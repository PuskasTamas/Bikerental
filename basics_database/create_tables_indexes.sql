USE BikeRental
GO

IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = N'Person')
EXEC('CREATE schema Person')
GO
IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = N'Product')
EXEC('CREATE schema Product')
GO
IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = N'HumanResources')
EXEC('CREATE schema HumanResources')
GO
IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = N'Sales')
EXEC('CREATE schema Sales')
GO
IF OBJECT_ID(N'Person.PersonType',N'U') IS NULL
CREATE TABLE Person.PersonType (PersonTypeId tinyint IDENTITY,
								Name varchar(50) NOT NULL,
								CONSTRAINT PK_PersonTypeId PRIMARY KEY(PersonTypeId),
								CONSTRAINT CHK_PersonType_Name CHECK (Name NOT IN ('%[^A-Za-z]%','%^ %')),
								CONSTRAINT UC_PersonType_Name UNIQUE (Name))
GO
IF OBJECT_ID(N'Person.Person',N'U') IS NULL
CREATE TABLE Person.Person (PersonId int IDENTITY,
							Title varchar(10),
							FirstName varchar(50) NOT NULL,
							MiddleName varchar(50),
							LastName varchar(50) NOT NULL,
							Gender char(1) NOT NULL,
							Age tinyint NOT NULL,
							PersonTypeId tinyint NOT NULL,
							CONSTRAINT PK_PersonId PRIMARY KEY(PersonId),
							CONSTRAINT FK_Person_PersonType FOREIGN KEY(PersonTypeId) REFERENCES Person.PersonType(PersonTypeId),
							CONSTRAINT CHK_Person_Gender CHECK (Gender IN('M','F')),
							CONSTRAINT CHK_Person_Age CHECK (Age BETWEEN 18 AND 100),
							CONSTRAINT CHK_Person_Firstname CHECK (FirstName NOT LIKE '%[^A-Za-z]%'),
							CONSTRAINT CHK_Person_LastName CHECK (LastName NOT LIKE '%[^A-Za-z]%'),
							CONSTRAINT CHK_Person_Title CHECK (Title NOT IN('%[^A-Za-z]%','^%.%') OR Title IS NULL),
							CONSTRAINT CHK_Person_Middlename CHECK (MiddleName NOT IN('%[^A-Za-z]%','^%.%') OR MiddleName IS NULL))
GO
IF OBJECT_ID(N'Person.PhoneType',N'U') IS NULL
CREATE TABLE Person.PhoneType (PhoneTypeId tinyint IDENTITY,
							   Name varchar(25) NOT NULL,
							   CONSTRAINT PK_PhoneType PRIMARY KEY(PhoneTypeId),
							   CONSTRAINT CHK_PhoneType_Name CHECK (Name NOT IN ('%[^A-Za-z]%','%^ %')),
							   CONSTRAINT UC_PhoneType_Name UNIQUE (Name))
GO
IF OBJECT_ID(N'Person.Phone',N'U') IS NULL
CREATE TABLE Person.Phone (PhoneId int IDENTITY,
						   PersonId int NOT NULL,
						   PhoneNumber varchar(25) NOT NULL,
						   PhoneTypeId tinyint NOT NULL,
						   CONSTRAINT PK_PhoneId PRIMARY KEY(PhoneId),
						   CONSTRAINT FK_Phone_PhoneType FOREIGN KEY(PhoneTypeId) REFERENCES Person.PhoneType(PhoneTypeId),
						   CONSTRAINT FK_Phone_Person FOREIGN KEY(PersonId) REFERENCES Person.Person(PersonId),
						   CONSTRAINT CHK_Phone_PhoneNumber CHECK(PhoneNumber NOT IN('%[^0-9]%','%^+%','%^ %','%^-%')))
GO
IF OBJECT_ID(N'Person.EmailType',N'U') IS NULL
CREATE TABLE Person.EmailType (EmailTypeId tinyint IDENTITY,
							   Name varchar(25) NOT NULL,
							   CONSTRAINT PK_EmailType PRIMARY KEY(EmailTypeId),
							   CONSTRAINT CHK_EmailType_Name CHECK (Name NOT IN ('%[^A-Za-z]%','%^ %')),
							   CONSTRAINT UC_EmailType_Name UNIQUE (Name))
