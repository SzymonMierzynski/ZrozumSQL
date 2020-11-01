--modul 6 - Data Query LANGUAGE: SELECT 

------------------

-- M6L6 - DISTINCT 

DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	manufactured_date DATE
);	

INSERT INTO products VALUES ('Product 1', 'PRD1', '10/11/2020');
INSERT INTO products VALUES ('Product 1', 'PRD1', '10/11/2020');
INSERT INTO products VALUES ('Product 1', 'PRD1.1', '10/11/2020');

SELECT * FROM products;

SELECT DISTINCT * FROM products;

SELECT product_name, manufactured_date FROM products;

SELECT DISTINCT * FROM products;

DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	description TEXT,
	manufactured_date DATE,
	valid_from timestamp,
	valid_to timestamp
);	

INSERT INTO products VALUES ('Product 1', 'PRD1', 'Product 1 - cool product.', '10/11/2018', '01/01/2018 00:00:00','31/12/2018 23:59:59');
INSERT INTO products VALUES ('Product 1', 'PRD1', 'Product 1 - product upgrade.', '10/11/2018', '01/01/2019 00:00:00', null);

SELECT product_name, 
	   product_code, 
	   manufactured_date
  FROM products;
 
SELECT DISTINCT 
       product_name, 
	   product_code, 
	   manufactured_date
  FROM products; 
 
-- BETTER
 SELECT product_name, 
	    product_code, 
	    manufactured_date
   FROM products
  WHERE valid_to IS NULL; 
  
 ------------------
 
 -- M6L7 - DISTINCT ON

 DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	manufactured_date DATE
);	

INSERT INTO products VALUES ('Product 1', 'PRD1', '10/11/2020');
INSERT INTO products VALUES ('Product 1', 'PRD1', '11/11/2020');
INSERT INTO products VALUES ('Product 1', 'PRD1.1', '10/11/2020');

SELECT * FROM products;

   SELECT DISTINCT ON (product_code) * 
     FROM products;
    
-- FAIL
   SELECT DISTINCT ON (product_code) * 
     FROM products
 ORDER BY manufactured_date;

 SELECT DISTINCT ON (product_code) * 
     FROM products
 ORDER BY product_code, manufactured_date DESC;

  ------------------

-- M6L8 - WHERE

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
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2020')
;

SELECT * 
  FROM products p
 WHERE p.product_name = 'PRD1';
 
SELECT * 
  FROM products p
 WHERE p.product_code = 'PRD1';
 
SELECT * 
  FROM products p
 WHERE p.product_code = 'PRD1' OR p.product_name = 'Product 1';
 
SELECT * 
  FROM products p
 WHERE p.product_name = 'Product 1'
       OR p.manufactured_date < '01/01/2020'
       AND p.product_quantity > 100;
       
SELECT * 
  FROM products p
 WHERE (p.product_name = 'Product 1'
        OR p.manufactured_date < '01/01/2020')
        AND p.product_quantity > 100;      
       
------------------

-- M6L9 - OPERATORS PRECEDENCE
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
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2020')
 	 		('Product 4', 'PRD4', 68.25, NULL)
;

SELECT * 
  FROM products p
 WHERE p.product_name = 'PRD1';
 
SELECT * 
  FROM products p
 WHERE p.product_code != 'PRD1'; -- PROGRAMMING APPROACH

SELECT * 
  FROM products p
 WHERE p.product_code <> 'PRD1'; --SQL APPROACH

SELECT * 
  FROM products p
 WHERE p.product_code IN ('PRD1');

SELECT * 
  FROM products p
 WHERE p.product_code NOT IN ('PRD1');

SELECT * 
  FROM products p
 WHERE p.manufactured_date IS NULL;

SELECT * 
  FROM products p
 WHERE p.manufactured_date IS NOT NULL;

SELECT * 
  FROM products p
 WHERE p.product_quantity > 10 -- <, <=, >=, 

 SELECT * 
  FROM products p
 WHERE p.product_quantity BETWEEN 12.25 AND 25.25 ;
 
 SELECT * 
  FROM products p
 WHERE p.product_quantity BETWEEN 12.2400009 AND 25.25 ;

 SELECT * 
  FROM products p
 WHERE p.product_quantity BETWEEN 12.2500001 AND 25.25 ;

SELECT * 
  FROM products p
 WHERE p.product_name = 'Product 1'
       OR p.manufactured_date < '01/01/2020'
       AND p.product_quantity > 100;
       
