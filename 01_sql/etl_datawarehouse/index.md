---
layout: default
title: ETL en SQL - creación de datawarehouse
permalink: /01_sql/etl_datawarehouse/
---

<div class="section">
  <div class="section-title">
    <h2>ETL en SQL - creación de datawarehouse</h2>
  </div>

  <p class="subtitle" style="max-width: 70ch;">

    <span>SQL Server · ETL · Data Warehouse · Modelo estrella</span>
      
    Construcción de un <b>datawarehouse</b> a partir de AdventureWorks: creación de <b>dimensiones</b>,
    <b>tabla de hechos</b>, <b>vistas</b> para carga y un <b>modelo estrella</b> listo para explotación analítica.
  </p>
</div>

<div class="section">
  <h3>Objetivo</h3>
  <ul>
    <li>Transformar y estructurar datos operacionales (OLTP) en un esquema analítico (DW).</li>
    <li>Generar <b>vistas en origen</b> y <b>carga en destino</b> para simplificar consumo y análisis.</li>
    <li>Incorporar métricas derivadas (p. ej., tiempos de envío) y claves de fechas.</li>
  </ul>
</div>

<div class="section">
  <h3>Enfoque (ETL)</h3>

  <ol>
    <li>
      <b>Vistas en origen (AdventureWorks2017)</b> para preparar los datos:
      <ul>
        <li><code>DW_Fact_Sales</code></li>
        <li><code>DW_Dim_Dates</code></li>
        <li><code>DW_Dim_Product</code></li>
        <li><code>DW_Dim_ShipMethod</code></li>
        <li><code>DW_Dim_Territory</code></li>
        <li><code>DW_Dim_Customer_IN</code> (clientes individuales)</li>
        <li><code>DW_Dim_Customer_ST</code> (clientes tienda)</li>
      </ul>
    </li>

    <li>
      <b>Tablas en destino (datawarehouse)</b>:
      <ul>
        <li><code>Fact_Sales</code></li>
        <li><code>Dim_Dates</code>, <code>Dim_Product</code>, <code>Dim_ShipMethod</code>, <code>Dim_Territory</code>, <code>Dim_Customer_IN</code>, <code>Dim_Customer_ST</code></li>
      </ul>
    </li>

    <li>
      <b>Carga</b>: inserción en tablas del DW desde las vistas del origen.
    </li>
  </ol>
</div>

<div class="section">
  <h3>Extracción (vistas en SQL)</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Ejemplos de vistas en el origen para extraer/transformar datos antes de cargarlos en el datawarehouse.
  </p>

  <div class="grid">
    <div class="card">
      <p class="kicker">Vista</p>
      <p class="title">DW_Dim_Dates</p>
      <img src="{{ '/01_sql/etl_datawarehouse/vista_dates.png' | relative_url }}"
           alt="Vista DW_Dim_Dates"
           style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
    </div>

    <div class="card">
      <p class="kicker">Vista</p>
      <p class="title">DW_Fact_Sales</p>
      <img src="{{ '/01_sql/etl_datawarehouse/vista.png' | relative_url }}"
           alt="Vista DW_Fact_Sales"
           style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
    </div>
  </div>
</div>

<div class="section">
  <h3>Tablas creadas en el datawarehouse</h3>
  <img src="{{ '/01_sql/etl_datawarehouse/tablas.png' | relative_url }}"
       alt="Tablas del datawarehouse"
       style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <h3>Modelo estrella</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Esquema final con una tabla de hechos central y dimensiones conectadas para análisis de ventas.
  </p>

  <img src="{{ '/01_sql/etl_datawarehouse/modelo_estrella.png' | relative_url }}"
       alt="Modelo estrella del datawarehouse"
       style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <h3>Validación</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Consulta de prueba para verificar cargas y agregaciones básicas (clientes y total por año).
  </p>

  <img src="{{ '/01_sql/etl_datawarehouse/consulta.png' | relative_url }}"
       alt="Consulta de prueba con resultados"
       style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <div class="cta">
    <a class="btn btn--primary"
   href="https://github.com/lucia-ferreno-pico/Portfolio/blob/main/01_sql/etl_datawarehouse/SQLdatawarehouse_ETL.sql"
   target="_blank" rel="noopener">Ver código</a>


    <a class="btn"
       href="{{ '/01_sql/etl_datawarehouse/SQLdatawarehouse_ETL.sql' | relative_url }}"
       target="_blank" rel="noopener">Abrir script SQL</a>
  </div>
</div>
