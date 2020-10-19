
--3. Wykonaj pe�n� kopi� zapasow� bazy danych z opcj� --clean (do formatu plain tak �eby widzie�, co si� zrzuci�o) 
--korzystaj�c z narz�dzia pg_dump. Nast�pnie odtw�rz kopi� z zapisanego skryptu korzystaj�c z narzedzia DBeaver lub psql.

pg_dump --host localhost ^
        --port 5432 ^
        --username postgres ^
        --format plain ^
        --file "C:\1\expense_tracker.sql" ^
        --schema expense_tracker ^
        postgres

--------------------------
        
--odtworzenie z zapisanego skryptu
        
DROP SCHEMA IF EXISTS expense_tracker CASCADE;       
        
psql -U postgres -p 5432 -h localhost -d postgres -f "C:\1\expense_tracker.sql"
