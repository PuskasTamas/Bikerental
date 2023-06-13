
drop function if exists Sales.RentalOrderSumByBranch
go

create function Sales.RentalOrderSumByBranch (@BranchName varchar(50), @Year smallint, @Month tinyint=null)
returns money
as
begin
	declare @result smallmoney
	declare @BranchId int

	--- Remove unnecessary whitespaces
	set @BranchName=TRIM(@BranchName)

	--- Call function to get Id from BranchName
	select @BranchId=Sales.GetBranchId (@BranchName)

	declare @BranchFilter int=(select BikeOrderHeaderId from Sales.BikeOrderDetail o
							   join HumanResources.RT_Branch_Model bm on bm.branchmodelid=o.branchmodelid
							   where bm.BranchId=@BranchId)

	--- Set manually date intervallum values to WHERE clause instead of YEAR(OrderDate)
	--- to decrease query cost
	declare @YearStart varchar(10)=CONVERT(varchar,@Year)+'-01-01'
	set @YearStart=CONVERT(date,@YearStart)
	declare @YearEnd varchar(10)=CONVERT(varchar,@Year)+'-12-31'
	set @YearEnd=CONVERT(date,@YearEnd)
	declare @YearMonthStart varchar(10)=convert(varchar,@Year)+'-'+convert(varchar,@Month)+'-01'
	set @YearMonthStart=CONVERT(date,@YearMonthStart)
	declare @YearMonthEnd varchar(10)=convert(varchar,@Year)+'-'+convert(varchar,@Month)+'-31'
	set @YearMonthEnd=CONVERT(date,@YearMonthEnd)
	
	--- Validates
	if @BranchId=-1
		return -1
	if @BranchFilter is null
		return -1
	if @Year not between 2022 and YEAR(GETDATE())
		return -1
	if @Month is null
		begin
			--- Just year
			select @result= sum(OrderCost) from Sales.RentalPaymentHeader
							where OrderDate between @YearStart and @YearEnd
								  and RentalPaymentHeaderId=@BranchFilter
		end
	if @Month not between 1 and 12
			return -1
	else
		--- Year and month
		select @result= sum(OrderCost) from Sales.RentalPaymentHeader
						where OrderDate between @YearMonthStart and @YearMonthEnd
							  and RentalPaymentHeaderId=@BranchFilter
	return @result	
end
go