--Modu³ 6 Data Query Language – Zadania Teoria SQL


--0. utwórz obiekty potrzebne do zadania

--------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS products;

CREATE TABLE products 
(
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO products (product_name, product_code, product_quantity, manufactured_date)
	SELECT 'Product '||floor(random() * 10 + 1)::int,
	'PRD'||floor(random() * 10 + 1)::int,
	random() * 10 + 1,
	CAST((NOW() - (random() * (interval '90 days')))::timestamp AS date)
	FROM generate_series(1, 10) s(i);
	
DROP TABLE IF EXISTS sales;

CREATE TABLE sales 
(
	id SERIAL,
	sal_description TEXT,
	sal_date DATE,
	sal_value NUMERIC(10,2),
	sal_qty NUMERIC(10,2),
	sal_product_id INTEGER,
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);


INSERT INTO sales (sal_description, sal_date, sal_value, sal_qty, sal_product_id)
	SELECT left(md5(i::text), 15),
	CAST((NOW() - (random() * (interval '60 days'))) AS DATE),
	random() * 100 + 1,
	floor(random() * 10 + 1)::int,
	floor(random() * 10)::int
	FROM generate_series(1, 10000) s(i);

--------------------------------------------------------------------------------------------------------

--1. Wyœwietl unikatowe daty stworzenia produktów (wed³ug atrybutu manufactured_date)

SELECT DISTINCT MANUFACTURED_DATE FROM PRODUCTS 

--------------------------------------------------------------------------------------------------------

--2. Jak sprawdzisz czy 10 wstawionych produktów to 10 unikatowych kodów produktów?

SELECT COUNT(*) FROM PRODUCTS 
--mamy 10 wyników

SELECT count(DISTINCT PRODUCT_CODE) FROM PRODUCTS 
--mamy 8 wyników
 
--------------------------------------------------------------------------------------------------------

--3. Korzystaj¹c ze sk³adni IN wyœwietl produkty od kodach PRD1 i PRD9

SELECT * FROM PRODUCTS WHERE PRODUCT_CODE IN ('PRD1', 'PRD9')

--------------------------------------------------------------------------------------------------------

--4. Wyœwietl wszystkie atrybuty z danych sprzeda¿owych, takie ¿e data sprzeda¿y jest w zakresie od 1 sierpnia 2020 do 31 sierpnia 2020 (w³¹cznie). 
--   Dane wynikowe maj¹ byæ posortowane wed³ug wartoœci sprzeda¿y malej¹co i daty sprzeda¿y rosn¹co.

-- nie ma daty sprzeda¿y z tego zakresu jak w zadaniu wiêc zrobi³em zakres z wrzeœnia aby by³y wyniki
SELECT * FROM SALES 
	WHERE sal_date BETWEEN '2020-09-01' AND '2020-09-30' 
	ORDER BY sal_value DESC, sal_date ASC 

--------------------------------------------------------------------------------------------------------

--5. Korzystaj¹c ze sk³adni NOT EXISTS wyœwietl te produkty z tabeli PRODUCTS, które nie bior¹ udzia³u w transakcjach sprzeda¿owych (tabela SALES). 
--   ID z tabeli Products i SAL_PRODUCT_ID to klucz ³¹czenia.

--SELECT * FROM PRODUCTS 

--SELECT * FROM SALES

SELECT * FROM PRODUCTS P 
	WHERE NOT EXISTS 
				(SELECT 1 FROM sales S WHERE p.ID = s.sal_product_id) 

--------------------------------------------------------------------------------------------------------

--6. Korzystaj¹c ze sk³adni ANY i operatora = wyœwietl te produkty, których wystêpuj¹ w transakcjach sprzeda¿owych 
--   (wed³ug klucza Products ID, Sales SAL_PRODUCT_ID) takich, ¿e wartoœæ sprzeda¿y w transakcji jest wiêksza od 100.

--SELECT * FROM PRODUCTS P 		
				
--SELECT * FROM SALES 
				
-- ANY
SELECT * 
  FROM products
 WHERE id = ANY (SELECT sal_product_id FROM sales WHERE sal_value > 100)			
								
--------------------------------------------------------------------------------------------------------

--7. Stwórz now¹ tabelê PRODUCTS_OLD_WAREHOUSE o takich samych kolumnach jak istniej¹ca tabela produktów (tabela PRODUCTS). 
--   Wstaw do nowej tabeli kilka wierszy - dowolnych wed³ug Twojego uznania.

DROP TABLE IF EXISTS PRODUCTS_OLD_WAREHOUSE;

CREATE TABLE PRODUCTS_OLD_WAREHOUSE
(
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO PRODUCTS_OLD_WAREHOUSE (SELECT * FROM PRODUCTS WHERE MANUFACTURED_DATE > '2020-09-01')

UPDATE PRODUCTS_OLD_WAREHOUSE SET product_code =

SELECT * FROM PRODUCTS_OLD_WAREHOUSE

--------------------------------------------------------------------------------------------------------

--8. Na podstawie tabeli z zadania 7, korzystaj¹c z operacji UNION oraz UNION ALL 
--   po³¹cz tabelê PRODUCTS_OLD_WAREHOUSE z 5 dowolnym produktami z tabeli PRODUCTS, w wyniku wyœwietl jedynie 
--   nazwê produktu (kolumna PRODUCT_NAME) i kod produktu (kolumna PRODUCT_CODE). Czy w przypadku wykorzystania UNION jakieœ wierszy zosta³y pominiête?


SELECT PRODUCT_NAME, PRODUCT_CODE FROM PRODUCTS --WHERE MANUFACTURED_DATE < '2020-08-27'
UNION 
SELECT PRODUCT_NAME, PRODUCT_CODE FROM PRODUCTS_OLD_WAREHOUSE
order BY product_name, product_code

-- UNION ALL - pokaza³ 14 wyników, tak¿e zdublowane
-- UNION - pokaza³ 10 wyników, tylko unikanle na zadanych kolumnach (PRODUCT_NAME, PRODUCT_CODE)

--------------------------------------------------------------------------------------------------------

--9. Na podstawie tabeli z zadania 7, korzystaj¹c z operacji EXCEPT znajdŸ ró¿nicê zbiorów pomiêdzy tabel¹ PRODUCTS_OLD_WAREHOUSE a PRODUCTS, 
--   w wyniku wyœwietl jedynie kod produktu (kolumna PRODUCT_CODE).

SELECT pw.product_code FROM products_old_warehouse pw
EXCEPT 
SELECT p.product_code FROM products p

--------------------------------------------------------------------------------------------------------

--10. Wyœwietl 10 rekordów z tabeli sprzeda¿owej sales. Dane powinny byæ posortowane wed³ug wartoœci sprzeda¿y (kolumn SAL_VALUE) malej¹co.

SELECT * FROM SALES
	ORDER BY sal_value DESC 
	LIMIT 10
--------------------------------------------------------------------------------------------------------

--11. Korzystaj¹c z funkcji SUBSTRING na atrybucie SAL_DESCRIPTION, wyœwietl 3 dowolne wiersze z tabeli sprzeda¿owej w taki sposób, 
--    aby w kolumnie wynikowej dla SUBSTRING z SAL_DESCRIPTION wyœwietlonych zosta³o tylko 3 pierwsze znaki.

SELECT SUBSTRING(sal_description,1,3) FROM SALES LIMIT 3

--------------------------------------------------------------------------------------------------------

--12. Korzystaj¹c ze sk³adni LIKE znajdŸ wszystkie dane sprzeda¿owe, których opis sprzeda¿y (SAL_DESCRIPTION) zaczyna siê od c4c.

SELECT * FROM SALES WHERE sal_description LIKE 'c4c%' 
