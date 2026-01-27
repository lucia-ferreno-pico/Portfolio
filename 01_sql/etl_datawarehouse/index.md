---
layout: default
title: ETL en SQL - creación de datawarehouse
permalink: /01_sql/etl_datawarehouse/
---

<div class="section">
  <div class="section-title">
    <h2>ETL en SQL - creación de datawarehouse</h2>
    <span>SQL Server · ETL · Data Warehouse</span>
  </div>

  <p class="subtitle" style="max-width: 70ch;">
    Construcción de un <b>datawarehouse</b> a partir de AdventureWorks: creación de <b>dimensiones</b>, <b>tabla de hechos</b>,
    <b>vistas</b> para carga y un <b>modelo estrella</b> listo para explotación analítica.
  </p>
</div>

<div class="section">
  <div class="section">
  <h3>Objetivo</h3>
    
- Transformar y estructurar datos operacionales (OLTP) en un esquema analítico (DW).
  
- Generar **vistas en origen** y **carga en destino** para simplificar consumo y análisis.
  
- Incorporar métricas derivadas (porcentajes, tiempos de envío, etc.) y claves de fechas.

<div class="section">
  <h3>Enfoque (ETL)</h3>
  
1. **Vistas en origen (AdventureWorks2017)** para preparar datos:
   - `DW_Fact_Sales`
   - `DW_Dim_Dates`
   - `DW_Dim_Product`
   - `DW_Dim_ShipMethod`
   - `DW_Dim_Territory`
   - `DW_Dim_Customer_IN` (clientes individuales)
   - `DW_Dim_Customer_ST` (clientes tienda)

2. **Tablas en destino (datawarehouse)**:
   - `Fact_Sales`
   - `Dim_Dates`, `Dim_Product`, `Dim_ShipMethod`, `Dim_Territory`, `Dim_Customer_IN`, `Dim_Customer_ST`

3. **Carga**: inserción en tablas del DW desde las vistas del origen.

</div>



<div class="section">
  <h3>Extracción (SQL)</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Creación de vistas de Adventureworks para la obtencion de los datos y su posterior insercion en las tablas creadas. El script completo está en el repositorio.
  </p>

  <div class="grid">
    <div class="card">
      <p class="kicker">Vista</p>
      <p class="title">DW_Dim_Dates</p>
      <img src="{{ '/01_sql/etl_datawarehouse/vista_dates.png'| relative_url  }}" alt="Vista Dim Dates" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
    </div>

    <div class="card">
      <p class="kicker">Vista</p>
      <p class="title">DW_Fact_Sales</p>
      <img src="{{ '/01_sql/etl_datawarehouse/vista.png'| relative_url }}" alt="Vista Fact Sales" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
    </div>
  </div>
</div>

<div class="section">
  <h3>Tablas creadas</h3>
  <img src="{{ '/01_sql/etl_datawarehouse/tablas.png'| relative_url }}" alt="Tablas del datawarehouse" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <h3>Modelo estrella</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Esquema final con una tabla de hechos central y dimensiones conectadas para análisis de ventas.
  </p>

  <img src="{{ '/01_sql/etl_datawarehouse/modelo_estrella.png' | relative_url }}" alt="Modelo estrella del datawarehouse" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <h3>Validación</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Consulta de prueba para verificar cargas y agregaciones básicas (clientes y total por año).
  </p>

  <img src="{{ '/01_sql/etl_datawarehouse/consulta.png'| relative_url }}" alt="Consulta de prueba con resultados" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>


<div class="section">
  <a class="btn btn--primary" href="https://github.com/lucia-ferreno-pico/Portfolio/tree/main/01_sql/etl_datawarehouse" target="_blank" rel="noopener">Ver código</a>
</div>
## Código
- **Script SQL completo**: [Abrir SQLdatawarehouse_ETL.sql]({{ "/01_sql/etl_datawarehouse/SQLdatawarehouse_ETL.sql" | relative_url }})
