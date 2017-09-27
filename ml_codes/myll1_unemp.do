*Camilo Pecha - October 2016*
******************** PLUGIN ***********************************
/*Conditioning
*equation is 
1. \phi_2(xb1, xb2) if retention==0
2. \phi_3(xb1, xb2, xb3) if retention==1 
3. \phi_4(xb1, xb2, xb3)/\Phi(xb2) if retention==1 and informal in t-1
4. \phi_4(xb1, xb2, xb3)/\Phi(-xb2) if retention==1 and formal in t-1

*/
capture program drop myll1_unemp
program define myll1_unemp
	args lnf xb1 xb2 c21   
	tempvar sp0 sp10  k1 k2 
quietly {
	gen double `k1' = 2*$ML_y1 - 1          // unemployed_t_1
	gen double `k2' = 2*$ML_y2 - 1	        // Working_t

	tempname cf21 cf22 C2 


	su `c21', meanonly		
	scalar  `cf21' = r(mean)


	

* constraints on diagonal elements
	scalar `cf22' = sqrt( 1 - `c21'^2 )

	mat `C2' = (1, 0  \ `cf21', `cf22')



	egen double `sp0' = mvnp(`xb1' `xb2') , chol(`C2') dr($dr) prefix(z) signs(`k1' `k2') // if retention is 0, the visible information is only for initial period 



	replace `lnf'= ln(`sp0') 
}
end

	
	