
/***************************************************************************

Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Table: Customers.

+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Table: Orders.

+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Using the above tables as example, return the following:

+-----------+


| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+

***************************************************************************/


drop table if exists Customers;
create table Customers(
Id int(11) NOT NULL AUTO_INCREMENT,
Name varchar(20),
primary key(Id));

INSERT INTO Customers(Name) VALUES ('Joe'),('Henry'),('Sam'),('Max');

drop table if exists Orders;
create table Orders(
Id int(11) NOT NULL AUTO_INCREMENT,
CustomerId int(11),
primary key(Id));

INSERT INTO Orders(CustomerId) VALUES (3),(1);

select Name from Customers where Id not in
(select Customers.Id
from Customers, Orders
where Customers.Id = CustomerId)