GO
IF OBJECT_ID(N'Person.Email',N'U') IS NULL
CREATE TABLE Person.Email (EmailId int IDENTITY,
						   PersonId int NOT NULL,
						   EmailAddress varchar(100) NOT NULL,
						   EmailTypeId tinyint NOT NULL,
						   CONSTRAINT PK_EmailId PRIMARY KEY(EmailId),
						   CONSTRAINT FK_Email_Person FOREIGN KEY(PersonId) REFERENCES Person.Person(PersonId),
						   CONSTRAINT FK_Email_Type FOREIGN KEY(EmailTypeId) REFERENCES Person.EmailType(EmailTypeId),
						   CONSTRAINT CHK_Email_EmailAddress CHECK(EmailAddress NOT IN('%[^A-Za-z0-9]%','%^@%','%^.%')),
						   CONSTRAINT UC_Email_EmailAddress UNIQUE (EmailAddress))
GO
IF OBJECT_ID(N'Person.AddressType',N'U') IS NULL
CREATE TABLE Person.AddressType (AddressTypeId tinyint IDENTITY,
								 Name varchar(25) NOT NULL,
								 CONSTRAINT PK_AddressType PRIMARY KEY(AddressTypeId),
								 CONSTRAINT CHK_AddressType_Name CHECK (Name NOT IN ('%[^A-Za-z]%','%^ %')),
								 CONSTRAINT UC_AddressType_Name UNIQUE (Name))
GO
IF OBJECT_ID(N'Person.Address',N'U') IS NULL
CREATE TABLE Person.Address (AddressId int IDENTITY,
							 AddressLine varchar(100) NOT NULL,
							 City varchar(50) NOT NULL,
							 County varchar(50) NOT NULL,
							 PostalCode int NOT NULL,
							 AddressTypeId tinyint NOT NULL,
							 CONSTRAINT PK_AddressId PRIMARY KEY(AddressId),
							 CONSTRAINT FK_Address_AddressType FOREIGN KEY(AddressTypeId) REFERENCES Person.AddressType(AddressTypeId),
							 CONSTRAINT CHK_Address_CityCounty CHECK ( (City+'|'+County) NOT IN ('%[^A-Za-z]%','%^ %')),
							 CONSTRAINT CHK_Address_Line CHECK (AddressLine NOT IN ('%[^A-Za-z0-9]%','%^ %','%^.%')))
GO
IF OBJECT_ID(N'Product.Manufacture',N'U') IS NULL
CREATE TABLE Product.Manufacture (ManufactureId tinyint IDENTITY,
								  Name varchar(50) NOT NULL,
								  AddressLine varchar(100) NOT NULL,
								  City varchar(50) NOT NULL,
								  County varchar(50) NOT NULL,
								  PostalCode int NOT NULL,
								  PhoneNumber varchar(25) NOT NULL,
								  EmailAddress varchar(100) NOT NULL,
								  CONSTRAINT PK_ManufactureId PRIMARY KEY(ManufactureId),
								  CONSTRAINT CHK_Manufacture_Name CHECK (Name NOT IN ('%[^A-Za-z]%','%^ %')),
								  CONSTRAINT CHK_Manufacture_Line CHECK (AddressLine NOT IN ('%[^A-Za-z0-9]%','%^ %','%^.%')),
								  CONSTRAINT CHK_Manufacture_CityCounty CHECK ( (City+'|'+County) NOT IN ('%[^A-Za-z]%','%^ %')),
								  CONSTRAINT CHK_Manufacture_PhoneNumber CHECK(PhoneNumber NOT IN('%[^0-9]%','%^+%','%^ %','%^-%')),
								  CONSTRAINT CHK_Manufacture_EmailAddress CHECK(EmailAddress NOT IN('%[^A-Za-z0-9]%','%^@%','%^.%')),
								  CONSTRAINT UC_Manufacture_Name UNIQUE (Name))
GO
IF OBJECT_ID(N'Product.Brand',N'U') IS NULL
CREATE TABLE Product.Brand (BrandId smallint IDENTITY,
							Name varchar(50) NOT NULL,
							ManufactureId tinyint NOT NULL,
							CONSTRAINT PK_BrandId PRIMARY KEY(BrandId),
							CONSTRAINT FK_Brand_Manufacture FOREIGN KEY(ManufactureId) REFERENCES Product.Manufacture(ManufactureId),
							CONSTRAINT CHK_Brand_Name CHECK (Name NOT IN ('%[^A-Za-z]%','%^ %')),
							CONSTRAINT UC_Brand_Name UNIQUE (Name))
