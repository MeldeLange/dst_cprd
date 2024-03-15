************************************************************************

*Creating road traffic injuries code list
*Date 22/11/22
*Author: Mel de Lange

************************************************************************
* Prepare environment
	
		clear
		set more off
		set linesize 100
		
* Load packages
		
		ssc install distinct
		
*****Need to set global macro for codebrowserdir*
*global codebrowserdir "....CPRD codes browsers\"


*Load data (CPRD Gold Medical Browser) using the global macro I have created: "codebrowserdir" 
use "$codebrowserdir\GoldMedical.dta", clear


** Make all descriptions lower case	
		
		gen Z=lower(desc)
		drop desc
		rename Z desc
		label variable desc "Read term description"
		
*************************************************************************
*****NEED TO RUN STEP 1 AND 2 TOGETHER FOR IT TO WORK!

*Step 1 - defining search terms using list of indications searching Read codes and descriptions

	*Define search terms for the local macro "rti" (road traffic injuries)
	local rti " "*motor*" "*traffic*" "*mvta*" "*vehicle*" "*road*" "*collision*" "*rta*" "*rtc*" "
	
**************************************************************************
* Step 2 - word search of CPRD medical dictionary: CPRD Gold Medical Dictionary, Version xxx, June 2022 build
	
	* Create a variable for identifying descriptions in each class
	
