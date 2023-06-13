
create or alter procedure Sales.RentalOrderPlus (@HeaderId int,
												 @ModelName varchar(100),
												 @Quantity tinyint)
as
begin
	begin try
	begin tran
		declare @ModelId int

		-- Remove unnecessary whitespaces
		set @ModelName=TRIM(@ModelName)

		--- Call function (ID from name)
		select @ModelId=Sales.GetModelId (@ModelName)

		--- Extract necessary additional ID's from inputs
		declare @Employee int=(select EmployeeId from Sales.RentalPaymentHeader
							   where RentalPaymentHeaderId=@HeaderId)
		declare @Branch int=(select b.BranchId from HumanResources.Branch b
							 join HumanResources.Employee e on e.BranchId=b.BranchId
							 where EmployeeId=@Employee)
		declare @BranchModel int=(select BranchModelId from HumanResources.RT_Branch_Model
								  where ModelId=@ModelId and BranchId=@Branch)
		declare @Model int=(select ModelId from HumanResources.RT_Branch_Model
							where BranchModelId=@BranchModel)

		--- Dynamic SQL for use print list order details
		declare @OrderList varchar(500)='select RentalPaymentHeaderId HeaderId,
												(select name from product.model p 
												 join HumanResources.RT_Branch_Model bm on bm.modelid=p.modelid
												 join Sales.RentalPaymentDetail d on d.branchmodelid=bm.branchmodelid
												 where p.modelid=bm.modelid) ModelName,
												Quantity from Sales.RentalPaymentDetail
												where RentalPaymentHeaderId=@HeaderId'

		--- Custom errors
		declare @error1 varchar(50)=convert(varchar,@Headerid)+' HeaderId is not exists!'
		declare @error2 varchar(150)=@ModelName+' model name is not exists in this Branch!'
		declare @error3 varchar(50)=convert(varchar,@Headerid)+' order is closed!'
		declare @error4 varchar(150)=@ModelName+' model name quantity is 0!'

		--- Validations	
		if not exists (select RentalPaymentHeaderId from Sales.RentalPaymentHeader
					   where RentalPaymentHeaderId=@HeaderId)
			begin
				raiserror (@error1,11,0)
				rollback tran
				return -1
			end
		if @BranchModel is null
			begin
				raiserror (@error2,11,0)
				rollback tran
				return -1
			end
		if (select OrderDate from Sales.RentalPaymentHeader
			where RentalPaymentHeaderId=@HeaderId)<GETDATE()
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
				--- Add order details
				insert into Sales.RentalPaymentDetail (RentalPaymentHeaderId,BranchModelId,Quantity)
				values (@HeaderId,@BranchModel,@Quantity)

				--- Modify available model quantity in branch
				update HumanResources.RT_Branch_Model
				set Quantity=Quantity-@Quantity
				where ModelId=@Model

				--- Modify model's rental quantity in main model's table
				update Product.Model
				set RentalQuantity=RentalQuantity+@Quantity
				where ModelId=@ModelId

				--- List all items from this order
				exec @OrderList

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
