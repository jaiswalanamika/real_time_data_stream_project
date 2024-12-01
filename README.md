# Automated ETL Pipeline with AWS, Apache NiFi, and Snowflake
This project demonstrates the creation of a fully automated ETL pipeline using AWS EC2, Apache NiFi, Jupyter Lab, and Snowflake. The pipeline automates data generation, transfer, storage, and transformation, making it scalable and efficient for handling large datasets. Here's a detailed breakdown of the architecture and its components:

# Pipeline Overview
The pipeline performs the following tasks:

## 1. Data Generation
	- Jupyter Lab is used to generate synthetic data using the Faker module. The generated data is saved as a CSV file on the EC2 instance.
 	- This data generation process is triggered by running the Python script, and the output is stored in a local folder on EC2.


