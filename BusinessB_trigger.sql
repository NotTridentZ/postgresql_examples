CREATE OR REPLACE FUNCTION BusinessB.trigger_function_calculateWallet()
	RETURNS TRIGGER
AS $calculate_wallet_trigger$
DECLARE
	currAmount money := 0;
	newWallet money := 0;
BEGIN
		--DECLARE currAmount money := 0;
		BEGIN
			SELECT Wallet_Amount INTO currAmount
			FROM BusinessB.Customer
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
		
		UPDATE BusinessB.Customer
			SET Wallet_Amount = newWallet
		WHERE CustomerID = NEW.CustomerID;
		
		RETURN NEW;
END;
$calculate_wallet_trigger$ LANGUAGE PLPGSQL;

CREATE TRIGGER calculate_wallet_trigger
AFTER INSERT ON BusinessB.DepositWithdrawal
FOR EACH ROW EXECUTE PROCEDURE BusinessB.trigger_function_calculateWallet();

--test
INSERT INTO BusinessB.DepositWithdrawal (CustomerID, TRANSFER_AMOUNT, TRANSFER_TYPE, Source_Fund, Transaction_Date)
VALUES ('1','100','Deposit', 'Debit Card',CURRENT_TIMESTAMP);

INSERT INTO BusinessB.DepositWithdrawal (CustomerID, TRANSFER_AMOUNT, TRANSFER_TYPE, Source_Fund, Transaction_Date)
VALUES ('1','100','Withdraw', 'Wallet',CURRENT_TIMESTAMP);

--check walletamount
SELECT c.CustomerID,
		dw.DepositWithdrawalID,
		dw.Transfer_amount,
		dw.Transfer_Type,
		c.Wallet_amount,
		dw.Transaction_date
FROM BusinessB.DepositWithdrawal dw
JOIN BusinessB.Customer c ON dw.CustomerID = c.CustomerID
WHERE c.CustomerID = '1'
ORDER BY dw.Transaction_Date DESC;