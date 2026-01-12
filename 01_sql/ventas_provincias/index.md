---
layout: default
title: Consultas analíticas de ventas (SQL | AdventureWorks2017)
---

# Consultas analíticas de ventas (SQL | AdventureWorks2017)

## Qué resuelve (en lenguaje de negocio)
Como analista de BI, transformo datos de una base **OLTP (AdventureWorks2017)** en **datasets analíticos listos para reporting y modelado**:
1) serie temporal de ventas (total y por región),  
2) dataset de clientes para regresión,  
3) dataset de clientes para clasificación con variable objetivo `BikePurchase`.

**Script completo:** [Ver queries.sql](./queries.sql)

---

## Entorno
- **SQL Server (T-SQL)**
- Base de datos: **AdventureWorks2017**

---

## Entregable 1 — Series temporales de ventas (2011–2014)
**Objetivo:** ventas diarias globales y por región (North America, Europe, Pacific) y dataset final combinado por fecha.

**Decisión clave:** al combinar regiones se usa `LEFT JOIN` por fecha para **no perder días** donde una región no tenga ventas (serie completa y comparable). 

### Evidencia (resultado)
![Entregable 1 — Serie por fecha y región](../../assets/img/sql/ventas_provincias/parte1_series.png)

### Snippet clave (tu SQL)
```sql
-- Parte I (fragmento): dataset final por fecha + regiones (temp tables + LEFT JOIN)
-- (Extraído de tu script ACT 3 grupo 6.sql)
SELECT SOH.OrderDate,
       SUM(SOD.LineTotal) AS SALES,
       USA.SalesUSA,
       EU.SalesEU,
       PAC.SalesPAc
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN #tablatemporalUSA AS USA
    ON USA.OrderDate = SOH.OrderDate
LEFT JOIN #tablatemporaleu AS EU
    ON EU.OrderDate = SOH.OrderDate
LEFT JOIN #tablatemporalpac AS PAC
    ON PAC.OrderDate = SOH.OrderDate
GROUP BY SOH.OrderDate, USA.SalesUSA, EU.SalesEU, PAC.SalesPAc
ORDER BY SOH.OrderDate;

