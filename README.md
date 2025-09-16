# Netflix Data Cleaning and Analysis Project | End to End ELT Project (SQL + Python)

An end-to-end Data Engineering project on Netflix dataset implementing ELT (Extract, Load, Transform) using PostgreSQL and Python. It focuses on data cleaning, data manipulation, transformation, and analysis to derive meaningful insights.
## Introduction
This project demonstrates an End-to-End Data Engineering pipeline on the Netflix dataset using Python and PostgreSQL. It covers the complete ELT (Extract, Load, Transform) process, including data extraction, cleaning (handling foreign characters, removing duplicates, filling missing values, type conversions), and transformation (creating tables, dropping unnecessary columns). Using advanced SQL techniques such as Joins, Aggregate, Window, and Built-in Functions, the project delivers meaningful data analysis and serves as a practical reference for ETL workflows, data cleaning, and real-world database management.

## Workflow / ELT Pipeline
![End to End ELT Project ](https://github.com/user-attachments/assets/dc79ddf8-ad06-4687-98e3-7437e13934eb)

## :bar_chart: Insights Required
The goal of this project is to analyze the Netflix dataset and extract meaningful business insights by answering the following key questions:
- Count the number of movies and TV shows created by each director (in separate columns).
- Identify the country with the highest number of comedy movies.
- For each year (based on date added), find the director with the maximum number of movies released.
- Calculate the average duration of movies in each genre.
- List the directors who created both horror and comedy movies, along with the count of each.

> [!NOTE]
> If anyone wants to see Netflix Data Analysis, All data analysis questions are present at the bottom of the SQL script. You can view by clicking on this [Netflix Data Analysis](https://github.com/muhammadrauhan/End-to-End-Data-Engineering-Project/blob/main/data_analysis_dml_ddl_dql_queries.sql).

## :key: Key Features / Highlights
- **End-to-End ELT Workflow:** Implemented Extract, Load, and Transform pipeline using Python and PostgreSQL.
- **Database Integration:** Established secure connections and executed queries directly from Python.
- **Data Cleaning:** Removed duplicates, handled foreign characters, populated missing values, and standardized null entries.
- **Schema Design & Transformation:** Created new tables, converted data types, and dropped unnecessary columns for a clean dataset.
- **Advanced SQL Operations:** Applied DDL, DML, and DQL queries including Joins, Aggregate Functions, Window Functions, and Built-in Functions.
- **Data Analysis:** Conducted meaningful insights on Netflix dataset using optimized SQL queries.
- **Practical Use Case:** Demonstrates real-world data engineering and data analysis best practices with open-source tools.

## :hammer_and_wrench: Data Preprocessing & Transformation Steps
Here I explain the data preprocessing and transformation process applied to the Netflix dataset such as schema setup, restructuring tables, column modifications, handling missing values and duplicates, supported with screencshots for better understanding.

- ### Data Check

  <div align="center">
    <img width="655" height="186" alt="data check" src="https://github.com/user-attachments/assets/9cab34a0-dc1e-4142-854f-57a47b3a7bdc" />
  </div>

  In this above mentioned picture, We can clearly see in the `title` column the value was ambiguous because of the unstructured schema I got and datatype. I handled this by transforming the schema which you can see in the picture below.

- ### Schema Setup
  <div align="center">
    <table>
      <tr>
        <td align="center" style="padding:10px;">
          <img src="https://github.com/user-attachments/assets/6176da2c-7da5-43cb-beb6-16051b3918e1" alt="Schema before" width="260" height="190" style="display:block;" />
          <div style="font-weight:bold; margin-top:6px;">Raw Schema</div>
        </td>
        <td align="center" style="padding:10px;">
          <img src="https://github.com/user-attachments/assets/0bc3a159-7416-47dc-abd8-f47337809309" alt="schema after" width="260" height="190" style="display:block;" />
          <div style="font-weight:bold; margin-top:6px;">Transformed Schema</div>
        </td>
      </tr>
    </table>
  </div>

- ### Checking Duplicates in Raw Table
  There were some duplicates in `netflix_raw` table. I checked for `title` column. So I solved the duplicates issue using CTE (Common Tbale Expression).
  
  <div align="center">
    <img width="703" height="398" alt="final-result-duplicates" src="https://github.com/user-attachments/assets/f91c4780-78ad-40c4-96fa-06521bf5a4b1" />
  </div>
  
  
- ### Handling Missing Values
  There were some missing values in `netflix_raw` table.
  - #### Handled Missing Values in `country`:
    I handled `country` column which I had inserted in new country column called `netflix_country` for further analysis.
    <div align="center">
      <img width="685" height="355" alt="populate-na-countries" src="https://github.com/user-attachments/assets/47ef349c-4bed-4e44-aa24-d1660c06aff1" />
    </div>

  - #### Handled Missing Values in `duration` column:
    I handled missing values column which is `duration` table, data type coversion for `date_added` column and drop `director`, `listed_in`, `country` and `cast` columns for final `netflix` table.
    
    <div align="center">
      <img width="716" height="395" alt="final-netflix" src="https://github.com/user-attachments/assets/06fa403f-cc33-4db8-a6eb-5dec98a00ee9" />
    </div>
    
- ### Creation of New Tables

  <div align="center">
    <img width="869" height="421" alt="new-tables" src="https://github.com/user-attachments/assets/7009bc86-fc72-4917-b669-4f7b0560e699" />
  </div>
