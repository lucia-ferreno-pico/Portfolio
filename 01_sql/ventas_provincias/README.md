# Caso transversal SQL — AdventureWorks2017

## Objetivo
Construir consultas SQL para extraer datasets desde una base OLTP (AdventureWorks2017) con fines analíticos:
- **Series temporales** de ventas (global y por región).
- **Dataset de clientes** con variables demográficas para regresión.
- **Dataset de clientes** con variable objetivo `BikePurchase` para clasificación.

## Entorno
- Base de datos: **AdventureWorks2017**
- Motor: SQL Server (T-SQL)

## Entregables
- [queries.sql](./queries.sql) script con las 3 partes del ejercicio.

## Parte I — Series temporales (2011–2014)
- Ventas globales por `OrderDate`.
- Ventas por región: **North America**, **Europe**, **Pacific**.
- Dataset final combinado usando `LEFT JOIN` por fecha para conservar días con ventas parciales por región.

## Parte II — Dataset clientes para regresión lineal
- Gasto acumulado (`SUM(SubTotal)`) por cliente.
- Variables demográficas desde `Sales.vPersonDemographics`.
- Filtro a clientes individuales: `PersonType = 'IN'`.
- Cálculo de edad: `DATEDIFF(YEAR, BirthDate, GETDATE())`.

## Parte III — Dataset clientes para clasificación (logística)
- Variable `BikePurchase`:
  - `1` si el cliente compró al menos una bicicleta (`ProductSubcategoryID IN (1,2,3)`).
  - `0` si no (tratado con `ISNULL`).
- Enriquecimiento del dataset de la Parte II mediante `LEFT JOIN` a una CTE.

## Tablas utilizadas
- `Sales.SalesOrderHeader`, `Sales.SalesOrderDetail`
- `Sales.SalesTerritory`
- `Sales.Customer`
- `Person.Person`
- `Sales.vPersonDemographics`
- `Production.Product`


