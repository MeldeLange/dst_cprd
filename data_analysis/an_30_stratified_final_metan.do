*an_30  Meta-analysis to test heteoregenity between stratified categories
*******************************************************************************

*1. Create & combine files needed


*1a) Import & save the sociodemographic & incident results
foreach mod in sociodemog incident {
cd "projectnumber\analysis\power_calcs\stratified_final/`mod'"
import excel using power_stratified_`mod'.xlsx, firstrow clear
drop stderr1 exp_lower exp_upper suff_powered lower upper //Drop variables we don't need.
save "projectnumber\analysis\stratified\final\metan/metan_`mod'.dta", replace
}

*1b) Append the files
clear
cd "projectnumber\analysis\stratified\final\metan"
ssc install fs
fs "*.dta*"
foreach f in `r(files)' {
	append using `f'
}
save metan.dta, replace


*1c) Drop observations for 'missing' category for gender and deprivation as the number of events is too low to be useful.
cd "projectnumber\analysis\stratified\final\metan"
use metan.dta, clear
drop if mod == "gender" & cat =="3" // 
drop if mod == "imd" & cat =="3" // 
save "projectnumber\analysis\stratified\final\metan/metan2.dta", replace



*****************************

*2. Run meta-analysis

*Open log
log using "projectnumber\analysis\logs/final_metan.log", replace

*2a) Loop to run meta-analysis for sociodemographics
clear
cd "projectnumber\analysis\stratified\final\metan"
use metan2.dta, clear
preserve
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep {
	foreach season in Spring Autumn {
		foreach mod in age alc bmi dbp gender imd sbp smok{
			
		keep if mod == "`mod'"
		keep if outcome == "`outcome'"
		keep if season == "`season'"
		di "`outcome': `season': `mod'"
		metan irr1 lci1 uci1
		restore
		preserve
	}
	}
}
restore



*2b) Loop to run meta-analysis for incident
clear
cd "projectnumber\analysis\stratified\final\metan"
use metan2.dta, clear
preserve
foreach outcome in anx cvd dep eatdis psy selfharm sleep {
	foreach season in Spring Autumn {
		foreach mod in incident{
		keep if mod == "`mod'"
		keep if outcome == "`outcome'"
		keep if season == "`season'"
		di "`outcome': `season': `mod'"
		metan irr1 lci1 uci1
		restore
		preserve
	}
	}
}
restore

*Close log
log close