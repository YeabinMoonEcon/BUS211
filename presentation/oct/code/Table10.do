****** set the path************************************************
cap cd "/Users/yeabinmoon/Dropbox (UH-ECON)/yeabin"
cap cd "c:/dropbox (UH-ECON)/yeabin" 
// cd "/Users/yeabinmoon/MyFiles/yeabin"
*******************************************************************
clear all

cd "./job market paper/data/"

//import delimited "./shortrun11.csv", clear
import delimited "./df_snap7.csv", clear

drop v1
sort flag
keep if flag == 0
keep if degree_date >= 2004

encode university, gen(college)
encode name_correct, gen(ID)
encode jel_code, gen(major_field)

label define female 0 "male"
encode gender, gen(female)
replace female = 0 if female == 2

rename usa usa2
label define usa 0 "no"
label define usa 1 "yes", add
encode usa2, gen(usa)
replace usa = 0 if usa == 2
replace usa = 1 if usa == 3
drop usa2

gen usa_imp = usa
replace usa_imp = 0 if missing(usa_imp)
gen female_imp = female
replace female_imp = 1 if missing(female_imp)
egen z1u_rate = std(u_o_rate)

drop if rank2 == 1

*************** Table 3 *****************
eststo clear
eststo:reghdfe outcome1 c.z1u_rate i.female_imp i.usa_imp, absorb(college major_field) vce(cluster degree_date)
//eststo:reghdfe outcome1 c.z1u_rate i.female_imp i.usa_imp if rank2 == 1, absorb(college major_field) vce(cluster degree_date)
//eststo:reghdfe outcome1 c.z1u_rate i.female_imp i.usa_imp if rank2 != 1, absorb(college major_field) vce(cluster degree_date)

//esttab using "/Users/yeabinmoon/Dropbox (UH-ECON)/JMP/writing/tab/raw_tex/table3.tex", replace se r2 ar2 scalars(F) drop(_cons) star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels
******************************************

import delimited "./df_long7.csv", clear

drop v1


tab flag
keep if flag == 0
count
tab degree_date

keep if degree_date >= 2004
encode university, gen(college)
encode name_correct, gen(ID)

encode jel_code, gen(major_field)

label define female 0 "male"
encode gender, gen(female)
replace female = 0 if female == 2

rename usa usa2
label define usa 0 "no"
label define usa 1 "yes", add
encode usa2, gen(usa)
replace usa = 0 if usa == 2
replace usa = 1 if usa == 3

gen usa_imp = usa
replace usa_imp = 0 if missing(usa_imp)

gen female_imp = female
replace female_imp = 1 if missing(female_imp)

egen z1u_rate = std(u_o_rate)
egen flag4 = max(pubs), by(ID)
egen flag1 = max(exp), by(ID)
egen flag2 = max(exp_5), by(ID)
gen flag3 = flag2 / flag1

gen long_outcome1 = 0
replace long_outcome1 = 1 if occupation == 1 & !missing(occupation)

eststo:reghdfe long_outcome1 c.z1u_rate i.female_imp i.usa_imp  if exp == 8  , absorb(college major_field) vce(cluster degree_date)

egen double_cluster = group(degree_date t)

replace pubs = 0 if missing(pubs)
drop if rank2 == 1
//keep if flag4 >= 1 
eststo:reghdfe pubs c.z1u_rate i.female_imp i.usa_imp , absorb(college major_field exp) vce(cluster double_cluster)
eststo:reghdfe pubs20 c.z1u_rate i.female_imp i.usa_imp , absorb(college major_field exp) vce(cluster double_cluster)
eststo:reghdfe pubs5 c.z1u_rate i.female_imp i.usa_imp , absorb(college major_field exp) vce(cluster double_cluster)
//eststo:reghdfe pubs c.z1u_rate##i.female_imp i.usa_imp , absorb(college major_field exp_1 exp_2 exp_3 exp_4 exp_5) vce(cluster degree_date)
//test  _b[z1u_rate] + _b[1.female#c.z1u_rate] = 0 
//eststo:reghdfe pubs c.z1u_rate##i.usa_imp i.female_imp , absorb(college major_field exp_1 exp_2 exp_3 exp_4 exp_5) vce(cluster degree_date)
//test  _b[z1u_rate] + _b[1.usa#c.z1u_rate] = 0
esttab, replace se r2 ar2 scalars(F) drop(_cons)  star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels
esttab using "/Users/yeabinmoon/Dropbox (UH-ECON)/JMP/presentations/oct/tables/raw/table10.tex", replace se r2 ar2 scalars(F) drop(_cons) star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels
