--zrozumsql projekt cz1 2020.10.07

--1. Utw�rz nowy schemat a je�li istnieje do usu�
--DROP SCHEMA IF EXISTS expense_tracker CASCADE; 

CREATE SCHEMA IF NOT EXISTS expense_tracker;

---------------------------------

--utw�rz tabel� bank_account_owner a je�li istnienie usu�

--DROP TABLE IF EXISTS expense_tracker.bank_account_owner CASCADE;

CREATE TABLE IF NOT EXISTS EXPENSE_TRACKER.bank_account_owner
(
	id_ba_own int PRIMARY key, 							--typ ca�kowity, klucz g��wny
	owner_name varchar(50) NOT NULL, 					--typ tekstowy 50 znak�w, not null
	owner_desc varchar(250), 							--typ tekstowy 250 znak�w
	user_login int NOT NULL, 							--typ ca�kowity, not null
	active boolean DEFAULT TRUE NOT null, 				--typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu znakowego
														--warto�� domy�lna 1, dla prawdy fa�sz ustaw prawd�, not null
	
	insert_date timestamp DEFAULT current_timestamp, 	--typ data i czas, warto�� domy�lna current_timestamp (spowoduje
														--wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
	
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, warto�� domy�lna current_timestamp
);

--INSERT INTO EXPENSE_TRACKER.BANK_ACCOUNT_OWNER VALUES (5, 'OWNER','own_descr', 123);

--SELECT * FROM EXPENSE_TRACKER.BANK_ACCOUNT_OWNER; 

----------------------------------------------------------------------------------

--utw�rz tabel� bank_account_owner a je�li istnienie usu�

--DROP TABLE IF EXISTS expense_tracker.bank_account_types CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_types 
(
	id_ba_type int PRIMARY key, 						--typ ca�kowity, klucz g��wny
	ba_type varchar(50) NOT null, 						--typ tekstowy 50 znak�w, not null
	ba_desc varchar(250), 								--typ tekstowy 250 znak�w
	active boolean DEFAULT true, 						--active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean))
	is_common_account boolean NOT NULL DEFAULT false, 	--typ tekstowy 1 znak (lub prawda / fa�sz (boolean)), dla typu
	id_ba_own int, 										--typ ca�kowity
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, warto�� domy�lna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, warto�� domy�lna current_timestamp
);

--INSERT INTO EXPENSE_TRACKER.BANK_ACCOUNT_TYPES VALUES (1, 'typ1','descr1');

--SELECT * FROM EXPENSE_TRACKER.BANK_ACCOUNT_TYPES BAT; 

----------------------------------------------------------------------------------

--utw�rz tabel� transactions a je�li istnienie usu�

--DROP TABLE IF EXISTS expense_tracker.transactions CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transactions
(
	id_transaction int PRIMARY key, 					--typ ca�kowity, klucz g��wny
	id_trans_ba int, 									--typ ca�kowity
	id_trans_cat int, 									--typ ca�kowity
	id_trans_subcat int, 								--typ ca�kowity
	id_trans_type int, 									--typ ca�kowity
	id_user int, 										--typ ca�kowity
	transaction_date date DEFAULT current_date,
	transaction_value NUMERIC(9,2),
	transaction_description TEXT,
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, warto�� domy�lna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, warto�� domy�lna current_timestamp
);

----------------------------------------------------------------------------------

--utw�rz tabel� transaction_bank_accounts a je�li istnienie usu�

--DROP TABLE IF EXISTS expense_tracker.transaction_bank_accounts CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_bank_accounts
(
	id_trans_ba int PRIMARY key, 						--typ ca�kowity, klucz g��wny
	id_ba_own int, 										--typ ca�kowity,
	id_ba_typ int, 										--typ ca�kowity,
	bank_account_name varchar(50) NOT NULL, 			--typ tekstowy 50 znak�w, not null
	bank_account_desc varchar(250), 					--typ tekstowy 250 znak�w
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, warto�� domy�lna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, warto�� domy�lna current_timestamp
);

----------------------------------------------------------------------------------

--utw�rz tabel� transaction_category a je�li istnienie usu�

--DROP TABLE IF EXISTS expense_tracker.transaction_category CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_category
(
	id_trans_cat int PRIMARY KEY, 						--typ ca�kowity, klucz g��wny
	category_name varchar(50) NOT NULL, 				--typ tekstowy 50 znak�w, not null
	category_description varchar(250), 					--typ tekstowy 250 znak�w
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, warto�� domy�lna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, warto�� domy�lna current_timestamp
);

----------------------------------------------------------------------------------

--utw�rz tabel� transaction_subcategory a je�li istnienie usu�

--DROP TABLE IF EXISTS expense_tracker.transaction_subcategory CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_subcategory
(
	id_trans_subcat int PRIMARY KEY,					--typ ca�kowity, klucz g��wny
	id_trans_cat int, 									--typ ca�kowity, klucz g��wny
	subcategory_name varchar(50) NOT NULL, 				--typ tekstowy 50 znak�w, not null
	subcategory_description varchar(250), 				--typ tekstowy 250 znak�w
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, warto�� domy�lna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, warto�� domy�lna current_timestamp
);

----------------------------------------------------------------------------------

--utw�rz tabel� transaction_subcategory a je�li istnienie usu�

--DROP TABLE IF EXISTS expense_tracker.transaction_type CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_type
(
	id_trans_type int PRIMARY KEY, 						--typ ca�kowity, klucz g��wny
	transaction_type_name varchar(50) NOT NULL, 		--typ tekstowy 50 znak�w, not null
	transaction_type_desc varchar(250), 				--typ tekstowy 250 znak�w
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, warto�� domy�lna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, warto�� domy�lna current_timestamp
);

----------------------------------------------------------------------------------

--utw�rz tabel� users a je�li istnienie usu�

--DROP TABLE IF EXISTS expense_tracker.users CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.users
(
	id_user int PRIMARY KEY, 							--typ ca�kowity, klucz g��wny
	user_login varchar(25) NOT NULL, 					--typ tekstowy 25 znak�w, not null
	user_name varchar(50) NOT NULL, 					--typ tekstowy 50 znak�w, not null
	user_password varchar(100) NOT NULL, 				--typ tekstowy 100 znak�w, not null
	password_salt varchar(100) NOT NULL, 				--typ tekstowy 100 znak�w, not null
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa�sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, warto�� domy�lna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, warto�� domy�lna current_timestamp
);
