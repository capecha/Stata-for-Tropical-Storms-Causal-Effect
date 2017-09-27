/*
In this program I build the Destruction index proposed by Strobl 2012 following Boose et al. 2004.
The do file uses data from the storms' tracks and the position of Jamaica districts' centroids to obtain the wind filed model
and weighting by the population generate the destruction index.

*/


set more off

*Distance matrix
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix.dta", clear
*Distance 
drop distance
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1.dta", replace

*Storm attributes
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/X_Y_VectDir_st_2000_2009_500k.dta", clear

merge 1:1 shapeid using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/forward_veloc_st_2000_2009_500k.dta"
drop _merge

**Max wind speed
sort serial_num
merge m:1 serial_num using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/max_wind_spped_st_2000_2009.dta"
drop if _merge==2
drop _merge
gen double eventtime = clock(iso_time, "MD20Yhm")
bysort serial_num:egen double eventstart=min(eventtime)
bysort serial_num:egen double eventend=max(eventtime)

format eventtime eventstart eventend %tc

sort name eventtime
drop basin
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/storms_char.dta", replace
*Merge with districts
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix1.dta",clear
sort name eventtime
drop basin
merge m:1 name eventtime using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/storms_char.dta"
drop length iso_time sub_basin num length_storm_sect _merge

save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/distance matrix2.dta", replace


*Calculate parameters:
*V_m= max wind velocity
gen V_m= wmo_wind
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

ren angle T


*R the radial distance from the hurricane center to the district centroid
*The linear and spherical length are calculated

sphdist, lat1(y_dist) lon1(x_dist) lat2(y_storm) lon2(x_storm) gen(R)          // Spherical
gen R2=lngth_d_st  															   // Linear

*Rm (1) Rm = 20 km, B=1.5; (2) Rm =40km, B=1.4; (3) Rm =60km, B=1.3;and (4) Rm =80 km, B=1.2  Based on Boose et.al 2004

gen Rm1 = 20
gen B1=1.5

gen Rm2 =40
gen B2=1.4

gen Rm3 =60
gen B3=1.3

gen Rm4 =80
gen B4=1.2

* F is the scaling parameter for effects of friction (-water- 1 + -land- 0.8)/2=0.9  //\ Still to locate the coordinates that are on land
gen F=0.9

* G is the gust factor (-water- 1.2 + -land- 1.5)/2=1.35 //\ Still to locate the coordinates that are on land
gen G=1.35

* S is the scaling parameter for asymmetry due to forward motion of storm (1.0)
gen S=1.0

* Vh is the forward velocity of the storm
ren st_velocity Vh
/* 
Wind field model 

V=FG[V_m-S(1-sin(T))Vh/2][(Rm/R)^B exp(1-[Rm/R]^B)]^1/2
*/
gen V1=F*G*(V_m-S*(1-sin(T))*(Vh/2))*((Rm1/R)^B1*exp(1-(Rm1/R)^B1))^(1/2)
gen V2=F*G*(V_m-S*(1-sin(T))*(Vh/2))*((Rm2/R)^B2*exp(1-(Rm2/R)^B2))^(1/2)
gen V3=F*G*(V_m-S*(1-sin(T))*(Vh/2))*((Rm3/R)^B3*exp(1-(Rm3/R)^B3))^(1/2)
gen V4=F*G*(V_m-S*(1-sin(T))*(Vh/2))*((Rm4/R)^B4*exp(1-(Rm4/R)^B4))^(1/2)

sort objectid
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/wind_field_model.dta", replace

merge m:1 objectid using "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/districts_charact.dta"
replace ed_id=102051 if objectid==1975
replace ed_id=402006 if objectid==2549
replace ed_id=804056 if objectid==4826
replace ed_id=1104014 if objectid==4070
replace ed_id=1304066 if objectid==1717


*keep ed_id season name V1 V2 V3 V4 ed ed_class parish const_name total_male total_fema total_popu event

