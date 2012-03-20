* This file contains definitions for exogenous trends: population, labor
* productivity and AEEI, etc.


*-----------------------------------------------------------------------------
*	USREP
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*	POPULATION GROWTH RATES based on US Census projections to 2030:

parameter popgrowth	5-year population growth rate (in %)
	  popgrowth_a	Annual population growth rate --imputed from 5yr average (in %);

popgrowth(s,t)$population_uscensus(s,t-1) = (population_uscensus(s,t)/population_uscensus(s,t-1)-1);
* 5year time step:
*popgrowth_a(r,t)$(popgrowth(r,t) gt 0) = ( (1+popgrowth(r,t))**(1/5) - 1);
* 2year time step:
popgrowth_a(s,t)$(popgrowth(s,t) gt 0) = ( (1+popgrowth(s,t))**(1/2) - 1);


*-----------------------------------------------------------------------------
*	LABOR PRODUCTIVITY GROWTH:

TABLE 
	rates_(*,*) Base year ANNUAL productivity and population growth rates (%)

	    PRD-start	PRD-end	POP-end	AEEI
USA         2.5		2.0	0.0	1.0;

*	NB: Initial productivity growth rates comes from: http://www.bls.gov/lpc/prodybar.htm

*	Inititalize rates for regions:

*	ASSUME HERE uniform labor productivity growth rates across all regions:

*	Uniform rates (with initial rate of 2.5% and 2.0% in 2100):

rates_(s,"prd-start") = rates_("usa","prd-start");

*	INITIAL LABOR PRODUCTIVITY GROWTH:

*	Adjust initial labor productivity growth rates to match approx.
*	forecasted GDP growth rates:

parameter corr Initial regional correction factor for labor productivity growth rates to match GDP forecasts in 2006;

*	NB: We have data on US Census regions that do not exactly conincide with USREP model regions. We target GDP
*	    growth rates for the "least common denominator" of regional aggregates.

*$ontext
*ENC,ESC,SAT,MAT = NEAST,SEAST,FL,NY
corr("fl") = 0.65;
corr("ny") = 0.65;
corr("seas") = 0.65;
corr("neas") = 0.65;
*MNT = MOUNT
corr("moun") = 0.7;
*NEW = NENGL
corr("neng") = 0.5;
*PAC = PACIF,CA,AK
corr("ak") = 2;
corr("ca") = .9;
corr("paci") = .9;
*WNC = NCENT
corr("ncen") = 0.5;
*WSC = TX,SCENT
corr("tx") = 0.75;
corr("scen") = 0.8;

corr(s) = .4*corr(s);

rates_("FL","prd-start") =  corr("fl")*rates_("usa","prd-start");
rates_("NY","prd-start") =  corr("ny")*rates_("usa","prd-start");
rates_("SEAS","prd-start") =  corr("seas")*rates_("usa","prd-start");
rates_("NEAS","prd-start") =  corr("neas")*rates_("usa","prd-start");
rates_("MOUN","prd-start") =  corr("moun")*rates_("usa","prd-start");
rates_("NENG","prd-start") =  corr("neng")*rates_("usa","prd-start");
rates_("AK","prd-start") =  corr("ak")*rates_("usa","prd-start");
rates_("CA","prd-start") =  corr("ca")*rates_("usa","prd-start");
rates_("PACI","prd-start") =  corr("paci")*rates_("usa","prd-start");
rates_("NCEN","prd-start") =  corr("ncen")*rates_("usa","prd-start");
rates_("TX","prd-start") =  corr("tx")*rates_("usa","prd-start");
rates_("SCEN","prd-start") =  corr("scen")*rates_("usa","prd-start");

* Assume that labor productivity growth rates for all regions converge in 2100:
rates_(r,"prd-end") = rates_("usa","prd-end");





* Define productivity growth trend.
	
PARAMETERS        

        FPROD(*,T)             Fixed factor productivity;

FPROD(rs,T) = (1 + 0.01)**(2*(ORD(T) - 1));
*$ontext
FPROD("ind",T) = (1 + 0.032)**(2*(ORD(T) - 1));
FPROD("bra",T) = (1 + 0.032)**(2*(ORD(T) - 1));
FPROD("chn",T) = (1 + 0.02)**(2*(ORD(T) - 1));
FPROD("rea",T) = (1 + 0.015)**(2*(ORD(T) - 1));
FPROD("lam",T) = (1 + 0.015)**(2*(ORD(T) - 1));
FPROD("mex",T) = (1 + 0.02)**(2*(ORD(T) - 1));
FPROD("afr",T) = (1 + 0.015)**(2*(ORD(T) - 1));
*$offtext

