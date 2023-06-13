use BikeRental
go

drop trigger if exists Sales.RentalOrderCost
go

create trigger RentalOrderCost
on Sales.RentalPaymentDetail
for insert,update
as
begin
	declare @Header int=(select RentalPaymentHeaderId from inserted)
	declare @Cost smallmoney=(select TotalPrice from inserted)
							 
	update Sales.RentalPaymentHeader
	set OrderCost=OrderCost+@Cost
	where RentalPaymentHeaderId=@Header
end
go