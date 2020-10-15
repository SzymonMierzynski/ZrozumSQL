--Modu³ 4 Data Control Language – Zadania Teoria SQL


--1. Korzystaj¹c ze sk³adni CREATE ROLE, stwórz nowego u¿ytkownika o nazwie user_training z mo¿liwoœci¹ zalogowania siê do bazy danych i has³em silnym :) (coœ wymyœl).

CREATE ROLE user_training WITH LOGIN PASSWORD 'u$er!r@!ning';

--------------------------------------------------------------------------------------------------------

--2. Korzystaj¹c z atrybutu AUTHORIZATION dla sk³adni CREATE SCHEMA. Utwórz schemat training, którego w³aœcicielem bêdzie u¿ytkownik user_training.

CREATE SCHEMA training AUTHORIZATION user_training;

--------------------------------------------------------------------------------------------------------

--3. Bêd¹c zalogowany na super u¿ytkowniku postgres, spróbuj usun¹æ rolê (u¿ytkownika) user_training.

DROP ROLE user_training;

-- nie mozna usunac roli bo: ERROR: role "user_training" cannot be dropped because some objects depend on it
--------------------------------------------------------------------------------------------------------

--4. Przeka¿ w³asnoœæ nad utworzonym dla / przez u¿ytkownika user_training obiektami na role postgres. Nastêpnie usuñ role user_training.

REASSIGN OWNED BY user_training TO postgres;

DROP ROLE user_training;

--------------------------------------------------------------------------------------------------------

--5. Utwórz now¹ rolê reporting_ro, która bêdzie grup¹ dostêpów, dla u¿ytkowników warstwy analitycznej o nastêpuj¹cych przywilejach.
--Dostêp do bazy danych postgres
--Dostêp do schematu training
--Dostêp do tworzenia obiektów w schemacie training
--Dostêp do wszystkich uprawnieñ dla wszystkich tabel w schemacie training

--REASSIGN OWNED BY reporting_ro TO postgres;
--REVOKE ALL ON SCHEMA training FROM reporting_ro;
--REVOKE ALL ON DATABASE postgres FROM reporting_ro;

CREATE ROLE reporting_ro;

GRANT CONNECT ON DATABASE postgres TO reporting_ro;
GRANT USAGE, CREATE ON SCHEMA training TO reporting_ro;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA training TO reporting_ro;

--------------------------------------------------------------------------------------------------------

6. Utwórz nowego u¿ytkownika reporting_user z mo¿liwoœci¹ logowania siê do bazy danych i haœle silnym :) (coœ wymyœl). Przypisz temu u¿ytkownikowi role reporting ro;

--REVOKE ALL ON DATABASE postgres FROM reporting_ro;

--REVOKE ALL ON DATABASE postgres FROM reporting_user;

--REVOKE ALL ON ALL TABLES IN schema postgres FROM reporting_user;

--DROP ROLE reporting_user;

CREATE ROLE reporting_user WITH LOGIN PASSWORD 'r@port!ng#user';
GRANT reporting_ro TO reporting_user;

--------------------------------------------------------------------------------------------------------

7. Bêd¹c zalogowany na u¿ytkownika reporting_user, spróbuj utworzyæ now¹ tabele (dowoln¹) w schemacie training.

CREATE TABLE training.test (id int);

--tabela zostala utworzona

--------------------------------------------------------------------------------------------------------

8. Zabierz uprawnienia roli reporting_ro do tworzenia obiektów w schemacie training;

REVOKE CREATE ON SCHEMA training FROM reporting_ro;

--------------------------------------------------------------------------------------------------------

9. Zaloguj siê ponownie na u¿ytkownika reporting_user, sprawdŸ czy mo¿esz utworzyæ now¹ tabelê w schemacie training oraz czy mo¿esz tak¹ tabelê utworzyæ w schemacie public.

CREATE TABLE training.test22 (id int);
--Nie mo¿na utworzyc tabeli: ERROR: permission denied for schema training

CREATE TABLE PUBLIC.test4 (id int);
--Tak, mozna utworzyc tabele