------------------------------PROYECTO DE ETL EN SQL SERVER (LUCIA FERREÑO PICO)----------------------------------------------

-- Este proyecto de ETL en SQL Server lo llevo a cabo para generar una datawarehouse en la que  
-- consumir los datos reconfigurados y reestructurados de tal manera que sea más sencillo consumirlos en Power BI y hacer reporting.

-- Optimizada para entender el negocio (analizar y decidir).

-- Los pasos seguidos para la creacion de la tabla de hechos y las de dimensiones son:

-- 1º Creación de vistas en AdventureWorks2017 (base de datos de origen)
-- 2º En el datawarehouse (base de datos de destino) genero las TABLAS que almacenarán los datos.
-- 3º Ejecuto las vistas en origen para migrar los datos al datawarehouse




--TABLA DE HECHOS / FACT TABLE (DATOS DE VENTA)


SELECT * FROM Sales.SalesOrderHeader 

SELECT * FROM Sales.SalesOrderDetail 

--Generacion de View para migrar los datos a la base de datos de destino

CREATE OR ALTER VIEW DW_Fact_Sales 
AS
SELECT CONCAT (SOH.SalesOrderID, SOD.SalesOrderDetailID) AS SalesID
		,CAST(SOH.OrderDate AS DATE) AS Orderdate
		,CONCAT(YEAR (OrderDate)
			,IIF (LEN (MONTH (OrderDate))=1
				, CAST(cONCAT (0,MONTH (OrderDate)) AS VARCHAR)
				, CAST(MONTH (OrderDate) AS VARCHAR)) 
			,IIF (LEN (dAY (OrderDate))=1
				, CAST(cONCAT (0,DAY (OrderDate)) AS VARCHAR)
				, CAST(DAY (OrderDate) AS VARCHAR))
			)AS ORDER_DATEKEY
		,CONVERT(DATE , SOH.ShipDate) AS ShipDate
		,CONCAT(YEAR (ShipDate)
			,IIF (LEN (MONTH (ShipDate))=1
				, CAST(cONCAT (0,MONTH (ShipDate)) AS VARCHAR)
				, CAST(MONTH (ShipDate) AS VARCHAR)) 
		,IIF (LEN (dAY (ShipDate))=1
			, CAST(cONCAT (0,DAY (ShipDate)) AS VARCHAR)
			, CAST(DAY (ShipDate) AS VARCHAR))
		)AS SHIP_DATEKEY
		,DATEDIFF (DAY,SOH.OrderDate,ShipDate) AS DaystoShip
		,CASE
			WHEN SOH.Status = 1 THEN 'In process'
			WHEN SOH.Status = 2 THEN 'Approved'
			WHEN SOH.Status = 3 THEN 'Backorderd'
			WHEN SOH.Status = 4 THEN 'Rejected'
			WHEN SOH.Status = 5 THEN 'Shipped'
			WHEN SOH.Status = 6 THEN 'Cancelled' 
			ELSE 'Check'
		END AS Status
		,IIF (SOH.OnlineOrderFlag=1, 'Order placed by sales person', 'Order placed online by customer') as OrderFlag
		,SOH.SalesOrderNumber
		,SOH.AccountNumber
		,SOH.CustomerID
		,ISNULL(SOH.SalesPersonID, 0) as SalesPersonID
		,SOH.BillToAddressID
		,SOH.ShipToAddressID
		,SOH.ShipMethodID
		,SOH.CurrencyRateID
		,SOH.SubTotal
		,SOH.TaxAmt
		,SOH.Freight
		,SOH.TerritoryID
		,SOH.TotalDue
		,ROUND (SOH.TaxAmt / (SOH.SubTotal + SOH.TaxAmt + SOH.Freight),2) AS PercentageTAX
		,ROUND (SOH.Freight / (SOH.SubTotal + SOH.TaxAmt + SOH.Freight),2) AS PercentageFreight
		,SOD.OrderQty
		,SOD.ProductID
		,SOD.UnitPrice
		,SOD.LineTotal
		,ROUND(SOD.LineTotal/SOH.TotalDue,2) AS PercentageOfOrder
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
	ON  SOH.SalesOrderID = SOD.SalesOrderID


