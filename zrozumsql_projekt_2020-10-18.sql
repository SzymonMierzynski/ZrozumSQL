--czesc 3
--Modu³ 5 Data Manipulation Language – PROJEKT

-----------------------------------

--zostawiam kroki z poprzedniej czesci projektu nadajace dostepy/uprawnienia itp

DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE  rolname = 'expense_tracker_user') THEN
      CREATE ROLE my_user LOGIN PASSWORD '@xp@nc@tr@cker!';
   END IF;
END
$do$;

REVOKE CREATE ON SCHEMA public FROM public;

DROP SCHEMA IF EXISTS expense_tracker CASCADE; 

DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE  rolname = 'expense_tracker_group') THEN
      CREATE ROLE expense_tracker_group;
   END IF;
END
$do$;

CREATE SCHEMA expense_tracker AUTHORIZATION expense_tracker_group;

GRANT CONNECT ON DATABASE postgres TO expense_tracker_group;
GRANT USAGE, CREATE ON SCHEMA expense_tracker TO expense_tracker_group;
GRANT ALL PRIVILEGES ON SCHEMA expense_tracker TO expense_tracker_group;

GRANT expense_tracker_group TO expense_tracker_user;

-----------------------------------

--1. Dla tabel posi¹daj¹cych klucz g³ówny (PRIMARY KEY) zmieñ typ danych dla identyfikatorów (PRIMARY KEY) na typ SERIAL. 
--Zmieniaj¹c definicjê struktury i zapytania CREATE TABLE. Klucze obce w tabelach (z ograniczeniem REFERENCES) powinny zostaæ, jako typ ca³kowity.


DROP TABLE IF EXISTS expense_tracker.bank_account_owner CASCADE;

CREATE TABLE EXPENSE_TRACKER.bank_account_owner
(
	id_ba_own serial PRIMARY KEY,
	owner_name varchar(50) NOT NULL,
	owner_desc varchar(250),
	user_login int NOT NULL,
	active boolean DEFAULT TRUE NOT NULL,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp
);

--------------------------------------

DROP TABLE IF EXISTS expense_tracker.users CASCADE;

CREATE TABLE expense_tracker.users
(
	id_user serial PRIMARY KEY,
	user_login varchar(25) NOT NULL,
	user_name varchar(50) NOT NULL,
	user_password varchar(100) NOT NULL,
	password_salt varchar(100) NOT NULL,
	active boolean NOT NULL DEFAULT TRUE,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp
);

--------------------------------------

DROP TABLE IF EXISTS expense_tracker.bank_account_types CASCADE;

CREATE TABLE expense_tracker.bank_account_types 
(
	id_ba_type serial PRIMARY KEY,
	ba_type varchar(50) NOT NULL,
	ba_desc varchar(250),
	active boolean DEFAULT TRUE,
	is_common_account boolean NOT NULL DEFAULT FALSE,
	id_ba_own int,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp,
	CONSTRAINT id_ba_own FOREIGN KEY (id_ba_own) REFERENCES expense_tracker.bank_account_owner  (id_ba_own) ON DELETE CASCADE
);

----------------------------------------------------------------------------------

DROP TABLE IF EXISTS expense_tracker.transaction_category CASCADE;

CREATE TABLE expense_tracker.transaction_category
(
	id_trans_cat serial PRIMARY KEY,
	category_name varchar(50) NOT NULL,
	category_description varchar(250),
	active boolean NOT NULL DEFAULT TRUE,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp
);

----------------------------------------------------------------------------------

DROP TABLE IF EXISTS expense_tracker.transaction_subcategory CASCADE;

CREATE TABLE expense_tracker.transaction_subcategory
(
	id_trans_subcat serial PRIMARY KEY,
	id_trans_cat int,
	subcategory_name varchar(50) NOT NULL,
	subcategory_description varchar(250),
	active boolean NOT NULL DEFAULT TRUE,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp,
	CONSTRAINT id_trans_cat FOREIGN KEY (id_trans_cat) REFERENCES expense_tracker.transaction_category  (id_trans_cat) ON DELETE CASCADE
);

----------------------------------------------------------------------------------

DROP TABLE IF EXISTS expense_tracker.transaction_bank_accounts CASCADE;

