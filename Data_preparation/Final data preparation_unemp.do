*Do file for the final data set 
clear all
capture log close
set more off
set niceness 0
set maxvar 31000
 set matsize 10000
global ruta_data "/Volumes/Transcend/Jamaica"
global ruta_data_aux "/Volumes/Untitled/Jamaica"
global ruta_data_save "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/Data/Working"
global ruta_data_gis "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/Data/GIS"
global ruta_data_panel "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/Data"
global ruta_storms "/Volumes/Transcend/Other DATA/Hurricanes/Destruct ind test/Destruction Index variable"
global ruta_data_large "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/DATA/Panels/LFS"


/*This part will integrate the information on distance to the coast.
import delimited "$ruta_data_panel/district distances.csv", encoding(ISO-8859-1)clear
replace ed_id=102051 if objectid==1975
replace ed_id=402006 if objectid==2549
replace ed_id=804056 if objectid==4826
replace ed_id=1104014 if objectid==4070
replace ed_id=1304066 if objectid==1717

ren ed_id ed_id_t_1
ren hubdist dist_kingston 
sort ed_id_t_1
keep ed_id_t_1 dist_kingston
save "$ruta_data_panel/district distances to Kingston.dta", replace

import delimited "$ruta_data_panel/distance_to_coast.csv", encoding(ISO-8859-1)clear
replace ed_id=102051 if objectid==1975
replace ed_id=402006 if objectid==2549
replace ed_id=804056 if objectid==4826
replace ed_id=1104014 if objectid==4070
replace ed_id=1304066 if objectid==1717

ren ed_id ed_id_t_1
ren hubdist dist_coast 
sort ed_id_t_1
keep ed_id_t_1 dist_coast
save "$ruta_data_panel/distance_to_coast.dta", replace

use "$ruta_data_large/panel_JAM_informality_storms_master_trnaspose_t_1_t_males.dta", clear
sort ed_id_t_1
merge m:1 ed_id_t_1 using "$ruta_data_panel/district distances to Kingston.dta"
drop if _merge==2
drop _merge
sort ed_id_t_1
merge m:1 ed_id_t_1 using "$ruta_data_panel/distance_to_coast.dta"
drop if _merge==2
drop _merge

replace dist_kingston=0 if dist_kingston==.
replace dist_coast=0 if dist_coast==.

save "$ruta_data_large/panel_JAM_informality_storms_master_trnaspose_t_1_t_males.dta", replace


*This part will integrate the info for non-hurricane storms and hurricanes to the master data.
use "$ruta_data_large/panel_JAM_informality_storms_master_trnaspose_t_1_t_males1.dta", clear
gen yq1=yq(year1,quar1)
gen yq2=yq(year2,quar2)

format yq1 yq2 %tq
drop if q21a_t_1==5 | q21a_t==5
drop if out_lf_t_1==1 | out_lf_t==1

keep iid_panel yq1 yq2 T_2Q_nh2_t_1 T_2Q_nh2_t T_2Q_nh1_t_1 T_2Q_nh1_t T_1Q_nh2_t_1 T_1Q_nh2_t T_1Q_nh1_t_1 T_1Q_nh1_t T_2Q_h2_t_1 T_2Q_h2_t T_2Q_h1_t_1 T_2Q_h1_t T_1Q_h2_t_1 T_1Q_h2_t T_1Q_h1_t_1 T_1Q_h1_t

sort iid_panel yq1 yq2
save "$ruta_data_large/NH_&_H.dta", replace


use "$ruta_data_large/panel_JAM_informality_storms_master_trnaspose_t_1_t_males.dta", clear
*distance to coast
sum dist_coast, d
gen coast=(dist_coast<=r(p50)) //lower than the 50th percentile

*Dropping full time at school individuals
drop if q21a_t_1==5 | q21a_t==5
drop if out_lf_t_1==1 | out_lf_t==1

gen yq1=yq(year1,quar1)
gen yq2=yq(year2,quar2)

format yq1 yq2 %tq

sort iid_panel yq1 yq2

merge 1:1 iid_panel yq1 yq2 using "$ruta_data_large/NH_&_H.dta"
tab _merge
drop _merge
save "$ruta_data_large/panel_JAM_informality_storms_master_trnaspose_t_1_t_males.dta", replace
*/
use "$ruta_data_large/panel_JAM_informality_storms_master_trnaspose_t_1_t_males.dta", clear
tabout yq1 yq2  using  "$ruta_data_panel/males_panel.xls" if sex_t!=.,cells(freq) format(0c) replace





*/
/*
*Setting up new categories.

*In this section I reduce the number of states to 4:

Unemployed:       unemployed_t_1 
Other employed:   unp_family_worker_t_1 own_acc_t_1
Informal:         inf_employee_nis_t_1 inf_employer_t_1 
Formal:           g_employee_t_1 f_employee_t_1 f_employer_t_1

*/
gen other_emplo_t_1=1 if unp_family_worker_t_1==1 | own_acc_t_1==1
replace other_emplo_t_1=0 if unp_family_worker_t_1==0 & own_acc_t_1==0
gen other_emplo_t=1 if unp_family_worker_t==1 | own_acc_t==1
replace other_emplo_t=0 if unp_family_worker_t==0 & own_acc_t==0

gen informal_t_1=1 if inf_employee_nis_t_1==1| inf_employer_t_1==1
replace informal_t_1=0 if inf_employee_nis_t_1==0& inf_employer_t_1==0
gen informal_t=1 if inf_employee_nis_t==1| inf_employer_t==1
replace informal_t=0 if inf_employee_nis_t==0& inf_employer_t==0

