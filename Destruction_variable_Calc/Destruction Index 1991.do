/*
In this program I build the Destruction index proposed by Strobl 2012 following Boose et al. 2004.
The do file uses data from the storms' tracks and the position of Jamaica districts' centroids to obtain the wind filed model
and weighting by the population generate the destruction index.

*/


set more off
*Importing data from CSV
*Distance matrix
import delimited "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/CSV/distance matrix_87_00_C1991.csv", clear
ren inputid objectid
ren targetid id2
drop distance
sort objectid
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991.dta", replace

import delimited "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/CSV/distance matrix_95_15_C1991.csv", clear
ren inputid objectid
ren targetid id2
drop distance
sort objectid
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991_1.dta", replace




*districts' x's and y's
import delimited "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/CSV/coor_dist_only_1991.csv", clear
keep x y ed_id id_ed shapeid

renvars x y id_ed \ x_dist y_dist objectid
sort objectid
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/coor_dist_only_1991.dta", replace

use  "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991.dta", clear
merge m:1 objectid using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/coor_dist_only_1991.dta"
sort objectid
drop _merge
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991.dta", replace

use  "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991_1.dta", clear
merge m:1 objectid using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/coor_dist_only_1991.dta"
sort objectid
drop _merge
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991_1.dta", replace





*districts' characteristics
import delimited "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/CSV/districts_charact_1991.csv", clear
sort objectid
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/districts_charact1991.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991.dta", clear
merge m:1 objectid using  "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/districts_charact1991.dta"
replace ed_id=204013 if shapeid==2085

replace name_1991="NC 47" if shapeid==2209
replace ed_id=204047 if shapeid==2209

replace name_1991="NC 48" if shapeid==2208
replace ed_id=204048 if shapeid==2208

replace ed_id=208095 if shapeid==2505
replace ed_id=502083 if shapeid==5059
replace ed_id=603019 if shapeid==1667
replace ed_id=804041 if shapeid==320

replace name_1991="S 6" if shapeid==3154
replace ed_id=1203006 if shapeid==3154

replace name_1991="NW 3" if shapeid==4768
replace ed_id=1302003 if shapeid==4768

replace ed_id=1401042 if shapeid==1354

replace name_1991="EC 49" if shapeid==1357
replace ed_id=1401049 if shapeid==1357

replace ed_id=1406055 if shapeid==675
replace ed_id=1406056 if shapeid==676
replace ed_id=1406059 if shapeid==677

drop _merge

save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991.dta", replace



use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991_1.dta", clear
merge m:1 objectid using  "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/districts_charact1991.dta"
replace ed_id=204013 if shapeid==2085

replace name_1991="NC 47" if shapeid==2209
replace ed_id=204047 if shapeid==2209

replace name_1991="NC 48" if shapeid==2208
replace ed_id=204048 if shapeid==2208

replace ed_id=208095 if shapeid==2505
replace ed_id=502083 if shapeid==5059
replace ed_id=603019 if shapeid==1667
replace ed_id=804041 if shapeid==320

replace name_1991="S 6" if shapeid==3154
replace ed_id=1203006 if shapeid==3154

replace name_1991="NW 3" if shapeid==4768
replace ed_id=1302003 if shapeid==4768

replace ed_id=1401042 if shapeid==1354

replace name_1991="EC 49" if shapeid==1357
replace ed_id=1401049 if shapeid==1357

replace ed_id=1406055 if shapeid==675
replace ed_id=1406056 if shapeid==676
replace ed_id=1406059 if shapeid==677

drop _merge

save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991_1.dta", replace








*Storm vectors
import delimited "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/CSV/storms_87_00_500k-nodes.csv", clear
sort id
drop shapeid
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/X_Y_VectDir_st_1987_2000_500k.dta", replace 



*Forward speed
import delimited "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/CSV/storms_87_00_500k-attributes.csv", clear
ren seg_lenght length_storm_sect 
gen st_velocity=length_storm_sect/6

keep st_velocity id serial_num
sort id
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/forward_veloc_st_1987_2000_500k.dta", replace