CREATE TABLE expense_tracker.transaction_bank_accounts
(
	id_trans_ba serial PRIMARY KEY,
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

DROP TABLE IF EXISTS expense_tracker.transaction_type CASCADE;

CREATE TABLE expense_tracker.transaction_type
(
	id_trans_type serial PRIMARY KEY,
	transaction_type_name varchar(50) NOT NULL,
	transaction_type_desc varchar(250),
	active boolean NOT NULL DEFAULT TRUE,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp
);

----------------------------------------------------------------------------------

DROP TABLE IF EXISTS expense_tracker.transactions CASCADE;

CREATE TABLE expense_tracker.transactions
(
	id_transaction serial PRIMARY KEY,
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

--2. Dla ka¿dej z tabel projektowych wstaw przynajmniej 1 rzeczywisty rekord spe³niaj¹cy kryteria tabeli i kluczy obcych.


INSERT INTO EXPENSE_TRACKER.BANK_ACCOUNT_OWNER (owner_name,  owner_desc, user_login)
	VALUES 	('Jan Pierwszy', 'Jan Jacek Pierwszy PESEL 10101010101', '11111'),
			('Anna Pierwsza', 'Anna Pierwsza nr buta 38', '11112');

--SELECT * FROM EXPENSE_TRACKER.BANK_ACCOUNT_OWNER;

--------------------------------------

INSERT INTO EXPENSE_TRACKER.USERS (user_login, user_name, user_password, password_salt)
	VALUES 	('11111', 'piejan', 'haslo_jan', 'alt_haslo_jan'),
			('11112', 'pieann', 'haslo_anna', 'alt_haslo_anna');

--SELECT * FROM EXPENSE_TRACKER.USERS;

--------------------------------------

INSERT INTO EXPENSE_TRACKER.BANK_ACCOUNT_TYPES (ba_type, ba_desc, id_ba_own) 
	VALUES ('konto glowne', 'konto glowne Jan Pierwszy', 1);

--SELECT * FROM EXPENSE_TRACKER.BANK_ACCOUNT_TYPES;
	
--------------------------------------

INSERT INTO EXPENSE_TRACKER.TRANSACTION_CATEGORY (category_name, category_description) 
	VALUES 	('rachunki', 'oplaty za mieszkanie, energie, gaz, telefon, internet itp'),
			('odziez', 'wydatki na odziez'),
			('spozywcze', 'wydatki na jedzenie');

--SELECT * FROM EXPENSE_TRACKER.TRANSACTION_CATEGORY;

--------------------------------------

INSERT INTO EXPENSE_TRACKER.TRANSACTION_SUBCATEGORY (id_trans_cat, subcategory_name, subcategory_description)
	VALUES 	(1, 'mieszkanie', 'oplaty za czynsz, podatek od gruntow itp'),
			(1, 'energia', 'oplaty za zuzycie energii'),
			(1, 'gaz', 'oplaty za zuzycie gazu'),
			(1, 'internet', 'oplaty za internet'),
			(1, 'telefon', 'oplaty za telefony'),
			(3, 'jedzenie w domu', 'jedzenie zakupione'),
			(3, 'jedzenie na zewnatrz', 'jedzenie w restauracjach itp');
		
--SELECT * FROM EXPENSE_TRACKER.TRANSACTION_SUBCATEGORY;

--------------------------------------

INSERT INTO EXPENSE_TRACKER.TRANSACTION_BANK_ACCOUNTS (id_ba_own, id_ba_typ, bank_account_name, bank_account_desc)
	VALUES 	(1, 1, 'mbank', 'konto w mbank');

--SELECT * FROM EXPENSE_TRACKER.TRANSACTION_BANK_ACCOUNTS;

--------------------------------------

INSERT INTO EXPENSE_TRACKER.TRANSACTION_TYPE (transaction_type_name, transaction_type_desc)
	VALUES 	('karta debetowa', 'platnosc karta debetowa'),
			('karta kredytowa', 'platnosc karta kredytowa'),
			('przelew', 'platnosc przelewem');

--SELECT * FROM EXPENSE_TRACKER.TRANSACTION_TYPE;

--------------------------------------

INSERT INTO EXPENSE_TRACKER.TRANSACTIONS (id_trans_ba, id_trans_cat, id_trans_subcat, id_trans_type, id_user, transaction_date, transaction_value, transaction_description)
	VALUES 	(1, 1, 4, 3, 1, '2020.07.01', 99.99, 'rachunek za internet 2020/07'),
			(1, 3, 6, 1, 2, '2020.07.07', 12.74, 'poranne zakupy na sniadanie'),
			(1, 3, 7, 1, 1, '2020.07.08', 254.00, 'kolacja w restauracji');

--SELECT * FROM EXPENSE_TRACKER.TRANSACTIONS;

/*
expense_tracker.transactions
	--id_trans_ba int,		pole z transaction_bank_accounts = konta bankowe 1=mbank
	--id_trans_cat int,		pole z transaction_category = 1=rachunki, 2=odziez, 3=spozywcze
	--id_trans_subcat int,	pole z transaction_subcategory = podkategoria wydatku
	--id_trans_type int,	pole z transaction_type = 1=kara deb, 2=karta kredyt, 3=przelew
	--id_user int,			pole z users = 1=jan, 2=anna 
	--transaction_date date DEFAULT current_date,
	--transaction_value NUMERIC(9,2),
	--transaction_description TEXT,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp,
*/

--------------------------------------
