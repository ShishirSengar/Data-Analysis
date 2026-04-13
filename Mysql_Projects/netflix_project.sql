-- Netflix Project

-- create tables
create table netflix(
	show_id varchar(6),	
	type varchar(10),	
	title varchar(150),	
	director varchar(209),	
	casts varchar(1000),	
	country varchar(200),	
	date_added varchar(50),	
	release_year int,	
	rating varchar(10),	
	duration varchar(15),	
	listed_in varchar(100),	
	description varchar(250)
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

SET sql_mode='';

-- Source - https://stackoverflow.com/a/68412491
-- Posted by NcXNaV
-- Retrieved 2026-04-12, License - CC BY-SA 4.0

LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Downloads/netflix_titles.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Problem Statements
-- 1. Count the number of Movies vs TV Shows.
select type, count(*) as total_content from netflix 
group by type;


-- 2. Find the most common rating for movies and TV shows.
select type, rating from
(
select type, rating, count(*) as count,
rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by type, rating
) t
where t.ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020).
select * from netflix 
where type = 'Movie' and release_year = 2020;


-- 4. Identify the longest movies
select * from netflix 
where type = 'Movie' and duration = (select max(duration) from netflix);


-- 5. Find content added in the last 5 years.
select * from netflix
where  str_to_date(date_added, '%M %d, %Y') >= curdate() - interval 5 year;


-- 6. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix where director like '%Rajiv Chilaka%';


-- 7. List all TV shows with more than 5 seasons.
SELECT *
from netflix
where SUBSTRING_INDEX(duration, ' ', 1) > 5 and type = 'TV Show';


/*
   8. Find each year and the average numbers of content release in India on netflix. 
   return top 5 year with highest avg content release!
*/
select 
extract(year from str_to_date(date_added, '%d-%b-%y')) as 'Year',
count(*) as yearly_content,
round(count(*) / (select count(*) from netflix where country = 'India' ) * 100 , 22 ) as avg_content_per_year
from netflix
where country ='India'
group by 1;


-- 9. List all movies that are documentaries.
select * from netflix 
where listed_in like '%documentaries%';


-- 10. Find all content without a director.
select * from netflix
where director is null;


-- 11. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix 
where casts like '%salman khan%'
and release_year > extract(year from current_date()) - 10;


-- 12. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
    TRIM(jt.actor) AS actor,
    COUNT(*) AS total_content
FROM netflix n,
JSON_TABLE(
    CONCAT('["', REPLACE(n.casts, ',', '","'), '"]'),
    '$[*]' COLUMNS (actor VARCHAR(255) PATH '$')
) AS jt
WHERE LOWER(n.country) LIKE '%india%'
GROUP BY actor
ORDER BY total_content DESC
LIMIT 10;


/*
13.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/
with label as 
(
select *,
case 
	when description like '%kill%' or
		 description like '%violence%' then 'Bad'
		 else 'Good'
	end 'Category'
from netflix
)
select Category, count(*) as total_content
from label
group by Category;