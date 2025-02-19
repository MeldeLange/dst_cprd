*Sensitivity 8: Negative control - restrict eventlists to correct age groups 
****************************************************************************

*Cut down eventlists to only those events where the person is in the correct age range at the time of the negative control.
*******************************************************************************************************************************
*>=10 for depression, anxiety, sleep, self-harm & eating disorders, psychological conditions
*All ages for road traffic injuries. (don't need to cut down)
*>=40 for cardiovascular disease.

**Mental health outcomes (anxiety, depression, selfharm, eating disorders) (>=10)
cd "projectnumber\analysis\sensitivity\negative_control\raw_datasets"
foreach outcome in anx dep eatdis psy selfharm sleep{
use "negcontrol_`outcome'_3.dta", clear
keep if age >=10
save negcontrol_`outcome'_4.dta, replace
}

*CVD (aged 40 and over)
cd "projectnumber\analysis\sensitivity\negative_control\raw_datasets"
use negcontrol_cvd_3.dta, clear
keep if age >=40
save negcontrol_cvd_4.dta, replace

*RTI's (Don't need to cut down but resave existing dataset so numbering (4) is consistent between datasets)
cd "projectnumber\analysis\sensitivity\negative_control\raw_datasets"
use negcontrol_rti_3.dta, clear
save negcontrol_rti_4.dta, replace