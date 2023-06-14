# Description of create of the order of database.

**Highly recommended running Bikerental.exe desktop application on Windows.  
It creates the database completely with your paths and datas.**

However, if your want to install the database manually follow the next steps.  
The *basics_database* folder contains the main SQL scripts of the database:  
1. **Create_db_main.sql**  
It creates *.mdf* and *.ldf* files.  
You have to replace *@pathdatabase* variable with your path.  
2. **Create_tables_indexes.sql**  
It creates tables and indexes with constraints.
3. **Create_login.sql**  
It creates few login names with authorizations.
4. **Insert_values.sql**  
I wonder what can do this for? 😃
5. **The other scripts**  
Help the work of a future client application.
7. **Backups**  
There is a full, a differential and a transaction agent file.  
You have to replace few values with yours after the next variables:  
\- @owner_login_name (at two places)  
\- @server_name  
\- @command  
\- @active_start_date
