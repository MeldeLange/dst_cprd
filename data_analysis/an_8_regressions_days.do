*Analysis 8: Regression analysis comparing the number of events individual days in the week after the clock changes to all other week days. 
*******************************************************************************************************************************************

*NB. Datasets are split by year, region and day. Analyses adjust for day and regions (& Easter weekend in Spring) & allow for clustering within regions.  


*1. Regression Analyses
*****************************

*Open log
log using "projectnumber\analysis\logs/regions_adjusted_days.log", replace

*Install estout package so can export regression results
ssc install estout



*1a) Autumn
**********

cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach day in sun mon tues wed thurs fri sat{ 
		use "`outcome'_Autumn_allyearsregions2.dta", clear

*Negative Binomial Regression comparing each day in the week after the clock change to control period of all other same days (i.e. Sunday after to all other Sundays) 
di "`outcome'" "Autumn: `day'"
eststo model1:nbreg count i.`day'_after i.region, irr vce(cluster region) // count = outcome. exposure: i.day. Don't need day of the week as a covariate as we only have one day of the week.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Autumn_regionsadj_`day'.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Autumn_regionsadj_`day'.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Autumn_regionsadj_`day'.xlsx", replace 

	}
}


*1b) Spring
********


cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach day in sun mon tues wed thurs fri sat{
		use "`outcome'_Spring_regions_easter2.dta", clear

*Negative Binomial Regression comparing each day in the week after the clock change to control period of all other same days (i.e. Sunday after to all other Sundays) 
di "`outcome'" "Spring: `day'"
eststo model1:nbreg count i.`day'_after i.easter_wkend i.region, irr vce(cluster region)  // count = outcome. i.day == exposure. Don't need day of the week as a covariate as we only have one day of the week but still include Easter weekend as covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Spring_regionsadj_`day'.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Spring_regionsadj_`day'.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Spring_regionsadj_`day'.xlsx", replace 

	}
}

***********************************************************************

*2. Get the total number of events included in each day of the week analyses
****************************************************************************
*2a) Autumn
cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach day in sun mon tues wed thurs fri sat{
use "`outcome'_Autumn_allyearsregions2.dta", clear
di "`outcome'" "Autumn: `day'"
keep if `day'_after !=.
total(count)
}
}

*2b) Spring
cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
	foreach day in sun mon tues wed thurs fri sat{
use "`outcome'_Spring_regions_easter2.dta", clear
di "`outcome'" "Spring: `day'"
keep if `day'_after !=.
total(count)
}
}


*Close log
log close