*Max wind speed
import delimited "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/CSV/storms_1987_2000_ to calc_max_windSpd.csv", clear
bysort serial_num:egen max_wind=max(wmo_wind)
sort serial_num
gen double eventtime = clock(iso_time, "YMDhms")
bysort serial_num:egen double eventstart=min(eventtime)
bysort serial_num:egen double eventend=max(eventtime)

format eventtime eventstart eventend %tc
drop if serial_num==serial_num[_n-1]
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/max_wind_spped_st_1987_2000.dta",replace


*Distance matrix





*Storm attributes
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/X_Y_VectDir_st_1987_2000_500k.dta", clear

merge m:1 id using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/forward_veloc_st_1987_2000_500k.dta"
drop _merge

**Max wind speed
sort serial_num
merge m:1 serial_num using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/max_wind_spped_st_1987_2000.dta", force

drop if _merge==2
drop _merge

sort name eventtime
drop basin
sort id2
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/storms_char_1987_2000.dta", replace

*Merge with districts
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991.dta",clear
sort id2
merge m:1 id2 using  "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/storms_char_1987_2000.dta"
sort ed_id id2
by ed_id :drop if id==id[_n-1]
drop  iso_time sub_basin num  _merge id2  center wmo_wind_ wmo_pres_ track_type ///
hda_grade hda_wind hda_pres td9_grade td9_wind td9_pres reu_grade reu_wind reu_pres atc_grade atc_wind atc_pres mlc_grade /// 
mlc_wind mlc_pres dss_grade dss_wind dss_pres dsi_grade dsi_wind dsi_pres bom_grade bom_wind bom_pres dsa_grade dsa_wind  ///
dsa_pres jts_grade jts_wind jts_pres jtw_grade jtw_wind jtw_pres td5_grade td5_wind td5_pres dsw_grade dsw_wind dsw_pres  ///
jti_grade jti_wind jti_pres cma_grade cma_wind cma_pres hde_grade hde_wind hde_pres jte_grade jte_wind jte_pres dse_grade  ///
dse_wind dse_pres jtc_grade jtc_wind jtc_pres jma_grade jma_wind jma_pres neu_grade neu_wind neu_pres hko_grade hko_wind  ///
hko_pres cph_grade cph_wind cph_pres nz_grade nz_wind nz_pres imd_grade imd_wind imd_pres nad_grade nad_wind nad_pres  ///
reu_rmw reu_wr1_ne reu_wr1_se reu_wr1_sw reu_wr1_nw reu_wr2_ne reu_wr2_se reu_wr2_sw reu_wr2_nw bom_hurrad bom_galrad  ///
bom_eye bom_roci atc_rmw atc_poci atc_roci atc_eye atc_w34_r1 atc_w34_r2 atc_w34_r3 atc_w34_r4 atc_w50_r1 atc_w50_r2  ///
atc_w50_r3 atc_w50_r4 atc_w64_r1 atc_w64_r2 atc_w64_r3 atc_w64_r4 jma_dir50 jma_long50 jma_shrt50 jma_dir30 jma_long30  ///
jma_shrt30 jtx_rmw jtx_poci jtx_roci jtx_eye jtx_w34_r1 jtx_w34_r2 jtx_w34_r3 jtx_w34_r4 jtx_w50_r1 jtx_w50_r2 jtx_w50_r3  ///
jtx_w50_r4 jtx_w64_r1 jtx_w64_r2 jtx_w64_r3 jtx_w64_r4 year month day hour min v15

save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991 2.dta", replace


use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/X_Y_VectDir_st_2000_2014_500k_95_14.dta", clear

merge m:1 id using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/forward_veloc_st_1995_2014_500k_95_14.dta"
drop _merge

**Max wind speed
sort serial_num
merge m:1 serial_num using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/max_wind_spped_st_1995_2014.dta", force

drop if _merge==2
drop _merge

sort name eventtime
drop basin
sort id2
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/storms_char_1987_2014.dta", replace