* Labor productivity


TABLE RATES(*,*) Base year growth and savings rates (%)

	    PRD-start	POP-start	PRD-end	POP-end	AEEI
*$ontext
*USA         2.3		1.1		2.0	0.0	1.0
CAN         2.3		1.0		2.0	0.0	1.0
MEX         3.0		1.7		2.0	0.0	1.0
JPN         2.9		0.3		2.0	0.0	1.0
ANZ         2.3		1.1		2.0	0.0	1.0
ROE         4.0		-0.2		2.0	0.0	1.0
RUS         4.0		-0.1		2.0	0.0	1.0
ASI         4.4		1.6		2.0	0.0	1.0
CHN         5.5		0.9		2.0	0.0	1.0
IND         4.0		1.8		2.0	0.0	1.0
BRA         4.0		1.4		2.4	0.1	1.0
AFR         2.0		2.6		2.4	0.1	1.0
MES         2.0		2.7		2.4	0.1	1.0
LAM         3.0		1.6		2.4	0.1	1.0
REA         3.0		2.0		2.4	0.1	1.0
EUR         2.3		0.2		2.0	0.0	1.0
*$offtext
ROW         2.3		0.2		2.0	0.0	1.0

AK			1.0		
CA			1.1	
FL			1.9
NY			0.2
TX			1.6
NENG			0.5
SEAS			1.0
NEAS			0.4
SCEN			0.5
NCEN			0.5
MOUN			1.7
PACI			1.0
;


rates(s,"pop-end") = 0;
rates(s,"aeei") = 0.01;
rates(s,"prd-start") = rates_(s,"prd-start");
rates(s,"prd-end") = 2;

* Growth = Productivity Growth + Population growth

rates(rs,"prd") = rates(rs,"prd-start") + rates(rs,"pop-start");
rates(rs,"prd100") = rates(rs,"prd-end") + rates(rs,"pop-end");


PARAMETER
	 PRDGR0(*)      Base year productivity growth rate (%)
	 PRDGR100(*)    Productivity growth rate at the end of horizon
	 GPROD(*,T)     Productivity index;

PRDGR0(rs)   = RATES(rs,"PRD")/100;
PRDGR100(rs) = RATES(rs,"PRD100")/100;

prdgr0(rs) = 1.15*prdgr0(rs);

$ontext
prdgr0(oecd) = 1.1*prdgr0(oecd);


prdgr0("ROE") = 1.2*prdgr0("ROE");
prdgr0("lam") = 1.2*prdgr0("lam");
prdgr0("eur") = 1.45*prdgr0("eur");
prdgr0("jpn") = 1.1*prdgr0("jpn");
prdgr0("mex") = 1.2*prdgr0("mex");
prdgr0("anz") = 1.25*prdgr0("anz");
prdgr0("asi") = 0.8*prdgr0("asi");
prdgr0("chn") = 0.8*prdgr0("chn");

prdgr100("mex") = 0.8*prdgr100("mex");
prdgr100("afr") = 0.8*prdgr100("afr");
prdgr100("REA") = 0.8*prdgr100("REA");
prdgr100("lam") = 0.8*prdgr100("lam");
prdgr100("can") = 1.05*prdgr100("can");
prdgr100("eur") = 1.05*prdgr100("eur");
prdgr100("ROE") = 1.2*prdgr100("ROE");
prdgr100("asi") = 1.05*prdgr100("asi");

* CCSP model
prdgr100(oecd) = 0.6*prdgr100(oecd);
* add to CCSP model
prdgr100("RUS") = 0.8*prdgr100("RUS");
prdgr100("ROE") = 0.6*prdgr100("ROE");
$offtext

* Simulate productivity and compute the growth index relative to 1997


parameter glr(*,t),alpha,beta;
alpha=0.1;
beta=0.07;
glr(rs,t) = (1+alpha)*(prdgr0(rs)-prdgr100(rs))/(1+alpha*exp(2*beta*(ord(t)-1)))+prdgr100(rs);


*-----------------------------------------------------------------------------
*	Optional plots (for model development):
*-----------------------------------------------------------------------------

$ontext
parameter 
	  temp_(t,rs) Fitted labor productivity growth rate;
temp_(t,rs) = glr(rs,t);
set tlabel(t) /2010,2020,2022,2024,2028,2030,2050,2080,2100/;
*$setglobal labels t
$setglobal labels tlabel
$libinclude plot temp_
$exit
$offtext


