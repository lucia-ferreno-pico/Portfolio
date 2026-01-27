---
layout: default
title: Temporalidad y predicción de ventas (R)
permalink: /03_r/temporalidad_ventas/
---

<div class="section">
  <div class="section-title">
    <h2>Temporalidad y predicción de ventas</h2>
    <span>R · Series temporales · ARIMA · ETS</span>
  </div>

  <p class="subtitle" style="max-width: 70ch;">
    Proyecto de analítica temporal sobre ventas: integración y preparación de datos, exploración por provincia y modelado predictivo con <b>ARIMA</b> y <b>ETS</b> (frecuencia diaria y semanal).
  </p>

  <div class="cta">
    <a class="btn btn--primary"
       href="https://github.com/lucia-ferreno-pico/Portfolio/tree/main/03_r/temporalidad_ventas"
       target="_blank" rel="noopener">Ver código</a>

    <a class="btn"
       href="{{ '/03_r/temporalidad_ventas/temporalidad_ventas.R' | relative_url }}"
       target="_blank" rel="noopener">Abrir script R</a>
  </div>
</div>

<div class="section">
  <h3>Objetivo</h3>
  <ul>
    <li>Entender patrones temporales de ventas (diario/semanal) y diferencias por <b>provincia</b>.</li>
    <li>Construir una base reproducible para análisis: agregaciones, normalización y variables temporales.</li>
    <li>Probar forecasting con <b>ARIMA</b> y <b>ETS</b> en provincias con mayor volumen y en el total país.</li>
  </ul>
</div>

<div class="section">
  <h3>Qué se hizo</h3>
  <ul>
    <li><b>Preparación de datos</b>: limpieza, comprobación de duplicados y consistencia.</li>
    <li><b>Agregación</b> de ventas por provincia y día, y análisis exploratorio con visualizaciones.</li>
    <li><b>Feature engineering</b>: construcción de series temporales y comparación diaria vs. semanal.</li>
    <li><b>Modelado</b>: forecasting con <b>auto.arima()</b> y <b>ets()</b> para Madrid, Barcelona, Valencia y Alicante, además de total país.</li>
    <li><b>Evaluación</b> con métricas de precisión (ej. MAPE) y comentarios sobre limitaciones por ruido/estacionalidad.</li>
  </ul>
</div>

<div class="section">
  <h3>Resultados y aprendizajes</h3>
  <p class="subtitle" style="max-width: 70ch;">
    Las series diarias presentan <b>alta variabilidad</b> y patrones estacionales difíciles de capturar con un histórico corto, por lo que se comparó también la agregación semanal.
    Esto permitió evaluar mejor la señal y documentar dónde los modelos aportan valor y dónde conviene reforzar con más histórico o variables exógenas.
  </p>
</div>

<div class="section">
  <h3>Stack</h3>
  <ul>
    <li><b>R</b>: tidyverse, lubridate</li>
    <li><b>Forecasting</b>: forecast (ARIMA, ETS), series temporales diarias y semanales</li>
    <li><b>Visualización</b>: ggplot2</li>
  </ul>
</div>

<div class="section">
  <h3>Código</h3>
  <ul>
    <li><b>Repositorio</b>: <a href="https://github.com/lucia-ferreno-pico/Portfolio/tree/main/03_r/temporalidad_ventas" target="_blank" rel="noopener">Ver carpeta del proyecto</a></li>
    <li><b>Script</b>: <a href="{{ '/03_r/temporalidad_ventas/temporalidad_ventas.R' | relative_url }}" target="_blank" rel="noopener">Abrir temporalidad_ventas.R</a></li>
  </ul>
</div>
