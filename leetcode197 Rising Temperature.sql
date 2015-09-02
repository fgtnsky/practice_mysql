/***************************************************************************
Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.

+---------+------------+------------------+
| Id(INT) | Date(DATE) | Temperature(INT) |
+---------+------------+------------------+
|       1 | 2015-01-01 |               10 |
|       2 | 2015-01-02 |               25 |
|       3 | 2015-01-03 |               20 |
|       4 | 2015-01-04 |               30 |
+---------+------------+------------------+
For example, return the following Ids for the above Weather table:
+----+
| Id |
+----+
|  2 |
|  4 |
+----+
***************************************************************************/


drop table if exists Weather;
create table Weather(
Id int(11) NOT NULL AUTO_INCREMENT,
Date DATE,
Temperature int(11),
primary key(id));

INSERT INTO Weather(Date,Temperature) VALUES
	('2015-01-01',10),
	('2015-01-02',25),
	('2015-01-03',20),
	('2015-01-04',30);
	
select W2.Id
from Weather W1, Weather W2
where ADDDATE(W1.Date,1) = W2.Date and W1.Temperature<W2.Temperature




