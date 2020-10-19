--Modu� 5 Data Manipulation Language � Zadania Teoria SQL


--1. Utw�rz nowy schemat dml_exercises

CREATE SCHEMA IF NOT EXISTS dml_exercises;

--------------------------------------------------------------------------------------------------------

--2. Utw�rz now� tabel� sales w schemacie dml_exercises wed�ug opisu:
--Tabela: sales;
--Kolumny:
-- id - typ SERIAL, klucz g��wny,
-- sales_date - typ data i czas (data + cz�� godziny, minuty, sekundy), to pole ma nie zawiera� warto�ci nieokre�lonych NULL,
-- sales_amount - typ zmiennoprzecinkowy (NUMERIC 38 znak�w, do 2 znak�w po przecinku)
-- sales_qty - typ zmiennoprzecinkowy (NUMERIC 10 znak�w, do 2 znak�w po przecinku)
-- added_by - typ tekstowy (nielimitowana ilo�� znak�w), z warto�ci� domy�ln� 'admin'
-- korzystaj�c z definiowania przy tworzeniu tabeli, po definicji kolumn, dodaje ograniczenie o nazwie sales_less_1k na polu sales_amount typu CHECK takie, 
-- �e warto�ci w polu sales_amount musz� by� mniejsze lub r�wne 1000

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

--3. Dodaj to tabeli kilka wierszy korzystaj�c ze sk�adni INSERT INTO
--3.1 Tak, aby id by�o generowane przez sekwencj�

INSERT INTO DML_EXERCISES.SALES (SALES_DATE, SALES_AMOUNT, SALES_QTY, ADDED_BY)
	VALUES 	('2020-01-03 12:13:14', 1000, 20, 'Jan'),
			('2019-12-21 15:00:00', 999, 1, 'Tomasz'),
			('2020-05-05 08:08:08', 600, 35, 'Anna');

SELECT * FROM DML_EXERCISES.SALES;

--------------------------------------------------------------------------------------------------------

--3. Dodaj to tabeli kilka wierszy korzystaj�c ze sk�adni INSERT INTO
--3.2 Tak by pod pole added_by wpisa� warto�� nieokre�lon� NULL

INSERT INTO DML_EXERCISES.SALES (SALES_DATE, SALES_AMOUNT, SALES_QTY, ADDED_BY)
	VALUES 	('2020-01-03 12:13:14', 1000, 20, NULL),
			('2019-12-21 15:00:00', 999, 1, NULL),
			('2020-05-05 08:08:08', 600, 35, NULL);

SELECT * FROM DML_EXERCISES.SALES;

--------------------------------------------------------------------------------------------------------

--3. Dodaj to tabeli kilka wierszy korzystaj�c ze sk�adni INSERT INTO
--3.3 Tak, aby sprawdzi� zachowanie ograniczenia sales_less_1k, gdy wpiszemy warto�ci wi�ksze od 1000

INSERT INTO DML_EXERCISES.SALES (SALES_DATE, SALES_AMOUNT, SALES_QTY, ADDED_BY)
	VALUES 	('2020-01-03 12:13:14', 1000, 20, NULL),
			('2019-12-21 15:00:00', 9999, 1, NULL),
			('2020-05-05 08:08:08', 600, 35, NULL);

--otrzymujemy blad:
--SQL Error [23514]: ERROR: new row for relation "sales" violates check constraint "sales_less_1k"
--Detail: Failing row contains (20, 2019-12-21 15:00:00, 9999.00, 1.00, null).

--------------------------------------------------------------------------------------------------------

--4. Co zostanie wstawione, jako format godzina (HH), minuta (MM), sekunda (SS), w polu sales_date, jak wstawimy do tabeli nast�puj�cy rekord.
--INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
--VALUES ('20/11/2019', 101, 50, NULL);

INSERT INTO DML_EXERCISES.SALES (SALES_DATE, SALES_AMOUNT, SALES_QTY, ADDED_BY)
	VALUES 	('2020-01-03', 101, 50, NULL);

SELECT * FROM DML_EXERCISES.SALES;

--otrzymamy warto�� sales_date = '2020-01-03 00:00:00'

--------------------------------------------------------------------------------------------------------

--5. Jaka b�dzie warto�� w atrybucie sales_date, po wstawieniu wiersza jak poni�ej. Jak zintepretujesz miesi�c i dzie�, �eby mie� pewno��, o jaki konkretnie chodzi.
--INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
--VALUES ('04/04/2020', 101, 50, NULL);

INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
	VALUES ('2020/04/04', 101, 50, NULL);

SELECT EXTRACT(MONTH FROM SALES_DATE) AS sales_month, EXTRACT(DAY FROM SALES_DATE) AS sales_day, * FROM DML_EXERCISES.SALES;

--------------------------------------------------------------------------------------------------------

--6. Dodaj do tabeli sales wstaw wiersze korzystaj�c z poni�szego polecenia
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

--7. Korzystaj�c ze sk�adni UPDATE, zaktualizuj atrybut added_by, wpisuj�c mu warto��
--'sales_over_200', gdy warto�� sprzeda�y (sales_amount jest wi�ksza lub r�wna 200)

UPDATE DML_EXERCISES.SALES 
	SET ADDED_BY = 'sales_over_200' 
	WHERE 
		sales_amount >= 200;
	
--Updated Rows	12039

--------------------------------------------------------------------------------------------------------

--8. Korzystaj�c ze sk�adni DELETE, usu� te wiersze z tabeli sales, dla kt�rych warto�� w polu
--added_by jest warto�ci� nieokre�lon� NULL. Sprawd� r�nic� mi�dzy zapisemm added_by =
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

--9. Wyczy�� wszystkie dane z tabeli sales i zrestartuj sekwencje

TRUNCATE DML_EXERCISES.SALES RESTART IDENTITY;

SELECT * FROM DML_EXERCISES.SALES;

--------------------------------------------------------------------------------------------------------

--10. DODATKOWE ponownie wstaw do tabeli sales wiersze jak w zadaniu 4. (jak w zadaniu 6)
--Utw�rz kopi� zapasow� tabeli do pliku. Nast�pnie usu� tabel� ze schematu dml_exercises i
--odtw�rz j� z kopii zapasowej.

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