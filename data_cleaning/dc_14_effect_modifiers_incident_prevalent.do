*dc_14_effect_modifiers_incident_prevalent
******************************************

*Mel de Lange
*18.10.24


*Save eventlists 10 as eventlists 11 for everything except cvd & eatdis. That way all latests events lists are 11.
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx dep psy rti selfharm sleep {
use "eventlist_`outcome'_10.dta", clear
save "eventlist_`outcome'_11.dta", replace
}

*Loop to create incident case variable
cd "projectnumber\cprd_data\combined\combined_eventlists"
foreach outcome in anx cvd dep eatdis psy selfharm sleep{ // we are not doing incident vs prevalent for rtis.
use "eventlist_`outcome'_11.dta", clear
bys patid (clinical_eventdate):generate clinicaleventdate_n = _n // for each person generate an event number
gen em_incident_bin =0 // generate variable for incident case
replace em_incident_bin=1 if clinicaleventdate_n ==1 // make 1 if this is the first case for this person.
label define em_incident_bin_lb 1"Yes" 0"No"
label values em_incident_bin em_incident_bin_lb // label the new variable.
drop clinicaleventdate_n
save "eventlist_`outcome'_12.dta", replace
}

*Save rti eventlist as no 12 so numbering consistent with other files
cd "projectnumber\cprd_data\combined\combined_eventlists"
use eventlist_rti_11.dta, clear
save eventlist_rti_12.dta, replace
