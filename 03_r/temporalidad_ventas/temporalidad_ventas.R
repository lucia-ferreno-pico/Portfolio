#leemos los tres datasets

library(readxl)
Product <- read_excel("C:/unir/MASTER/2 CUATRIMESTRE/TFM/empresa/Data set Red Proyectum - Altadis/nuevos dataset creados/Product.xlsx")
View(Product)

library(readxl)
puntos_venta_enriquecido2_sinNA <- read_excel("C:/unir/MASTER/2 CUATRIMESTRE/TFM/empresa/Data set Red Proyectum - Altadis/nuevos dataset creados/puntos_venta_enriquecido2_sinNA.xlsx")
View(puntos_venta_enriquecido2_sinNA)

library(readr)

SalesDay <- read_delim("C:/unir/MASTER/2 CUATRIMESTRE/TFM/empresa/Data set Red Proyectum - Altadis/SalesDay.csv",delim = ";")
View(SalesDay)

library(dplyr)
library(ggplot2)
library(forecast)
library(caTools)
library(rpart)
library(rpart.plot)
library(caret)
library(tidyverse)
library(patchwork)
library(caret)
library(cluster)
library(tidyr)
library(ConvergenceClubs)
library(lubridate)
library(rlang)
#primero se comprueva si hay duplicados en product

any(duplicated(Product$Product_Code))



#como si que hay, se mira cuales.

Product$Product_Code[duplicated(Product$Product_Code)]



#solo hay un producto duplicado que es Natu122 con lo que se elimina se ha duplicado por el formato es ATA y ASL
#se elimina y se crea un nuevo data set sin esa duplicidad quedandose con el primero que aparece que es ATA ya que Product_Code 
#debe ser clave primaria UNICA

Product_sin_duplicados <- Product %>%
  distinct(Product_Code, .keep_all = TRUE)



#ahora si podemos unir SalesDay con Product (por Product_Code)

ventas_productos <- SalesDay %>%
  left_join(Product_sin_duplicados, by = "Product_Code")

#se mantienen el numero de observaciones tras el join (2878182)

#Ahora se une con puntos_venta_enriquecido2_sinNA (por Affiliated_Code)
ventas_completo_2 <- ventas_productos %>%
  left_join(puntos_venta_enriquecido2_sinNA, by = "Affiliated_Code")

#se siguen mantiendo el numero de observaciones tras el join (2878182)

#ahora tenemos un dataset de 2878182obs y 14 variables se extrae como excel y
#se procede a su limpieza

#creamos un excell llamado para el archivo

library(readr)

write_csv(ventas_completo_2, "C:/unir/MASTER/2 CUATRIMESTRE/TFM/empresa/Data set Red Proyectum - Altadis/ventas_completo_2.csv")


#ahora procedemos a trabajar con nuestro nuevo dataset ventas_completo 


ventas_completo_2

dim(ventas_completo_2)
str(ventas_completo_2)
summary(ventas_completo_2)
unique(ventas_completo_2$Management_Cluster)
unique(ventas_completo_2$Product_Code)
unique(ventas_completo_2$Location)
unique(ventas_completo_2$SIZE)
unique(ventas_completo_2$Format)
unique(ventas_completo_2$Engage)
unique(ventas_completo_2$provincia)


is.na(ventas_completo_2)
which(is.na(ventas_completo_2))
colSums(is.na(ventas_completo_2))
colSums(is.na(puntos_venta_enriquecido2_sinNA))


#No hay celdas vacias

#se le dice a r que la variable Sales_DAY es fecha
ventas_completo_2<-ventas_completo_2%>%
            mutate(Sales_DAY = as.Date(as.character(Sales_DAY), 
                                     format = "%Y%m%d"))
#Se comprueva y esta como fecha
str(ventas_completo_2)

#Se realiza una representación gráfica que permita conocer el comportamiento 
#de la serie temporal de las ventas en cada una de las provincias. 


#Se hacen los graficos y se observa que no los puedo comparar

ventas_completo_2 %>%
  ggplot(aes(x=Sales_DAY,y =Sales_Uds,color="Ventas"))+
  geom_line()+
  facet_wrap(~provincia)+
  scale_color_manual(values = c("#0098cd"))+
  labs(title = "Evolución diaria de ventas por provincia",
                            x = "Fecha", y = "Ventas diarias") +
  theme_minimal()

#Se escala para comparar (normalizacion 0-1) y se quitan na's:

#se calcula una columna de ventas totales en cada provincia

