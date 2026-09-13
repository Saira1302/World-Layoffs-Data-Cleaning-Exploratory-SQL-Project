# 🌍 World Layoffs Data Cleaning & & Exploratory with SQL

## 📌 Project Overview

This project focuses on **cleaning and preparing a World Layoffs dataset using MySQL**.

The project demonstrates how raw data can be transformed into a cleaner and more consistent dataset before performing further analysis.

Instead of modifying the original raw dataset directly, a **staging table** was created and used throughout the cleaning process. This helps preserve the original data while allowing transformations to be performed safely.

---

## 🎯 Project Objectives

The main objectives of this project are to:

* Create a staging table from the raw dataset
* Identify and remove duplicate records
* Standardize inconsistent data
* Clean company names
* Standardize industry values
* Clean country values
* Handle NULL and blank values
* Identify records with missing information
* Remove unnecessary records
* Prepare the dataset for further analysis

---

## 🗂️ Dataset

The dataset contains information about layoffs across different companies, industries, locations, and countries.

Key columns include:

* `company`
* `location`
* `industry`
* `total_laid_off`
* `percentage_laid_off`
* `date`
* `stage`
* `country`
* `funds_raised_millions`

---

## 🧹 Data Cleaning Process

### 1. Creating a Staging Table

The original `layoffs` table was preserved by creating a separate staging table.

```sql
CREATE TABLE staged_layoffs
LIKE layoffs;

INSERT INTO staged_layoffs
SELECT * FROM layoffs;
```

This allows the raw dataset to remain unchanged while cleaning is performed on the copied data.

---

### 2. Identifying Duplicate Records

Duplicate records were identified using the `ROW_NUMBER()` window function.

The following columns were used to identify potential duplicates:

* Company
* Location
* Industry
* Total layoffs
* Percentage laid off
* Date
* Country
* Funds raised
* Company stage

```sql
ROW_NUMBER() OVER(
    PARTITION BY company,
                 location,
                 industry,
                 total_laid_off,
                 percentage_laid_off,
                 date,
                 country,
                 funds_raised_millions,
                 stage
) AS row_num
```

Records with `row_num > 1` were identified as duplicates.

---

### 3. Removing Duplicates

A separate staging table was created with the `row_num` column to identify and remove duplicate records.

```sql
DELETE FROM staged_layoffs3
WHERE row_num > 1;
```

After removing duplicates, the temporary `row_num` column was dropped.

```sql
ALTER TABLE staged_layoffs3
DROP COLUMN row_num;
```

---

### 4. Standardizing Company Names

Extra spaces in company names were removed using `TRIM()`.

```sql
UPDATE staged_layoffs3
SET company = TRIM(company);
```

This ensures that companies with accidental leading or trailing spaces are stored consistently.

---

### 5. Standardizing Industry Values

Different variations of the same industry were identified using `DISTINCT` and pattern matching.

For example, variations beginning with `crypto` were standardized to:

```text
crypto
```

using:

```sql
UPDATE staged_layoffs3
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';
```

---

### 6. Cleaning Country Names

Country values were checked for inconsistencies such as unnecessary punctuation.

For example, trailing periods were removed from country names:

```sql
UPDATE staged_layoffs3
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
```

This helps ensure consistent country names throughout the dataset.

---

### 7. Handling NULL and Blank Values

Missing values were investigated in important columns such as:

* `industry`
* `total_laid_off`
* `percentage_laid_off`

Blank industry values were first identified and then converted to `NULL`.

```sql
UPDATE staged_layoffs3
SET industry = NULL
WHERE industry = '';
```

---

### 8. Filling Missing Industry Values

Missing industry values were compared with other records belonging to the same company.

A self join was used to find cases where one record had a missing industry but another record for the same company contained industry information.

```sql
UPDATE staged_layoffs3 t1
JOIN staged_layoffs3 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
```

This allows existing information within the dataset to be used to fill missing values.

---

### 9. Removing Records Without Layoff Information

Records where both `total_laid_off` and `percentage_laid_off` were missing were identified.

Since these records do not provide useful layoff information, they were removed:

```sql
DELETE FROM staged_layoffs3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```

---

## 🧠 SQL Concepts Used

This project demonstrates practical use of:

* `SELECT`
* `CREATE TABLE`
* `INSERT INTO`
* `UPDATE`
* `DELETE`
* `ALTER TABLE`
* `TRIM()`
* `DISTINCT`
* `LIKE`
* `WHERE`
* `JOIN`
* Self Joins
* Common Table Expressions (CTEs)
* Window Functions
* `ROW_NUMBER()`
* NULL handling
* Data standardization
* Data cleaning

---

## 🔄 Data Cleaning Workflow

```text
Raw Layoffs Data
       ↓
Create Staging Table
       ↓
Identify Duplicates
       ↓
Remove Duplicates
       ↓
Standardize Company Names
       ↓
Standardize Industries
       ↓
Clean Country Values
       ↓
Handle NULL / Blank Values
       ↓
Fill Missing Industry Data
       ↓
Remove Unnecessary Records
       ↓
Clean Dataset
```

---

## 🛠️ Tools Used

* **MySQL**
* **SQL**
* **GitHub**

---

## 📈 Project Outcome

The main outcome of this project is a **cleaner and more consistent layoffs dataset** that can be used for further exploratory analysis and visualization.

The project demonstrates the importance of data cleaning before analysis and provides practical experience with SQL techniques used in real world data preparation.

---


Interested in Data Analysis, Business Intelligence, Machine Learning, Digital Marketing, and SEO.
