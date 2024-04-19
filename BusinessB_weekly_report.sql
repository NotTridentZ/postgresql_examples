CREATE TABLE BusinessB.TableWeek(
	Week_Number INT
);
INSERT INTO BusinessB.TableWeek VALUES(1);
INSERT INTO BusinessB.TableWeek VALUES(2);
INSERT INTO BusinessB.TableWeek VALUES(3);
INSERT INTO BusinessB.TableWeek VALUES(4);
INSERT INTO BusinessB.TableWeek VALUES(5);
INSERT INTO BusinessB.TableWeek VALUES(6);
INSERT INTO BusinessB.TableWeek VALUES(7);
INSERT INTO BusinessB.TableWeek VALUES(8);
INSERT INTO BusinessB.TableWeek VALUES(9);
INSERT INTO BusinessB.TableWeek VALUES(10);
INSERT INTO BusinessB.TableWeek VALUES(11);
INSERT INTO BusinessB.TableWeek VALUES(12);
INSERT INTO BusinessB.TableWeek VALUES(13);
INSERT INTO BusinessB.TableWeek VALUES(14);
INSERT INTO BusinessB.TableWeek VALUES(15);
INSERT INTO BusinessB.TableWeek VALUES(16);
INSERT INTO BusinessB.TableWeek VALUES(17);
INSERT INTO BusinessB.TableWeek VALUES(18);
INSERT INTO BusinessB.TableWeek VALUES(19);
INSERT INTO BusinessB.TableWeek VALUES(20);
INSERT INTO BusinessB.TableWeek VALUES(21);
INSERT INTO BusinessB.TableWeek VALUES(22);
INSERT INTO BusinessB.TableWeek VALUES(23);
INSERT INTO BusinessB.TableWeek VALUES(24);
INSERT INTO BusinessB.TableWeek VALUES(25);
INSERT INTO BusinessB.TableWeek VALUES(26);
INSERT INTO BusinessB.TableWeek VALUES(27);
INSERT INTO BusinessB.TableWeek VALUES(28);
INSERT INTO BusinessB.TableWeek VALUES(29);
INSERT INTO BusinessB.TableWeek VALUES(30);
INSERT INTO BusinessB.TableWeek VALUES(31);
INSERT INTO BusinessB.TableWeek VALUES(32);
INSERT INTO BusinessB.TableWeek VALUES(33);
INSERT INTO BusinessB.TableWeek VALUES(34);
INSERT INTO BusinessB.TableWeek VALUES(35);
INSERT INTO BusinessB.TableWeek VALUES(36);
INSERT INTO BusinessB.TableWeek VALUES(37);
INSERT INTO BusinessB.TableWeek VALUES(38);
INSERT INTO BusinessB.TableWeek VALUES(39);
INSERT INTO BusinessB.TableWeek VALUES(40);
INSERT INTO BusinessB.TableWeek VALUES(41);
INSERT INTO BusinessB.TableWeek VALUES(42);
INSERT INTO BusinessB.TableWeek VALUES(43);
INSERT INTO BusinessB.TableWeek VALUES(44);
INSERT INTO BusinessB.TableWeek VALUES(45);
INSERT INTO BusinessB.TableWeek VALUES(46);
INSERT INTO BusinessB.TableWeek VALUES(47);
INSERT INTO BusinessB.TableWeek VALUES(48);
INSERT INTO BusinessB.TableWeek VALUES(49);
INSERT INTO BusinessB.TableWeek VALUES(50);
INSERT INTO BusinessB.TableWeek VALUES(51);
INSERT INTO BusinessB.TableWeek VALUES(52);

SELECT * FROM BusinessB.TableWeek;

CREATE OR REPLACE FUNCTION BusinessB.weekly_report
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
		FROM BusinessB.Transaction t
			JOIN BusinessB.Customer c ON c.CustomerID = t.CustomerID
		WHERE c.CustomerID = CUSTID
			AND EXTRACT(YEAR FROM t.Transaction_Date) = INYEAR
	)
	SELECT
		tw.week_number,
		COALESCE(COUNT(ft.TransactionID), 0::INT)::INT AS Total_Transaction,
		COALESCE(SUM(ft.Transaction_Amount), 0::MONEY)::MONEY AS Total_Transaction_Amount
	FROM BusinessB.TableWeek tw 
		LEFT JOIN FilteredTransactions ft ON tw.Week_Number = EXTRACT(WEEK FROM ft.Transaction_Date)
	GROUP BY tw.Week_Number
	ORDER BY tw.Week_Number ASC;
END;
$$ LANGUAGE PLPGSQL

SELECT * FROM BusinessB.weekly_report(1, 2022);