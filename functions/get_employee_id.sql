
create or alter function Sales.GetEmployeeId (@EmployeeName varchar(180))
returns int
as
begin
	--- Remove unnecessary whitespaces
	set @EmployeeName=TRIM(@EmployeeName)

	--- Calculates how many parts name consists of
	declare @CountPartsOfName tinyint=(select LEN(@EmployeeName) - LEN(REPLACE(@EmployeeName,' ','')) + 1)
	declare @result int
	declare @Title varchar(10)
	declare @First varchar(50)
	declare @Middle varchar(50)
	declare @Last varchar(50)
	declare @4name int
	declare @3name int
	declare @2name int

	--- Split fullname by number parts name
	--- and validates
	if @CountPartsOfName=4
		begin
			set @Title=(select PARSENAME(replace(@EmployeeName,' ','.'),4))
			set @First=(select PARSENAME(replace(@EmployeeName,' ','.'),3))
			set @Middle=(select PARSENAME(replace(@EmployeeName,' ','.'),2))
			set @Last=(select PARSENAME(replace(@EmployeeName,' ','.'),1))
			set @4name=(select e.EmployeeId from HumanResources.Employee e
						join Person.Person p on p.PersonId=e.EmployeeId
						where p.Title=@Title and p.FirstName=@First and p.MiddleName=@Middle and p.LastName=@Last)
			if @4name is not null
				begin
					set @result=@4name
				end
			else
				begin
					return -1
				end
		end

	if @CountPartsOfName=3
		begin
			set @First=(select PARSENAME(replace(@EmployeeName,' ','.'),3))
			set @Middle=(select PARSENAME(replace(@EmployeeName,' ','.'),2))
			set @Last=(select PARSENAME(replace(@EmployeeName,' ','.'),1))
			set @3name=(select e.EmployeeId from HumanResources.Employee e
					   join Person.Person p on p.PersonId=e.EmployeeId
					   where (p.FirstName=@First and p.MiddleName=@Middle and p.LastName=@Last)
							 or
							 (p.Title=@First and p.FirstName=@Middle and p.LastName=@Last)
					   )
			if @3name is not null
				begin
					set @result=@3name
				end
			else
				begin
					return -1
				end
		end

	If @CountPartsOfName=2
		begin
			set @First=(select PARSENAME(replace(@EmployeeName,' ','.'),2))
			set @Last=(select PARSENAME(replace(@EmployeeName,' ','.'),1))
			set @2name=(select e.EmployeeId from HumanResources.Employee e
					   join Person.Person p on p.PersonId=e.EmployeeId
					   where p.FirstName=@First and p.LastName=@Last)
			if @2name is not null
				begin
					set @result=@2name
				end
			else
				begin
					return -1
				end
		end

	if @CountPartsOfName <=1
		return -1
	
	return @result
end
go
