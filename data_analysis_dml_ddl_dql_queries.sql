/*SELECT * FROM netflix_raw
ORDER BY netflix_raw.title

DROP TABLE public.netflix_raw


-- handling foreign characters
CREATE TABLE public.netflix_raw (
	show_id varchar(10) PRIMARY KEY,
	"type" varchar(10) NULL,
	title varchar(200) NULL,
	director varchar(250) NULL,
	"cast" varchar(1000) NULL,
	country varchar(150) NULL,
	date_added varchar(20) NULL,
	release_year int NULL,
	rating varchar(10) NULL,
	duration varchar(10) NULL,
	listed_in varchar(100) NULL,
	description varchar(500) NULL
);

SELECT * FROM netflix_raw
WHERE show_id = 's5023';


-- remove duplicates
SELECT show_id, COUNT(*) -- no duplicates for show_id
FROM netflix_raw
GROUP BY show_id 
HAVING COUNT(*) > 1;

SELECT * FROM netflix_raw   -- checking duplicates for titles
WHERE (UPPER(title), type)  IN (
		SELECT UPPER(title), type
		FROM netflix_raw
		GROUP BY UPPER(title), type
		HAVING COUNT(*) > 1)
ORDER BY title;


SELECT UPPER(title), COUNT(*) -- need to use UPPER() because postgre by default is case sensitive
FROM netflix_raw
GROUP BY UPPER(title)
HAVING COUNT(*) > 1


WITH cte AS(
	SELECT * 
	, ROW_NUMBER() OVER(PARTITION BY UPPER(title), type
	ORDER BY show_id) AS rn
	FROM netflix_raw
)
SELECT * FROM cte
WHERE rn = 1;*/		-- final result of handling duplicates using cte



--- new table for listed in, director, country, cast.
-- for directors:
CREATE TABLE netflix_directors AS
SELECT show_id, TRIM(director_name) AS director
FROM netflix_raw,
LATERAL unnest(string_to_array(director, ',')) AS director_name;

SELECT * FROM netflix_directors

-- for country
CREATE TABLE netflix_country AS
SELECT show_id, TRIM(country_name) AS country
FROM netflix_raw,
LATERAL unnest(string_to_array(country, ',')) AS country_name;

SELECT * FROM netflix_country

-- for listed_in
CREATE TABLE netflix_genre AS
SELECT show_id, TRIM(genre_name) AS genre
FROM netflix_raw,
LATERAL unnest(string_to_array(listed_in, ',')) AS genre_name;

SELECT * FROM netflix_genre

-- for cast
CREATE TABLE netflix_cast AS
SELECT show_id, TRIM(cast_name) AS cast
FROM netflix_raw,
LATERAL unnest(string_to_array(netflix_raw.cast, ',')) AS cast_name;

SELECT * FROM netflix_cast





--- data type conversions for date added.
--- populate missing values in country, duration columns.
-- for country
INSERT INTO netflix_country 
SELECT show_id, m.country
FROM netflix_raw nr
INNER JOIN (
	SELECT nd.director, nc.country
	FROM netflix_country nc
	INNER JOIN netflix_directors nd
	ON nc.show_id = nd.show_id
	GROUP BY director, country
) m ON nr.director = m.director 
WHERE nr.country IS NULL

SELECT * FROM netflix_country WHERE show_id = 's1001' 

SELECT nd.director, nc.country
FROM netflix_country nc
INNER JOIN netflix_directors nd
ON nc.show_id = nd.show_id
GROUP BY director, country

-- for duration
SELECT * FROM netflix_raw
WHERE duration IS NULL

--- populate rest of the nulls as not_available.
--- drop columns director, listed_in, country, cast.
CREATE TABLE netflix AS
WITH cte AS(
	SELECT * 
	, ROW_NUMBER() OVER(PARTITION BY UPPER(title), type
	ORDER BY show_id) AS rn
	FROM netflix_raw
)
SELECT show_id, type, title, CAST(date_added AS date) AS date_added, release_year,
		rating,
		CASE
			WHEN duration IS NULL THEN rating
			ELSE duration  
		END AS duration, description
FROM cte;

SELECT * FROM netflix;




-- NETFLIX DATA ANALYSIS

-- 1: For each director count the no. of movies and tv shows created by director in separate columns?
SELECT nd.director,
		COUNT(DISTINCT CASE WHEN n."type" = 'Movie' THEN n.show_id END) AS no_of_movie,
		COUNT(DISTINCT CASE WHEN n."type" = 'TV Show' THEN n.show_id END) AS no_of_tvshow
FROM netflix n 
INNER JOIN netflix_directors nd
ON n.show_id = nd.show_id
GROUP BY nd.director
HAVING COUNT(DISTINCT n."type") > 1;


-- 2: Which country has highest number of comedy movies?
SELECT nc.country,
		COUNT(DISTINCT ng.show_id) AS no_of_comedy_movies
FROM netflix_genre ng
INNER JOIN netflix_country nc
ON ng.show_id = nc.show_id
	INNER JOIN netflix n
	ON ng.show_id = n.show_id
WHERE n."type" = 'Movie' AND ng.genre = 'Comedies'
GROUP BY nc.country
ORDER BY no_of_comedy_movies DESC
-- LIMIT 1;


-- 3: For each year (as per date added to netflix), which director has maximum number of movies released?
WITH cte AS (
	SELECT nd.director, EXTRACT(YEAR FROM n.date_added) AS date_year, COUNT(n.show_id) AS no_of_movies_released
	FROM netflix n
	INNER JOIN netflix_directors nd
	ON n.show_id = nd.show_id
	WHERE n."type" = 'Movie'
	GROUP BY nd.director, date_year
)
, cte2 AS (
	SELECT *,
			ROW_NUMBER() OVER (PARTITION BY date_year
								ORDER BY no_of_movies_released DESC, director) AS rn
	FROM cte
)
SELECT * FROM cte2 WHERE rn = 1
ORDER BY no_of_movies_released DESC; -- as per date_added



-- 4: What is average duration of movies in each genre?
SELECT ng.genre, AVG(CAST(REPLACE(n.duration, ' min', '') AS int)) AS avg_duration
FROM netflix n 
INNER JOIN netflix_genre ng
ON n.show_id = ng.show_id
WHERE n."type" = 'Movie'
GROUP BY ng.genre



-- 5: Find the list of directors who have created horror and comedy movies both.
-- Dislay director names along with number of comedy and horror movies directed by them.
SELECT nd.director,
		COUNT(DISTINCT CASE WHEN ng.genre = 'Comedies' THEN n.show_id END) AS no_of_comedy_movies,
		COUNT(DISTINCT CASE WHEN ng.genre = 'Horror Movies' THEN n.show_id END) AS no_of_horror_movies
FROM netflix n 
INNER JOIN netflix_genre ng ON n.show_id = ng.show_id
INNER JOIN netflix_directors nd ON n.show_id = nd.show_id
WHERE n."type" = 'Movie' AND ng.genre IN ('Comedies', 'Horror Movies')
GROUP BY nd.director
HAVING COUNT(DISTINCT ng.genre) = 2;





















