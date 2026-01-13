# AdventureWorks — Visión 360 y segmentación de clientes (CRM)

Proyecto de **análisis 360 de clientes** y **segmentación (clustering)** usando el dataset público **AdventureWorks**, con el objetivo de obtener segmentos accionables para **CRM/Marketing**.

## Archivos
- `Actividad_CRM.ipynb`: notebook principal (EDA → preparación → K-Means → evaluación → conclusiones).
- `dataset_AW.csv`: dataset público AdventureWorks utilizado.
- `README.md`: descripción del proyecto.

## Metodología
1. **Entendimiento del dato (EDA)**: revisión de variables, calidad del dato y análisis descriptivo.
2. **Preparación**: selección de variables, transformaciones y estandarización cuando procede.
3. **Segmentación (K-Means)**: selección de K con **Elbow** y validación con **Silhouette**.
4. **Evaluación e interpretación**: perfilado de clusters y recomendaciones de negocio por segmento.

## Ejecución
- Abrir `Actividad_CRM.ipynb` en Colab o en Jupyter y ejecutar las celdas en orden.

![Outliers](imgs/01_outliers.png)
![Elbow](imgs/02_elbow.png)
![Silhouette](imgs/03_silhouette.png)