--Tabla generada en mi nueva base de datos llamada "datawarehouse"

--DROP TABLE[datawarehouse].dbo.Fact_Sales

CREATE TABLE [datawarehouse].dbo.Fact_Sales(
	SalesID BIGINT PRIMARY KEY
	,OrdeDate DATE
	,ORDER_DATEKEY INT
	,ShipDate DATE
	,SHIP_DATEKEY INT
	,DaysToShio INT
	,[Status] VARCHAR (255)
	,OrderFlag VARCHAR (255)
	,SalesOrdeNumber VARCHAR (255)
	,AccountNumber VARCHAR (255)
	,CustomerID INT
	,SalesPersonID INT
	,BillToAddressID INT
	,ShipToAddressID INT
	,ShipMethodID INT
	,CurrencyRateID INT
	,SubTotal NUMERIC(38,4)
	,TaxAmt NUMERIC(38,2)
	,Freight  NUMERIC(38,4)
	,TotalDue NUMERIC(38,4)
	,PercentageTAX NUMERIC(38,2)
	,PercentageFreight NUMERIC(38,2)
	,OrderQty INT
	,TerritoryID INT
	,ProductID INT
	,UnitPrice NUMERIC(38,4)
	,LineTotal NUMERIC(38,4)
	,PercentageOfOrder NUMERIC(38,2))

	--Inserccion de datos en la nueva tabla de hecchos, procedentes de AdventureWorks2017

	INSERT INTO [datawarehouse].dbo.Fact_Sales
	SELECT * 
	FROM [AdventureWorks2017].dbo.DW_Fact_Sales

	--
--Consulta de Prueba

	SELECT YEAR(OrdeDate) AS Año
		,COUNT( CustomerID) AS TotalClientes
		,SUM (TotalDue) as Total
	FROM [datawarehouse].dbo.Fact_Sales
	GROUP BY 
		YEAR(OrdeDate)	
	ORDER BY AÑO

--Creacion de tabla de Fechas DIM DATE

CREATE OR ALTER VIEW  DW_Dim_Dates
AS
SELECT DISTINCT OrderDate AS [Date]
	,CONCAT(YEAR (OrderDate)
		,IIF (LEN (MONTH (OrderDate))=1
			, CAST(cONCAT (0,MONTH (OrderDate)) AS VARCHAR)
			, CAST(MONTH (OrderDate) AS VARCHAR)) 
		,IIF (LEN (dAY (OrderDate))=1
			, CAST(cONCAT (0,DAY (OrderDate)) AS VARCHAR)
			, CAST(DAY (OrderDate) AS VARCHAR))
		)AS DATEKEY
	,YEAR (OrderDate) AS [YEAR]
	,MONTH (OrderDate) AS [MONTH]
	,DAY (OrderDate) AS [DAY]
	,DATENAME(MONTH, OrderDate) AS [MonthName]
	,DATENAME(WEEKDAY, OrderDate) AS [DayOfWeek]
	,DATEPART (DAYOFYEAR, OrderDate) AS [DayOfYear]
	,DATEPART (WEEK, OrderDate) AS [WeekOfYear]
	,DATEPART (QUARTER, OrderDate) AS [Quarter]
	,CASE
		WHEN DATEPART (QUARTER, OrderDate) IN (1,2) THEN 1
		WHEN DATEPART (QUARTER, OrderDate) IN (3,4) THEN 2
		ELSE NULL
	END AS SEMESTER
		,CAST (DATEADD (YEAR, -1,OrderDate)AS DATE) AS OrderDatePreviusYear
		,CAST (DATEADD (MONTH, -1,OrderDate)AS DATE) AS OrderDatePreviusMonth
		,CAST (DATEADD (QUARTER, -1,OrderDate)AS DATE) AS OrderDatePreviusQuarter
