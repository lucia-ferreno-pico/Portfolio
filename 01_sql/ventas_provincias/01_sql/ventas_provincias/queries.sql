--PARTE I:
--1º

SELECT  
	SOH.OrderDate,
	SUM (SOD.LineTotal) AS SALES
FROM SALES.SalesOrderDetail AS SOD
INNER JOIN SALES.SalesOrderHeader AS SOH
	ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY SOH.OrderDate
ORDER BY SOH.OrderDate

--2º

SELECT 
	SOH.OrderDate, 
	SUM (SOD.LineTotal) AS SalesUSA
INTO #tablatemporalUSA
FROM SALES.SalesOrderDetail AS SOD
INNER JOIN SALES.SalesOrderHeader AS SOH
	ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
WHERE ST.[Group] ='North America'
GROUP BY SOH.OrderDate
ORDER BY SOH.OrderDate

select* from #tablatemporalUSA

--3º

SELECT 
	SOH.OrderDate, 
	SUM (SOD.LineTotal) AS SalesEU
INTO #tablatemporaleu
FROM SALES.SalesOrderDetail AS SOD
INNER JOIN SALES.SalesOrderHeader AS SOH
	ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
WHERE ST.[Group] ='Europe'
GROUP BY SOH.OrderDate
ORDER BY SOH.OrderDate

select * from #tablatemporaleu

--4º

SELECT 
	SOH.OrderDate, 
	SUM (SOD.LineTotal) AS SalesPAc
into #tablatemporalpac
FROM SALES.SalesOrderDetail AS SOD
INNER JOIN SALES.SalesOrderHeader AS SOH
	ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
WHERE ST.[Group] ='Pacific'
GROUP BY SOH.OrderDate
ORDER BY SOH.OrderDate

select * from #tablatemporalpac

--5º
SELECT  
	SOH.OrderDate,
	SUM (SOD.LineTotal) AS SALES,
	USA.SalesUSA, 
	EU.SalesEU, 
	PAC.SalesPAc
FROM SALES.SalesOrderDetail AS SOD
INNER JOIN SALES.SalesOrderHeader AS SOH
	ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN #tablatemporalUSA as USA
	on USA.OrderDate = SOH.OrderDate
LEFT JOIN #tablatemporaleu as EU
	on EU.OrderDate = SOH.OrderDate
LEFT JOIN #tablatemporalpac as PAC
	on PAC.OrderDate = SOH.OrderDate
GROUP BY SOH.OrderDate,USA.SalesUSA, EU.SalesEU, PAC.SalesPAc
ORDER BY SOH.OrderDate

--PARTE II:
SELECT  
	SUM (SOH.SubTotal) AS TotalAmount
	,CUS.CustomerID
	,ST.Name AS Country
	,ST.CountryRegionCode
	,ST.[Group]
	,CUS.PersonID
	, PP.PersonType
	,PDG.DateFirstPurchase
	,PDG.BirthDate
	,DATEDIFF (YEAR,PDG.BirthDate, GETDATE()) AS Age
	,PDG.MaritalStatus
	,PDG.YearlyIncome
	,PDG.Gender
	,PDG.TotalChildren
	,PDG.Education
	,PDG.Occupation
	,PDG.HomeOwnerFlag
	,PDG.NumberCarsOwned
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON PP.BusinessEntityID = CUS.PersonID
INNER JOIN Sales.SalesOrderHeader AS SOH
	ON SOH.CustomerID = CUS.CustomerID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
INNER JOIN Sales.vPersonDemographics AS PDG
	ON PDG.BusinessEntityID = PP.BusinessEntityID
WHERE PP.PersonType = 'IN'
GROUP BY 
	CUS.CustomerID, ST.Name
	,ST.CountryRegionCode, ST.[Group]
	, CUS.PersonID, PP.PersonType
	, PDG.DateFirstPurchase,PDG.BirthDate
	,PDG.MaritalStatus,PDG.YearlyIncome
	,PDG.Gender,PDG.TotalChildren
	,PDG.Education,PDG.Occupation
	,PDG.HomeOwnerFlag,PDG.NumberCarsOwned
ORDER BY CUS.CustomerID ASC

--PARTE III:
WITH CTE AS (
SELECT DISTINCT 
	SOH.CustomerID
	, 1 AS BikePurchase
FROM Sales.SalesOrderDetail as SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
	ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product as PP
	ON PP.ProductID = SOD.ProductID
WHERE PP.ProductSubcategoryID IN (1,2,3))
SELECT  
	SUM(SOH.SubTotal) AS TotalAmount
	,ISNULL(BIKE.BikePurchase
	, 0) AS BikePurchase
	,CUS.CustomerID
	,ST.Name AS Country
	,ST.CountryRegionCode
	,ST.[Group],CUS.PersonID
	, PP.PersonType
	,PDG.DateFirstPurchase
	,PDG.BirthDate
	,DATEDIFF (YEAR,PDG.BirthDate, GETDATE()) AS Age
	,PDG.MaritalStatus,PDG.YearlyIncome
	,PDG.Gender,PDG.TotalChildren
	,PDG.Education
	,PDG.Occupation
	,PDG.HomeOwnerFlag
	,PDG.NumberCarsOwned
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON PP.BusinessEntityID = CUS.PersonID
INNER JOIN Sales.SalesOrderHeader AS SOH
	ON SOH.CustomerID = CUS.CustomerID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
INNER JOIN Sales.vPersonDemographics AS PDG
	ON PDG.BusinessEntityID = PP.BusinessEntityID
LEFT JOIN CTE AS BIKE
	ON BIKE.CustomerID = SOH.CustomerID
WHERE PP.PersonType = 'IN'
GROUP BY 
CUS.CustomerID
, ST.Name
, ST.CountryRegionCode
, ST.[Group]
, CUS.PersonID
, PP.PersonType
, PDG.DateFirstPurchase
,PDG.BirthDate
,PDG.MaritalStatus
,PDG.YearlyIncome
,PDG.Gender
,PDG.TotalChildren
,PDG.Education
,PDG.Occupation
,PDG.HomeOwnerFlag
,PDG.NumberCarsOwned
,BIKE.BikePurchase
ORDER BY PDG.DateFirstPurchase ASC


