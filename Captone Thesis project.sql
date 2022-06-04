/* 
TEAM 7 - MSBA 1
SQL Data Management - Prof Luis Escamilla
By Hasnain Ahmed
Profit & Loss Statement and Balance Sheet
*/

USE H_Accounting;

DROP PROCEDURE IF EXISTS `balancesheet_7`;

DELIMITER $$
CREATE PROCEDURE `balancesheet_7` (varCalendarYear YEAR)
BEGIN

SELECT st.statement_section AS balancesheet_7, FORMAT(SUM(jeli.debit), 2) as debit, FORMAT(SUM(jeli.credit), 2) as credit,
		FORMAT(SUM(jeli.debit) - SUM(jeli.credit), 2) AS balance
	
    FROM statement_section AS st
		LEFT OUTER JOIN account AS ac ON ac.balance_sheet_section_id = st.statement_section_id
        LEFT OUTER JOIN journal_entry_line_item as jeli ON ac.account_id = jeli.account_id
        LEFT OUTER JOIN journal_entry AS je ON jeli.journal_entry_id = je.journal_entry_id
	WHERE st.statement_section_id IN (61, 62, 63, 64, 65, 66, 67)
		AND YEAR(je.entry_date) <= varCalendarYear
        AND je.cancelled = 0
        AND je.debit_credit_balanced = 1
	GROUP BY st.statement_section_id
    ORDER BY st.statement_section_id;
    
END $$
DELIMITER ;

CALL balancesheet_7(2019); #<-- CHANGE THE YEAR inside the parentheses


/* YEAR 2018
TOTAL ASSETS = CURRENT ASSETS +  FIXED ASSETS
			= 2,975,073.72 + 0
            =2,975,073.72
	TOTAL Liabilities  and Equity = CURRENT LIABILITIES + EQUITY
								= 1,193,161.36 + 1,781,912.36
                                = 2,975,073.72
	TOTAL ASSETS = TOTAL LIABILITIES and Equity 
    */

DROP TABLE IF EXISTS balance_7_table;

 
CREATE TABLE balance_7_table
	(	balance_number INT, 
		label VARCHAR(50), 
		amount Double
	);
  
INSERT INTO balance_7_table 
	(balance_number, label, amount)
  
    VALUES 
   (1, 'TOTAL ASSETS (k)', '2975073.72'),
   (2, 'FIXED ASSETS (k)', '0'),
   (3, 'CURRENT LIABILITIES (k)', '1193161.36'),
   (4, 'EQUITY (k)', '1781912.36');
	
SELECT label, format(amount / 1000, 0) AS '2019' FROM balance_7_table;
            
            


#PROFIT AND LOSS STATEMENT



DROP PROCEDURE IF EXISTS `pl_7`;

DELIMITER $$
CREATE PROCEDURE `pl_7` (varCalendarYear YEAR)
BEGIN

SELECT st.statement_section AS pl_7, FORMAT(SUM(jel.debit), 2) as debit, FORMAT(SUM(jel.credit), 2) as credit,
		FORMAT(SUM(jel.debit) - SUM(jel.credit), 2) AS balance
	
    
    FROM journal_entry_line_item AS jel
		INNER JOIN account AS ac ON ac.account_id = jel.account_id
        INNER JOIN statement_section AS st ON st.statement_section_id = ac.profit_loss_section_id
        INNER JOIN journal_entry AS je on je.journal_entry_id = jel.journal_entry_id
	WHERE st.statement_section_id IN (68, 69, 74, 75, 76, 77)
		AND YEAR(je.entry_date) <= varCalendarYear
	GROUP BY st.statement_section_id
    ORDER BY st.statement_section_id;
    
END $$
DELIMITER ;


CALL pl_7(2019); #<-- CHANGE THE YEAR inside the parentheses

#2018
#GROSS PROFIT = REVENUE - Cost of GOODS SOLDS
#GROSS PROFIT = 10,832,301.54 - 7,708,051.51
#GROSS PROFIT = 3,124,250.03

#NET INCOME = GROSS PROFIT - SELLING EXPENSES - OTHER EXPENSES
#NET INCOME = 3,124,250.03 - 1,647,078.52 - 349,966.81
#NET INCOME = 1,127,204.7 

###2019
#GROSS PROFIT = REVENUE - Cost of GOODS SOLDS
#GROSS PROFIT = 14,296,911.44 - 12,450,928.39
#GROSS PROFIT = 1,845,983.05

#NET LOSS = GROSS PROFIT - SELLING EXPENSES - OTHER EXPENSES
#NET LOSS = 1,845,983.05 - 2,190,505.51 - 538,188.95
#NET LOSS = -882,711.41

DROP TABLE IF EXISTS pl_7_table;

 
CREATE TABLE pl_7_table
	(	profit_loss_line_number INT, 
		label VARCHAR(50), 
		amount Double
	);
  
INSERT INTO pl_7_table 
	(profit_loss_line_number, label, amount)
  
    VALUES 
   (1, 'TOTAL REVENUES (k)', '14296911.442'),
   (2, 'TOTAL OF GOODS AND SERVICES (k)', '12450928.39'),
   (3, 'SELLING EXPENSES (k)', '2190505.51'),
   (4, 'OTHER EXPENSES (k)', '538188.95');
	
SELECT label, format(amount / 1000, 0) AS '2019' FROM pl_7_table;
	