GO
IF OBJECT_ID(N'Product.BikeType',N'U') IS NULL
CREATE TABLE Product.BikeType (BikeTypeId tinyint IDENTITY,
							   Name varchar(50) NOT NULL,
							   CONSTRAINT PK_BikeTypeId PRIMARY KEY(BikeTypeId),
							   CONSTRAINT CHK_BikeType_Name CHECK (Name NOT IN ('%[^A-Za-z]%','%^ %')),
							   CONSTRAINT UC_BikeType_Name UNIQUE (Name))
GO
IF OBJECT_ID(N'Product.Model',N'U') IS NULL
CREATE TABLE Product.Model (ModelId int IDENTITY,
							BrandId smallint NOT NULL,
							BikeTypeId tinyint NOT NULL,
							Name varchar(100) NOT NULL,
							PurchasePrice smallmoney NOT NULL,
							RentalPrice smallmoney NOT NULL,
							StartDate date DEFAULT GETDATE() NOT NULL,
							EndDate date,
							TotalQuantity int DEFAULT 0,
							ServiceQuantity smallint DEFAULT 0 NOT NULL,
							RentalQuantity smallint DEFAULT 0 NOT NULL,
							AvailableQuantity AS TotalQuantity-(ServiceQuantity+RentalQuantity),
							CONSTRAINT PK_ModelId PRIMARY KEY(ModelId),
							CONSTRAINT FK_Model_Brand FOREIGN KEY(BrandId) REFERENCES Product.Brand(BrandId),
							CONSTRAINT FK_Model_BikeType FOREIGN KEY(BikeTypeId) REFERENCES Product.BikeType(BikeTypeId),
							CONSTRAINT CHK_Model_PurchasePrice CHECK(PurchasePrice > 0),
							CONSTRAINT CHK_Model_RentalPrice CHECK(RentalPrice > 0),
							CONSTRAINT CHK_Model_EndDate CHECK(EndDate >= StartDate OR EndDate IS NULL),
							CONSTRAINT CHK_Model_TotalQuantity CHECK(TotalQuantity >= 0),
							CONSTRAINT CHK_Model_ServiceQuantity CHECK(ServiceQuantity >= 0),
							CONSTRAINT CHK_Model_RentalQuantity CHECK(RentalQuantity >= 0),
							CONSTRAINT UC_Model_Name UNIQUE (Name))
GO
IF OBJECT_ID(N'HumanResources.Branch',N'U') IS NULL
CREATE TABLE HumanResources.Branch (BranchId tinyint IDENTITY,
									Name varchar(50) NOT NULL,
									OpenedDate date DEFAULT GETDATE() NOT NULL,
									ClosedDate date,
									CONSTRAINT PK_BranchId PRIMARY KEY(BranchId),
									CONSTRAINT CHK_Branch_ClosedDate CHECK(ClosedDate >= OpenedDate OR ClosedDate IS NULL),
									CONSTRAINT CHK_Branch_Name CHECK (Name NOT IN ('%[^A-Za-z]%','%^ %')),
									CONSTRAINT UC_Branch_Name UNIQUE (Name))
GO
IF OBJECT_ID(N'HumanResources.Employee',N'U') IS NULL
CREATE TABLE HumanResources.Employee (EmployeeId int IDENTITY,
									  PersonId int NOT NULL,
									  BranchId tinyint NOT NULL,
									  HiredDate date DEFAULT GETDATE() NOT NULL,
									  ExitDate date,
									  CONSTRAINT PK_EmployeeId PRIMARY KEY(EmployeeId),
									  CONSTRAINT FK_Employee_PersonId FOREIGN KEY(PersonId) REFERENCES Person.Person(PersonId),
									  CONSTRAINT FK_Employee_BranchId FOREIGN KEY(BranchId) REFERENCES HumanResources.Branch(BranchId),
									  CONSTRAINT CHK_Employee_ExitDate CHECK(ExitDate >= HiredDate OR ExitDate IS NULL))
