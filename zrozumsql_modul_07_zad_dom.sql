--Modu� 7 Data Query Language � JOINS - Zadania Teoria SQL


--0. utw�rz obiekty potrzebne do zadania

--------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS products, sales, product_manufactured_region CASCADE;

CREATE TABLE products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),	
	manufactured_date DATE,
	product_man_region INTEGER,
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE sales (
	id SERIAL,
	sal_description TEXT,
	sal_date DATE,
	sal_value NUMERIC(10,2),
	sal_prd_id INTEGER,
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

CREATE TABLE product_manufactured_region (
	id SERIAL,
	region_name VARCHAR(25),
	region_code VARCHAR(10),
	established_year INTEGER
);

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	  VALUES ('EMEA', 'E_EMEA', 2010),
	  		 ('EMEA', 'W_EMEA', 2012),
	  		 ('APAC', NULL, 2019),
	  		 ('North America', NULL, 2012),
	  		 ('Africa', NULL, 2012);

INSERT INTO products (product_name, product_code, product_quantity, manufactured_date, product_man_region)
     SELECT 'Product '||floor(random() * 10 + 1)::int,
            'PRD'||floor(random() * 10 + 1)::int,
            random() * 10 + 1,
            CAST((NOW() - (random() * (interval '90 days')))::timestamp AS date),
            CEIL(random()*(10-5))::int
       FROM generate_series(1, 10) s(i);  
      
INSERT INTO sales (sal_description, sal_date, sal_value, sal_prd_id)
     SELECT left(md5(i::text), 15),
     		CAST((NOW() - (random() * (interval '60 days'))) AS DATE),	
     		random() * 100 + 1,
        	floor(random() * 10)+1::int            
       FROM generate_series(1, 10000) s(i);    
      
--------------------------------------------------------------------------------------------------------

--1. Korzystaj�c z konstrukcji INNER JOIN po��cz dane sprzeda�owe (SALES, sal_prd_id) z
--   danymi o produktach (PRODUCTS, id). W wynikach poka� tylko te produkty, kt�re
--   powsta�y w regionie EMEA. Wyniki ogranicz do 100 wierszy.

-- po zlaczeniu tabel sales i products nie bylo w nich informacji o regionach wiec dodalem tabele produst_manufactured_region ktora te informacje ma      
      
 SELECT * FROM SALES S 
 	JOIN PRODUCTS P ON s.sal_prd_id = p.id
 	JOIN PRODUCT_MANUFACTURED_REGION PMR ON p.PRODUCT_MAN_REGION = pmr.id
 WHERE pmr.REGION_NAME = 'EMEA'
LIMIT 100
 
--SELECT * FROM PRODUCTS P 
--SELECT * FROM PRODUCT_MANUFACTURED_REGION PMR 
--------------------------------------------------------------------------------------------------------

--2. Korzystaj�c z konstrukcji LEFT JOIN po��cz dane o produktach (PRODUCTS,
--   product_man_region) z danymi o regionach w kt�rych produkty powsta�y
--	 (PRODUCT_MANUFACTURED_REGION, id)
--	 W wynikach wy�wietl wszystkie atrybuty z tabeli produkt�w i atrybut REGION_NAME
--	 z tabeli PRODUCT_MANUFACTURED_REGION. Dodatkowo w trakcie z��czenia
--	 ogranicz dane brane przy z��czenia do tych region�w, kt�re zosta�y za�o�one po 2012
--	 roku.

SELECT P2.*, pmr.REGION_NAME FROM PRODUCTS P2 
	LEFT JOIN PRODUCT_MANUFACTURED_REGION PMR ON p2.PRODUCT_MAN_REGION = pmr.ID AND pmr.ESTABLISHED_YEAR > 2012 

-- w wyniku odstaniemy wszystkie 10 produk�w a tam gdzie regiony zostaly zalozone po 2012 mamy NULL
	
--SELECT * FROM PRODUCTS P 
--SELECT * FROM PRODUCT_MANUFACTURED_REGION PMR 

--------------------------------------------------------------------------------------------------------

--3. Korzystaj�c z konstrukcji LEFT JOIN po��cz dane o produktach (PRODUCTS,
--	 product_man_region) z danymi o regionach w kt�rych produkty powsta�y
--	 (PRODUCT_MANUFACTURED_REGION, id).
--	 W wynikach wy�wietl wszystkie atrybuty z tabeli produkt�w i atrybut REGION_NAME
--	 z tabeli PRODUCT_MANUFACTURED_REGION.
-- 	 Dodatkowo wyfiltruj dane wynikowe taki spos�b, aby pokaza� tylko te produkty, dla
--	 kt�rych regiony, w kt�rych powsta�y zosta�y za�o�one po 2012 roku.
--	 Por�wnaj te wyniki z wynikami z zadania 2.

SELECT P2.*, pmr.REGION_NAME FROM PRODUCTS P2 
	LEFT JOIN PRODUCT_MANUFACTURED_REGION PMR ON p2.PRODUCT_MAN_REGION = pmr.ID
		WHERE pmr.ESTABLISHED_YEAR > 2012

-- w wyniku odstaniemy tylko 2 rekordy		
		
--SELECT * FROM PRODUCTS P 
--SELECT * FROM PRODUCT_MANUFACTURED_REGION PMR 

--------------------------------------------------------------------------------------------------------

--4. Korzystaj�c z konstrukcji RIGHT JOIN po��cz dane sprzeda�owe (SALES, sal_prd_id) z
--	 podzapytaniem, w kt�rych dla danych produktowych uwzgl�dnij tylko te produkty
--	 (PRODUCTS, id), kt�rych ilo�� jednostek jest wi�ksza od 5 (product_quantity).
--	 W wynikach wy�wietl unikatow� nazw� produktu (product_name) oraz z��czeniem
--	 ROK_MIESI�C z danych sprzeda�owych - data sprzeda�y.
--	 Dane posortuj wed�ug pierwszej kolumny malej�co. 

SELECT DISTINCT 
	produkty5.product_name,
    CONCAT(	EXTRACT(YEAR FROM s.sal_date), '_', EXTRACT(MONTH FROM s.sal_date)) AS salesyearmonth
		FROM sales s
 		RIGHT JOIN (SELECT p.* FROM products p WHERE p.product_quantity > 5) produkty5 ON produkty5.id = s.sal_prd_id
ORDER BY produkty5.product_name DESC 
		
--------------------------------------------------------------------------------------------------------

--5. Dodaj nowy region do tabeli PRODUCT_MANUFACTURED_REGION. 
--	 Nast�pnie korzystaj�c z konstrukcji FULL JOIN po��cz dane o produktach
--	 (PRODUCTS,product_man_region) z danymi o regionach produkt�w w kt�rych
--	 zosta�y one stworzone (PRODUCT_MANUFACTURED_REGION, id)
--	 Wy�wietl w wynikach wszystkie atrybuty z obu tabel

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	VALUES ('South America', NULL, 2020);

SELECT * FROM PRODUCTS P 
	JOIN PRODUCT_MANUFACTURED_REGION PMR ON p.PRODUCT_MAN_REGION = pmr.ID 

--region South America wstawil sie jako id=6 a takiego id regionu nie ma w tabeli produktow wiec w wynikach go nie ma 
 
--------------------------------------------------------------------------------------------------------

--6. Uzyskaj te same wyniki, co w zadaniu 5 dla stworzonego zapytania, tym razem nie
--	 korzystaj ze sk�adni FULL JOIN. Wykorzystaj INNER JOIN / LEFT / RIGHT JOIN lub
--	 inne cz�ci SQL-a, kt�re znasz :)
								
