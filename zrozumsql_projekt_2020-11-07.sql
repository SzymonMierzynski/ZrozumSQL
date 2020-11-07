--czesc 7 - PROJEKT

--------------------------------------------------------------------------------

--1. Wy�wietl wszystkie informacje o koncie:
--   nazwa w�a�cieciela (owner_name)
--   opis w�a�ciciela (owner_desc)
--   typ konta (ba_type)
--   opis konta (ba_desc)
--   flaga czy jest aktywne (active)
--   nazwa konta bankowego (bank_account_name)
--   razem z u�ytkownikiem (user_login),
--   kt�ry jest do niego przypisany. Dla w�a�ciciela, jakim jest Janusz Kowalski.

SELECT
	BAO.OWNER_NAME,
	BAO.OWNER_DESC,
	BAT.BA_TYPE,
	BAT.BA_DESC,
	BAT.ACTIVE,
	TBA.BANK_ACCOUNT_NAME,
	U.USER_LOGIN 
FROM EXPENSE_TRACKER.BANK_ACCOUNT_OWNER BAO 
	LEFT JOIN EXPENSE_TRACKER.BANK_ACCOUNT_TYPES BAT ON bao.ID_BA_OWN = bat.ID_BA_OWN 
	LEFT JOIN EXPENSE_TRACKER.TRANSACTION_BANK_ACCOUNTS TBA ON BAT.ID_BA_TYPE   = TBA.ID_BA_TYP 
	LEFT JOIN EXPENSE_TRACKER.USERS U ON bao.USER_LOGIN = u.ID_USER 
WHERE OWNER_NAME = 'Janusz Kowalski'

--------------------------------------------------------------------------------

--2. Wy�wietl wszystkie informacje o dost�pnych kategoriach transakcji i ich mo�liwych podkategoriach.
--   W obu przypadkach powinny to by� tylko "aktywne" elementy (active TRUE / 1 / Y / y :)).
--   W wyniku wy�wietl 2 atrybuty, nazwa kategorii i nazwa podkategorii, dane posortuj po identyfikatorze kategorii rosn�co.

SELECT
	tc.CATEGORY_NAME,
	ts.SUBCATEGORY_NAME 
FROM EXPENSE_TRACKER.TRANSACTION_CATEGORY TC 
	JOIN EXPENSE_TRACKER.TRANSACTION_SUBCATEGORY TS ON TC.ID_TRANS_CAT  = TS.ID_TRANS_CAT 
WHERE tc.ACTIVE = TRUE AND ts.ACTIVE = TRUE 
ORDER BY tc.ID_TRANS_CAT 

--------------------------------------------------------------------------------

--3. Wy�wietl wszystkie transakcje (TRANSACTIONS), kt�re mia�y miejsce w 2016 roku zwi�zane z kategori� JEDZENIE.

SELECT T.* FROM 
	EXPENSE_TRACKER.TRANSACTIONS T 
	JOIN EXPENSE_TRACKER.TRANSACTION_CATEGORY TC ON t.ID_TRANS_CAT = TC.ID_TRANS_CAT 
WHERE 
	tc.CATEGORY_NAME ='JEDZENIE' AND (t.TRANSACTION_DATE BETWEEN '2016-01-01' AND '2016-12-31')
	
	
--------------------------------------------------------------------------------

--4. Dodaj now� podkategori� do tabeli TRANSACTION_SUBCATEGORY, kt�ra b�dzie w relacji z kategori� (TRANSACTION_CATEGORY) JEDZENIE.
--   Na podstawie wynik�w z zadania 3, dla wszystkich wierszy z kategorii jedzenie, kt�re nie maj� przypisanej podkategorii (-1) 
--   zaktualizuj warto�� podkategorii na now� dodan�.
--   Mo�esz wykorzysta� dowoln� znan� Ci konstrukcj� (UPDATE / UPDATE + WITH / UPDATE + FROM / UPDATE + EXISTS).

INSERT INTO EXPENSE_TRACKER.TRANSACTION_SUBCATEGORY (ID_TRANS_SUBCAT , ID_TRANS_CAT, SUBCATEGORY_NAME, SUBCATEGORY_DESCRIPTION)
	VALUES ( 54, 1, 'Owoce i warzywa', 'Owoce i warzywa')

	
UPDATE EXPENSE_TRACKER.TRANSACTIONS SET ID_TRANS_SUBCAT = 54
	WHERE ID_TRANS_CAT = 1 AND ID_TRANS_SUBCAT = -1

--------------------------------------------------------------------------------

--5. Wy�wietl wszystkie transakcje w roku 2020 dla konta oszcz�dno�ciowego Janusz i Gra�ynka.
--   W wynikach wy�wietl informacje o:
--   nazwie kategorii,
--   nazwie podkategorii,
--   typie transakcji,
--   dacie transakcji
--   warto�ci transakcji.

SELECT 
	tc.CATEGORY_NAME ,
	ts.SUBCATEGORY_NAME ,
	tt.TRANSACTION_TYPE_NAME ,
	tt.TRANSACTION_TYPE_DESC ,
	t.TRANSACTION_DATE ,
	t.TRANSACTION_VALUE 
FROM EXPENSE_TRACKER.TRANSACTIONS T 
	LEFT JOIN EXPENSE_TRACKER.TRANSACTION_BANK_ACCOUNTS TBA ON T.ID_TRANS_BA = TBA.ID_TRANS_BA 
	LEFT JOIN EXPENSE_TRACKER.TRANSACTION_CATEGORY TC ON t.ID_TRANS_CAT = TC.ID_TRANS_CAT
	LEFT JOIN EXPENSE_TRACKER.TRANSACTION_SUBCATEGORY TS ON t.ID_TRANS_SUBCAT = TS.ID_TRANS_SUBCAT 
	LEFT JOIN EXPENSE_TRACKER.TRANSACTION_TYPE TT ON TT.ID_TRANS_TYPE = T.ID_TRANS_TYPE 
WHERE tba.ID_BA_TYP = 6 AND (t.TRANSACTION_DATE BETWEEN '2020-01-01' AND '2020-12-31')
	
--------------------------------------------------------------------------------

--backup bazy PRZED powyzszymi, backup zawiera dane
--	expense_tracker_20201107_v1.sql 

-- backup bazy po powyzszych dzialaniach:
/*
pg_dump --host localhost ^
        --port 5432 ^
        --username postgres ^
        --format plain ^
        --file "C:\1\expense_tracker_20201107_v2.sql" ^
        --schema expense_tracker ^
        postgres
*/