--modul 7 - Data Query LANGUAGE: JOINS 

------------------

-- M7L3 - INNER JOIN
DROP TABLE IF EXISTS products, product_manufactured_region CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	manufactured_region VARCHAR(25),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE product_manufactured_region (
	id SERIAL,
	region_name VARCHAR(25),
	region_code VARCHAR(10),
	established_year INTEGER
);

TRUNCATE TABLE products, product_manufactured_region;

INSERT INTO products (product_name, product_code, manufactured_region, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 'Europe', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 'EMEA', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 'APAC', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 'APAC', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 'North America', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, NULL, 11.11, '12/12/2020')
;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', NULL, 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012);

-- INNER JOIN

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 INNER JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

-- INNER JOIN 2
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
       JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

-- INNER JOIN 3

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p, product_manufactured_region mr 
   	  WHERE mr.region_name = p.manufactured_region
;

-- INNER JOIN 4 

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 INNER JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region
 		   AND mr.established_year > 2015
;

-- INNER JOIN 5 

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 INNER JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region
 		   AND mr.established_year > 2015
      WHERE p.product_code IN ('PRD1','PRD2')
;

-- INNER JOIN 6

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 INNER JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

TRUNCATE TABLE product_manufactured_region RESTART IDENTITY;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', 'East EMEA', 2010),
			 ('EMEA', 'West EMEA', 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012);
	  		 
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 INNER JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

------------------

-- M7L4 - LEFT JOIN
DROP TABLE IF EXISTS products, product_manufactured_region CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	manufactured_region VARCHAR(25),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE product_manufactured_region (
	id SERIAL,
	region_name VARCHAR(25),
	region_code VARCHAR(10),
	established_year INTEGER
);

TRUNCATE TABLE products, product_manufactured_region;

INSERT INTO products (product_name, product_code, manufactured_region, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 'Europe', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 'EMEA', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 'APAC', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 'APAC', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 'North America', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, NULL, 11.11, '12/12/2020')
;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', NULL, 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012);

-- LEFT JOIN

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 LEFT OUTER JOIN product_manufactured_region mr 
 				ON mr.region_name = p.manufactured_region
;

-- LEFT JOIN 2
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN product_manufactured_region mr 
  			ON mr.region_name = p.manufactured_region
;

-- LEFT JOIN 3

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region
 		   AND mr.established_year > 2015
;

-- LEFT JOIN 4 

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region
 		   AND mr.established_year = 2012
      WHERE p.product_code IN ('PRD1','PRD2','PRD4')
;

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region		   
      WHERE p.product_code IN ('PRD1','PRD2','PRD4')
        AND mr.established_year = 2012
;

-- LEFT JOIN 5

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

TRUNCATE TABLE product_manufactured_region RESTART IDENTITY;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', 'East EMEA', 2010),
			 ('EMEA', 'West EMEA', 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012);
	  		 
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

-- LEFT JOIN 6

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN (SELECT pmr.region_name,
  					pmr.established_year
			   FROM product_manufactured_region pmr
			  WHERE pmr.established_year < 2019) mr ON mr.region_name = p.manufactured_region
;

------------------

-- M7L5 - RIGHT JOIN
DROP TABLE IF EXISTS products, product_manufactured_region CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	manufactured_region VARCHAR(25),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE product_manufactured_region (
	id SERIAL,
	region_name VARCHAR(25),
	region_code VARCHAR(10),
	established_year INTEGER
);

TRUNCATE TABLE products, product_manufactured_region;

INSERT INTO products (product_name, product_code, manufactured_region, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 'Europe', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 'EMEA', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 'APAC', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 'APAC', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 'North America', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, NULL, 11.11, '12/12/2020')
;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', NULL, 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012);

-- RIGHT JOIN
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 RIGHT OUTER JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

-- RIGHT JOIN 2
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  RIGHT JOIN product_manufactured_region mr 
  			ON mr.region_name = p.manufactured_region
;

-- RIGHT JOIN 3
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.region_name,
		    mr.established_year AS region_establed_at
       FROM products p 
  RIGHT JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region
 		   AND mr.established_year > 2015
;

-- RIGHT JOIN 4 
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 RIGHT JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region
 		   AND mr.established_year > 2015
      WHERE p.product_code IN ('PRD1','PRD2')
;

-- RIGHT JOIN 5
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 RIGHT JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

TRUNCATE TABLE product_manufactured_region RESTART IDENTITY;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', 'East EMEA', 2010),
			 ('EMEA', 'West EMEA', 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012);
	  		 
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.region_name,
		    mr.region_code,
		    mr.established_year AS region_establed_at
       FROM products p 
  RIGHT JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

-- RIGHT JOIN 6
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 RIGHT JOIN (SELECT pmr.region_name,
  					pmr.established_year
			   FROM product_manufactured_region pmr
			  WHERE pmr.established_year < 2019) mr ON mr.region_name = p.manufactured_region
