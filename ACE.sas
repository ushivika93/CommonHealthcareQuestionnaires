*************************************************************************************/
Program name: ACE
Notes: 
***************************************************************************************/;

options nofmterr;

*import data;
*if the path doesn't work,please try:"T:\epiprojs\epicore\Tene Lewis grants\MUSE\Datasets\Received\Survey\Survey Gizmo Exports\Muse_baseline\muse_baseline_20218720\spss.sav";
proc import datafile=" "
			out=fullds;
run;
*check variables;
proc contents data=fullds;
run;

*confirm import is ok;
proc print data=fullds (obs=18);
run;

/*******Set up macro variables********/
*change for each QC;
%let scale=ACE;
*SG variable names to check: ;
%let varlist= ACE1-ACE10;

%put  &scale &varlist;


*output raw counts for subscale;
options nodate nonumber;
ods rtf file="\ACE_RAW_Summary.rtf"; *This will print to whatever directory SAS was opened from;
proc freq data=fullds; *Be sure to include the whole file path to ensure that summary statistics are saved in the appropriate place;
table &varlist / list;
run;
ods rtf close;

*Check numeric representation of the coded variables;
proc freq data=fullds;
table &varlist;
format &varlist f8.;
run; 
*Shows variables take on values (0=No,1=Yes ),all missing data will be missing;

data ds1;
	set fullds;
	array ACE(10);
	array ACE_origin &varlist.;
	ACE_num_miss = 0;

	**Keep the values of ACE variables the same; 
	
	do i=1 to 10;
		if ACE_origin(i)=. then ACE(i)=.;
		else ACE(i) = ACE_origin(i);
		if ACE(i)=. then ACE_num_miss=ACE_num_miss+1;
	end;
	
	RAW_SUM_ACE = ACE1+ACE2+ACE3+ACE4+ACE5+ACE6+ACE7+ACE8+ACE9+ACE10;
	RAW_AVG_ACE = mean(ACE1,ACE2,ACE3,ACE4,ACE5,ACE6,ACE7,ACE8,ACE9,ACE10);
	*only allow < 10*0.2=2 missing variables;
	if ACE_num_miss < 2 then SUM_ACE = sum(ACE1,ACE2,ACE3,ACE4,ACE5,ACE6,ACE7,ACE8,ACE9,ACE10)
												+ RAW_AVG_ACE*ACE_num_miss;
	ELSE SUM_ACE =.;
    label SUM_ACE ="(Imputed) Summary Score for ACE Scale";
	drop  i; 
	ACE_ABUSE = ACE1+ACE2+ACE3;
	ACE_NEGLECT= ACE4+ACE5;
	ACE_HOUSEHOLDDYSFUNCTION= ACE6+ACE7+ACE8+ACE9+ACE10;
    
	label ace_abuse= 'ACE Subscale- Abuse';
	label ace_neglect= 'ACE Subscale- Neglect';
	label ace_HOUSEHOLDDYSFUNCTION= 'ACE Subscale- Household Dysfnction';

	
run;	
proc contents data=ds1;
run;

proc freq data=ds1;
tables ACE1  ACE2;
run;
*check the missing ACE variables;
proc freq data=ds1;
tables ACE_num_miss;
run;

proc univariate data = ds1;
	var SUM_ACE ACE_ABUSE ACE_NEGLECT ACE_HOUSEHOLDDYSFUNCTION ;
run; 

*output cleaned counts;
options nonumber;
ods rtf file="\Summary_ACE.rtf";
title "Summarization of ACE Summary Variables and Missing Values at baseline";
proc univariate data=ds1;
var RAW_SUM_ACE SUM_ACE RAW_AVG_ACE ACE_ABUSE ACE_NEGLECT ACE_HOUSEHOLDDYSFUNCTION;
run;
proc freq data =ds1;
table ACE_num_miss;
run;
title;
title "Summarization of Raw and Imputed Sum of ACE total score and subscales_Baseline";
proc means data=ds1 n range min max mean std q1 median q3 nmiss maxdec=2;
var  RAW_SUM_ACE SUM_ACE ACE_ABUSE ACE_NEGLECT ACE_HOUSEHOLDDYSFUNCTION;
run;
title;
title "Internal Consistency Ace Abuse";
proc corr data=ds1 alpha nomiss nocorr noprob nosimple;
	var ACE1 ACE2 ACE3 ACE4 ACE5 ACE6 ACE7 ACE8 ACE9 ACE10;
run;
title "Internal Consistency Ace Abuse";
proc corr data=ds1 alpha nomiss nocorr noprob nosimple;
	var ACE1 ACE2 ACE3 ;
run;
title "Internal Consistency Ace Neglect";
proc corr data=ds1 alpha nomiss nocorr noprob nosimple;
	var ACE4 ACE5;
run;
title "Internal Consistency ACE Household Dysfunction";
proc corr data=ds1 alpha nomiss nocorr noprob nosimple;
	var ACE6 ACE7 ACE8 ACE9 ACE10;
run;
title;
ods rtf close;

*output cleaned/QC'd data to data folder;
libname aces " " ;
data aces.ACE_ds;
	set ds1;
run;

/*End of program*/

