USE BikeRental
GO
-- Delete all VALUES from all tables
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO
EXEC sp_MSForEachTable 'DELETE FROM ?'
GO

INSERT INTO Person.AddressType VALUES ('Employee Home Permanent'),
									  ('Employee Home Temporary'),
									  ('Employee Work'),
									  ('Customer Home Permanent'),
									  ('Customer Home Temporary')
GO
INSERT INTO Person.Address VALUES ('Princess Way 48','San Antodonia','Baskeurus',48167,3),
								  ('Sunny Lane 85','Santa Dorio','Baskeurus',48168,3),
								  ('Apostle Avenue 100','San Mipa','Radril',83651,3),
								  ('Spring Street 8','San Anrada','Radril',83652,3),
								  ('Central Route 81','Alaracas','Sheiton',21234,3), --5
								  ('Nova Lane 32','Moramento','Sheiton',21235,3),
								  
								  ('Brook Row 86','San Antodonia','Baskeurus',48167,1),
								  ('Hill Street 31','Santa Dorio','Baskeurus',48168,1),
								  ('Rose Lane 11','San Mipa','Radril',83651,1),
								  ('Grand Passage 28','San Anrada','Radril',83652,1), --10
								  ('Market Street 14','Alaracas','Sheiton',21234,1),
								  ('Jade Lane 96','Moramento','Sheiton',21235,1), 
								  ('Bury Route 91','San Antodonia','Baskeurus',48167,1),
								  ('East Avenue 77','Santa Dorio','Baskeurus',48168,1),
								  ('Fountain Route 19','San Mipa','Radril',83651,1), --15
								  ('King Lane 72','San Anrada','Radril',83652,1),
								  ('Ivy Way 22','Alaracas','Sheiton',21234,1),
								  ('Sunny Route 96','Moramento','Sheiton',21235,1),
								  
								  ('Cavern Boulevard 19','Abaza','Radril',83653,2),
								  ('Sapphire Avenue 67','La Juhuano','Sheiton',21236,2), --20
								  ('Elm Way 40','Nevez','Baskeurus',48169,2),
								  ('Blossom Lane 80','Paldos','Radril',83653,2),
								  ('Art Lane 83','Lunes','Sheiton',21236,2),

								  ('Haven Street 23','San Antodonia','Baskeurus',48167,4),
								  ('Mason Boulevard 56','Monterica','Baskeurus',48169,4), --25
								  ('Castle Route 53','Onrio','Fload Chain',2072,4),
								  ('Union Passage 58','Carritina','Fload Chain',2073,4),
								  ('Olive Boulevard 71','San Mipa','Radril',83651,4),
								  ('Apollo Passage 53','Vallepaera','Radril',83653,4),
								  ('Rosemary Street 43','La Vila','Bruacia',38106,4), --30
								  ('Walnut Lane 70','Pedreteno','Bruacia',38107,4),
								  ('Hawthorn Row 67','Bonanlo','Qecristan',30721,4),
								  ('Fox Passage 36','Mirados','Qecristan',30722,4),
								  ('Manor Street 39','Salbaia','Sholes',49509,4),
								  ('Crown Route 76','La Pelupe','Sholes',49510,4), --35
								  ('Ferry Row 49','Barpos','Frieye',33470,4),
								  ('High Lane 54','San Joaquera','Frieye',33471,4),
								  ('Valley Street 6','Flocedes','Stuyland',10701,4),
								  ('Grotto Route 91','Guayami','Stuyland',10702,4),
								  ('Marble Row 22','Alaracas','Sheiton',21234,4), --40
								  ('Jewel Street 73','Camarca','Sheiton',21236,4),
								  ('Sunshine Street 40','Chicazicia','Ofrua',44312,4),
								  ('Bloomfield Lane 22','Copata','Ofrua',44313,4),

								  ('Honor Route 3','La Aminio','Fload Chain',2074,5),
								  ('Brook Route 87','Urugoa','Bruacia',38108,5), --45
								  ('Rose Route 69','Robochi','Sholes',49511,5),
								  ('Victory Boulevard 11','Pacoritos','Stuyland',10703,5),
								  ('River Avenue 75','Blacedes','Sheiton',21237,5)
