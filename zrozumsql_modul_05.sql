--modul 5 - Data Manipulation LANGUAGE: INSERT, DELETE, UPDATE, 

------------------
--INSERT


DROP TABLE IF EXISTS products;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

-- INSERT
INSERT INTO products (id, product_name, product_code, product_quantity, manufactured_date, added_by) 
				VALUES (1, 'Product 1', 'PRD1', 100, '2019-11-30', NULL  );
     
SELECT * FROM PRODUCTS 			
	 		 
SHOW datestyle;	 		

-- WIECEJ: https://www.postgresql.org/docs/12/datatype-datetime.html


-- INSERT 6 -- VALUES
INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '20/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2019')
 	 		
 	 		
 --------------------------
 --DELETE
 	 		
DROP TABLE IF EXISTS products;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '20/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2019')
; 					  

-- DELETE
DELETE FROM products;

SELECT * FROM products;

-- AUTOCOMMIT AND OTHER USER VIEW

-- DELETE WHERE
DELETE FROM products 
      WHERE product_code = 'PRD1' 
			AND 
			product_name = 'Product 0';

DELETE FROM products 
	  WHERE product_code = 'PRD1' 
	     OR product_name = 'Product 2';
	    
DELETE FROM products 
      WHERE product_code IN ('PRD1', 'PRD2');
     
DELETE FROM products 
      WHERE product_code NOT IN ('PRD1', 'PRD2');
      

------------------------------
--UPDATE
     
DROP TABLE IF EXISTS products;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '20/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2019')
; 					  

-- UPDATE
UPDATE products SET product_quantity = 100;

SELECT * FROM products;

-- 
DELETE FROM products;

-- UPDATE WHERE
UPDATE products
   SET product_quantity = 99.98
 WHERE product_code = 'PRD1' 
   	   AND 
	   product_name = 'Product 0';

UPDATE products 
   SET product_quantity = 99.98
 WHERE product_code = 'PRD1' 
	   OR 
	   product_name = 'Product 2';

SELECT * FROM products;
	  
UPDATE products 
   SET product_quantity = 99.98
 WHERE product_code IN ('PRD1', 'PRD2');
     
UPDATE products 
   SET product_quantity = 99.98
 WHERE product_code NOT IN ('PRD1', 'PRD2');


SELECT ctid, * FROM products;


------------------------------------
-- MERGE 
CREATE TABLE stock (item_id int UNIQUE, balance int);

INSERT INTO stock VALUES (10, 2200);
INSERT INTO stock VALUES (20, 1900);

CREATE TABLE buy (item_id int, volume int);

INSERT INTO buy values(10, 1000);
INSERT INTO buy values(30, 300);

MERGE INTO stock s
     USING buy b
        ON s.item_id = b.item_id
 WHEN MATCHED THEN UPDATE SET balance = balance + b.volume
 WHEN NOT MATCHED THEN INSERT VALUES (b.item_id, b.volume);

DROP TABLE stock_buy;

CREATE TABLE stock_buy (
	item_id INTEGER UNIQUE,
	balance INTEGER,
	bought_volume INTEGER
);

INSERT INTO stock_buy VALUES (10, 2200, 1000);

INSERT INTO stock_buy 
     VALUES (10, NULL, 2000)
ON CONFLICT (item_id)
  DO UPDATE SET balance = stock_buy.balance + EXCLUDED.bought_volume;

SELECT * FROM stock_buy;


--------------------------------------
-- INSERT INTO ... SELECT 

DROP TABLE IF EXISTS sales, sales_2019;

CREATE TABLE sales (
	id SERIAL,
	sal_value NUMERIC(10,2),
	sal_date DATE
);

CREATE TABLE sales_2019 (
	id SERIAL,
	sal_value NUMERIC(10,2),
	sal_date DATE
);

INSERT INTO sales (sal_value, sal_date)
	 VALUES (1000, '20/11/2019'),
          	(3000, '16/11/2018'),
            (2000, '4/11/2020'),
            (1000, '02/04/2019');

-- OK 
INSERT INTO sales_2019           
	 SELECT * 
	   FROM sales           
	  WHERE EXTRACT(YEAR FROM sal_date) = 2019;

-- FAIL 
ALTER TABLE sales ADD COLUMN sal_description TEXT;
UPDATE sales SET sal_description = '<UNKNOWN>';
SELECT * FROM sales;

INSERT INTO sales_2019           
	 SELECT * 
	   FROM sales           
	  WHERE EXTRACT(YEAR FROM sal_date) = 2019;

INSERT INTO sales_2019 (sal_value, sal_date)
	 SELECT sal_value, sal_date
	   FROM sales           
	  WHERE EXTRACT(YEAR FROM sal_date) = 2019;	
	  

-----------------------------------------
--RETURNING

DROP TABLE IF EXISTS products;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '2019-11-20'),
 	 		('Product 2', 'PRD2', 12.25, '2019-11-1'),
 	 		('Product 3', 'PRD3', 25.25, '2019-11-2'),
 	 		('Product 4', 'PRD4', 68.25, '2020-03-7')
; 		

