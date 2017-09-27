clear all
set more off
global ruta_storms "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable"

use "$ruta_storms/destruction index_2001_CHANTAL_2001.dta"
merge m:1 ed_id using "$ruta_storms/destruction index_2001_IRIS_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

*2002 SEASON

merge m:1 ed_id using "$ruta_storms/destruction index_2002_ISIDORE_2001.dta"
tab _merge
drop if _merge!=3
drop _merge
merge m:1 ed_id using "$ruta_storms/destruction index_2002_LILI_2001.dta"
tab _merge
drop if _merge!=3
drop _merge
merge m:1 ed_id using "$ruta_storms/destruction index_2002_UNNAMED_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

*2003 SEASON

merge m:1 ed_id using "$ruta_storms/destruction index_2003_CLAUDETTE_2001.dta"
tab _merge
drop if _merge!=3
drop _merge
merge m:1 ed_id using "$ruta_storms/destruction index_2003_ODETTE_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

*2004 SEASON
merge m:1 ed_id using "$ruta_storms/destruction index_2004_BONNIE_2001.dta"
tab _merge
drop if _merge!=3
drop _merge
merge m:1 ed_id using "$ruta_storms/destruction index_2004_CHARLEY_2001.dta"
tab _merge
drop if _merge!=3
drop _merge
merge m:1 ed_id using "$ruta_storms/destruction index_2004_IVAN_2001.dta"
tab _merge
drop if _merge!=3
drop _merge
merge m:1 ed_id using "$ruta_storms/destruction index_2004_JEANNE_2001.dta"
tab _merge
drop if _merge!=3
drop _merge
*2005 SEASON
merge m:1 ed_id using "$ruta_storms/destruction index_2005_ALPHA_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2005_DENNIS_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2005_EMILY_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2005_GAMMA_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2005_WILMA_2001.dta"
tab _merge
drop if _merge!=3
drop _merge


*SEASON 2006
merge m:1 ed_id using "$ruta_storms/destruction index_2006_CHRIS_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2006_ERNESTO_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

*SEASON 2007
merge m:1 ed_id using "$ruta_storms/destruction index_2007_DEAN_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2007_FELIX_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2007_NOEL_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2007_OLGA_2001.dta"
tab _merge
drop if _merge!=3
drop _merge


*SEASON 2008
merge m:1 ed_id using "$ruta_storms/destruction index_2008_FAY_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2008_GUSTAV_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2008_HANNA_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2008_IKE_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2008_PALOMA_2001.dta"
tab _merge
drop if _merge!=3
drop _merge


*SEASON 2010, THERE WAS NONE IN 2009 SEASON
merge m:1 ed_id using "$ruta_storms/destruction index_2010_ALEX_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2010_BONNIE_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2010_KARL_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2010_MATTHEW_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2010_NICOLE_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2010_RICHARD_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2010_TOMAS_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

*SEASON 2011
merge m:1 ed_id using "$ruta_storms/destruction index_2011_EMILY_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2011_RINA_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

*SEASON 2012
merge m:1 ed_id using "$ruta_storms/destruction index_2012_ERNESTO_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2012_HELENE_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2012_ISAAC_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2012_SANDY_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2013_DORIAN_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

merge m:1 ed_id using "$ruta_storms/destruction index_2014_HANNA_2001.dta"
tab _merge
drop if _merge!=3
drop _merge

save "$ruta_storms/set_storms_01_14.dta"

