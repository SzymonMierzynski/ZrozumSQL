CREATE DATABASE test
	WITH ENCODING 'UTF8'
	TEMPLATE = template0
	
CREATE SCHEMA training

CREATE TABLE test_tbl (id int)

CREATE TABLE TRAINING.TEST_TBL2 
(
	id int,
	description text
)

DROP SCHEMA training

DROP TABLE TRAINING.TEST_TBL2 

ALTER SCHEMA train RENAME TO training

CREATE TABLE new_table (id integer);

ALTER TABLE new_table RENAME TO newer_table; 

ALTER TABLE TRAINING.TEST_TBL2  
	ADD COLUMN description2 TEXT;

ALTER TABLE TRAINING.TEST_TBL2 
	RENAME description2 TO descr2;

ALTER TABLE TRAINING.TEST_TBL2 
	DROP descr2;
	
---------------------------------------------------

CREATE TABLE products (
	id integer,
	PRIMARY KEY (id)
);

CREATE TABLE sales (
	id integer PRIMARY KEY,
	descr text
);

CREATE TABLE customers (
	id integer,
	name TEXT 
);

INSERT INTO customers VALUES (NULL, 'Customer 1'), (1, 'Customer 2');

ALTER TABLE customers ADD CONSTRAINT pk_customers PRIMARY KEY (id);

ALTER TABLE customers ADD PRIMARY KEY (id);

ALTER TABLE customers DROP CONSTRAINT customers_pkey

---------------------------------
--klucze:

CREATE TABLE products (
	id integer,
	PRIMARY KEY (id)
);

CREATE TABLE sales (
	id integer PRIMARY KEY,
	product_id  integer REFERENCES products
);

CREATE TABLE sales_2019 (
	id integer,
	product_id integer,
	FOREIGN KEY (product_id) REFERENCES products (id)
);

CREATE TABLE sales_2020 (
	id integer,
	product_id integer
);

ALTER TABLE sales_2020 ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products (id);
ALTER TABLE sales_2020 ADD FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE sales_2020 DROP CONSTRAINT fk_products;

CREATE TABLE sales_2021 (
	id integer,
	product_id integer REFERENCES products ON DELETE CASCADE
);

INSERT INTO sales_2020 VALUES (1, NULL);

INSERT INTO products VALUES (1),(2),(3);
INSERT INTO sales_2021 VALUES (1, 1);
INSERT INTO sales_2021 VALUES (2, 1);

SELECT * FROM sales_2021;

DELETE FROM products WHERE id = 1;

-----------------------------------------------

CREATE TABLE sales (
	id integer NOT NULL,
	sales NUMERIC CHECK (sales > 1000)
);

ALTER TABLE sales ALTER COLUMN id DROP NOT NULL;


CREATE TABLE sales2 (
	id integer,
	sales NUMERIC CONSTRAINT sales_not_null CHECK (sales IS NOT NULL)
);

-------------------------------------------
--null

CREATE TABLE sales (
	id integer NOT NULL,
	sales NUMERIC CHECK (sales > 1000)
);

ALTER TABLE sales ALTER COLUMN id DROP NOT NULL;


CREATE TABLE sales2 (
	id integer,
	sales NUMERIC CONSTRAINT sales_not_null CHECK (sales IS NOT NULL)
);

--------------------
--UNIQUE

CREATE TABLE sales (
	id integer NOT NULL,
	description TEXT unique
);


INSERT INTO sales VALUES (1,'abc');
INSERT INTO sales VALUES (2,NULL);
INSERT INTO sales VALUES (3,NULL);
INSERT INTO sales VALUES (4,'abc');

CREATE TABLE products (
	id integer NOT NULL,
	product_short_code varchar(10),
	product_no varchar(5),
	UNIQUE(product_short_code, product_no)
);

------------------------------
--IF EXISTS
--IF NOT EXISTS

CREATE TABLE sales (
	id integer
);

CREATE TABLE sales (
	id integer,
	description text
);


CREATE TABLE IF NOT EXISTS sales ( 
	id integer,
	description text
);

DROP TABLE IF EXISTS sales;

DROP TABLE sales;

-----------------------------------------
--CASCADE

CREATE SCHEMA training;

CREATE TABLE training.sales (id integer);

DROP SCHEMA training;

---

DROP SCHEMA training CASCADE;

CREATE TABLE products (id integer PRIMARY KEY);
CREATE TABLE sales (id integer PRIMARY KEY, 
				    product_id integer REFERENCES products);

INSERT INTO products VALUES (1);
INSERT INTO sales VALUES (1,1), (2,1);

DROP TABLE products;

---

DROP TABLE products CASCADE;

----------------------------------------------