gen formal_t_1=1 if g_employee_t_1==1 | f_employee_t_1==1 | f_employer_t_1==1
replace formal_t_1=0 if g_employee_t_1==0& f_employee_t_1==0& f_employer_t_1==0
gen formal_t=1 if g_employee_t==1 | f_employee_t==1 | f_employer_t==1
replace formal_t=0 if g_employee_t==0& f_employee_t==0& f_employer_t==0

drop if other_emplo_t_1==1 |other_emplo_t==1 

*recode unemployed_t_1 informal_t_1 formal_t_1 (.=0) if sex_t==.
*Transitions: 
local row 0
matrix table1_3a=J(3,3,.)
global ls " unemployed_t_1 informal_t_1 formal_t_1" // Unemployed transitions are the same as before
foreach v in $ls {
local ++row
gen     `v'_u=1 if `v'==1 & unemployed_t==1
replace `v'_u=0 if `v'==1 & unemployed_t==0 & (informal_t==1 | formal_t==1)
sum `v'_u
matrix table1_3a[`row',1]=r(mean)

gen     `v'_i=1 if `v'==1 & informal_t==1
replace `v'_i=0 if `v'==1 & informal_t==0 &(unemployed_t==1|formal_t==1)
sum `v'_i
matrix table1_3a[`row',2]=r(mean)

gen     `v'_f=1 if `v'==1 & formal_t==1
replace `v'_f=0 if `v'==1 & formal_t==0 &(informal_t==1|unemployed_t==1)
sum `v'_f
matrix table1_3a[`row',3]=r(mean)
}

local row 0

*With attrition
matrix table1_3b=J(3,4,.)
global ls " unemployed_t_1 informal_t_1 formal_t_1" // Unemployed transitions are the same as before
foreach v in $ls {
local ++row
gen     `v'_u_m=1 if `v'==1 & unemployed_t==1
replace `v'_u_m=0 if `v'==1 & (unemployed_t==0|unemployed_t==.)
sum `v'_u_m
matrix table1_3b[`row',1]=r(mean)

gen     `v'_i_m=1 if `v'==1 & informal_t==1
replace `v'_i_m=0 if `v'==1 & (informal_t==0|informal_t==.)
sum `v'_i_m
matrix table1_3b[`row',2]=r(mean)

gen     `v'_f_m=1 if `v'==1 & formal_t==1
replace `v'_f_m=0 if `v'==1 & (formal_t==0|formal_t==.)
sum `v'_f_m
matrix table1_3b[`row',3]=r(mean)

gen     `v'_mis=1 if `v'_f_m==0 & `v'_i_m==0 &  `v'_u_m==0 
replace `v'_mis=0 if `v'_f_m==1 | `v'_i_m==1 |  `v'_u_m==1 
sum `v'_mis
matrix table1_3b[`row',4]=r(mean)

}






*Endogenous switching model
*1. Individual characteristics
*Age
gen age2_t_1=age_t_1*age_t_1
global age "age_t_1 age2_t_1"

*Education
gen no_qualif=1 if q322_t_1==1|q423_t_1==1|q516_t_1==1
gen other_qualif=1 if q322_t_1==2 |q423_t_1==2|q516_t_1==2|q322_t_1==9 |q423_t_1==9|q516_t_1==9
gen o_level=1 if q322_t_1==3|q322_t_1==4|q322_t_1==5 |q423_t_1==3|q423_t_1==4|q423_t_1==5  |q516_t_1==3|q516_t_1==4|q516_t_1==5
gen a_level=1 if q322_t_1==6|q322_t_1==7 |q423_t_1==6|q423_t_1==7  |q516_t_1==6|q516_t_1==6|q516_t_1==7
gen other_high_deg=1 if q322_t_1==8 |q423_t_1==8|q516_t_1==8

replace no_qualif=0 if no_qualif!=1 & (other_qualif==1| o_level==1| a_level==1| other_high_deg==1)
replace other_qualif=0 if other_qualif!=1 & (no_qualif==1| o_level==1| a_level==1| other_high_deg==1)
replace o_level=0 if o_level!=1 & (no_qualif==1| other_qualif==1| a_level==1| other_high_deg==1)
replace a_level=0 if a_level!=1 & (no_qualif==1| other_qualif==1| o_level==1| other_high_deg==1)
replace other_high_deg=0 if other_high_deg!=1 & (no_qualif==1| other_qualif==1| o_level==1| a_level==1)

recode no_qualif other_qualif o_level a_level other_high_deg (0=.) if q322_t_1==.&q423_t_1==.&q516_t_1==.

global education "no_qualif other_qualif o_level other_high_deg"


*Ocupation type 
gen     group_occup_t_1=.
replace group_occup_t_1=1 if q38m_t_1<2000
replace group_occup_t_1=2 if q38m_t_1>=2000 & q38m_t_1<3000
replace group_occup_t_1=3 if q38m_t_1>=3000 & q38m_t_1<4000
replace group_occup_t_1=4 if q38m_t_1>=4000 & q38m_t_1<5000
replace group_occup_t_1=5 if q38m_t_1>=5000 & q38m_t_1<6000
replace group_occup_t_1=6 if q38m_t_1>=6000 & q38m_t_1<7000
replace group_occup_t_1=7 if q38m_t_1>=7000 & q38m_t_1<8000
replace group_occup_t_1=8 if q38m_t_1>=8000 & q38m_t_1<9000
replace group_occup_t_1=9 if q38m_t_1>=9000


