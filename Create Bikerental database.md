This is a bike rental database.

The basics_database folder contains the main SQL scripts of database.
The first SQL script is the create_db_main.sql file. It creates .mdf and .ldf files.
If you want to run it separately you have to replace @pathdatabase variable with your path.

Backups files create log files with timestamps in their names.
Full backup script works at 4p.m. every friday.
Differential backup script saves log files at 4p.m from every monday to thursday.
Transaction backup script create log files every 2 hour.
They is not recommended running in SSMS or similar way
because it contains many variables and it is difficult to replace with yours.

Highly recommended running Bikerental.exe desktop application on Windows.
It creates the database completely with your paths and datas.
