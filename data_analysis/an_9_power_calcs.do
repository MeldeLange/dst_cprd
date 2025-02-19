*Analysis 9: Calculating the power of our estimates using the standard errors
*****************************************************************************

*We can calculate the power of our estimates by the following formula, we will have 80% power at 95% level of significance to detect effects outside of the following range:
*Lower limit:exp(-1.96*SE IRR)
*Upper limit: exp(1.96*SE IRR)
*We are not powered to detect IRR bigger than the lower limit or smaller than upper limit.

************************************************************************

*1. 1, 2 and 4 weeks, and Monday-Friday analyses
**************************************************


*1a) Autumn - weeks/weekdays
******************************

cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach analysis in onewk_after twowk_after fourwk_after wkdays_onewkafter {
use "`outcome'_Autumn_allyearsregions2.dta", clear

*Negative Binomial Regression comparing the mean daily number of events in the weeks after the clock change to all other weeks, adjusting for day of the week & region.
di "`outcome'" "Autumn: `analysis'"
nbreg count i.`analysis' i.days i.region, irr vce(cluster region) 
matrix list r(table)
matrix irr= r(table)[1, 2] // Row 1: irr
matrix stderr = r(table)[2, 2] // Row 2: Standard errors
svmat irr // Save irr
svmat stderr // Save standard error
keep irr1 stderr1
keep if _n ==1
gen outcome = "`outcome'" 
gen season ="Autumn"
gen analysis = "`analysis'"
gen lower = -1.96*stderr1
gen upper = 1.96*stderr1
gen exp_lower= exp(lower)
gen exp_upper= exp(upper)
gen suff_powered = 0
replace suff_powered = 1 if irr1 <= exp_lower | irr1 >= exp_upper
order outcome season analysis irr1 stderr1
save "projectnumber\analysis\power_calcs\region_adjusted\weeks/`outcome'_Autumn_`analysis'.dta", replace

	}
}


***************

*1b) Spring - weeks/weekdays
******************************

cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach analysis in onewk_after twowk_after fourwk_after wkdays_onewkafter {
use "`outcome'_Spring_regions_easter2.dta", clear

*Negative Binomial Regression comparing the mean daily number of events in the weeks after the clock change to all other weeks, adjusting for day of the week, region & the Easter weekend.

di "`outcome'" "Spring: `analysis'"
nbreg count i.`analysis' i.days i.easter_wkend i.region, irr vce(cluster region) // count = outcome. onewk_after = exposure. days = covariate. easter_wkend = covariate.
matrix list r(table) // displays results inc the full p value.
matrix irr= r(table)[1, 2] // Row 1: irr
matrix stderr = r(table)[2, 2] // Row 2: Standard errors
svmat irr // Save irr
svmat stderr // Save standard error
keep irr1 stderr1
keep if _n ==1
gen outcome = "`outcome'" 
gen season ="Spring"
gen analysis = "`analysis'"
gen lower = -1.96*stderr1
gen upper = 1.96*stderr1
gen exp_lower= exp(lower)
gen exp_upper= exp(upper)
gen suff_powered = 0
replace suff_powered = 1 if irr1 <= exp_lower | irr1 >= exp_upper
order outcome season analysis irr1 stderr1
save "projectnumber\analysis\power_calcs\region_adjusted\weeks/`outcome'_Spring_`analysis'.dta", replace

	}
}


*1c) Append all files.
cd "projectnumber\analysis\power_calcs\region_adjusted\weeks"
ssc install fs
fs "*.dta*"
foreach f in `r(files)' {
	append using `f'
}
	export excel using "power_regionadj_weeks.xlsx", firstrow(variables) replace
	
	
	
	
***************************************************************************************************************************************

*2. Individual day of the week analyses
***************************************

*2a) Autumn - individual days
********************************

cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach day in sun mon tues wed thurs fri sat{ 
		use "`outcome'_Autumn_allyearsregions2.dta", clear

*Negative Binomial Regression comparing each day in the week after the clock change to control period of all other same days (i.e. Sunday after to all other Sundays) 
di "`outcome'" "Autumn: `day'"
nbreg count i.`day'_after i.region, irr vce(cluster region) // count = outcome. exposure: i.day. Don't need day of the week as a covariate as we only have one day of the week.
matrix list r(table) // displays results inc the full p value.
matrix irr= r(table)[1, 2] // Row 1: irr
matrix stderr = r(table)[2, 2] // Row 2: Standard errors
svmat irr // Save irr
svmat stderr // Save standard error
keep irr1 stderr1
keep if _n ==1
gen outcome = "`outcome'" 
gen season ="Autumn"
gen day = "`day'"
gen lower = -1.96*stderr1
gen upper = 1.96*stderr1
gen exp_lower= exp(lower)
gen exp_upper= exp(upper)
gen suff_powered = 0
replace suff_powered = 1 if irr1 <= exp_lower | irr1 >= exp_upper
order outcome season day irr1 stderr1
save "projectnumber\analysis\power_calcs\region_adjusted\days/`outcome'_Autumn_`day'.dta", replace

	}
}


***************

*2b) Spring - individual days
*********************************

cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach day in sun mon tues wed thurs fri sat{
		use "`outcome'_Spring_regions_easter2.dta", clear

*Negative Binomial Regression comparing each day in the week after the clock change to control period of all other same days (i.e. Sunday after to all other Sundays) 
di "`outcome'" "Spring: `day'"
nbreg count i.`day'_after i.easter_wkend i.region, irr vce(cluster region) // count = outcome. i.day == exposure. Don't need day of the week as a covariate as we only have one day of the week but still include Easter weekend as covariate.
matrix list r(table) // displays results inc the full p value.
matrix irr= r(table)[1, 2] // Row 1: irr
matrix stderr = r(table)[2, 2] // Row 2: Standard errors
svmat irr // Save irr
svmat stderr // Save standard error
keep irr1 stderr1
keep if _n ==1
gen outcome = "`outcome'" 
gen season ="Spring"
gen day = "`day'"
gen lower = -1.96*stderr1
gen upper = 1.96*stderr1
gen exp_lower= exp(lower)
gen exp_upper= exp(upper)
gen suff_powered = 0
replace suff_powered = 1 if irr1 <= exp_lower | irr1 >= exp_upper
order outcome season day irr1 stderr1
save "projectnumber\analysis\power_calcs\region_adjusted\days/`outcome'_Spring_`day'.dta", replace


	}
}


*2c) Append all files - individual days
****************************************
cd "projectnumber\analysis\power_calcs\region_adjusted\days"
ssc install fs
fs "*.dta*"
foreach f in `r(files)' {
	append using `f'
}
	export excel using "power_regionadj_days.xlsx", firstrow(variables) replace