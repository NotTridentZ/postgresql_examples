CREATE SCHEMA BusinessA;

CREATE TABLE BusinessA.Customer (
    CustomerID SERIAL PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Age INT,
    Address TEXT,
    Birthday DATE,
    Country VARCHAR(50),
    Wallet_Amount MONEY DEFAULT 0
);

DROP TABLE BusinessA.Customer;
COPY BusinessA.Customer FROM 'C:\Users\PC001\Downloads\BusinessA_customer.csv' DELIMITER ',' CSV HEADER;

/*
INSERT INTO BusinessA.Customer(First_Name, Last_Name, Age, Address, Birthday, Country, Wallet_amount)
SELECT
    md5(random()::text), --first_name
    md5(random()::text), --last_name
    FLOOR(RANDOM() * (90) + 10)::int, --age
	md5(random()::text), --address
	NOW() - '1 year'::INTERVAL * ROUND(RANDOM() * 100), --birthday
	md5(random()::text), --country
	(10000000 + (random() * (100000000 - 10000000)))::int AS random_money
FROM generate_series(1, 1000);
*/

select count(*) from BusinessA.Customer;
select count(DISTINCT (First_Name, Last_Name, Age, Address, Birthday, Country)) from BusinessA.Customer;

CREATE TABLE BusinessA.Transaction (
    TransactionID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES BusinessA.Customer(CustomerID),
    Transaction_Name VARCHAR(100),
    Transaction_Amount MONEY,
    Note TEXT,
    Transaction_Date TIMESTAMP
);

DROP TABLE BusinessA.Transaction;
COPY BusinessA.Transaction FROM 'C:\Users\PC001\Downloads\BusinessA_transaction.csv' DELIMITER ',' CSV HEADER;
select count(*) from BusinessA.Transaction;
--select count(DISTINCT (CUSTOMERID)) from BusinessA.Transaction;

CREATE TABLE BusinessA.DepositWithdrawal (
    DepositWithdrawalID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES BusinessA.Customer(CustomerID),
    Transfer_Amount MONEY,
    Transfer_Type VARCHAR(100),
	Source_Fund VARCHAR(500),
    Transaction_Date TIMESTAMP
);

DROP TABLE BusinessA.DepositWithdrawal;
COPY BusinessA.DepositWithdrawal FROM 'C:\Users\PC001\Downloads\BusinessA_depositwithdrawal.csv' DELIMITER ',' CSV HEADER;
select count(*) from BusinessA.DepositWithdrawal;
--select count(DISTINCT (CUSTOMERID)) from BusinessA.DepositWithdrawal;