GO
IF OBJECT_ID(N'HumanResources.RT_Branch_Model',N'U') IS NULL
CREATE TABLE HumanResources.RT_Branch_Model (BranchModelId int IDENTITY UNIQUE,
											 BranchId tinyint NOT NULL,
											 ModelId int NOT NULL,
											 Quantity tinyint NOT NULL,
											 CONSTRAINT FK_RT_Branch_Model_Model FOREIGN KEY(ModelId) REFERENCES Product.Model(ModelId),
											 CONSTRAINT FK_RT_Branch_Model_Branch FOREIGN KEY(BranchId) REFERENCES HumanResources.Branch(BranchId),
											 CONSTRAINT PK_RT_Branch_Model PRIMARY KEY(ModelId,BranchId),
											 CONSTRAINT UC_RT_Branch_Model_BranchModel UNIQUE(BranchmodelId))
GO
IF OBJECT_ID(N'Sales.Service',N'U') IS NULL
CREATE TABLE Sales.Service (ServiceId smallint IDENTITY,
							Name varchar(50) NOT NULL,
							AddressLine varchar(100) NOT NULL,
							City varchar(50) NOT NULL,
							County varchar(50) NOT NULL,
							PostalCode int NOT NULL,
							PhoneNumber varchar(25) NOT NULL,
							EmailAddress varchar(100) NOT NULL,
							JoinedDate date DEFAULT GETDATE() NOT NULL,
							ExitDate date,
							CONSTRAINT PK_ServiceId PRIMARY KEY(ServiceId),
							CONSTRAINT CHK_Service_Name CHECK (Name NOT IN ('%[^A-Za-z]%','%^ %')),
							CONSTRAINT CHK_Service_Line CHECK (AddressLine NOT IN ('%[^A-Za-z0-9]%','%^ %','%^.%')),
							CONSTRAINT CHK_Service_CityCounty CHECK ( (City+'|'+County) NOT IN ('%[^A-Za-z]%','%^ %')),
							CONSTRAINT CHK_Service_PhoneNumber CHECK(PhoneNumber NOT IN('%[^0-9]%','%^+%','%^ %','%^-%')),
							CONSTRAINT CHK_Service_EmailAddress CHECK(EmailAddress NOT IN('%[^A-Za-z0-9]%','%^@%','%^.%')),
							CONSTRAINT CHK_Service_ExitDate CHECK(ExitDate >= JoinedDate OR ExitDate IS NULL),
							CONSTRAINT UC_Service_Name UNIQUE(Name))
GO
IF OBJECT_ID(N'Sales.Customer',N'U') IS NULL
CREATE TABLE Sales.Customer (CustomerId int IDENTITY,
							 PersonId int NOT NULL,
							 JoinedDate date DEFAULT GETDATE() NOT NULL,
							 ExitDate date,
							 EmailSubscribe bit DEFAULT 0 NOT NULL,
							 CONSTRAINT PK_CustomerId PRIMARY KEY(CustomerId),
							 CONSTRAINT FK_Customer_Person FOREIGN KEY(PersonId) REFERENCES Person.Person(PersonId),
							 CONSTRAINT CHK_Customer_ExitDate CHECK(ExitDate >= JoinedDate OR ExitDate IS NULL))
GO
IF OBJECT_ID(N'Sales.ServicePaymentHeader',N'U') IS NULL
CREATE TABLE Sales.ServicePaymentHeader (ServicePaymentHeaderId int IDENTITY,
										 ServiceId smallint NOT NULL,
										 EmployeeId int NOT NULL,
										 OrderDate datetime DEFAULT GETDATE() NOT NULL,
										 ShippedDate datetime,
										 ReturnDate datetime,
										 ShippingCost smallmoney DEFAULT 10,
										 OrderCost smallmoney DEFAULT 0,
										 TotalCost AS ShippingCost+OrderCost,
										 CONSTRAINT PK_ServicePaymentHeaderId PRIMARY KEY(ServicePaymentHeaderId),
										 CONSTRAINT FK_ServicePaymentHeader_Service FOREIGN KEY(ServiceId) REFERENCES Sales.Service(ServiceId),
										 CONSTRAINT FK_ServicePaymentHeader_Employee FOREIGN KEY(EmployeeId) REFERENCES HumanResources.Employee(EmployeeId),
										 CONSTRAINT CHK_ServicePaymentHeader_ShippedDate CHECK(ShippedDate >= OrderDate OR ShippedDate IS NULL),
										 CONSTRAINT CHK_ServicePaymentHeader_ReturnDate CHECK(ReturnDate >= ShippedDate OR ReturnDate IS NULL),
										 CONSTRAINT CHK_ServicePaymentHeader_ShippingCost CHECK(ShippingCost >= 10),
										 CONSTRAINT CHK_ServicePaymentHeader_OrderCost CHECK(OrderCost >=0))						
