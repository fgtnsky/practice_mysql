/***************************************************************************
Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
For example, given the above Scores table, your query should generate the following report (order by highest score):

+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
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




