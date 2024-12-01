# Automated ETL Pipeline with AWS, Apache NiFi, and Snowflake
This project demonstrates the creation of a fully automated ETL pipeline using AWS EC2, Apache NiFi, Jupyter Lab, and Snowflake. The pipeline automates data generation, transfer, storage, and transformation, making it scalable and efficient for handling large datasets. Here's a detailed breakdown of the architecture and its components:

# Pipeline Overview
The pipeline performs the following tasks:

## 1. Data Generation
- Jupyter Lab is used to generate synthetic data using the Faker module. The generated data is saved as a CSV file on the EC2 instance.
- This data generation process is triggered by running the Python script, and the output is stored in a local folder on EC2.
## 2. Data Transfer with Apache NiFi
- Apache NiFi is used to automate the transfer of CSV files from the local EC2 folder to an AWS S3 bucket.
- NiFi monitors the folder for new files, and whenever a new file is generated, it automatically fetches and uploads it to S3.
## 3. Data Loading with Snowpipe
- Snowpipe is configured to automatically load the files from the S3 bucket into Snowflake for further processing and analysis.
## 4. Data Processing in Snowflake
- The data processing in Snowflake is structured around three key tables, each serving a specific purpose to handle raw, current, and historical data:
#### 1. Raw Data Table (customer_raw):
- This table stores the unmodified data fetched from S3. It acts as the staging area where the raw data remains unchanged until it is processed and moved to the next stages.
#### 2. Current Records Table (customer):
- The customer table is designed to maintain the latest and most accurate records. It uses SCD1 (Slowly Changing Dimension Type 1) to update the current records by only inserting new or updated data from the customer_raw table. This ensures that only relevant and fresh data is retained, while older data is overwritten.
#### 3. Historical Data Table (customer_history):
- The customer_history table is responsible for maintaining a log of all historical changes. It uses SCD2 (Slowly Changing Dimension Type 2) to track changes over time, ensuring that every modification or update to customer data is recorded with a timestamp and kept for historical reference.