FROM Sales.SalesOrderHeader


--ORDER BY 1


SELECT* FROM DW_Dim_Dates

--DROP TABLE [datawarehouse].dbo.DW_Dim_Dates

CREATE TABLE [datawarehouse].dbo.Dim_Dates(
	[Date] Date
	,DATEKEY INT
	,[YEAR] INT
	, [MONTH] INT
	,[DAY] INT
	,[MonthName] VARCHAR(255)
	, [DayOfWeek]VARCHAR(255)
	,[DayOfYear]INT
	, [WeekOfYear]INT
	, [Quarter]INT
	,SEMESTER INT
	,OrderDatePreviusYear Date
	,OrderDatePreviusMonth Date
	, OrderDatePreviusQuarter Date 
	)



INSERT INTO [datawarehouse].dbo.Dim_Dates
SELECT * 
FROM [AdventureWorks2017].dbo.DW_Dim_Dates


SELECT* FROM[datawarehouse].dbo.Dim_Dates


--Creacion de tabla de DIMENSION SHIP_METHOD

CREATE OR ALTER VIEW VWShipMethod
AS
select ShipMethodID
	,NAME AS Shipment_Company
	,ShipBase
	,ShipRate
FROM Purchasing.ShipMethod

SELECT *FROM VWShipMethod

--DROP TABLE[datawarehouse].dbo.Dim_ShipMethod

CREATE TABLE [datawarehouse].dbo.Dim_ShipMethod(
	ShipMethod INT PRIMARY KEY
	,Shipment_Company VARCHAR(100)
	,ShipBase NUMERIC(4,2)
	,ShipRate NUMERIC(3,2)
	)

INSERT INTO [datawarehouse].dbo.Dim_ShipMethod
SELECT*FROM [AdventureWorks2017].dbo.VWShipMethod

SELECT*
fROM[datawarehouse].dbo.Dim_ShipMethod


--Creacion de tabla de DIMENSION PRODUCT

create or alter view DW_Dim_Product
as
SELECT PP.ProductID
	, PP.Name AS ProductName
	,PP.ProductNumber
	,IIF(PP.Color IS NULL, 'No Color',PP.Color) AS Color
	,PP.StandardCost
	,PP.ListPrice
	,PP.ListPrice - PP.StandardCost AS Profit
	,IIF(PP.Size IS NULL,'No Size',PP.Size)as Size
	,IIF (PP.SizeUnitMeasureCode IS NULL,'No Size Code',PP.SizeUnitMeasureCode) as SizeUnitMeasureCode
	,IIF(PP.[Weight]IS NULL,0,PP.[Weight]) as [Weight]
	,CASE
		WHEN  PP.ProductLine = 'R' THEN 'Road'
		WHEN  PP.ProductLine = 'M' THEN 'Mountain'
		WHEN  PP.ProductLine = 'R' THEN 'Touring'
		WHEN  PP.ProductLine = 'S' THEN 'Standart'
		WHEN  PP.ProductLine IS NULL THEN 'No Product Line'
	ELSE 'To Check'
	END As ProductLine
	,CASE
		WHEN  PP.Class = 'H' THEN 'High'
		WHEN  PP.Class = 'M' THEN 'Medium'
		WHEN  PP.Class = 'L' THEN 'Low'
		WHEN  PP.Class IS NULL THEN 'No Class'
	ELSE 'To Check'
	END As Class
	,CASE
		WHEN  PP.Style = 'W' THEN 'Women'
		WHEN  PP.Style = 'M' THEN 'Men'
		WHEN  PP.Style = 'U' THEN 'Universal'
		WHEN  PP.Style  IS NULL THEN 'No Style'
	ELSE 'To Check'
	END As Style
	,PP.SellStartDate
	,PP.SellEndDate
	,IIF(PP.SellEndDate IS NOT NULL, 'Inactive','Active') AS ProductStatus
	,ISNULL (PSC.Name, 'No Subcategory') AS Subcategory
	,ISNULL(PSC.Name,'No Category') AS Category
	,ISNULL(PM.Name,'No Model') AS Model
