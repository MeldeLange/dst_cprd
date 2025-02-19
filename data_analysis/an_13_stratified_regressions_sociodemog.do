*Analysis 13: Stratified regressions for the first week after the clock changes vs rest of the weeks, stratified by sociodemographics
*************************************************************************************************************************************

*Sex, age, deprivation, systolic blood pressure, diastolic blood pressure, bmi, alcohol status, smoking status, marital status



**Open log
log using "projectnumber\analysis\logs/stratified_regressions_sociodemog.log", replace // because having to use 'capture' command this doesn't log the regression outputs from part 1.


*1. Run regressions & save results.

*1a) Autumn
**********
clear
foreach mod in gender age imd sbp dbp bmi alc smok marital{
	cd "projectnumber\analysis\stratified\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
		foreach category in 0 1 2 3{
			
local filenames: dir "." files "`outcome'_Autumn_allyearsregions_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
capture { // For some analyses convergence is not achieved so have to use capture to get whole loop to run.
*Negative Binomial Regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & region.
*onewk_after
di "`outcome'" "Autumn: One week after"
eststo model1:nbreg count i.onewk_after i.days i.region, irr vce(cluster region) // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Autumn_oneweek_`mod'`category'.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Autumn_oneweek_`mod'`category'.txt, clear
export excel using "projectnumber\analysis\stratified\regressions/`mod'/`outcome'_Autumn_oneweek_`mod'`category'.xlsx", replace 
 
 }
		}
}
}
}


*1b) Spring
clear

foreach mod in gender age imd sbp dbp bmi alc smok marital{
	cd "projectnumber\analysis\stratified\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
		foreach category in 0 1 2 3{
			
local filenames: dir "." files "`outcome'_Spring_allyearsregions_easter_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
capture { // For some analyses convergence is not achieved so have to use capture to get whole loop to run.
*Negative Binomial Regression comparing the mean daily number of events in the week after the clock change to all other weeks, adjusting for day of the week & region.
*onewk_after
di "`outcome'" "Spring: One week after"
eststo model1:nbreg count i.onewk_after i.days i.easter_wkend i.region, irr vce(cluster region)  // count = outcome. onewk_after = exposure. days = covariate. region = covariate.
matrix list r(table) // displays results inc the full p value.
estout model1 using `outcome'_Spring_oneweek_`mod'`category'.txt, eform replace cells("b(label(IRR) fmt(%9.2f)) ci(label(95% CI) fmt(%9.3f)) p(label(p value) fmt(%9.4f))") label stats(N, labels("n") fmt(%9.0g))
*Import regression results & save as excel spreadsheet
import delimited using `outcome'_Spring_oneweek_`mod'`category'.txt, clear
export excel using "projectnumber\analysis\stratified\regressions/`mod'/`outcome'_Spring_oneweek_`mod'`category'.xlsx", replace 
 
 }
		}
}
}
}

******************************************************

*2. Get the total number of events included in each of the 1 week analyses (use all the days of data)

*2a) Autumn
clear

foreach mod in gender age imd sbp dbp bmi alc smok marital{
	cd "projectnumber\analysis\stratified\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
		foreach category in 0 1 2 3{

		local filenames: dir "." files "`outcome'_Autumn_allyearsregions_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
		di "`outcome.'" "Autumn: One week after." "`mod':`category'"
total(count)
		
 }
		}
}
}

*2b) Spring
clear

foreach mod in gender age imd sbp dbp bmi alc smok marital{
	cd "projectnumber\analysis\stratified\datasets/`mod'/years_combined"

foreach outcome in anx cvd dep eatdis psy rti selfharm sleep{
		foreach category in 0 1 2 3{

		local filenames: dir "." files "`outcome'_Spring_allyearsregions_easter_`mod'`category'_2.dta"
 foreach file in `filenames'{
	 	use `file', clear
		di "`outcome.'" "Spring: One week after." "`mod':`category'"
total(count)
		
 }
		}
}
}





*Close log
log close


*********************************************************

*3. Check the actual p values of those that are 0.0000
********************************************************
cd "projectnumber\analysis\stratified\datasets/smok/years_combined"
use anx_Autumn_allyearsregions_smok1_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

cd "projectnumber\analysis\stratified\datasets/bmi/years_combined"
use cvd_Spring_allyearsregions_easter_bmi1_2.dta, clear
nbreg count i.onewk_after i.days i.region i.easter_wkend, irr vce(cluster region) 
matrix list r(table)

cd "projectnumber\analysis\stratified\datasets/imd/years_combined"
use dep_Autumn_allyearsregions_imd2_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*BMI - depression - Autumn -normal
cd "projectnumber\analysis\stratified\datasets/bmi/years_combined"
use dep_Autumn_allyearsregions_bmi2_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*Marital - depression  - Autumn - normal
cd "projectnumber\analysis\stratified\datasets/marital/years_combined"
use dep_Autumn_allyearsregions_marital2_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*Marital - depression  - Autumn - missing
cd "projectnumber\analysis\stratified\datasets/marital/years_combined"
use dep_Autumn_allyearsregions_marital3_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*Alcohol - depression - Autumn - current
cd "projectnumber\analysis\stratified\datasets/alc/years_combined"
use dep_Autumn_allyearsregions_alc1_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*Alcohol - depression - Autumn - missing
cd "projectnumber\analysis\stratified\datasets/alc/years_combined"
use dep_Autumn_allyearsregions_alc3_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*Smoking - depression - autumn - current
cd "projectnumber\analysis\stratified\datasets/smok/years_combined"
use dep_Autumn_allyearsregions_smok1_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*SBP - depression - autumn normal
cd "projectnumber\analysis\stratified\datasets/sbp/years_combined"
use dep_Autumn_allyearsregions_sbp2_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*DBP - depression - autumn normal
cd "projectnumber\analysis\stratified\datasets/dbp/years_combined"
use dep_Autumn_allyearsregions_dbp2_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*IMD - eatdis - spring - missing
cd "projectnumber\analysis\stratified\datasets/imd/years_combined"
use eatdis_Spring_allyearsregions_easter_imd3_2.dta, clear
nbreg count i.onewk_after i.days i.region i.easter_wkend, irr vce(cluster region) 
matrix list r(table)

*IMD - eatdis - autumn - missing
cd "projectnumber\analysis\stratified\datasets/imd/years_combined"
use eatdis_Autumn_allyearsregions_imd3_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*gender  rti spring missing
cd "projectnumber\analysis\stratified\datasets/gender/years_combined"
use rti_Spring_allyearsregions_easter_gender3_2.dta, clear
nbreg count i.onewk_after i.days i.region i.easter_wkend, irr vce(cluster region) 
matrix list r(table)

*alcohol rti autumn non/ex
cd "projectnumber\analysis\stratified\datasets/alc/years_combined"
use rti_Autumn_allyearsregions_alc2_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*gender selfharm spring missing
cd "projectnumber\analysis\stratified\datasets/gender/years_combined"
use selfharm_Spring_allyearsregions_easter_gender3_2.dta, clear
nbreg count i.onewk_after i.days i.region i.easter_wkend, irr vce(cluster region) 
matrix list r(table)

*gender selfharm autumn missing
cd "projectnumber\analysis\stratified\datasets/gender/years_combined"
use selfharm_Autumn_allyearsregions_gender3_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

*bmi autumn psyc missing
cd "\projectnumber\analysis\stratified\datasets/bmi/years_combined"
use psy_Autumn_allyearsregions_bmi3_2.dta, clear
nbreg count i.onewk_after i.days i.region, irr vce(cluster region) 
matrix list r(table)

