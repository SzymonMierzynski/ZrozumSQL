--Modu� 3 Data Definition Language � Zadania Teoria SQL

--1. Utworz nowy schemat o nazwie training
CREATE SCHEMA training;

--------------------------------------------------------------------------------------------------------

--2. Zmie� nazw� schematu na training_zs
ALTER SCHEMA training RENAME TO training_zs;


-- 3. Korzystaj�c z konstrukcji <nazwa_schematy>.<nazwa_tabeli> lub ��cz�c si� DO schematu training_zs, utw�rz tabel� wed�ug opisu.
-- Tabela: products; 
-- Kolumny: 
--  id - typ ca�kowity, 
--  production_qty - typ zmiennoprzecinkowy (numeric - 10 znak�w i do 2 znak�w po przecinku)
--  product_name - typ tekstowy 100 znak�w (NIE STALA ILOSC - patrz varchar)
--  product_code - typ tekstowy 10 znak�w
--  description - typ tekstowy nieograniczona ilo�� znak�w
--  manufacturing_date - typ data (sama data bez cz�ci godzin, minut, sekund)


CREATE TABLE TRAINING_ZS.products 
(
	id int,
	production_qty numeric(10,2),
	product_name varchar(100),
	product_code varchar(10),
	description text, 
	manufacturing_date date
);

--------------------------------------------------------------------------------------------------------

--4. Korzystaj�c ze sk�adni ALTER TABLE, dodaj klucz g��wny do tabeli products dla pola ID.

ALTER TABLE training_zs.products ADD PRIMARY KEY (id);

--lub
--ALTER TABLE training_zs.products ADD CONSTRAINT products_id_pk PRIMARY KEY (id); 

--------------------------------------------------------------------------------------------------------

--5. Korzystaj�c ze sk�adni IF EXISTS spr�buj usun�� tabel� sales ze schematu training_zs

DROP TABLE IF EXISTS training_zs.sales;

--------------------------------------------------------------------------------------------------------

-- 6. W schemacie training_zs, utw�rz now� tabel� sales wed�ug opisu.
-- Tabela: sales; 
-- Kolumny: 
--  id - typ ca�kowity, klucz g��wny, 
--  sales_date - typ data i czas (data + cz�� godziny, minuty, sekundy), to pole ma nie zawiera� warto�ci nieokre�lonych NULL,
--  sales_amount - typ zmiennoprzecinkowy (NUMERIC 38 znak�w, do 2 znak�w po przecinku)
--  sales_qty - typ zmiennoprzecinkowy (NUMERIC 10 znak�w, do 2 znak�w po przecinku)
--  product_id - typ ca�kowity INTEGER
--  added_by - typ tekstowy (nielimitowana ilo�� znak�w), z warto�ci� domy�ln� 'admin'
--- UWAGA: nie ma tego w materia�ach wideo. Przeczytaj o atrybucie DEFAULT dla kolumny https://www.postgresql.org/docs/12/ddl-default.html 
--  korzystaj�c z definiowania przy tworzeniu tabeli, po definicji kolumn, dodaj ograniczenie o nazwie sales_over_1k na polu sales_amount typu CHECK takie, 
--		�e warto�ci w polu sales_amount musz� by� wi�ksze od 1000

CREATE TABLE training_zs.sales
(
	id int PRIMARY KEY,
	sales_date TIMESTAMP NOT NULL,
	sales_amount NUMERIC(38,2),
	sales_qty NUMERIC(10,2),
	product_id int,
	added_by text DEFAULT 'admin',
	CONSTRAINT sales_over_1k CHECK (sales_amount > 1000)
);

--------------------------------------------------------------------------------------------------------

--7. Korzystaj�c z operacji ALTER utw�rz powi�zanie mi�dzy tabel� sales a products, 
--   jako klucz obcy pomi�dzy atrybutami product_id z tabeli sales i id z tabeli products. 
--   Dodatkowo nadaj kluczowi obcemu opcj� ON DELETE CASCADE

--w jednym kroku dodanie klucza i nadanie mu opcji ON DELETE CASCADE
ALTER TABLE TRAINING_ZS.SALES ADD FOREIGN KEY (product_id) REFERENCES training_zs.products  (id)  ON DELETE CASCADE;
--albo je�eli chcemy nada� w�asn� nazw� dla klucza to u�ywamy:
ALTER TABLE TRAINING_ZS.SALES ADD CONSTRAINT nazwa_sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES training_zs.products  (id)  ON DELETE CASCADE;


--w trzech krokach: 1. dodanie klucza obcego / 2. usuni�cie klucza / 3. dodanie klucza poprzez ALTER
ALTER TABLE TRAINING_ZS.SALES ADD CONSTRAINT nazwa_sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES training_zs.products (id);

ALTER TABLE TRAINING_ZS.SALES drop CONSTRAINT nazwa_sales_product_id_fkey;

ALTER TABLE TRAINING_ZS.SALES ADD CONSTRAINT sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES training_zs.products (id) ON DELETE CASCADE;

--------------------------------------------------------------------------------------------------------

--8. Korzystaj�c z polecenia DROP i opcji CASCADE usu� schemat training_zs

DROP SCHEMA training_zs CASCADE; 

