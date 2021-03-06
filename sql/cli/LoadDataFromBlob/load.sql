IF SCHEMA_ID('DataLoad') IS NULL
EXEC ('CREATE SCHEMA DataLoad')
CREATE TABLE DataLoad.store_returns
(
    sr_returned_date_sk             bigint,
    sr_return_time_sk               bigint,
    sr_item_sk                      bigint           ,
    sr_customer_sk                  bigint,
    sr_cdemo_sk                     bigint,
    sr_hdemo_sk                     bigint,
    sr_addr_sk                      bigint,
    sr_store_sk                     bigint,
    sr_reason_sk                    bigint,
    sr_ticket_number                bigint           ,
    sr_return_quantity              integer,
    sr_return_amt                   float,
    sr_return_tax                   float,
    sr_return_amt_inc_tax           float,
    sr_fee                          float,
    sr_return_ship_cost             float,
    sr_refunded_cash                float,
    sr_reversed_charge              float,
    sr_store_credit                 float,
    sr_net_loss                     float
);
GO

CREATE MASTER KEY 
ENCRYPTION BY PASSWORD='MyComplexPassword00!';
GO

CREATE DATABASE SCOPED CREDENTIAL [https://xxxxxx.blob.core.windows.net/data/]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = '....';
GO

CREATE EXTERNAL DATA SOURCE dataset
WITH
(
    TYPE = BLOB_STORAGE,
    LOCATION = 'https://xxxxxx.blob.core.windows.net/data/',
    CREDENTIAL = [https://xxxxxx.blob.core.windows.net/data/]
);
GO

SET NOCOUNT ON -- Reduce network traffic by stopping the message that shows the number of rows affected
BULK INSERT DataLoad.store_returns -- Table you created in step 3
FROM 'dataset/store_returns/store_returns_1.dat' -- Within the container, the location of the file
WITH (
DATA_SOURCE = 'dataset' -- Using the external data source from step 6
,DATAFILETYPE = 'char'
,FIELDTERMINATOR = '\|'
,ROWTERMINATOR = '\|\n'
,BATCHSIZE=100000 -- Reduce network traffic by inserting in batches
, TABLOCK -- Minimize number of log records for the insert operation
);
GO

SELECT COUNT(*) FROM DataLoad.store_returns;
GO