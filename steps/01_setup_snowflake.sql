USE ROLE ACCOUNTADMIN;

CREATE OR ALTER WAREHOUSE QUICKSTART_WH 
  WAREHOUSE_SIZE = XSMALL 
  AUTO_SUSPEND = 300 
  AUTO_RESUME= TRUE;


-- Separate database for git repository
CREATE OR ALTER DATABASE QUICKSTART_COMMON;

--Added comment to check deployment 
--Added comment2 to check deployment 


-- API integration is needed for GitHub integration
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/ank-guhe') -- INSERT YOUR GITHUB USERNAME HERE
  ENABLED = TRUE;


-- Git repository object is similar to external stage
CREATE OR REPLACE GIT REPOSITORY quickstart_common.public.quickstart_repo
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/ank-guhe/sfguide-getting-started-with-snowflake-devops';


CREATE OR ALTER DATABASE QUICKSTART_PROD; 

--new comment

-- To monitor data pipeline's completion
CREATE OR REPLACE NOTIFICATION INTEGRATION email_integration
  TYPE=EMAIL
  ENABLED=TRUE;


-- Database level objects
CREATE OR ALTER SCHEMA bronze;
CREATE OR ALTER SCHEMA silver;
CREATE OR ALTER SCHEMA gold;


-- Schema level objects
CREATE OR REPLACE FILE FORMAT bronze.json_format TYPE = 'json';
CREATE OR ALTER STAGE bronze.raw;


-- Copy file from GitHub to internal stage
copy files into @bronze.raw from @quickstart_common.public.quickstart_repo/branches/main/data/airport_list.json;