GO
IF OBJECT_ID(N'Sales.ServicePaymentDetail',N'U') IS NULL
CREATE TABLE Sales.ServicePaymentDetail (ServicePaymentDetailId int IDENTITY,
										 ServicePaymentHeaderId int NOT NULL,
										 BranchModelId int NOT NULL,
										 Quantity tinyint NOT NULL,
										 ServicePrice smallmoney,
										 TotalPrice AS ServicePrice*Quantity,
										 ServiceReason varchar(100) NOT NULL,
										 CONSTRAINT PK_ServicePaymentDetailId PRIMARY KEY(ServicePaymentDetailId),
										 CONSTRAINT FK_ServicePaymentDetail_ServicePaymentHeader FOREIGN KEY(ServicePaymentHeaderId) REFERENCES Sales.ServicePaymentHeader(ServicePaymentHeaderId),
										 CONSTRAINT FK_ServicePaymentDetail_Model FOREIGN KEY(BranchModelId) REFERENCES HumanResources.RT_Branch_Model(BranchModelId),
										 CONSTRAINT CHK_ServicePaymentDetail_Quantity CHECK(Quantity >= 1),
										 CONSTRAINT CHK_ServicePaymentDetail_ServicePrice CHECK(ServicePrice >= 1))
GO
IF OBJECT_ID(N'Sales.BikeOrderHeader',N'U') IS NULL
CREATE TABLE Sales.BikeOrderHeader (BikeOrderHeaderId int IDENTITY,
									EmployeeId int NOT NULL,
									OrderDate datetime DEFAULT GETDATE(),
									ShippedDate datetime,
									ShippingCost smallmoney DEFAULT 15,
									OrderCost smallmoney DEFAULT 0,
									TotalCost AS ShippingCost+OrderCost,
									CONSTRAINT PK_BikeOrderHeaderId PRIMARY KEY(BikeOrderHeaderId),
									CONSTRAINT FK_BikeOrderHeader_Employee FOREIGN KEY(EmployeeId) REFERENCES HumanResources.Employee(EmployeeId),
									CONSTRAINT CHK_BikeOrderHeader_ShippedDate CHECK(ShippedDate >= OrderDate OR ShippedDate IS NULL),
									CONSTRAINT CHK_BikeOrderHeader_ShippingCost CHECK(ShippingCost >= 15),
									CONSTRAINT CHK_BikeOrderHeader_OrderCost CHECK(OrderCost >=0))
GO
IF OBJECT_ID(N'Sales.BikeOrderDetail',N'U') IS NULL
CREATE TABLE Sales.BikeOrderDetail (BikeOrderDetailId int IDENTITY,
									BikeOrderHeaderId int NOT NULL,
									BranchModelId int NOT NULL,
									Quantity tinyint NOT NULL,
									PurchasePrice smallmoney,
									TotalPrice AS (Quantity*PurchasePrice),
									CONSTRAINT PK_BikeOrderDetailId PRIMARY KEY(BikeOrderDetailId),
									CONSTRAINT FK_BikeOrderDetail_BikeOrderHeader FOREIGN KEY(BikeOrderHeaderId) REFERENCES Sales.BikeOrderHeader(BikeOrderHeaderId),
									CONSTRAINT FK_BikeOrderDetail_Model FOREIGN KEY(BranchModelId) REFERENCES HumanResources.RT_Branch_Model(BranchModelId),
									CONSTRAINT CHK_BikeOrderDetail_Quantity CHECK(Quantity >= 1),
									CONSTRAINT CHK_BikeOrderDetail_PurchasePrice CHECK(PurchasePrice >=1))
