
create or alter procedure Sales.RentalOrder (@EmployeeName varchar(180),
											 @CustomerName varchar(180),
											 @ModelName varchar(100),
											 @Quantity tinyint)
as
begin
	begin try
	begin tran
		declare @EmployeeId int
		declare @ModelId int
		declare @CustomerId int
		declare @Header int

		--- Remove unnecessary whitespaces
		set @EmployeeName=TRIM(@EmployeeName)
		set @CustomerName=TRIM(@CustomerName)
		set @ModelName=TRIM(@ModelName)

		--- Call functions (ID's from names)
		select @EmployeeId=Sales.GetEmployeeId (@EmployeeName)
		select @ModelId=Sales.GetModelId (@ModelName)
		select @CustomerId=Sales.GetCustomerId (@CustomerName)

		--- Extract necessary additional ID's from inputs
		declare @Branch int=(select b.BranchId from HumanResources.Branch b
							 join HumanResources.Employee e on e.BranchId=b.BranchId
							 where EmployeeId=@EmployeeId)
		declare @BranchModel int=(select BranchModelId from HumanResources.RT_Branch_Model
								  where ModelId=@ModelId and BranchId=@Branch)
		declare @Price smallmoney=(select RentalPrice from Product.Model
								   where ModelId=@ModelId)
		declare @Model int=(select ModelId from HumanResources.RT_Branch_Model
							where BranchModelId=@BranchModel)
		
		--- Custom errors
		declare @error1 varchar(220)=@CustomerName+' customer name is not exists!'
		declare @error2 varchar(220)=@EmployeeName+' employee name is not exists!'
		declare @error3 varchar(150)=@ModelName+' model name is not exists in this Branch!'
		declare @error4 varchar(150)=@Modelname+' model name quantity is 0!'

		--- Validations
		if not exists (select CustomerId from Sales.Customer
					   where CustomerId=@CustomerId
					   union
					   select CustomerId from Sales.Customer
					   where CustomerId=@CustomerId and ExitDate is null)
			begin
				raiserror(@error1,11,0)
				rollback tran
				return -1
			end
		if not exists (select EmployeeId from HumanResources.Employee
					   where EmployeeId=@EmployeeId
					   union
					   select EmployeeId from HumanResources.Employee
					   where EmployeeId=@EmployeeId and ExitDate is null)
			begin
				raiserror(@error2,11,0)
				rollback tran
				return -1
			end
		if @BranchModel is null
			begin
				raiserror(@error3,11,0)
				rollback tran
				return -1
			end
		if exists (select BranchModelId from HumanResources.RT_Branch_Model
				   where ModelId=@ModelId and BranchId=@Branch and Quantity=0)
			begin
				raiserror(@error4,11,0)
				rollback tran
				return -1
			end

		else
			begin
				--- Add new order ID
				insert into Sales.RentalPaymentHeader(EmployeeId,CustomerId) values (@EmployeeId,@CustomerId)

				--- Select new order ID
				set @Header=(select MAX(RentalPaymentHeaderId) from Sales.RentalPaymentHeader)

				--- Add order details
				insert into Sales.RentalPaymentDetail(RentalPaymentHeaderId,BranchModelId,Quantity,RentalPrice)
				values (@Header,@BranchModel,@Quantity,@Price)

				--- Modify available model quantity in branch
				update HumanResources.RT_Branch_Model
				set Quantity=Quantity-@Quantity
				where ModelId=@Model

				--- Modify model's rental quantity in main model's table
				update Product.Model
				set RentalQuantity=RentalQuantity+@Quantity
				where ModelId=@ModelId

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

