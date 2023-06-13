SET nocount ON
GO

IF DB_ID('BikeRental') IS NOT NULL
	BEGIN
		ALTER DATABASE BikeRental SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE IF EXISTS BikeRental
	END
GO

CREATE DATABASE BikeRental
ON PRIMARY
( name='BikeRentalDatabase',
	filename='@primary',
	size=200mb,
	maxsize=unlimited,
	filegrowth=50mb )
LOG ON
( name='BikeRentalDatabase_log',
	filename='@log',
	size=20mb,
	maxsize=50mb,
	filegrowth=10mb );
GO