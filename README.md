# ProjectPortfolio
Readme for SQL Script 1: "COVID_Analysis.sql"
Purpose
This SQL script aims to analyze COVID-19 data. It includes various queries to extract meaningful insights from the data.

Queries and Functions
Data Retrieval and Ordering

Purpose: Retrieve COVID-19 data from the CovidDeaths table and order it by specified columns.
Function: Basic data retrieval and ordering.
Data Selection for Analysis

Purpose: Select specific columns of COVID-19 data for further analysis.
Function: Basic data selection.
Analyzing Death Percentage for the United States

Purpose: Determine the date with the highest death percentage in the United States.
Function: CASE function for conditional transformation.
Analyzing Infection Rates

Purpose: Calculate the percentage of population infected and sort by the highest infection percentage.
Functions: MAX function for finding the maximum value, GROUP BY for grouping data, and mathematical calculations.
Identifying Countries with Highest Death Count per Population

Purpose: Identify countries with the highest death count per population.
Functions: MAX function for finding the maximum value and GROUP BY for grouping data.
Analyzing Global Deaths per Cases

Purpose: Calculate the percentage of deaths per cases globally on each date.
Functions: SUM function for aggregating data and mathematical calculations.
Analyzing Population vs. Vaccinations

Purpose: Analyze total population vs. vaccinations and calculate rolling total for new vaccinations.
Functions: Common Table Expression (CTE) for temporary result set and SUM function for cumulative calculations.
Creating a Temporary Table for Vaccination Data

Purpose: Create and use a temporary table to store and analyze vaccination data.
Functions: Temporary table creation and INSERT INTO for data insertion.
Creating a View for Data Storage

Purpose: Create a view to store data for later visualizations.
Function: View creation.
Retrieving Data from the View

Purpose: Retrieve data from the created view.
Function: Basic data retrieval.
Usage
To use this script, follow these steps:

Connect to the Nashville Housing database.
Execute each query individually or as needed.
Review the results and insights generated by the queries.
Readme for SQL Script 2: "Data_Cleaning.sql"
Purpose
This SQL script focuses on cleaning and transforming data within the Nashville Housing database.

Queries and Functions
Data Cleaning - Date Conversion

Purpose: Convert the SaleDate column to a Date data type.
Function: Conversion using the CONVERT function.
Data Cleaning - Property Address Handling

Purpose: Handle missing PropertyAddress values through self-joins and ParcelID.
Functions: Self-joins, ISNULL function, and UPDATE statements.
Data Transformation - Address Splitting

Purpose: Split PropertyAddress into individual columns for address and city.
Functions: Substring and ALTER TABLE for column addition and UPDATE statements.
Data Transformation - Owner Address Splitting

Purpose: Split OwnerAddress into separate columns for address, city, and state.
Functions: ParseName function, ALTER TABLE for column addition, and UPDATE statements.
Data Transformation - 'SoldAsVacant' Mapping

Purpose: Map 'Y' to 'Yes' and 'N' to 'No' in the 'SoldAsVacant' column.
Functions: CASE function and UPDATE statements.
Data Cleaning - Removing Duplicate Rows

Purpose: Remove duplicate rows based on specified columns.
Functions: Common Table Expression (CTE) for temporary result set and DELETE statement.
Data Cleaning - Dropping Unused Columns

Purpose: Drop specific columns from the table.
Function: ALTER TABLE DROP COLUMN statement.