* Calibrated to IMF World Economic Outlook (2009)


gprod(rs,"2004") =1;

*$ontext
* 2004
*glr("usa", "2004") = 0.025;
glr("can", "2004") = 0.02;
glr("mex", "2004") = 0.08;
glr("jpn", "2004") = 0.0008;
glr("anz", "2004") = 0.012;
glr("eur", "2004") = 0.026;
glr("ROE", "2004") = 0.059;
glr("RUS", "2004") = 0.09;
glr("asi", "2004") = 0.065;
glr("chn", "2004") = 0.14;
glr("ind", "2004") = 0.178;
glr("BRA", "2004") = 0.10;
glr("afr", "2004") = 0.11;
glr("mes", "2004") = 0.20;
glr("lam", "2004") = 0.06;
glr("REA", "2004") = 0.10;


* 2005 (affects 2010 growth numbers)
*glr("usa", "2005") = 0.015;
glr("can", "2006") = 0.014;
glr("mex", "2006") = 0.035;
glr("jpn", "2006") = 0.009;
glr("anz", "2006") = 0.025;
glr("eur", "2006") = 0.01;
glr("roe", "2006") = 0.065;
glr("rus", "2006") = 0.041;
glr("asi", "2006") = 0.028;
glr("chn", "2006") = 0.21;
glr("ind", "2006") = 0.19;
glr("bra", "2006") = 0.055;
glr("afr", "2006") = 0.11;
glr("mes", "2006") = 0.17;
glr("lam", "2006") = 0.07;
glr("rea", "2006") = 0.15;



* 2010
*glr("usa", "2010") = 0.045;
glr("can", "2010") = 0.041;
glr("mex", "2010") = 0.05;
glr("jpn", "2010") = 0.031;
glr("anz", "2010") = 0.048;
glr("eur", "2010") = 0.037;
glr("roe", "2010") = 0.052;
glr("rus", "2010") = 0.039;
glr("asi", "2010") = 0.052;
glr("chn", "2010") = 0.12;
glr("ind", "2010") = 0.14;
glr("bra", "2010") = 0.057;
glr("afr", "2010") = 0.039;
glr("mes", "2010") = 0.047;
glr("lam", "2010") = 0.039;
glr("rea", "2010") = 0.05;



* 2015
*glr("usa", "2015") = 0.034;
glr("can", "2016") = 0.038;
glr("mex", "2016") = 0.044;
glr("jpn", "2016") = 0.028;
glr("anz", "2016") = 0.045;
glr("eur", "2016") = 0.035;
glr("roe", "2016") = 0.045;
glr("rus", "2016") = 0.038;
glr("asi", "2016") = 0.035;
glr("chn", "2016") = 0.10;
glr("ind", "2016") = 0.120;
glr("bra", "2016") = 0.035;
glr("afr", "2016") = 0.042;
glr("mes", "2016") = 0.052;
glr("lam", "2016") = 0.05;
glr("rea", "2016") = 0.055;



* 2020
*glr("usa", "2020") = 0.034;
glr("can", "2020") = 0.04;
glr("mex", "2020") = 0.051;
glr("jpn", "2020") = 0.029;
glr("anz", "2020") = 0.049;
glr("eur", "2020") = 0.035;
glr("roe", "2020") = 0.052;
glr("rus", "2020") = 0.035;
glr("asi", "2020") = 0.042;
glr("chn", "2020") = 0.08;
glr("ind", "2020") = 0.12;
glr("bra", "2020") = 0.045;
glr("afr", "2020") = 0.06;
glr("mes", "2020") = 0.06;
glr("lam", "2020") = 0.052;
glr("rea", "2020") = 0.07;



* 2025
*glr("usa", "2025") = 0.037;
glr("can", "2026") = 0.043;
glr("mex", "2026") = 0.059;
glr("jpn", "2026") = 0.03;
glr("anz", "2026") = 0.045;
glr("eur", "2026") = 0.035;
glr("roe", "2026") = 0.055;
glr("rus", "2026") = 0.029;
glr("asi", "2026") = 0.047;
*glr("chn", "2026") = 0.08;
glr("chn", "2026") = 0.07;
glr("ind", "2026") = 0.07;
glr("bra", "2026") = 0.045;
glr("afr", "2026") = 0.06;
glr("mes", "2026") = 0.062;
glr("lam", "2026") = 0.048;
glr("rea", "2026") = 0.075;


