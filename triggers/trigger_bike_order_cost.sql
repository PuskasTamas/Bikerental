use BikeRental
go

drop trigger if exists Sales.BikeOrderCost
go

create trigger BikeOrderCost
on Sales.BikeOrderDetail
for insert,update
as
begin
	declare @Header smallint=(select BikeOrderHeaderId from inserted)
	declare @Cost smallmoney=(select TotalPrice from inserted)
							 
	update Sales.BikeOrderHeader
	set OrderCost=OrderCost+@Cost
	where BikeOrderHeaderId=@Header
end
go