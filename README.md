# Automated ETL Pipeline with AWS, Apache NiFi, and Snowflake
This project demonstrates the creation of a fully automated ETL pipeline using AWS EC2, Apache NiFi, Jupyter Lab, and Snowflake. The pipeline automates data generation, transfer, storage, and transformation, making it scalable and efficient for handling large datasets. Here's a detailed breakdown of the architecture and its components:

## Pipeline Overview
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
	- **`Raw Data Table (customer_raw)`**:
		- This table stores the unmodified data fetched from S3. It acts as the staging area where the raw data remains unchanged until it is processed and moved to the next stages.
	- **`Current Records Table (customer)`**:
		- The customer table is designed to maintain the latest and most accurate records. It uses SCD1 (Slowly Changing Dimension Type 1) to update the current records by only inserting new or updated data from the customer_raw table. This ensures that only relevant and fresh data is retained, while older data is overwritten.
	- **`Historical Data Table (customer_history)`**:
		- The customer_history table is responsible for maintaining a log of all historical changes. It uses SCD2 (Slowly Changing Dimension Type 2) to track changes over time, ensuring that every modification or update to customer data is recorded with a timestamp and kept for historical reference.

## 5. Stream and Task for Automation
- **`Snowflake Stream`**:
	- A Stream is created on the customer table to track incremental changes. The stream captures any new or modified records, ensuring that only the relevant changes are identified and processed. This allows the system to keep the data updated automatically as new files are loaded and processed.
- **`Snowflake Task`**:
	- Tasks are used to automate the update process for both the customer and customer_history tables. The task ensures that as new data arrives in the customer_raw table and is inserted into the customer table, the corresponding changes are also reflected in the customer_history table. This automation keeps the entire data transformation pipeline seamless and efficient, running in real-time without manual intervention.

Together, the Stream and Task work to ensure that the updates are captured, transformed, and inserted into the tables automatically, maintaining the accuracy and historical integrity of the data.

## How It Works (Automated Flow)
- **`Data Generation`**:
	- The Python script in Jupyter Lab is run to generate synthetic data, which is saved as a CSV file on the EC2 instance.
- **`Data Transfer to S3`**:
	- The Apache NiFi workflow detects the new file in the local EC2 folder and automatically uploads it to an AWS S3 bucket.
- **`Snowpipe Load`**:
	- Once the file is in S3, Snowpipe automatically loads the data into Snowflake for further processing.
- **`Data Processing`**:
	- The data is processed into two tables: the current records table (customer using SCD1) and the historical data table (customer_history using SCD2).
	- The Snowflake Stream captures any incremental changes, while Snowflake Tasks automate the updates to both tables, ensuring real-time consistency and historical accuracy.

## Key Components
- **`AWS EC2 Instance`**
	- Provisioned as the foundation for running the Python script and hosting Apache NiFi and Jupyter Lab within Docker containers.
- **`Apache NiFi`**
	- Used for automating the data transfer from the EC2 instance to AWS S3, ensuring seamless integration and data flow.
- **`Jupyter Lab with Python`**
	- The Faker module is used within Jupyter Lab to generate synthetic datasets, which are then stored as CSV files in the EC2 instance for further processing.
- **`AWS S3`**
	- Acts as the temporary storage location for the CSV files before they are loaded into Snowflake via Snowpipe for further processing.
- **`Snowflake`**
	  - Used for storing and processing data with three main tables: 
	    - **`customer_raw`**: Stores the raw, unmodified data fetched from S3.
	    - **`customer`**: Maintains the current records using SCD1, updating the table with new or updated records.
	    - **`customer_history`**: Maintains historical records using SCD2, tracking all changes over time.
	  - Snowpipe loads data from S3 into Snowflake for processing.
	  - Streams and Tasks automate the management of data updates and historical tracking in real-time.

## Snowflake Tables and Workflow
- Raw Data Table (customer_raw)
	- Stores the raw, unmodified data fetched from S3 before any transformation or processing occurs.
- Current Records Table (customer)
	- Updates and maintains the latest records using SCD1 by inserting only new or updated records from the customer_raw table.
- Historical Data Table (customer_history)
	- Maintains historical records using SCD2, tracking all changes over time, ensuring data integrity and accurate historical tracking.
- Snowflake Stream
	- Tracks incremental changes in the customer table (current records), enabling the efficient handling and update of new or modified data.
- Snowflake Task
	- Automates the process of updating both the customer table and the customer_history table in real-time, ensuring continuous data flow and historical tracking without manual intervention.

## Automation Flow
- Data Generation:
	- The Python script in Jupyter Lab generates synthetic data and saves it to a folder on the EC2 instance.
- Data Transfer:
	- Apache NiFi detects new files in the local folder and uploads them to AWS S3.
- Data Load:
	- Snowpipe automatically loads the data from S3 into Snowflake for processing.
- Data Processing:
	- The Current Records Table and Historical Data Table are updated automatically via Snowflake Streams and Tasks, ensuring the latest data is always reflected in real-time.

## Technologies Used
- AWS EC2
- Docker
- Apache NiFi
- Jupyter Lab
- Python
- AWS S3
- Snowflake

## Setup Instructions
- AWS EC2 Instance:
	- Set up an AWS EC2 instance to host the project.
	- Install Docker and configure Apache NiFi and Jupyter Lab inside containers.
- Python and Faker Module:
	- Install the Faker module and configure the Python script to generate synthetic data.
- NiFi Workflow:
	- Set up the NiFi workflow to monitor the local folder and automatically transfer files to AWS S3.
- Snowflake Setup:
	- Configure Snowpipe for automatic data loading from S3 into Snowflake.
	- Create the necessary tables, streams, and tasks for automating data processing and maintaining historical records.

## Conclusion
This pipeline provides an efficient, automated solution for generating, storing, and processing synthetic data. By leveraging the power of AWS, Apache NiFi, and Snowflake, this project demonstrates the ease of integrating cloud storage, data transformation, and real-time updates to maintain a consistent and accurate dataset.