*Merge with districts
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991_1.dta",clear
sort id2
merge m:1 id2 using  "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/storms_char_1987_2014.dta"
sort ed_id id2
by ed_id :drop if id==id[_n-1]
drop  iso_time sub_basin num  _merge id2  center wmo_wind_ wmo_pres_ track_type ///
hda_grade hda_wind hda_pres td9_grade td9_wind td9_pres reu_grade reu_wind reu_pres atc_grade atc_wind atc_pres mlc_grade /// 
mlc_wind mlc_pres dss_grade dss_wind dss_pres dsi_grade dsi_wind dsi_pres bom_grade bom_wind bom_pres dsa_grade dsa_wind  ///
dsa_pres jts_grade jts_wind jts_pres jtw_grade jtw_wind jtw_pres td5_grade td5_wind td5_pres dsw_grade dsw_wind dsw_pres  ///
jti_grade jti_wind jti_pres cma_grade cma_wind cma_pres hde_grade hde_wind hde_pres jte_grade jte_wind jte_pres dse_grade  ///
dse_wind dse_pres jtc_grade jtc_wind jtc_pres jma_grade jma_wind jma_pres neu_grade neu_wind neu_pres hko_grade hko_wind  ///
hko_pres cph_grade cph_wind cph_pres nz_grade nz_wind nz_pres imd_grade imd_wind imd_pres nad_grade nad_wind nad_pres  ///
reu_rmw reu_wr1_ne reu_wr1_se reu_wr1_sw reu_wr1_nw reu_wr2_ne reu_wr2_se reu_wr2_sw reu_wr2_nw bom_hurrad bom_galrad  ///
bom_eye bom_roci atc_rmw atc_poci atc_roci atc_eye atc_w34_r1 atc_w34_r2 atc_w34_r3 atc_w34_r4 atc_w50_r1 atc_w50_r2  ///
atc_w50_r3 atc_w50_r4 atc_w64_r1 atc_w64_r2 atc_w64_r3 atc_w64_r4 jma_dir50 jma_long50 jma_shrt50 jma_dir30 jma_long30  ///
jma_shrt30 jtx_rmw jtx_poci jtx_roci jtx_eye jtx_w34_r1 jtx_w34_r2 jtx_w34_r3 jtx_w34_r4 jtx_w50_r1 jtx_w50_r2 jtx_w50_r3  ///
jtx_w50_r4 jtx_w64_r1 jtx_w64_r2 jtx_w64_r3 jtx_w64_r4 year month day hour min 

keep if season>2000
append using  "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991 2.dta"




save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1991 2_2.dta", replace


*Calculate parameters:
*V_m= max wind velocity
gen V_m= max_wind
/*
T=the clockwise angle between the storm's track and the radial distance between storm's eye and the district's centroid
To calculate "T" I need:
1. the coordinates for districts' centroid:

x_dist y_dist

2. the coordinates for the initial point of each segment in the storm's track

x_storm y_storm

3. the address of the vector between the district and the storm eye
3.a if district is above the storm's track district - storm
*/
gen x_d_s=.
replace x_d_s=x_dist-x_storm if y_dist>y_storm
gen y_d_s=.
replace y_d_s=y_dist-y_storm if y_dist>y_storm
/*
3.b if district is below the storm's track storm - district
*/
replace x_d_s=x_storm-x_dist if y_dist<=y_storm
replace y_d_s=y_storm-y_dist if y_dist<=y_storm

/*
4.the address of the segment of storm's track   

x_dir_storm y_dir_storm


5. Lenght of each segment in the storm's track
*/
gen len_s_t=sqrt(x_dir_storm^2+y_dir_storm^2)
/*
6. the length of the vector between the district's centroid and the initial point of each segment in the storm's track
*/
gen lngth_d_st=sqrt(x_d_s^2+y_d_s^2)

