/***************************************************************************
The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, Max has the highest salary in the IT department and Henry has the highest salary in the Sales department.

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
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
	(4,'Max',90000,1);
	
drop table if exists Department;
create table Department(
	Id int(11) NOT NULL AUTO_INCREMENT,
	Name varchar(20),
	primary key(Id));

INSERT INTO Department(Name) VALUES ('IT'), ('Sales');

select dept_name, Name, Salary from
(select Employee.Name, Salary, DepartmentId,Department.Name as dept_name
from Employee join Department 
where DepartmentId = Department.Id) as Employ,
(select MAX(Salary) as maxsalary, DepartmentId
from Employee
group by DepartmentId) as max_Salary
where Salary=maxsalary and Employ.DepartmentId = max_Salary.DepartmentId