GO
INSERT INTO Person.PersonType VALUES ('Employee'),
									 ('Customer')
GO
INSERT INTO Person.Person VALUES (NULL,'Theo','Burt','Murray','M',20,1),
								 (NULL,'Lucy','Ardal','Henderson','F',29,1),
								 (NULL,'Kai',NULL,'Bell','M',37,1),
								 (NULL,'Jodie',NULL,'Davidson','F',38,1),
								 (NULL,'Freddie','Louis','Read','M',39,1),
								 (NULL,'Alisha','Kerry','Lowe','F',31,1),
								 (NULL,'Taylor',NULL,'Saunders','M',58,1),
								 (NULL,'Abby',NULL,'Smith','F',40,1),
								 (NULL,'Rory',NULL,'Harvey','M',29,1),
								 (NULL,'Phoebe',NULL,'White','F',26,1),
								 (NULL,'Hudson','Melvin','White','M',40,1),
								 (NULL,'Angel','Ruby','Jarvis','F',27,1),

								 ('Prof.','Callum','Will','West','M',51,2),
								 (NULL,'Ashton',NULL,'Johnston','M',69,2),
								 ('Dr.','James',NULL,'Walker','M',51,2),
								 (NULL,'Noah','Kester','Richards','M',33,2),
								 ('Dr.','Hayden',NULL,'Phillips','M',49,2),
								 (NULL,'Augustine',NULL,'Davenport','M',23,2),
								 ('Prof.','Ricky','Colman','Coffey','M',47,2),
								 (NULL,'Stephen',NULL,'Greer','M',34,2),
								 ('Dr.','Jace',NULL,'Bowen','M',63,2),
								 (NULL,'Orlando','Ivon','Singleton','M',27,2),
								 ('Dr.','Chloe','Macey','Wells','F',73,2),
								 (NULL,'Maisy',NULL,'Reid','F',33,2),
								 ('Dr.','Mya',NULL,'Henderson','F',51,2),
								 (NULL,'Isabelle','Jamari','Fisher','F',23,2),
								 ('Dr.','Hannah',NULL,'Griffiths','F',53,2),
								 (NULL,'Kaitlin','Lyn','Burns','F',18,2),
								 ('Prof.','Amira',NULL,'Marshall','F',78,2),
								 (NULL,'Anabella','Jasmine','Dorsey','F',26,2),
								 ('Dr.','Monica',NULL,'Daniels','F',47,2),
								 (NULL,'Sabrina',NULL,'Coleman','F',33,2)
GO
INSERT INTO Person.EmailType VALUES ('Employee Home'),
									('Employee Work'),
									('Customer Primary'),
									('Customer Secondary')
