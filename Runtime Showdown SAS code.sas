/* Replicated Latin Square Design*/
PROC IMPORT DATAFILE="/home/u63064808/Stat571B/LSD Project Data New.xlsx"
	DBMS=xlsx 
	OUT=data
	REPLACE; 
	GETNAMES=YES; 
RUN;


/*Original Analysis*/
title 'Latin Square Design';
proc glm data=data;
class language task size LSReplicate;
model time=language task(LSReplicate) size LSReplicate;
output out=output r=res p=pred;
run;

/* check constant variance */
title 'Constant variance checking';
proc sgplot data=output; 
scatter x=pred y=res;
refline 0;
run;

/* check normality */
title 'Normality checking';
proc univariate data=output normal;
var res;
qqplot res/normal (mu=0 sigma=est);
run;

/* check constant variance */
title 'Constant variance checking';
proc sgplot data=output; 
scatter x=pred y=res;
refline 0;
run;

/* check normality */
title 'Normality checking';
proc univariate data=output normal;
var res;
qqplot res/normal (mu=0 sigma=est);
run;


/*Do Transformation*/
title 'Transformation';
proc transreg data=output;
 model boxcox(time/convenient lambda=-2.0 to 2.0 by 0.1)=class(language task size LSReplicate); 
run;

/* do transformation on the response */
title 'Log Transform';
data newdata;
 set data;
 newtime=log(time);
run;


/*Do new analysis*/
title 'Latin Square Design - NEW';
proc glm data=newdata;
class language task size LSReplicate;
model newtime=language task(LSReplicate) size LSReplicate;
output out=newoutput r=res p=pred;
run;


/* check constant variance */
title 'Constant variance checking - NEW';
proc sgplot data=newoutput; 
scatter x=pred y=res;
refline 0;
run;

/* check normality */
title 'Normality checking - NEW';
proc univariate data=newoutput normal;
var res;
qqplot res/normal (mu=0 sigma=est);
run;

/* post-ANOVA comparison */
title 'Post-ANOVA Comparison';
proc glm data=newoutput;
class language task size LSReplicate;
model newtime=language task(LSReplicate) size LSReplicate;
means language/ lines lsd;
output out=new r=res p=pred;
run;


