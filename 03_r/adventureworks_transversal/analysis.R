library(readxl)    
library(dplyr)    
library(ggplot2)   
library(patchwork)
# 1. ¿En qué país (Country) se concentra la mayor parte de la facturación (TotalAmount)? Utiliza para ello la pestaña Var 
# Discreta Adq Bicicleta y las variables Country y TotalAmount. Haz un gráfico con el TOP 10 y describe brevemente los 
# hallazgos más relevantes tras este conocimiento inicial.

# Cargamos el archivo
archivo <- "dataset_AW.xlsx"
datos_bicicleta <- read_excel("Actividad 3/Actividad 3/dataset_AW.xlsx", 
                              sheet = "Var Discreta Adq Bicicleta")

# Ver nombres de columnas
colnames(datos_bicicleta)

# Observación inicial de los datos
head(datos_bicicleta)
#se observa que hay 2 paise mal nombrados se renombran ya que no existe northwest ni southwest sino que son Estados Unidos de America
datos_bicicleta$Country[datos_bicicleta$Country == "Southwest"]<-"Estados Unidos"
datos_bicicleta$Country[datos_bicicleta$Country == "Northwest"]<-"Estados Unidos"
datos_bicicleta$Country[datos_bicicleta$Country == "Southeast"]<-"Estados Unidos"
datos_bicicleta$Country[datos_bicicleta$Country == "Northeast"]<-"Estados Unidos"
datos_bicicleta$Country[datos_bicicleta$Country == "Central"]<-"Estados Unidos"
# Agrupamos por país y calculamos la facturación total
top_paises <- datos_bicicleta %>%
  group_by(Country) %>%
  summarise(Facturacion_Total = sum(TotalAmount, na.rm = TRUE)) %>%
  arrange(desc(Facturacion_Total)) %>%
  slice_head(n = 10) 