* 2030
*glr("usa", "2030") = 0.034;
glr("can", "2030") = 0.035;
glr("mex", "2030") = 0.059;
glr("jpn", "2030") = 0.028;
glr("anz", "2030") = 0.04;
glr("eur", "2030") = 0.031;
glr("roe", "2030") = 0.05;
glr("rus", "2030") = 0.015;
glr("asi", "2030") = 0.042;
*glr("chn", "2030") = 0.08;
glr("chn", "2030") = 0.06;
glr("ind", "2030") = 0.05;
glr("bra", "2030") = 0.04;
glr("afr", "2030") = 0.06;
glr("mes", "2030") = 0.06;
glr("lam", "2030") = 0.042;
glr("rea", "2030") = 0.06;


* 2035
*glr("usa", "2036") = 0.03;
glr("can", "2036") = 0.035;
glr("mex", "2036") = 0.057;
glr("jpn", "2036") = 0.025;
glr("anz", "2036") = 0.035;
glr("eur", "2036") = 0.029;
glr("roe", "2036") = 0.038;
glr("rus", "2036") = 0.017;
glr("asi", "2036") = 0.037;
glr("chn", "2036") = 0.04;
glr("ind", "2036") = 0.02;
glr("bra", "2036") = 0.034;
glr("afr", "2036") = 0.03;
glr("mes", "2036") = 0.009;
glr("lam", "2036") = 0.04;
glr("rea", "2036") = 0.03;


* 2040
*glr("usa", "2040") = 0.028;
glr("can", "2040") = 0.033;
glr("mex", "2040") = 0.053;
glr("jpn", "2040") = 0.023;
glr("anz", "2040") = 0.033;
glr("eur", "2040") = 0.027;
glr("roe", "2040") = 0.03;
glr("rus", "2040") = 0.018;
glr("asi", "2040") = 0.033;
glr("chn", "2040") = 0.04;
glr("ind", "2040") = 0.03;
glr("bra", "2040") = 0.033;
glr("afr", "2040") = 0.031;
glr("mes", "2040") = 0.023;
glr("lam", "2040") = 0.038;
glr("rea", "2040") = 0.04;


* 2045
*glr("usa", "2046") = 0.027;
glr("can", "2046") = 0.03;
glr("mex", "2046") = 0.049;
glr("jpn", "2046") = 0.02;
glr("anz", "2046") = 0.029;
glr("eur", "2046") = 0.025;
glr("roe", "2046") = 0.029;
glr("rus", "2046") = 0.017;
glr("asi", "2046") = 0.035;
glr("chn", "2046") = 0.04;
glr("ind", "2046") = 0.04;
glr("bra", "2046") = 0.031;
glr("afr", "2046") = 0.031;
glr("mes", "2046") = 0.02;
glr("lam", "2046") = 0.035;
glr("rea", "2046") = 0.04;


* 2050
*glr("usa", "2050") = 0.021;
glr("can", "2050") = 0.028;
glr("mex", "2050") = 0.047;
glr("jpn", "2050") = 0.016;
glr("anz", "2050") = 0.029;
glr("eur", "2050") = 0.022;
glr("roe", "2050") = 0.021;
glr("rus", "2050") = 0.01;
glr("asi", "2050") = 0.02;
glr("chn", "2050") = 0.02;
glr("ind", "2050") = 0.017;
glr("bra", "2050") = 0.029;
glr("afr", "2050") = 0.032;
glr("mes", "2050") = 0.021;
glr("lam", "2050") = 0.038;
glr("rea", "2050") = 0.034;
*$offtext

gprod(r,"2006") = gprod(r,"2004")*(1+glr(r,"2004")); 
gprod(r,"2010") = gprod(r,"2006")*(1+glr(r,"2006"))**2; 


loop(t,
if(ord(t) ge 1,
gprod(rs,t+1) = gprod(rs,t)*(1+glr(rs,t))**2; 
);
);



* Population and effective labor supply.

Parameters

	POPULATION(RS,T)        POPULATION OF REGION R IN YEAR T;
 
* EPPA4 updated (table 17).

*$include ..\data\popa_eppa_e5.dat
*population(r,t) = popa_eppa5(r,t);




* Define AEEI trends.

PARAMETERS
	LAMDAE(I,*,T)          AEEI FACTORS FOR SECTORS
	LAMDACE(*,T)           AEEI FACTOR FOR CONSUMPTION
	LAMDAGE(*,T)           AEEI FACTOR FOR GOVERNMENT
	LAMDAIE(*,T)           AEEI FACTOR FOR INVESTMENT;
 
