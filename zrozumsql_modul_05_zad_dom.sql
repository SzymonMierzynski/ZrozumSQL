--Modu³ 5 Data Manipulation Language – Zadania Teoria SQL


--1. Utwórz nowy schemat dml_exercises

CREATE SCHEMA IF NOT EXISTS dml_exercises;

--------------------------------------------------------------------------------------------------------

--2. Utwórz now¹ tabelê sales w schemacie dml_exercises wed³ug opisu:
--Tabela: sales;
--Kolumny:
-- id - typ SERIAL, klucz g³ówny,
-- sales_date - typ data i czas (data + czêœæ godziny, minuty, sekundy), to pole ma nie zawieraæ wartoœci nieokreœlonych NULL,
-- sales_amount - typ zmiennoprzecinkowy (NUMERIC 38 znaków, do 2 znaków po przecinku)
-- sales_qty - typ zmiennoprzecinkowy (NUMERIC 10 znaków, do 2 znaków po przecinku)
-- added_by - typ tekstowy (nielimitowana iloœæ znaków), z wartoœci¹ domyœln¹ 'admin'
-- korzystaj¹c z definiowania przy tworzeniu tabeli, po definicji kolumn, dodaje ograniczenie o nazwie sales_less_1k na polu sales_amount typu CHECK takie, 
-- ¿e wartoœci w polu sales_amount musz¹ byæ mniejsze lub równe 1000

DROP TABLE IF EXISTS dml_exercises.sales;

CREATE TABLE DML_EXERCISES.sales 
(
	id SERIAL PRIMARY KEY,
	sales_date TIMESTAMP NOT NULL,
	sales_amount NUMERIC(38,2),
	sales_qty NUMERIC(10,2),
	added_by TEXT DEFAULT 'admin',
	CONSTRAINT sales_less_1k CHECK (sales_amount <= 1000)
);

--------------------------------------------------------------------------------------------------------

--3. Dodaj to tabeli kilka wierszy korzystaj¹c ze sk³adni INSERT INTO
--3.1 Tak, aby id by³o generowane przez sekwencjê

INSERT INTO DML_EXERCISES.SALES (SALES_DATE, SALES_AMOUNT, SALES_QTY, ADDED_BY)
	VALUES 	('2020-01-03 12:13:14', 1000, 20, 'Jan'),
			('2019-12-21 15:00:00', 999, 1, 'Tomasz'),
			('2020-05-05 08:08:08', 600, 35, 'Anna');

SELECT * FROM DML_EXERCISES.SALES;

--------------------------------------------------------------------------------------------------------

--3. Dodaj to tabeli kilka wierszy korzystaj¹c ze sk³adni INSERT INTO
--3.2 Tak by pod pole added_by wpisaæ wartoœæ nieokreœlon¹ NULL

INSERT INTO DML_EXERCISES.SALES (SALES_DATE, SALES_AMOUNT, SALES_QTY, ADDED_BY)
	VALUES 	('2020-01-03 12:13:14', 1000, 20, NULL),
			('2019-12-21 15:00:00', 999, 1, NULL),
			('2020-05-05 08:08:08', 600, 35, NULL);

SELECT * FROM DML_EXERCISES.SALES;

--------------------------------------------------------------------------------------------------------

--3. Dodaj to tabeli kilka wierszy korzystaj¹c ze sk³adni INSERT INTO
--3.3 Tak, aby sprawdziæ zachowanie ograniczenia sales_less_1k, gdy wpiszemy wartoœci wiêksze od 1000

INSERT INTO DML_EXERCISES.SALES (SALES_DATE, SALES_AMOUNT, SALES_QTY, ADDED_BY)
	VALUES 	('2020-01-03 12:13:14', 1000, 20, NULL),
			('2019-12-21 15:00:00', 9999, 1, NULL),
			('2020-05-05 08:08:08', 600, 35, NULL);

--otrzymujemy blad:
--SQL Error [23514]: ERROR: new row for relation "sales" violates check constraint "sales_less_1k"
--Detail: Failing row contains (20, 2019-12-21 15:00:00, 9999.00, 1.00, null).

--------------------------------------------------------------------------------------------------------

--4. Co zostanie wstawione, jako format godzina (HH), minuta (MM), sekunda (SS), w polu sales_date, jak wstawimy do tabeli nastêpuj¹cy rekord.
--INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
--VALUES ('20/11/2019', 101, 50, NULL);

