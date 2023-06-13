
create or alter function Sales.GetModelId (@ModelName varchar(100))
returns int
as
begin
	declare @result int

	--- Remove unnecessary whitespaces
	set @ModelName=TRIM(@ModelName)

	--- Validates
	if exists (select ModelId from Product.Model where Name=@ModelName)
		begin
			select @result=ModelId from Product.Model where Name=@ModelName
		end
	else
		begin
			return -1
		end
	
	return @result
end
go