;

------------------

-- M7L6 - FULL JOIN
DROP TABLE IF EXISTS products, product_manufactured_region CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	manufactured_region VARCHAR(25),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE product_manufactured_region (
	id SERIAL,
	region_name VARCHAR(25),
	region_code VARCHAR(10),
	established_year INTEGER
);

TRUNCATE TABLE products, product_manufactured_region;

INSERT INTO products (product_name, product_code, manufactured_region, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 'Europe', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 'EMEA', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 'APAC', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 'APAC', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 'North America', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, NULL, 11.11, '12/12/2020')
;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', NULL, 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012),
  	  		 ('Africa', NULL, 2020);

-- FULL JOIN
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.region_name,
		    mr.established_year AS region_establed_at
       FROM products p 
 FULL OUTER JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

-- FULL JOIN 2
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.region_name,
		    mr.established_year AS region_establed_at
       FROM products p 
  FULL JOIN product_manufactured_region mr 
  			ON mr.region_name = p.manufactured_region
;

-- FULL JOIN 3
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.region_name,		    
		    mr.established_year AS region_establed_at 
       FROM products p 
  LEFT JOIN product_manufactured_region mr 
  		 ON mr.region_name = p.manufactured_region
  	  UNION  		 
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.region_name,		    
		    mr.established_year AS region_establed_at 
       FROM products p 
 RIGHT JOIN product_manufactured_region mr 
  		 ON mr.region_name = p.manufactured_region
;

-- FULL JOIN 4 
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  FULL JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region
 		   AND mr.established_year > 2015
;

-- FULL JOIN 5 
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 FULL JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region
 		   AND mr.established_year > 2015
      WHERE p.product_code IN ('PRD1','PRD2')
;

-- FULL JOIN 6
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  FULL JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

TRUNCATE TABLE product_manufactured_region RESTART IDENTITY;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', 'East EMEA', 2010),
			 ('EMEA', 'West EMEA', 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012);
	  		 
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  FULL JOIN product_manufactured_region mr ON mr.region_name = p.manufactured_region
;

-- FULL JOIN 7
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 FULL JOIN (SELECT pmr.region_name,
  					pmr.established_year
			   FROM product_manufactured_region pmr
			  WHERE pmr.established_year < 2019) mr ON mr.region_name = p.manufactured_region
;

------------------

-- M7L7 - CROSS
DROP TABLE IF EXISTS products, region CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE region (
	id SERIAL,
	region_name VARCHAR(25),
	region_code VARCHAR(10),
	established_year INTEGER
);

TRUNCATE TABLE products, region;

INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, 11.11, '12/12/2020')
;

INSERT INTO region (region_name, region_code, established_year)
	  VALUES ('EMEA', NULL, 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012),
  	  		 ('Africa', NULL, 2020);

-- CROSS JOIN
	 SELECT p.product_name,
		    p.product_code, 		   
		    r.region_name,
		    r.established_year AS region_establed_at
       FROM products p 
 CROSS JOIN region r
;

-- CROSS JOIN 2
	 SELECT p.product_name,
		    p.product_code, 		   
		    r.region_name,
		    r.established_year AS region_establed_at
       FROM products p, region r
;

-- CROSS JOIN 3
	 SELECT p.product_name,
		    p.product_code, 		   
		    r.region_name,
		    r.established_year AS region_establed_at
       FROM products p
 INNER JOIN region r ON 1=1 
;

-- CROSS JOIN 4
EXPLAIN ANALYZE
	 SELECT p.product_name,
		    p.product_code, 		   
		    r.region_name,
		    r.established_year AS region_establed_at
       FROM products p, region r
;

------------------

-- M7L8 - SELF JOIN
DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

TRUNCATE TABLE products;

INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, 11.11, '12/12/2020')
;

-- SELF JOIN

SELECT p.* 
  FROM products p;
 
    SELECT p.product_name,
    	   p.product_code, 
           p2.product_name AS same_product_name_diff_code
      FROM products p
 LEFT JOIN products p2 ON p2.product_code = p.product_code
  ORDER BY p.product_name, p.product_code
;

 SELECT *
   FROM (
	    SELECT p.product_name,
	    	   p.product_code, 
	           CASE WHEN p2.product_name <> p.product_name THEN p2.product_name 
	           		ELSE NULL 
	           	END AS same_product_name_diff_code
	      FROM products p
	 LEFT JOIN products p2 ON p2.product_code = p.product_code
	  ORDER BY p.product_name, p.product_code
	) sq 
  WHERE sq.same_product_name_diff_code IS NOT NULL
;


-- SELF JOIN 2 
DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
	employee_id INT PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	manager_id INT
);

