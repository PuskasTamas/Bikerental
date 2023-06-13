use BikeRental
go

create or alter procedure Sales.BikeOrder (@EmployeeName varchar(180),
										   @ModelName varchar(100),
										   @Quantity tinyint)
as
begin
	begin try
	begin tran
		declare @EmployeeId int
		declare @ModelId int
		declare @Header int

		--- Remove unnecessary whitespaces
		set @EmployeeName=TRIM(@EmployeeName)
		set @ModelName=TRIM(@ModelName)

		--- Call functions (ID's from names)
		select @EmployeeId=Sales.GetEmployeeId (@EmployeeName)
		select @ModelId=Sales.GetModelId (@ModelName)

		--- Extract necessary additional ID's from inputs
		declare @Branch int=(select b.BranchId from HumanResources.Branch b
							 join HumanResources.Employee e on e.BranchId=b.BranchId
							 where EmployeeId=@EmployeeId)
		declare @BranchModel int=(select BranchModelId from HumanResources.RT_Branch_Model
								  where ModelId=@ModelId and BranchId=@Branch)
		declare @Price smallmoney=(select PurchasePrice from Product.Model
								   where ModelId=@ModelId)
		
		--- Custom errors
		declare @error1 varchar(220)=@EmployeeName+' employee name is not exists!'
		declare @error2 varchar(150)=@ModelName+' model name is not available in this branch!'

		--- Validations
		if not exists (select EmployeeId from HumanResources.Employee
					   where EmployeeId=@EmployeeId
					   union
					   select EmployeeId from HumanResources.Employee
					   where EmployeeId=@EmployeeId and ExitDate is null)
			begin
				raiserror(@error1,11,0)
				rollback tran
				return -1
			end
		if @BranchModel is null
			begin
				raiserror(@error2,11,0)
				rollback tran
				return -1
			end

		else
			begin
				--- Add new order ID
				insert into Sales.BikeOrderHeader (EmployeeId) values (@EmployeeId)

				--- Select new order ID
				set @Header=(select MAX(BikeOrderHeaderId) from Sales.BikeOrderHeader)

				--- Add order details
				insert into Sales.BikeOrderDetail (BikeOrderHeaderId,BranchModelId,Quantity,PurchasePrice)
				values (@Header,@BranchModel,@Quantity,@Price)

				print 'The last order id: '+convert(varchar,@Header)

				commit tran
				return
			end
	end try
	begin catch
		if @@TRANCOUNT>0
		rollback
	end catch
end
go