/*
Using the total population by district and the annual percentage rate growth of population
I create the variable w_d that weights the destruction index
The data is obtained from the Statisitcs institute of Jamaica  http://statinja.gov.jm/Demo_SocialStats/newSummaryofPopulationMovements.aspx  consulted on Jan 20/2016
annual percentage rate growth for 1991 to 2001 is 0.87 
annual percentage rate growth for 2001 to 2011 is 0.36 

*/

gen total_popu99=(total_popu*(1-0.082))*(1-0.082)
gen total_popu00=total_popu*(1-0.082)
gen total_popu01=total_popu
gen total_popu02=total_popu01*(1+0.036)
gen total_popu03=total_popu02*(1+0.036)
gen total_popu04=total_popu03*(1+0.036)
gen total_popu05=total_popu04*(1+0.036)
gen total_popu06=total_popu05*(1+0.036)
gen total_popu07=total_popu06*(1+0.036)
gen total_popu08=total_popu07*(1+0.036)
gen total_popu09=total_popu08*(1+0.036)
gen total_popu10=total_popu09*(1+0.036)

egen max_pop99=max(total_popu99)
egen max_pop00=max(total_popu00)
egen max_pop01=max(total_popu01)
egen max_pop02=max(total_popu02)
egen max_pop03=max(total_popu03)
egen max_pop04=max(total_popu04)
egen max_pop05=max(total_popu05)
egen max_pop06=max(total_popu06)
egen max_pop07=max(total_popu07)
egen max_pop08=max(total_popu08)
egen max_pop09=max(total_popu09)
egen max_pop10=max(total_popu10)



gen w_d=.
replace w_d=total_popu99/max_pop99 if season==2000
replace w_d=total_popu00/max_pop00 if season==2001
replace w_d=total_popu01/max_pop01 if season==2002
replace w_d=total_popu02/max_pop02 if season==2003
replace w_d=total_popu03/max_pop03 if season==2004
replace w_d=total_popu04/max_pop04 if season==2005
replace w_d=total_popu05/max_pop05 if season==2006
replace w_d=total_popu06/max_pop06 if season==2007
replace w_d=total_popu07/max_pop07 if season==2008
replace w_d=total_popu08/max_pop08 if season==2009
replace w_d=total_popu09/max_pop09 if season==2010

sum w_d

sort objectid serial_num
by objectid serial_num: egen wind1=total(V1)
by objectid serial_num: egen wind2=total(V2)
by objectid serial_num: egen wind3=total(V3)
by objectid serial_num: egen wind4=total(V4)

gen wind1_w=wind1*w_d
gen wind2_w=wind2*w_d
gen wind3_w=wind3*w_d
gen wind4_w=wind4*w_d

collapse (mean) wind1_w wind2_w wind3_w wind4_w w_d eventstart eventend,by(objectid ed_id serial_num season name)

save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", replace

keep if season==2000 & name=="HELENE"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2000_HELENE.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2003 & name=="CLAUDETTE"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2003_CLAUDETTE.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2004 & name=="BONNIE"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2004_BONNIE.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2004 & name=="CHARLEY"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2004_CHARLEY.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2004 & name=="IVAN"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2004_IVAN.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2005 & name=="DENNIS"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2005_DENNIS.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2005 & name=="GAMMA"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2005_GAMMA.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2006 & name=="CHRIS"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2006_CHRIS.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2006 & name=="ERNESTO"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2006_ERNESTO.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2007 & name=="DEAN"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2007_DEAN.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2007 & name=="FELIX"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2007_FELIX.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2008 & name=="FAY"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2008_FAY.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2008 & name=="GUSTAV"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2008_GUSTAV.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2008 & name=="IKE"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2008_IKE.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

keep if season==2010 & name=="BONNIE"
save "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/Destruction Index variable/destruction index_2010_BONNIE.dta", replace
use "/Users/camilojosepechagarzon/Documents/DATA/Jamaica/GIS/Hurricanes/Destruct ind test/To calculate DI/BAsic Info/Stata/destruction index.dta", clear