ventas_completo_2_escaladas <- ventas_completo_2 %>%
  drop_na()%>%
  group_by(provincia,Product_Code)%>%
  mutate (Ventas_Totales=sum(Sales_Uds))

#columna de cociente 0-1

ventas_completo_2_escaladas$Sales_Uds_1 <- ventas_completo_2_escaladas$Sales_Uds/ventas_completo_2_escaladas$Ventas_Totales

# table para saber si todas las provincias estan presentes todas las veces

table(ventas_completo_2$provincia)

#como se puede ver no todas las provincias tienen ventas todos los días con lo 
#que para Visualizar el comportamiento diario de las ventas (normalizadas entre 0-1) 
#para cada provincia, y analizar tendencias o estacionalidad hay que crear un nuevo 
#dataframe donde aparaezcan todos los dias aunq no haya ventas.

#hay que crear una tabla de fechas completas incluso para los días sin ventas y así evitar 
#saltos de linea en el grafico
  
# Hacemos los vectores de fecha minima y maximas del dataset
fecha_min <- min(ventas_completo_2_escaladas$Sales_DAY, na.rm = TRUE)



fecha_max <- max(ventas_completo_2_escaladas$Sales_DAY, na.rm = TRUE)



# Crear secuencia de fechas para cada provincia, primero extraemos un vector donde 
#ponga cada provincia distinta, vemos que son 48 y generamos todas las combinaciones posibles entre ambas (provincias y fechas)
provincias <- unique(ventas_completo_2_escaladas$provincia)

fechas_provincias<-expand.grid(
  Sales_DAY = seq.Date(from = fecha_min, to = fecha_max, by = "day"),
  provincia = provincias)

#Se unen las tablas ventas_completo_2_escaladas y el nuevo dataframe de fechas_provincias(combinaciones posibles entre provincias y fechas)
#y además se rellenan los días sin ventas poniendo CERO ventas y Así se mantienen todos los días (aunque no haya ventas en todos):
#se observa que se pasa de 2878182 obs a 2878191 obs
  

ventas_diarias_completas<-fechas_provincias %>%
  left_join(ventas_completo_2_escaladas, by = c("Sales_DAY", "provincia")) %>%
  replace_na(list(Sales_Uds = 0, Sales_Uds_1 = 0))


#Ahora se resumen las ventas escaladas diarias por provincia


ventas_provincia_dia<- ventas_diarias_completas %>%
  group_by(provincia, Sales_DAY) %>%
  summarise(Ventas_Totales_Diarias = sum(Sales_Uds_1, na.rm = TRUE), .groups = "drop")

#hago un table para saber si todas las provincias estan presentes todas las veces y se observa que si (210)

table(ventas_provincia_dia$provincia)

#4º)Visualizar la serie temporal



g0<-ggplot(ventas_provincia_dia, aes(x = Sales_DAY, y = Ventas_Totales_Diarias)) +
  geom_line(color = "#0098cd") +
  facet_wrap(~ provincia, scales = "free_y") +
  labs(title = "Evolución diaria de ventas normalizadas por provincia",
       x = "Fecha", y = "Ventas normalizadas (0-1)") +
  theme_minimal()

g0

g1<-ggplot(ventas_provincia_dia, aes(x = Sales_DAY, y = Ventas_Totales_Diarias)) +
  geom_line(color = "#0098cd") +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  facet_wrap(~provincia, scales = "free_y") +
  labs(title = "Tendencia y estacionalidad por provincia", x = "Fecha", y = "Ventas normalizadas") +
  theme_minimal()

g1

g0+g1

#Los graficos ya son comparables y hemos obtenido el comportamiento diario por provincia de las ventas 
#(aunque no haya ventas todos los días, se visualizarán como cero).


#ahora se estudian las ventas por día de la semana y mes (normalizado para que tengamos tambien la vision de octubre)

ventas_por_dia_de_semana<-ventas_completo_2 %>%
  mutate(dia_semana = wday(Sales_DAY, label = TRUE)) %>%
  group_by(dia_semana) %>%
  summarise(Ventas = sum(Sales_Uds)) 

g2<-ggplot(ventas_por_dia_de_semana, aes(x = dia_semana, y = Ventas)) +
  geom_col(fill = "#0098cd") +
  labs(title = "Ventas por día de la semana", x = "Día", y = "Unidades vendidas") +
  theme_minimal()

g2


ventas_diarias_mes_normalizado <- ventas_completo_2 %>%
  mutate(mes = month(Sales_DAY, label = TRUE)) %>%
  group_by(mes, Sales_DAY) %>%
  summarise(Ventas_dia = sum(Sales_Uds), .groups = "drop") %>%
  group_by(mes) %>%
  summarise(Media_diaria = mean(Ventas_dia), .groups = "drop")