INSERT INTO DML_EXERCISES.SALES (SALES_DATE, SALES_AMOUNT, SALES_QTY, ADDED_BY)
	VALUES 	('2020-01-03', 101, 50, NULL);

SELECT * FROM DML_EXERCISES.SALES;

--otrzymamy wartoœæ sales_date = '2020-01-03 00:00:00'

--------------------------------------------------------------------------------------------------------

--5. Jaka bêdzie wartoœæ w atrybucie sales_date, po wstawieniu wiersza jak poni¿ej. Jak zintepretujesz miesi¹c i dzieñ, ¿eby mieæ pewnoœæ, o jaki konkretnie chodzi.
--INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
--VALUES ('04/04/2020', 101, 50, NULL);

INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
	VALUES ('2020/04/04', 101, 50, NULL);

SELECT EXTRACT(MONTH FROM SALES_DATE) AS sales_month, EXTRACT(DAY FROM SALES_DATE) AS sales_day, * FROM DML_EXERCISES.SALES;

--------------------------------------------------------------------------------------------------------

--6. Dodaj do tabeli sales wstaw wiersze korzystaj¹c z poni¿szego polecenia
--INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty,added_by)
--SELECT NOW() + (random() * (interval '90 days')) + '30 days',
--random() * 500 + 1,
--random() * 100 + 1,
--NULL
--FROM generate_series(1, 20000) s(i);

INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty,added_by)
	SELECT NOW() + (random() * (interval '90 days')) + '30 days',
	random() * 500 + 1,
	random() * 100 + 1,
	NULL
	FROM generate_series(1, 20000) s(i);

--Updated Rows	20000

--------------------------------------------------------------------------------------------------------

--7. Korzystaj¹c ze sk³adni UPDATE, zaktualizuj atrybut added_by, wpisuj¹c mu wartoœæ
--'sales_over_200', gdy wartoœæ sprzeda¿y (sales_amount jest wiêksza lub równa 200)

UPDATE DML_EXERCISES.SALES 
	SET ADDED_BY = 'sales_over_200' 
	WHERE 
		sales_amount >= 200;
	
--Updated Rows	12039

--------------------------------------------------------------------------------------------------------

--8. Korzystaj¹c ze sk³adni DELETE, usuñ te wiersze z tabeli sales, dla których wartoœæ w polu
--added_by jest wartoœci¹ nieokreœlon¹ NULL. SprawdŸ ró¿nicê miêdzy zapisemm added_by =
--NULL, a added_by IS NULL

--przed wykonaniem ponizszych operacji przelaczylem commit na manual aby moc cofnac operacje i porownac
	
DELETE FROM DML_EXERCISES.SALES 
	WHERE 
		ADDED_BY = NULL 
--Updated Rows	0
		

DELETE FROM DML_EXERCISES.SALES 
	WHERE 
		ADDED_BY IS NULL 
--Updated Rows	7971

--------------------------------------------------------------------------------------------------------

--9. Wyczyœæ wszystkie dane z tabeli sales i zrestartuj sekwencje

TRUNCATE DML_EXERCISES.SALES RESTART IDENTITY;

SELECT * FROM DML_EXERCISES.SALES;

--------------------------------------------------------------------------------------------------------

--10. DODATKOWE ponownie wstaw do tabeli sales wiersze jak w zadaniu 4. (jak w zadaniu 6)
--Utwórz kopiê zapasow¹ tabeli do pliku. Nastêpnie usuñ tabelê ze schematu dml_exercises i
--odtwórz j¹ z kopii zapasowej.

INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty,added_by)
	SELECT NOW() + (random() * (interval '90 days')) + '30 days',
	random() * 500 + 1,
	random() * 100 + 1,
	NULL
	FROM generate_series(1, 20000) s(i);

pg_dump --host localhost ^
        --port 5432 ^
        --username postgres ^
        --format d ^
        --file "c:\1\dml_exercises_sales_dump" ^
        --table dml_exercises.sales ^
        postgres

DROP TABLE DML_EXERCISES.SALES;
        
pg_restore --host localhost ^
           --port 5432 ^
           --username postgres ^
           --dbname postgres ^
           --clean ^
           "c:\1\dml_exercises_sales_dump"

SELECT * FROM DML_EXERCISES.SALES;

SELECT COUNT(*) FROM DML_EXERCISES.SALES;
--20000 rekordow