/*
**To calculate the angle T we use the Cosine formula

COS(T)= ((x_d_s*x_dir_storm)+(y_d_s*y_dir_storm))/ (lngth_d_st*lngth_st_s_trck)
*/
*Dot product and lengths
*First, I use the coordinates from the district and the ones that define each component in the storm's track
gen x1=x_storm+x_dir_storm
gen y1=y_storm+y_dir_storm
gen x2=x_storm
gen y2=y_storm
gen x3=x_dist
gen y3=y_dist

gen dot_prod=.
replace dot_prod=(x3*x1)-(x3*x2)-(x2*x1)+(x2^2)+(y3*y1)-(y3*y2)-(y2*y1)+y2^2
gen lengths=.
replace  lengths=sqrt((x3-x2)^2+(y3-y2)^2)*sqrt((x1-x2)^2+(y1-y2)^2)

gen uno=dot_prod/lengths

*Angle T
gen angle=acos(uno)*(180/_pi)
*Condition for districts located to the left of the storm's forward path:
*latitude for the district must be below the latitude of the initial coordinate for each track segment
*latitude for the track segment's end coordinate must be above the correspondent latitude for the radial line between the district and the initial coordinate of the segment 
gen y_line=((y3-y2)/(x3-x2))*(x1-x2)+y2 // this define the latitud correspondent to the line between the district and the initial segment's coordinate.
replace angle=360-angle if y_dist<=y_storm & y_dist<=y1 & y_line<=y1
replace angle=0 if angle==360
ren angle T


*R the radial distance from the hurricane center to the district centroid
*The linear and spherical length are calculated

sphdist, lat1(y_dist) lon1(x_dist) lat2(y_storm) lon2(x_storm) gen(R)          // Spherical
gen R2=lngth_d_st  															   // Linear

*Rm (1) Rm = 20 km, B=1.5; (2) Rm =40km, B=1.4; (3) Rm =60km, B=1.3;and (4) Rm =80 km, B=1.2  Based on Boose et.al 2004

*gen Rm1 = 20
*gen B1=1.5

*gen Rm2 =40
*gen B2=1.4

gen Rm3 =50 //These are the parameters from Strobl 2012 citing Boose et al.(2004)
gen B3=1.3

*gen Rm4 =80
*gen B4=1.2


* F is the scaling parameter for effects of friction (-water- 1 + -land- 0.8)
gen y_line_inland=((y2-y1)/(x2-x1))*(x_dist-x1)+y1
replace y_line_inland=y2 if x2==x1
xtile sect_x= x_dist, n(1000)
bysort sect_x: egen upper_jam_limit=max(y_dist)
bysort sect_x: egen lower_jam_limit=min(y_dist)
gen inland=(y_line_inland<= upper_jam_limit &y_line_inland>= lower_jam_limit & x_dist<= x2 & x_dist>= x1)

gen F=(inland==0)
replace F=0.8 if F==0

* G is the gust factor (-water- 1.2 + -land- 1.5)
gen G=1.2 if inland==0
replace G=1.5 if inland==1

* S is the scaling parameter for asymmetry due to forward motion of storm (1.0)
gen S=1.0

* Vh is the forward velocity of the storm
ren st_velocity Vh
/* 
Wind field model 

V=FG[V_m-S(1-sin(T))Vh/2][(Rm/R)^B exp(1-[Rm/R]^B)]^1/2
*/
*gen V1=F*G*(V_m-S*(1-sin(T))*(Vh/2))*((Rm1/R)^B1*exp(1-(Rm1/R)^B1))^(1/2)
*gen V2=F*G*(V_m-S*(1-sin(T))*(Vh/2))*((Rm2/R)^B2*exp(1-(Rm2/R)^B2))^(1/2)
gen V=F*G*(V_m-S*(1-sin(T))*(Vh/2))*((Rm3/R)^B3*exp(1-(Rm3/R)^B3))^(1/2)
*gen V4=F*G*(V_m-S*(1-sin(T))*(Vh/2))*((Rm4/R)^B4*exp(1-(Rm4/R)^B4))^(1/2)

sort ed_id
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/wind_field_model1991.dta", replace

*Using only storms between 2000 and 2012

drop if season>2012


