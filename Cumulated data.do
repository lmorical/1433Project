clear

**Loading data**
cd "/Users/leamorical/Desktop/14.33/"
use Polit.dta

**dropping irrelevant variables**
drop v1 v2 V4a Version doi v5 v6 v7 v8 v9 v10 v11 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29 v30 v31 v32 v35 v36 v37 v38 v39 v40 v41 v42 v43 v44 v45 v46 v47 v48 v49 v50 v51 v53 v55 v58 v59 v62 v64 v66 v67 v68 v69 v70 v72 v73 v74 v76 v79 v80 V81

**labelling relevant variables**
label variable v4 "Response Year"
label variable v3 "Response Month"
label variable v12 "Feelings toward Greens"
label variable v33 "Most Important Problem"
label variable v34 "Second Most Important Problem"
label variable v52 "Religious Denomination"
label variable v54 "Gender"
label variable v56 "Age Category"
label variable v57 "Marital Status"
label variable v60 "Education"
label variable v61 "Completed Vocational Training"
label variable v65 "Occupational Group"
label variable v71 "Personal Job Risk"
label variable v75 "State"
label variable v77 "Community Size"
label variable v78 "Factor Weight"

rename v75 state

**restricting to symmetric time frame 2010 to 2018**
drop if v4 < 2010

**label numeric values with corresponding words**
label define month 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
label values v3 month

label define school 0 "NA" 1 "Vocational" 2 "Intermediate" 3 "College entrance"
label values v63 school

label define religion 1 "Catholic" 2 "Protestant/Evangelical" 3 "Other" 4 "Not religious" 5 "Muslim" 6 "Jewish" 9 "NA"
label values v52 religion

label define gender 1 "Male" 2 "Female" 9 "NA"
label values v54 gender

label define agegroup 1 "17 to 20" 2 "21 to 24" 3 "25 to 29" 4 "30 to 34" 5 "35 to 39" 6 "40 to 44" 7 "45 to 49" 8 "50 to 59" 9 "60 to 69" 10 "Above 70" 99 "NA"
label values v56 agegroup

label define marital 0 "NA" 1 "Married" 2 "Married but separated" 3 "Single" 4 "Divorced" 5 "Widowed" 6 "Civil Partnership" 9 "NA"
label values v57 marital

label define schooling 0 "NA" 1 "Not graduated secondary" 2 "Graduated secondary" 3 "Technical Certificate" 4 "College Entrance" 5 "Still in School" 9 "NA"

label define voc 0 "NA" 1 "Completed vocational training" 2 "Did not complete vocational training" 8 "NA" 9 "NA"

label define occgroup 0 "NA" 1 "Self-employed" 5 "Simple employee" 6 "High-level employee" 8 "Manager" 9 "Civil servant" 10 "Middle-class official" 11 "Senior civil servant" 12 "Most senior civil servant" 13 "Judge" 14 "Soldier" 17 "Unskilled worker" 18 "Skilled worker" 20 "Master" 21 "Farmer" 24 "Housewife" 25 "Not yet employed" 99 "NA"
label values v65 occgroup

label define states 1 "Schleswig-Holstein" 2 "Hamburg" 3 "Niedersachsen" 4 "Bremen" 5 "Nordrhein-Wastfalen" 6 "Hessen" 7 "Rheinland-Pfalz" 8 "Baden-Wuttemberg" 9 "Bayern" 10 "Saarland" 11 "Berlin-West" 12 "Berlin-East" 13 "Brandenburg" 14 "Mecklenburg-Vorpommern" 15 "Sachsen" 16 "Sachsen-Anhalt" 17 "Thuringen" 99 "NA"
label values v75 states

**drop values missing state**
drop if v75 == 99

label define risk 0 "NA" 1 "Endangered" 2 "Safe" 9 "NA"
label values v71 risk

label define residents 0 "NA" 1 "up to 2,000 residents" 2 "between 2,000 and 5,000 residents" 3 "between 5,000 and 10,0000 residents" 4 "between 10,000 and 20,000 residents" 5 "between 20,000 and 50,000 residents" 6 "between 50,000 and 100,000 residents" 7 "between 100,000 and 500,000 residents" 8 "more than 500,000 residents"
label values v77 residents

**generate dependent variables based on survey responses**

**climate most important issue**
generate climate_1 = 1 if v33 == 15
replace climate_1 = 0 if v33 != 15

