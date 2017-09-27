*Camilo Pecha - October 2016*
******************** PLUGIN ***********************************
/*Conditioning
*equation is 
1. \phi_2(xb1, xb2) if retention==0
2. \phi_3(xb1, xb2, xb3) if retention==1 
3. \phi_4(xb1, xb2, xb3)/\Phi(xb2) if retention==1 and informal in t-1
4. \phi_4(xb1, xb2, xb3)/\Phi(-xb2) if retention==1 and formal in t-1

*/
capture program drop myll_cond
program define myll_cond
	args lnf xb1 xb2 xb3 xb4 c21 c31 c32 c41 c42 c43   
	tempvar sp0 sp10 sp11  k1 k2 k3 k4
quietly {
	gen double `k1' = 2*$ML_y1 - 1          // Informal_t_1
	gen double `k2' = 2*$ML_y2 - 1	        // Retention
	gen double `k3' = 2*$ML_y3 - 1	        // Employed
	gen double `k4' = 2*$ML_y4 - 1	        // Informal_t

	tempname cf21 cf22 cf31 cf32 cf33 cf41 cf42 cf43 cf44 C2 C3 C4


	su `c21', meanonly		
	scalar  `cf21' = r(mean)

	su `c31', meanonly		
	scalar  `cf31' = r(mean)
	su `c32', meanonly		
	scalar  `cf32' = r(mean)

	su `c41', meanonly		
	scalar  `cf41' = r(mean)
	su `c42', meanonly		
	scalar  `cf42' = r(mean)
	su `c43', meanonly		
	scalar  `cf43' = r(mean)
	

* constraints on diagonal elements
	scalar `cf22' = sqrt( 1 - `c21'^2 )
	scalar `cf33' = sqrt( 1 - `c31'^2 - `c32'^2 )
	scalar `cf44' = sqrt( 1 - `c41'^2 - `c42'^2 - `c43'^2)

	mat `C2' = (1, 0  \ `cf21', `cf22')
	mat `C3' = (1, 0, 0  \ `cf21', `cf22', 0 \ `cf31',`cf32', `cf33')
	mat `C4' = (1, 0, 0, 0  \ `cf21', `cf22', 0, 0 \ `cf31',`cf32', `cf33', 0 \ `cf41',`cf42', `cf43', `cf44')


	egen double `sp0' = mvnp(`xb1' `xb2' ) if   $ML_y2==0, chol(`C2') dr($dr) prefix(z) signs(`k1' `k2') // if retention is 0, the visible information is only for initial period 

	egen double `sp10' = mvnp(`xb1' `xb2' `xb3' ) if  $ML_y2==1&$ML_y3==0 , chol(`C3') dr($dr) prefix(z) signs(`k1' `k2' `k3') // Ret==1 and working_t==0

	egen double `sp11' = mvnp(`xb1' `xb2' `xb3' `xb4') if  $ML_y2==1&$ML_y3==1 , chol(`C4') dr($dr) prefix(z) signs(`k1' `k2' `k3' `k4') // Ret==1 and working_t==1

	replace `lnf'= ln(`sp0') if    $ML_y2==0
	replace `lnf'= ln(`sp10') if   $ML_y2==1&$ML_y3==0
	replace `lnf'= ln(`sp11') if   $ML_y2==1&$ML_y3==1   

}
end

	
	