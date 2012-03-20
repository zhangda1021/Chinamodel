$title Read US Census Data

set inc /0
10
15
25
30
50
75
100
150
/

valueq /hhtable,poptotal/

region /
AK   ,    CA   ,    FL   ,    NY   ,    TX   ,    NENG,    SEAS,    NEAS,    SCEN,    NCEN,    MOUN,    PACI
/
;

*	Read data:

table	dataa(inc,region,valueq)	
$ondelim
$offlisting
$include ..\data\population_fromUScensus\pop_region_income.csv
$onlisting
$offdelim
;

*	Relabel income groups:
parameter data_;

$ontext
set maphouse(h,inc) /
hhl.0
hh10.10
hh15.15
hh25.25
hh30.30
hh50.50
hh75.75
hh100.100
hh150.150
/;
$offtext
*$ontext
set maphouse(h,inc) /
c.0
c.10
c.15
c.25
c.30
c.50
c.75
c.100
c.150
/;
*$offtext

data_(region,h,valueq) = sum(maphouse(h,inc), dataa(inc,region,valueq));


*	Aggregate to regional target:

parameter UScensus_hhdata(s,h,*)  Number of households or individuals by income class by region;

$if "%rtarget%"=="rtarget_us" $goto usskip_

$if "%rtarget%"=="rtarget_12noak" $goto noakskip_

$if "%rtarget%"=="8" $goto 8skip_

$if "%rtarget%"=="rtarget_2" $goto 2skip_

set mapregion(s,region) /
CA.CA
FL.FL
NY.NY
TX.TX
NENG.NENG
SEAS.SEAS
NEAS.NEAS
SCEN.SCEN
NCEN.NCEN
MOUN.MOUN
PACI.PACI
AK.AK
/;
UScensus_hhdata(s,h,"households") = sum(mapregion(s,region),data_(region,h,"hhtable"));
UScensus_hhdata(s,h,"population") = sum(mapregion(s,region),data_(region,h,"poptotal"));


display uscensus_hhdata;

parameter 
	popweight	Population weight (households)
;

popweight(s,h,"#hh") = uscensus_hhdata(s,h,"households") / sum((ss,hh),uscensus_hhdata(ss,hh,"households"));
popweight(s,h,"pop") = uscensus_hhdata(s,h,"population") / sum((ss,hh),uscensus_hhdata(ss,hh,"population"));

$ontext
parameter 
	  kapshare	"Capital income share (population adjusted)"
	  labshare	"Capital income share (population adjusted)"
	  enceshare	"Private energy consumption share (population adjusted)"
	  eleshare	"Electricity consumption share (population adjusted)"
	  gasshare	"Electricity consumption share (population adjusted)"
	  oilshare	"Electricity consumption share (population adjusted)"
;

*	Not adjusted by population:
labshare(r,h) = labor(r,h)/ sum((rr,hh),labor(rr,hh));
kapshare(r,h) = kapital(r,h)/ sum((rr,hh),kapital(rr,hh));
enceshare(r,h) = sum(e,ence(r,e,h))/ sum((rr,e,hh),ence(rr,e,hh)); 
eleshare(r,h) = ence(r,"ele",h)/ sum((rr,hh),ence(rr,"ele",hh));
gasshare(r,h) = ence(r,"gas",h)/ sum((rr,hh),ence(rr,"gas",hh));
oilshare(r,h) = ence(r,"oil",h)/ sum((rr,hh),ence(rr,"oil",hh));
$offtext

parameter 
	populationindx	Population index (2006=1)
;

populationindx(s,t) = population_uscensus(s,t)/population_uscensus(s,"2006");

*	Adjust US Census data for population growth over time:

parameter
	uscensus_hhdatat
;

uscensus_hhdatat(s,h,"households",t) = uscensus_hhdata(s,h,"households")*populationindx(s,t);
uscensus_hhdatat(s,h,"population",t) = uscensus_hhdata(s,h,"population")*populationindx(s,t);


display populationindx;