INSERT INTO employee (employee_id, first_name,	last_name,	manager_id)
VALUES (1, 'Krzysiek', 'Bury', NULL),
   	   (2, 'Ania', 'Kowalska', 1),
	   (3, 'Tomek', 'Sawyer', 1),
   	   (4, 'Jessica', 'Polska', 2),
   	   (5, 'Janusz', 'Podbipiêta', 2),
   	   (6, 'Onufry', 'Zag³oba', 3),
   	   (7, 'Bohdan', 'Chmielnicki', 3),
       (8, 'Micha³', 'Paliwoda', 3);
       
    SELECT e.first_name || ' ' || e.last_name employee,
           m .first_name || ' ' || m .last_name manager
      FROM employee e
INNER JOIN employee m ON m .employee_id = e.manager_id
  ORDER BY manager;  
  
     SELECT e.first_name || ' ' || e.last_name employee,
           m .first_name || ' ' || m .last_name manager
      FROM employee e
 LEFT JOIN employee m ON m .employee_id = e.manager_id
  ORDER BY manager;  
  
 ------------------
 
 -- M7L11 - KONSEKWENCJE ZLACZEN
DROP TABLE IF EXISTS products, product_manufactured_region CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	manufactured_region VARCHAR(25),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE product_manufactured_region (
	id SERIAL,
	region_name VARCHAR(25),
	region_code VARCHAR(10),
	established_year INTEGER
);

TRUNCATE TABLE products, product_manufactured_region;

INSERT INTO products (product_name, product_code, manufactured_region, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 'Europe', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 'EMEA', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 'APAC', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 'APAC', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 'North America', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, NULL, 11.11, '12/12/2020')
;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', 'East EMEA', 2010),
			 ('EMEA', 'West EMEA', 2010),
			 ('Africa', NULL, 2018),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012);
	  		 

-- KONSEKWENCJA 1
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 LEFT OUTER JOIN product_manufactured_region mr 
 				ON mr.region_name = p.manufactured_region
;

-- KONSEKWENCJA 2
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
 LEFT OUTER JOIN product_manufactured_region mr 
 				ON mr.region_name = p.manufactured_region
 				OR 1=1
;

-- KONSEKWENCJA 3
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p, product_manufactured_region mr 
  	  WHERE mr.established_year > 2010				
;

-- KONSEKWENCJA 4
    SELECT p.product_name,
    	   p.product_code, 
           p2.product_name AS same_product_name_diff_code
      FROM products p
 LEFT JOIN products p2 ON p2.product_code = p.product_code
  ORDER BY p.product_name, p.product_code
;

    SELECT p.*,
    	   p2.*
      FROM products p
 LEFT JOIN products p2 ON p2.product_code = p.product_code
  ORDER BY p.product_name, p.product_code
;

-- KONSEKWENCJA 5
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region
 		   AND mr.established_year = 2012
;

	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN product_manufactured_region mr 
 			ON mr.region_name = p.manufactured_region		   
      WHERE mr.established_year = 2012
;

------------------

-- M7L12 - WITH
DROP TABLE IF EXISTS products, product_manufactured_region CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	manufactured_region VARCHAR(25),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE product_manufactured_region (
	id SERIAL,
	region_name VARCHAR(25),
	region_code VARCHAR(10),
	established_year INTEGER
);

TRUNCATE TABLE products, product_manufactured_region;

INSERT INTO products (product_name, product_code, manufactured_region, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 'Europe', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 'EMEA', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 'APAC', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 'APAC', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 'North America', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, NULL, 11.11, '12/12/2020')
;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', 'East EMEA', 2010),
			 ('EMEA', 'West EMEA', 2010),
			 ('Africa', NULL, 2018),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012);
	  		 

-- WITH
	 SELECT p.product_name,
		    p.product_code, 
		    p.manufactured_region,
		    mr.established_year AS region_establed_at
       FROM products p 
  LEFT JOIN (SELECT pmr.region_name,
  					pmr.established_year
			   FROM product_manufactured_region pmr
			  WHERE pmr.established_year < 2019) mr ON mr.region_name = p.manufactured_region
;

WITH region_prior_2019 AS (
	SELECT pmr.region_name,
  		   pmr.established_year
	  FROM product_manufactured_region pmr
	 WHERE pmr.established_year < 2019
)  SELECT p.product_name,
		  p.product_code, 
		  p.manufactured_region,
		  rp.established_year AS region_establed_at
     FROM products p
LEFT JOIN region_prior_2019 rp ON rp.region_name = p.manufactured_region

-- WITH 2
WITH different_region_upsert AS (
	SELECT p.manufactured_region, 
	       EXTRACT(YEAR FROM p.manufactured_date) manufactured_year
	  FROM products p
 LEFT JOIN product_manufactured_region pmr ON pmr.region_name = p.manufactured_region
     WHERE pmr.region_name IS NULL
       AND p.manufactured_region  IS NOT NULL
) INSERT INTO product_manufactured_region (region_name, region_code, established_year)
   SELECT manufactured_region, NULL, manufactured_year
     FROM different_region_upsert;
     
