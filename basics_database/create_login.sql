USE master
GO

-- Logins
IF SUSER_ID ('Bikerental') IS NULL
    CREATE LOGIN Bikerental WITH PASSWORD='Bikerental', DEFAULT_DATABASE=BikeRental
GO
GRANT CONNECT SQL to Bikerental WITH GRANT OPTION
GO
IF SUSER_ID ('Admins') IS NULL
    CREATE LOGIN Admins WITH PASSWORD='Admins', DEFAULT_DATABASE=BikeRental
GO
GRANT CONNECT SQL to Admins WITH GRANT OPTION
GO
IF SUSER_ID ('Securities') IS NULL
    CREATE LOGIN Securities WITH PASSWORD='Securities', DEFAULT_DATABASE=BikeRental
GO
GRANT CONNECT SQL to Securities WITH GRANT OPTION
GO
IF SUSER_ID ('EmployeeTheo') IS NULL
    CREATE LOGIN EmployeeTheo WITH PASSWORD='EmployeeTheo', DEFAULT_DATABASE=BikeRental
GO
GRANT CONNECT SQL to EmployeeTheo
GO
IF SUSER_ID ('EmployeeKai') IS NULL
    CREATE LOGIN EmployeeKai WITH PASSWORD='EmployeeKai', DEFAULT_DATABASE=BikeRental
GO
GRANT CONNECT SQL to EmployeeKai
GO

--System users
USE BikeRental
GO
IF USER_ID('Bikerental') IS NULL
BEGIN
    CREATE USER Bikerental FOR LOGIN Bikerental
END
GO
ALTER ROLE db_owner ADD MEMBER Bikerental
GO
IF USER_ID('Admins') IS NULL
BEGIN
    CREATE USER Admins FOR LOGIN Admins
END
GO
ALTER ROLE db_ddladmin ADD MEMBER Admins
GO
IF USER_ID('Securities') IS NULL
BEGIN
    CREATE USER Securities FOR LOGIN Securities
END
GO
ALTER ROLE db_securityadmin ADD MEMBER Securities
GO

--Employee users
IF USER_ID('TheoBurtMurray') IS NULL
BEGIN
    CREATE USER TheoBurtMurray FOR LOGIN EmployeeTheo
END
GO
IF USER_ID('KaiBell') IS NULL
BEGIN
    CREATE USER KaiBell FOR LOGIN EmployeeKai
END
GO

--Role for all employees
IF DATABASE_PRINCIPAL_ID('Employee') IS NULL
CREATE role Employee
GO
ALTER ROLE Employee ADD MEMBER TheoBurtMurray
GO
ALTER ROLE Employee ADD MEMBER KaiBell
GO
GRANT EXECUTE,SELECT TO Employee
GO

--Application role
IF DATABASE_PRINCIPAL_ID('Appreader') IS NULL
CREATE APPLICATION ROLE AppReader WITH DEFAULT_SCHEMA=Sales, PASSWORD='AppReader'
GO
ALTER AUTHORIZATION ON SCHEMA::db_datareader TO AppReader
GO
GRANT SELECT TO Appreader
GO