SELECT * 
  FROM products p
 WHERE (p.product_name = 'Product 1'
        OR p.manufactured_date < '01/01/2020')
        AND p.product_quantity > 100;      

------------------

-- M6L11 - ANY / SOME / ALL / IN / NOT IN 
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
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, 11.11, '12/12/2020')
;

-- IN 
SELECT * 
  FROM products 
 WHERE product_code IN ('PRD1','PRD3');

-- NOT IN 
SELECT * 
  FROM products 
 WHERE product_code NOT IN ('PRD1','PRD3');

-- COALESCE
SELECT * 
  FROM products 
 WHERE COALESCE(product_code,'') IN ('PRD1','PRD3');

SELECT * 
  FROM products 
 WHERE COALESCE(product_code,'') NOT IN ('PRD1','PRD3');

-- ANY
SELECT * 
  FROM products 
 WHERE COALESCE(product_code,'') 
		= ANY (SELECT DISTINCT product_code 
				 FROM products);
SELECT * 
  FROM products 
 WHERE COALESCE(product_code,'') 
		= ANY (SELECT DISTINCT COALESCE(product_code ,'')
				 FROM products);				

-- ALL
SELECT * 
  FROM products 
 WHERE COALESCE(product_code,'') 
		= ALL (SELECT DISTINCT product_code 
				 FROM products);
				
SELECT * 
  FROM products 
 WHERE COALESCE(product_code,'') 
		= ALL (SELECT DISTINCT product_code 
				 FROM products
				WHERE product_name = 'Product 2');		

SELECT * 
  FROM products 
 WHERE 10.00
		< ALL (SELECT DISTINCT product_quantity 
				 FROM products);
				
------------------

-- M6L12 - EXISTS
DROP TABLE IF EXISTS products, categories CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_category varchar(25),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE categories (
	id SERIAL,
	category_name VARCHAR(25)
);

INSERT INTO products (product_name, product_code, product_category, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 'Food', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 'Food', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 'Tech', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 'Tech', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 'Books', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, 'Books', 11.11, '12/12/2020')
;

INSERT INTO categories (category_name)
	  VALUES ('Food'),
	  		 ('Tech'),
	  		 ('Misc');

TRUNCATE TABLE products, categories;	  		

SELECT p.* 
  FROM products p 
 WHERE EXISTS (SELECT 1
 				 FROM categories c 
 				WHERE c.category_name = p.product_category);
 			

SELECT p.* 
  FROM products p 
 WHERE NOT EXISTS (SELECT 1
 				 FROM categories c 
 				WHERE c.category_name = p.product_category);
 			
------------------

-- M6L13 - LIKE
DROP TABLE IF EXISTS products;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_category varchar(25),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO products (product_name, product_code, product_category, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 'Food', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 'Food', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 'Tech', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 'Tech', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 'Books', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, 'Books', 11.11, '12/12/2020')
;

SELECT p.* 
  FROM products p 
 WHERE product_name LIKE 'Pr%';
 
SELECT p.* 
  FROM products p 
 WHERE product_name LIKE 'pr%';

SELECT p.* 
  FROM products p 
 WHERE product_name ILIKE 'pr%';
 
SELECT p.* 
  FROM products p 
 WHERE product_code LIKE '%3';
 
SELECT p.* 
  FROM products p 
 WHERE product_code LIKE 'PRD_';
 
SELECT regexp_match('foobarbequebaz', 'bar.*que');
SELECT regexp_match('foobarbe123456quebaz', 'bar.*que');

SELECT regexp_match('foobarbe123456quebaz', '[[:digit:]].*');
SELECT regexp_match('foobarbe123456quebaz', '[0-9]+');
 			
------------------

-- M6L14 - UNION / UNION ALL
DROP TABLE IF EXISTS products, products_old_system;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE products_old_system (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	manufactured_date DATE
);


INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2020'),
 	 		('Product 4', 'PRD4', 68.25, NULL)
;

INSERT INTO products_old_system (product_name, product_code, manufactured_date)					    
 	 VALUES ('Product Best Seller', 'PRD1', '20/11/2006'),
 	 		('Product Most Important', 'PRD2', '1/11/2009'),
 	 		('Product World Class', 'PRD3', '1/11/2008');
;

-- UNION1
SELECT product_name,
	   product_code,
	   manufactured_date,
	   product_quantity
  FROM products
 UNION
