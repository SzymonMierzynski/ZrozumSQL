
--3. Wykonaj pe³n¹ kopiê zapasow¹ bazy danych z opcj¹ --clean (do formatu plain tak ¿eby widzieæ, co siê zrzuci³o) 
--korzystaj¹c z narzêdzia pg_dump. Nastêpnie odtwórz kopiê z zapisanego skryptu korzystaj¹c z narzedzia DBeaver lub psql.

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
