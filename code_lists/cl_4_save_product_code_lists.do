* Save product files as stata files with just outcome as name.
cd "\gold_primary_care_all\prodcodelists"

local myfilelist : dir "." files "*.txt"

foreach file of local myfilelist{
insheet using `file', clear
local name = subinstr("`file'","_product.txt","",.)
save `name'.dta, replace
}
