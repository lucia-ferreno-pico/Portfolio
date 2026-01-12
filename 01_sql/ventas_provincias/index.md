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

## 1 — Series temporales de ventas (2011–2014)
**Objetivo:** ventas diarias globales y por región (North America, Europe, Pacific) y dataset final combinado por fecha.

**Decisión clave:** al combinar regiones se usa `LEFT JOIN` por fecha para **no perder días** donde una región no tenga ventas (serie completa y comparable). 

### Evidencia (resultado)
![Entregable 1 — Serie por fecha y región](../../assets/img/sql/ventas_provincias/parte1_series.png)

## 2 — Dataset de clientes para regresión
**Objetivo:** dataset por cliente con gasto acumulado y variables demográficas (edad, ingresos, educación, etc.).

### Evidencia (resultado)
![Entregable 2 — Dataset regresión](../../assets/img/sql/ventas_provincias/parte2_regresion.png)

## 3 — Dataset de clientes para clasificación (BikePurchase)
**Objetivo:** crear la variable objetivo BikePurchase (1 si compró bicicleta, 0 si no).

### Evidencia (resultado)
![Entregable 3 — Dataset regresión](../../assets/img/sql/ventas_provincias/parte3_clasificacion.png)


