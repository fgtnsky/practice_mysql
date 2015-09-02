/***************************************************************************
The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows.

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
***************************************************************************/


drop table if exists Employee;
create table Employee(
	Id int(11) NOT NULL AUTO_INCREMENT, 
	Name varchar(20), 
	Salary int, 
	DepartmentId int,
	primary key(id));
	
INSERT INTO Employee VALUES
	(1,'Joe', 70000, 1),
	(2,'Henry',80000,2),
	(3,'Sam',60000,2),
	(4,'Max',90000,1),
	(5,'Janet',69000,1),
	(6,'Randy',85000,1);
	
drop table if exists Department;
create table Department(
	Id int(11) NOT NULL AUTO_INCREMENT,
	Name varchar(20),
	primary key(Id));

INSERT INTO Department(Name) VALUES ('IT'), ('Sales');

# method 1
select Department, Name, Salary from
(select Name,  (CASE WHEN @pre_dep=dep_name and @pre_salary= Salary THEN @seq:= @seq
		WHEN @pre_dep = dep_name and @pre_salary <> Salary THEN @seq:= @seq+1
		WHEN @pre_dep <> dep_name THEN @seq:=1 END) as seq,@pre_dep:=dep_name as Department, @pre_salary:=Salary as Salary
from
(select Employee.Id, Employee.Name, Salary, Department.Name as dep_name
from Employee, Department
where DepartmentId = Department.Id
order by DepartmentId, Salary desc) as ordered_employ,
(select @seq := 0, @pre_dep := 'NOT_NULLL',@pre_salary = -1000) as init) as Data1
where seq<=3;

# method 2
select distinct Num from
(select (CASE WHEN @last_num = Num THEN @freq := @freq + 1
						WHEN @last_num <> Num Then @freq := 1 END) as freqency
						, @last_num := Num as Num
from Logs join (select @last_num := -1000, @freq := 0) as init) as Freq
where freqency>=3;




