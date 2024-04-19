--assume the maintainer already know on what business is the customer in, this example assume BusinessA

--deposit/withdrawal history
SELECT c.First_Name, c.Last_Name, 
	d.Transfer_Type, 
	d.Transfer_Amount,
	d.source_fund,
	d.Transaction_Date
FROM BusinessA.Customer c
JOIN BusinessA.DepositWithdrawal d ON c.customerid = d.customerid
WHERE c.customerid = '1'
ORDER BY d.Transaction_Date DESC;

--transaction history
SELECT c.First_Name, c.Last_Name, 
	t.Transaction_name, 
	t.Transaction_Amount,
	t.Note,
	t.Transaction_Date
FROM BusinessA.Customer c
JOIN BusinessA.Transaction t ON c.customerid = t.customerid
WHERE c.customerid = '1'
ORDER BY t.Transaction_Date DESC;