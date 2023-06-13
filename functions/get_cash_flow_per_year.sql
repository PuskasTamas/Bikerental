
drop function if exists Sales.CashFlow
go

create function Sales.CashFlow (@BranchName varchar(50), @Year smallint, @Month tinyint=null)
returns money
begin
	declare @result smallmoney
	declare @BranchId int

	--- Remove unnecessary whitespaces
	set @BranchName=TRIM(@BranchName)

	--- Call function to get Id from BranchName
	select @BranchId=Sales.GetBranchId (@BranchName)

	declare @BranchFilter int=(select BranchId from HumanResources.Branch where BranchId=@BranchId)

	--- Validations
	if @BranchId=-1
		return -1
	if @BranchFilter is null
		return -1
	if @Year not between 2022 and YEAR(GETDATE())
		return -1

	if @Month is null
		begin
			--- Just year
			select @result= Sales.RentalOrderSumByBranch(@BranchId,@Year,null)
							-(Sales.ServiceOrderSumByBranch(@BranchId,@Year,null)+Sales.BikeOrderSumByBranch(@BranchId,@Year,null))
		end
	if @Month not between 1 and 12
		return -1
	else
	begin
		--- Year and month
		select @result= Sales.RentalOrderSumByBranch(@BranchId,@Year,@Month)
						-(Sales.ServiceOrderSumByBranch(@BranchId,@Year,@Month)+Sales.BikeOrderSumByBranch(@BranchId,@Year,@Month))
	end
return @result
end
go