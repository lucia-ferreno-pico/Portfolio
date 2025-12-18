# Dashboard de Ventas — Power BI (Análisis interactivo)

## Objetivo
Responder a preguntas de negocio clave:
**¿qué se vende?, ¿dónde se vende?, ¿quién lo vende? y ¿cuándo se vende?**

El dashboard está diseñado para análisis interactivo de ventas con navegación a detalle y tooltips enriquecidos.

## Estructura del informe (4 páginas)
1. **Portada**
2. **Informe de ventas (principal)**
3. **Detalle de ventas** (acceso desde “Obtener detalles”)
4. **Tooltip del mapa** (dinámico por CCAA / provincia)

## Modelo de datos
- **Modelo estrella** (fact + dimensiones).
- **Tabla calendario** para inteligencia temporal y selección de periodo.
- **Parámetros** para controlar la escala/nivel de detalle de visualización.

## Interacción y filtros
En el **menú de filtros** se permite:
- Selección de **rango de fechas**
- Selección de **escala temporal** (día / mes / trimestre / año)
- Filtros por **territorio** (CCAA / provincia), **punto de venta** y **producto**

## KPIs principales
- **Total unidades vendidas**
- **% del total**
Ambos indicadores cambian dinámicamente según filtros y selección en gráficos.

## Análisis de ventas (página principal)
- **Evolución temporal de unidades vendidas** (día/mes/trimestre/año).
- Desde una barra del gráfico se puede **Obtener detalles** y navegar a:
  - **Página Detalle Ventas**, con desagregación por productos/ventas del periodo.
- Botón **Volver** para retornar a la página principal.

## Visuales adicionales
- **Ventas por día de la semana** (líneas) con opción de obtener detalle.
- **Mapa geográfico** de distribución de ventas:
  - Selector por **CCAA** o **provincia**
  - **Tooltip dinámico** al pasar el ratón con:
    - Unidades vendidas del territorio
    - **Top productos** y cantidad vendida (gráfico de barras)

---

## Capturas

### Informe de ventas (vista general)
![](./screenshots/01_informe_ventas.png)

### Menú de filtros
![](./screenshots/02_menu_filtros.png)

### Tooltip del mapa (CCAA/Provincia + top productos)
![](./screenshots/03_tooltip_mapa.png)

### Ventas por día de la semana
![](./screenshots/04_ventas_dia_semana.png)

### Página detalle de ventas
![](./screenshots/05_detalle_ventas.png)

### Drillthrough (Obtener detalles)
![](./screenshots/06_drillthrough.png)

### Pdf
- [Anexo dashboard (PDF)](./screenshots/DASHBOARD%20VENTAS.pdf)

## Cómo usar el dashboard (rápido)
1. Selecciona **periodo** (y la escala temporal: día/mes/trimestre/año).
2. Filtra por **CCAA/provincia**, **punto de venta** y/o **producto**.
3. Consulta KPIs y visuales.
4. En el gráfico temporal usa **Obtener detalles** para ir a **Detalle Ventas** y vuelve con **Volver**.
5. En el mapa, pasa el ratón por el territorio para ver el **tooltip** con top productos.

## Notas
- Proyecto académico (Master BI). Datos: `Product`, `SalesDay`, `puntos_venta_enriquecido2`.
- El `.pbix` se comparte solo si no contiene información sensible (alternativa: PDF + capturas).
