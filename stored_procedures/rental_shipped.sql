
create or alter procedure Sales.RentalShipped (@HeaderId int)
as
begin
	begin try
	begin tran

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
				--- Set ShippedDate as current date when customer ship bike
				update Sales.RentalPaymentHeader
				set ShippedDate=GETDATE()
				where RentalPaymentHeaderId=@HeaderId

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