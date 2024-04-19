CREATE TABLE BusinessC.TableWeek(
	Week_Number INT
);
INSERT INTO BusinessC.TableWeek VALUES(1);
INSERT INTO BusinessC.TableWeek VALUES(2);
INSERT INTO BusinessC.TableWeek VALUES(3);
INSERT INTO BusinessC.TableWeek VALUES(4);
INSERT INTO BusinessC.TableWeek VALUES(5);
INSERT INTO BusinessC.TableWeek VALUES(6);
INSERT INTO BusinessC.TableWeek VALUES(7);
INSERT INTO BusinessC.TableWeek VALUES(8);
INSERT INTO BusinessC.TableWeek VALUES(9);
INSERT INTO BusinessC.TableWeek VALUES(10);
INSERT INTO BusinessC.TableWeek VALUES(11);
INSERT INTO BusinessC.TableWeek VALUES(12);
INSERT INTO BusinessC.TableWeek VALUES(13);
INSERT INTO BusinessC.TableWeek VALUES(14);
INSERT INTO BusinessC.TableWeek VALUES(15);
INSERT INTO BusinessC.TableWeek VALUES(16);
INSERT INTO BusinessC.TableWeek VALUES(17);
INSERT INTO BusinessC.TableWeek VALUES(18);
INSERT INTO BusinessC.TableWeek VALUES(19);
INSERT INTO BusinessC.TableWeek VALUES(20);
INSERT INTO BusinessC.TableWeek VALUES(21);
INSERT INTO BusinessC.TableWeek VALUES(22);
INSERT INTO BusinessC.TableWeek VALUES(23);
INSERT INTO BusinessC.TableWeek VALUES(24);
INSERT INTO BusinessC.TableWeek VALUES(25);
INSERT INTO BusinessC.TableWeek VALUES(26);
INSERT INTO BusinessC.TableWeek VALUES(27);
INSERT INTO BusinessC.TableWeek VALUES(28);
INSERT INTO BusinessC.TableWeek VALUES(29);
INSERT INTO BusinessC.TableWeek VALUES(30);
INSERT INTO BusinessC.TableWeek VALUES(31);
INSERT INTO BusinessC.TableWeek VALUES(32);
INSERT INTO BusinessC.TableWeek VALUES(33);
INSERT INTO BusinessC.TableWeek VALUES(34);
INSERT INTO BusinessC.TableWeek VALUES(35);
INSERT INTO BusinessC.TableWeek VALUES(36);
INSERT INTO BusinessC.TableWeek VALUES(37);
INSERT INTO BusinessC.TableWeek VALUES(38);
INSERT INTO BusinessC.TableWeek VALUES(39);
INSERT INTO BusinessC.TableWeek VALUES(40);
INSERT INTO BusinessC.TableWeek VALUES(41);
INSERT INTO BusinessC.TableWeek VALUES(42);
INSERT INTO BusinessC.TableWeek VALUES(43);
INSERT INTO BusinessC.TableWeek VALUES(44);
INSERT INTO BusinessC.TableWeek VALUES(45);
INSERT INTO BusinessC.TableWeek VALUES(46);
INSERT INTO BusinessC.TableWeek VALUES(47);
INSERT INTO BusinessC.TableWeek VALUES(48);
INSERT INTO BusinessC.TableWeek VALUES(49);
INSERT INTO BusinessC.TableWeek VALUES(50);
INSERT INTO BusinessC.TableWeek VALUES(51);
INSERT INTO BusinessC.TableWeek VALUES(52);

SELECT * FROM BusinessC.TableWeek;

CREATE OR REPLACE FUNCTION BusinessC.weekly_report
(
	CUSTID INT, --assume maintainer already get cumstomer id
	INYEAR INT -- selected year
)
RETURNS TABLE
(
	Week_Number INT,
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
		FROM BusinessC.Transaction t
			JOIN BusinessC.Customer c ON c.CustomerID = t.CustomerID
		WHERE c.CustomerID = CUSTID
			AND EXTRACT(YEAR FROM t.Transaction_Date) = INYEAR
	)
	SELECT
		tw.week_number,
		COALESCE(COUNT(ft.TransactionID), 0::INT)::INT AS Total_Transaction,
		COALESCE(SUM(ft.Transaction_Amount), 0::MONEY)::MONEY AS Total_Transaction_Amount
	FROM BusinessC.TableWeek tw 
		LEFT JOIN FilteredTransactions ft ON tw.Week_Number = EXTRACT(WEEK FROM ft.Transaction_Date)
	GROUP BY tw.Week_Number
	ORDER BY tw.Week_Number ASC;
END;
$$ LANGUAGE PLPGSQL

SELECT * FROM BusinessC.weekly_report(1, 2022);