CREATE OR REPLACE FUNCTION BusinessC.yearly_report
(
	CUSTID INT, --assume maintainer already get cumstomer id
	STARTYEAR INT,
	ENDYEAR INT
)
RETURNS TABLE
(
	YEAR_RANGE INT,
	TOTAL_TRANSACTION INT,
	ToTal_Transaction_Amount MONEY
)
AS $$
DECLARE
    i INT;
	yearDiff INT;
BEGIN
	CREATE TEMPORARY TABLE tempYear ( Year_Number INT );
	
	i := 1;
	yearDiff := ENDYEAR - STARTYEAR;
	
	FOR i IN 0..yearDiff LOOP
        INSERT INTO tempYear VALUES (STARTYEAR + i);
		i := i + 1;
    END LOOP;
	
	/*
	WHILE i <= yearDiff LOOP
        INSERT INTO tempYear VALUES (STARTYEAR + i);
        i := i + 1;
    END LOOP;
	*/
	
	RETURN QUERY
	WITH FilteredTransactions AS (
		SELECT
			t.TransactionID,
			t.Transaction_Date,
			t.Transaction_Amount
		FROM BusinessC.Transaction t
			JOIN BusinessC.Customer c ON c.CustomerID = t.CustomerID
		WHERE c.CustomerID = CUSTID
			AND (EXTRACT(YEAR FROM t.Transaction_Date) >= STARTYEAR AND EXTRACT(YEAR FROM t.Transaction_Date) <=  ENDYEAR)
	)
	SELECT
		ty.Year_Number AS YEAR,
		COALESCE(COUNT(ft.TransactionID), 0::INT)::INT AS Total_Transaction,
		COALESCE(SUM(ft.Transaction_Amount), 0::MONEY)::MONEY AS Total_Transaction_Amount
	FROM tempYear ty
		LEFT JOIN FilteredTransactions ft ON EXTRACT(YEAR FROM ft.Transaction_Date) = ty.Year_Number
	GROUP BY YEAR
	ORDER BY YEAR DESC;
	
	DROP TABLE IF EXISTS tempYear;
END;
$$ LANGUAGE PLPGSQL

SELECT * FROM BusinessC.yearly_report(1, 2015, 2023);