-- RETURNING
DELETE FROM products 
      WHERE product_name = 'Product 1'
  RETURNING id;
 
UPDATE products 
   SET product_code = 'PRD2.1' 
 WHERE product_name = 'Product 2'
  RETURNING *;

INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '2019-07-21')
  RETURNING id;
  
 
--------------------------------------------------
--PARTCJONOWANIE - PARTITIONS

 
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
	id SERIAL,
	sal_description TEXT,
	sal_date DATE,
	sal_value NUMERIC(10,2),
	sal_discount NUMERIC (10,2),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
) PARTITION BY RANGE (sal_date);

CREATE TABLE sales_y2018 PARTITION OF sales
    FOR VALUES FROM ('2018-01-01') TO ('2018-12-31');

CREATE TABLE sales_y2019 PARTITION OF sales
    FOR VALUES FROM ('2019-01-01') TO ('2019-12-31');
   
CREATE TABLE sales_y2020 PARTITION OF sales
    FOR VALUES FROM ('2020-01-01') TO ('2020-12-31');

CREATE INDEX ON sales (sal_date);

-- OK
INSERT INTO sales (sal_description, sal_date, 
				   sal_value, sal_discount)
  	 VALUES ('201901_sale', '12/12/2019', 1000, 90),
  	  	    ('201902_sale', '24/06/2019', 10000, 190),
      	    ('201801_sale', '05/04/2018', 5630, 102),
      	    ('202001_sale', '07/04/2020', 7230, 0);

-- FAIL
INSERT INTO sales (sal_description, sal_date, 
				   sal_value, sal_discount)      	   
     VALUES ('202101_sale', '06/01/2021', 5000, 0);

SELECT * FROM sales;    

EXPLAIN ANALYZE 
SELECT * FROM sales;    

EXPLAIN ANALYZE
SELECT * 
  FROM sales 
 WHERE sal_date BETWEEN '01/01/2019' AND '31/12/2019';    

-- FAST BUT ...     
DROP TABLE sales_y2020;    

--- BETTER
ALTER TABLE sales DETACH PARTITION sales_y2019;


------------------------------------------------------
--TRUNCATE


DROP TABLE IF EXISTS products;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '20/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2019')
; 					  

-- DELETE VS TRUNCATE (NO AUTOCOMMIT)
DELETE FROM products; 

SELECT * FROM products;

TRUNCATE products;

-- TRUNCATE AND SERIAL TYPE 
TRUNCATE products;

SELECT * FROM products;

TRUNCATE products RESTART IDENTITY;

-- DELETE VS TRUNCATE (TABLE SIZE)

DELETE FROM products; 
TRUNCATE products;

SELECT pg_size_pretty( pg_total_relation_size('products') );


--------------------------------------------------------------------
-- M5L13 - INSERT CORNER CASES
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
	id SERIAL,
	sal_description TEXT,
	sal_date DATE,
	sal_value NUMERIC(10,2),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

EXPLAIN ANALYZE
INSERT INTO sales (sal_description, sal_date, sal_value)
     SELECT left(md5(i::text), 10),
	        NOW() + (random() * (interval '90 days')) + '30 days',
        	random() * 10 + 1        
       FROM generate_series(1, 20000) s(i);

SELECT COUNT(*) FROM sales;      
      
TRUNCATE TABLE sales RESTART IDENTITY;

-- Option 1 Execute Script Separate Inserts
-- Option 2 Execute Script Combined Inserts
-- Option 3 COPY
-- COPY public.sales TO 'D:\PostgreSQL_dump\M5_L13_SALES20K_COPY.copy';
-- COPY public.sales FROM 'D:\PostgreSQL_dump\M5_L13_SALES20K_COPY.copy';

-- Wiecej o COPY: https://postgresql.org/docs/12/sql-copy.html


-----------------------------------------------------------------------
-- M5L14 - BACKUP TABLE 
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
	id SERIAL,
	sal_description TEXT,
	sal_date DATE,
	sal_value NUMERIC(10,2),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO sales (sal_description, sal_date, sal_value)
     SELECT left(md5(i::text), 10),
	        NOW() + (random() * (interval '90 days')) + '30 days',
        	random() * 10 + 1        
       FROM generate_series(1, 20000) s(i);

SELECT COUNT(*) FROM sales;      
      
TRUNCATE TABLE sales RESTART IDENTITY;

pg_dump --host localhost ^
        --port 5432 ^
        --username postgres ^
        --format d ^
        --file "c:\1\db_postgres_dump" ^
        --table public.sales ^
        postgres

pg_dump --host localhost ^
        --port 5432 ^
        --username postgres ^
        --format plain ^
        --file "C:\1\public_sales_bp.sql" ^
        --table public.sales ^
        postgres

pg_restore --host localhost ^
           --port 5432 ^
           --username postgres ^
           --dbname postgres ^
           --clean ^
           "C:\1\db_postgres_dump"    

psql -U postgres -p 5432 -h localhost -d postgres -f "C:\1\public_sales_bp.sql"


pg_dump dla dockera:
docker exec -i some-postgres pg_dump --username postgres  --table public.sales > c:\1\dump.sql


------------------------------------------------------------
