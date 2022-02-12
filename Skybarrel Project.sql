SELECT A.BORROWERID,
CONCAT(A.BorrowerFirstName, ' ',A.BorrowerMiddleInitial, ' ' , A.BorrowerLastName) AS BorrowerFullName,
STUFF(A.TaxPayerID_SSN, 1,5, '*****') AS SSN,YEAR(B.PurchaseDate)AS [YEAR OF PURCHASE],
[PurchaseAmount (IN THOUSAND)]=FORMAT(PURCHASEAMOUNT/1000, 'C0')+'K'
FROM dbo.Borrower AS A
RIGHT JOIN dbo.LoanSetupInformation AS B
ON A.BORROWERID = B.BORROWERID;


                          1B
SELECT A.BORROWERID,
CONCAT_WS(' ', A.BorrowerFirstName, A.BorrowerMiddleInitial, A.BorrowerLastName) AS BorrowerFullName,
concat('*****',RIGHT(A.TaxPayerID_SSN,4)) AS SSN, YEAR(B.PurchaseDate) AS [YEAR OF PURCHASE],
[PurchaseAmount (IN THOUSAND)]=FORMAT(PURCHASEAMOUNT/1000, 'C0')+'K'
FROM dbo.Borrower AS A
LEFT JOIN dbo.LoanSetupInformation AS B
ON A.BORROWERID = B.BORROWERID;


                      2A
Select Citizenship,
format(sum(B.PurchaseAmount),'c0') as [Total Purchase Amount],
FORMAT(avg(B.PurchaseAmount),'c0') as [AVG Purchase Amount],
count(B.BorrowerID) as [No.of Borrowers],
floor(avg(floor((datediff(day, a.dob, getdate())) /365.25))) AS [AVG AGE OF BORROWERS],
format(avg(LTV),'p') as [AVG LTV],
format(min(LTV),'p') AS [MIN LTV],
format(MAX(LTV),'p') AS [MAX LTV]
from LoanSetupInformation AS B
inner join DBO.Borrower AS A
on B.BorrowerID = A.BorrowerID
Group By Citizenship
Order By [TOTAL PURCHASE AMOUNT] DESC


                          2B
Select CASE gender
WHEN 'F'THEN gender
WHEN 'M' THEN gender
ELSE 'X' END AS gender,
A.Citizenship AS Citizenship,
FORMAT(SUM(PurchaseAmount), 'c0') AS [Total Purchase Amount],
FORMAT(avg(B.PurchaseAmount),'c0') as [AVG Purchase Amount],
count(B.BorrowerID) as [No. of Borrowers],
floor(avg(floor((datediff(day, a.dob, getdate())) /365.25))) AS [AVG AGE OF BORROWERS],
format(avg(LTV),'P') as [AVG LTV],
format(min(LTV),'P') AS [MIN LTV],
format(MAX(LTV),'P') AS [MAX LTV]
from LoanSetupInformation AS B
INNER JOIN [dbo].[Borrower] AS A
ON A.BorrowerID = B.BorrowerID
Group By A.gender, Citizenship
ORDER BY [TOTAL PURCHASE AMOUNT] DESC



                  2C
Select year(PurchaseDate) as [Year of Purchase],
case gender
When 'F' THEN 'Female'
When 'M' THEN 'Male'
end
AS GENDER,
FORMAT(SUM(PurchaseAmount), 'c0') AS [Total Purchase Amount],
FORMAT(avg(B.PurchaseAmount),'c0') as [AVG Purchase Amount],
count(B.BorrowerID) as [No. of Borrowers],
floor(avg(floor((datediff(day, a.dob, getdate())) /365.25))) AS [AVG AGE OF BORROWERS],
format(avg(LTV),'P') as [AVG LTV],
format(min(LTV),'P') AS [MIN LTV],
format(MAX(LTV),'P') AS [MAX LTV]
from LoanSetupInformation AS B
INNER JOIN [dbo].[Borrower] AS A
ON A.BorrowerID = B.BorrowerID
Where gender in('F', 'M')
Group By year(PurchaseDate),
case
When Gender = 'F' THEN 'Female'
When Gender = 'M' THEN 'Male'
end
ORDER BY [Year of Purchase], Gender DESC;



SELECT
[Years Left to Maturity (bins)] = CASE
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 5 THEN '00-5'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 10 THEN '06-10'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 15 THEN '11-15'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 20 THEN '16-20'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 25 THEN '21-25'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 30 THEN '26-30'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 > 30 THEN '>30'
END,
[No. of Loans] = COUNT(loannumber),
[Total Purchase Amount]    =    Format(sum(purchaseamount), '$0,,,.000B')
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation]
GROUP BY CASE WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 5 THEN '00-5'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 10 THEN '06-10'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 15 THEN '11-15'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 20 THEN '16-20'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 25 THEN '21-25'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 <= 30 THEN '26-30'
WHEN DATEDIFF(DAY, GETDATE(), [MaturityDate])/365.25 > 30 THEN '>30'
END
ORDER BY [Years Left to Maturity (bins)];



Select Year(b.PurchaseDate) AS [Year Of Purchase],
[PaymentFrequency_Description] AS [Payment Frequ Desc],
Count(B.LoanNumber) AS [No. Of Loans]
From [dbo].[LU_PaymentFrequency] AS A
Left Join [dbo].[LoanSetupInformation] AS B  ON A.PaymentFrequency=b.PaymentFrequency
Group By Year(b.PurchaseDate),[PaymentFrequency_Description]