*Create Effect modifiers from additional patient file - Alcohol, smoking, blood pressure & BMI 
************************************************************************************************

cd "cprd_data\gold_primary_care_all"
*we have 12 additional data files.
*The 4 effect modifiers we want are: alcohol status (enttype 5), smoking status (enttype 4), BMI (enttype 13) & systolic blood pressure (enttype 1).
//The additional data files have no dates in them. So to get the date we have to merge them with the clinical files using adid, which is unique within individual and date.


*1. BMI
**********

*1a) Loop through additional files to clean
cd "cprd_data\gold_primary_care_all\Stata files"
ssc install fs
fs "*Additional*"

foreach f in `r(files)' {
	use "`f'", clear
	format patid %12.0f // format patid
	keep if enttype==13 // only keep bmi
	keep patid adid data3 // Only keep vars we need
	gen data_3 = real(data3) //Destring data variable
	drop data3
	rename data_3 data3
	keep if data3!=. //*Drop anyone without bmi data
	save "tempdata/bmi_`f'", replace // Save
			}
			
*1b) Loop to append the 12 cleaned bmi files into one additional file.
clear
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
fs "*bmi*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*1c)  Generate & clean BMI variable
		*https://www.nhs.uk/conditions/obesity/
		gen em_bmi = data3
		drop if em_bmi <12 // drop extreme values of BMI (<12 or >50) as per Neil's paper
		drop if em_bmi >50 & em_bmi !=.
		recode em_bmi (25/max=1) (0/24.9=2) , gen(em_bmi_bin)
		label define em_bmi_bin_lb 1"Overweight/Obese" 2"Normal/Under"
		label values em_bmi_bin em_bmi_bin_lb
		tab em_bmi_bin, missing
		drop em_bmi data3



*1d) Save bmi additional dataset  (Long format as can have >1 measurement per person)
duplicates drop // 0 obs are duplicates
compress
save "bmi.dta", replace // 9,009,365 obs: 3 vars. patid, adid em_bmi_bin


*1e) Create temporary files which contain patid adid & eventdate from the (55) clinical files.
cd "cprd_data\gold_primary_care_all\Stata files"
forvalues i=1(1)55{
			use  patid adid eventdate using "stata_Clinical_`i'.dta", clear
			sort patid adid
			compress
			save "tempdata/patid_adid_eventdate_`i'",replace
			}
	
*1f) Merge the bmi & temporary clinical files
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use bmi.dta, clear
	gen _merge_final=.
		forvalues i=1(1)55{
			joinby patid adid using "patid_adid_eventdate_`i'.dta", unmatched(master) update
			replace _merge_final=3 if _merge==3
			drop _merge
			}
		drop _merge_final // all obs were matched (_merge_final==3)
		rename eventdate bmi_eventdate
		compress
		save "bmi_eventdate", replace  // 4 vars: patid, adid, em_bmi_bin, bmi_eventdate
		
		

************************************************************************************************

*2. Alcohol
************

*2a) Loop through additional files to clean
cd "cprd_data\gold_primary_care_all\Stata files"
ssc install fs
fs "*Additional*"

foreach f in `r(files)' {
	use "`f'", clear
	format patid %12.0f // format patid
	keep if enttype==5 // only keep alcohol status
	keep patid adid data1 // Only keep vars we need
	destring data1, replace //Destring data variable
	keep if data1!=. //*Drop anyone without bmi data
	save "tempdata/alc_`f'", replace // Save
			}
			
*2b) Loop to append the 12 cleaned alcohol files into one additional file.
clear
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
fs "*alc*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*2c)  Generate & clean alcohol variable
		gen em_alc = data1
		recode em_alc(0=.) (1=1) (2=2) (3=2), gen(em_alc_bin)
		label define em_alc_bin_lb 1"Current" 2"Non/Ex"
		label values em_alc_bin em_alc_bin_lb
		tab em_alc_bin, missing
		drop em_alc data1
		drop if em_alc_bin ==. // 159 obs deleted


*2d) Save alcohol additional dataset  (Long format as can have >1 measurement per person)
duplicates drop 
compress
save "alc.dta", replace // 4,741,599 obs. 3 vars: patid, adid, em_alc_bin 

	
*2e) Merge the bmi & temporary clinical files
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use alc.dta, clear
	gen _merge_final=.
		forvalues i=1(1)55{
			joinby patid adid using "patid_adid_eventdate_`i'.dta", unmatched(master) update
			replace _merge_final=3 if _merge==3
			drop _merge
			}
		tab _merge_final
		drop _merge_final // all obs were matched (_merge_final==3)
		rename eventdate alc_eventdate
		compress
		save "alc_eventdate", replace  // 4,741,599 obs. 4 vars: patid, adid, em_alc_bin alc_eventdate
			
	
