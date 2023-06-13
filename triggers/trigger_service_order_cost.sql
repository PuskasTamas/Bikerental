
drop trigger if exists Sales.ServiceOrderCost
go

create trigger ServiceOrderCost
on Sales.ServicePaymentDetail
for insert,update
as
begin
	declare @Header int=(select ServicePaymentHeaderId from inserted)
	declare @Cost smallmoney=(select TotalPrice from inserted)
							
	update Sales.ServicePaymentHeader
	set OrderCost=OrderCost+@Cost
	where ServicePaymentHeaderId=@Header
end
go