*keep ed_id season name V1 V2 V3 V4 ed ed_class parish const_name total_male total_fema total_popu event

/*
Using the total population by district and the annual percentage rate growth of population
I create the variable w_d that weights the destruction index
The data is obtained from the Statisitcs institute of Jamaica  http://statinja.gov.jm/Demo_SocialStats/newSummaryofPopulationMovements.aspx  consulted on Jan 20/2016
annual percentage rate growth for 1991 to 2001 is 0.87 
annual percentage rate growth for 2001 to 2011 is 0.36 



gen total_popu99_i=(total_popu*(1-0.082))*(1-0.082)
gen total_popu00_i=total_popu*(1-0.082)
gen total_popu01_i=total_popu
gen total_popu02_i=total_popu01*(1+0.036)
gen total_popu03_i=total_popu02*(1+0.036)
gen total_popu04_i=total_popu03*(1+0.036)
gen total_popu05_i=total_popu04*(1+0.036)
gen total_popu06_i=total_popu05*(1+0.036)
gen total_popu07_i=total_popu06*(1+0.036)
gen total_popu08_i=total_popu07*(1+0.036)
gen total_popu09_i=total_popu08*(1+0.036)
gen total_popu10_i=total_popu09*(1+0.036)
gen total_popu11_i=total_popu10*(1+0.036)
gen total_popu12_i=total_popu11*(1+0.036)

egen max_pop99=max(total_popu99_i)
egen max_pop00=max(total_popu00_i)
egen max_pop01=max(total_popu01_i)
egen max_pop02=max(total_popu02_i)
egen max_pop03=max(total_popu03_i)
egen max_pop04=max(total_popu04_i)
egen max_pop05=max(total_popu05_i)
egen max_pop06=max(total_popu06_i)
egen max_pop07=max(total_popu07_i)
egen max_pop08=max(total_popu08_i)
egen max_pop09=max(total_popu09_i)
egen max_pop10=max(total_popu10_i)
egen max_pop11=max(total_popu11_i)
egen max_pop12=max(total_popu12_i)

egen total_popu99=total(total_popu99_i)
egen total_popu00=total(total_popu00_i)
egen total_popu01=total(total_popu01_i)
egen total_popu02=total(total_popu02_i)
egen total_popu03=total(total_popu03_i)
egen total_popu04=total(total_popu04_i)
egen total_popu05=total(total_popu05_i)
egen total_popu06=total(total_popu06_i)
egen total_popu07=total(total_popu07_i)
egen total_popu08=total(total_popu08_i)
egen total_popu09=total(total_popu09_i)
egen total_popu10=total(total_popu10_i)
egen total_popu11=total(total_popu11_i)
egen total_popu12=total(total_popu12_i)


gen w_d1=. //this is the relative weight with respect to the district with the largest population
replace w_d1=total_popu99_i/max_pop99 if season==2000
replace w_d1=total_popu00_i/max_pop00 if season==2001
replace w_d1=total_popu01_i/max_pop01 if season==2002
replace w_d1=total_popu02_i/max_pop02 if season==2003
replace w_d1=total_popu03_i/max_pop03 if season==2004
replace w_d1=total_popu04_i/max_pop04 if season==2005
replace w_d1=total_popu05_i/max_pop05 if season==2006
replace w_d1=total_popu06_i/max_pop06 if season==2007
replace w_d1=total_popu07_i/max_pop07 if season==2008
replace w_d1=total_popu08_i/max_pop08 if season==2009
replace w_d1=total_popu09_i/max_pop09 if season==2010
replace w_d1=total_popu10_i/max_pop10 if season==2011
replace w_d1=total_popu11_i/max_pop11 if season==2012

gen w_d2=. //this is the weight as share of each district's population of the total population
replace w_d2=total_popu99_i/total_popu99 if season==2000
replace w_d2=total_popu00_i/total_popu00 if season==2001
replace w_d2=total_popu01_i/total_popu01 if season==2002
replace w_d2=total_popu02_i/total_popu02 if season==2003
replace w_d2=total_popu03_i/total_popu03 if season==2004
replace w_d2=total_popu04_i/total_popu04 if season==2005
replace w_d2=total_popu05_i/total_popu05 if season==2006
replace w_d2=total_popu06_i/total_popu06 if season==2007
replace w_d2=total_popu07_i/total_popu07 if season==2008
replace w_d2=total_popu08_i/total_popu08 if season==2009
replace w_d2=total_popu09_i/total_popu09 if season==2010
replace w_d2=total_popu10_i/total_popu10 if season==2011
replace w_d2=total_popu11_i/total_popu11 if season==2012
*/
sort ed_id serial_num
*by objectid serial_num: egen wind1=total(V1)
*by objectid serial_num: egen wind2=total(V2)
by ed_id serial_num: egen wind1=total(V^3)  //based on Strobl et. al 2012, the threshold above which winds are considered to be of hurricane strength, equal to 119 km/hr.
by ed_id serial_num: egen wind2=total(V^3) if V_m>=119  //based on Strobl et. al 2015, the threshold above which winds are considered to be of hurricane strength, equal to 119 km/hr.

