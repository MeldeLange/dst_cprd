*Sensitivity 11: Power calcs (using standard errors) for Negative Control Regressions
************************************************************************************

*We can calculate the power of our estimates by the following formula, we will have 80% power at 95% level of significance to detect effects outside of the following range:
*Lower limit:exp(-1.96*SE IRR)
*Upper limit: exp(1.96*SE IRR)
*We are not powered to detect IRR bigger than the lower limit or smaller than upper limit.

*********************************************************************

*1a) Autumn 
************

cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined"

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Autumn_allyearsregions_2.dta", clear

*Negative Binomial Regression comparing the mean daily number of events in the weeks after the negative control to all other weeks, adjusting for day of the week & region.
di "`outcome': Autumn"
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)
matrix irr= r(table)[1, 2] // Row 1, column 2: irr
matrix lci =r(table)[5, 2] // row 5, column 2 = lower ci
matrix uci =r(table)[6, 2] // row 6, column 2 = upper ci
matrix stderr = r(table)[2, 2] // Row 2: Standard errors
svmat irr // Save irr
svmat lci // Save lower ci
svmat uci // save upper ci
svmat stderr // Save standard error
keep irr1 lci1 uci1 stderr1
keep if _n ==1
gen outcome = "`outcome'" 
gen season ="Autumn"
gen lower = -1.96*stderr1
gen upper = 1.96*stderr1
gen exp_lower= exp(lower)
gen exp_upper= exp(upper)
gen suff_powered = 0
replace suff_powered = 1 if irr1 <= exp_lower | irr1 >= exp_upper
order outcome season irr1 lci1 uci1 stderr1
save "projectnumber\analysis\power_calcs\negative_control/`outcome'_Autumn.dta", replace

	}

	
	
	

*1b) Spring
**********
clear
cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	use "`outcome'_Spring_allyearsregions_easter_2.dta", clear
*Negative Binomial Regression comparing the mean daily number of events in the weeks after the negative control to all other weeks, adjusting for day of the week & region.
di "`outcome': Spring"
nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region)
matrix list r(table)
matrix irr= r(table)[1, 2] // Row 1, column 2: irr
matrix lci =r(table)[5, 2] // row 5, column 2 = lower ci
matrix uci =r(table)[6, 2] // row 6, column 2 = upper ci
matrix stderr = r(table)[2, 2] // Row 2: Standard errors
svmat irr // Save irr
svmat lci // Save lower ci
svmat uci // save upper ci
svmat stderr // Save standard error
keep irr1 lci1 uci1 stderr1
keep if _n ==1
gen outcome = "`outcome'" 
gen season ="Spring"
gen lower = -1.96*stderr1
gen upper = 1.96*stderr1
gen exp_lower= exp(lower)
gen exp_upper= exp(upper)
gen suff_powered = 0
replace suff_powered = 1 if irr1 <= exp_lower | irr1 >= exp_upper
order outcome season irr1 lci1 uci1 stderr1
save "projectnumber\analysis\power_calcs\negative_control/`outcome'_Spring.dta", replace
 }

 
 
 *********************************************************************

*1c) Append all files.
clear
cd "projectnumber\analysis\power_calcs\negative_control"
ssc install fs
fs "*.dta*"
foreach f in `r(files)' {
	append using `f'
}
	export excel using "power_negative_control.xlsx", firstrow(variables) replace
	


