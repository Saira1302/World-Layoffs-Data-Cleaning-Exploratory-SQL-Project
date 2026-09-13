SELECT * FROM layoffs;

-- 1. remove duplicates 
-- 2. strandardized the data
-- 3. null or blank values
-- 4. remove rows and columns that are unneccessary(creates a PROBLEM  if you are using raw data. deleting something from raw data makes things difficult) to avoid this create a new table
CREATE table  staged_layoffs
LIKE layoffs;
SELECT * from staged_layoffs;

Insert  staged_layoffs
select * from layoffs;

-- duplicate removal
SELECT *,
ROW_NUMBER() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,'date',country,funds_raised_millions,stage) as row_num
FROM staged_layoffs;

-- to remove duplicate
with duplicate_cte as(
SELECT *,
ROW_NUMBER() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,'date',country,funds_raised_millions, stage) as row_num
FROM staged_layoffs
)
SELECT * from duplicate_cte
where row_num>1;

-- for checking
SELECT * from staged_layoffs
where company='TikTok';

-- remove 1 row that is duplicate
with duplicate_cte as(
SELECT *,
ROW_NUMBER() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,'date',country,funds_raised_millions, stage) as row_num
FROM staged_layoffs
)
DELETE from duplicate_cte
where row_num>1;



CREATE TABLE `staged_layoffs3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * from staged_layoffs;
insert into  staged_layoffs3
SELECT *,
ROW_NUMBER() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,'date',country,funds_raised_millions, stage) as row_num
FROM staged_layoffs;

SELECT * from staged_layoffs3
where row_num >1;

-- delete 
DELETE from staged_layoffs3
where row_num >1;

SELECT * from staged_layoffs3;

SET SQL_SAFE_UPDATES = 0;



-- strandardizing data(finding issues in data and  fix it)

select company,trim(company)
from staged_layoffs3;
update staged_layoffs3
set company=trim(company);
select * from staged_layoffs3;

-- for industry

select distinct industry
from staged_layoffs3
order by 1;

select * from staged_layoffs3
where industry like 'crypto%'
;

update staged_layoffs3
set industry='crypto'
where industry like 'crypto%';

SELECT  distinct country, trim(trailing '.' from country) as trimed_country
from  staged_layoffs3
order by 1;
select * from  staged_layoffs3;

-- to remove duplicate country
update  staged_layoffs3
set country= trim(trailing '.' from country)
where country like 'United States%';

select country from staged_layoffs3;

-- change date column which is in text format into other format

select 'date',
STR_to_DATE('date','%m/%d/%Y')
from staged_layoffs3;


-- for null values
select * from staged_layoffs3
where total_laid_off is NULL
and percentage_laid_off is null;


select * from staged_layoffs3 
where industry is NULL
or industry='';

select * from staged_layoffs3 
where company='Airbnb';


select t1.industry,t2.industry
from  staged_layoffs3 t1
join staged_layoffs3 t2
on t1.company=t2.company
where(t1.industry is null or t1.industry='')
and t2.industry is not null;


update staged_layoffs3 t1
join staged_layoffs3 t2
on t1.company=t2.company
set t1.industry=t2.industry
where(t1.industry is null or t1.industry='')
and t2.industry is not null;


update staged_layoffs3 
set industry = NULL
where industry='';

select * from staged_layoffs3 where total_laid_off is null and percentage_laid_off is null;
delete from staged_layoffs3 where total_laid_off is null and percentage_laid_off is null;

select * from staged_layoffs3;

alter table  staged_layoffs3
drop column row_num;