*by objectid serial_num: egen wind4=total(V4)
sum wind*

*gen wind1_w=wind1*w_d
*gen wind2_w=wind2*w_d
gen wind11=wind1
*gen wind12w=(wind1)*w_d1
*gen wind13w=(wind1)*w_d2

*Using the wind field model from those storms with maximum winds faster then 119 Km/h
gen wind21=wind2
*gen wind22w=(wind2)*w_d1
*gen wind23w=(wind2)*w_d2
*gen wind4_w=wind4*w_d

collapse (mean) wind11 wind21 eventstart eventend V_m,by(ed_id serial_num season name)
gen census=1991
sort ed_id
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta", replace

*running the program to build the destruction index using the 2011 census and to find same districts in that data

*do "/Volumes/Transcend/Other DATA/Hurricanes/Destruct ind test/To calculate DI/Destruction Index 2011.do"

*Smallest distance to coast
import delimited "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/CSV/distance to coast 1991.csv", clear
gen shapeid=id_ed-1

replace ed_id=204013 if shapeid==2085

replace name_1991="NC 47" if shapeid==2209
replace ed_id=204047 if shapeid==2209

replace name_1991="NC 48" if shapeid==2208
replace ed_id=204048 if shapeid==2208

replace ed_id=208095 if shapeid==2505
replace ed_id=502083 if shapeid==5059
replace ed_id=603019 if shapeid==1667
replace ed_id=804041 if shapeid==320

replace name_1991="S 6" if shapeid==3154
replace ed_id=1203006 if shapeid==3154

replace name_1991="NW 3" if shapeid==4768
replace ed_id=1302003 if shapeid==4768

replace ed_id=1401042 if shapeid==1354

replace name_1991="EC 49" if shapeid==1357
replace ed_id=1401049 if shapeid==1357

replace ed_id=1406055 if shapeid==675
replace ed_id=1406056 if shapeid==676
replace ed_id=1406059 if shapeid==677
keep ed_id hubdist
ren hubdist dist_coast
save "$ruta_save/distance to coast 1991.dta", replace


use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			
merge m:1 ed_id using "$ruta_save/distance to coast 1991.dta"
tab _merge
drop if _merge!=3
drop _merge
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta", replace


*This part of the program will split the whole database by year/storm

keep if season==1987 & name=="UNNAMED" &serial_num=="1987249N13297"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_87_U	season_87_U	name_87_U	wind11_87_U   wind21_87_U eventstart_87_U	eventend_87_U V_m_87_U 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1987_UNNAMED_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1987 & name=="EMILY"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_87_E	season_87_E	name_87_E	wind11_87_E   wind21_87_E eventstart_87_E	eventend_87_E V_m_87_E 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1987_EMILY_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1987 & name=="FLOYD"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_87_F	season_87_F	name_87_F	wind11_87_F   wind21_87_F eventstart_87_F	eventend_87_F V_m_87_F 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1987_FLOYD_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1987 & name=="UNNAMED"	&serial_num=="1987305N17283"																				
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_87_U1	season_87_U1	name_87_U1	wind11_87_U1   wind21_87_U1 eventstart_87_U1	eventend_87_U1 V_m_87_U1 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1987_UNNAMED1_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			




