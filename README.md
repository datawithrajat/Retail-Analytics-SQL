# Retail Sales Analytics using SQL

## Overview
This project analyzes retail transaction data to understand product performance, customer purchasing behavior, and sales trends using SQL. The project focuses on cleaning raw data and performing exploratory analysis to generate useful business insights.
The analysis is performed on retail datasets containing customer information, product inventory details, and sales transactions.

## Dataset
The project works with three datasets:
- Customers
- Products
- Sales Transactions

These datasets are used to analyze purchasing behavior, product demand, and sales performance.

## Data Cleaning
Before performing analysis, several data cleaning steps were completed to ensure the dataset was accurate and usable.

Cleaning steps included:
- Renaming tables for better readability
- Fixing encoding issues in column names
- Removing duplicate sales transactions
- Converting transaction date fields into proper date format
- Replacing missing customer location values

These steps help ensure the data is consistent and suitable for analysis.

## Analysis Performed

### Product Performance
Analyze which products generate the highest revenue and which products have low sales performance.

### Customer Transactions
Evaluate how frequently customers make purchases and identify high activity customers.

### Category Sales Performance
Understand how different product categories contribute to total sales.

### Top Revenue Products
Identify the top 10 products generating the highest revenue.

### Sales Trend Analysis
Analyze transaction data over time to understand revenue patterns and sales activity.

### Customer Segmentation
Customers are grouped based on total quantity purchased.

Segments used:
- Low (1–10 purchases)
- Medium (11–30 purchases)
- High (more than 30 purchases)

This helps understand different types of customers based on purchasing behavior.

## SQL Concepts Used
The project demonstrates several SQL techniques:
- Data Cleaning
- Aggregation Functions
- Joins
- Window Functions
- Common Table Expressions (CTEs)

These concepts are used to transform the data and extract insights from the retail dataset.
## Project File
retail_analytics.sql
This SQL script contains all queries used in the project, including data cleaning, transformations, and analytical queries.

## Tools Used
- SQL
- MySQL
- Data Analysis

## Key Insights
- A small number of products contribute a large portion of the total revenue.
- Some products show consistently low sales and may require marketing or pricing adjustments.
- Customer purchase frequency varies significantly across the dataset.
- A group of customers makes repeated purchases and contributes significantly to revenue.
- Sales trends provide useful information about transaction activity over time.

Retail-Analytics-SQL
│
├── README.md
├── retail_analytics.sql
│
└── dataset
    ├── customers.csv
    ├── products.csv
    └── sales.csv

## Author
datawithrajat  
Data Analytics Learner  
SQL | Excel | Power BI | Python