GO
INSERT INTO Person.Email VALUES (1,'theoburtmurray@ecallen.com',1),
								(1,'theoburtmurray@dragonclaw.com',2),
								(2,'lucyardalhenderson@greendike.com',1),
								(2,'lucyardalhenderson@dragonclaw.com',2),
								(3,'kaibell@omtecha.com',1),
								(3,'kaibell@bravery.com',2),
								(4,'jodiedavidson@uptown.id',1),
								(4,'jodiedavidson@bravery.com',2),
								(5,'freddielouisread@elraodo.com',1),
								(5,'freddielouisread@falcon.com',2),
								(6,'alishakerrylowe@greendike.com',1),
								(6,'alishakerrylowe@falcon.com',2),
								(7,'taylorsaunders@swiftstrike.com',2),
								(8,'abbysmith@swiftstrike.com',2),
								(9,'roryharvey@scarlet.com',2),
								(10,'phoebewhite@scarlet.com',2),
								(11,'hudsonmelvinwhite@creed.com',2),
								(12,'angelrubyjarvis@creed.com',2),

								(13,'callumwillwest@greendike.com',3),
								(14,'ashtonjohnston@fnaul.com',3),
								(15,'jameswalker@omtecha.com',3),
								(16,'noahkesterrichards@uptown.id',3),
								(16,'noahkesterrichards@transmute.us',4),
								(17,'haydenphillips@greendike.com',3),
								(18,'augustinedavenport@roptaoti.com',3),
								(19,'rickycolmancoffey@nproxi.com',3),
								(20,'stephengreer@email.com',3),
								(20,'stephengreer@greendike.com',4),
								(21,'jacebowen@hotmail.red',3),
								(22,'orlandoivonsingleton@nonise.com',3),
								(23,'chloemaceywells@ecallen.com',3),
								(24,'maisyreid@fnaul.com',3),
								(24,'maisyreid@uptown.id',4),
								(25,'myahenderson@hotmail.red',3),
								(26,'isabellejamarifisher@nproxi.com',3),
								(27,'hannahgriffiths@omtecha.com',3),
								(28,'kaitlinlynburns@email.com',3),
								(28,'kaitlinlynburns@roadbike.ga',4),
								(29,'amiramarshall@transmute.us',3),
								(30,'anabellajasminedorsey@ecallen.com',3),
								(30,'anabellajasminedorsey@roadbike.ga',4),
								(31,'monicadaniels@fnaul.com',3),
								(32,'sabrinacoleman@uptown.id',3)
GO
INSERT INTO Person.PhoneType VALUES ('Employee Home'),
									('Employee Work'),
									('Customer Main'),
									('Customer Other')
GO
INSERT INTO Person.Phone VALUES (1,'+1 202-918-2132',1),
								(1,'+1 202-918-2100',2),
								(2,'+1 202-918-2185',1),
								(2,'+1 202-918-2100',2),
								(3,'+1 202-915-5247',1),
								(3,'+1 202-915-5200',2),
								(4,'+1 202-915-5214',1),
								(4,'+1 202-915-5200',2),
								(5,'+1 505-644-6676',1),
								(5,'+1 505-644-6600',2),
								(6,'+1 505-644-6636',1),
								(6,'+1 505-644-6600',2),
								(7,'+1 505-649-3496',1),
								(7,'+1 505-649-3400',2),
								(8,'+1 505-649-3475',1),
								(8,'+1 505-649-3400',2),
								(9,'+1 305-538-2028',1),
								(9,'+1 305-538-2000',2),
								(10,'+1 305-538-2061',1),
								(10,'+1 305-538-2000',2),
								(11,'+1 305-411-3313',1),
								(11,'+1 305-411-3300',2),
								(12,'+1 305-411-3394',1),
								(12,'+1 305-411-3300',2),

								(13,'+1 202-918-2155',3),
								(14,'+1 202-845-2548',3),
								(15,'+1 213-845-1094',3),
								(16,'+1 213-126-5489',3),
								(16,'+1 213-338-6248',4),
								(17,'+1 505-598-4026',3),
								(18,'+1 505-950-4868',3),
								(19,'+1 412-698-3427',3),
								(20,'+1 412-218-1668',3),
								(20,'+1 412-477-1658',4),
								(21,'+1 582-201-6445',3),
								(22,'+1 582-559-2548',3),
								(23,'+1 224-465-1099',3),
								(24,'+1 224-327-6887',3),
								(24,'+1 224-445-3077',4),
								(25,'+1 248-828-7999',3),
								(26,'+1 248-486-7958',3),
								(27,'+1 615-526-0152',3),
								(28,'+1 615-915-5142',3),
								(28,'+1 615-687-2986',4),
								(29,'+1 305-538-2088',3),
								(30,'+1 305-996-2658',3),
								(30,'+1 305-115-3489',4),
								(31,'+1 341-599-0454',3),
								(32,'+1 341-446-0454',3)