SELECT * FROM product_manufactured_region;

------------------

-- M7L13 - WITH RECURSIVE

WITH RECURSIVE numbers_generator(n) AS (
	SELECT 1
	UNION
	SELECT n+1 
	  FROM numbers_generator
  	 WHERE n < 100 
) SELECT sum(n) FROM numbers_generator;

DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
	employee_id INT PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	manager_id INT
);

INSERT INTO employee (employee_id, first_name,	last_name,	manager_id)
VALUES (1, 'Krzysiek', 'Bury', NULL),
   	   (2, 'Ania', 'Kowalska', 1),
	   (3, 'Tomek', 'Sawyer', 1),
   	   (4, 'Jessica', 'Polska', 2),
   	   (5, 'Janusz', 'Podbipiêta', 2),
   	   (6, 'Onufry', 'Zag³oba', 3),
   	   (7, 'Bohdan', 'Chmielnicki', 3),
       (8, 'Micha³', 'Paliwoda', 3);
       
    SELECT e.first_name || ' ' || e.last_name employee,
           m .first_name || ' ' || m .last_name manager
      FROM employee e
INNER JOIN employee m ON m .employee_id = e.manager_id
  ORDER BY manager;  
  
     SELECT e.first_name || ' ' || e.last_name employee,
           m .first_name || ' ' || m .last_name manager
      FROM employee e
 LEFT JOIN employee m ON m .employee_id = e.manager_id
  ORDER BY manager;  
  
 WITH RECURSIVE emp AS (
 	SELECT employee_id,
 		   CASE WHEN manager_id IS NULL THEN 'BOSS'
 		   		ELSE first_name || ' ' || last_name 
  	        END  AS manager_name, 		   		 		   
 	       first_name || ' ' || last_name employee
 	  FROM employee
 	 WHERE manager_id IS NULL 
  	 UNION ALL
    SELECT e.employee_id,
    	   wre.employee,    	  
    	   e.first_name || ' ' || e.last_name employee
 	  FROM emp wre, employee e 
 	 WHERE wre.employee_id = e.manager_id
) SELECT * FROM emp;

------------------

-- M7L14 - UPDATE DELETE
DROP TABLE IF EXISTS products, product_manufactured_region CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,	
	manufactured_region VARCHAR(25),
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE product_manufactured_region (
	id SERIAL,
	region_name VARCHAR(25),
	region_code VARCHAR(10),
	established_year INTEGER
);

TRUNCATE TABLE products, product_manufactured_region;

INSERT INTO products (product_name, product_code, manufactured_region, product_quantity, manufactured_date)					    
 	 VALUES ('Product 1', 'PRD1', 'Europe', 100.25, '20/11/2019'),
 	 		('Product 1', 'PRD2', 'EMEA', 92.25, '1/11/2019'),
 	 		('Product 2', 'PRD2', 'APAC', 12.25, '1/11/2019'),
 	 		('Product 3', 'PRD3', 'APAC', 25.25, '2/11/2019'),
 	 		('Product 4', 'PRD4', 'North America', 68.25, '3/11/2019'),
 	 		('Product 5', NULL, NULL, 11.11, '12/12/2020')
;

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', NULL, 2010),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012),
  	  		 ('Africa', NULL, 2020);

-- UPDATE
   UPDATE products p 
      SET manufactured_region = '<unknown>'
     FROM products po 
LEFT JOIN product_manufactured_region pmr ON pmr.region_name = po.manufactured_region
    WHERE p.id = po.id AND pmr.region_name IS NULL
RETURNING *;

SELECT * FROM products;

	UPDATE products p 
  	   SET manufactured_region = '<unknown>'
  	  WHERE EXISTS (SELECT 1
   	  				  FROM products po 
				 LEFT JOIN product_manufactured_region pmr ON pmr.region_name = po.manufactured_region
				     WHERE p.id = po.id AND pmr.region_name IS NULL)
  RETURNING *;
				     
-- DELETE 
  DELETE FROM product_manufactured_region pmr
   USING products p 
 RIGHT JOIN product_manufactured_region pmr2 ON pmr2.region_name = p.manufactured_region
  WHERE p.manufactured_region IS NULL
    AND pmr.id = pmr2.id
   RETURNING *;
   
  DELETE FROM product_manufactured_region pmr
        WHERE EXISTS (SELECT 1
   	  				  FROM products p 
 			    RIGHT JOIN product_manufactured_region pmr2 ON pmr2.region_name = p.manufactured_region
				     WHERE pmr2.id = pmr.id 
				       AND p.manufactured_region IS NULL)
    RETURNING *;
    
   