# Creamos el gráfico
ggplot(top_paises, aes(x = reorder(Country, Facturacion_Total), y = Facturacion_Total)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  ggtitle("Top 10 países por Facturación Total")

# Estados Unidos es el país que lidera el ranking de facturación total, por lo que sería el mercado más importante para
# la empresa. Australia es también tiene un peso relevante. En el mercado europeo son relevantes UK, Alemania y Francia. Se podrían enfocar los recursos comerciales
# y operativos en estos países prioritarios.

# 2. Haz una representación gráfica que permita conocer la tendencia de las ventas de la empresa. Utiliza la pestaña ST 
# Ventas Totales. ¿Qué tendencia tienen las ventas de la empresa?

ventas <- read_excel("Actividad 3/Actividad 3/dataset_AW.xlsx", 
                                sheet = "ST Ventas Totales ")

# Observamos la estructura del dataset, tanto las columnas que lo componen como una vista previa de los datos
colnames(ventas)

head(ventas)


# Comprobamos que la columna OrderDate tiene formato de fecha
library(dplyr)
library(lubridate)

ventas$OrderDate <- as.Date(ventas$OrderDate)
str(ventas)

# Agrupamos las ventas por mes
ventas_mensuales <- ventas %>%
  mutate(Mes = floor_date(OrderDate, "month")) %>%
  group_by(Mes) %>%
  summarise(Ventas = sum(Sales, na.rm = TRUE))

# Creamos el gráfico

ggplot(ventas_mensuales, aes(x = Mes, y = Ventas)) +
  geom_line()

# Creamos el gráfico dibujando la tendencia

ggplot(ventas_mensuales, aes(x = Mes, y = Ventas)) +
  geom_line()+
  geom_smooth(method = "lm", se = FALSE)
#la tendencia de la ventas de la empresa es creciente aunque tienen mucha irregularidad lo que se traduce en una alta estacionalidad

# 3. La dirección general quiere revisar las políticas de precios actuales. ¿Cuál es el precio medio de las distintas categorías de producto que 
# comercializa la empresa? Utiliza las variables Name y UnitPrice de la pestaña Datos sin etiquetas (No Supervisado). ¿Hay diferencia de precios cuando
# los productos son de un color determinado? Para resolver a esta última pregunta debes utilizar la variable Color.

productos <-read_excel("Actividad 3/Actividad 3/dataset_AW.xlsx", 
                        sheet = "Datos sin etiquetas (No Supervs")

colnames(productos)

# Calculamos el precio medio por producto

precio_medio_producto <- productos %>%
  group_by(Name) %>%
  summarise(PrecioMedio = mean(UnitPrice, na.rm = TRUE)) %>%
  arrange(desc(PrecioMedio))
print(precio_medio_producto)

# Hacemos un gráfico del TOP10 de productos por mayor precio medio

top_productos <- precio_medio_producto %>%
  slice_head(n = 10)

g1<-ggplot(top_productos, aes(x = reorder(Name, PrecioMedio), y = PrecioMedio)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 10 productos por precio medio",
       x = "Producto",
       y = "Precio medio")
g1
# Calculamos el precio medio por color
precio_medio_color <- productos %>%
  group_by(Color) %>%
  summarise(PrecioMedio = mean(UnitPrice, na.rm = TRUE)) %>%
  arrange(desc(PrecioMedio))
print(precio_medio_color)

# Hacemos un gráfico de los productos con mayor precio medio por color
g2<-ggplot(precio_medio_color, aes(x = reorder(Color, PrecioMedio), y = PrecioMedio)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Precio medio por color",
       x = "Color",
       y = "Precio medio")
g2
g1+g2
# Para resolver la pregunta de si hay diferencia de precios cuando los productos son de un color determinado
#calculamos un ANOVA

anova_result <- aov(UnitPrice ~ Color, data = productos)
summary(anova_result)

#un pvalor tan significativo muestra que hay diferencias significativas en funcion del color del producto

# Calculamos el precio medio por color y producto
precio_medio_color_producto <- productos %>%
  group_by(Name,Color) %>%
  summarise(PrecioMedio = mean(UnitPrice, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(PrecioMedio))
print(precio_medio_color_producto)

# Hacemos un gráfico de los productos con mayor precio medio por color y producto
g3<-ggplot ( precio_medio_color_producto, aes(x = reorder(paste(Name, Color, sep = " - "), PrecioMedio), y = PrecioMedio))+
  geom_bar(stat = "identity")+
  coord_flip() +
  labs(title = "Precio medio por color y producto",
       x = "Color",y = "Precio medio")
g2+g3

#Hacemos un grafico para conocer como se distribuyen los precios en cada color (media, mediana, etc)
g4<-ggplot(productos, aes(x = Color, y = UnitPrice)) +
  geom_boxplot(fill = "steelblue", color = "black") +
  labs(title = "Distribución del precio por color",
       x = "Color", y = "Precio") +
  theme_minimal()

g1+g2+g3+g4

#Hay diferencias significativas en funcion del color del producto. Los productos más caros son las mountain bikes sin embargo, si añadimos el color a nuestro estudio se ve
# que el producto más caro es road bike red seguido de mountain bike black. En el grafico de cjas se puede observar como el rojo tiene el outlier más elevado y así mismo
#una distribucion de precios más amplia en el tercer cuartil, esto es entre el 50% y el 75% de los productos de ese color. 
# Apesar de que el color influye en el precios los  productos más caros son las bicicletas

# 4. ¿Qué características tienen los compradores de bicicletas? Para ello, utiliza las variables BikePurchase (1 es que el cliente es comprador de 
# bicicleta).

# Utilizamos el conjunto de datos que habíamos llamado datos_bicicleta y que contiene la información de la pestaña Var Discreta Adq Bicicleta

colnames(datos_bicicleta)

table(datos_bicicleta$BikePurchase)
# Obtenemos la distribución de la variable y observamos que 9132 clientes han comprado bicicletas y 9352 no han comprado

# Vamos a crear una variable nueva donde se calcule los ingresos medios por rango de ingreso, para poder calcular el ingreso medio por cliente
library(stringr)

datos_bicicleta <- datos_bicicleta %>%
  mutate(IncomeAvg = case_when(YearlyIncome == "0-25000"~ 12500,
                      YearlyIncome == "25001-50000"~ 37500,
                      YearlyIncome == "50001-75000"~ 62500,
                      YearlyIncome == "75001-100000"~ 87500,
                      YearlyIncome == "100001-125000"~ 112500,
                      YearlyIncome == "125001-150000"~ 137500,
                      YearlyIncome == "150000+"~ 155000,
                      TRUE ~ NA_real_))

# Filtramos primero por los compradores para ver sus características

compradores <- datos_bicicleta %>% filter(BikePurchase == 1)
summary(compradores)

# Calculamos la edad media de los compradores
mean(compradores$Age, na.rm = TRUE)
# La edad media de los compradores es de 57 años

# Calculamos el ingreso medio
mean(compradores$IncomeAvg, na.rm = TRUE)

# Los ingresos medios anuales por compradores son de algo más de 50k/año

# Distribución de la variable Education
table(compradores$Education)
prop.table(table(compradores$Education))
# El 33% de los clientes tienen estudios universitarios completos, el 18% tienen un máster/doctorado, el 15% realizaron educación secundaria,
# el 27% tienen estudios universitarios parciales y el 5% tienen estudios secundarios parciales

# Distribución de la variable MaritalStatus
table(compradores$MaritalStatus)
prop.table(table(compradores$MaritalStatus))
# El 51% de los clientes están casados y el 49% solteros.

# Distribución de la variable Gender
table(compradores$Gender)
prop.table(table(compradores$Gender))
# El 50,3% son mujeres y el 49,6% son hombres

# Si comparamos estos resultados con los no compradores:
# Edad media:
datos_bicicleta %>%
  group_by(BikePurchase) %>%
  summarise(EdadMedia = mean(Age, na.rm = TRUE))
# Los compradores tienen una edad media de 57 años mientras que los no compradores tienen una edad media de 59

# Ingreso medio por grupo
datos_bicicleta %>%
  group_by(BikePurchase) %>%
  summarise(IngresoMedio = mean(IncomeAvg, na.rm = TRUE))
# Los compradores tienen unos ingresos medios de 50421 dólares al año mientras que los no compradores tienen unos ingresos medios anuales de 48529

# Distribuciones por grupo en la variable Education
prop.table(table(datos_bicicleta$Education, datos_bicicleta$BikePurchase))
# El grupo de compradores más numeroso es el que tiene estudios universitarios superiores(16%), mientras que en los no compradores el grupo más numeroso 
# es el que tiene estudios universitarios parciales (13%)

# Distribuciones por grupo en la variable MaritalStatus
prop.table(table(datos_bicicleta$MaritalStatus, datos_bicicleta$BikePurchase))
# El grupo de casados es el más numeroso tanto en compradores como en no compradores

# Distribuciones por grupo en la variable Gender
prop.table(table(datos_bicicleta$Gender, datos_bicicleta$BikePurchase))
# En los compradores, la mayoría son mujeres (24.8%), mientras que en los no compradores, la mayoría son hombres (26%)

# Visualizamos el ingreso medio por grupo
datos_bicicleta %>%
  group_by(BikePurchase) %>%
  summarise(IngresoMedio = mean(IncomeAvg, na.rm = TRUE)) %>%
  ggplot(aes(x = factor(BikePurchase), y = IngresoMedio)) +
  geom_bar(stat = "identity") +
  labs(x = "Comprador de bicicleta", y = "Ingreso medio estimado (€)", title = "Ingreso medio por grupo")

# Visualizamos la edad media
datos_bicicleta %>%
  group_by(BikePurchase) %>%
  summarise(EdadMedia = mean(Age, na.rm = TRUE)) %>%
  ggplot(aes(x = factor(BikePurchase), y = EdadMedia)) +
  geom_bar(stat = "identity") +
  labs(x = "Comprador de bicicleta", y = "Edad media", title = "Edad media por grupo")

# 5. 	¿Qué conclusiones iniciales puede extraer Juana con la información útil generada?

#1)	EEUU y Australia concentran la mayor parte de la facturación de la empresa, lo que permitirá enfocar los esfuerzos comerciales, 
#logísticos y promocionales de la empresa. Se debería estudiar qué es lo que compran para potenciar las ventas.
#2)	Las ventas presentan un comportamiento cíclico, con picos en ciertos momentos del año, lo que indica una posible influencia estacional, 
#compatible con el tipo de productos que se venden en la compañía (bicicletas y respuestos). Estos comportamientos se deben tener en cuenta 
#a la hora de optimizar el aprovisionamiento y la gestión del inventario, así como la planificación de las campañas de marketing.
#3)	Existen diferencias muy marcadas en el precio medio por tipo de producto, siendo las bicicletas y sus cuadros los productos de mayor valor. 
#Se observan diferencias en cuanto al color del producto, siendo los productos de color rojo, plateado y amarillo los que mayor precio 
#medio presentan. Viendo que el color influye en el precio se debería ver si también en las ventas.
#4)	El comprador promedio de bicicletas es una persona de unos 57 años, con ingresos de unos 50k dólares anuales, nivel educativo universitario 
#y con estado civil casado/a. Se detecta una mayor proporción de mujeres entre los compradores, lo que puede indicar una oportunidad de enfoque 	
#de marketing por género.
#Gracias a este análisis, Juana ha obtenido una visión clara y estructurada del negocio, que le permitirá tomar decisiones informadas en 
#las siguientes fases del proyecto de inteligencia de negocio. Esta información proporciona una base sólida para profundizar en estrategias de 
#internacionalización, análisis predictivos, políticas de precios y segmentación de clientes.