gen     group_occup_t=.
replace group_occup_t=1 if q38m_t<2000
replace group_occup_t=2 if q38m_t>=2000 & q38m_t<3000
replace group_occup_t=3 if q38m_t>=3000 & q38m_t<4000
replace group_occup_t=4 if q38m_t>=4000 & q38m_t<5000
replace group_occup_t=5 if q38m_t>=5000 & q38m_t<6000
replace group_occup_t=6 if q38m_t>=6000 & q38m_t<7000
replace group_occup_t=7 if q38m_t>=7000 & q38m_t<8000
replace group_occup_t=8 if q38m_t>=8000 & q38m_t<9000
replace group_occup_t=9 if q38m_t>=9000

label define group_occup ///
 1 "Legislators, Senior Officials and Managers" ///
 2 "Professionals" ///
 3 "Technicians and Associate Professionals" ///
 4 "Clerks"  ///
 5 "Service Workers and Shop and Market Sales Workers" ///
 6 "Skilled Agricultural and Fishery Workers" ///
 7 "Craft and Related Workers" ///
 8 "Plant and Machine Operators and Assemblers" ///
 9 "Elementary Occupations"
 
label values group_occup_t_1 group_occup

tab group_occup_t_1, gen(group_occup_t_1_)
gen professionals_t_1=group_occup_t_1_1
tab group_occup_t, gen(group_occup__t_)
gen professionals_t=group_occup__t_1






*Kingston
gen kingston_t_1=(iddist_t_1<200000)
gen kingston_t=(iddist_t<200000)


*Labor information
*work hours 
gen h_week_t_1=q33_t_1
gen h_week_t=q33_t


*Retention
*Panes definition
*Panel A first master sample 2004-2006
gen     panel_A=.
replace panel_A=1 if yq1==tq(2004q1)&yq2==tq(2004q4)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2004q4)&yq2==tq(2005q1)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2005q1)&yq2==tq(2005q4)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2005q4)&yq2==tq(2006q1)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2006q1)&yq2==tq(2006q4)&sex_t_1!=.&sex_t!=.
*Panel A second master sample 2007-2010
replace panel_A=1 if yq1==tq(2007q1)&yq2==tq(2007q4)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2007q4)&yq2==tq(2008q1)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2008q1)&yq2==tq(2008q4)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2008q4)&yq2==tq(2009q1)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2009q1)&yq2==tq(2009q4)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2009q4)&yq2==tq(2010q1)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2010q1)&yq2==tq(2010q4)&sex_t_1!=.&sex_t!=.
*Panel A third master sample 2012-2014
replace panel_A=1 if yq1==tq(2012q1)&yq2==tq(2012q4)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2012q4)&yq2==tq(2013q1)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2013q1)&yq2==tq(2013q4)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2013q4)&yq2==tq(2014q1)&sex_t_1!=.&sex_t!=.
replace panel_A=1 if yq1==tq(2014q1)&yq2==tq(2014q4)&sex_t_1!=.&sex_t!=.


sort iid_panel

by iid_panel: egen panel=max(panel_A)
drop panel_A
ren panel panel_A


*Panel C first master sample 2004-2006
gen     panel_C=.
replace panel_C=1 if yq1==tq(2004q1)&yq2==tq(2004q2)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2004q2)&yq2==tq(2005q1)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2005q1)&yq2==tq(2005q2)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2005q2)&yq2==tq(2006q1)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2006q1)&yq2==tq(2006q2)&sex_t_1!=.&sex_t!=.
*Panel C second master sample 2007-2010
replace panel_C=1 if yq1==tq(2007q1)&yq2==tq(2007q2)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2007q2)&yq2==tq(2008q1)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2008q1)&yq2==tq(2008q2)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2008q2)&yq2==tq(2009q1)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2009q1)&yq2==tq(2009q2)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2009q2)&yq2==tq(2010q1)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2010q1)&yq2==tq(2010q2)&sex_t_1!=.&sex_t!=.
*Panel C third master sample 2012-2014
replace panel_C=1 if yq1==tq(2012q1)&yq2==tq(2012q2)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2012q2)&yq2==tq(2013q1)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2013q1)&yq2==tq(2013q2)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2013q2)&yq2==tq(2014q1)&sex_t_1!=.&sex_t!=.
replace panel_C=1 if yq1==tq(2014q1)&yq2==tq(2014q2)&sex_t_1!=.&sex_t!=.

sort iid_panel

by iid_panel: egen panel=max(panel_C)
drop panel_C
ren panel panel_C


*Panel E first master sample 2004-2006
gen     panel_E=.
replace panel_E=1 if yq1==tq(2004q2)&yq2==tq(2004q3)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2004q3)&yq2==tq(2005q2)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2005q2)&yq2==tq(2005q3)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2005q3)&yq2==tq(2006q2)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2006q2)&yq2==tq(2006q3)&sex_t_1!=.&sex_t!=.
*Panel E second master sample 2007-2010
replace panel_E=1 if yq1==tq(2007q2)&yq2==tq(2007q3)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2007q3)&yq2==tq(2008q2)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2008q2)&yq2==tq(2008q3)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2008q3)&yq2==tq(2009q2)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2009q2)&yq2==tq(2009q3)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2009q3)&yq2==tq(2010q2)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2010q2)&yq2==tq(2010q3)&sex_t_1!=.&sex_t!=.
*Panel E third master sample 2012-2014
replace panel_E=1 if yq1==tq(2012q2)&yq2==tq(2012q3)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2012q3)&yq2==tq(2013q2)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2013q2)&yq2==tq(2013q3)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2013q3)&yq2==tq(2014q2)&sex_t_1!=.&sex_t!=.
replace panel_E=1 if yq1==tq(2014q2)&yq2==tq(2014q3)&sex_t_1!=.&sex_t!=.