************************************************************

*3. Smoking


*3a) Loop through additional files to clean
clear
cd "cprd_data\gold_primary_care_all\Stata files"
ssc install fs
fs "*Additional*"

foreach f in `r(files)' {
	use "`f'", clear
	format patid %12.0f // format patid
	keep if enttype==4 // only keep smoking status
	keep patid adid data1 // Only keep vars we need
	destring data1, replace //Destring data variable
	keep if data1!=. //*Drop anyone without smoking data
	save "tempdata/smok_`f'", replace // Save
			}
			
*3b) Loop to append the 12 cleaned smoking files into one additional file.
clear
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
fs "*smok*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*3c)  Generate & clean smoking variable
		gen em_smok = data1
		recode em_smok(0=.) (1=1) (2=2) (3=2), gen(em_smok_bin)
		label define em_smok_bin_lb 1"Current" 2"Non/Ex"
		label values em_smok_bin em_smokbin_lb
		tab em_smok_bin, missing
		drop em_smok data1
		drop if em_smok_bin ==. // 2,039 obs deleted


*3d) Save smoking additional dataset  (Long format as can have >1 measurement per person)
duplicates drop 
compress
save "smok.dta", replace //10,601,172 obs. 3 vars: patid, adid, em_smok_bin 

	
*3e) Merge the smoking & temporary clinical files
clear
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use smok.dta, clear
	gen _merge_final=.
		forvalues i=1(1)55{
			joinby patid adid using "patid_adid_eventdate_`i'.dta", unmatched(master) update
			replace _merge_final=3 if _merge==3
			drop _merge
			}
		tab _merge_final
		drop _merge_final // all obs were matched (_merge_final==3)
		rename eventdate smok_eventdate
		compress
		save "smok_eventdate", replace  // 10,601,172 obs. 4 vars: patid, adid, em_smok_bin smok_eventdate



*********************************************************


*4. Blood pressure



*4a) Loop through additional files to clean
clear
cd "cprd_data\gold_primary_care_all\Stata files"
ssc install fs
fs "*Additional*"

foreach f in `r(files)' {
	use "`f'", clear
	format patid %12.0f // format patid
	keep if enttype==1 // only keep blood pressure
	keep patid adid data2 // Only keep vars we need (systolic BP is data2)
	destring data2, replace //Destring data variable
	keep if data2!=. //*Drop anyone without systolic BP data
	save "tempdata/sbp_`f'", replace // Save
			}
			
*4b) Loop to append the 12 cleaned systolic blood pressure files into one additional file.
clear
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
fs "*sbp*"
foreach f in `r(files)' {
	di "`f'"
	append using "`f'"
	rm "`f'"
}

*4c)  Generate & clean systolic BP variable
		*https://www.ncbi.nlm.nih.gov/pmc/articles/PMC381142/ Hypertension = SPB >=140.
		gen em_sbp = data2
		recode em_sbp (140/max=1) (0/139=2), gen(em_sbp_bin)
		label define em_sbp_bin_lb 1"High" 2"Normal"
		label values em_sbp_bin em_sbp_bin_lb
		tab em_sbp_bin, missing
		drop em_sbp data2
		drop if em_sbp_bin ==. //0 obs deleted

*4d) Save systolic blood pressure additional dataset  (Long format as can have >1 measurement per person)
duplicates drop // 0 duplicates
compress
save "sbp.dta", replace // 24,436,235 obs. 3 vars: patid, adid, em_sbp_bin 

	
*4e) Merge the sbp & temporary clinical files
cd "cprd_data\gold_primary_care_all\Stata files\tempdata"
use sbp.dta, clear
	gen _merge_final=.
		forvalues i=1(1)55{
			joinby patid adid using "patid_adid_eventdate_`i'.dta", unmatched(master) update
			replace _merge_final=3 if _merge==3
			drop _merge
			}
		tab _merge_final
		drop _merge_final // all obs were matched (_merge_final==3)
		rename eventdate sbp_eventdate
		compress
		save "sbp_eventdate", replace  // 24,436,235 obs. 4 vars: patid, adid, em_sbp_bin sbp_eventdate
	
	


***********************************