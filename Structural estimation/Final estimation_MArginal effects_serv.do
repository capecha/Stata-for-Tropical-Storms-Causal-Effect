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

use "$ruta_data_save/final_data.dta", clear

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

do "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/ml_codes/myll1.do"
keep if q39m_t_1>=5000& q39m_t_1<6000 // keeping workers in the services sector that were initially formal employees
 preserve
*keep if inter_semestral==1
*keep if dif_quar>=2

*The initial paramenter values are extracted from an iterative process where I run the ml model 239 time and each time I updated the new parameters obtained 
*after each iteration. The initial parameters for the first iteration come from the estimation of individual probits, one per equation.

*the number of draws is equal to the square root of the sample size (138674)~372	
*estimates use "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/ml_final2.ster"
	probit informal_t_1          T_1Q_as1_t_1   T_1Q_as2_t_1      T_2Q_as1_t_1   T_2Q_as2_t_1  rural_t_1  year1_1-year1_10  professionals_t_1  h_week_t_1 $age $education q312_t_1
	mat b1 = e(b)
	mat coleq b1 = informal_t_1

	probit retention             T_1Q_as1_t_1   T_1Q_as2_t_1      T_2Q_as1_t_1   T_2Q_as2_t_1  rural_t_1  year1_1-year1_10                                $age $education dist_kingston
	mat b2 = e(b)
	mat coleq b2 = retention

	probit working_t             T_1Q_as1_t_1   T_1Q_as2_t_1      T_2Q_as1_t_1   T_2Q_as2_t_1  rural_t_1  year1_1-year1_10                                $age $education dist_avg_altitude_t_1
	mat b3 = e(b)
	mat coleq b3 = working_t

    probit informal_t     informal_t_1  formal_t_1  $strom_1Q_t_i_t_1 $strom_1Q_t_f_t_1   $strom_2Q_t_i_t_1 $strom_2Q_t_f_t_1 $cross_term_i_t_1 $cross_term_f_t_1  $yr_fe
	mat b4 = e(b)
	mat coleq b4 = informal_t

	mat b0 = b1, b2, b3, b4

*matrix b0=e(b)'

*loop to determine initial values for the optimal measure of normal draws
foreach i in 2 10 168   {
mdraws, dr(`i') neq(4) prefix(z) random seed(123456789) antithetics replace
global dr = r(n_draws)
ml model lf myll_cond (informal_t_1:   informal_t_1=       T_1Q_as1_t_1   T_1Q_as2_t_1      T_2Q_as1_t_1   T_2Q_as2_t_1  rural_t_1  year1_1-year1_10  professionals_t_1  h_week_t_1 $age $education q312_t_1)      ///
                      (retention:      retention =         T_1Q_as1_t_1   T_1Q_as2_t_1      T_2Q_as1_t_1   T_2Q_as2_t_1  rural_t_1  year1_1-year1_10                                $age $education dist_kingston)                  ///
                      (working_t:      working_t=          T_1Q_as1_t_1   T_1Q_as2_t_1      T_2Q_as1_t_1   T_2Q_as2_t_1  rural_t_1  year1_1-year1_10                                $age $education dist_avg_altitude_t_1)              ///
                      (informal_t:     informal_t=    informal_t_1  formal_t_1  $strom_1Q_t_i_t_1 $strom_1Q_t_f_t_1   $strom_2Q_t_i_t_1 $strom_2Q_t_f_t_1 $cross_term_i_t_1 $cross_term_f_t_1  $yr_fe )             ///
                       /c21 /c31 /c32 /c41 /c42 /c43 , title("MV Probit by MSL, $dr pseudo-random draws") vce(cluster iid_dist_unq) 
ml init b0


/*
ml init -7.58663E-09	4.09248E-16	-7.10038E-09	3.38398E-16	0.44397831	0.269716859	0.190465569	0.175369978	0.094474323	0.051786624	0.056396738	0.0963796 ///
   	    0.007607348	-0.024729466	0	0.05208772	0.00602357	-0.00865251	7.40206E-05	1.239154577	0.442949772	0.312550843	-0.205199853	0.147652119	-1.804360867 ///
   		2.39671E-08	-9.43681E-16	-5.97953E-09	-5.58943E-17	-0.114873841	-0.195314482	-0.018376494	-0.148867622	0.036289986	-0.104433313	///
   		-0.120647773	-0.019711863	-0.253144979	-0.211164564	0	-0.031230446	0.00032069	0.167200893	0.086159095	0.134305581	0.110554323	0.002731539	///
   		3.442712307	-1.3682E-08	8.54712E-16	-1.3654E-08	4.90591E-16	-0.071972631	0.06907887	0.176863387	0.459145784	0.073518425	-0.097181313	-0.016088922	///
   		0.034635536	-0.088023037	0.009256927	0	0.064247951	-0.00064013	-0.401286453	-0.200229034	-0.085949011	0.324608356	9.40312E-05	0.472284675	///
   		1.070602775	0	-8.38579E-09	4.80018E-16	-1.22582E-08	5.94367E-16	-1.21877E-08	6.79663E-16	-7.08684E-11	1.3238E-16	0.100548439	0.322730184	///
   		0.004683514	0.005874835	5.05077E-07	1.000183702	0.621669412	0.555890679	0.119926274	0.048797008	0.187106743	0.006162817	-0.027746137	0.000243637	///
   		0.760407448	0.272535384	0.151296884	-0.118448913	0.291844904	0.255205303	0.046133865	0.272855222	0.297088414	0.135256201	0.164866805	0.231030479	///
   		0.2361646	-0.180674836	-0.159634486	-0.071688227	-0.149439052	-0.090607807	-0.080851391	-0.164600223	-0.214436144	-0.121191241	///
   		-1.698137283	-0.019270139	-0.165958866	-0.073208861	0.07490176	-0.201649502	-0.514809251, copy
 */  		
ml max, diff iter(20) 
matrix b0=e(b)'
} 

-
estimates save "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/ml_final_serv.ster", replace

matrix b=e(b)'

*Marginal effects program
do "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/gen_data_figure_ME_storm_x_f_t_1_240_May_2017.do"




*restore
log close
do "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/Final estimation_rhos.do"
do "/Users/camilojosepechagarzon/Documents/PhD Applied Economics/Paper 4/do files/Final estimation_instruments validity.do"