**climate second most important issue**
generate climate_2 = 1 if v34 == 15
replace climate_2 = 0 if v34 != 15

**climate one of top two most important issues**
generate climate_top = 1 if climate_1 == 1 | climate_2 ==1
replace climate_top = 0 if climate_1 == 0 & climate_2 == 0

**positive feelings toward greens**
drop if v12 == 99
generate like_greens = 1 if v12 > 6
replace like_greens = 0 if v12 <=6

**labelling dependent variables**
label variable like_greens "Hold Positive Feelings towards the Green Party"
label variable climate_top "Climate Top Concern"

save CumulatedData, replace

**cleaning plant data**
clear all
set more off

cd "/Users/leamorical/Desktop/14.33/"

import excel using states_allplants.xlsx, firstrow

**labelling states**
label define states 1 "Schleswig-Holstein" 2 "Hamburg" 3 "Niedersachsen" 4 "Bremen" 5 "Nordrhein-Wastfalen" 6 "Hessen" 7 "Rheinland-Pfalz" 8 "Baden-Wuttemberg" 9 "Bayern" 10 "Saarland" 11 "Berlin-West" 12 "Berlin-East" 13 "Brandenburg" 14 "Mecklenburg-Vorpommern" 15 "Sachsen" 16 "Sachsen-Anhalt " 17 "Thuringen" 99 "NA"
label values state states

**reshape**
reshape long produce_ev  evfuture_, i(state) j(year)

**merge with survey data**
rename year v4

save states_allplants, replace

merge 1:m state v4 using CumulatedData 


save PlantMerged

**run regressions**

**first regression: dependent on independent state and year fixed effects**
**second regression: dep on ind state and year fixed effects + controls**
**second regression: dep on ind state and year fixed effects + controls only for people with vocational training**

**climate top on produce EVs**
est clear
eststo: quietly regress climate_top produce_ev i.state i.v4 [weight = v78], cluster(state)
eststo: quietly regress climate_top produce_ev i.state i.v4 i.v60 i.v57 i.v56 i.v52 i.v54 [weight = v78], cluster(state)
eststo: quietly regress climate_top produce_ev i.state i.v4 i.v60 i.v57 i.v56 i.v52 i.v54 if v61 == 1 [weight = v78], cluster(state)

**climate top on will produce EVs**
eststo: quietly regress climate_top evfuture_ i.state i.v4 [weight = v78], cluster(state)
eststo: quietly regress climate_top evfuture_ i.state i.v4 i.v60 i.v57 i.v56 i.v52 i.v54 [weight = v78], cluster(state)
eststo: quietly regress climate_top evfuture_ i.state i.v4 i.v60 i.v57 i.v56 i.v52 i.v54 if v61 == 1 [weight = v78], cluster(state)

**like greens on produce EVs**
eststo: quietly regress like_greens produce_ev i.state i.v4 [weight = v78], cluster(state)
eststo: quietly regress like_greens produce_ev i.state i.v4 i.v60 i.v57 i.v56 i.v52 i.v54 [weight = v78], cluster(state)
eststo: quietly regress like_greens produce_ev i.state i.v4 i.v60 i.v57 i.v56 i.v52 i.v54 if v61 == 1 [weight = v78], cluster(state)

**like greens on will produce EVs**
eststo: quietly regress like_greens evfuture_ i.state i.v4 [weight = v78], cluster(state)
eststo: quietly regress like_greens evfuture_ i.state i.v4 i.v60 i.v57 i.v56 i.v52 i.v54 [weight = v78], cluster(state)
eststo: quietly regress like_greens evfuture_ i.state i.v4 i.v60 i.v57 i.v56 i.v52 i.v54 if v61 == 1 [weight = v78], cluster(state)

**output tables to .tex file**
esttab est1 est2 est3 est4 est5 est6 using set1.tex, star p label title(Regression Results of EV Production and Future Production on Climate Change as a Top Concern) keep(produce_ev evfuture_) 

esttab est7 est8 est9 est10 est11 est12 using set2.tex, star p label title(Regression Results of EV Production and Future Production on Green Party Perception) keep(produce_ev evfuture_) 

**make event study figure**

**generate time variable**
bysort state: egen temp_min = min(v4) if produce_ev == 1
bysort state: egen min_year = min(temp_min)
gen timevar = v4 - min_year

**create figure**
eventdd climate_top i.state i.v4 [weight = v78], cluster(state) timevar(timevar) ci(rcap)

