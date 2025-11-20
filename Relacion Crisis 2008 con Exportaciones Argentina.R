library(readxl)
library(strucchange)
library(lmtest)

datos <- read_excel("C:/Users/CTI24673/OneDrive - AMX Argentina S.A/Documentos/R/BaseTP.xlsx")

# Variables Logaritmicas
datos$ln_Export <- log(datos$Exportaciones)
datos$ln_TCR <- log(datos$TCR_real)
datos$ln_Soja <- log(datos$PrecioSoja)
datos$ln_PBImundial <- log(datos$PBI_Mundial)
datos$ln_PBIarg <- log(datos$PBI_Argentina)
#Transformo las variables a logaritmicas para que la regresion explique los valores como elasticidades.
#Buscando un sentido economico.
#Tambien buscamos reducir heterocedasticidad al suavizar la varianza de las series.
modelo<- lm(ln_Export ~ Crisis2008 + ln_TCR + I(ln_TCR^2) +
                               ln_Soja + ln_PBImundial + ln_PBIarg ,data = datos)
summary(modelo)

#El modelo explica el 96,93% de la variabilidad de las exportaciones, un muy buen nivel de ajuste.
#F estadistico p<0.001 - el conjunto de variables explica significativamente las exportaciones, el modelo en su totalidad es util.
#Residual standard error = 0.1175 - los errores promedios son relativamente pequeños en escala logaritmica.

#Intercepto: Constante del modelo.
#Crisis2008: No significativa: no hay evidencia de que la crisis del 2008 haya reducido ni aumentado las exportaciones argentinas, mantienendo cte las demas variables.
#ln_TCR: Indica que un aumento inicial del tipo de cambio real (depreciacion) incrementa las exportaciones, ceteris paribus.
#ln_TCR2: Muy Significativa: La relacion con el TCR es no lineal concava: al principio la depreciacion ayuda, pero a partir de cierto nivel las exportaciones dejan de crecer y pueden caer.
#ln_soja: No significativa: el precio internacional de la soja no mostro impacto independiente (probablemente porque su efecto ya se refleja en el PBI mundial).
#ln_PBImundial: Muy significativa: Un aumento del 1% en el PBI mundial se asocia con un aumento de 2,48% de las exportaciones argentinas. Esto muestra que el contexto global tiene un fuerte impacto sobre las ventas externas.
#ln_PBIarg: Significativa: un aumento del 1% del pbi argentino se asocia con una reduccion del 0.62% en exportaciones. Posiblemente, porque un pbi mas alto aumenta conusmo interno y reduce disponiblidad par aexportar.

#El efecto total del TCR es: 6,03.2*0,74265 * ln(TCR)
#Esto confirma la relacion concava:
#Para TCR bajo, la depreciación ayuda a exportar.
#A partir de cierto punto, más depreciación ya no es beneficiosa.



#Intereptecion economica:
#El modelo explica muy bien las exportaciones totales (R² ~ 0.96).
#El PBI mundial sigue siendo la variable más determinante.#El PBI mundial mantiene un efecto positivo y altamente significativo, confirmando la fuerte dependencia del comercio exterior argentino respecto a la actividad económica global.
#El tipo de cambio real tiene un efecto no lineal cóncavo: aumenta exportaciones hasta un punto y luego disminuye.
#El PBI argentino tiene un efecto negativo, consistente con mayor consumo interno.
#La crisis de 2008 no tuvo un impacto directo una vez controladas las otras variables.
#El precio de la soja no es relevante para las exportaciones totales.

sctest(modelo, type = "Chow", point = which(datos$Año == 2009))
#Evaluamos si existe un quiebre estructural en el año 2009, es decir, si los coeficientes de la regresion cambian significativamente un año despues de la crisis.
#El p_value nos da 0.40 > 0.05, por lo tantao no se rechaza H0 - El modelo se mantiene estable; la crisis no cambio significativamente los coeficientes.

#Otro tipo de diagnosticos
dwtest(modelo)
# El p_value es menor a 0.05, los errores del modelo estan correlacionados en el tiempo, lo cual puede pasar con series temporales como exportaciones anuales.

bptest(modelo)
# Buscamos comprobar si la dispersion de los errores cambia con el nuvel de las variables explicativas.
#El p_value nos da 0.3789 > 0.05, no hay heterocedasticidad.

#Graficos de diagnostico
par(mfrow = c(2,2)) 
plot(modelo)

###################
modelo_lineal <-lm(ln_Export ~ Crisis2008 + ln_TCR + ln_Soja + ln_PBImundial + ln_PBIarg, data = datos)
anova(modelo_lineal, modelo)
#Como el p_value es menor a 0.05 “El modelo con términos cuadráticos mejora significativamente la capacidad explicativa respecto del modelo lineal simple.”

modelo_externo <- lm(ln_Export ~ ln_PBImundial + ln_Soja + ln_TCR, data = datos)
summary(modelo_externo)
#R² = 0.9113 → El modelo explica el 91,1 % de la variación de las exportaciones argentinas.
#Es un valor muy alto, lo que sugiere que las variables externas (fundamentalmente el PBI mundial) explican gran parte del comportamiento de las exportaciones.
#F-statistic: 89.04, p < 0.001 → El modelo en su conjunto es altamente significativo, es decir, al menos una de las variables tiene efecto sobre las exportaciones.

#ln_PBImundial= s claramente significativa y positiva. Indica que si el PBI mundial aumenta 1 %, las exportaciones argentinas aumentan aproximadamente 1.38 %. Muestra una alta elasticidad ingreso de la demanda externa.
#ln soja = No es significativa → los precios internacionales de la soja no explican las exportaciones totales (puede deberse a la diversificación exportadora o rezagos no modelados).
#ln_TCR= No significativa y de signo negativo → el tipo de cambio real no parece tener un efecto directo sobre las exportaciones en este modelo. Podría ser porque el PBI mundial capta gran parte de la variabilidad o por efecto de multicolinealidad.


install.packages("reshape2")

library(ggplot2)
library(reshape2)

# Seleccionar solo las variables numéricas para la correlación
vars <- datos[, c("ln_Export", "ln_TCR", "ln_Soja", "ln_PBImundial", "ln_PBIarg")]

# Matriz de correlación
corr_matrix <- cor(vars, use = "complete.obs")
corr_matrix

corr_long <- melt(corr_matrix)
colnames(corr_long) <- c("Var1", "Var2", "Correlacion")

ggplot(corr_long, aes(Var1, Var2, fill = Correlacion)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white",
                       midpoint = 0, limit = c(-1,1), name = "Correlación") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Heatmap de correlaciones",
       x = "Variables",
       y = "Variables")

