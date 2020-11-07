--Modu³ 7 Data Query Language – JOINS - Zadania Teoria SQL


--0. utwórz obiekty potrzebne do zadania

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

--1. Korzystaj¹c z konstrukcji INNER JOIN po³¹cz dane sprzeda¿owe (SALES, sal_prd_id) z
--   danymi o produktach (PRODUCTS, id). W wynikach poka¿ tylko te produkty, które
--   powsta³y w regionie EMEA. Wyniki ogranicz do 100 wierszy.

-- po zlaczeniu tabel sales i products nie bylo w nich informacji o regionach wiec dodalem tabele produst_manufactured_region ktora te informacje ma      
      
 SELECT * FROM SALES S 
 	JOIN PRODUCTS P ON s.sal_prd_id = p.id
 	JOIN PRODUCT_MANUFACTURED_REGION PMR ON p.PRODUCT_MAN_REGION = pmr.id
 WHERE pmr.REGION_NAME = 'EMEA'
LIMIT 100
 
--SELECT * FROM PRODUCTS P 
--SELECT * FROM PRODUCT_MANUFACTURED_REGION PMR 
--------------------------------------------------------------------------------------------------------

--2. Korzystaj¹c z konstrukcji LEFT JOIN po³¹cz dane o produktach (PRODUCTS,
--   product_man_region) z danymi o regionach w których produkty powsta³y
--	 (PRODUCT_MANUFACTURED_REGION, id)
--	 W wynikach wyœwietl wszystkie atrybuty z tabeli produktów i atrybut REGION_NAME
--	 z tabeli PRODUCT_MANUFACTURED_REGION. Dodatkowo w trakcie z³¹czenia
--	 ogranicz dane brane przy z³¹czenia do tych regionów, które zosta³y za³o¿one po 2012
--	 roku.

SELECT P2.*, pmr.REGION_NAME FROM PRODUCTS P2 
	LEFT JOIN PRODUCT_MANUFACTURED_REGION PMR ON p2.PRODUCT_MAN_REGION = pmr.ID AND pmr.ESTABLISHED_YEAR > 2012 

-- w wyniku odstaniemy wszystkie 10 produków a tam gdzie regiony zostaly zalozone po 2012 mamy NULL
	
--SELECT * FROM PRODUCTS P 
--SELECT * FROM PRODUCT_MANUFACTURED_REGION PMR 

--------------------------------------------------------------------------------------------------------

--3. Korzystaj¹c z konstrukcji LEFT JOIN po³¹cz dane o produktach (PRODUCTS,
--	 product_man_region) z danymi o regionach w których produkty powsta³y
--	 (PRODUCT_MANUFACTURED_REGION, id).
--	 W wynikach wyœwietl wszystkie atrybuty z tabeli produktów i atrybut REGION_NAME
--	 z tabeli PRODUCT_MANUFACTURED_REGION.
-- 	 Dodatkowo wyfiltruj dane wynikowe taki sposób, aby pokazaæ tylko te produkty, dla
--	 których regiony, w których powsta³y zosta³y za³o¿one po 2012 roku.
--	 Porównaj te wyniki z wynikami z zadania 2.

SELECT P2.*, pmr.REGION_NAME FROM PRODUCTS P2 
	LEFT JOIN PRODUCT_MANUFACTURED_REGION PMR ON p2.PRODUCT_MAN_REGION = pmr.ID
		WHERE pmr.ESTABLISHED_YEAR > 2012

-- w wyniku odstaniemy tylko 2 rekordy		
		
--SELECT * FROM PRODUCTS P 
--SELECT * FROM PRODUCT_MANUFACTURED_REGION PMR 

--------------------------------------------------------------------------------------------------------

--4. Korzystaj¹c z konstrukcji RIGHT JOIN po³¹cz dane sprzeda¿owe (SALES, sal_prd_id) z
--	 podzapytaniem, w których dla danych produktowych uwzglêdnij tylko te produkty
--	 (PRODUCTS, id), których iloœæ jednostek jest wiêksza od 5 (product_quantity).
--	 W wynikach wyœwietl unikatow¹ nazwê produktu (product_name) oraz z³¹czeniem
--	 ROK_MIESI¥C z danych sprzeda¿owych - data sprzeda¿y.
--	 Dane posortuj wed³ug pierwszej kolumny malej¹co. 

