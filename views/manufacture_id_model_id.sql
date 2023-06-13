
if object_id('ManufactureIdModelId','v') is not null
drop view ManufactureIdModelId;
go

create view ManufactureIdModelId
as
with model (modelid,brandid,[Model Name])as
(
	select modelid,brandid,name from product.model
),
brand (brandid,manufactureid,[Brand Name]) as
(
	select brandid,manufactureid,name from product.brand
),
manufacture (manufactureid,[Manufacture Name]) as
(
	select ManufactureId, Name from Product.Manufacture
)
select [Model Name],[Manufacture Name],[Brand Name]
from model m
join brand b on b.brandid=m.brandid
join manufacture ma on ma.manufactureid=b.manufactureid
go
