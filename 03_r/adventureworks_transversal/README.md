# Proyecto transversal (R) — AdventureWorks: análisis exploratorio y preguntas de negocio

## Contexto
Análisis exploratorio sobre un dataset extraído de AdventureWorks (`dataset_AW.xlsx`) para obtener una visión general del negocio.

## Dataset
Archivo: `dataset_AW.xlsx`

Pestañas:
- **ST Ventas Totales**: ventas totales diarias (~3 años)
- **Var Discreta Adq Bicicleta**: 18.484 clientes (características, gasto total, etc.)
- **Datos sin etiquetas (No Supervisado)**: información de productos

## Preguntas de negocio y resultados

### 1) ¿Dónde se concentra la facturación? (Top 10 países)
Se agrupa por `Country` y se suma `TotalAmount` para obtener la facturación total por país.
**Hallazgo:** Estados Unidos lidera claramente la facturación; Australia también destaca. En Europa, los países más relevantes son UK, Alemania y Francia.

### 2) Tendencia de ventas
Se agrupan ventas por mes a partir de `OrderDate` y se calcula la suma de `Sales`.
**Hallazgo:** tendencia general **creciente**, con **oscilaciones estacionales** y picos que pueden asociarse a campañas o periodos de alta demanda.

### 3) Política de precios: precio medio por producto y efecto del color
Se calcula el precio medio usando `Name` y `UnitPrice`. Se analiza también el efecto de `Color` (incluye contraste estadístico con ANOVA).
**Hallazgos:**
- Los productos con mayor precio medio son **bicicletas** y **frames**.
- Existen **diferencias significativas** de precio por color: rojo, plateado y amarillo presentan mayores precios medios en el dataset.
- El análisis por producto+color muestra combinaciones de alto valor (p.ej. variantes concretas por color).

### 4) Perfil de compradores de bicicletas (BikePurchase = 1)
Se analiza el perfil de compradores y se compara con no compradores.
**Hallazgos principales:**
- Comprador medio: **~57 años**, ingresos estimados **~50k/año**, predominio de estudios universitarios (completos/parciales), ligera mayoría casados.
- Se observa una **mayor proporción de mujeres** entre compradores, mientras que en no compradores destaca una mayor proporción de hombres.
- Compradores: ingresos ligeramente superiores y edad algo menor que no compradores.

### 5) Conclusiones iniciales
1. Enfocar esfuerzos comerciales/logísticos en **EEUU y Australia** (y principales mercados europeos).
2. Considerar la **estacionalidad** para aprovisionamiento, inventario y campañas de marketing.
3. Diferencias de precio claras por tipo de producto y por **color**; recomendable analizar si el color también impacta en volumen/ventas.
4. Segmentación: comprador tipo con perfil definido (edad, ingresos, educación, género) para orientar campañas y fidelización.

## Entregables
- [Script en R](./analysis.R)
- (Opcional) Informe/PDF o capturas de gráficos (si se añaden posteriormente)

## Stack
`readxl`, `dplyr`, `ggplot2`, `patchwork`, `lubridate`
