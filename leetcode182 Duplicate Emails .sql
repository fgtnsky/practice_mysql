/***************************************************************************
Write a SQL query to find all duplicate emails in a table named Person.

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
For example, your query should return the following for the above table:

+---------+
| Email   |
+---------+
| a@b.com |
+---------+
Note: All emails are in lowercase.
***************************************************************************/

drop table if exists Person;
create table Person(
Id int(11) NOT NULL AUTO_INCREMENT,
Email varchar(40),
primary key(Id));

INSERT INTO Person(Email) VALUES ('a@b.com'),('c@d.com'),('a@b.com');

select Email from (
select Email, count(*) as num
from Person
group by Email) as dup_email
where num>1;




