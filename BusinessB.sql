CREATE SCHEMA BusinessB;

CREATE TABLE BusinessB.Customer (
    CustomerID SERIAL PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Age INT,
    Address TEXT,
    Birthday DATE,
    Country VARCHAR(50),
    Wallet_Amount MONEY DEFAULT 0
);

DROP TABLE BusinessB.Customer;
COPY BusinessB.Customer FROM 'C:\Users\PC001\Downloads\BusinessB_customer.csv' DELIMITER ',' CSV HEADER;

select count(*) from BusinessB.Customer;
select count(DISTINCT (First_Name, Last_Name, Age, Address, Birthday, Country)) from BusinessB.Customer;

CREATE TABLE BusinessB.Transaction (
    TransactionID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES BusinessB.Customer(CustomerID),
    Transaction_Name VARCHAR(100),
    Transaction_Amount MONEY,
    Note TEXT,
    Transaction_Date TIMESTAMP
);

DROP TABLE BusinessB.Transaction;
COPY BusinessB.Transaction FROM 'C:\Users\PC001\Downloads\BusinessB_transaction.csv' DELIMITER ',' CSV HEADER;
select count(*) from BusinessB.Transaction;
--select count(DISTINCT (CUSTOMERID)) from BusinessB.Transaction;

CREATE TABLE BusinessB.DepositWithdrawal (
    DepositWithdrawalID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES BusinessB.Customer(CustomerID),
    Transfer_Amount MONEY,
    Transfer_Type VARCHAR(100),
	Source_Fund VARCHAR(100),
    Transaction_Date TIMESTAMP
);

DROP TABLE BusinessB.DepositWithdrawal;
COPY BusinessB.DepositWithdrawal FROM 'C:\Users\PC001\Downloads\BusinessB_depositwithdrawal.csv' DELIMITER ',' CSV HEADER;
select count(*) from BusinessB.DepositWithdrawal;
--select count(DISTINCT (CUSTOMERID)) from BusinessB.DepositWithdrawal;