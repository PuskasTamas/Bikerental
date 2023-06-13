
create or alter procedure Sales.RentalReturn (@HeaderId int)
as
begin
	begin try
	begin tran

		--- Create table and insert into values from order
		declare @RentalOrder table (BranchModelId int, Quantity tinyint)
			insert into @RentalOrder
			select BranchModelId,Quantity from Sales.RentalPaymentDetail
			where RentalPaymentHeaderId=@HeaderId

		--- Custom errors
		declare @error1 varchar(50)=convert(varchar,@Headerid)+' order is not exists!'
		declare @error2 varchar(50)=convert(varchar,@Headerid)+' order closed!'
		
		--- Validations
		if not exists (select RentalPaymentHeaderId from Sales.RentalPaymentHeader
					   where RentalPaymentHeaderId=@HeaderId)
			begin
				raiserror (@error1,11,0)
				rollback tran
				return -1
			end
		if exists (select RentalPaymentHeaderId from Sales.RentalPaymentHeader
				   where ShippedDate is not null and RentalPaymentHeaderId=@HeaderId)
			begin
				raiserror (@error2,11,0)
				rollback tran
				return -1
			end

		else
			begin
				--- Set ReturnDate as current date when customer return bike
				update Sales.RentalPaymentHeader
				set ReturnDate=GETDATE()
				where RentalPaymentHeaderId=@HeaderId

				--- Modify all available model quantity in branch
				update bm
				set bm.Quantity=bm.Quantity+o.Quantity
				from HumanResources.RT_Branch_Model bm
				join @RentalOrder o on o.BranchModelId=bm.BranchModelId
				where o.BranchModelId=bm.BranchModelId

				--- Modify all model's rental quantity in main model's table
				update m
				set m.RentalQuantity=m.RentalQuantity-o.Quantity
				from Product.Model m
				join HumanResources.RT_Branch_Model bm on bm.ModelId=m.ModelId
				join @RentalOrder o on o.BranchModelId=bm.BranchModelId
				where bm.ModelId=m.ModelId

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