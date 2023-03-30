/* Question 1 */
libname HW7 "/home/u60739998/BS 805/Class 7";

data crash_temp;
	set HW7.crash;
	
	if protection = "airbags" then airbag=1; else airbag=0;
	if protection = "manual belts" then manual=1; else manual=0;
	if protection = "motorized belts" then motorized=1; else motorized=0;
	
run;

proc reg data=crash_temp;
	model chest_decel=airbag manual motorized/clb;
	test airbag, manual, motorized = 0;
run;
*no signifncant differences when compared to passive. however, if i set ref to airbags
there is a sig difference between airbags and manual:
/* proc glm data=crash_temp;
	*class protection (ref="airbags");
	*model chest_decel=protection/solution;
*run;

proc sort data=crash_temp;
	by protection;
run;

proc means data=crash_temp;
	by protection;
	var chest_decel;
run;

proc sgplot data=crash_temp;
	vbox chest_decel / category=protection;
	title1 "Boxplot of Chest Deceleration by Kind of Protection";
run;title;

/* Question 2 */
proc glm data=crash_temp;
	class d_p size protection; *default ref group for protection is passive;
	model chest_decel=protection wt d_p size/clparm solution;
run;

/* Question 3 */
proc glm data=crash_temp;
	class d_p size protection; *default ref group for protection is passive;
	model chest_decel=protection wt d_p size protection*wt/solution;
run;

/* Question 4 */
data crash_temp2;
	set crash_temp;
	where d_p = "Driver";
	wtsqr = wt**2;
run;

proc means data=crash_temp2;
	var chest_decel wt wtsqr;
run;

proc rank groups=10 data=crash_temp2 out=one;
	var chest_decel wt wtsqr;
	ranks rchest_decel rwt rwtsqr;
run;

proc sgplot data=one;
	vbox chest_decel / category= rwt;
	title1 "Boxplots of Chest Deceleration Score by Weight Rank";
run; title;
	
/* Question 5 */
proc reg data=crash_temp2;
	model chest_decel=wt wtsqr/stb pcorr2 r;
	id carI_and_year;
	output out=two p=chest_pred student=chest_r press=chest_press;
run;

proc sort data=two;
	by wt;
run;

proc sgplot data=two;
	series x=wt y=chest_pred;
	scatter x=wt y=chest_decel;
run;

/* Question 6 */
proc univariate plots normal data=two;
	id carI_and_year;
	var chest_r;
run;

proc univariate plots data=two;
	id carI_and_year;
	var chest_press;
run;
