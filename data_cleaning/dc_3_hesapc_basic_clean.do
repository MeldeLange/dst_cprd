*Basic clean of HES APC Diagnosis hospitalisations file
********************************************************

*Mel de Lange 10.05.2024

cd "\cprd_data\HES APC data"

import delimited using hes_diagnosis_hosp_22_002468_DM.txt, clear
browse
list in 1/5


*Only keep variables we need.
keep patid admidate icd

*Format patid so not in scientific notation
format patid %12.0f

*Format admission date
gen admidate2 = date(admidate, "DMY")
list admidate admidate2 in 1/5
format admidate2 %d
list admidate admidate2 in 1/5
drop admidate
rename admidate2 admidate
replace admidate=. if admidate>150000 // 150,000 days after 01 Jan 1960 is 25th June 2028. // No changes made.

*Compress file
compress
describe

*Save as stata file
save hes_apc.dta, replace