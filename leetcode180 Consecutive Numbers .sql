/***************************************************************************
Write a SQL query to find all numbers that appear at least three times consecutively.

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.
***************************************************************************/


#  Consecutive Numbers:
create table Logs(Id int(11) NOT NULL AUTO_INCREMENT, Num int, PRIMARY KEY(Id));
INSERT INTO Logs(Num) VALUES(1),(1),(1),(2),(1),(2),(2);

# Method 1
select distinct L1.Num
from Logs L1, Logs L2, Logs L3
where L1.Id = L2.Id -1 and L2.Id = L3.Id -1 and L1.Num = L2.Num and L2.Num = L3.Num

# Method 2
select distinct Num from
(select (CASE WHEN @last_num = Num THEN @freq := @freq + 1
						WHEN @last_num <> Num Then @freq := 1 END) as freqency
						, @last_num := Num as Num
from Logs join (select @last_num := -1000, @freq := 0) as init) as Freq
where freqency>=3;