sort iid_panel

by iid_panel: egen panel=max(panel_E)
drop panel_E
ren panel panel_E

*Panel G first master sample 2004-2006
gen     panel_G=.
replace panel_G=1 if yq1==tq(2004q3)&yq2==tq(2004q4)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2004q4)&yq2==tq(2005q3)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2005q3)&yq2==tq(2005q4)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2005q4)&yq2==tq(2006q3)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2006q3)&yq2==tq(2006q4)&sex_t_1!=.&sex_t!=.
*Panel E second master sample 2007-2010
replace panel_G=1 if yq1==tq(2007q3)&yq2==tq(2007q4)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2007q4)&yq2==tq(2008q3)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2008q3)&yq2==tq(2008q4)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2008q4)&yq2==tq(2009q3)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2009q3)&yq2==tq(2009q4)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2009q4)&yq2==tq(2010q3)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2010q3)&yq2==tq(2010q4)&sex_t_1!=.&sex_t!=.
*Panel E third master sample 2012-2014
replace panel_G=1 if yq1==tq(2012q3)&yq2==tq(2012q4)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2012q4)&yq2==tq(2013q3)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2013q3)&yq2==tq(2013q4)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2013q4)&yq2==tq(2014q3)&sex_t_1!=.&sex_t!=.
replace panel_G=1 if yq1==tq(2014q3)&yq2==tq(2014q4)&sex_t_1!=.&sex_t!=.


sort iid_panel

by iid_panel: egen panel=max(panel_G)
drop panel_G
ren panel panel_G


*Keeping only time-frames according to the rotational panel structure.
gen to_keep=.
replace to_keep=1 if panel_A==1 & ///
(yq1==tq(2004q1)&yq2==tq(2004q4) | ///
yq1==tq(2004q1)&yq2==tq(2005q1) | ///
yq1==tq(2004q4)&yq2==tq(2005q1) | ///
yq1==tq(2004q4)&yq2==tq(2005q4) | ///
yq1==tq(2005q1)&yq2==tq(2005q4) | ///
yq1==tq(2005q1)&yq2==tq(2006q1) | ///
yq1==tq(2005q4)&yq2==tq(2006q1) | ///
yq1==tq(2005q4)&yq2==tq(2006q4) | ///
yq1==tq(2006q1)&yq2==tq(2006q4) | ///
yq1==tq(2007q1)&yq2==tq(2007q4) | ///
yq1==tq(2007q1)&yq2==tq(2008q1) | ///
yq1==tq(2007q4)&yq2==tq(2008q1) | ///
yq1==tq(2007q4)&yq2==tq(2008q4) | ///
yq1==tq(2008q1)&yq2==tq(2008q4) | ///
yq1==tq(2008q1)&yq2==tq(2009q1) | ///
yq1==tq(2008q4)&yq2==tq(2009q1) | ///
yq1==tq(2008q4)&yq2==tq(2009q4) | ///
yq1==tq(2009q1)&yq2==tq(2009q4) | ///
yq1==tq(2009q1)&yq2==tq(2010q1) | ///
yq1==tq(2009q4)&yq2==tq(2010q1) | ///
yq1==tq(2009q4)&yq2==tq(2010q4) | ///
yq1==tq(2010q1)&yq2==tq(2010q4) | ///
yq1==tq(2012q1)&yq2==tq(2012q4) | ///
yq1==tq(2012q1)&yq2==tq(2013q1) | ///
yq1==tq(2012q4)&yq2==tq(2013q1) | ///
yq1==tq(2012q4)&yq2==tq(2013q4) | ///
yq1==tq(2013q1)&yq2==tq(2013q4) | ///
yq1==tq(2013q1)&yq2==tq(2014q1) | ///
yq1==tq(2013q4)&yq2==tq(2014q1) | ///
yq1==tq(2013q4)&yq2==tq(2014q4) | ///
yq1==tq(2014q1)&yq2==tq(2014q4) )