SELECT product_name,
	   product_code,
	   manufactured_date
  FROM products_old_system;
  
-- UNION2
SELECT product_name,
	   product_code,
	   manufactured_date,
	   product_quantity
  FROM products
 UNION
SELECT product_name,
	   product_code,
	   manufactured_date,
	   NULL AS product_quantity
  FROM products_old_system; 
  
 -- UNION3
SELECT product_name,
	   product_code,
	   manufactured_date,
	   product_quantity
  FROM products
ORDER BY product_code  
 UNION
SELECT product_name,
	   product_code,
	   manufactured_date,
	   NULL AS product_quantity
  FROM products_old_system;

  -- UNION4
SELECT * 
  FROM 
 (SELECT product_name,
	   product_code,
	   manufactured_date,
	   product_quantity
  FROM products
ORDER BY product_code) sq 
 UNION
SELECT product_name,
	   product_code,
	   manufactured_date,
	   NULL AS product_quantity
  FROM products_old_system;

-- UNION5
SELECT product_name,
	   product_code,
	   manufactured_date,
	   product_quantity
  FROM products
 UNION
SELECT product_name,
	   product_code,
	   manufactured_date,
	   NULL AS product_quantity
  FROM products_old_system
ORDER BY product_code;

-- UNION6
SELECT product_name,
	   product_code,
	   manufactured_date,
	   product_quantity
  FROM products
 UNION ALL
SELECT product_name,
	   product_code,
	   manufactured_date,
	   NULL AS product_quantity
  FROM products_old_system
ORDER BY product_code;

-- UNION7
SELECT product_code
  FROM products
 UNION ALL 
SELECT product_code
  FROM products_old_system
ORDER BY product_code;

-- UNION8
SELECT product_code
  FROM products
 UNION ALL
SELECT product_code
  FROM products_old_system
ORDER BY product_code;

------------------

-- M6L15 - INTERSECT / EXCEPT

-- L¹czenie zbiorów danych. W wyniku zostanie wyœwietlona czêœæ wspólna obu zbiorów.
-- INTERSECT - poza duplikatami a INTERSECT ALL - z duplikatami 
-- EXCEPT - w wyniku zostanie wyœwietlona ró¿nica w wierszach ze zbioru pierwszego query1 w stosunku do drugiego zbioru query2

DROP TABLE IF EXISTS products, products_old_system;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE products_old_system (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	manufactured_date DATE
);


INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '2019-11-20'),
 	 		('Product 1', 'PRD2', 92.25, '2019-11-01'),
 	 		('Product 2', 'PRD2', 12.25, '2019-11-01'),
 	 		('Product 3', 'PRD3', 25.25, '2019-11-02'),
 	 		('Product 4', 'PRD4', 68.25, '2020-11-03'),
 	 		('Product 4', 'PRD4', 68.25, NULL)
;

INSERT INTO products_old_system (product_name, product_code, manufactured_date)					    
 	 VALUES ('Product Best Seller', 'PRD1', '2006-11-20'),
 	 		('Product Most Important', 'PRD2', '2009-11-01'),
 	 		('Product Most Important', 'PRD2', '2007-11-01'),
 	 		('Product World Class', 'PRD3', '2008-11-01');
;

-- INTERSECT
SELECT product_name,
	   product_code,
	   manufactured_date,
	   product_quantity
  FROM products
 INTERSECT
SELECT product_name,
	   product_code,
	   manufactured_date
  FROM products_old_system;
  
-- INTERSECT2
SELECT product_name,
	   product_code,
	   manufactured_date,
	   product_quantity
  FROM products
 INTERSECT
SELECT product_name,
	   product_code,
	   manufactured_date,
	   NULL AS product_quantity
  FROM products_old_system; 
  
-- INTERSECT3
SELECT product_code
  FROM products
 INTERSECT ALL
 SELECT product_code
  FROM products_old_system
ORDER BY product_code;

-- INTERSECT4
SELECT product_code
  FROM products
 INTERSECT 
SELECT product_code
  FROM products_old_system
ORDER BY product_code;

-- EXCEPT
SELECT product_code
  FROM products
 EXCEPT ALL
SELECT product_code
  FROM products_old_system;
  
-- EXCEPT ALL 
SELECT product_code
  FROM products
 EXCEPT ALL
SELECT product_code
  FROM products_old_system; 
  