g2_normalizado <- ggplot(ventas_diarias_mes_normalizado, aes(x = mes, y = Media_diaria)) +
  geom_col(fill = "#0098cd") +
  labs(title = "Media diaria de ventas por mes", x = "Mes", y = "Media diaria de ventas") +
  theme_minimal()

g2_normalizado
g2+g2_normalizado

#Se va a generar un dataset que contenga dia de la semana ccaa y festividades para graficar y conocer comportamiento 
# Se crea un vector de festivos nacionales en el 2015

festivos_nacionales<-as.Date(c("2015-01-01", "2015-01-06", "2015-04-03", "2015-05-01",
                            "2015-08-15", "2015-10-12", "2015-11-01","2015-12-06", "2015-12-08", "2015-12-25"))

# generamos una lista de festivos autonomicos en el 2015 extraidos de 
# https://www.ccoo-servicios.es/archivos/tecnocom/20150120_Calendario_Laboral_2015.pdf

festivos_ccaa<-list("Andalucía" = as.Date(c("2015-02-28","2015-04-02","2015-11-02","2015-12-07"),
  "Aragón" = as.Date(c("2015-04-23","2015-04-02","2015-11-02","2015-12-07")),
  "Asturias" = as.Date(c("2015-09-08","2015-04-02","2015-11-02","2015-12-07")),
  "Islas Baleares" = as.Date(c("2015-04-06","2015-04-02","2015-11-02","2015-12-07")),
  "Canarias" = as.Date(c("2015-05-30","2015-04-02","2015-11-02")),
  "Cantabria" = as.Date(c("2015-04-02","2015-11-02","2015-04-06","2015-09-15")),
  "Castilla-La Mancha" = as.Date(c("2015-04-02","2015-04-06","2015-06-04","2015-12-07")),
  "Castilla y León" = as.Date(c("2015-04-23","2015-04-02",,"2015-12-07","2015-11-02")),
  "Cataluña" = as.Date(c("2015-04-06", "2015-06-24", "2015-09-11","2015-12-26")),
  "Comunidad Valenciana" = as.Date(c("2015-03-19", "2015-10-09","2015-04-06","2015-12-07")),
  "Extremadura" = as.Date(c("2015-09-08","2015-04-02","2015-11-02","2015-12-07")),
  "Galicia" = as.Date(c("2015-07-25", "2015-04-02","2015-03-20","2015-11-02")),
  "Madrid" = as.Date(c("2015-03-19", "2015-04-02", "2015-05-02","2015-06-04")),
  "Murcia" = as.Date(c("2015-06-09","2015-03-19", "2015-04-02","2015-12-07")),
  "Navarra" = as.Date(c("2015-03-19","2015-04-02","2015-06-04","2015-07-25")),
  "País Vasco" = as.Date(c("2015-03-19","2015-04-02","2015-06-04","2015-07-25")),
  "La Rioja" = as.Date(c("2015-06-09","2015-04-02","2015-06-04","2015-12-07")),
  "Ceuta" = as.Date(c("2015-09-25","2015-12-07","2015-04-02")),
  "Melilla" = as.Date(c("2015-09-25","2015-12-07","2015-03-19","2015-04-02"))))

# vector de provincias a que ccaa pertenece

provincia_a_ccaa<-c("Álava" = "País Vasco","Albacete" = "Castilla-La Mancha","Alicante" = "Comunidad Valenciana",
                  "Almería" = "Andalucía","Asturias" = "Asturias","Ávila" = "Castilla y León","Badajoz" = "Extremadura",
                  "Barcelona" = "Cataluña","Burgos" = "Castilla y León","Cáceres" = "Extremadura","Cádiz" = "Andalucía","Cantabria" = "Cantabria",
                    "Castellón" = "Comunidad Valenciana","Ciudad Real" = "Castilla-La Mancha","Córdoba" = "Andalucía",
                  "Cuenca" = "Castilla-La Mancha","Girona" = "Cataluña","Granada" = "Andalucía","Guadalajara" = "Castilla-La Mancha",
                  "Guipúzcoa" = "País Vasco","Huelva" = "Andalucía","Huesca" = "Aragón","Illes Balears" = "Islas Baleares","Jaén" = "Andalucía",
                    "A Coruña" = "Galicia","La Rioja" = "La Rioja","Las Palmas" = "Canarias","León" = "Castilla y León","Lleida" = "Cataluña","Lugo" = "Galicia",
                   "Madrid" = "Madrid","Málaga" = "Andalucía","Murcia" = "Región de Murcia","Navarra" = "Navarra",
                   "Ourense" = "Galicia","Palencia" = "Castilla y León","Pontevedra" = "Galicia","Salamanca" = "Castilla y León",
                    "Santa Cruz de Tenerife" = "Canarias","Segovia" = "Castilla y León","Sevilla" = "Andalucía",
                    "Soria" = "Castilla y León","Tarragona" = "Cataluña","Teruel" = "Aragón","Toledo" = "Castilla-La Mancha","Valencia" = "Comunidad Valenciana",
                    "Valladolid" = "Castilla y León","Vizcaya" = "País Vasco","Zamora" = "Castilla y León","Zaragoza" = "Aragón","Ceuta" = "Ceuta","Melilla" = "Melilla")