replace to_keep=1 if panel_C==1 & ///
(yq1==tq(2004q1)&yq2==tq(2004q2) | ///
yq1==tq(2004q1)&yq2==tq(2005q1) | ///
yq1==tq(2004q2)&yq2==tq(2005q1) | ///
yq1==tq(2004q2)&yq2==tq(2005q2) | ///
yq1==tq(2005q1)&yq2==tq(2005q2) | ///
yq1==tq(2005q1)&yq2==tq(2006q1) | ///
yq1==tq(2005q2)&yq2==tq(2006q1) | ///
yq1==tq(2005q2)&yq2==tq(2006q2) | ///
yq1==tq(2006q1)&yq2==tq(2006q2) | ///
yq1==tq(2007q1)&yq2==tq(2007q2) | ///
yq1==tq(2007q1)&yq2==tq(2008q1) | ///
yq1==tq(2007q2)&yq2==tq(2008q1) | ///
yq1==tq(2007q2)&yq2==tq(2008q2) | ///
yq1==tq(2008q1)&yq2==tq(2008q2) | ///
yq1==tq(2008q1)&yq2==tq(2009q1) | ///
yq1==tq(2008q2)&yq2==tq(2009q1) | ///
yq1==tq(2008q2)&yq2==tq(2009q2) | ///
yq1==tq(2009q1)&yq2==tq(2009q2) | ///
yq1==tq(2009q1)&yq2==tq(2010q1) | ///
yq1==tq(2009q2)&yq2==tq(2010q1) | ///
yq1==tq(2009q2)&yq2==tq(2010q2) | ///
yq1==tq(2010q1)&yq2==tq(2010q2) | ///
yq1==tq(2012q1)&yq2==tq(2012q2) | ///
yq1==tq(2012q1)&yq2==tq(2013q1) | ///
yq1==tq(2012q2)&yq2==tq(2013q1) | ///
yq1==tq(2012q2)&yq2==tq(2013q2) | ///
yq1==tq(2013q1)&yq2==tq(2013q2) | ///
yq1==tq(2013q1)&yq2==tq(2014q1) | ///
yq1==tq(2013q2)&yq2==tq(2014q1) | ///
yq1==tq(2014q1)&yq2==tq(2014q2) | ///
yq1==tq(2013q2)&yq2==tq(2014q2))

replace to_keep=1 if panel_E==1 & ///
(yq1==tq(2004q2)&yq2==tq(2004q3) | ///
yq1==tq(2004q2)&yq2==tq(2005q2) | ///
yq1==tq(2004q3)&yq2==tq(2005q2) | ///
yq1==tq(2004q3)&yq2==tq(2005q3) | ///
yq1==tq(2005q2)&yq2==tq(2005q3) | ///
yq1==tq(2005q2)&yq2==tq(2006q2) | ///
yq1==tq(2005q3)&yq2==tq(2006q2) | ///
yq1==tq(2005q3)&yq2==tq(2006q3) | ///
yq1==tq(2006q2)&yq2==tq(2006q3) | ///
yq1==tq(2007q2)&yq2==tq(2007q3) | ///
yq1==tq(2007q2)&yq2==tq(2008q2) | ///
yq1==tq(2007q3)&yq2==tq(2008q2) | ///
yq1==tq(2007q3)&yq2==tq(2008q3) | ///
yq1==tq(2008q2)&yq2==tq(2008q3) | ///
yq1==tq(2008q2)&yq2==tq(2009q2) | ///
yq1==tq(2008q3)&yq2==tq(2009q2) | ///
yq1==tq(2008q3)&yq2==tq(2009q3) | ///
yq1==tq(2009q2)&yq2==tq(2009q3) | ///
yq1==tq(2009q2)&yq2==tq(2010q2) | ///
yq1==tq(2009q3)&yq2==tq(2010q2) | ///
yq1==tq(2009q3)&yq2==tq(2010q3) | ///
yq1==tq(2010q2)&yq2==tq(2010q3) | ///
yq1==tq(2012q2)&yq2==tq(2012q3) | ///
yq1==tq(2012q2)&yq2==tq(2013q2) | ///
yq1==tq(2012q3)&yq2==tq(2013q2) | ///
yq1==tq(2012q3)&yq2==tq(2013q3) | ///
yq1==tq(2013q2)&yq2==tq(2013q3) | ///
yq1==tq(2013q2)&yq2==tq(2014q2) | ///
yq1==tq(2013q3)&yq2==tq(2014q2) | ///
yq1==tq(2013q3)&yq2==tq(2014q3) | ///
yq1==tq(2014q2)&yq2==tq(2014q3) )

replace to_keep=1 if panel_G==1 & ///
(yq1==tq(2004q3)&yq2==tq(2004q4) | ///
yq1==tq(2004q3)&yq2==tq(2005q3) | ///
yq1==tq(2004q4)&yq2==tq(2005q3) | ///
yq1==tq(2004q4)&yq2==tq(2005q4) | ///
yq1==tq(2005q3)&yq2==tq(2005q4) | ///
yq1==tq(2005q3)&yq2==tq(2006q3) | ///
yq1==tq(2005q4)&yq2==tq(2006q3) | ///
yq1==tq(2005q4)&yq2==tq(2006q4) | ///
yq1==tq(2006q3)&yq2==tq(2006q4) | ///
yq1==tq(2006q3)&yq2==tq(2007q3) | ///
yq1==tq(2007q3)&yq2==tq(2007q4) | ///
yq1==tq(2007q3)&yq2==tq(2008q3) | ///
yq1==tq(2007q4)&yq2==tq(2008q3) | ///
yq1==tq(2007q4)&yq2==tq(2008q4) | ///
yq1==tq(2008q3)&yq2==tq(2008q4) | ///
yq1==tq(2008q3)&yq2==tq(2009q3) | ///
yq1==tq(2008q4)&yq2==tq(2009q3) | ///
yq1==tq(2008q4)&yq2==tq(2009q4) | ///
yq1==tq(2009q3)&yq2==tq(2009q4) | ///
yq1==tq(2009q3)&yq2==tq(2010q3) | ///
yq1==tq(2009q4)&yq2==tq(2010q3) | ///
yq1==tq(2009q4)&yq2==tq(2010q4) | ///
yq1==tq(2010q3)&yq2==tq(2010q4) | ///
yq1==tq(2012q3)&yq2==tq(2012q4) | ///
yq1==tq(2012q3)&yq2==tq(2013q3) | ///
yq1==tq(2012q4)&yq2==tq(2013q3) | ///
yq1==tq(2012q4)&yq2==tq(2013q4) | ///
yq1==tq(2013q3)&yq2==tq(2013q4) | ///
yq1==tq(2013q3)&yq2==tq(2014q3) | ///
yq1==tq(2013q4)&yq2==tq(2014q3) | ///
yq1==tq(2013q4)&yq2==tq(2014q4) | ///
yq1==tq(2014q3)&yq2==tq(2014q4))







