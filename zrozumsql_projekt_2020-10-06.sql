--zrozumsql projekt cz1 2020.10.07

--1. Utwórz nowy schemat a jeœli istnieje do usuñ
--DROP SCHEMA IF EXISTS expense_tracker CASCADE; 

CREATE SCHEMA IF NOT EXISTS expense_tracker;

---------------------------------

--utwórz tabelê bank_account_owner a jeœli istnienie usuñ

--DROP TABLE IF EXISTS expense_tracker.bank_account_owner CASCADE;

CREATE TABLE IF NOT EXISTS EXPENSE_TRACKER.bank_account_owner
(
	id_ba_own int PRIMARY key, 							--typ ca³kowity, klucz g³ówny
	owner_name varchar(50) NOT NULL, 					--typ tekstowy 50 znaków, not null
	owner_desc varchar(250), 							--typ tekstowy 250 znaków
	user_login int NOT NULL, 							--typ ca³kowity, not null
	active boolean DEFAULT TRUE NOT null, 				--typ tekstowy 1 znak (lub prawda / fa³sz (boolean)), dla typu znakowego
														--wartoœæ domyœlna 1, dla prawdy fa³sz ustaw prawdê, not null
	
	insert_date timestamp DEFAULT current_timestamp, 	--typ data i czas, wartoœæ domyœlna current_timestamp (spowoduje
														--wstawianie aktualnej daty i czasu w momencie wstawiania wierszy)
	
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, wartoœæ domyœlna current_timestamp
);

--INSERT INTO EXPENSE_TRACKER.BANK_ACCOUNT_OWNER VALUES (5, 'OWNER','own_descr', 123);

--SELECT * FROM EXPENSE_TRACKER.BANK_ACCOUNT_OWNER; 

----------------------------------------------------------------------------------

--utwórz tabelê bank_account_owner a jeœli istnienie usuñ

--DROP TABLE IF EXISTS expense_tracker.bank_account_types CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_types 
(
	id_ba_type int PRIMARY key, 						--typ ca³kowity, klucz g³ówny
	ba_type varchar(50) NOT null, 						--typ tekstowy 50 znaków, not null
	ba_desc varchar(250), 								--typ tekstowy 250 znaków
	active boolean DEFAULT true, 						--active, typ tekstowy 1 znak (lub prawda / fa³sz (boolean))
	is_common_account boolean NOT NULL DEFAULT false, 	--typ tekstowy 1 znak (lub prawda / fa³sz (boolean)), dla typu
	id_ba_own int, 										--typ ca³kowity
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, wartoœæ domyœlna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, wartoœæ domyœlna current_timestamp
);

--INSERT INTO EXPENSE_TRACKER.BANK_ACCOUNT_TYPES VALUES (1, 'typ1','descr1');

--SELECT * FROM EXPENSE_TRACKER.BANK_ACCOUNT_TYPES BAT; 

----------------------------------------------------------------------------------

--utwórz tabelê transactions a jeœli istnienie usuñ

--DROP TABLE IF EXISTS expense_tracker.transactions CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transactions
(
	id_transaction int PRIMARY key, 					--typ ca³kowity, klucz g³ówny
	id_trans_ba int, 									--typ ca³kowity
	id_trans_cat int, 									--typ ca³kowity
	id_trans_subcat int, 								--typ ca³kowity
	id_trans_type int, 									--typ ca³kowity
	id_user int, 										--typ ca³kowity
	transaction_date date DEFAULT current_date,
	transaction_value NUMERIC(9,2),
	transaction_description TEXT,
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, wartoœæ domyœlna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, wartoœæ domyœlna current_timestamp
);

----------------------------------------------------------------------------------

--utwórz tabelê transaction_bank_accounts a jeœli istnienie usuñ

--DROP TABLE IF EXISTS expense_tracker.transaction_bank_accounts CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_bank_accounts
(
	id_trans_ba int PRIMARY key, 						--typ ca³kowity, klucz g³ówny
	id_ba_own int, 										--typ ca³kowity,
	id_ba_typ int, 										--typ ca³kowity,
	bank_account_name varchar(50) NOT NULL, 			--typ tekstowy 50 znaków, not null
	bank_account_desc varchar(250), 					--typ tekstowy 250 znaków
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa³sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, wartoœæ domyœlna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, wartoœæ domyœlna current_timestamp
);

----------------------------------------------------------------------------------

--utwórz tabelê transaction_category a jeœli istnienie usuñ

--DROP TABLE IF EXISTS expense_tracker.transaction_category CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_category
(
	id_trans_cat int PRIMARY KEY, 						--typ ca³kowity, klucz g³ówny
	category_name varchar(50) NOT NULL, 				--typ tekstowy 50 znaków, not null
	category_description varchar(250), 					--typ tekstowy 250 znaków
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa³sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, wartoœæ domyœlna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, wartoœæ domyœlna current_timestamp
);

----------------------------------------------------------------------------------

--utwórz tabelê transaction_subcategory a jeœli istnienie usuñ

--DROP TABLE IF EXISTS expense_tracker.transaction_subcategory CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_subcategory
(
	id_trans_subcat int PRIMARY KEY,					--typ ca³kowity, klucz g³ówny
	id_trans_cat int, 									--typ ca³kowity, klucz g³ówny
	subcategory_name varchar(50) NOT NULL, 				--typ tekstowy 50 znaków, not null
	subcategory_description varchar(250), 				--typ tekstowy 250 znaków
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa³sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, wartoœæ domyœlna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, wartoœæ domyœlna current_timestamp
);

----------------------------------------------------------------------------------

--utwórz tabelê transaction_subcategory a jeœli istnienie usuñ

--DROP TABLE IF EXISTS expense_tracker.transaction_type CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_type
(
	id_trans_type int PRIMARY KEY, 						--typ ca³kowity, klucz g³ówny
	transaction_type_name varchar(50) NOT NULL, 		--typ tekstowy 50 znaków, not null
	transaction_type_desc varchar(250), 				--typ tekstowy 250 znaków
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa³sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, wartoœæ domyœlna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, wartoœæ domyœlna current_timestamp
);

----------------------------------------------------------------------------------

--utwórz tabelê users a jeœli istnienie usuñ

--DROP TABLE IF EXISTS expense_tracker.users CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.users
(
	id_user int PRIMARY KEY, 							--typ ca³kowity, klucz g³ówny
	user_login varchar(25) NOT NULL, 					--typ tekstowy 25 znaków, not null
	user_name varchar(50) NOT NULL, 					--typ tekstowy 50 znaków, not null
	user_password varchar(100) NOT NULL, 				--typ tekstowy 100 znaków, not null
	password_salt varchar(100) NOT NULL, 				--typ tekstowy 100 znaków, not null
	active boolean NOT NULL DEFAULT TRUE, 				--active, typ tekstowy 1 znak (lub prawda / fa³sz (boolean))
	insert_date timestamp DEFAULT current_timestamp,	--typ data i czas, wartoœæ domyœlna current_timestamp
	update_date timestamp DEFAULT current_timestamp 	--typ data i czas, wartoœæ domyœlna current_timestamp
);
