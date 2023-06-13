use BikeRental
go

if object_id('BranchModelInfo','v') is not null
drop view BranchModelInfo;
go

create view BranchModelInfo
as
with branchmodel (branchmodelid,branchid,productid,[Available Quantity]) as
(
	select  branchmodelid,
			BranchId,
			ModelId,
			quantity		
	from HumanResources.RT_Branch_Model
),
branch (branchid,[Branch Name]) as
(
	select BranchId,name from HumanResources.Branch
),
model (modelid,[Model Name]) as
(
	select modelid, name from Product.Model
),
service (branchmodelid,[Service Quantity])as
(
	select BranchModelId,
			sum(Quantity)
	from Sales.ServicePaymentDetail
	group by branchmodelid
),
rental (branchmodelid,[Rental Quantity]) as
(
	select BranchModelId,
			SUM(Quantity)
	from Sales.RentalPaymentDetail
	group by BranchModelId
)
select bm.branchmodelid,b.[Branch Name],m.[Model Name],bm.[Available Quantity],s.[Service Quantity],r.[Rental Quantity] from branchmodel bm
left join service s on s.BranchModelId=bm.branchmodelid
left join rental r on r.branchmodelid=bm.branchmodelid
join branch b on b.branchid=bm.branchid
join model m on m.modelid=bm.productid
go