gen to_keep_m=.
replace to_keep_m=1 if panel_A==. &panel_C==.&panel_E==.&panel_G==. & ///
(yq1==tq(2004q1)&yq2==tq(2004q4) | ///
yq1==tq(2004q4)&yq2==tq(2005q1) | ///
yq1==tq(2005q1)&yq2==tq(2005q4) | ///
yq1==tq(2005q4)&yq2==tq(2006q1) | ///
yq1==tq(2006q1)&yq2==tq(2006q4) | ///
yq1==tq(2007q1)&yq2==tq(2007q4) | ///
yq1==tq(2007q4)&yq2==tq(2008q1) | ///
yq1==tq(2008q1)&yq2==tq(2008q4) | ///
yq1==tq(2008q4)&yq2==tq(2009q1) | ///
yq1==tq(2009q1)&yq2==tq(2009q4) | ///
yq1==tq(2009q4)&yq2==tq(2010q1) | ///
yq1==tq(2010q1)&yq2==tq(2010q4) | ///
yq1==tq(2012q1)&yq2==tq(2012q4) | ///
yq1==tq(2012q4)&yq2==tq(2013q1) | ///
yq1==tq(2013q1)&yq2==tq(2013q4) | ///
yq1==tq(2013q4)&yq2==tq(2014q1) | ///
yq1==tq(2014q1)&yq2==tq(2014q4) )

replace to_keep_m=1 if panel_A==. &panel_C==.&panel_E==.&panel_G==. & ///
(yq1==tq(2004q1)&yq2==tq(2004q2) | ///
yq1==tq(2004q2)&yq2==tq(2005q1) | ///
yq1==tq(2005q1)&yq2==tq(2005q2) | ///
yq1==tq(2005q2)&yq2==tq(2006q1) | ///
yq1==tq(2006q1)&yq2==tq(2006q2) | ///
yq1==tq(2007q1)&yq2==tq(2007q2) | ///
yq1==tq(2007q2)&yq2==tq(2008q1) | ///
yq1==tq(2008q1)&yq2==tq(2008q2) | ///
yq1==tq(2008q2)&yq2==tq(2009q1) | ///
yq1==tq(2009q1)&yq2==tq(2009q2) | ///
yq1==tq(2009q2)&yq2==tq(2010q1) | ///
yq1==tq(2010q1)&yq2==tq(2010q2) | ///
yq1==tq(2012q1)&yq2==tq(2012q2) | ///
yq1==tq(2012q2)&yq2==tq(2013q1) | ///
yq1==tq(2013q1)&yq2==tq(2013q2) | ///
yq1==tq(2013q2)&yq2==tq(2014q1) )

replace to_keep_m=1 if panel_A==. &panel_C==.&panel_E==.&panel_G==. & ///
(yq1==tq(2014q1)&yq2==tq(2014q2) | ///
yq1==tq(2004q2)&yq2==tq(2004q3) | ///
yq1==tq(2004q3)&yq2==tq(2005q2) | ///
yq1==tq(2005q2)&yq2==tq(2005q3) | ///
yq1==tq(2005q3)&yq2==tq(2006q2) | ///
yq1==tq(2006q2)&yq2==tq(2006q3) | ///
yq1==tq(2007q2)&yq2==tq(2007q3) | ///
yq1==tq(2007q3)&yq2==tq(2008q2) | ///
yq1==tq(2008q2)&yq2==tq(2008q3) | ///
yq1==tq(2008q3)&yq2==tq(2009q2) | ///
yq1==tq(2009q2)&yq2==tq(2009q3) | ///
yq1==tq(2009q3)&yq2==tq(2010q2) | ///
yq1==tq(2010q2)&yq2==tq(2010q3) | ///
yq1==tq(2012q2)&yq2==tq(2012q3) | ///
yq1==tq(2012q3)&yq2==tq(2013q2) | ///
yq1==tq(2013q2)&yq2==tq(2013q3) | ///
yq1==tq(2013q3)&yq2==tq(2014q2) | ///
yq1==tq(2014q2)&yq2==tq(2014q3) )

replace to_keep_m=1 if panel_A==. &panel_C==.&panel_E==.&panel_G==. & ///
(yq1==tq(2004q3)&yq2==tq(2004q4) | ///
yq1==tq(2004q4)&yq2==tq(2005q3) | ///
yq1==tq(2005q3)&yq2==tq(2005q4) | ///
yq1==tq(2005q4)&yq2==tq(2006q3) | ///
yq1==tq(2006q3)&yq2==tq(2006q4) | ///
yq1==tq(2007q3)&yq2==tq(2007q4) | ///
yq1==tq(2007q4)&yq2==tq(2008q3) | ///
yq1==tq(2008q3)&yq2==tq(2008q4) | ///
yq1==tq(2008q4)&yq2==tq(2009q3) | ///
yq1==tq(2009q3)&yq2==tq(2009q4) | ///
yq1==tq(2009q4)&yq2==tq(2010q3) | ///
yq1==tq(2010q3)&yq2==tq(2010q4) | ///
yq1==tq(2012q3)&yq2==tq(2012q4) | ///
yq1==tq(2012q4)&yq2==tq(2013q3) | ///
yq1==tq(2013q3)&yq2==tq(2013q4) | ///
yq1==tq(2013q4)&yq2==tq(2014q3) | ///
yq1==tq(2014q3)&yq2==tq(2014q4))




