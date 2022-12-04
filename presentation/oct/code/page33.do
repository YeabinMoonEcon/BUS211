****** set the path************************************************
cap cd "/Users/yeabinmoon/Dropbox (UH-ECON)/yeabin"
cap cd "c:/dropbox (UH-ECON)/yeabin" 
// cd "/Users/yeabinmoon/MyFiles/yeabin"
*******************************************************************
clear all

cd "./job market paper/data/"

//import delimited "./df_long3.csv", clear
//import delimited "./df_long8.csv", clear

import delimited "./df_long7.csv", clear

drop v1

tab flag
keep if flag == 0
count
tab degree_date

keep if degree_date >= 2004
encode university, gen(college)
encode name_correct, gen(ID)
 gen g=group(college)
 gen date_g=degree_date*100+g

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

replace pubs = 0 if missing(pubs)


// pubs in top 50

egen double_cluster = group(degree_date t)
egen double_cluster2 = group(degree_date major_field)

eststo clear
//eststo:reghdfe pubs  c.z1u_rate i.female_imp i.usa_imp, absorb(college major_field exp) vce(cluster double_cluster)
eststo:reghdfe pubs  c.z1u_rate i.female_imp i.usa_imp , absorb(college major_field exp) vce(cluster double_cluster)
eststo:reghdfe pubs  c.z1u_rate i.female_imp i.usa_imp  exp, absorb(college major_field) vce(cluster double_cluster)
eststo:reghdfe pubs20  c.z1u_rate i.female_imp i.usa_imp , absorb(college major_field exp) vce(cluster double_cluster)
eststo:reghdfe pubs20  c.z1u_rate i.female_imp i.usa_imp  exp, absorb(college major_field) vce(cluster double_cluster)
eststo:reghdfe pubs5  c.z1u_rate i.female_imp i.usa_imp , absorb(college major_field exp) vce(cluster double_cluster)
eststo:reghdfe pubs5  c.z1u_rate i.female_imp i.usa_imp  exp, absorb(college major_field) vce(cluster double_cluster)
esttab, replace se r2 ar2 scalars(F) drop(_cons)  star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels
esttab using "/Users/yeabinmoon/Dropbox (UH-ECON)/JMP/presentations/oct/tables/raw/table7.tex", replace se r2 ar2 scalars(F) drop(_cons) star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels


