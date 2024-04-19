CREATE TABLE BusinessA.TableMonth(
	Month_Number INT
);
INSERT INTO BusinessA.TableMonth VALUES(1);
INSERT INTO BusinessA.TableMonth VALUES(2);
INSERT INTO BusinessA.TableMonth VALUES(3);
INSERT INTO BusinessA.TableMonth VALUES(4);
INSERT INTO BusinessA.TableMonth VALUES(5);
INSERT INTO BusinessA.TableMonth VALUES(6);
INSERT INTO BusinessA.TableMonth VALUES(7);
INSERT INTO BusinessA.TableMonth VALUES(8);
INSERT INTO BusinessA.TableMonth VALUES(9);
INSERT INTO BusinessA.TableMonth VALUES(10);
INSERT INTO BusinessA.TableMonth VALUES(11);
INSERT INTO BusinessA.TableMonth VALUES(12);

CREATE OR REPLACE FUNCTION BusinessA.monthly_report
(
	CUSTID INT, --assume maintainer already get customer id
	INYEAR INT -- selected year
)
RETURNS TABLE
(
	Month_Number INT,
	TOTAL_TRANSACTION INT,
	ToTal_Transaction_Amount MONEY
)
AS $$
BEGIN
	RETURN QUERY
	WITH FilteredTransactions AS (
		SELECT
			t.TransactionID,
			t.Transaction_Date,
			t.Transaction_Amount
		FROM BusinessA.Transaction t
			JOIN BUSINESSA.Customer c ON c.CustomerID = t.CustomerID
		WHERE c.CustomerID = CUSTID
			AND EXTRACT(YEAR FROM t.Transaction_Date) = INYEAR
	)
	SELECT
		tw.Month_number,
		COALESCE(COUNT(ft.TransactionID), 0::INT)::INT AS Total_Transaction,
		COALESCE(SUM(ft.Transaction_Amount), 0::MONEY)::MONEY AS Total_Transaction_Amount
	FROM BusinessA.TableMonth tw 
		LEFT JOIN FilteredTransactions ft ON tw.Month_Number = EXTRACT(MONTH FROM ft.Transaction_Date)
	GROUP BY tw.Month_number
	ORDER BY tw.Month_number ASC;
END;
$$ LANGUAGE PLPGSQL

SELECT * FROM BusinessA.monthly_report(1, 2022);