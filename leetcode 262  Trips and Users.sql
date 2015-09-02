/***************************************************************************
The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).

+----+-----------+-----------+---------+--------------------+----------+
| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
+----+-----------+-----------+---------+--------------------+----------+
| 1  |     1     |    10     |    1    |     completed      |2013-10-01|
| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
| 3  |     3     |    12     |    6    |     completed      |2013-10-01|
| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
| 5  |     1     |    10     |    1    |     completed      |2013-10-02|
| 6  |     2     |    11     |    6    |     completed      |2013-10-02|
| 7  |     3     |    12     |    6    |     completed      |2013-10-02|
| 8  |     2     |    12     |    12   |     completed      |2013-10-03|
| 9  |     3     |    10     |    12   |     completed      |2013-10-03| 
| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
+----+-----------+-----------+---------+--------------------+----------+
The Users table holds all users. Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).

+----------+--------+--------+
| Users_Id | Banned |  Role  |
+----------+--------+--------+
|    1     |   No   | client |
|    2     |   Yes  | client |
|    3     |   No   | client |
|    4     |   No   | client |
|    10    |   No   | driver |
|    11    |   No   | driver |
|    12    |   No   | driver |
|    13    |   No   | driver |
+----------+--------+--------+
Write a SQL query to find the cancellation rate of requests made by unbanned clients between Oct 1, 2013 and Oct 3, 2013. For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

+------------+-------------------+
|     Day    | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 |       0.33        |
| 2013-10-02 |       0.00        |
| 2013-10-03 |       0.50        |
+------------+-------------------+

***************************************************************************/

drop table if exists Trips;
create table Trips(
	Id int(11) NOT NULL AUTO_INCREMENT,
	Client_Id int,
	Driver_Id int,
	City_Id int,
	Status ENUM('completed', 'cancelled_by_driver', 'cancelled_by_client'),
	Request_at DATE,
	primary key(Id));
	
INSERT INTO trips(Client_Id,Driver_Id,City_Id,Status,Request_at) VALUES
	(1,10,1,1,'2013-10-01'),
	(2,11,1,2,'2013-10-01'),
	(3,12,6,1,'2013-10-01'),
	(4,13,6,3,'2013-10-01'),
	(1,10,1,1,'2013-10-02'),
	(2,11,6,1,'2013-10-02'),
	(3,12,6,1,'2013-10-02'),
	(2,12,12,1,'2013-10-03'),
	(3,10,12,1,'2013-10-03'),
	(4,13,12,2,'2013-10-03');
	
INSERT INTO trips(Client_Id,Driver_Id,City_Id,Status,Request_at) VALUES
	(1,10,1,1,'2013-10-01');
	

drop table if exists Users;
create table Users(
Users_Id int(11),
Banned ENUM('Yes','No'),
Role ENUM('client', 'driver', 'partner'));

INSERT INTO Users VALUES
	(1,2,1),
	(2,1,1),
	(3,2,1),
	(4,2,1),
	(10,2,2),
	(11,2,2),
	(12,2,2),
	(13,2,2);
	

	

select D2.Request_at, round(ifnull(c1/c2,0),2) from	
(select Request_at, count(*) as c1 from
(select *
from Trips, Users
where Users_Id = Client_Id and Banned = 'No' and (Request_at between '2013-10-01' and '2013-10-03') and Status!='Completed') as DATA1
group by Request_at) as D1
right join 
(select Request_at, count(*) as c2 from
(select *
from Trips, Users
where Users_Id = Client_Id and Banned = 'No' and (Request_at between '2013-10-01' and '2013-10-03'))  as DATA2
group by Request_at) as D2
on D1.Request_at = D2.Request_at;





