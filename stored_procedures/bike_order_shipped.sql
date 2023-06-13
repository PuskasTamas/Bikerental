
create or alter procedure Sales.BikeOrderShipped (@HeaderId int)
as
begin
	begin try
	begin tran

		--- Create table and insert into values from order
		declare @BikeOrder table (BranchModelId int, Quantity tinyint)
				insert into @BikeOrder select BranchModelId,Quantity from Sales.BikeOrderDetail
										where BikeOrderHeaderId=@HeaderId

		--- Custom errors
		declare @error1 varchar(50)=convert(varchar,@Headerid)+' order is not exists!'
		declare @error2 varchar(50)=convert(varchar,@Headerid)+' order closed!'
		
		--- Validations
		if not exists (select BikeOrderHeaderId from Sales.BikeOrderHeader
					   where BikeOrderHeaderId=@HeaderId)
			begin
				raiserror(@error1,11,0)
				rollback tran
				return -1
			end
		if exists (select BikeOrderHeaderId from Sales.BikeOrderHeader
				   where ShippedDate is not null and BikeOrderHeaderId=@HeaderId)
			begin
				raiserror(@error2,11,0)
				rollback tran
				return -1
			end

		else
			begin
				--- Set ShippedDate as current date when manufacture ship bike
				update Sales.BikeOrderHeader
				set ShippedDate=GETDATE()
				where BikeOrderHeaderId=@HeaderId

				--- Modify all available model quantity in branch
				update bm
				set bm.Quantity=bm.Quantity+o.Quantity
				from HumanResources.RT_Branch_Model bm
				join @BikeOrder o on o.BranchModelId=bm.BranchModelId
				where o.BranchModelId=bm.BranchModelId

				--- Modify all model's rental quantity in main model's table
				update m
				set m.TotalQuantity=m.TotalQuantity+o.Quantity
				from Product.Model m
				join HumanResources.RT_Branch_Model bm on bm.ModelId=m.ModelId
				join @BikeOrder o on o.BranchModelId=bm.BranchModelId
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