drop if to_keep_m==. & to_keep==. & sex_t==.



gen retention=(sex_t!=.)


*replace working_t=0 if informal_t==0&formal_t==0 &working_t==1


tab year1, gen(year1_) //Year FE
recode q312_t_1 (2=0)

gen dif_quar=yq2-yq1
gen rural_t_1=(urcode_t_1==3)


*drop if unemployed_t_1==1
*drop if unemployed_t==0 & working_t==0
*drop if informal_t_1==0 & formal_t_1==0
*drop if informal_t==0 & formal_t==0
*drop if working_t==0
*recode informal_t formal_t (0=.) if working_t==0  // If individual is unemployed (unemployed_t==1) there is no information regarding 
*Cross terms w.r.t. informal_t_1

foreach var in  professionals_t_1 T_1Q_as1_t T_1Q_as2_t T_2Q_as1_t T_2Q_as2_t group_occup_t_1_2 group_occup_t_1_3 group_occup_t_1_4 group_occup_t_1_5 group_occup_t_1_6 group_occup_t_1_7 group_occup_t_1_8 group_occup_t_1_9 rural_t_1 h_week_t_1 $age $education year1_1 year1_2 year1_3 year1_4 year1_5 year1_6 year1_7 year1_8 year1_9 year1_10{
gen `var'_f_t_1=`var'*working_t_1
}
global cross_term_f_t_1 "professionals_t_1_f_t_1 rural_t_1_f_t_1 h_week_t_1_f_t_1 age_t_1_f_t_1 age2_t_1_f_t_1 no_qualif_f_t_1 other_qualif_f_t_1 o_level_f_t_1 other_high_deg_f_t_1"
global strom_1Q_t_f_t_1 "T_1Q_as1_t_f_t_1 T_1Q_as2_t_f_t_1" 
global strom_2Q_t_f_t_1 "T_2Q_as1_t_f_t_1 T_2Q_as2_t_f_t_1"
global time_fe_f_t_1 "year1_1_f_t_1 year1_2_f_t_1 year1_3_f_t_1 year1_4_f_t_1 year1_5_f_t_1 year1_6_f_t_1 year1_7_f_t_1 year1_8_f_t_1 year1_9_f_t_1 "


foreach var in professionals_t_1 T_1Q_as1_t T_1Q_as2_t T_2Q_as1_t T_2Q_as2_t group_occup_t_1_2 group_occup_t_1_3 group_occup_t_1_4 group_occup_t_1_5 group_occup_t_1_6 group_occup_t_1_7 group_occup_t_1_8 group_occup_t_1_9 rural_t_1 h_week_t_1 $age $education  year1_1 year1_2 year1_3 year1_4 year1_5 year1_6 year1_7 year1_8 year1_9 year1_10{
gen `var'_i_t_1=`var'*unemployed_t_1
}

global cross_term_i_t_1 "professionals_t_1_i_t_1 rural_t_1_i_t_1 h_week_t_1_i_t_1 age_t_1_i_t_1 age2_t_1_i_t_1 no_qualif_i_t_1 other_qualif_i_t_1 o_level_i_t_1 other_high_deg_i_t_1"
global strom_1Q_t_i_t_1 "T_1Q_as1_t_i_t_1 T_1Q_as2_t_i_t_1" 
global strom_2Q_t_i_t_1 "T_2Q_as1_t_i_t_1 T_2Q_as2_t_i_t_1"
global time_fe_i_t_1 "year1_1_i_t_1 year1_2_i_t_1 year1_3_i_t_1 year1_4_i_t_1 year1_5_i_t_1 year1_6_i_t_1 year1_7_i_t_1 year1_8_i_t_1 year1_9_i_t_1 "
egen gend_year=concat(year1 unemployed_t_1)

tab gend_year, gen(gend_year_)

global yr_fe "year1_1_f_t_1 year1_2_f_t_1 year1_3_f_t_1 year1_4_f_t_1 year1_5_f_t_1 year1_6_f_t_1 year1_7_f_t_1 year1_8_f_t_1 year1_9_f_t_1 year1_1_i_t_1 year1_2_i_t_1 year1_3_i_t_1 year1_4_i_t_1 year1_5_i_t_1 year1_6_i_t_1 year1_7_i_t_1 year1_8_i_t_1 year1_9_i_t_1"





*Individuals with observations in the first semester for t-1 and in the second or in the firs of following year

