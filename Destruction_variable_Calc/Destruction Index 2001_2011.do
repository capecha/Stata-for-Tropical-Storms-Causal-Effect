/* This program merge the destruction index calculated using census data in 2001 with the one calculated using data from 2011census
*/
clear all
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/EDs merge/merge_2001_2011_only ed_id.dta", clear
ren ed_id ed_id11 
ren ed_id_2001 ed_id
la var ed_id "ED if in 2001"
* 54%=2808/5235
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/EDs merge/merge_2001_2011_only ed_id1.dta", replace
*For Health fees
ren ed_id11 iddist
sort iddist
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/EDs merge/merge_2001_2011_only ed_id_hf.dta", replace


use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_2011_95_14.dta",clear																			
append using  "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_2001_95_14.dta"
drop ed_id_2001_2011
merge m:1 ed_id using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/EDs merge/merge_2001_2011_only ed_id1.dta" 
bysort census ed_id: gen newid = 1 if _n==1
replace newid = sum(newid)
replace ed_id11= ed_id if census==2011
bysort ed_id11 : egen newid3=min(newid)
replace newid3=newid if ed_id11==.
ren newid3 ed_id_2001_2011
drop newid
drop _merge
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_2001_2011_95_14.dta", replace

keep if census==2001
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_2001_95_14.dta", replace

use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_2001_2011_95_14.dta",clear
keep if census==2011
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_2011_95_14.dta", replace