SELECT DISTINCT 
	produkty5.product_name,
    CONCAT(	EXTRACT(YEAR FROM s.sal_date), '_', EXTRACT(MONTH FROM s.sal_date)) AS salesyearmonth
		FROM sales s
 		RIGHT JOIN (SELECT p.* FROM products p WHERE p.product_quantity > 5) produkty5 ON produkty5.id = s.sal_prd_id
ORDER BY produkty5.product_name DESC 
		
--------------------------------------------------------------------------------------------------------

--5. Dodaj nowy region do tabeli PRODUCT_MANUFACTURED_REGION. 
--	 Nastêpnie korzystaj¹c z konstrukcji FULL JOIN po³¹cz dane o produktach
--	 (PRODUCTS,product_man_region) z danymi o regionach produktów w których
--	 zosta³y one stworzone (PRODUCT_MANUFACTURED_REGION, id)
--	 Wyœwietl w wynikach wszystkie atrybuty z obu tabel

INSERT INTO product_manufactured_region (region_name, region_code, established_year)
	VALUES ('South America', NULL, 2020);

SELECT * FROM PRODUCTS P 
	JOIN PRODUCT_MANUFACTURED_REGION PMR ON p.PRODUCT_MAN_REGION = pmr.ID 

--region South America wstawil sie jako id=6 a takiego id regionu nie ma w tabeli produktow wiec w wynikach go nie ma 
 
--------------------------------------------------------------------------------------------------------

--6. Uzyskaj te same wyniki, co w zadaniu 5 dla stworzonego zapytania, tym razem nie
--	 korzystaj ze sk³adni FULL JOIN. Wykorzystaj INNER JOIN / LEFT / RIGHT JOIN lub
--	 inne czêœci SQL-a, które znasz :)
								
SELECT * FROM PRODUCTS P 
	LEFT JOIN PRODUCT_MANUFACTURED_REGION PMR ON p.PRODUCT_MAN_REGION = pmr.ID 
	
--------------------------------------------------------------------------------------------------------

--7. Wykorzystaj konstrukcjê WITH i zmieñ Twoje zapytanie z zadania 4 w taki sposób, aby
--	 podzapytanie znalaz³o siê w sekcji CTE (common table expression = WITH) zapytania. 

WITH produkty5 AS 
	(SELECT * FROM products p WHERE p.product_quantity > 5)
SELECT DISTINCT 
	produkty5.product_name,
    CONCAT(	EXTRACT(YEAR FROM s.sal_date), '_', EXTRACT(MONTH FROM s.sal_date)) AS salesyearmonth
		FROM sales s
 		RIGHT JOIN produkty5 ON produkty5.id = s.sal_prd_id
ORDER BY produkty5.product_name DESC 
		
--------------------------------------------------------------------------------------------------------

--8. Usuñ wszystkie te produkty (PRODUCTS), które s¹ przypisane do regionu EMEA i kodu
--	 E_EMEA.
--	 Skorzystaj z konstrukcji USING lub EXISTS.

DELETE FROM PRODUCTS p1
	WHERE EXISTS 
	(SELECT 1 FROM PRODUCTS p2 JOIN PRODUCT_MANUFACTURED_REGION pmr ON 
		p1.id = p2.ID AND pmr.id = p2.PRODUCT_MAN_REGION AND pmr.REGION_CODE = 'E_EMEA' AND pmr.REGION_NAME = 'EMEA')
RETURNING *;

--------------------------------------------------------------------------------------------------------

--9. OPCJONALNE: Korzystaj¹c z konstrukcji WITH RECURSIVE stwórz ci¹g Fibonacciego,
--	 którego wyniki bêd¹ ograniczone do wartoœci poni¿ej 100.

--------------------------------------------------------------------------------------------------------