FROM Production.Product AS PP
LEFT JOIN Production.ProductSubcategory AS PSC
	ON PSC.ProductSubcategoryID = PP.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS PC
	ON PC.ProductCategoryID = PSC.ProductCategoryID
LEFT JOIN Production.ProductModel AS PM
	ON PP.ProductModelID = PM.ProductModelID


SELECT* FROM DW_Dim_Product

--DROP TABLE [datawarehouse].dbo.Dim_Product


CREATE TABLE[datawarehouse].dbo.Dim_Product(
	ProductID INT Primary KEY
	,ProductName VARCHAR (100)
	,ProductNumber VARCHAR (100)
	,Color VARCHAR (12)
	,StandardCost NUMERIC(38,4)
	,ListPrice NUMERIC(38,4)
	,Profit NUMERIC(38,4)
	,Size VARCHAR (100)
	,SizeUnitMeasureCode VARCHAR (20)
	,[Weight] NUMERIC(38,4)
	,ProductLine VARCHAR (100)
	,Class VARCHAR (100)
	,Style VARCHAR (100)
	,SellStartDate DATE
	,SellEndDate DATE
	,ProductStatus VARCHAR (100)
	,Subcategory VARCHAR (100)
	,Category VARCHAR (100)
	,Model VARCHAR (100)
	)



INSERT INTO [datawarehouse].dbo.Dim_Product
SELECT * FROM [AdventureWorks2017].dbo.DW_Dim_Product

SELECT * FROM [datawarehouse].dbo.Dim_Product

--Creacion de tabla de DIMENSION TERRITORIO

CREATE OR ALTER VIEW DW_Dim_Territory
AS
SELECT TerritoryID
	,Name AS Territory
	,CountryRegionCode
	,[Group]
	,CASE
		WHEN CountryRegionCode = 'US' THEN 37.09024
		WHEN CountryRegionCode = 'CA' THEN 37.2502200
		WHEN CountryRegionCode = 'FR' THEN 46.22763
		WHEN CountryRegionCode = 'DE' THEN 51.165691
		WHEN CountryRegionCode = 'AU' THEN -25.274398
		WHEN CountryRegionCode = 'GB' THEN 55.378051
	ELSE NULL END AS Latitud
	,CASE
		WHEN CountryRegionCode = 'US' THEN -95.712891
		WHEN CountryRegionCode = 'CA' THEN -119.7512600
		WHEN CountryRegionCode = 'FR' THEN 2.213749
		WHEN CountryRegionCode = 'DE' THEN 10.451526
		WHEN CountryRegionCode = 'AU' THEN 133.775136
		WHEN CountryRegionCode = 'GB' THEN -3.435973
	ELSE NULL END AS Longitud
FROM Sales.SalesTerritory

Select * From DW_Dim_Territory

--DROP TABLE [datawarehouse].dbo.Dim_Territory

CREATE TABLE [datawarehouse].dbo.Dim_Territory(
	TerritoryID INT Primary KEY
	,Territory Varchar(100)
	,CountryRegionCode Varchar(2)
	,[Group] Varchar(50)
	, Latitud Varchar(50)
	, Longitud Varchar(50)
	)

INSERT INTO [datawarehouse].dbo.Dim_Territory
SELECT* FROM [AdventureWorks2017].dbo.DW_Dim_Territory

select* from [datawarehouse].dbo.Dim_Territory


--Creacion de tabla de DIMENSION CLIENTES INDIVIDUOS


