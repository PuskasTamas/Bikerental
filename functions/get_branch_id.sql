USE BikeRental
GO

CREATE OR ALTER FUNCTION Sales.GetBranchId (@BranchName varchar(50))
RETURNS int
AS
BEGIN
	DECLARE @result int

	--- Remove unnecessary whitespaces
	SET @BranchName=TRIM(@BranchName)

	--- Validates
	IF EXISTS (SELECT BranchId FROM HumanResources.Branch WHERE Name=@BranchName)
					BEGIN
						SELECT @result=BranchId FROM HumanResources.Branch WHERE Name=@BranchName
					END
				ELSE
					BEGIN
						RETURN -1
					END
	RETURN @result
END
GO