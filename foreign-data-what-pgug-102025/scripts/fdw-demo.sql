-- postgres fdw
create extension postgre_fdw; 

create server remotedemo foreign data wrapper postgres_fdw options (host 'localhost', dbname 'demo');

create user mapping for postgres server remotedemo options (user 'postgres');

create foreign table airports
(  airport_code character(3),
    airport_name jsonb,
    city jsonb ,
    coordinates point
) server remotedemo
 OPTIONS (table_name 'airports_data', schema_name 'bookings');



--- schema 
CREATE SCHEMA IF NOT EXISTS demo_import; 

-- import whole schema to 
IMPORT FOREIGN SCHEMA bookings FROM SERVER foreign_server INTO demo_import;


-- oracle fdw

create server ora01 foreign data wrapper oracle_fdw
          options (dbserver '//ora01:1521/freepdb1');

grant usage on foreign server ora01 to postgres;          

create user mapping for postgres server ora01
          options (user 'CO', password 'Start123#');


CREATE FOREIGN TABLE customers (
          customer_id        integer  NOT NULL,
          email_address      character varying(255)  NOT NULL,
          full_name          character varying(255)  NOT NULL
       ) SERVER ora01 OPTIONS (schema 'CO', table 'CUSTOMERS');          
--- Oracle is upper case!!!




-- file fdws
CREATE SERVER file_fdw_test FOREIGN DATA WRAPPER file_fdw;

CREATE FOREIGN TABLE csv_test (
 id INT,
 message TEXT,
 randnrs BIGINT
)
SERVER file_fdw_test
OPTIONS (
   filename '/tmp/fdw_test.csv',
   format 'csv',
   header 'TRUE'
)


SELECT * FROM csv_test;



-- kafka fdw

CREATE FOREIGN TABLE kafka_data (
  key text,
  field1 text,
) SERVER kafka_server
  OPTIONS (
    topic 'postgres',
    bootstrap_servers '192.168.2.1:9092',
    offset 'beginning'
  );