GO
IF OBJECT_ID(N'Sales.RentalPaymentHeader',N'U') IS NULL
CREATE TABLE Sales.RentalPaymentHeader (RentalPaymentHeaderId int IDENTITY,
										EmployeeId int NOT NULL,
										CustomerId int NOT NULL,
										OrderDate datetime DEFAULT GETDATE(),
										ShippedDate datetime,
										ReturnDate datetime,
										OrderCost smallmoney DEFAULT 0,
										CONSTRAINT PK_RentalPaymentHeaderId PRIMARY KEY(RentalPaymentHeaderId),
										CONSTRAINT FK_RentalPaymentHeader_Employee FOREIGN KEY(EmployeeId) REFERENCES HumanResources.Employee(EmployeeId),
										CONSTRAINT FK_RentalPaymentHeader_Customer FOREIGN KEY(CustomerId) REFERENCES Sales.Customer(CustomerId),
										CONSTRAINT CHK_RentalPaymentHeader_ShippedDate CHECK(ShippedDate >= OrderDate OR ShippedDate IS NULL),
										CONSTRAINT CHK_RentalPaymentHeader_ReturnDate CHECK(ReturnDate >= ShippedDate OR ReturnDate >= OrderDate OR ReturnDate IS NULL),
										CONSTRAINT CHK_RentalPaymentHeader_OrderCost CHECK(OrderCost >=0))
GO
IF OBJECT_ID(N'Sales.RentalPaymentDetail',N'U') IS NULL
CREATE TABLE Sales.RentalPaymentDetail (RentalPaymentDetailId int IDENTITY,
										RentalPaymentHeaderId int NOT NULL,
										BranchModelId int NOT NULL,
										Quantity tinyint NOT NULL,
										RentalPrice smallmoney NOT NULL,
										TotalPrice AS Quantity*RentalPrice,
										CONSTRAINT PK_RentalPaymentDetailId PRIMARY KEY(RentalPaymentDetailId),
										CONSTRAINT FK_RentalPaymentDetail_RentalPaymentHeader FOREIGN KEY(RentalPaymentHeaderId) REFERENCES Sales.RentalPaymentHeader(RentalPaymentHeaderId),
										CONSTRAINT FK_RentalPaymentDetail_Model FOREIGN KEY(BranchModelId) REFERENCES HumanResources.RT_Branch_Model(BranchModelId),
										CONSTRAINT CHK_RentalPaymentDetail_Quantity CHECK(Quantity >= 1),
										CONSTRAINT CHK_RentalPaymentDetail_RentalPrice CHECK(RentalPrice >=1))
GO
IF OBJECT_ID(N'Person.RT_Person_Address',N'U') IS NULL
CREATE TABLE Person.RT_Person_Address (PersonId int NOT NULL,
									   AddressId int NOT NULL,
									   CONSTRAINT RT_FK_Person_Address1 FOREIGN KEY(PersonId) REFERENCES Person.Person(PersonId),
									   CONSTRAINT RT_FK_Person_Address2 FOREIGN KEY(AddressId) REFERENCES Person.Address(AddressID),
									   CONSTRAINT PK_RT_Person_Address PRIMARY KEY (PersonId,AddressId))
GO
IF OBJECT_ID(N'Product.RT_Model_Type',N'U') IS NULL
CREATE TABLE Product.RT_Model_Type (ModelId int NOT NULL,
									BikeTypeId tinyint NOT NULL,
									CONSTRAINT RT_FK_Model_Type1 FOREIGN KEY(ModelId) REFERENCES Product.Model(ModelId),
									CONSTRAINT RT_FK_Model_Type2 FOREIGN KEY(BikeTypeId) REFERENCES Product.BikeType(BikeTypeId),
									CONSTRAINT PK_RT_Model_Type PRIMARY KEY (ModelId,BikeTypeId))
GO

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE Name = 'IDX_Person')
CREATE NONCLUSTERED INDEX IDX_Person
	ON person.person (Title,FirstName,MiddleName,LastName)
GO
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE Name = 'IDX_Address')
CREATE NONCLUSTERED INDEX IDX_Address
	ON person.address (addressline)
	INCLUDE	(city,county,postalcode)
GO
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE Name = 'IDX_Branch_Model')
CREATE NONCLUSTERED INDEX IDX_Branch_Model
	ON HumanResources.RT_Branch_Model (Quantity)
GO
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE Name = 'IDX_ServiceOrder')
CREATE NONCLUSTERED INDEX IDX_ServiceOrder
	ON Sales.ServicePaymentHeader (OrderDate)
GO
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE Name = 'IDX_RentalOrder')
CREATE NONCLUSTERED INDEX IDX_RentalOrder
	ON Sales.RentalPaymentHeader (OrderDate)
GO
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE Name = 'IDX_BikeOrder')
CREATE NONCLUSTERED INDEX IDX_BikeOrder
	ON Sales.BikeOrderHeader (OrderDate)
GO

ALTER DATABASE BikeRental SET MULTI_USER
GO