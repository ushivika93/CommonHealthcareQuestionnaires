/* cap input rows for the captured run */
options obs=100;

/* upstream ACE.sas opens with: options nofmterr; */
options nofmterr;

/*
  The upstream script reads its cohort via `proc import datafile=" "` from an
  external survey export. This bundle ships a small synthetic ACE dataset with
  the exact ACE1-ACE10 (0=No, 1=Yes) shape the script expects, so the scoring
  logic below runs unmodified against realistic input. No real respondent data
  is used or transmitted.
*/
data fullds;
    input ACE1 ACE2 ACE3 ACE4 ACE5 ACE6 ACE7 ACE8 ACE9 ACE10;
    datalines;
0 0 0 0 0 0 0 0 0 0
1 1 0 0 0 1 0 0 0 0
1 0 1 0 1 0 0 1 0 0
0 0 0 0 0 1 1 0 0 1
1 1 1 1 1 1 1 1 1 1
0 1 0 0 0 0 0 0 1 0
1 0 0 1 0 0 0 0 0 0
0 0 1 0 0 1 0 0 0 1
1 1 0 0 1 0 1 0 0 0
0 0 0 0 0 0 0 0 0 0
1 0 0 0 1 0 0 1 1 0
0 1 1 1 0 0 0 0 0 0
1 1 1 0 0 1 0 1 0 1
0 0 0 0 1 0 0 0 0 0
1 0 1 0 0 0 1 0 1 0
0 1 0 1 0 1 0 0 0 1
1 1 1 1 0 0 0 0 0 0
0 0 0 0 0 0 1 1 1 1
;
run;
