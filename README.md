# CDS492-CAPSTONE PROJECT
Benjamin Green (2023) 

GOAL AND PURPOSE

This research project aims to explore the relationship between divorce trends across the globe
and accompanying suicide rates. Unlike previous studies which are largely based on localized
comparisons of divorce and suicide rates, the study will seek to analyze differences across
several countries in order to more effectively account for covariates. Furthermore, again, unlike
previous studies, the focus will not simply be on the rates of these two variables, rather, the
variation in index scores for divorce freedom will be compared to corresponding suicide rates.
Using this explanatory variable instead of simply using divorce rates allows for more applicable
interpretation. Since divorce rates cannot be manipulated but only observed, unless there exists a
thorough understanding of its own explanatory variables, establishing correlations between such
rates does little in the way of providing a solution. However, if the confounding variables can be
adequately accounted for, which the inclusion of several countries hopes to accomplish, then
identifying the nature of the relationship between divorce freedom and suicide rates could
potentially provide real solutions since policy regarding divorce can be altered to produce
optimal outcomes.

WHAT YOU'LL NEED

This analysis will be conducted using R and three datasets containing information on global suicide 
rates, human freedom index scores, and divorce rates. 

To obtain the global suicide dataset:
1. Visit https://data.oecd.org/healthstat/suicide-rates.htm
2. A chart should appear. Unselect 'latest data available' and 
manually adjust the year bands to 2010-2020.
3. At the top of the chart, select download and choose the 'selected data only' option.  
4. This file MUST be renamed to 'SUICIDES'  


To obtain the global human freedom index data:
1. Visit https://www.cato.org/human-freedom-index/2022.
2. Download the xlsx version of the data. It is located at the top of the box on the left
3. 4. This file MUST be renamed to 'HFINDEX'  


To obtain the global divorce rates data:
1. Visit https://ourworldindata.org/marriages-and-divorces.
2. Scroll down to 'Divorces'. There will be a graph on the right.
3. Set the time bands to 2010-2018 and Download the xlsx version of the data. 
4. Name the dataset DIVORCE_RATE

Move all three datasets to your Downloads folder. 

To ensure these datasets succesfully appear and function in the code within Capston_Analysis.R, ensure both files are
1. Saved in .xlsx format. 
2. Named correctly as previously specified. 
3. Located in the Downloads folder. 





