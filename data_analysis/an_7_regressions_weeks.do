* Analysis 7: Regression analysis comparing the number of events in the 1, 2 and 4 weeks, and Monday-Friday after the clock changes to all other weeks.
*********************************************************************************************************************************************************


*NB. Datasets are split by year, region and day. Analyses adjust for day and regions (& Easter weekend in Spring) & allow for clustering within regions.  

*Open log
log using "projectnumber\analysis\logs/regions_adjusted_weeks.log", replace


*1. Autumn
**********

cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Autumn_allyearsregions2.dta", clear

*1a) Negative Binomial Regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week.
*onewk_after
di "`outcome'" "Autumn: One week after"
eststo model1:nbreg count i.onewk_after i.days i.region, irr vce(cluster region) // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Autumn_regionsadj_oneweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Autumn_regionsadj_oneweek.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Autumn_regionsadj_oneweek.xlsx", replace 


*1b) Negative Binomial Regression comparing the mean daily number of events in the two weeks after the clock change to all other weeks, adjusting for day of the week.
*twowk_after
use "`outcome'_Autumn_allyearsregions2.dta", clear
di "`outcome'" "Autumn: Two weeks after"
eststo model1:nbreg count i.twowk_after i.days i.region, irr vce(cluster region) 
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Autumn_regionsadj_twoweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Autumn_regionsadj_twoweek.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Autumn_regionsadj_twoweek.xlsx", replace 


*1c) Negative Binomial Regression comparing the mean daily number of events in the four weeks after the clock change to all other weeks, adjusting for day of the week.
*fourwk_after
use "`outcome'_Autumn_allyearsregions2.dta", clear
di "`outcome'" "Autumn: Four weeks after"
eststo model1:nbreg count i.fourwk_after i.days i.region, irr vce(cluster region) 
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Autumn_regionsadj_fourweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Autumn_regionsadj_fourweek.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Autumn_regionsadj_fourweek.xlsx", replace 

*1d) Negative Binomial Regression comparing the mean daily number of events in the weekdays in the week after the clock change to weekdays in all other weeks, adjusting for day of the week.
*wkdays_onewkafter
use "`outcome'_Autumn_allyearsregions2.dta", clear
di "`outcome'" "Autumn: Weekdays in the week after"
eststo model1:nbreg count i.wkdays_onewkafter i.days i.region, irr vce(cluster region) 
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Autumn_regionsadj_weekdays.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Autumn_regionsadj_weekdays.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Autumn_regionsadj_weekdays.xlsx", replace 

}


******************************************************************************************

*2. Spring
********

cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Spring_regions_easter2.dta", clear

*2a) Negative binomial regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & the Easter weekend.
*onewk_after
di "`outcome'" "Spring: One week after"
eststo model1:nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region) // count = outcome. onewk_after = exposure. days = covariate. easter_wkend = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Spring_regionsadj_oneweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Spring_regionsadj_oneweek.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Spring_regionsadj_oneweek.xlsx", replace 

*2b) Negative Binomial Regression comparing the mean daily number of events in the two weeks after the clock change to all other weeks, adjusting for day of the week.
*twowk_after
use "`outcome'_Spring_regions_easter2.dta", clear
di "`outcome'" "Spring: Two weeks after"
eststo model1:nbreg count i.twowk_after i.days i.easter_wkend i.region, irr vce(cluster region) 
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Spring_regionsadj_twoweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Spring_regionsadj_twoweek.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Spring_regionsadj_twoweek.xlsx", replace 

*2c) Negative Binomial Regression comparing the mean daily number of events in the four weeks after the clock change to all other weeks, adjusting for day of the week.
*fourwk_after
use "`outcome'_Spring_regions_easter2.dta", clear
di "`outcome'" "Spring: Four weeks after"
eststo model1:nbreg count i.fourwk_after i.days i.easter_wkend i.region, irr vce(cluster region) 
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Spring_regionsadj_fourweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Spring_regionsadj_fourweek.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Spring_regionsadj_fourweek.xlsx", replace 

*2d) Negative Binomial Regression comparing the mean daily number of events in the weekdays in the week after the clock change to weekdays in all other weeks, adjusting for day of the week.
*wkdays_onewkafter
use "`outcome'_Spring_regions_easter2.dta", clear
di "`outcome'" "Spring: Weekdays in the week after"
eststo model1:nbreg count i.wkdays_onewkafter i.days i.easter_wkend i.region, irr vce(cluster region) 
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Spring_regionsadj_weekdays.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Spring_regionsadj_weekdays.txt, clear
export excel using "projectnumber\analysis\regressions\region\adjusted/`outcome'_Spring_regionsadj_weekdays.xlsx", replace 

}

****************************************************************

*3. Get the total number of events included in each of the 1,2 & 4 weeks and Mon-Fri analyses 
************************************************************************************************************
*3a) Autumn - 1,2 & 4 week analyses (all use all days of data)
cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Autumn_allyearsregions2.dta", clear
di "`outcome'" "Autumn: weeks"
total(count)
}

*3b) Spring - - 1,2 & 4 week analyses (all use all days of data)
cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Spring_regions_easter2.dta", clear
di "`outcome'" "Spring: weeks"
total(count)
}


*3c) Autumn - Monday-Friday analyses (just use week days)
cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Autumn_allyearsregions2.dta", clear
di "`outcome'" "Autumn: weekdays"
keep if wkdays_onewkafter !=.
total(count)
}

*3d) Spring - Monday-Friday analyses (just use week days)
cd "projectnumber\analysis\datasets\comparisons\region"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Spring_regions_easter2.dta", clear
di "`outcome'" "Spring: weekdays"
keep if wkdays_onewkafter !=.
total(count)
}


*Close log
log close

