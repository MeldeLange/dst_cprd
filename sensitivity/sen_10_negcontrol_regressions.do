*Sensitivity 10: Negative control regressions comparing nmber of events in the week after the negative control to all other weeks
*********************************************************************************************************************************

*NB. Datasets are split by year, region and day. Analyses adjust for day and regions (& Easter weekend in Spring) & allow for clustering within regions.  

*Open log
log using "projectnumber\analysis\logs/negcontrol_regressions.log", replace


*1. Autumn
**********

cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Autumn_allyearsregions_2.dta", clear
capture {
*Negative Binomial Regression comparing the mean daily number of events in the week after the negative control to all other weeks, adjusting for day of the week.
*onewk_after
di "`outcome'" "Autumn: One week after"
eststo model1:nbreg count i.onewk_after i.days i.region, irr vce(cluster region) // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Autumn_oneweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Autumn_oneweek.txt, clear
export excel using "projectnumber\analysis\sensitivity\negative_control\regressions/`outcome'_Autumn_oneweek.xlsx", replace 
}
}
**********
*2. Spring
********

cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Spring_allyearsregions_easter_2.dta", clear
capture {
*Negative binomial regression comparing the mean daily number of events in the week after the negative control to all other weeks, adjusting for day of the week & the Easter weekend.
*onewk_after
di "`outcome'" "Spring: One week after"
eststo model1:nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region) // count = outcome. onewk_after = exposure. days = covariate. easter_wkend = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Spring_oneweek.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Spring_oneweek.txt, clear
export excel using "projectnumber\analysis\sensitivity\negative_control\regressions/`outcome'_Spring_oneweek.xlsx", replace 
}
}

***************

*3. Get the total number of events included in each of the analyses 
************************************************************************************************************
*3a) Autumn (use all days of data)
cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Autumn_allyearsregions_2.dta", clear
di "`outcome'" "Autumn: One week after"
total(count)
}

*3b) Spring (use all days of data)
cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined"
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
use "`outcome'_Spring_allyearsregions_easter_2.dta", clear
di "`outcome'" "Spring: One week after"
total(count)
}



*Close log
log close



********************************************

*4. Get exact p value for sleep disorders in Spring
cd "projectnumber\analysis\sensitivity\negative_control\sum_datasets\years_combined"
use "sleep_Spring_allyearsregions_easter_2.dta", clear
nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region)
matrix list r(table) // 3.222e-06