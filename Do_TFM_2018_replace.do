Santiago Haro

*** Base Año 2018 ***
clear all

set more off

** Cargar la base del año 2018
use "C:\Users\Santiago\Documents\UCM\TFM\Datos\2018\MuestraIRPF_2018.dta"

gen A = Par19 + Par20 + Par21 + Par23

gen renta = Par435 + Par460 + A

gen bi = Par435 + Par460

gen bl = Par505 + Par510

gen ci = Par545 + Par546

gen cl = Par570 + Par571


replace renta=0 if renta<0
replace bi=0 if bi<0
replace bl=0 if bl<0

* Genero reducciones *

gen R = bi - bl

replace R=0 if R<0

* Genero mínimos P y F MPF es la suma de todos los M*

gen MPF = Par519

gen MP = Par511
gen MD = Par513
gen MA = Par515
gen MDC = Par517


* Genero renta después de impuestos

gen renta_neta= renta - cl

replace renta_neta=0 if renta_neta<0

* Genero renta - R - MPF * Renta libre de impuestos

gen renta_R_MPF_A = renta - R - MPF - A

replace renta_R_MPF_A=0 if renta_R_MPF_A<0

* Genero el valor de las deducciones 

gen D = ci -cl

replace D=0 if D<0

* Genero variables Para efecto base *

gen renta_A = renta - A
gen renta_R = renta - R
gen renta_MPF = renta - MPF

gen renta_MP = renta - MP
gen renta_MD = renta - MD
gen renta_MA = renta - MA
gen renta_MDC = renta - MDC


gen BI_MP = bi-MP
gen BI_MP_MD = BI_MP - MD
gen BI_MP_MD_MA = BI_MP_MD - MA
gen BI_MP_MD_MA_MDC = BI_MP_MD_MA - MDC
gen BI_MPF_R = bi - MPF - R
gen BI_MPF = bi - MPF

*** Empezar a calcular todos los RS de estas variables



*** Reemplazo por cero todas las variables negativas  **

replace renta_A=0 if renta_A<0
replace renta_R=0 if renta_R<0
replace renta_MPF=0 if renta_MPF<0
replace renta_MP=0 if renta_MP<0
replace renta_MD=0 if renta_MD<0
replace renta_MA=0 if renta_MA<0
replace renta_MDC=0 if renta_MDC<0
replace BI_MP=0 if BI_MP<0
replace BI_MP_MD=0 if BI_MP_MD<0
replace BI_MP_MD_MA=0 if BI_MP_MD_MA<0
replace BI_MP_MD_MA_MDC=0 if BI_MP_MD_MA_MDC<0
replace BI_MPF_R=0 if BI_MPF_R <0
replace BI_MPF=0 if BI_MPF<0

** Mínimos que se encuentran en la base liquidable y gravan 0
* Mínimo del contribuyente Par635
* Mínimo por descendiente Par636
* Mínimo por ascendiente Par637
* Mínimo por discapacidad Par638
* Mínimo personal y familiar (suma anteriores)Par685



** Curvas  e índices de concentración y Lorenz Brutos**
lorenz renta cl renta_neta [w=factor], pvar(renta) graph(overlay noci) gini
** efecto reordenación **
lorenz renta_neta [w=factor], gini

** Ginis Para efecto redistributivo de la base imponible  **
lorenz  renta_A [w=factor], gini
lorenz  renta_R [w=factor], gini
lorenz  renta_MP [w=factor], gini
lorenz  renta_MD [w=factor], gini
lorenz  renta_MA [w=factor], gini
lorenz  renta_MDC [w=factor], gini
lorenz  renta_MPF [w=factor], gini
lorenz  renta_R_MPF_A [w=factor], gini

lorenz  BI_MP [w=factor], gini
lorenz  BI_MP_MD [w=factor], gini
lorenz  BI_MP_MD_MA [w=factor], gini
lorenz  BI_MP_MD_MA_MDC [w=factor], gini
lorenz  BI_MPF_R [w=factor], gini
lorenz  BI_MPF [w=factor], gini



* Genero variables Para efecto cuota *
gen renta_R_MPF_A_CI = renta - R - MPF - A - ci
gen renta_R_MPF_A_CI_CL = renta - R - MPF - A - ci + D

replace renta_R_MPF_A_CI=0 if renta_R_MPF_A_CI<0
replace renta_R_MPF_A_CI_CL=0 if renta_R_MPF_A_CI_CL<0


** Ginis Para efecto redistributivo de la cuota  **
lorenz  renta_R_MPF_A_CI [w=factor], gini
lorenz  renta_R_MPF_A_CI_CL [w=factor], gini



** Ginis Para efecto redistributivo de la cuota **
lorenz  variable [w=factor], gini

** Media con pesos Para la fórmula final 
egen Var = wtmean(var), weight(factor)


** medias Para ponderadores **
egen mean1 = wtmean( renta_R_MPF_A_CI_CL ), weight(factor)
sum mean1
egen mean2 = wtmean( cl ), weight(factor)
sum mean2
egen mean3 = wtmean( renta_neta ), weight(factor)
sum mean3


** Gráfico de Pfahler **
lorenz renta cl renta_neta renta_R_MPF_A renta_R_MPF_A_CI_CL [w=factor], pvar(renta) graph(overlay noci) gini



** Coeficientes de concentración (solo prueba) **
lorenz  renta_A [w=factor], pvar(renta) gini 
lorenz  renta_R [w=factor], pvar(renta) gini
lorenz  renta_MP [w=factor], pvar(renta) gini
lorenz  renta_MD [w=factor], pvar(renta) gini
lorenz  renta_MA [w=factor], pvar(renta) gini
lorenz  renta_MDC [w=factor], pvar(renta) gini
lorenz  renta_MPF [w=factor], pvar(renta) gini
lorenz  renta_R_MPF_A [w=factor], pvar(renta) gini

lorenz  BI_MP [w=factor], pvar(renta) gini
lorenz  BI_MP_MD [w=factor], pvar(renta) gini
lorenz  BI_MP_MD_MA [w=factor], pvar(renta) gini
lorenz  BI_MP_MD_MA_MDC [w=factor], pvar(renta) gini
lorenz  BI_MPF [w=factor], pvar(renta) gini
lorenz  BI_MPF_R [w=factor], pvar(renta) gini

lorenz  renta_R_MPF_A_CI [w=factor], pvar(renta) gini
lorenz  renta_R_MPF_A_CI_CL [w=factor], pvar(renta) gini