PARAMETER       GAMAEG(*)    INITIAL AEEI GROWTH RATE FOR GOVERNMENT
*$ontext
	/
*	USA               0.01
	 can		   0.01
	 mex		   0.01
	 JPN               0.01
	 anz		   0.01
	 eur               0.01
	 ROE               0.01
	 RUS               0.01
	 asi               0.01
	 chn               0.01 
	 IND               0.01
	 BRA               0.01
	 afr		   0.01
	 mes               0.01
	 lam               0.01
	 REA               0.01/
*$offtext
;
GAMAEG(rs) = 0.01;

GAMAEG(s) = 0.01;

PARAMETER       GAMAEI(*)    INITIAL AEEI GROWTH RATE FOR INVESTMENT
*$ontext
	/
*	USA               0.01
	 can		   0.01
	 mex		   0.01
	 JPN               0.01
	 anz		   0.01
	 eur               0.01
	 ROE               0.01
	 RUS               0.01
	 asi               0.01
	 chn               0.01 
	 IND               0.01
	 BRA               0.01
	 afr		   0.01
	 mes               0.01
	 lam               0.01
	 REA               0.01/
*$offtext
;

GAMAEI(rs) = 0.01;
	
GAMAEI(s) = 0.01;

* Notes 0s in energy sectors.

TABLE GAMAES(*,I)       INITIAL AEEI GROWTH RATES FOR SECTORS
	
	 COL     CRU     GAS     OIL     ELE      EIS     MAN	TRN	SRV
*$ontext
*USA      0.0     0.0     0.0     0.0     0.01     0.01    0.01	0.01	0.01
can      0.0     0.0     0.0     0.0     0.01     0.01    0.01	0.01	0.01
mex      0.0     0.0     0.0     0.0     0.01     0.01    0.01	0.01	0.01
JPN      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
anz      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
eur      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
ROE      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
RUS      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
asi      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
chn      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
IND      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
BRA      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
afr      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
mes      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
lam      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01
REA      0.0     0.0     0.0     0.0     0.01     0.01    0.01	0.01	0.01
*$offtext
row      0.0     0.0     0.0     0.0     0.01     0.01    0.01 	0.01	0.01

;
		   
GAMAES(S,I) = GAMAES("eur",I);

parameter GAMAEC(RS)       INITIAL AEEI GROWTH RATES FOR CONSUMER GOODS; 
gamaec(rs)=0.01;


LAMDAE(I,RS,T) = EXP(2*Rates(rs,"aeei")*GAMAES(Rs,I)*(ORD(T)-1)*(1-(ORD(T)-1)/100)); 

LAMDACE(rs,T) = EXP(2*Rates(rs,"aeei")*GAMAEC(rs)*(ORD(T)-1)*(1-(ORD(T)-1)/100)); 
LAMDAGE(rs,T) = EXP(2*Rates(rs,"aeei")*GAMAEG(rs)*(ORD(T)-1)*(1-(ORD(T)-1)/100)); 
LAMDAIE(rs,T) = EXP(2*Rates(rs,"aeei")*GAMAEI(rs)*(ORD(T)-1)*(1-(ORD(T)-1)/100)); 


*$ontext
LAMDAE(I,"rus",T)$(ord(t) ge 4) = 1.23 * LAMDAE(I,"rus",T);
LAMDAE(I,"roe",T)$(ord(t) ge 4) = 1.2 * LAMDAE(I,"roe",T);
LAMDAE(I,"eur",T)$(ord(t) ge 4) = 1.1 * LAMDAE(I,"eur",T);


LAMDACE("rus",T)$(ord(t) ge 4) = 1.23 * LAMDACE("rus",T);
LAMDACE("roe",T)$(ord(t) ge 4) = 1.2 * LAMDACE("roe",T);
LAMDACE("eur",T)$(ord(t) ge 4) = 1.1 * LAMDACE("eur",T);

LAMDAIE("rus",T)$(ord(t) ge 4) = 1.23 * LAMDAIE("rus",T);
LAMDAIE("roe",T)$(ord(t) ge 4) = 1.2 * LAMDAIE("roe",T);
LAMDAIE("eur",T)$(ord(t) ge 4) = 1.1 * LAMDAIE("eur",T);

LAMDAGE("rus",T)$(ord(t) ge 4) = 1.23 * LAMDAGE("rus",T);
LAMDAGE("roe",T)$(ord(t) ge 4) = 1.2 * LAMDAGE("roe",T);
LAMDAGE("eur",T)$(ord(t) ge 4) = 1.1 * LAMDAGE("eur",T);



