
create or alter procedure Sales.ServiceOrder (@EmployeeName varchar(180),
											  @ServiceName varchar(50),
											  @ModelName varchar(100),
											  @Quantity tinyint,
											  @Reason varchar(100))
as
begin
	begin try
	begin tran
		declare @EmployeeId int
		declare @ModelId int
		declare @ServiceId int

		--- Remove unnecessary whitespaces
		set @EmployeeName=TRIM(@EmployeeName)
		set @ServiceName=TRIM(@ServiceName)
		set @ModelName=TRIM(@ModelName)
		set @Reason=TRIM(@Reason)

		--- Call functions (ID's from names)
		select @EmployeeId=Sales.GetEmployeeId (@EmployeeName)
		select @ModelId=Sales.GetModelId (@ModelName)
		select @ServiceId=Sales.GetServiceId (@ServiceName)

		--- Extract necessary additional ID's from inputs
		declare @Branch int=(select b.BranchId from HumanResources.Branch b
							 join HumanResources.Employee e on e.BranchId=b.BranchId
							 where EmployeeId=@EmployeeId)
		declare @BranchModel int=(select BranchModelId from HumanResources.RT_Branch_Model
								  where ModelId=@ModelId and BranchId=@Branch)
		declare @Model int=(select ModelId from HumanResources.RT_Branch_Model
							where BranchModelId=@BranchModel)

		--- Custom errors
		declare @error1 varchar(80)=@ServiceName+' service name is not exists!'
		declare @error2 varchar(220)=@EmployeeName+' employee name is not exists!'
		declare @error3 varchar(150)=@ModelName+' model name is not exists in this Branch!'
		declare @error4 varchar(150)=@ModelName+' model name quantity is 0!'
		
		--- Validations
		if not exists (select ServiceId from Sales.Service
					   where ServiceId=@ServiceId
					   union
					   select ServiceId from Sales.Service
					   where ServiceId=@ServiceId and ExitDate is null)
			begin
				raiserror (@error1,11,0)
				rollback tran
				return -1
			end
		if not exists (select EmployeeId from HumanResources.Employee
					   where EmployeeId=@EmployeeId
					   union
					   select EmployeeId from HumanResources.Employee
					   where EmployeeId=@EmployeeId and ExitDate is null)
			begin
				raiserror (@error2,11,0)
				rollback tran
				return -1
			end
		if @BranchModel is null
			begin
				raiserror (@error3,11,0)
				rollback tran
				return -1
			end
		if exists (select BranchModelId from HumanResources.RT_Branch_Model
					where ModelId=@ModelId and BranchId=@Branch and Quantity=0)
			begin
				raiserror (@error4,11,0)
				rollback tran
				return -1
			end

		else
			begin
				--- Add new order ID
				insert into Sales.ServicePaymentHeader(ServiceId,EmployeeId) values (@ServiceId,@EmployeeId)

				--- Select new order ID
				declare @Header int=(select MAX(ServicePaymentHeaderId) from Sales.ServicePaymentHeader)

				--- Add order details
				insert into Sales.ServicePaymentDetail(ServicePaymentHeaderId,BranchModelId,Quantity,ServiceReason)
				values (@Header,@BranchModel,@Quantity,@Reason)

				--- Modify available model quantity in branch
				update HumanResources.RT_Branch_Model
				set Quantity=Quantity-@Quantity
				where ModelId=@Model

				--- Modify model's rental quantity in main model's table
				update Product.Model
				set ServiceQuantity=ServiceQuantity+@Quantity
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