gen inter_semestral=1 if (yq1==tq(2004q2) & (yq2==tq(2004q3)|yq2==tq(2004q4)|yq2==tq(2005q1)|yq2==tq(2005q2))) 
replace inter_semestral=1 if (yq1==tq(2004q3) & (yq2==tq(2004q4)|yq2==tq(2005q1)|yq2==tq(2005q2)))  
replace inter_semestral=1 if (yq1==tq(2004q4) & (yq2==tq(2005q1)|yq2==tq(2005q2)))  
replace inter_semestral=1 if (yq1==tq(2005q1) & (yq2==tq(2005q3)|yq2==tq(2005q4)|yq2==tq(2006q1)|yq2==tq(2006q2)))  
replace inter_semestral=1 if (yq1==tq(2005q2) & (yq2==tq(2005q3)|yq2==tq(2005q4)|yq2==tq(2006q1)|yq2==tq(2006q2)))  
replace inter_semestral=1 if (yq1==tq(2005q3) & (yq2==tq(2005q4)|yq2==tq(2006q1)|yq2==tq(2006q2)))  
replace inter_semestral=1 if (yq1==tq(2005q4) & (yq2==tq(2006q1)|yq2==tq(2006q2)))  
replace inter_semestral=1 if (yq1==tq(2006q1) & (yq2==tq(2006q3)|yq2==tq(2006q4)))  
replace inter_semestral=1 if (yq1==tq(2006q2) & (yq2==tq(2006q3)|yq2==tq(2006q4)))  
replace inter_semestral=1 if (yq1==tq(2007q1) & (yq2==tq(2007q3)|yq2==tq(2007q4)|yq2==tq(2008q1)|yq2==tq(2008q2)))  
replace inter_semestral=1 if (yq1==tq(2007q2) & (yq2==tq(2007q3)|yq2==tq(2007q4)|yq2==tq(2008q1)|yq2==tq(2008q2)))  
replace inter_semestral=1 if (yq1==tq(2007q3) & (yq2==tq(2008q1)|yq2==tq(2008q2)))  
replace inter_semestral=1 if (yq1==tq(2007q4) & (yq2==tq(2008q1)|yq2==tq(2008q2)))  
replace inter_semestral=1 if (yq1==tq(2008q1) & (yq2==tq(2008q3)|yq2==tq(2008q4)|yq2==tq(2009q1)|yq2==tq(2009q2)))  
replace inter_semestral=1 if (yq1==tq(2008q2) & (yq2==tq(2008q3)|yq2==tq(2008q4)|yq2==tq(2009q1)|yq2==tq(2009q2)))  
replace inter_semestral=1 if (yq1==tq(2008q3) & (yq2==tq(2009q1)|yq2==tq(2009q2))) 
replace inter_semestral=1 if (yq1==tq(2008q4) & (yq2==tq(2009q1)|yq2==tq(2009q2))) 
replace inter_semestral=1 if (yq1==tq(2009q1) & (yq2==tq(2009q3)|yq2==tq(2009q4)|yq2==tq(2010q1)|yq2==tq(2010q2)))  
replace inter_semestral=1 if (yq1==tq(2009q2) & (yq2==tq(2009q3)|yq2==tq(2009q4)|yq2==tq(2010q1)|yq2==tq(2010q2)))  
replace inter_semestral=1 if (yq1==tq(2009q3) & (yq2==tq(2010q1)|yq2==tq(2010q2)))  
replace inter_semestral=1 if (yq1==tq(2009q4) & (yq2==tq(2010q1)|yq2==tq(2010q2)))  
replace inter_semestral=1 if (yq1==tq(2010q1) & (yq2==tq(2010q3)|yq2==tq(2010q4)))  
replace inter_semestral=1 if (yq1==tq(2010q2) & (yq2==tq(2010q3)|yq2==tq(2010q4)))  
replace inter_semestral=1 if (yq1==tq(2012q1) & (yq2==tq(2012q3)|yq2==tq(2012q4)|yq2==tq(2013q1)|yq2==tq(2013q2)))  
replace inter_semestral=1 if (yq1==tq(2012q2) & (yq2==tq(2012q3)|yq2==tq(2012q4)|yq2==tq(2013q1)|yq2==tq(2013q2)))  
replace inter_semestral=1 if (yq1==tq(2012q3) & (yq2==tq(2013q1)|yq2==tq(2013q2)))  
replace inter_semestral=1 if (yq1==tq(2012q4) & (yq2==tq(2013q1)|yq2==tq(2013q2)))  
replace inter_semestral=1 if (yq1==tq(2013q1) & (yq2==tq(2013q3)|yq2==tq(2013q4)|yq2==tq(2014q1)|yq2==tq(2014q2)))  
replace inter_semestral=1 if (yq1==tq(2013q2) & (yq2==tq(2013q3)|yq2==tq(2013q4)|yq2==tq(2014q1)|yq2==tq(2014q2)))  
replace inter_semestral=1 if (yq1==tq(2013q3) & (yq2==tq(2014q1)|yq2==tq(2014q2))) 
replace inter_semestral=1 if (yq1==tq(2013q4) & (yq2==tq(2014q1)|yq2==tq(2014q2))) 
replace inter_semestral=1 if (yq1==tq(2014q1) & (yq2==tq(2014q3)|yq2==tq(2014q4))) 
replace inter_semestral=1 if (yq1==tq(2014q2) & (yq2==tq(2014q3)|yq2==tq(2014q4))) 


*District id
bysort iid_panel: egen iid_dist_unq=max(iddist_t)
save "$ruta_data_save/final_data_unem.dta", replace
-
do "/Users/camilojosepechagarzon/Dropbox/PhD Applied Economics/Paper 4/do files/Final estimation_rhos.do"
do "/Users/camilojosepechagarzon/Dropbox/PhD Applied Economics/Paper 4/do files/Final estimation_instruments validity.do"
do "/Users/camilojosepechagarzon/Dropbox/PhD Applied Economics/Paper 4/do files/Final estimation_MArginal effects.do"


