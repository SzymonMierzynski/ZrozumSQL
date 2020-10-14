--czesc 2
--Modu� 4 Data Control Language � PROJEKT

-----------------------------------

--1. Korzystaj�c ze sk�adni CREATE ROLE, stw�rz nowego u�ytkownika o nazwie expense_tracker_user z mo�liwo�ci� zalogowania si� do bazy danych i has�em silnym :) (co� wymy�l)

--CREATE ROLE expense_tracker_user WITH LOGIN PASSWORD '@xp@nc@tr@cker!';

DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE  rolname = 'expense_tracker_user') THEN
      CREATE ROLE my_user LOGIN PASSWORD '@xp@nc@tr@cker!';
   END IF;
END
$do$;

-----------------------------------

--2. Korzystaj�c ze sk�adni REVOKE, odbierz uprawnienia tworzenia obiekt�w w schemacie public roli PUBLIC

REVOKE CREATE ON SCHEMA public FROM public;

-----------------------------------

--3. Je�eli w Twoim �rodowisku istnieje ju� schemat expense_tracker (z obiektami tabel) usu� go korzystaj�c z polecenie DROP CASCADE.

DROP SCHEMA IF EXISTS expense_tracker CASCADE; 

-----------------------------------

--4. Utw�rz now� rol� expense_tracker_group.

--CREATE ROLE expense_tracker_group;

DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE  rolname = 'expense_tracker_group') THEN
      CREATE ROLE expense_tracker_group;
   END IF;
END
$do$;

-----------------------------------

--5. Utw�rz schemat expense_tracker, korzystaj�c z atrybutu AUTHORIZATION, ustalaj�c w�asno�� na rol� expense_tracker_group.

CREATE SCHEMA expense_tracker AUTHORIZATION expense_tracker_group;

-----------------------------------

--6. Dla roli expense_tracker_group, dodaj nast�puj�ce przywileje:
-- Dodaj przywilej ��czenia do bazy danych postgres (lub innej, je�eli korzystasz z innej nazwy)
-- Dodaj wszystkie przywileje do schematu expense_tracker

GRANT CONNECT ON DATABASE postgres TO expense_tracker_group;
GRANT USAGE, CREATE ON SCHEMA expense_tracker TO expense_tracker_group;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA expense_tracker TO expense_tracker_group;

-----------------------------------

--7. Dodaj rol� expense_tracker_group u�ytkownikowi expense_tracker_user.

---GRANT/REVOKE privileges ON object TO user;

GRANT expense_tracker_group TO expense_tracker_user;


-----------------------------------


--ZMIANY DO SKRYPTU MODU� 3
--8. Otw�rz skrypt z zdaniami projektowymi z Modu�y 3. Usu� fragment skryptu zwi�zany z tworzeniem schematu expense_tracker, teraz ten fragment b�dzie w tej cz�ci skryptu.
--9. Dla definicja tabel w skrypcie z zdaniami do Modu�u 3 dodaj relacj� kluczy obcych pomi�dzy tabelami. Zmie� definicj� CREATE TABLE, 
--nie dodawaj tego za po�rednictwem ALTER TABLE (b�dzie przejrzy�ciej).
--BANK_ACCOUNT_TYPES: Atrybut ID_BA_OWN ma by� referencj� do BANK_ACCOUNT_OWNER (ID_BA_OWN)
--TRANSACTIONS: Atrybut ID_TRANS_BA ma by� referencj� do TRANSACTION_BANK_ACCOUNTS (ID_TRANS_BA)
-- TRANSACTIONS: Atrybut ID_TRANS_CAT ma by� referencj� do TRANSACTION_CATEGORY (ID_TRANS_CAT)
-- TRANSACTIONS: Atrybut ID_TRANS_SUBCAT ma by� referencj� do TRANSACTION_SUBCATEGORY (ID_TRANS_SUBCAT)
-- TRANSACTIONS: Atrybut ID_TRANS_TYPE ma by� referencj� do TRANSACTION_TYPE (ID_TRANS_TYPE)
-- TRANSACTIONS: Atrybut ID_USER ma by� referencj� do USERS (ID_USER)
-- TRANSACTION_BANK_ACCOUNTS: Atrybut ID_BA_OWN ma by� referencj� do BANK_ACCOUNT_OWNER (ID_BA_OWN)
-- TRANSACTION_BANK_ACCOUNTS: Atrybut ID_BA_TYP ma by� referencj� do BANK_ACCOUNT_TYPES (ID_BA_TYPE)
-- TRANSACTION_SUBCATEGORY: Atrybut ID_TRANS_CAT ma by� referencj� do TRANSACTION_CATEGORY (ID_TRANS_CAT)
--10. Uszereguj tak wykonanie tabel w skrypcie, aby w momencie uruchomienia skryptu, nie by� zwracany b��d, �e dana relacja nie mo�e zosta� utworzona, bo tabela jeszcze nie istnieje.

