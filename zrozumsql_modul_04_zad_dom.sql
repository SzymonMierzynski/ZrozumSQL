--Modu� 4 Data Control Language � Zadania Teoria SQL


--1. Korzystaj�c ze sk�adni CREATE ROLE, stw�rz nowego u�ytkownika o nazwie user_training z mo�liwo�ci� zalogowania si� do bazy danych i has�em silnym :) (co� wymy�l).

CREATE ROLE user_training WITH LOGIN PASSWORD 'u$er!r@!ning';

--------------------------------------------------------------------------------------------------------

--2. Korzystaj�c z atrybutu AUTHORIZATION dla sk�adni CREATE SCHEMA. Utw�rz schemat training, kt�rego w�a�cicielem b�dzie u�ytkownik user_training.

CREATE SCHEMA training AUTHORIZATION user_training;

--------------------------------------------------------------------------------------------------------

--3. B�d�c zalogowany na super u�ytkowniku postgres, spr�buj usun�� rol� (u�ytkownika) user_training.

DROP ROLE user_training;

-- nie mozna usunac roli bo: ERROR: role "user_training" cannot be dropped because some objects depend on it
--------------------------------------------------------------------------------------------------------

--4. Przeka� w�asno�� nad utworzonym dla / przez u�ytkownika user_training obiektami na role postgres. Nast�pnie usu� role user_training.

REASSIGN OWNED BY user_training TO postgres;

DROP ROLE user_training;

--------------------------------------------------------------------------------------------------------

--5. Utw�rz now� rol� reporting_ro, kt�ra b�dzie grup� dost�p�w, dla u�ytkownik�w warstwy analitycznej o nast�puj�cych przywilejach.
--Dost�p do bazy danych postgres
--Dost�p do schematu training
--Dost�p do tworzenia obiekt�w w schemacie training
--Dost�p do wszystkich uprawnie� dla wszystkich tabel w schemacie training

--REASSIGN OWNED BY reporting_ro TO postgres;
--REVOKE ALL ON SCHEMA training FROM reporting_ro;
--REVOKE ALL ON DATABASE postgres FROM reporting_ro;

CREATE ROLE reporting_ro;

GRANT CONNECT ON DATABASE postgres TO reporting_ro;
GRANT USAGE, CREATE ON SCHEMA training TO reporting_ro;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA training TO reporting_ro;

--------------------------------------------------------------------------------------------------------

6. Utw�rz nowego u�ytkownika reporting_user z mo�liwo�ci� logowania si� do bazy danych i ha�le silnym :) (co� wymy�l). Przypisz temu u�ytkownikowi role reporting ro;

--REVOKE ALL ON DATABASE postgres FROM reporting_ro;

--REVOKE ALL ON DATABASE postgres FROM reporting_user;

--REVOKE ALL ON ALL TABLES IN schema postgres FROM reporting_user;

--DROP ROLE reporting_user;

CREATE ROLE reporting_user WITH LOGIN PASSWORD 'r@port!ng#user';
GRANT reporting_ro TO reporting_user;

--------------------------------------------------------------------------------------------------------

7. B�d�c zalogowany na u�ytkownika reporting_user, spr�buj utworzy� now� tabele (dowoln�) w schemacie training.

CREATE TABLE training.test (id int);

--tabela zostala utworzona

--------------------------------------------------------------------------------------------------------

8. Zabierz uprawnienia roli reporting_ro do tworzenia obiekt�w w schemacie training;

REVOKE CREATE ON SCHEMA training FROM reporting_ro;

--------------------------------------------------------------------------------------------------------

9. Zaloguj si� ponownie na u�ytkownika reporting_user, sprawd� czy mo�esz utworzy� now� tabel� w schemacie training oraz czy mo�esz tak� tabel� utworzy� w schemacie public.

CREATE TABLE training.test22 (id int);
--Nie mo�na utworzyc tabeli: ERROR: permission denied for schema training

CREATE TABLE PUBLIC.test4 (id int);
--Tak, mozna utworzyc tabele