--trigger on each inserted new row for deposit/withdraw to update the wallet amount for current user
CREATE OR REPLACE FUNCTION BusinessA.trigger_function_calculateWallet()
	RETURNS TRIGGER
AS $calculate_wallet_trigger$
DECLARE
	currAmount money := 0;
	newWallet money := 0;
BEGIN
		--DECLARE currAmount money := 0;
		BEGIN
			SELECT Wallet_Amount INTO currAmount
			FROM BusinessA.Customer
			WHERE CustomerID = NEW.CustomerID
			LIMIT 1;
		EXCEPTION
			WHEN OTHERS THEN
				currAmount := 0;
		END;

		--DECLARE newWallet money := 0;
		IF NEW.Transfer_Type = 'Deposit' THEN
			newWallet := currAmount + NEW.Transfer_Amount;
		ELSIF NEW.Transfer_Type = 'Withdraw' THEN
			newWallet := currAmount - NEW.Transfer_Amount;
		END IF;
		
		UPDATE BusinessA.Customer
			SET Wallet_Amount = newWallet
		WHERE CustomerID = NEW.CustomerID;
		
		RETURN NEW;
END;
$calculate_wallet_trigger$ LANGUAGE PLPGSQL;

CREATE TRIGGER calculate_wallet_trigger
AFTER INSERT ON BusinessA.DepositWithdrawal
FOR EACH ROW EXECUTE PROCEDURE BusinessA.trigger_function_calculateWallet();

--test
INSERT INTO BusinessA.DepositWithdrawal (CustomerID, TRANSFER_AMOUNT, TRANSFER_TYPE, Source_Fund, Transaction_Date)
VALUES ('1','100','Deposit', 'Debit Card',CURRENT_TIMESTAMP);

INSERT INTO BusinessA.DepositWithdrawal (CustomerID, TRANSFER_AMOUNT, TRANSFER_TYPE, Source_Fund, Transaction_Date)
VALUES ('1','100','Withdraw', 'Wallet',CURRENT_TIMESTAMP);

--check walletamount
SELECT c.CustomerID,
		dw.DepositWithdrawalID,
		dw.Transfer_amount,
		dw.Transfer_Type,
		c.Wallet_amount,
		dw.Transaction_date
FROM BusinessA.DepositWithdrawal dw
JOIN BusinessA.Customer c ON dw.CustomerID = c.CustomerID
WHERE c.CustomerID = '1'
ORDER BY dw.Transaction_Date DESC;

--old school not used
/*CREATE OR REPLACE FUNCTION BusinessA.trigger_function_calculateWallet() 
   RETURNS TRIGGER 
   LANGUAGE PLPGSQL
AS $$
DECLARE
	trfAmount money := 0;
	ttype varchar(100) := 'blank';
	getcussid int := 0;
	currAmount money := 0;
	newWallet money := 0;
BEGIN
   		--DECLARE trfAmount money := 0;
		--DECLARE ttype varchar(100) := 'blank';
		--DECLARE getcussid int := 0;
			
		BEGIN
			SELECT transfer_amount, transfer_type, customerid INTO trfAmount, ttype, getcussid
			FROM BusinessA.DepositWithdrawal
			ORDER BY transaction_Date DESC
			LIMIT 1;
		EXCEPTION
			WHEN OTHERS THEN
				trfAmount := 0;
		END;
		
		--DECLARE currAmount money := 0;
		BEGIN
			SELECT Wallet_Amount INTO currAmount
			FROM BusinessA.Customer
			WHERE CustomerID = getcussid
			LIMIT 1;
		EXCEPTION
			WHEN OTHERS THEN
				currAmount := 0;
		END;
		
		--DECLARE newWallet money := 0;
		IF ttype = 'deposit' THEN
			newWallet := currAmount + trfAmount;
		ELSIF ttype = 'withdraw' THEN
			newWallet := currAmount - trfAmount;
		END IF;
		
		UPDATE BusinessA.Customer
			SET Wallet_Amount = newWallet
		WHERE CustomerID = getcussid;
END;
$$

CREATE TRIGGER calculate_wallet_trigger
AFTER INSERT ON BusinessA.DepositWithdrawal
FOR EACH ROW EXECUTE PROCEDURE trigger_function_calculateWallet();
*/