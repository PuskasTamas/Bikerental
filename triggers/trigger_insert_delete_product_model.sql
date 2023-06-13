use tempdb
go

IF OBJECT_ID('dbo.BikeRentalModelInsertDelete', 'U') IS NULL
create table dbo.BikeRentalModelInsertDelete (ModelId int, BrandId smallint, Name varchar(50), ChangeDate datetime, Operation char(6), UserName varchar(50))
go

use BikeRental
go

drop trigger if exists Product.ModelInsertDelete
go

create trigger ModelInsertDelete
on Product.Model
for insert,delete
as
begin
	set nocount on

	insert into dbo.BBikeRentalModelInsertDelete
	select ModelId,BrandId,Name,GETDATE(),'INSERT', SUSER_NAME() from inserted i
	union all
	select ModelId,BrandId,Name,GETDATE(),'DELETE', suser_name() from deleted d
end
go
