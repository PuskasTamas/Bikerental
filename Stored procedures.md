# Description of stored procedures
- **Rental order**  
It needs employee's and customer's name, the bike's name and a quantiy.  
Then it creates a rental order and get an identity number,  
a trigger counts a rental cost,  
decreases the available quantity of the bike in the main bike table,  
and make a list about the details of the rental.
- **Rental order plus**  
Of course, a customer can rental more bikes.  
In this case it only needs the identity number that you received earlier, and the name and quantity of the bike.  
Every other tasks are the same than the previous ones.
- **Rental shipped**  
It is possible that the customer will take the bike(s) away later - book.  
In this case it only needs the identity number of the order.  
Then it store the date of the rental on the order.
- **Rental return**  
When the customer return the bike(s) it stores the date of return.  
Then it increases the available quantity of the bike in the main table.  

The logic of the other procedures are the same then this one.
