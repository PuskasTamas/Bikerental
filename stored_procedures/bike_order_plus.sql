
create or alter procedure Sales.BikeOrderPlus (@Header int,
											   @ModelName varchar(100),
											   @Quantity tinyint)
as
begin
	begin try
	begin tran
		declare @ModelId int

		--- Remove unnecessary whitespaces
		set @ModelName=TRIM(@ModelName)

		--- Call function (ID from name)
		select @ModelId=Sales.GetModelId (@ModelName)

		--- Extract necessary additional ID's from inputs
		declare @Employee int=(select EmployeeId from Sales.BikeOrderHeader
							   where BikeOrderHeaderId=@Header)
		declare @Branch int=(select b.BranchId from HumanResources.Branch b
							 join HumanResources.Employee e on e.BranchId=b.BranchId
							 where EmployeeId=@Employee)
		declare @BranchModel int=(select BranchModelId from HumanResources.RT_Branch_Model
								  where ModelId=@ModelId and BranchId=@Branch)
		declare @Price smallmoney=(select PurchasePrice from Product.Model
								   where ModelId=@ModelId)

		--- Create table and insert into values
		--- to avoid order bike from another manufacture in same order
		declare @Manufacture table (ManufactureId int, Allmodel int, BranchModel int)
				insert into @Manufacture select ma.ManufactureId, mo.ModelId Allmodel, bm.ModelId BranchModel from Product.Manufacture ma
												join Product.Brand b on b.ManufactureId=ma.ManufactureId
												join Product.Model mo on mo.BrandId=b.BrandId
												join HumanResources.RT_Branch_Model bm on bm.ModelId=mo.ModelId

		--- Dynamic SQL for use print list order details
		declare @OrderList varchar(500)='select BikeOrderHeaderId HeaderId,
												(select name from product.model p 
												 join HumanResources.RT_Branch_Model bm on bm.modelid=p.modelid
												 join Sales.BikeOrderDetail d on d.branchmodelid=bm.branchmodelid
												 where p.modelid=bm.modelid) ModelName,
												Quantity from Sales.BikeOrderDetail
												where BikeOrderHeaderId=@HeaderId'
		
		--- Custom errors
		declare @error1 varchar(150)=@ModelName+' model name is not available in this branch!'
		declare @error2 varchar(50)=convert(varchar,@Header)+' order is closed!'
		declare @error3 varchar(150)=@ModelName+' model name belongs to another manufacturer!'

		--- Validations
		if @BranchModel is null
			begin
				raiserror(@error1,11,0)
				rollback tran
				return -1
			end
		if (select OrderDate from Sales.BikeOrderHeader
			where BikeOrderHeaderId=@Header)<GETDATE()
				begin
					raiserror(@error2,11,0)
					rollback tran
					return -1
				end
		if	(select ManufactureId from @Manufacture where BranchModel=@BranchModel)
			 !=
			(select ManufactureId from @Manufacture where AllModel=@ModelId)
				begin
					raiserror(@error3,11,0)
					rollback tran
					return -1
				end

		else
			begin
				--- Add order details
				insert into Sales.BikeOrderDetail (BikeOrderHeaderId,BranchModelId,Quantity,PurchasePrice)
				values (@Header,@BranchModel,@Quantity,@Price)

				--- List all items from this order
				exec @OrderList

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
