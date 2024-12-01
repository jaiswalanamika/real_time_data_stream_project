// create storage integration
create or replace storage integration s3_init
type = external_stage
storage_provider = s3
enabled = true
//Take this from the role under IAM
// In IAM: Create a role, add S3 permissions, and update the trust policy with external_id and user_arn.
storage_aws_role_arn = 'arn:aws:iam::448049805266:role/scd-project-role'
storage_allowed_locations = ('s3://snowflake-instacart-project-1/stream_data/')
comment = 'connection to s3';

desc integration s3_init;

// create file format for csv file
create or replace file format CSV_file_format
type = 'csv'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';



// creating external stage
create or replace stage scd_stage
url = 's3://snowflake-instacart-project-1/stream_data/'
storage_integration = s3_init
file_format = SNOWFLAKE_SCD_PROJECT.SCD.CSV_FILE_FORMAT

show stages;

list @SNOWFLAKE_SCD_PROJECT.SCD.SCD_STAGE;

create or replace pipe customer_s3_pipe
as
copy into customer_raw
from @scd_stage
file_format = CSV_file_format;

desc pipe customer_s3_pipe;

select * from customer_raw;

show pipes;

select SYSTEM$PIPE_STATUS('customer_s3_pipe');

TRUNCATE  customer_raw;

