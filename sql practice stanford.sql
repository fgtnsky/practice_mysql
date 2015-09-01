
#######################################################
###  Part I: SQL Movie-Rating Query  Exercises      ###
#######################################################


# Find the Link Here:
# https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/

#Movie ( mID, title, year, director ) 
#English: There is a movie with ID number mID, a title, a release year, and a director. 

#Reviewer ( rID, name ) 
#English: The reviewer with ID number rID has a certain name. 

#Rating ( rID, mID, stars, ratingDate ) 
#English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

## Schema and data input:


/* Delete the tables if they already exist */
drop table if exists Movie;
drop table if exists Reviewer;
drop table if exists Rating;

/* Create the schema for our tables */
create table Movie(mID int, title text, year int, director text);
create table Reviewer(rID int, name text);
create table Rating(rID int, mID int, stars int, ratingDate date);

/* Populate the tables with our data */
insert into Movie values(101, 'Gone with the Wind', 1939, 'Victor Fleming');
insert into Movie values(102, 'Star Wars', 1977, 'George Lucas');
insert into Movie values(103, 'The Sound of Music', 1965, 'Robert Wise');
insert into Movie values(104, 'E.T.', 1982, 'Steven Spielberg');
insert into Movie values(105, 'Titanic', 1997, 'James Cameron');
insert into Movie values(106, 'Snow White', 1937, null);
insert into Movie values(107, 'Avatar', 2009, 'James Cameron');
insert into Movie values(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

insert into Reviewer values(201, 'Sarah Martinez');
insert into Reviewer values(202, 'Daniel Lewis');
insert into Reviewer values(203, 'Brittany Harris');
insert into Reviewer values(204, 'Mike Anderson');
insert into Reviewer values(205, 'Chris Jackson');
insert into Reviewer values(206, 'Elizabeth Thomas');
insert into Reviewer values(207, 'James Cameron');
insert into Reviewer values(208, 'Ashley White');

insert into Rating values(201, 101, 2, '2011-01-22');
insert into Rating values(201, 101, 4, '2011-01-27');
insert into Rating values(202, 106, 4, null);
insert into Rating values(203, 103, 2, '2011-01-20');
insert into Rating values(203, 108, 4, '2011-01-12');
insert into Rating values(203, 108, 2, '2011-01-30');
insert into Rating values(204, 101, 3, '2011-01-09');
insert into Rating values(205, 103, 3, '2011-01-27');
insert into Rating values(205, 104, 2, '2011-01-22');
insert into Rating values(205, 108, 4, null);
insert into Rating values(206, 107, 3, '2011-01-15');
insert into Rating values(206, 106, 5, '2011-01-19');
insert into Rating values(207, 107, 5, '2011-01-20');
insert into Rating values(208, 104, 3, '2011-01-02');


# Q1
# Find the titles of all movies directed by Steven Spielberg. 
select title
from Movie
where director = 'Steven Spielberg';

# Q2
# Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

select distinct year
from Movie join Rating using(mID)
where stars >= 4
order by year;


# Q3
# Find the titles of all movies that have no ratings.
select title
from Movie 
where mID not in (select mID from Rating);

#Q4
#Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
select name
from Reviewer join Rating using(rID)
where ratingDate is null;

#Q5
# Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

select distinct name, title, stars, ratingDate
from Movie, Reviewer, Rating
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID
order by name, title, stars;

#Q6
#For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
 
select name, title
from Movie, Reviewer, Rating R1, Rating R2
where Movie.mID = R1.mID and Reviewer.rID = R1.rID and R1.rID = R2.rID and R1.mID=R2.mID
 and R1.ratingDate < R2.ratingDate and R1.stars < R2.stars;

# Q7
# For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
select title, max(stars)
from  Movie join Rating using(mID)
group by mID;

#Q8 
#For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

select title, max(stars) - min(stars) as rating_spreading
from  Movie join Rating using(mID)
group by mID
order by rating_spreading desc;

#Q9  (1/1 point)
#Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

select
(select avg(avgstars1) from(select mID, year, avg(stars) as avgstars1 from Movie join Rating using(mID) where year<1980 group by mID) as D1) -
(select avg(avgstars2) from(select mID, year, avg(stars) as avgstars2 from Movie join Rating using(mID) where year>1980 group by mID) as D2);




#######################################################
## Part II: SQL Movie-Rating Query  Exercises Extras ##
#######################################################

# Find the link here:
# https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_extra/

# Q1  (1/1 point)
# Find the names of all reviewers who rated Gone with the Wind. 

select distinct name
from Movie, Reviewer, Rating
where Movie.mID = Rating.mID and Reviewer.rID=Rating.rID
	 and title = 'Gone with the Wind';

	 
# Q2  (1/1 point)
# For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 

select distinct name, title, stars
from Movie, Reviewer, Rating
where Movie.mID = Rating.mID and Reviewer.rID=Rating.rID
and name = director;


#Q3  (1/1 point)
#Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
select name from Reviewer 
union
select title as name from Movie
order by name;

#Q4  (1/1 point)
#Find the titles of all movies not reviewed by Chris Jackson. 
select title from Movie
where title not in (select title from Movie, Reviewer,Rating
		where Movie.mID = Rating.mID and Reviewer.rID=Rating.rID
		and name = 'Chris Jackson'
);



#Q5  (1/1 point)
#For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
select distinct Rev1.name, Rev2.name
from Rating R1, Rating R2, Reviewer Rev1, Reviewer Rev2
where R1.mID = R2.mID and R1.rID=Rev1.rID and 
		R2.rID = Rev2.rID and Rev1.name < Rev2.name;



#Q6  (1/1 point)
#For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from Movie, Reviewer, Rating
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID
	and stars = (select min(stars) from Rating);
	
	
#Q7  (1/1 point)
#List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
select title, avg(stars) as avgstars
from Movie,Rating
where Movie.mID = Rating.mID
group by Movie.mID
order by avgstars desc, title;


#Q8  (1/1 point)
#Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
select nam
from
(select name, count(*) as number
from Reviewer, Rating
where Reviewer.rID = Rating.rID 
group by Reviewer.rID) as D1
where number>=3;


#Q9  (1/1 point)
#Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
select title, director
from Movie
where director in (
select director
from Movie
group by director
having count(*) > 1)
order by director, title;


#Q10  (1/1 point)
#Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 

select title, avgstars
from (
select title, avg(stars) as avgstars
from Movie, Rating
where Movie.mID = Rating.mID 
group by title) D1
where avgstars = (select max(D2.avgstars) from (
select avg(stars) as avgstars
from Movie, Rating
where Movie.mID = Rating.mID 
group by title) as D2)
;



#Q11  (1/1 point)
#Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 

select title, avgstars
from (
select title, avg(stars) as avgstars
from Movie, Rating
where Movie.mID = Rating.mID 
group by title) D1
where avgstars = (select min(D2.avgstars) from (
select avg(stars) as avgstars
from Movie, Rating
where Movie.mID = Rating.mID 
group by title) as D2)
;

#Q12  (1/1 point)
#For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 

select distinct director, title, stars
from Movie , Rating
where Movie.mID = Rating.mID and Rating.stars = (
		select max(stars) from Rating as R2, Movie as M2
		where M2.mID=R2.mID and M2.director=Movie.director)
		and director is not null;


#######################################################
##    Part III: SQL Movie-Rating Modification Ex     ##
#######################################################

# Find the link here:
# https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_mod/


#Q1  (1/1 point)
#Add the reviewer Roger Ebert to your database, with an rID of 209. 
insert into Reviewer values (209,'Roger Ebert');


#Q2  (1/1 point)
#Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 
insert into Rating
select (select distinct rID from Reviewer where name='James Cameron'),mID, 5, null
from Movie;

#Q3  (1/1 point)
#For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) 
update Movie
set year = year + 25
where mID in	
	(select mID
	from Rating
	group by mID
	having avg(stars) >= 4);


#Q4  (1/1 point)
#Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. 
delete from Rating
where stars < 4 and mID in
	(select mID from Movie where year<1970 or year > 2000);




#######################################################
##    Part IV: SQL Social-Network Query Ex           ##
#######################################################


#Students at your hometown high school have decided to organize their social network using databases. So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema: 

#Highschooler ( ID, name, grade ) 
#English: There is a high school student with unique ID and a given first name in a certain grade. 

#Friend ( ID1, ID2 ) 
#English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

#Likes ( ID1, ID2 ) 
#English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

# Find the link here:
#  https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_core/


#####  Schema and Data below:   ####

/* Delete the tables if they already exist */
drop table if exists Highschooler;
drop table if exists Friend;
drop table if exists Likes;

/* Create the schema for our tables */
create table Highschooler(ID int, name text, grade int);
create table Friend(ID1 int, ID2 int);
create table Likes(ID1 int, ID2 int);

create table Highschooler(ID int, name text, grade int);
create table Friend(ID1 int, ID2 int);
create table Likes(ID1 int, ID2 int);

/* Populate the tables with our data */
insert into Highschooler values (1510, 'Jordan', 9);
insert into Highschooler values (1689, 'Gabriel', 9);
insert into Highschooler values (1381, 'Tiffany', 9);
insert into Highschooler values (1709, 'Cassandra', 9);
insert into Highschooler values (1101, 'Haley', 10);
insert into Highschooler values (1782, 'Andrew', 10);
insert into Highschooler values (1468, 'Kris', 10);
insert into Highschooler values (1641, 'Brittany', 10);
insert into Highschooler values (1247, 'Alexis', 11);
insert into Highschooler values (1316, 'Austin', 11);
insert into Highschooler values (1911, 'Gabriel', 11);
insert into Highschooler values (1501, 'Jessica', 11);
insert into Highschooler values (1304, 'Jordan', 12);
insert into Highschooler values (1025, 'John', 12);
insert into Highschooler values (1934, 'Kyle', 12);
insert into Highschooler values (1661, 'Logan', 12);

insert into Friend values (1510, 1381);
insert into Friend values (1510, 1689);
insert into Friend values (1689, 1709);
insert into Friend values (1381, 1247);
insert into Friend values (1709, 1247);
insert into Friend values (1689, 1782);
insert into Friend values (1782, 1468);
insert into Friend values (1782, 1316);
insert into Friend values (1782, 1304);
insert into Friend values (1468, 1101);
insert into Friend values (1468, 1641);
insert into Friend values (1101, 1641);
insert into Friend values (1247, 1911);
insert into Friend values (1247, 1501);
insert into Friend values (1911, 1501);
insert into Friend values (1501, 1934);
insert into Friend values (1316, 1934);
insert into Friend values (1934, 1304);
insert into Friend values (1304, 1661);
insert into Friend values (1661, 1025);
insert into Friend select ID2, ID1 from Friend;

insert into Likes values(1689, 1709);
insert into Likes values(1709, 1689);
insert into Likes values(1782, 1709);
insert into Likes values(1911, 1247);
insert into Likes values(1247, 1468);
insert into Likes values(1641, 1468);
insert into Likes values(1316, 1304);
insert into Likes values(1501, 1934);
insert into Likes values(1934, 1501);
insert into Likes values(1025, 1101);

#Q1  (1/1 point)
#Find the names of all students who are friends with someone named Gabriel.

select H2.name
from Friend, Highschooler H1, Highschooler H2
where H1.name = 'Gabriel' and H1.ID = ID1 and H2.ID=ID2;

#Q2  (1/1 point)
#For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
select H1.name, H1.grade, H2.name, H2.grade
from Likes, Highschooler H1, Highschooler H2
where H1.ID=ID1 and H2.ID=ID2 and H1.grade - H2.grade>=2;


#Q3  (1/1 point)
#For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
select H1.name, H1.grade, H2.name, H2.grade
from Likes L1, Highschooler H1, Highschooler H2
where H1.ID=ID1 and H2.ID=ID2 and H1.name < H2.name and
		ID1 in (select ID2 from Likes L2 where
		L2.ID1 = L1.ID2);
		
		
#Q4  (1/1 point)
#Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 
select name, grade
from Highschooler
where ID not in (
	select ID1 from Likes union select ID2 from Likes)
order by grade,name;


#Q5  (1/1 point)
#For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 

select H1.name, H1.grade, H2.name, H2.grade
from Likes L1, Highschooler H1, Highschooler H2
where H1.ID=ID1 and H2.ID=ID2 and H2.ID not in
	(select ID1 from Likes);

#Q6  (1/1 point)
#Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
select name, grade
from Highschooler
where ID not in (
select distinct H1.ID
from Friend, Highschooler H1, Highschooler H2
where H1.ID = ID1 and H2.ID=ID2 and H1.grade <> H2.grade)
order by grade,name;


#Q7  (1/1 point)
#For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 

select H1.name, H1.grade,H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3, Likes
where  H1.ID not in (select ID2 from Friend where ID1=H2.ID)
	and  H1.ID in (select ID2 from Friend where ID1=H3.ID)
	and  H2.ID in (select ID2 from Friend where ID1=H3.ID)
	and ID1=H1.ID and ID2=H2.ID;
	
	
#Q8  (1/1 point)
#Find the difference between the number of students in the school and the number of different first names. 
select (select count(*) from Highschooler) - 
	(select count(distinct name) from Highschooler);
	
	
#Q9  (1/1 point)
#Find the name and grade of all students who are liked by more than one other student. 

select name, grade
from Highschooler
where ID in
(select ID2
from Likes
group by ID2
having count(*)>=2);


#######################################################
##    Part V: SQL Social-Network Query Ex Extras     ##
#######################################################


# Find the link here:
# https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_extra/


#Q1  (1/1 point)
#For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
select distinct H1.name, H1.grade,H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3
where  H2.ID in (select ID2 from Likes where ID1=H1.ID)
	and  H3.ID in (select ID2 from Likes where ID1=H2.ID)
	and  H1.ID <> H3.ID;
	
	
	
#Q2  (1/1 point)
#Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 

select name, grade
from Highschooler
where ID not in (
	select H1.ID from Highschooler H1, Highschooler H2, Friend
	where H1.ID=ID1 and H2.ID=ID2 and H1.grade = H2.grade);
	
	
	
#Q3  (1/1 point)
#What is the average number of friends per student? (Your result should be just one number.) 
select avg(D.num) from
(select ID1, count(*) as num
from Friend
group by ID1) as D;


#Q4  (1/1 point)
#Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
select count(D1.num) from 
(select distinct F1.ID1 as num
from Friend F1, Highschooler H1
where F1.ID2 in
	(select distinct F2.ID2
	from Friend F2, Highschooler H2
	where F2.ID1 = H2.ID and H2.name = 'Cassandra')
	and H1.ID = F1.ID1 and H1.name <> 'Cassandra'
union all
select distinct F2.ID2 as num
	from Friend F2, Highschooler H2
	where F2.ID1 = H2.ID and H2.name = 'Cassandra') as D1;
	
	
#Q5  (1/1 point)
#Find the name and grade of the student(s) with the greatest number of friends. 
select name,grade 
from Highschooler,
	(select ID1, count(*) as num
	from Friend
	group by ID1) as D1
where ID = D1.ID1 and D1.num =
	(select max(D2.num)
	from 
		(select Friend.ID1, count(*) as num
		from Friend
		group by Friend.ID1) as D2
	);



#######################################################
##    Part VI: SQL Social-Network Nodification Ex    ##
#######################################################


# Find the link here:
# https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_mod/

#Q1  (1/1 point)
#It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 

delete from Highschooler
where grade = 12;

#Q2  (1/1 point)
#If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
delete from Likes 
where ID1 not in 
	(select L2.ID2 from Likes L2 where L2.ID1 = ID2)
	and ID1 in (select F1.ID2 from Friend F1 where F1.ID1=ID2);


#Q3  (1/1 point)
#For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 
insert into Friend 
select F1.iD1, F2.iD2 from Friend F1, Friend F2
where F1.iD2 = F2.iD1
and F1.iD1 <> F2.iD2
except 
select * from Friend;







