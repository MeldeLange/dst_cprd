*Basic clean of HES A&E Attendance and Diagnosis files
********************************************************

*Mel de Lange 14.05.2024
*Updated 14.8.2024

cd "cprd_data\HES A&E"


*1. Clean attendance file
**************************

import delimited using hesae_attendance_22_002468_DM.txt, clear
browse // 9,222,737 obs.
list in 1/5


*Only keep variables we need.
keep patid aekey arrivaldate aepatgroup

*Format aekey so not in scientific notation
format aekey %15.0f

*Format admission date
gen arrivaldate2 = date(arrivaldate, "DMY")
list arrivaldate arrivaldate2 in 1/5
format arrivaldate2 %d
list arrivaldate arrivaldate2 in 1/5
drop arrivaldate
rename arrivaldate2 arrivaldate
replace arrivaldate=. if arrivaldate>150000 // 150,000 days after 01 Jan 1960. // No changes made.

*Compress file
compress
describe

*Save as stata file
save hes_ae_attendance.dta, replace

**************************************************

*2. Clean diagnosis file
************************

import delimited using hesae_diagnosis_22_002468_DM.txt, clear
browse
list in 1/5 // 7,794,842 obs


*Only keep variables we need.
keep patid aekey diag2

*Format aekey so not in scientific notation
format aekey %15.0f


*Compress file
compress
describe

*Save as stata file
save hes_ae_diagnosis.dta, replace