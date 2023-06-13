
create or alter procedure Sales.ServiceReturn (@HeaderId int,
											   @ServicePrice smallmoney)
as
begin
	begin try
	begin tran

		--- Create table and insert into values from order
		declare @ServiceOrder table (BranchModelId int, Quantity tinyint)
				insert into @ServiceOrder select BranchModelId,Quantity from Sales.ServicePaymentDetail
										 where ServicePaymentHeaderId=@HeaderId

		--- Custom errors
		declare @error1 varchar(30)=convert(varchar,@Headerid)+' order is not exists!'
		declare @error2 varchar(25)=convert(varchar,@Headerid)+' order closed!'
		
		--- Validations
		if not exists (select ServicePaymentHeaderId from Sales.ServicePaymentHeader
					   where ServicePaymentHeaderId=@HeaderId)
			begin
				raiserror (@error1,11,0)
				rollback tran
				return -1
			end
		if exists (select ServicePaymentHeaderId from Sales.ServicePaymentHeader
				   where ShippedDate is not null and ServicePaymentHeaderId=@HeaderId)
			begin
				raiserror (@error2,11,0)
				rollback tran
				return -1
			end

		else
			begin
				--- Set ReturnDate as current date when customer return bike
				update Sales.ServicePaymentHeader
				set ReturnDate=GETDATE()
				where ServicePaymentHeaderId=@HeaderId

				--- Set ServicePrice from service
				update Sales.ServicePaymentDetail
				set ServicePrice=@ServicePrice
				where ServicePaymentHeaderId=@HeaderId

				--- Modify all available model quantity in branch
				update bm
				set bm.Quantity=bm.Quantity+o.Quantity
				from HumanResources.RT_Branch_Model bm
				join @ServiceOrder o on o.BranchModelId=bm.BranchModelId
				where o.BranchModelId=bm.BranchModelId

				--- Modify all model's rental quantity in main model's table
				update m
				set m.ServiceQuantity=m.ServiceQuantity-o.Quantity
				from Product.Model m
				join HumanResources.RT_Branch_Model bm on bm.ModelId=m.ModelId
				join @ServiceOrder o on o.BranchModelId=bm.BranchModelId
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