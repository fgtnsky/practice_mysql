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


# Method 1
select Score, rank from
(select  (Case WHEN @pre_score = Score THEN @rank := @rank WHEN @pre_score <> Score THEN @rank := @rank + 1 END) as rank
		, @pre_score := Score as Score
from (select Score from Scores order by Score desc) as sorted_score
		, (select @rank:=0,@pre_score := -1000) as init) as DATA1

# Method 2
select Scores.Score, count(*) as Rank
from Scores , (select distinct Score from Scores order by Score desc) as Ranking
where Scores.Score <= Ranking.Score
group by Scores.Id
order by Scores.Score desc;
