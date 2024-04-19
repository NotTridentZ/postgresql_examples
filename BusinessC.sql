CREATE SCHEMA BusinessC;

CREATE TABLE BusinessC.Customer (
    CustomerID SERIAL PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Age INT,
    Address TEXT,
    Birthday DATE,
    Country VARCHAR(50),
    Wallet_Amount MONEY DEFAULT 0
);

DROP TABLE BusinessC.Customer;

COPY BusinessC.Customer FROM 'C:\Users\PC001\Downloads\BusinessC_customer.csv' DELIMITER ',' CSV HEADER;

select count(*) from BusinessC.Customer;
select count(DISTINCT (First_Name, Last_Name, Age, Address, Birthday, Country)) from BusinessC.Customer;

CREATE TABLE BusinessC.Transaction (
    TransactionID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES BusinessC.Customer(CustomerID),
    Transaction_Name VARCHAR(100),
    Transaction_Amount MONEY,
    Note TEXT,
    Transaction_Date TIMESTAMP
);

DROP TABLE BusinessC.Transaction;
COPY BusinessC.Transaction FROM 'C:\Users\PC001\Downloads\BusinessC_transaction.csv' DELIMITER ',' CSV HEADER;
select count(*) from BusinessC.Transaction;
--select count(DISTINCT (CUSTOMERID)) from BusinessC.Transaction;

CREATE TABLE BusinessC.DepositWithdrawal (
    DepositWithdrawalID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES BusinessC.Customer(CustomerID),
    Transfer_Amount MONEY,
    Transfer_Type VARCHAR(100),
	Source_Fund VARCHAR(100),
    Transaction_Date TIMESTAMP
);

DROP TABLE BusinessC.DepositWithdrawal;
COPY BusinessC.DepositWithdrawal FROM 'C:\Users\PC001\Downloads\BusinessC_depositwithdrawal.csv' DELIMITER ',' CSV HEADER;
select count(*) from BusinessC.DepositWithdrawal;
--select count(DISTINCT (CUSTOMERID)) from BusinessC.DepositWithdrawal;