#añadir al dataset el día de la semana y el tipo de día 
#(laborable, festivo o fin de semana), utilizando festivos nacionales y autonómicos

ventas_completo_2_festivos<-ventas_completo_2 %>%
  mutate(dia_semana = wday(Sales_DAY, label = TRUE),
          ccaa = recode(provincia, !!!provincia_a_ccaa),
          festivo_especifico = case_when(Sales_DAY %in% festivos_nacionales ~ TRUE,
                                                        !is.na(ccaa) & map2_lgl(ccaa, Sales_DAY,
                                                        ~ .y %in% festivos_ccaa[[.x]]) ~ TRUE,
                                                        TRUE ~ FALSE),
          tipo_dia = case_when(festivo_especifico ~ "Festivo",
            dia_semana %in% c("sá\\.", "do\\.") ~ "Fin de semana",
            TRUE ~ "Laborable"))

unique(ventas_completo_2_festivos$tipo_dia)

ventas_completo_2_festivos %>% count(tipo_dia)

ventas_completo_2_festivos %>% count(dia_semana)

ventas_completo_2_festivos %>%
  count(dia_semana) %>%
  arrange(dia_semana)

str(ventas_completo_2$Sales_DAY)

#Ver si se vende más en laborables, fines de semana o festivos.

g3<-ventas_completo_2_festivos %>%
  group_by(tipo_dia) %>%
  summarise(Ventas = sum(Sales_Uds)) %>%
  ggplot(aes(x = tipo_dia, y = Ventas, fill = tipo_dia)) +
  geom_col() +
  labs(title = "Ventas totales según tipo de día", x = "", y = "Unidades vendidas") +
  scale_fill_manual(values = c("#0072B2", "#E69F00", "#D55E00")) +
  theme_minimal()

g3

#Ver la evolución temporal con una línea por tipo de día.

g4<-ventas_completo_2_festivos %>%
  group_by(Sales_DAY, tipo_dia) %>%
  summarise(Ventas = sum(Sales_Uds), .groups = "drop") %>%
  ggplot(aes(x = Sales_DAY, y = Ventas, color = tipo_dia)) +
  geom_line() +
  labs(title = "Evolución de ventas por tipo de día", x = "Fecha", y = "Ventas") +
  theme_minimal()

g4

#Cruzar los días (lun-dom) con el tipo de día para detectar patrones.

g5<-ventas_completo_2_festivos %>%
  group_by(dia_semana, tipo_dia) %>%
  summarise(Ventas = sum(Sales_Uds), .groups = "drop") %>%
  ggplot(aes(x = dia_semana, y = Ventas, fill = tipo_dia)) +
  geom_col(position = "stack") +
  labs(title = "Ventas por día de la semana y tipo de día", x = "Día", y = "Unidades vendidas") +
  theme_minimal()

g5

g3+g4+g5

#Ahora se van a dibujar diferentes graficos para observar el comportamiento de las ventas generales


#se calculan las ventas por producto y se dibujan

ventas_productos <- ventas_completo_2 %>%
  group_by(Product_Code, SIZE, Format) %>%
  summarise(Unidades = sum(Sales_Uds), .groups = "drop") %>%
  arrange(desc(Unidades))

g6<-ggplot (ventas_productos)+
  geom_col(aes(x= Unidades, y= reorder(Product_Code, Unidades)),fill="#0098cd")+ 
  labs(title = "Ranking ventas por Producto", x=" Unidades Vendidas", y= "Producto")+
  theme_minimal()

g6

#se calculan las ventas totales por provincia y se dibujan , se trata de un ranking total 
#por provincia (suma de las ventas en todos los puntos de venta de cada provincia)

