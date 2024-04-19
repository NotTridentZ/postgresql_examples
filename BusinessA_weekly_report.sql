CREATE TABLE BusinessA.TableWeek(
	Week_Number INT
);
INSERT INTO BusinessA.TableWeek VALUES(1);
INSERT INTO BusinessA.TableWeek VALUES(2);
INSERT INTO BusinessA.TableWeek VALUES(3);
INSERT INTO BusinessA.TableWeek VALUES(4);
INSERT INTO BusinessA.TableWeek VALUES(5);
INSERT INTO BusinessA.TableWeek VALUES(6);
INSERT INTO BusinessA.TableWeek VALUES(7);
INSERT INTO BusinessA.TableWeek VALUES(8);
INSERT INTO BusinessA.TableWeek VALUES(9);
INSERT INTO BusinessA.TableWeek VALUES(10);
INSERT INTO BusinessA.TableWeek VALUES(11);
INSERT INTO BusinessA.TableWeek VALUES(12);
INSERT INTO BusinessA.TableWeek VALUES(13);
INSERT INTO BusinessA.TableWeek VALUES(14);
INSERT INTO BusinessA.TableWeek VALUES(15);
INSERT INTO BusinessA.TableWeek VALUES(16);
INSERT INTO BusinessA.TableWeek VALUES(17);
INSERT INTO BusinessA.TableWeek VALUES(18);
INSERT INTO BusinessA.TableWeek VALUES(19);
INSERT INTO BusinessA.TableWeek VALUES(20);
INSERT INTO BusinessA.TableWeek VALUES(21);
INSERT INTO BusinessA.TableWeek VALUES(22);
INSERT INTO BusinessA.TableWeek VALUES(23);
INSERT INTO BusinessA.TableWeek VALUES(24);
INSERT INTO BusinessA.TableWeek VALUES(25);
INSERT INTO BusinessA.TableWeek VALUES(26);
INSERT INTO BusinessA.TableWeek VALUES(27);
INSERT INTO BusinessA.TableWeek VALUES(28);
INSERT INTO BusinessA.TableWeek VALUES(29);
INSERT INTO BusinessA.TableWeek VALUES(30);
INSERT INTO BusinessA.TableWeek VALUES(31);
INSERT INTO BusinessA.TableWeek VALUES(32);
INSERT INTO BusinessA.TableWeek VALUES(33);
INSERT INTO BusinessA.TableWeek VALUES(34);
INSERT INTO BusinessA.TableWeek VALUES(35);
INSERT INTO BusinessA.TableWeek VALUES(36);
INSERT INTO BusinessA.TableWeek VALUES(37);
INSERT INTO BusinessA.TableWeek VALUES(38);
INSERT INTO BusinessA.TableWeek VALUES(39);
INSERT INTO BusinessA.TableWeek VALUES(40);
INSERT INTO BusinessA.TableWeek VALUES(41);
INSERT INTO BusinessA.TableWeek VALUES(42);
INSERT INTO BusinessA.TableWeek VALUES(43);
INSERT INTO BusinessA.TableWeek VALUES(44);
INSERT INTO BusinessA.TableWeek VALUES(45);
INSERT INTO BusinessA.TableWeek VALUES(46);
INSERT INTO BusinessA.TableWeek VALUES(47);
INSERT INTO BusinessA.TableWeek VALUES(48);
INSERT INTO BusinessA.TableWeek VALUES(49);
INSERT INTO BusinessA.TableWeek VALUES(50);
INSERT INTO BusinessA.TableWeek VALUES(51);
INSERT INTO BusinessA.TableWeek VALUES(52);

SELECT * FROM BusinessA.TableWeek;

CREATE OR REPLACE FUNCTION BusinessA.weekly_report
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
		FROM BusinessA.Transaction t
			JOIN BUSINESSA.Customer c ON c.CustomerID = t.CustomerID
		WHERE c.CustomerID = CUSTID
			AND EXTRACT(YEAR FROM t.Transaction_Date) = INYEAR
	)
	SELECT
		tw.week_number,
		COALESCE(COUNT(ft.TransactionID), 0::INT)::INT AS Total_Transaction,
		COALESCE(SUM(ft.Transaction_Amount), 0::MONEY)::MONEY AS Total_Transaction_Amount
	FROM BusinessA.TableWeek tw 
		LEFT JOIN FilteredTransactions ft ON tw.Week_Number = EXTRACT(WEEK FROM ft.Transaction_Date)
	GROUP BY tw.Week_Number
	ORDER BY tw.Week_Number ASC;
END;
$$ LANGUAGE PLPGSQL

SELECT * FROM BusinessA.weekly_report(1, 2022);