SELECT * FROM PRODUCTS P 
	LEFT JOIN PRODUCT_MANUFACTURED_REGION PMR ON p.PRODUCT_MAN_REGION = pmr.ID 
	
--------------------------------------------------------------------------------------------------------

--7. Wykorzystaj konstrukcj� WITH i zmie� Twoje zapytanie z zadania 4 w taki spos�b, aby
--	 podzapytanie znalaz�o si� w sekcji CTE (common table expression = WITH) zapytania. 

WITH produkty5 AS 
	(SELECT * FROM products p WHERE p.product_quantity > 5)
SELECT DISTINCT 
	produkty5.product_name,
    CONCAT(	EXTRACT(YEAR FROM s.sal_date), '_', EXTRACT(MONTH FROM s.sal_date)) AS salesyearmonth
		FROM sales s
 		RIGHT JOIN produkty5 ON produkty5.id = s.sal_prd_id
ORDER BY produkty5.product_name DESC 
		
--------------------------------------------------------------------------------------------------------

--8. Usu� wszystkie te produkty (PRODUCTS), kt�re s� przypisane do regionu EMEA i kodu
--	 E_EMEA.
--	 Skorzystaj z konstrukcji USING lub EXISTS.

DELETE FROM PRODUCTS p1
	WHERE EXISTS 
	(SELECT 1 FROM PRODUCTS p2 JOIN PRODUCT_MANUFACTURED_REGION pmr ON 
		p1.id = p2.ID AND pmr.id = p2.PRODUCT_MAN_REGION AND pmr.REGION_CODE = 'E_EMEA' AND pmr.REGION_NAME = 'EMEA')
RETURNING *;

--------------------------------------------------------------------------------------------------------

--9. OPCJONALNE: Korzystaj�c z konstrukcji WITH RECURSIVE stw�rz ci�g Fibonacciego,
--	 kt�rego wyniki b�d� ograniczone do warto�ci poni�ej 100.

--------------------------------------------------------------------------------------------------------