--------------------------------------

--utw�rz tabel� bank_account_owner a je�li istnienie usu�
-----CREATE TABLE IF NOT EXISTS EXPENSE_TRACKER.bank_account_owner

--Tabela: bank_account_owner
--Kolumny:
-- id_ba_own, typ ca�kowity, klucz g��wny
-- owner_name, typ tekstowy 50 znak�w, not null
-- owner_desc, typ tekstowy 250 znak�w
-- user_login, typ ca�kowity, not null
-- active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu znakowego warto�� domy�lna 1, dla prawdy fa�sz ustaw prawd�, not null
-- insert_date, typ data i czas, warto�� domy�lna current_timestamp (spowoduje wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
-- update_date, typ data i czas, warto�� domy�lna current_timestamp

DROP TABLE IF EXISTS expense_tracker.bank_account_owner CASCADE;

CREATE TABLE EXPENSE_TRACKER.bank_account_owner
(
	id_ba_own int PRIMARY KEY,
	owner_name varchar(50) NOT NULL,
	owner_desc varchar(250),
	user_login int NOT NULL,
	active boolean DEFAULT TRUE NOT NULL,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp
);

--INSERT INTO EXPENSE_TRACKER.BANK_ACCOUNT_OWNER VALUES (5, 'OWNER','own_descr', 123);

--SELECT * FROM EXPENSE_TRACKER.BANK_ACCOUNT_OWNER; 

--------------------------------------

--Tabela: users
--Kolumny:
-- id_user, typ ca�kowity, klucz g��wny
-- user_login, typ tekstowy 25 znak�w, not null
-- user_name, typ tekstowy 50 znak�w, not null
-- user_password, typ tekstowy 100 znak�w, not null
-- password_salt, typ tekstowy 100 znak�w, not null
-- active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu znakowego warto�� domy�lna 1, dla prawdy fa�sz ustaw prawd�, , not null
-- insert_date, typ data i czas, warto�� domy�lna current_timestamp (spowoduje wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
-- update_date, typ data i czas, warto�� domy�lna current_timestamp

DROP TABLE IF EXISTS expense_tracker.users CASCADE;

CREATE TABLE expense_tracker.users
(
	id_user int PRIMARY KEY,
	user_login varchar(25) NOT NULL,
	user_name varchar(50) NOT NULL,
	user_password varchar(100) NOT NULL,
	password_salt varchar(100) NOT NULL,
	active boolean NOT NULL DEFAULT TRUE,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp
);

--------------------------------------

--Tabela: bank_account_types
--Kolumny:
-- id_ba_type, typ ca�kowity, klucz g��wny
-- ba_type, typ tekstowy 50 znak�w, not null
-- ba_desc, typ tekstowy 250 znak�w
-- active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu znakowego warto�� domy�lna 1, dla prawdy fa�sz ustaw prawd�, , not null
-- is_common_account, typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu znakowego warto�� domy�lna 0, dla prawdy fa�sz ustaw fa�sz, , not null
-- id_ba_own, typ ca�kowity
-- insert_date, typ data i czas, warto�� domy�lna current_timestamp (spowoduje wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
-- update_date, typ data i czas, warto�� domy�lna current_timestamp

DROP TABLE IF EXISTS expense_tracker.bank_account_types CASCADE;

CREATE TABLE expense_tracker.bank_account_types 
(
	id_ba_type int PRIMARY KEY,
	ba_type varchar(50) NOT NULL,
	ba_desc varchar(250),
	active boolean DEFAULT TRUE,
	is_common_account boolean NOT NULL DEFAULT FALSE,
	id_ba_own int,---------------------------------------------
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp,
	CONSTRAINT id_ba_own FOREIGN KEY (id_ba_own) REFERENCES expense_tracker.bank_account_owner  (id_ba_own)  ON DELETE CASCADE
);

--INSERT INTO EXPENSE_TRACKER.BANK_ACCOUNT_TYPES VALUES (1, 'typ1','descr1');

--SELECT * FROM EXPENSE_TRACKER.BANK_ACCOUNT_TYPES BAT; 

----------------------------------------------------------------------------------

--Tabela: transaction_category
--Kolumny:
-- id_trans_cat, typ ca�kowity, klucz g��wny
-- category_name, typ tekstowy 50 znak�w, not null
-- category_description, typ tekstowy 250 znak�w
-- active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu znakowego warto�� domy�lna 1, dla prawdy fa�sz ustaw prawd�, , not null
-- insert_date, typ data i czas, warto�� domy�lna current_timestamp (spowoduje wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
-- update_date, typ data i czas, warto�� domy�lna current_timestamp

DROP TABLE IF EXISTS expense_tracker.transaction_category CASCADE;

CREATE TABLE expense_tracker.transaction_category
(
	id_trans_cat int PRIMARY KEY,
	category_name varchar(50) NOT NULL,
	category_description varchar(250),
	active boolean NOT NULL DEFAULT TRUE,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp
);

----------------------------------------------------------------------------------

--Tabela: transaction_subcategory
--Kolumny:
-- id_trans_subcat, typ ca�kowity, klucz g��wny
-- id_trans_cat, typ ca�kowity
-- subcategory_name, typ tekstowy 50 znak�w, not null
-- subcategory_description, typ tekstowy 250 znak�w
-- active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu znakowego warto�� domy�lna 1, dla prawdy fa�sz ustaw prawd�, , not null
-- insert_date, typ data i czas, warto�� domy�lna current_timestamp (spowoduje wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
-- update_date, typ data i czas, warto�� domy�lna current_timestamp

DROP TABLE IF EXISTS expense_tracker.transaction_subcategory CASCADE;

CREATE TABLE expense_tracker.transaction_subcategory
(
	id_trans_subcat int PRIMARY KEY,
	id_trans_cat int,
	subcategory_name varchar(50) NOT NULL,
	subcategory_description varchar(250),
	active boolean NOT NULL DEFAULT TRUE,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp,
	CONSTRAINT id_trans_cat FOREIGN KEY (id_trans_cat) REFERENCES expense_tracker.transaction_category  (id_trans_cat)  ON DELETE CASCADE
);

----------------------------------------------------------------------------------

--Tabela: transaction_bank_accounts
--Kolumny:
-- id_trans_ba, typ ca�kowity, klucz g��wny
-- id_ba_own, typ ca�kowity,
-- id_ba_typ, typ ca�kowity,
-- bank_account_name, typ tekstowy 50 znak�w, not null
-- bank_account_desc, typ tekstowy 250 znak�w
-- active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu znakowego warto�� domy�lna 1, dla prawdy fa�sz ustaw prawd�, , not null
-- insert_date, typ data i czas, warto�� domy�lna current_timestamp (spowoduje wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
-- update_date, typ data i czas, warto�� domy�lna current_timestamp

DROP TABLE IF EXISTS expense_tracker.transaction_bank_accounts CASCADE;

CREATE TABLE expense_tracker.transaction_bank_accounts
(
	id_trans_ba int PRIMARY KEY,
	id_ba_own int,
	id_ba_typ int,
	bank_account_name varchar(50) NOT NULL,
	bank_account_desc varchar(250),
	active boolean NOT NULL DEFAULT TRUE,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp,
	CONSTRAINT id_ba_own FOREIGN KEY (id_ba_own) REFERENCES expense_tracker.bank_account_owner  (id_ba_own)  ON DELETE CASCADE,
	CONSTRAINT id_ba_typ FOREIGN KEY (id_ba_typ) REFERENCES expense_tracker.bank_account_types  (id_ba_type)  ON DELETE CASCADE
);

----------------------------------------------------------------------------------

--Tabela: transaction_type
--Kolumny:
-- id_trans_type, typ ca�kowity, klucz g��wny
-- transaction_type_name, typ tekstowy 50 znak�w, not null
-- transaction_type_desc, typ tekstowy 250 znak�w
-- active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu znakowego warto�� domy�lna 1, dla prawdy fa�sz ustaw prawd�, , not null
-- insert_date, typ data i czas, warto�� domy�lna current_timestamp (spowoduje wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
-- update_date, typ data i czas, warto�� domy�lna current_timestamp

DROP TABLE IF EXISTS expense_tracker.transaction_type CASCADE;

CREATE TABLE expense_tracker.transaction_type
(
	id_trans_type int PRIMARY KEY,
	transaction_type_name varchar(50) NOT NULL,
	transaction_type_desc varchar(250),
	active boolean NOT NULL DEFAULT TRUE,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp
);

----------------------------------------------------------------------------------

--Tabela: transactions
--Kolumny:
-- id_transaction, typ ca�kowity, klucz g��wny
-- id_trans_ba, typ ca�kowity
-- id_trans_cat, typ ca�kowity
-- id_trans_subcat, typ ca�kowity
-- id_trans_type, typ ca�kowity
-- id_user, typ ca�kowity
-- transaction_date, typ daty (sama data), warto�� domy�lna current_date (spowoduje wstawianie aktualnej daty w momencie wstawiania wierszy)
-- transaction_value, typ zmiennoprzecinkowy (numeric, 9 znak�w, do 2 znak�w po przecinku)
-- transaction_description, typ tekstowy (nieograniczony)
-- insert_date, typ data i czas, warto�� domy�lna current_timestamp (spowoduje wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
-- update_date, typ data i czas, warto�� domy�lna current_timestamp

DROP TABLE IF EXISTS expense_tracker.transactions CASCADE;

CREATE TABLE expense_tracker.transactions
(
	id_transaction int PRIMARY KEY,
	id_trans_ba int,
	id_trans_cat int,
	id_trans_subcat int,
	id_trans_type int,
	id_user int,
	transaction_date date DEFAULT current_date,
	transaction_value NUMERIC(9,2),
	transaction_description TEXT,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp,
	CONSTRAINT id_trans_ba FOREIGN KEY (id_trans_ba) REFERENCES expense_tracker.transaction_bank_accounts  (id_trans_ba) ON DELETE CASCADE,
	CONSTRAINT id_trans_cat FOREIGN KEY (id_trans_cat) REFERENCES expense_tracker.transaction_category (id_trans_cat) ON DELETE CASCADE,
	CONSTRAINT id_trans_subcat FOREIGN KEY (id_trans_subcat) REFERENCES expense_tracker.transaction_subcategory (id_trans_subcat) ON DELETE CASCADE,
	CONSTRAINT id_trans_type FOREIGN KEY (id_trans_type) REFERENCES expense_tracker.transaction_type  (id_trans_type) ON DELETE CASCADE,
	CONSTRAINT id_user FOREIGN KEY (id_user) REFERENCES expense_tracker.users  (id_user) ON DELETE CASCADE	
);

----------------------------------------------------------------------------------
