# Description of create of the order of database.

**Highly recommended running Bikerental.exe desktop application on Windows.  
It creates the database completely with your paths and datas.**

However, if your want to install the database manually follow the next steps.  
The *basics_database* folder contains the main SQL scripts of the database:  
1. **Create_db_main.sql**  
It creates *.mdf* and *.ldf* files.  
You have to replace *@pathdatabase* variable with your path.  
3. **Create_tables_indexes.sql**  
It creates tables and indexes with constraints.
4. **Create_login.sql**  
It creates few login names with authorizations.
5. **insert_values.sql**  
I wonder what can do this for? 😃

The other scripts help the work of a client application.  
Description of they's details is arriving soon.