keep if season==1988 & name=="SIX:UNNAMED"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_88_S	season_88_S	name_88_S	wind11_88_S   wind21_88_S eventstart_88_S	eventend_88_S V_m_88_S 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1988_SIXUNNAMED_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1988 & name=="CHRIS"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_88_C	season_88_C	name_88_C	wind11_88_C   wind21_88_C eventstart_88_C	eventend_88_C V_m_88_C 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1988_CHRIS_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1988 & name=="GILBERT"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_88_G	season_88_G	name_88_G	wind11_88_G   wind21_88_G eventstart_88_G	eventend_88_G V_m_88_G 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1988_GILBERT_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1988 & name=="KEITH"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_88_K	season_88_K	name_88_K	wind11_88_K   wind21_88_K eventstart_88_K	eventend_88_K V_m_88_K 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1988_KEITH_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			


keep if season==1990 & name=="ARTHUR"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_90_A	season_90_A	name_90_A	wind11_90_A   wind21_90_A eventstart_90_A	eventend_90_A V_m_90_A 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1990_ARTHUR_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1990 & name=="MARCO"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_90_M	season_90_M	name_90_M	wind11_90_M   wind21_90_M eventstart_90_M	eventend_90_M V_m_90_M 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1990_MARCO_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			


keep if season==1994 & name=="GORDON"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_94_G	season_94_G	name_94_G	wind11_94_G   wind21_94_G eventstart_94_G	eventend_94_G V_m_94_G 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1994_GORDON_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			


keep if season==1995 & name=="ROXANNE"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_95_R	season_95_R	name_95_R	wind11_95_R   wind21_95_R eventstart_95_R	eventend_95_R V_m_95_R 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1995_ROXANNE_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			


keep if season==1996 & name=="DOLLY"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_96_D	season_96_D	name_96_D	wind11_96_D   wind21_96_D eventstart_96_D	eventend_96_D V_m_96_D 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1996_DOLLY_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1996 & name=="LILI"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_96_L	season_96_L	name_96_L	wind11_96_L   wind21_96_L eventstart_96_L	eventend_96_L V_m_96_L 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1996_LILI_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1996 & name=="MARCO"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_96_M	season_96_M	name_96_M	wind11_96_M   wind21_96_M eventstart_96_M	eventend_96_M V_m_96_M 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1996_MARCO_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			


keep if season==1998 & name=="GEORGES"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_98_G	season_98_G	name_98_G	wind11_98_G   wind21_98_G eventstart_98_G	eventend_98_G V_m_98_G 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1998_GEORGES_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1998 & name=="MITCH"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_98_M	season_98_M	name_98_M	wind11_98_M   wind21_98_M eventstart_98_M	eventend_98_M V_m_98_M 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1998_MITCH_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			


keep if season==1999 & name=="IRENE"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_99_I	season_99_I	name_99_I	wind11_99_I   wind21_99_I eventstart_99_I	eventend_99_I V_m_99_I 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1999_IRENE_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==1999 & name=="LENNY"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_99_L	season_99_L	name_99_L	wind11_99_L   wind21_99_L eventstart_99_L	eventend_99_L V_m_99_L 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_1999_LENNY_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			


keep if season==2000 & name=="DEBBY"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_00_D	season_00_D	name_00_D	wind11_00_D   wind21_00_D eventstart_00_D	eventend_00_D V_m_00_D 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2000_DEBBY_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2000 & name=="HELENE"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_00_H	season_00_H	name_00_H	wind11_00_H   wind21_00_H eventstart_00_H	eventend_00_H V_m_00_H 
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2000_HELENE_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			


