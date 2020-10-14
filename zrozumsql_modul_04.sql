----modul 4 - DCL - role, uprawnienia itp

SHOW search_path;

SELECT * FROM pg_catalog.pg_roles;
SELECT * FROM pg_catalog.pg_user;
SELECT * FROM pg_catalog.pg_group;

CREATE ROLE training_user WITH SUPERUSER PASSWORD 'tuser$1';

CREATE ROLE training_user WITH LOGIN SUPERUSER PASSWORD 'tuser$1';

CREATE ROLE app_reporting_ro WITH LOGIN PASSWORD 'appReporting#0';

REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON DATABASE postgres FROM PUBLIC;

GRANT CONNECT ON DATABASE postgres TO PUBLIC;

CREATE TABLE test (id integer);

------------------------------------------------------------------

--GRANT

--- SUPERUSER STEPS
CREATE ROLE accountant WITH LOGIN PASSWORD 'acc$1Passw0r4';

GRANT ALL PRIVILEGES ON DATABASE postgres TO accountant;

DROP ROLE accountant;

REASSIGN OWNED BY accountant TO postgres;
DROP OWNED BY accountant;
DROP ROLE accountant;

CREATE ROLE accountant WITH LOGIN PASSWORD 'acc$1Passw0r4';
REVOKE ALL PRIVILEGES ON SCHEMA public FROM PUBLIC;

CREATE ROLE readonly_accountants;
GRANT CONNECT ON DATABASE postgres TO readonly_accountants; 

CREATE SCHEMA accountants;
CREATE TABLE accountants.test (id INTEGER);

GRANT USAGE ON SCHEMA accountants TO readonly_accountants;
GRANT SELECT ON TABLE accountants.test TO readonly_accountants;

GRANT readonly_accountants TO accountant;


-- ACCOUNTANT STEPS
CREATE TABLE test_accountant (id INTEGER);
CREATE SCHEMA accountant; 

SELECT * FROM accountants.test t ;

------------------------------------------------------------------------------------------

--REWOKE

--- SUPERUSER STEPS
CREATE SCHEMA accountants;
CREATE TABLE accountants.test (id INTEGER);

CREATE ROLE accountant WITH LOGIN PASSWORD 'acc$1Passw0r4';

CREATE ROLE accountants_role;
GRANT CONNECT ON DATABASE postgres TO accountants_role;
GRANT USAGE, CREATE ON SCHEMA accountants TO accountants_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA accountants TO accountants_role;
GRANT accountants_role TO accountant;

REVOKE CREATE ON SCHEMA accountants FROM accountants_role;
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA accountants FROM accountants_role;

-- ROLE PERSPECTIVE
CREATE TABLE accountants.test2 (id integer);

CREATE TABLE accountants.test3 (id integer);

SELECT * FROM accountants.test2 t ;

------------------------------------------------------------------------------------------

REVOKE ALL ON SCHEMA training FROM expense_tracker_group;

REVOKE ALL ON SCHEMA training FROM expense_tracker_group;

REVOKE USAGE ON SCHEMA training FROM expense_tracker_group;

REVOKE SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA training FROM uzytk;


SELECT * FROM TRAINING.TEST
