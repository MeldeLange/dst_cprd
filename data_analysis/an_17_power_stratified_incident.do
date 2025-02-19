* Analysis 17 - Calculating the power of our one week regressions, stratified by incident vs prevalent case, using the standard errors.
*****************************************************************************************************************************

*We can calculate the power of our estimates by the following formula, we will have 80% power at 95% level of significance to detect effects outside of the following range:
*Lower limit:exp(-1.96*SE IRR)
*Upper limit: exp(1.96*SE IRR)
*We are not powered to detect IRR bigger than the lower limit or smaller than upper limit.


*1a) Autumn
**********
clear
foreach mod in incident{
	cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\22_002468\analysis\stratified\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy selfharm sleep{
		foreach category in 0 1 2 3{
			
local filenames: dir "." files "`outcome'_Autumn_allyearsregions_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
capture { // For some analyses convergence is not achieved so have to use capture to get whole loop to run.
*Negative Binomial Regression comparing the mean daily number of events in the weeks after the clock change to all other weeks, adjusting for day of the week & region.
di "`outcome'" "Autumn: `mod':`category'"
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
gen mod = "`mod'"
gen cat = "`category'"
gen lower = -1.96*stderr1
gen upper = 1.96*stderr1
gen exp_lower= exp(lower)
gen exp_upper= exp(upper)
gen suff_powered = 0
replace suff_powered = 1 if irr1 <= exp_lower | irr1 >= exp_upper
replace suff_powered = . if stderr1 ==.
order outcome season mod cat irr1 lci1 uci1 stderr1
 save "projectnumber\analysis\power_calcs\stratified\`mod'/`outcome'_Autumn_`mod'_`category'.dta", replace
 }
		}
}
}
}
*********************************************************************************************

*1b) Spring
**********
clear
foreach mod in incident{
	cd "projectnumber\analysis\stratified\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy selfharm sleep{
		foreach category in 0 1 2 3{
			
local filenames: dir "." files "`outcome'_Spring_allyearsregions_easter_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
capture { // For some analyses convergence is not achieved so have to use capture to get whole loop to run.
*Negative Binomial Regression comparing the mean daily number of events in the weeks after the clock change to all other weeks, adjusting for day of the week & region.
di "`outcome'" "Spring: `mod':`category'"
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
gen mod = "`mod'"
gen cat = "`category'"
gen lower = -1.96*stderr1
gen upper = 1.96*stderr1
gen exp_lower= exp(lower)
gen exp_upper= exp(upper)
gen suff_powered = 0
replace suff_powered = 1 if irr1 <= exp_lower | irr1 >= exp_upper
replace suff_powered = . if stderr1 ==.
order outcome season mod cat irr1 lci1 uci1 stderr1
 save "projectnumber\analysis\power_calcs\stratified\`mod'/`outcome'_Spring_`mod'_`category'.dta", replace
 }
		}
}
}
}


*********************************************************************

*1c) Append all files.
clear
cd "projectnumber\analysis\power_calcs\stratified\incident"
ssc install fs
fs "*.dta*"
foreach f in `r(files)' {
	append using `f'
}
	export excel using "power_stratified_incident.xlsx", firstrow(variables) replace
	