keep if season==2001 & name=="CHANTAL"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_01_C	season_01_C	name_01_C	wind11_01_C   wind21_01_C  		eventstart_01_C	eventend_01_C V_m_01_C
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2001_CHANTAL_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2001 & name=="IRIS"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_01_I	season_01_I	name_01_I	wind11_01_I   wind21_01_I  		eventstart_01_I	eventend_01_I V_m_01_I
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2001_IRIS_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2002 & name=="ISIDORE"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_02_I	season_02_I	name_02_I	wind11_02_I   wind21_02_I  		eventstart_02_I	eventend_02_I V_m_02_I
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2002_ISIDORE_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2002 & name=="LILI"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_02_L	season_02_L	name_02_L	wind11_02_L   wind21_02_L  		eventstart_02_L	eventend_02_L V_m_02_L
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2002_LILI_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2002 & name=="UNNAMED"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_02_U	season_02_U	name_02_U	wind11_02_U   wind21_02_U  		eventstart_02_U	eventend_02_U V_m_02_U
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2002_UNNAMED_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2003 & name=="CLAUDETTE"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_03_C	season_03_C	name_03_C	wind11_03_C   wind21_03_C  		eventstart_03_C	eventend_03_C V_m_03_C																					
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2003_CLAUDETTE_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2003 & name=="ODETTE"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_03_O	season_03_O	name_03_O	wind11_03_O   wind21_03_O  		eventstart_03_O	eventend_03_O V_m_03_O																																										
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2003_ODETTE_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2004 & name=="BONNIE"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_04_B	season_04_B	name_04_B	wind11_04_B   wind21_04_B  		eventstart_04_B	eventend_04_B V_m_04_B																							
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2004_BONNIE_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2004 & name=="CHARLEY"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_04_C	season_04_C	name_04_C	wind11_04_C   wind21_04_C  		eventstart_04_C	eventend_04_C V_m_04_C																																												
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2004_CHARLEY_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2004 & name=="IVAN"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_04_I	season_04_I	name_04_I	wind11_04_I   wind21_04_I  		eventstart_04_I	eventend_04_I V_m_04_I																																																																	
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2004_IVAN_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2004 & name=="JEANNE"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_04_J	season_04_J	name_04_J	wind11_04_J   wind21_04_J  		eventstart_04_J	eventend_04_J V_m_04_J																																																																	
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2004_JEANNE_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2005 & name=="ALPHA"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_05_A	season_05_A	name_05_A	wind11_05_A   wind21_05_A  		eventstart_05_A	eventend_05_A V_m_05_A																																																																	
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2005_ALPHA_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2005 & name=="DENNIS"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_05_D	season_05_D	name_05_D	wind11_05_D   wind21_05_D  		eventstart_05_D	eventend_05_D V_m_05_D																																																																	
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2005_DENNIS_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2005 & name=="EMILY"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_05_E	season_05_E	name_05_E	wind11_05_E   wind21_05_E  		eventstart_05_E	eventend_05_E V_m_05_E																																																																	
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2005_EMILY_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2005 & name=="GAMMA"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_05_G	season_05_G	name_05_G	wind11_05_G   wind21_05_G  		eventstart_05_G	eventend_05_G V_m_05_G																																																																	
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2005_GAMMA_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2005 & name=="WILMA"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_05_W	season_05_W	name_05_W	wind11_05_W   wind21_05_W  		eventstart_05_W	eventend_05_W V_m_05_W																																																																	
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2005_WILMA_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2006 & name=="CHRIS"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_06_C	season_06_C	name_06_C	wind11_06_C   wind21_06_C  		eventstart_06_C	eventend_06_C V_m_06_C																																																																	
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2006_CHRIS_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			

keep if season==2006 & name=="ERNESTO"																					
renvars	serial_num	season	name	wind11   wind21  	eventstart	eventend V_m	/	serial_num_06_E	season_06_E	name_06_E	wind11_06_E   wind21_06_E  		eventstart_06_E	eventend_06_E V_m_06_E																																																																	
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2006_ERNESTO_1991.dta",replace																			
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index_1991.dta",clear																			









											