GO
INSERT INTO Person.RT_Person_Address VALUES (1,1),(1,7),
											(2,1),(2,13),
											(3,2),(3,8),
											(4,2),(4,14),(4,21),
											(5,3),(5,9),
											(6,3),(6,15),
											(7,4),(7,10),(7,19),
											(8,4),(8,16),(8,22),
											(9,5),(9,11),
											(10,5),(10,17),
											(11,6),(11,12),(11,20),
											(12,6),(12,18),(12,23),
											(13,24),
											(14,25),
											(15,26),
											(16,27),(16,44),
											(17,28),
											(18,29),
											(19,30),
											(20,31),(20,45),
											(21,32),
											(22,33),
											(23,34),
											(24,35),(24,46),
											(25,36),
											(26,37),
											(27,38),
											(28,39),(28,47),
											(29,40),
											(30,41),(30,48),
											(31,42),
											(32,43)
GO
INSERT INTO Product.BikeType VALUES ('Road'),
									('Mountain'),
									('Touring'),
									('Electric'),
									('BMX'),
									('Kid')
GO
INSERT INTO Product.Manufacture VALUES ('Shadowbit','Lawn Lane 57','Faving','Caspania',54601,'+1 202-918-2132','shadowbit@naverapp.com'),
									   ('Hummingworth','Bright Street 76','Clekford','Froye',11413,'+1 582-900-3117','hummingworth@btcmd.com'),
									   ('Goldustries','Trinity Street 49','Enceron','Sucria',21117,'+1 501-647-6077','goldustries@naverapp.com'),
									   ('Apexwell','Liberty Row 4','Dason','Eprar',43551,'+1 224-401-6672','apexwell@appsmail.us'),
									   ('Dynamico','Ivory Route 85','San Antodonia','Baskeurus',48167,'+1 202-918-2486','dynamico@mumbama.com')
GO
INSERT INTO Product.Brand VALUES ('Duporn',1),
								 ('Antegice',1),
								 ('Sempa',2),
								 ('Raf',2),
								 ('Comy',3),
								 ('Mononell',3),
								 ('Truxail',4),
								 ('Synor',4),
								 ('Dinall',5),
								 ('Hozo',5)
GO
INSERT INTO Product.Model (BrandId,BikeTypeId,Name,PurchasePrice,RentalPrice)
						VALUES  (1,2,'Eraser',136,13),
								(1,1,'Ambition',270,27),
								(2,6,'Purpose',237,23),
								(2,4,'Mamba',905,90),
								(3,6,'Grace',108,10),
								(3,3,'Serpent',215,21),
								(4,3,'Achiver',506,50),
								(4,1,'Storm',344,34),
								(5,4,'Inspirer',947,94),
								(5,1,'Eternity',353,35),
								(6,4,'Classified',1540,154),
								(6,2,'Preserver',253,25),
								(7,4,'Celebration',1622,162),
								(7,5,'Covert',215,21),
								(8,2,'Destroyer',223,22),
								(8,3,'Treasure',390,39),
								(9,2,'Engager',198,98),
								(9,5,'Bolt',225,25),
								(10,3,'Fighter',296,29),
								(10,1,'Searcher',530,53)
GO
INSERT INTO HumanResources.Branch (Name) VALUES ('Dragonclaw Base'),
												('Bravery Sanctum'),
												('Falcon Fortress'),
												('Swiftstrike Mansion'),
												('The Scarlet Citadel'),
												('Creed''s Station')
GO
INSERT INTO HumanResources.Employee (PersonId,BranchId) VALUES (1,1),
															   (2,1),
															   (3,2),
															   (4,2),
															   (5,3),
															   (6,3),
															   (7,4),
															   (8,4),
															   (9,5),
															   (10,5),
															   (11,6),
															   (12,6)