foreach x in rti {
		
		gen `x'=.
	
	}
	
	* Update marker where description matches search terms
	
		foreach x in rti {
			foreach term in desc {
				foreach word in ``x''{
           
		   replace `x' = 1 if strmatch(`term', "`word'")
          
				}
			}
		}	
		
		
	* Check each of the markers against description & flag potentially irrelevant codes
	
	gen marker =.
	
	browse desc if rti==1
	
	* Medical codes to potentially remove: 
	replace marker = 1 if rti==1 & regexm(desc, "aorta")
	replace marker = 1 if rti==1 & regexm(desc, "quartan")
	replace marker = 1 if rti==1 & regexm(desc, "portage")
	replace marker = 1 if rti==1 & regexm(desc, "porta")
	replace marker = 1 if rti==1 & regexm(desc, "importance")
	replace marker = 1 if rti==1 & regexm(desc, "uncertain")
	replace marker = 1 if rti==1 & regexm(desc, "certain")
	replace marker = 1 if rti==1 & regexm(desc, "mortality")
	replace marker = 1 if rti==1 & regexm(desc, "insertable")
	replace marker = 1 if rti==1 & regexm(desc, "comfortable")
	replace marker = 1 if rti==1 & regexm(desc, "intertarsal")
	replace marker = 1 if rti==1 & regexm(desc, "portal")
	replace marker = 1 if rti==1 & regexm(desc, "important")
	replace marker = 1 if rti==1 & regexm(desc, "mortar")
	replace marker = 1 if rti==1 & regexm(desc, "portable")
	replace marker = 1 if rti==1 & regexm(desc, "mortal")
	replace marker = 1 if rti==1 & regexm(desc, "pubertal")
	replace marker = 1 if rti==1 & regexm(desc, "convertase")
	replace marker = 1 if rti==1 & regexm(desc, "chlortalidone")
	replace marker = 1 if rti==1 & regexm(desc, "entertainer")
	replace marker = 1 if rti==1 & regexm(desc, "undertakes")
	replace marker = 1 if rti==1 & regexm(desc, "entertainment")
	replace marker = 1 if rti==1 & regexm(desc, "chronic motor")
	replace marker = 1 if rti==1 & regexm(desc, "oral motor")
	replace marker = 1 if rti==1 & regexm(desc, "motor epilepsy")
	replace marker = 1 if rti==1 & regexm(desc, "oculomotor")
	replace marker = 1 if rti==1 & regexm(desc, "deep motor")
	replace marker = 1 if rti==1 & regexm(desc, "motor symptom")
	replace marker = 1 if rti==1 & regexm(desc, "motor retraining")
	replace marker = 1 if rti==1 & regexm(desc, "motor aphasia")
	replace marker = 1 if rti==1 & regexm(desc, "motor disorders")
	replace marker = 1 if rti==1 & regexm(desc, "motor relearning")
	replace marker = 1 if rti==1 & regexm(desc, "motor speech")
	replace marker = 1 if rti==1 & regexm(desc, "motor dysphasia")
	replace marker = 1 if rti==1 & regexm(desc, "dysphasia")
	replace marker = 1 if rti==1 & regexm(desc, "motor dysfunction")
	replace marker = 1 if rti==1 & regexm(desc, "motor control")
	replace marker = 1 if rti==1 & regexm(desc, "gross motor")
	replace marker = 1 if rti==1 & regexm(desc, "motor neurone")
	replace marker = 1 if rti==1 & regexm(desc, "motor system")
	replace marker = 1 if rti==1 & regexm(desc, "fine motor")
	replace marker = 1 if rti==1 & regexm(desc, "psychomotor")
	replace marker = 1 if rti==1 & regexm(desc, "locomotor")
	replace marker = 1 if rti==1 & regexm(desc, "motor develop")
	replace marker = 1 if rti==1 & regexm(desc, "sensorimotor")
	replace marker = 1 if rti==1 & regexm(desc, "vasomotor")
	replace marker = 1 if rti==1 & regexm(desc, "motor/sensory")
	replace marker = 1 if rti==1 & regexm(desc, "motor function")
	replace marker = 1 if rti==1 & regexm(desc, "motor delay")
	replace marker = 1 if rti==1 & regexm(desc, "motor problem")
	replace marker = 1 if rti==1 & regexm(desc, "motor therapy")
	replace marker = 1 if rti==1 & regexm(desc, "motor branch")
	replace marker = 1 if rti==1 & regexm(desc, "heavy goods")
	replace marker = 1 if rti==1 & regexm(desc, "broad")
	replace marker = 1 if rti==1 & regexm(desc, "cross the road")
	replace marker = 1 if rti==1 & regexm(desc, "mvnta")
	replace marker = 1 if rti==1 & regexm(desc, "nontrf")
	replace marker = 1 if rti==1 & regexm(desc, "nontraf")
	replace marker = 1 if rti==1 & regexm(desc, "nontraff")
	replace marker = 1 if rti==1 & regexm(desc, "test")
	replace marker = 1 if rti==1 & regexm(desc, "syndrome")
	replace marker = 1 if rti==1 & regexm(desc, "score")
	replace marker = 1 if rti==1 & regexm(desc, "questionnaire")
	replace marker = 1 if rti==1 & regexm(desc, "assessment")
	replace marker = 1 if rti==1 & regexm(desc, "scale")
	replace marker = 1 if rti==1 & regexm(desc, "suicide")
	replace marker = 1 if rti==1 & regexm(desc, "throwing self")
	replace marker = 1 if rti==1 & regexm(desc, "foreman")
	replace marker = 1 if rti==1 & regexm(desc, "roadsman")
	replace marker = 1 if rti==1 & regexm(desc, "occupation")
	replace marker = 1 if rti==1 & regexm(desc, "hereditary")
	replace marker = 1 if rti==1 & regexm(desc, "ambulance")
	replace marker = 1 if rti==1 & regexm(desc, "self harm")
	replace marker = 1 if rti==1 & regexm(desc, "poisoning")
	replace marker = 1 if rti==1 & regexm(desc, "acc pois")
	replace marker = 1 if rti==1 & regexm(desc, "skills")
	replace marker = 1 if rti==1 & regexm(desc, "claim")
	replace marker = 1 if rti==1 & regexm(desc, "rides")
	replace marker = 1 if rti==1 & regexm(desc, "warden")
	replace marker = 1 if rti==1 & regexm(desc, "job")
	replace marker = 1 if rti==1 & regexm(desc, "manager")
	replace marker = 1 if rti==1 & regexm(desc, "engineer")
	replace marker = 1 if rti==1 & regexm(desc, "ships")
	replace marker = 1 if rti==1 & regexm(desc, "watercraft")
	replace marker = 1 if rti==1 & regexm(desc, "powered vehicle")
	replace marker = 1 if rti==1 & regexm(desc, "kick")
	replace marker = 1 if rti==1 & regexm(desc, "adva")
	replace marker = 1 if rti==1 & regexm(desc, "pca")
	replace marker = 1 if rti==1 & regexm(desc, "able to ride")
	replace marker = 1 if rti==1 & regexm(desc, "railway accident")
	replace marker = 1 if rti==1 & regexm(desc, "train accident")
	replace marker = 1 if rti==1 & regexm(desc, "undertaken")
	replace marker = 1 if rti==1 & regexm(desc, "aircraft")
	replace marker = 1 if rti==1 & regexm(desc, "aspartate")
	replace marker = 1 if rti==1 & regexm(desc, "air traffic")
	replace marker = 1 if rti==1 & regexm(desc, "undertake")
	replace marker = 1 if rti==1 & regexm(desc, "streetcar")
	replace marker = 1 if rti==1 & regexm(desc, "wash plant")
	replace marker = 1 if rti==1 & regexm(desc, "difficulty")
	replace marker = 1 if rti==1 & regexm(desc, "racing")
	replace marker = 1 if rti==1 & regexm(desc, "smarta")
	replace marker = 1 if rti==1 & regexm(desc, "road surfacer")
	replace marker = 1 if rti==1 & regexm(desc, "road sweeper")
	replace marker = 1 if rti==1 & regexm(desc, "traffic light")
	replace marker = 1 if rti==1 & regexm(desc, "storm")
	replace marker = 1 if rti==1 & regexm(desc, "road surfacer")
	replace marker = 1 if rti==1 & regexm(desc, "light goods")
	replace marker = 1 if rti==1 & regexm(desc, "motor car driver")
	replace marker = 1 if rti==1 & regexm(desc, "track")
	replace marker = 1 if rti==1 & regexm(desc, "trafficking")
	replace marker = 1 if rti==1 & regexm(desc, "road safety")
	replace marker = 1 if rti==1 & regexm(desc, "vehicle body")
	replace marker = 1 if rti==1 & regexm(desc, "patrolman")
	replace marker = 1 if rti==1 & regexm(desc, "danger")
	replace marker = 1 if rti==1 & regexm(desc, "adaption")
	replace marker = 1 if rti==1 & regexm(desc, "does not drive")
	replace marker = 1 if rti==1 & regexm(desc, "motor limb")
	replace marker = 1 if rti==1 & regexm(desc, "history")
	replace marker = 1 if rti==1 & regexm(desc, "traffic dispatcher")
	replace marker = 1 if rti==1 & regexm(desc, "x-ray")
	replace marker = 1 if rti==1 & regexm(desc, "prime mover")
	replace marker = 1 if rti==1 & regexm(desc, "airport")
	replace marker = 1 if rti==1 & regexm(desc, "builder")
	replace marker = 1 if rti==1 & regexm(desc, "letter")
	replace marker = 1 if rti==1 & regexm(desc, "finisher")
	replace marker = 1 if rti==1 & regexm(desc, "motor vehicle mechanic")
	replace marker = 1 if rti==1 & regexm(desc, "able to")
	replace marker = 1 if rti==1 & regexm(desc, "does ride")
	replace marker = 1 if rti==1 & regexm(desc, "crosses")


	
	* Codes to keep in to check
		browse desc if rti==1 & marker==.
		
		**Gives us 467 observations (codes)
		
		* Codes to take out to check
		browse desc if marker==1
	* 918 observations (codes) cut.
	

	*Save codelists as excel & stata files for checking
keep if rti==1	
	
********Need to set global macro for rticodesdir* 
*global rticodesdir2 "..."
	
export excel "$rticodesdir2\rti_to_check.xlsx", firstrow(varlabels) replace

save "$rticodesdir2\rti_to_check.dta", replace	
	
	