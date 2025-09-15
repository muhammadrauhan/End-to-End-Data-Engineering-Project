SELECT * FROM netflix_raw
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
WHERE rn = 1;		-- final result of handling duplicates using cte
