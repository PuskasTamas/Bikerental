
if object_id('EmployeeInfo','v') is not null
drop view EmployeeInfo;
go

create view EmployeeInfo
as
with Person1 (PersonId,Title,[Full Name],Gender,Age)as 
(
	select  p.PersonId,
			isnull(p.Title,'---'),
			replace(CONCAT_WS(' ',p.FirstName,p.MiddleName,p.LastName),'  ',' '),
			case p.Gender when 'M' then 'Male' when 'F' then 'Female' end Gender,
			p.Age
	from person.person p
	join Person.PersonType t on t.PersonTypeId=p.PersonTypeId
	where t.PersonTypeId=1
),
Address1 (PersonId, [Full Address])as
(	
	select  pa.PersonId,
			replace(CONCAT_WS(', ',a.AddressLine,a.City,a.County,a.PostalCode),'  ',' ')
	from Person.Address a
	join Person.AddressType t on t.AddressTypeId=a.AddressTypeId
	join Person.RT_Person_Address pa on a.AddressId=pa.AddressId
	where t.AddressTypeId=3
),
Phone1 (PersonId, [Phone Number],[Phone Type])as
(
	select  p.PersonId,
			p.PhoneNumber,
			t.Name
	from Person.Phone p
	join Person.PhoneType t on t.PhoneTypeId=p.PhoneTypeId
	where t.PhoneTypeId=2
),
Email1 (PersonId, [Email Address], [Email Type])as
(
	select	e.PersonId,
			e.EmailAddress,
			t.Name
	from Person.Email e
	join Person.EmailType t on t.EmailTypeId=e.EmailTypeId
	where t.EmailTypeId=2
),
Branch1 (PersonId, [Branch Name]) as
(
	select	e.personId,
			b.Name
	from HumanResources.Branch b
	join HumanResources.Employee e on e.BranchId=b.BranchId
)
select p.PersonId,Title,[Full Name],Gender,Age,[Branch Name] ,[Full Address],[Phone Number],[Phone Type],[Email Address],[Email Type] 
		from Person1 p
		join Address1 a on a.PersonId=p.PersonId
		join Phone1 ph on ph.PersonId=p.PersonId
		join Email1 e on e.PersonId=p.PersonId
		join Branch1 b on b.PersonId=p.PersonId
go