Create or alter View DW_Dim_Customer_IN 
as
SELECT CUS.CustomerID
	,ST.Name AS CustomerTerritory
	,ST.[Group] AS Region
	,CUS.AccountNumber
	,PP.FirstName+ ' '+PP.LastName as CustomerName
	, CAST (VPD.DateFirstPurchase AS DATE ) AS DateFirstPurchase
	,CAST (VPD.BirthDate AS DATE ) AS BirthDate
	,VPD.MaritalStatus
	,VPD.YearlyIncome
	,VPD.Gender
	,VPD.TotalChildren
	,VPD.NumberChildrenAtHome
	,VPD.Education
	,VPD.Occupation
	,VPD.HomeOwnerFlag
	,VPD.NumberCarsOwned
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON PP.BusinessEntityID = CUS.PersonID
INNER JOIN Sales.vPersonDemographics AS VPD
	ON VPD.BusinessEntityID = PP.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST
	ON CUS.TerritoryID = ST.TerritoryID
WHERE PP.PersonType = 'IN'

SELECT * FROM DW_Dim_Customer_IN

--drop table [datawarehouse].dbo.DW_Dim_Customer_IN 

CREATE TABLE [datawarehouse].dbo.Dim_Customer_IN (
	CustomerID INT PRIMARY KEY
	,CustomerTerritory VARCHAR(100)
	,Region VARCHAR(100)
	,AccountNumber VARCHAR(100)
	,CustomerName VARCHAR(100)
	,DateFirstPurchase DATE
	,BirthDate DATE
	,MaritalStatus CHAR(1)
	,YearlyIncome VARCHAR(100)
	,Gender CHAR(1)
	,TotalChildren INT
	,NumberChildrenAtHome INT
	,Education VARCHAR(100)
	,Occupation VARCHAR(100)
	,HomeOwnerFlag INT
	,NumberCarsOwned INT
	)

INSERT INTO [datawarehouse].dbo.Dim_Customer_IN
SELECT * FROM [AdventureWorks2017].dbo.DW_Dim_Customer_IN

SELECT * FROM [datawarehouse].dbo.Dim_Customer_IN

--Creacion de tabla de DIMENSION CLIENTES EMPRESA

CREATE OR ALTER VIEW DW_Dim_Customer_ST
AS
SELECT CUS.CustomerID
      ,ST.Name AS CustomerTerritory
	  ,ST.[Group] AS Region
	  ,CUS.AccountNumber
	  ,STO.Name AS StoreName
	  ,SP.FirstName + ' ' + SP.LastName AS SalesPerson
	  ,P.FirstName + ' ' + P.LastName AS Contact
	  ,EA.EmailAddress AS ContactEmail
	  ,Ph.PhoneNumber
FROM Sales.Customer AS CUS
INNER JOIN Sales.Store AS STO
	ON STO.BusinessEntityID = CUS.StoreID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = CUS.TerritoryID
INNER JOIN Person.Person AS SP
	ON SP.BusinessEntityID = STO.SalesPersonID
INNER JOIN Person.Person AS P
	ON P.BusinessEntityID = CUS.PersonID
INNER JOIN Person.EmailAddress AS EA
	ON EA.BusinessEntityID = P.BusinessEntityID
INNER JOIN Person.PersonPhone AS Ph
	ON PH.BusinessEntityID = P.BusinessEntityID


SELECT * FROM DW_Dim_Customer_ST


--drop table[datawarehouse].dbo.Dim_Customer_ST

CREATE TABLE [datawarehouse].dbo.Dim_Customer_ST (
	CustomerID INT PRIMARY KEY
	,CustomerTerritory VARCHAR(50)
	,Region VARCHAR(15)
	,AccountNumber VARCHAR(100)
	,StoreName VARCHAR(100)
	,SalesPerson VARCHAR(100)
	,Contact VARCHAR(100)
	,ContactEmail VARCHAR(100)
	,PhoneNumber VARCHAR(100)
	)

INSERT INTO [datawarehouse].dbo.Dim_Customer_ST
SELECT * FROM [AdventureWorks2017].dbo.DW_Dim_Customer_ST

SELECT * FROM [datawarehouse].dbo.Dim_Customer_ST