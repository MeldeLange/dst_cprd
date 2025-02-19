*Analysis 20: Meta-analysis to test heteoregenity between stratified categories
*******************************************************************************

*1. Create & combine files needed


*1a) Import & save the sociodemographic, incident & cvd subgroup results
foreach mod in sociodemog incident subgroup {
cd "projectnumber\analysis\power_calcs\stratified/`mod'"
import excel using power_stratified_`mod'.xlsx, firstrow clear
drop stderr1 exp_lower exp_upper suff_powered lower upper //Drop variables we don't need.
save "projectnumber\analysis\stratified\metan/metan_`mod'.dta", replace
}



*1b) Append the files & cut down to variables we need.
clear
cd "projectnumber\analysis\stratified\metan"
ssc install fs
fs "*.dta*"
foreach f in `r(files)' {
	append using `f'
}
save metan.dta, replace


*1c) Drop observations for 'missing' category for gender and deprivation as the number of events is too low to be useful.
cd "projectnumber\analysis\stratified\metan"
use metan.dta, clear
drop if mod == "gender" & cat =="3" // 5 obs deleted
drop if mod == "imd" & cat =="3" // 16 obs deleted. 420 obs.
save "projectnumber\analysis\stratified\metan/metan2.dta", replace


*****************************

*2. Run meta-analysis

*Open log
log using "projectnumber\analysis\logs/metan.log", replace

*2a) Loop to run meta-analysis for sociodemographics
clear
cd "projectnumber\analysis\stratified\metan"
use metan2.dta, clear
preserve
foreach outcome in anx cvd dep eatdis psy rti selfharm sleep {
	foreach season in Spring Autumn {
		foreach mod in age alc bmi dbp gender imd marital sbp smok{
			
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
cd "projectnumber\analysis\stratified\metan"
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


*2c) Loop to run meta-analysis for cvd subgroup 
clear
cd "projectnumber\analysis\stratified\metan"
use metan2.dta, clear
preserve
foreach outcome in cvd {
	foreach season in Spring Autumn {
		foreach mod in subgroup{
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