ventas_totales_provincia<-ventas_completo_2 %>%
  group_by(provincia) %>%
  summarise(Ventas_Totales = sum(Sales_Uds), .groups = "drop") %>%
  arrange(desc(Ventas_Totales))

g7<-ggplot(ventas_totales_provincia) +
                geom_col(aes(x = Ventas_Totales, y = reorder(provincia, Ventas_Totales)), fill = "#0098cd") +
                labs(title = "Ranking ventas totales por provincia", 
                     x = "Ventas Totales", 
                     y = "Provincias") +
                theme_minimal()
g7

# Ahora se muestran los Top 20 puntos de venta por ventas totales


# Top 20 puntos de venta con más ventas

top_puntos_venta <- ventas_completo_2 %>%
  group_by(Affiliated_Code, Affiliated_NAME, provincia) %>%
  summarise(Ventas_Totales = sum(Sales_Uds), .groups = "drop") %>%
  arrange(desc(Ventas_Totales)) %>%
  slice_max(order_by = Ventas_Totales, n = 30)

g8<-ggplot(top_puntos_venta) +
                geom_col(aes(x = Ventas_Totales, y = reorder(Affiliated_NAME, Ventas_Totales), fill = provincia)) +
                geom_text (aes(x = Ventas_Totales, y = reorder(Affiliated_NAME, Ventas_Totales), label = round (Ventas_Totales, 0)), 
                           hjust = 1, size = 4)+
                labs(title = "Top 20 puntos de venta por ventas totales", 
                     x = "Ventas Totales", 
                     y = "Punto de Venta") +
                theme_minimal()

g8

g6+g7+g8


#Modelos Propuestos: ARIMA y ETS
#Se hace una predicción a 3 meses para las 4 provincias en las que más se vende
#como se vio anteriormente


library(forecast)

#Se hace un dataset de ventas diarias totales que se usara para despues discriminar las
#filas de cada provincia

ventas_provincia_dia_totales<- ventas_completo_2%>%
  group_by(provincia, Sales_DAY)%>%
  summarise(Ventas_Totales_Diarias = sum(Sales_Uds), .groups = "drop")

#Se Predice Madrid     

#se separan las filas de madrid 

madrid<-ventas_provincia_dia_totales%>%
  filter(provincia == "Madrid") %>%
  arrange(Sales_DAY)


#Se le da formato de serie temporal y graficamos para verlo mejor, no se puede 
#descomponer debido a que no tenemos un año completo

serie_diaria_madrid<-ts(madrid$Ventas_Totales_Diarias,
                           start = c(2015, yday(min(madrid$Sales_DAY))),
                           frequency = 365)

plot(serie_diaria_madrid,main = "Serie temporal diaria de ventas en Madrid (2015)")


#Se hace la prediccion diaria modelo ARIMA

modelo_diario_madrid<- auto.arima(serie_diaria_madrid, seasonal = TRUE)

prediccion_diaria_madrid<-forecast(modelo_diario_madrid,h=90)

plot(prediccion_diaria_madrid,
     main = "Predicción de ventas diarias en Madrid (90 días)",
     ylab = "Ventas diarias",
     xlab = "Días futuros")

#Se calcula como de buena es la prediccion 
accuracy(modelo_diario_madrid)

#MAPE >50% indica un modelo con una precision mala

#El modelo ARIMA no encuentra patrones estacionales ni tendencias estables en la serie diaria de ventas.

#Esto puede deberse a:
#Fuerte ruido diario en los datos
#Falta de ciclos estacionales detectables (por ejemplo, no se repiten patrones semanales o mensuales).
#Período temporal muy corto (menos de un año) y sin años anteriores para detectar estacionalidad real.

#se comprueba el modelo arima en periodo semanal

madrid_semanal <- madrid %>%
  mutate(semana = floor_date(Sales_DAY, "week")) %>%
  group_by(semana) %>%
  summarise(Ventas_Semanales = sum(Ventas_Totales_Diarias), .groups = "drop")

serie_semanal_madrid <- ts(madrid_semanal$Ventas_Semanales, start = c(2015, 1), frequency = 52)
plot(serie_semanal_madrid,main = "Serie temporal semanal de ventas en Madrid (2015)")

#Se hace prediccion semanal modelo ARIMA

modelo_semanal_madrid<- auto.arima(serie_semanal_madrid, seasonal = TRUE)

prediccion_semanal_madrid<-forecast(modelo_semanal_madrid,h=12)

plot(prediccion_semanal_madrid,
     main = "Predicción de ventas semanal en Madrid (12 semanas)",
     ylab = "Ventas diarias",
     xlab = "Semanas futuras")

