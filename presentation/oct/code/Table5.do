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

eststo clear
eststo:mlogit category_1 c.z1u_rate i.female_imp i.usa_imp ,  vce(cluster degree_date)
eststo:mlogit category_1 c.z1u_rate i.female_imp i.usa_imp i.college i.major_field,  vce(cluster degree_date)
esttab using "/Users/yeabinmoon/Dropbox (UH-ECON)/JMP/presentations/oct/tables/raw/table5.tex", replace se r2 ar2 scalars(F) drop(_cons) star(* 0.10 ** .05 *** .01) interaction("X") nobaselevels
