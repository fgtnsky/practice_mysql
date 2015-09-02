/***************************************************************************

Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+


***************************************************************************/

drop table if exists Person;
create table Person(
Id int(11) NOT NULL,
Email varchar(40),
primary key(Id));

INSERT INTO Person VALUES 
	(1,'john@example.com'),
	(2,'bob@example.com'),
	(3,'john@example.com');
	
select MIN(Id), Email
from Person
group by Email
order by Id;

DELETE P2
from Person P1, Person P2
where P1.Email = P2. Email and P1.Id < P2.Id