#Se calcula como de buena es la prediccion 

accuracy(modelo_semanal_madrid)

#ME     RMSE      MAE       MPE     MAPE MASE      ACF1
#Training set 328.8017 6598.653 4190.321 -55.41987 69.85865  NaN 0.1410504

#A nivel semanal, el modelo capta algo de estructura, pero la variabilidad sigue siendo elevada. La predicción mejora visualmente y 
#es más estable que la diaria, pero debe tomarse con cautela por el alto error relativo (MAPE).

#Se prueva con el modelo ETS que funciona bien con ruido y datos que fluctuan mucho

modelo_ets_madrid<-ets(serie_diaria_madrid)

prediccion_ets_madrid<-forecast(modelo_ets_madrid, h = 90)

plot(prediccion_ets_madrid,
     main = "Predicción ETS (Madrid - 90 días)",
     ylab = "Ventas diarias",
     xlab = "Días futuros")

accuracy(modelo_ets_madrid)

#MAPE muy alto lo que dice que el modelo tiene una mala precision predictiva

#Se prediceBarcelona

#Filas de Barcelona 

Barcelona<-ventas_provincia_dia_totales%>%
  filter(provincia == "Barcelona") %>%
  arrange(Sales_DAY)


#Formato de serie temporal y se grafica para verlo mejor, no se puede 
#descomponer debido a que no tenemos un año completo

serie_diaria_Barcelona<-ts(Barcelona$Ventas_Totales_Diarias,
                        start = c(2015, yday(min(Barcelona$Sales_DAY))),
                        frequency = 365)

plot(serie_diaria_Barcelona,main = "Serie temporal diaria de ventas en Barcelona (2015)")


#Hacemos la prediccion diaria modelo ARIMA

modelo_diario_Barcelona<- auto.arima(serie_diaria_Barcelona, seasonal = TRUE)

prediccion_diaria_Barcelona<-forecast(modelo_diario_Barcelona,h=90)

plot(prediccion_diaria_Barcelona,
     main = "Predicción de ventas diarias en Barcelona (90 días)",
     ylab = "Ventas diarias",
     xlab = "Días futuros")

#Calculamos como de buena es la prediccion

accuracy(modelo_diario_Barcelona)

#MAPE >50% indica un modelo con una precision mala

#El modelo ARIMA no encuentra patrones estacionales ni tendencias estables en la serie diaria de ventas.

#Esto puede deberse a:
#Fuerte ruido diario en los datos
#Falta de ciclos estacionales detectables (por ejemplo, no se repiten patrones semanales o mensuales).
#Período temporal muy corto (menos de un año) y sin años anteriores para detectar estacionalidad real.

#se comprueba el modelo arima en periodo semanal

Barcelona_semanal<-Barcelona%>%
  mutate(semana = floor_date(Sales_DAY, "week")) %>%
  group_by(semana) %>%
  summarise(Ventas_Semanales = sum(Ventas_Totales_Diarias), .groups = "drop")

serie_semanal_Barcelona<-ts(Barcelona_semanal$Ventas_Semanales, start = c(2015, 1), frequency = 52)

plot(serie_semanal_Barcelona,main = "Serie temporal semanal de ventas en Barcelona (2015)")

#Hacemos la prediccion semanal modelo ARIMA

modelo_semanal_Barcelona<-auto.arima(serie_semanal_Barcelona, seasonal = TRUE)

prediccion_semanal_Barcelona<-forecast(modelo_semanal_Barcelona,h=12)

plot(prediccion_semanal_Barcelona,
     main = "Predicción de ventas semanal en Barcelona(12 semanas)",
     ylab = "Ventas diarias",
     xlab = "Semanas futuras")

#Calculamos como de buena es la prediccion 

accuracy(modelo_semanal_Barcelona)

#ME     RMSE      MAE       MPE     MAPE MASE       ACF1
#Training set 165.4978 4784.412 2787.293 -88.44689 99.84792  NaN 0.07760957

#A nivel semanal, el modelo resulta no valido.

#Se prueva con el modelo ETS que funciona bien con ruido y datos que fluctuan mucho

modelo_ets_Barcelona<-ets(serie_diaria_Barcelona)
prediccion_ets_Barcelona<- forecast(modelo_ets_Barcelona, h = 90)

plot(prediccion_ets_Barcelona,
     main = "Predicción ETS (Barcelona - 90 días)",
     ylab = "Ventas diarias",
     xlab = "Días futuros")
accuracy(modelo_ets_Barcelona)

