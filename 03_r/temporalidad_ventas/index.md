---
layout: default
title: Temporalidad y predicción de ventas
permalink: /03_r/temporalidad_prediccion_ventas/
---

<div class="section">
  <div class="section-title">
    <h2>Temporalidad y predicción de ventas</h2>
  </div>

  <p class="subtitle" style="max-width: 70ch;">
    <span>R · Series temporales · Visualización · ARIMA . ETS</span>
  </p>

  <p class="subtitle" style="max-width: 70ch;">
    Análisis de la <b>temporalidad de las ventas</b> a nivel provincial y nacional,
    estudiando patrones por <b>día de la semana</b>, <b>mes</b> y <b>tipo de día(laborable, fin de semana o  festivo)</b>,
    y desarrollo de modelos de <b>predicción temporal</b> mediante <b>ARIMA y ETS</b>.
  </p>
</div>

<div class="section">
  <h3>Objetivo</h3>
  <ul>
    <li>Analizar la evolución temporal de las ventas normalizadas por provincia.</li>
    <li>Detectar patrones estacionales y diferencias por día de la semana y mes.</li>
    <li>Evaluar la viabilidad de modelos predictivos sobre series de ventas.</li>
  </ul>
</div>

<div class="section">
  <h3>Análisis de temporalidad</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Visualización de la evolución diaria de ventas normalizadas por provincia,
    permitiendo comparar tendencias y estacionalidad entre territorios.
  </p>

  <img src="{{ '/03_r/temporalidad_prediccion_ventas/temporalidad_ventas.png' | relative_url }}"
       alt="Temporalidad de ventas por provincia"
       style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <h3>Patrones por calendario</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Comparación de ventas por <b>día de la semana</b> y análisis de la
    <b>media diaria por mes</b> para detectar ciclos y comportamiento estacional.
  </p>

  <img src="{{ '/03_r/temporalidad_prediccion_ventas/dia_semana_mes.png' | relative_url }}"
       alt="Ventas por día de la semana y media mensual"
       style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <h3>Predicción temporal</h3>

  <p class="subtitle" style="max-width: 70ch;">
    Construcción de modelos <b>ARIMA</b> sobre series temporales diarias y semanales,
    evaluando su precisión y limitaciones en entornos con alta variabilidad.
  </p>

  <img src="{{ '/03_r/temporalidad_prediccion_ventas/arima_madrid.png' | relative_url }}"
       alt="Predicción ARIMA de ventas en Madrid"
       style="width:100%; border:1px solid rgba(17,17,17,.14); background:#fff;">
</div>

<div class="section">
  <div class="cta">
    <a class="btn btn--primary"
       href="https://github.com/lucia-ferreno-pico/Portfolio/tree/main/03_r/temporalidad_ventas"
       target="_blank" rel="noopener">
       Ver código
    </a>

    <a class="btn"
       href="{{ '/03_r/temporalidad_ventas/temporalidad_ventas.R' | relative_url }}"
       target="_blank" rel="noopener">
       Abrir script R
    </a>
  </div>
</div>