LAMDAE(I,"chn", "2004")= 1.2;
LAMDAE(I,"chn", "2006")= 1.2;
LAMDAE(I,"chn", "2010")= 1.2;

LAMDACE("chn", "2004") = 1.2;
LAMDAGE("chn", "2004") = 1.2;
LAMDAIE("chn", "2004") = 1.2;

LAMDACE("chn", "2006") = 1.2;
LAMDAGE("chn", "2006") = 1.2;
LAMDAIE("chn", "2006") = 1.2;

LAMDACE("chn", "2010") = 1;
LAMDAGE("chn", "2010") = 1;
LAMDAIE("chn", "2010") = 1;
*$offtext

lamdae(enoe,rs,t) = 1;
lamdae("ele",rs,t) = 1;

display lamdae, lamdace, lamdage, lamdaie;
                

* EPPA4 Updated (table 20)


table res950(*,ff)	1995 resource base by fuel (EJ)
	cru	gas     col
*$ontext
*USA	1128.5	1112.0	24962.9
CAN	3357.3	178.1	656.8
MEX	547.4	156.9	60.3
JPN	0	0	55.9
ANZ	92.5	430.1	5974.1
EUR	831	1170	12077
ROE	785	912	35601
RUS	7535	5300	75535
ASI	104	341.5	75.4
CHN	558	228.1	13595
IND	144.6	110.4	2491
BRA	196.5	440.6	240.7
AFR	2100	994.4	5303
MES	9784.6	5994.3	58
LAM	7497.1	1261.6	1082.7
REA	575	328.7	1688.5
*$offtext
ROW	20831	11170	112077

;

res950(rs,"cru")=res950(rs,"cru")*2;
res950(rs,"gas")=res950(rs,"gas")*2;

$include ..\parameter_sets\eppa_ngas.gms
parameter res95(rs,ff)
res04(rs,grt,ff);
res95(rs,ff)=res950(rs,ff);
res04(r,grt,ff)=cy_res(r,grt,ff);


parameter temp_totals;

temp_totals("us","gas") =  sum(s,fossil_reserves(s,"gas"))*1.055;
temp_totals("us","col") =  sum(s,fossil_reserves(s,"col"))*1.055;
temp_totals("us","cru") =  sum(s,fossil_reserves(s,"cru"))*1.055;

*	Scale to match EPPA totals (we take figures from Table 5, JP Report 125):
temp_totals("EPPA","gas") =  2224;
temp_totals("EPPA","col") =  24962.9;
temp_totals("EPPA","cru") =  2257;

temp_totals("EPPA","gas") = 1*temp_totals("EPPA","gas");
temp_totals("EPPA","col") = 1*temp_totals("EPPA","col");
temp_totals("EPPA","cru") = 1*temp_totals("EPPA","cru");

fossil_reserves(s,"gas") =  fossil_reserves(s,"gas")*temp_totals("EPPA","gas")/temp_totals("us","gas");
fossil_reserves(s,"col") =  fossil_reserves(s,"col")*temp_totals("EPPA","col")/temp_totals("us","col");
fossil_reserves(s,"cru") =  fossil_reserves(s,"cru")*temp_totals("EPPA","cru")/temp_totals("us","cru");

*	For MIT Gas study, use these estimates which include shale gas (These numbers come from data\reserves_data\gas_reserves_USREP-mod-NGSupply.xlsx):

fossil_reserves("AK","gas") = 382.97626;
fossil_reserves("CA","gas") = 15.464204;
fossil_reserves("FL","gas") = 1.80414;
fossil_reserves("NY","gas") = 73.004448;
fossil_reserves("NENG","gas") = 0;
fossil_reserves("SEAS","gas") = 78.463128;
fossil_reserves("NEAS","gas") = 326.6984;
fossil_reserves("SCEN","gas") = 336.9103807;
fossil_reserves("TX","gas") = 505.057942;
fossil_reserves("NCEN","gas") = 16.723504;
fossil_reserves("MOUN","gas") = 399.3910213;
fossil_reserves("PACI","gas") = 4.02976;
*fossil_reserves("US","gas") = sum(s,fossil_reserves(s,"gas"));

parameter 
	ffreserves	"Fossil fuel reserves estimates (quad btu)";

ffreserves(s,ff) = fossil_reserves(s,ff);
ffreserves(r,ff) = res95(r,ff)*1.055;

display ffreserves;