#MAPE muy alto lo que dice que el modelo no tiene precision predictiva


#Predecimos Valencia

#Filas de Valencia 

Valencia<-ventas_provincia_dia_totales%>%
  filter(provincia == "Valencia") %>%
  arrange(Sales_DAY)


#Le damos formato de serie temporal y graficamos para verlo mejor, no se puede 
#descomponer debido a que no tenemos un año completo

serie_diaria_Valencia<-ts(Valencia$Ventas_Totales_Diarias,
                           start = c(2015, yday(min(Valencia$Sales_DAY))),
                           frequency = 365)

plot(serie_diaria_Valencia,main = "Serie temporal diaria de ventas en Valencia (2015)")


#Hacemos la prediccion diaria modelo ARIMA

modelo_diario_Valencia<-auto.arima(serie_diaria_Valencia, seasonal = TRUE)

prediccion_diaria_Valencia<-forecast(modelo_diario_Valencia,h=90)

plot(prediccion_diaria_Valencia,
     main = "Predicción de ventas diarias en Valencia (90 días)",
     ylab = "Ventas diarias",
     xlab = "Días futuros")

#Calculamos como de buena es la prediccion

accuracy(modelo_diario_Valencia)

#MAPE tan alto indica un modelo con una precision mala

#El modelo ARIMA no encuentra patrones estacionales ni tendencias estables en la serie diaria de ventas.

#Esto puede deberse a:

#Fuerte ruido diario en los datos
#Falta de ciclos estacionales detectables (por ejemplo, no se repiten patrones semanales o mensuales).
#Período temporal muy corto (menos de un año) y sin años anteriores para detectar estacionalidad real.

#se comprueba el modelo arima en periodo semanal

Valencia_semanal<-Valencia%>%
  mutate(semana = floor_date(Sales_DAY, "week")) %>%
  group_by(semana) %>%
  summarise(Ventas_Semanales = sum(Ventas_Totales_Diarias), .groups = "drop")

serie_semanal_Valencia<-ts(Valencia_semanal$Ventas_Semanales, start = c(2015, 1), frequency = 52)
plot(serie_semanal_Valencia,main = "Serie temporal semanal de ventas en Valencia (2015)")

#Hacemos la prediccion semanal modelo ARIMA

modelo_semanal_Valencia<-auto.arima(serie_semanal_Valencia, seasonal = TRUE)

prediccion_semanal_Valencia<-forecast(modelo_semanal_Valencia,h=12)

plot(prediccion_semanal_Valencia,
     main = "Predicción de ventas semanal en Valencia(12 semanas)",
     ylab = "Ventas diarias",
     xlab = "Semanas futuras")

#Calculamos como de buena es la prediccion 

accuracy(modelo_semanal_Valencia)

#                    ME     RMSE      MAE       MPE     MAPE MASE       ACF1
#Training set -788.9627 3229.224 1387.007 -122.5167 126.3663  NaN 0.05397777


#Se prueva con el modelo ETS que funciona bien con ruido y datos que fluctuan mucho

modelo_ets_Valencia<-ets(serie_diaria_Valencia)
prediccion_ets_Valencia<- forecast(modelo_ets_Valencia, h = 90)

plot(prediccion_ets_Valencia,
     main = "Predicción ETS (Valencia - 90 días)",
     ylab = "Ventas diarias",
     xlab = "Días futuros")
accuracy(modelo_ets_Valencia)

#MAPE muy alto lo que dice que el modelo no tiene precision predictiva

#Predecimos Alicante

#Separamos las filas de Alicante

Alicante<-ventas_provincia_dia_totales%>%
  filter(provincia == "Alicante") %>%
  arrange(Sales_DAY)


#Le damos formato de serie temporal y graficamos para verlo mejor, no se puede 
#descomponer debido a que no tenemos un año completo

serie_diaria_Alicante<-ts(Alicante$Ventas_Totales_Diarias,
                          start = c(2015, yday(min(Alicante$Sales_DAY))),
                          frequency = 365)

plot(serie_diaria_Alicante,main = "Serie temporal diaria de ventas en Alicante (2015)")


#Hacemos la prediccion diaria modelo ARIMA

modelo_diario_Alicante<- auto.arima(serie_diaria_Alicante, seasonal = TRUE)

prediccion_diaria_Alicante<-forecast(modelo_diario_Alicante,h=90)

plot(prediccion_diaria_Alicante,
     main = "Predicción de ventas diarias en Alicante (90 días)",
     ylab = "Ventas diarias",
     xlab = "Días futuros")