GO
INSERT INTO HumanResources.RT_Branch_Model VALUES 
	(1,1,5),(1,2,2),(1,3,1),(1,4,4),(1,5,1),(1,6,5),(1,7,15),(1,8,7),(1,9,4),(1,10,15),
	(1,11,5),(1,12,15),(1,13,5),(1,14,1),(1,15,7),(1,16,15),(1,17,8),(1,18,1),(1,19,3),(1,20,13),

	(2,1,5),(2,2,2),(2,3,1),(2,4,4),(2,5,1),(2,6,5),(2,7,15),(2,8,7),(2,9,4),(2,10,15),
	(2,11,5),(2,12,15),(2,13,5),(2,14,1),(2,15,7),(2,16,15),(2,17,8),(2,18,1),(2,19,3),(2,20,13),

	(3,1,5),(3,2,2),(3,3,1),(3,4,4),(3,5,1),(3,6,5),(3,7,15),(3,8,7),(3,9,4),(3,10,15),
	(3,11,5),(3,12,15),(3,13,5),(3,14,1),(3,15,7),(3,16,15),(3,17,8),(3,18,1),(3,19,3),(3,20,13),
	
	(4,1,5),(4,2,2),(4,3,1),(4,4,4),(4,5,1),(4,6,5),(4,7,15),(4,8,7),(4,9,4),(4,10,15),
	(4,11,5),(4,12,15),(4,13,5),(4,14,1),(4,15,7),(4,16,15),(4,17,8),(4,18,1),(4,19,3),(4,20,13),

	(5,1,5),(5,2,2),(5,3,1),(5,4,4),(5,5,1),(5,6,5),(5,7,15),(5,8,7),(5,9,4),(5,10,15),
	(5,11,5),(5,12,15),(5,13,5),(5,14,1),(5,15,7),(5,16,15),(5,17,8),(5,18,1),(5,19,3),(5,20,13),

	(6,1,5),(6,2,2),(6,3,1),(6,4,4),(6,5,1),(6,6,5),(6,7,15),(6,8,7),(6,9,4),(6,10,15),
	(6,11,5),(6,12,15),(6,13,5),(6,14,1),(6,15,7),(6,16,15),(6,17,8),(6,18,1),(6,19,3),(6,20,13)
GO
INSERT INTO Sales.Customer (PersonId,EmailSubscribe) VALUES (13,1),
															(14,0),
															(15,1),
															(16,0),
															(17,1),
															(18,0),
															(19,1),
															(20,1),
															(21,1),
															(22,1),
															(23,1),
															(24,0),
															(25,1),
															(26,0),
															(27,1),
															(28,1),
															(29,1),
															(30,1),
															(31,1),
															(32,0)
GO
INSERT INTO Sales.Service (Name,AddressLine,City,County,PostalCode,PhoneNumber,EmailAddress)
					VALUES ('Gorillatechs','South Avenue 31','Clester','Oskines',7652,'+1 402-610-6340','gorillatechs@falcon.com'),
						   ('Hatchworks','Heirloom Boulevard 20','Pogas','Ufrain',19320,'+1 307-961-2491','hatchworks@omtecha.com'),
						   ('Accenco','Knight Street 81','Meles','Acrar',42101,'+1 253-413-5225','accenco@iptown.id'),
						   ('Pumpkin Corp','Oval Avenue 47','Dason','Eprar',43551,'+1 224-401-6123','pumpkincorp@appsmail.us'),
						   ('Brisco','Aurora Lane 82','San Antodonia','Baskeurus',48167,'+1 202-918-2486','brisco@mumbama.com')
GO

UPDATE Product.Model
SET TotalQuantity=(SELECT SUM(h.Quantity) FROM HumanResources.RT_Branch_Model h WHERE Product.Model.ModelId=h.ModelId)
WHERE Product.Model.ModelId IN (SELECT h.ModelId FROM HumanResources.RT_Branch_Model h)
GO