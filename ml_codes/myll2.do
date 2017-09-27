
******************** PLUGIN ***********************************
/*Conditioning
*equation is 
1. \phi_2(xb1, xb2) if working==0
2. \phi_3(xb1, xb2, xb3) if working==1 

*/
capture program drop myll_cond2
program define myll_cond2
	args lnf xb1 xb2 xb3  c21 c31 c32    
	tempvar sp0 sp10 sp11  k1 k2 k3 
quietly {
	gen double `k1' = 2*$ML_y1 - 1          // Informal_t_1
	gen double `k2' = 2*$ML_y2 - 1	        // Employed
	gen double `k3' = 2*$ML_y3 - 1	        // Informal_t

	tempname cf21 cf22 cf31 cf32 cf33  C2 C3 


	su `c21', meanonly		
	scalar  `cf21' = r(mean)

	su `c31', meanonly		
	scalar  `cf31' = r(mean)
	su `c32', meanonly		
	scalar  `cf32' = r(mean)

	

* constraints on diagonal elements
	scalar `cf22' = sqrt( 1 - `c21'^2 )
	scalar `cf33' = sqrt( 1 - `c31'^2 - `c32'^2 )

	mat `C2' = (1, 0  \ `cf21', `cf22')
	mat `C3' = (1, 0, 0  \ `cf21', `cf22', 0 \ `cf31',`cf32', `cf33')


	egen double `sp0' = mvnp(`xb1' `xb2' ) if   $ML_y2==0, chol(`C2') dr($dr) prefix(z) signs(`k1' `k2') // if working is 0, the visible information is only for initial period 

	egen double `sp10' = mvnp(`xb1' `xb2' `xb3' ) if  $ML_y2==1 , chol(`C3') dr($dr) prefix(z) signs(`k1' `k2' `k3') // working_t==1


	replace `lnf'= ln(`sp0') if    $ML_y2==0
	replace `lnf'= ln(`sp10') if   $ML_y2==1

}
end

	
	