#Calculamos como de buena es la prediccion 
accuracy(modelo_diario_Alicante)

#MAPE del 57.51% indica un modelo con una precision mala aunque es el mejor de todas las provincias

#El modelo ARIMA no encuentra patrones estacionales ni tendencias estables en la serie diaria de ventas.

#Esto puede deberse a:

#Fuerte ruido diario en los datos
#Falta de ciclos estacionales detectables (por ejemplo, no se repiten patrones semanales o mensuales).
#Período temporal muy corto (menos de un año) y sin años anteriores para detectar estacionalidad real.

#se comprueba el modelo arima en periodo semanal

Alicante_semanal<-Alicante%>%
  mutate(semana = floor_date(Sales_DAY, "week")) %>%
  group_by(semana) %>%
  summarise(Ventas_Semanales = sum(Ventas_Totales_Diarias), .groups = "drop")

serie_semanal_Alicante<-ts(Alicante_semanal$Ventas_Semanales, start = c(2015, 1), frequency = 52)
plot(serie_semanal_Alicante,main = "Serie temporal semanal de ventas en Alicante (2015)")

#Hacemos la prediccion semanal modelo ARIMA

modelo_semanal_Alicante<-auto.arima(serie_semanal_Alicante, seasonal = TRUE)

prediccion_semanal_Alicante<-forecast(modelo_semanal_Alicante,h=12)

plot(prediccion_semanal_Alicante,
     main = "Predicción de ventas semanal en Alicante(12 semanas)",
     ylab = "Ventas diarias",
     xlab = "Semanas futuras")

#Calculamos como de buena es la prediccion 

accuracy(modelo_semanal_Alicante)

#                    ME     RMSE      MAE       MPE     MAPE MASE       ACF1
#Training set 37.53617 1467.122 629.2236 -81.26976 89.03175  NaN 0.02041297


#Se prueva con el modelo ETS que funciona bien con ruido y datos que fluctuan mucho

modelo_ets_Alicante<-ets(serie_diaria_Alicante)
prediccion_ets_Alicante<- forecast(modelo_ets_Alicante, h = 90)

plot(prediccion_ets_Alicante,
     main = "Predicción ETS (Alicante - 90 días)",
     ylab = "Ventas diarias",
     xlab = "Días futuros")
accuracy(modelo_ets_Alicante)

#MAPE muy alto lo que dice que el modelo tiene precision predictiva mala

#TODO EL PAIS

# Se agregan las ventas totales diarias de todo el país

ventas_diarias_total_pais<-ventas_completo_2 %>%
                              group_by(Sales_DAY) %>%
                              summarise(Ventas_Totales = sum(Sales_Uds), .groups = "drop") %>%
                              arrange(Sales_DAY)

# Se agregan las ventas totales semanales de todo el país

ventas_semanales_total_pais<-ventas_completo_2 %>%
                              mutate(semana = floor_date(Sales_DAY, "week"))%>%
                              group_by(semana)%>%
                              summarise(Ventas_Semanales = sum(Sales_Uds), .groups = "drop")%>%
                              arrange(semana)

#Se genera la serie temporal diaria

serie_total_pais<-ts(ventas_diarias_total_pais$Ventas_Totales,
                       start = c(2015, yday(min(ventas_diarias_total_pais$Sales_DAY))),
                       frequency = 365)

#Se genera la serie temporal semanal
serie_semanal_total_pais <- ts(ventas_semanales_total_pais$Ventas_Semanales,
                               start = c(2015, 1),
                               frequency = 52)

#Aplicamos los Modelos ARIMA y ETS

modelo_arima_pais<-auto.arima(serie_total_pais, seasonal = TRUE)
modelo_arima_semanal_pais<-auto.arima(serie_semanal_total_pais, seasonal = TRUE)
modelo_ets_pais<-ets(serie_total_pais)


#Predicciones

pred_arima_pais<-forecast(modelo_arima_pais, h = 90)
pred_arima_semanal_pais<-forecast(modelo_arima_semanal_pais, h = 12)
pred_ets_pais<-forecast(modelo_ets_pais, h = 90)

#Precision de los modelos

accuracy(modelo_arima_pais)
accuracy(modelo_arima_semanal_pais)
accuracy(modelo_ets_pais)

#Visualización de las prediciones
plot(pred_arima_pais, main = "Predicción ARIMA - Ventas totales (90 días)")
plot(pred_arima_semanal_pais, main = "Predicción ARIMA - Ventas semanales totales (12 semanas)")
plot(pred_ets_pais, main = "Predicción ETS - Ventas totales (90 días)")