------------------
 
 -- M6L16: GROUP BY
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
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2020'),
 	 		('Product 4', 'PRD4', 68.25, NULL)
;

-- GROUP BY
  SELECT product_code, product_quantity
    FROM products p 
GROUP BY product_code
;

  SELECT product_code, product_quantity
    FROM products p 
GROUP BY product_code, product_quantity
;

  SELECT product_code
    FROM products p 
GROUP BY product_code
;

  SELECT product_code, sum(product_quantity)
    FROM products p 
GROUP BY product_code
;

  SELECT product_code, sum(product_quantity)
    FROM products p 
GROUP BY 1
;

  SELECT product_code, 
         EXTRACT(YEAR FROM manufactured_date) AS man_year,
         sum(product_quantity)
    FROM products p 
GROUP BY product_code, 2
;
 
  SELECT product_code, 
         EXTRACT(YEAR FROM COALESCE(manufactured_date,'10/10/2020')) AS man_year,
         sum(product_quantity)
    FROM products p 
GROUP BY product_code, 2
;
 
------------------

-- M6L17: HAVING
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
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2020'),
 	 		('Product 4', 'PRD4', 68.25, NULL)
;

-- HAVING
SELECT product_code, product_quantity
  FROM products p 
HAVING product_quantity > 10
;

SELECT sum(product_quantity)
  FROM products p 
HAVING product_quantity > 10
; 

SELECT sum(product_quantity)
  FROM products p 
HAVING sum(product_quantity) > 100
; 

SELECT product_code, sum(product_quantity)
  FROM products p
GROUP BY product_code
HAVING product_code = 'PRD2'
; 

SELECT product_code, sum(product_quantity)
  FROM products p
GROUP BY product_code
HAVING sum(product_quantity) > 100
; 

------------------

-- M6L18 - ORDER BY 
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
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2019')
;

-- 
SELECT p.product_name,
       p.product_code, 
       p.manufactured_date,
       p.product_quantity * 0.5 AS half_qty
  FROM products p 
 ORDER BY product_name ASC, product_code DESC;

--

SELECT p.product_name,
       p.product_code, 
       p.manufactured_date,
       p.product_quantity * 0.5 AS half_qty
  FROM products p 
 ORDER BY 1 ASC, 2 DESC;

--

SELECT p.product_name,
       p.product_code, 
       p.manufactured_date,
       p.product_quantity * 0.5 AS half_qty
  FROM products p 
 ORDER BY 1 ASC, 2;

--

SELECT p.product_name,
       p.product_code, 
       p.manufactured_date,
       p.product_quantity * 0.5 AS half_qty
  FROM products p 
 ORDER BY (p.product_quantity * 0.5) + 2;

-- FAIL

SELECT p.product_name AS pname,
       p.product_code, 
       p.manufactured_date,
       p.product_quantity * 0.5 AS half_qty
  FROM products p 
 ORDER BY half_qty + 2;

-- OK

SELECT p.product_name AS pname,
       p.product_code, 
       p.manufactured_date,
       p.product_quantity * 0.5 AS half_qty
  FROM products p 
 ORDER BY half_qty;
 
------------------

-- M6L19 - LIMIT I OFFSET 
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
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2019')
;

SELECT p.product_name,
       p.product_code, 
       p.manufactured_date,
       p.product_quantity * 0.5 AS half_qty
  FROM products p 
 LIMIT 1 OFFSET 2;

UPDATE products SET product_code = 'PRD2.1' WHERE product_name = 'Product 2';

SELECT p.product_name,
       p.product_code, 
       p.manufactured_date,
       p.product_quantity * 0.5 AS half_qty
  FROM products p 
 LIMIT 1 OFFSET 2;

SELECT p.product_name,
       p.product_code, 
       p.manufactured_date,
       p.product_quantity * 0.5 AS half_qty
  FROM products p 
 LIMIT 1 OFFSET 6;
 
------------------

-- M6L20 - LOGICZNY PLAN WYKONANIA 
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

-- 
SELECT *
  FROM products p
 WHERE product_name = 'Product 1';
 
--
SELECT p.product_name AS pname,
       p.product_code, 
       p.manufactured_date
  FROM products p 
 WHERE pname = 'Product 1';

--
SELECT p.product_name AS pname,
       p.product_code, 
       p.manufactured_date
  FROM products p 
 ORDER BY pname;
 
------------------

