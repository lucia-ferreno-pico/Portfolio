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
  <h3>Qué hice</h3>
  <ul>
    <li><b>ETL con vistas</b> para preparar y migrar datos a la base de destino.</li>
    <li><b>Dimensiones</b>: fechas, producto, cliente, territorio y método de envío.</li>
    <li><b>Hechos</b>: Fact_Sales incluyendo claves (incl. <i>TerritoryID</i>).</li>
    <li><b>Modelo estrella</b> para reporting (Power BI / herramientas BI).</li>
  </ul>
</div>

<div class="section">
  <h3>Modelo estrella</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Esquema final con una tabla de hechos central y dimensiones conectadas para análisis de ventas.
  </p>

  <img src="{{ '/01_sql/etl_datawarehouse/img/modelo_estrella.png' | relative_url }}" alt="Modelo estrella del datawarehouse" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <h3>Implementación (SQL)</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Ejemplos de creación de vistas y estructuras. El script completo está en el repositorio.
  </p>

  <div class="grid">
    <div class="card">
      <p class="kicker">Vista</p>
      <p class="title">DW_Dim_Dates</p>
      <img src="{{ '/01_sql/etl_datawarehouse/img/vista.png' }}" alt="Vista Dim Dates" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
    </div>

    <div class="card">
      <p class="kicker">Vista</p>
      <p class="title">DW_Fact_Sales</p>
      <img src="{{ '/01_sql/etl_datawarehouse/img/vista.png'}}" alt="Vista Fact Sales" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
    </div>
  </div>
</div>

<div class="section">
  <h3>Validación</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Consulta de prueba para verificar cargas y agregaciones básicas (clientes y total por año).
  </p>

  <img src="{{ '/01_sql/etl_datawarehouse/img/consulta.png'}}" alt="Consulta de prueba con resultados" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <h3>Tablas creadas</h3>
  <img src="{{ '/01_sql/etl_datawarehouse/img/tablas.png'}}" alt="Tablas del datawarehouse" style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <a class="btn btn--primary" href="https://github.com/lucia-ferreno-pico/Portfolio/tree/main/01_sql/etl_datawarehouse" target="_blank" rel="noopener">Ver código</a>
</div>
