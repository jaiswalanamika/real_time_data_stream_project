merge into customer c // target table
using customer_raw cr // source table
on c.customer_id = cr.customer_id
when matched and c.CUSTOMER_ID <> cr.CUSTOMER_ID or //when any update comes
	c.FIRST_NAME <> cr.FIRST_NAME or
	c.LAST_NAME <> cr.LAST_NAME or
	c.EMAIL <> cr.EMAIL or
	c.STREET <> cr.STREET or
	c.CITY <> cr.CITY or
	c.STATE <> cr.STATE or
	c.COUNTRY <> cr.COUNTRY then update
set c.CUSTOMER_ID = cr.CUSTOMER_ID,
	c.FIRST_NAME = cr.FIRST_NAME,
	c.LAST_NAME = cr.LAST_NAME,
	c.EMAIL = cr.EMAIL,
	c.STREET = cr.STREET,
	c.CITY = cr.CITY,
	c.STATE = cr.STATE,
	c.COUNTRY = cr.COUNTRY,
    UPDATE_TIMESTAMP = current_timestamp()
when not matched then insert               // when any new record insert
(c.customer_id, c.first_name, c.last_name, c.email, c.street, c.city, c.state, c.country)
values (cr.customer_id, cr.first_name, cr.last_name, cr.email, cr.street, cr.city, cr.state, cr.country);

create or replace procedure scd_1_proc()
return string not null
language javascript
as
    $$
        var cmd = 'merge into customer c // target table
                    using customer_raw cr // source table
                    on c.customer_id = cr.customer_id
                    when matched and c.CUSTOMER_ID <> cr.CUSTOMER_ID or //when any update comes
                    	c.FIRST_NAME <> cr.FIRST_NAME or
                    	c.LAST_NAME <> cr.LAST_NAME or
                    	c.EMAIL <> cr.EMAIL or
                    	c.STREET <> cr.STREET or
                    	c.CITY <> cr.CITY or
                    	c.STATE <> cr.STATE or
                    	c.COUNTRY <> cr.COUNTRY then update
                    set c.CUSTOMER_ID = cr.CUSTOMER_ID,
                    	c.FIRST_NAME = cr.FIRST_NAME,
                    	c.LAST_NAME = cr.LAST_NAME,
                    	c.EMAIL = cr.EMAIL,
                    	c.STREET = cr.STREET,
                    	c.CITY = cr.CITY,
                    	c.STATE = cr.STATE,
                    	c.COUNTRY = cr.COUNTRY,
                        UPDATE_TIMESTAMP = current_timestamp()
                    when not matched then insert               // when any new record insert
                    (c.customer_id, c.first_name, c.last_name, c.email, c.street, c.city, c.state, c.country)
                    values (cr.customer_id, cr.first_name, cr.last_name, cr.email, cr.street, cr.city, cr.state, cr.country);
                    '
            var cmd1 = "truncate table SNOWFLAKE_SCD_PROJECT.SCD.CUSTOMER_RAW;"
            var sql = snowflake.createStatement({sqlText: cmd});
            var sql1 = snowflake.createStatement({sqlText: cmd1});
            va result = sql.execute();
            var result1 = sql1.execute();
            return cmd+'\n'+cmd1;
            $$;

call scd_1_proc();

-- setup TASKADMIN role
use role securityadmin;
create or replace role taskadmin;

-- Set the active role to ACCOUNTADMIN before granting the EXECUTE TASK privilege to TASKADMIN
use role acconutadmin;
grant execute task on account to role taskadmin;

-- Set the active role to SECURITYADMIN to show that this role can grant a role to another role 
use role securityadmin;
grant role taskadmin to role sysadmin;

create or replace task tsk_scd_raw warehouse = COMPUTE_WH schedule = '1 minute'
ERROR_ON_NONDETERMINISTIC_MERGE=FALSE
as
call scd_1_proc();
show tasks;
alter task tsk_scd_raw suspend;--resume --suspend
show tasks;

select timestampdiff(second, current_timestamp, scheduled_time) as next_run, scheduled_time, current_timestamp, name, state 
from table(information_schema.task_history()) where state = 'SCHEDULED' order by completed_time desc;

select * from customer where customer_id=0;

    
	