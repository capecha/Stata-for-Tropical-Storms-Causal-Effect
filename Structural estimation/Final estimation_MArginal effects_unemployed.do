*Estimations
clear all
capture log close
set more off
set processors 4
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
global tables "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/Tables/Working"

use "$ruta_data_save/final_data_unem.dta", clear

preserve
keep if dif_quar==3 | dif_quar==4

replace informal_t=. if informal_t==0&formal_t==0&working_t==1
*Transition matrix - Only group C
tab informal_t_1 informal_t
tabout informal_t_1 informal_t  using "$tables/GroupC.xls", ///
cells(row) format(1) clab(Row_%) ///
replace 

*Transition matrix - group B
gen     inf_unemp_t=0 if informal_t==0
replace inf_unemp_t=1 if informal_t==1
replace inf_unemp_t=2 if unemployed_t==1 & informal_t==0 & formal_t==0
tab informal_t_1 inf_unemp_t
tabout informal_t_1 inf_unemp_t  using "$tables/GroupB.xls", ///
cells(row) format(1) clab(Row_%) ///
replace 

*Transition matrix - group A
gen     inf_ret_t=0 if informal_t==0
replace inf_ret_t=1 if informal_t==1
replace inf_ret_t=2 if unemployed_t==1 & informal_t==0 & formal_t==0
replace inf_ret_t=3 if retention==0 & sex_t==.
tab informal_t_1 inf_ret_t
tabout informal_t_1 inf_ret_t  using "$tables/GroupA.xls", ///
cells(row) format(1) clab(Row_%) ///
replace 


*Transition matrix - group A
gen     inf_nd_t=0 if informal_t==0
replace inf_nd_t=1 if informal_t==1
replace inf_nd_t=2 if unemployed_t==1 & informal_t==0 & formal_t==0
replace inf_nd_t=3 if retention==0 & sex_t==.
replace inf_nd_t=4 if informal_t==.&working_t==1
tab informal_t_1 inf_nd_t
tabout informal_t_1 inf_nd_t  using "$tables/non_response.xls", ///
cells(row) format(1) ///
replace 

restore




log using "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/Log files/mle_final_MEff.log", append 

set rmsg on
*This model is conditional on being formal in t-1, how storms from 1Q befor t-survey affect pr(informal in t) if individual was informal in t-1
*Only individual with observations one quester apart  

********************************************************
********************************************************
********************************************************
***ML PROGRAMMING 
********************************************************
********************************************************
********************************************************

do "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/ml_codes/myll1_unemp.do"

 
*keep if inter_semestral==1
*keep if dif_quar>=2

*The initial paramenter values are extracted from an iterative process where I run the ml model 239 time and each time I updated the new parameters obtained 
*after each iteration. The initial parameters for the first iteration come from the estimation of individual probits, one per equation.

*the number of draws is equal to the square root of the sample size (138674)~372	
*
	probit working_t_1         T_1Q_as1_t_1 T_1Q_as2_t_1 T_2Q_as1_t_1 T_2Q_as2_t_1  rural_t_1  year1_1-year1_10 $age $education dist_avg_altitude_t_1
	mat b1 = e(b)
	mat coleq b1 = working_t_1

    probit unemployed_t     unemployed_t_1 working_t_1    $strom_1Q_t_i_t_1 $strom_1Q_t_f_t_1   $strom_2Q_t_i_t_1 $strom_2Q_t_f_t_1 $cross_term_i_t_1 $cross_term_f_t_1  $yr_fe
	mat b2 = e(b)
	mat coleq b2 = unemployed_t

	mat b0 = b1, b2

*estimates use "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/ml_final2.ster"
*matrix b0=e(b)'
mdraws, dr(1) neq(2) prefix(z) random seed(9999) antithetics replace
global dr = r(n_draws)
egen iid_dist_unqq=concat(iid_dist_unq year1 year2 iid_panel)
ml model lf myll1_unemp (working_t_1:            working_t_1=      T_1Q_as1_t_1 T_1Q_as2_t_1 T_2Q_as1_t_1 T_2Q_as2_t_1  rural_t_1  year1_1-year1_10 $age $education dist_avg_altitude_t_1   )      ///
                        (unemployed_t:          unemployed_t=         unemployed_t_1 working_t_1    $strom_1Q_t_i_t_1 $strom_1Q_t_f_t_1   $strom_2Q_t_i_t_1 $strom_2Q_t_f_t_1 $cross_term_i_t_1 $cross_term_f_t_1  $yr_fe )             ///
                       /c21   , title("MV Probit by MSL, $dr pseudo-random draws") vce(cluster iid_dist_unq) 
ml init b0
ml max, diff iter(20) 
estimates save "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/ml_final2_unem.ster", replace
/
matrix b=e(b)'

*Marginal effects program
do "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/gen_data_figure_ME_storm_x_f_t_1_240_May_2017.do"




*restore
log close
do "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/Final estimation_rhos.do"
do "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/Final estimation_instruments validity.do"

