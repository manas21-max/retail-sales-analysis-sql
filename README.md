# Retail Sales Analysis Using SQL

## Project Overview

This project analyzes an online retail transaction dataset using PostgreSQL to identify sales trends, top-performing products, valuable customers, and high-revenue markets.

The goal is to transform raw transaction data into meaningful business insights using SQL queries and data-quality checks.

## Tools & Technologies

- **Database:** PostgreSQL
- **SQL Environment:** pgAdmin 4
- **Version Control:** Git and GitHub

## Dataset

The project uses the [UCI Online Retail Dataset](https://archive.ics.uci.edu/dataset/352/online+retail), containing transactions from a UK-based online retailer.

- **Original records:** 541,909
- **Time period:** December 2010 – December 2011
- **Key fields:** Invoice number, product code, description, quantity, invoice date, unit price, customer ID, and country

## Project Workflow

### 1. Data Exploration
- Examined the dataset structure and transaction date range.
- Counted unique customers, products, and countries.
- Identified missing values and unusual transaction records.

### 2. Data Quality Analysis
- Investigated duplicate records.
- Examined cancelled invoices and negative quantities.
- Identified zero and negative prices.
- Investigated unusually high prices and non-product transaction codes.

### 3. SQL Analysis
- Calculated overall and monthly sales revenue.
- Ranked products by revenue and units sold.
- Identified the highest-revenue customers.
- Compared revenue across countries.

### 4. SQL Concepts Used
- Aggregate functions: `SUM()`, `COUNT()`, `MIN()`, `MAX()`
- Filtering with `WHERE` and aggregate `FILTER` clauses
- `GROUP BY` and `ORDER BY`
- Date functions: `DATE_TRUNC()`
- Subqueries and `CREATE OR REPLACE VIEW`
- Conditional aggregation and `COUNT(DISTINCT ...)`

## Initial Findings

- The original dataset contains 541,909 transaction rows.
- The exploratory analysis identified 4,372 distinct customer IDs, 4,070 product codes, and 38 countries.
- Monthly revenue varied throughout the observation period, with November 2011 appearing as the highest-revenue month in the initial analysis.
- The United Kingdom was the leading market by revenue in the initial country analysis.
- Data-quality checks identified missing customer IDs, duplicate records, cancelled invoices, and unusual prices.

*Note: These are exploratory findings. Revenue and rankings should be recalculated using the finalized analysis view before being treated as final business results.*

## Data Cleaning Approach

A separate SQL view named `standard_sales` was created to support standard sales analysis while preserving the original imported table.

The preliminary view excludes cancelled invoices, non-positive quantities, non-positive prices, missing product descriptions, and selected non-product transaction codes.

These rules are analytical assumptions and may require further refinement. Returns, cancellations, discounts, postage, and accounting adjustments should be analyzed separately when appropriate.

## Project Structure

- `retail_sales_analysis.sql` — SQL queries for exploration, data-quality checks, view creation, and business analysis.
- `README.md` — Project documentation.

## Key Learnings

- Writing SQL queries to investigate real-world transaction data.
- Identifying data-quality issues before analysis.
- Using aggregate functions, subqueries, and views to answer business questions.
- Translating transaction data into actionable business insights.

## Future Improvements

- Validate and refine data-cleaning rules.
- Add customer segmentation and repeat-purchase analysis.
- Analyze returns and cancellations separately.
- Build a Power BI dashboard to visualize sales trends.

## Author

Manas Khare

[GitHub Profile](https://github.com/manas21-max)
