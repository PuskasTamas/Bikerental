
create or alter function Sales.GetServiceId (@ServiceName varchar(50))
returns int
as
begin
	declare @result int

	--- Remove unnecessary whitespaces
	set @ServiceName=TRIM(@ServiceName)

	--- Validates
	If exists (select ServiceId from Sales.Service where Name=@ServiceName)
					begin
						select @result=ServiceId from Sales.Service where Name=@ServiceName
					end
				else
					begin
						return -1
					end
	return @result
end
go
