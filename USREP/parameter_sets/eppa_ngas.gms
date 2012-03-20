* parameters for calibrating resurce supply curve for gas (EPPA5) based on cost curve data :

* Define a set for gas resource types:
SET grt gas resource types / cnv conventional, shl shale, tgh tight sands, cbm coal bed methane/;

alias (grt,gtr);

parameter cy_res(*,grt,ff) the current updated resource base by type;

table gasres04(*,grt) benchmark total gas reserves by type in TCF based on 2004 gas prices (3$ per mmbtu) 

* Cost_04_M_at5$

*$ontext
	cnv	shl	tgh	cbm
*USA	506	516	67	74
CAN	157	381	0	19
MEX	70	0	0	0
JPN	0	0	0	0
ANZ	162	0	0	0
EUR	518	0	0	0
ROE	724	0	0	0
RUS	2965	0	0	0
ASI	408	0	0	0
CHN	104	0	0	0
IND	70	0	0	0
BRA	234	0	0	0
AFR	864	0	0	0
MES	4359	0	0	0
LAM	538	0	0	0
REA	197	0	0	0
;


table gasresb0(*,*) resource supply elasticity for gas based on econmetric fitting of whole curve 

*$ontext
* cost_04
	b0	
*USA	0.87	
CAN	0.35	
MEX	0.59	
JPN	0	
ANZ	0.67	
EUR	0.55	
ROE	0.51	
RUS	0.44	
ASI	0.49	
CHN	0.60	
IND	0.51	
BRA	0.75	
AFR	0.59	
MES	0.25	
LAM	0.59	
REA	0.46	;

table gasresb11(*,*) resource supply elasticity for gas based on econmetric fitting of relevant curve segment 0 to 10

* cost_04_M_at$5
	cnv	shl	tgh	cbm
*USA	0.91	0.32	1.06	0.41
CAN	0.33	0.02	0	0.7
MEX	0.30	0	0	0	
JPN	0	0	0	0
ANZ	0.32	0	0	0
EUR	0.30	0	0	0
ROE	0.21	0	0	0
RUS	0.13	0	0	0
ASI	0.19	0	0	0
CHN	0.34	0	0	0
IND	0.26	0	0	0
BRA	0.39	0	0	0
AFR	0.20	0	0	0
MES	0.08	0	0	0	
LAM	0.41	0	0	0
REA	0.21	0	0	0   ;


table gasresb12(*,*) resource supply elasticity for gas based on econmetric fitting of relevant curve segment 10 plus

* cost_04_M_at$5
	cnv	shl	tgh	cbm
*USA	0.34	0	0.25	0.11
CAN	0.49	0	0	0
MEX	0.07	0	0	0	
JPN	0	0	0	0
ANZ	0.12	0	0	0
EUR	0.11	0	0	0
ROE	0.10	0	0	0
RUS	0.05	0	0	0
ASI	0.02	0	0	0
CHN	0.37	0	0	0
IND	0.02	0	0	0
BRA	0.10	0	0	0
AFR	0.05	0	0	0
MES	0.01	0	0	0	
LAM	0.10	0	0	0
REA	0.04	0	0	0   ;


parameter gas_mod;

gas_mod = 0;


* over-write the resource numbers for gas with the new assessment
res950(r,"gas")$gas_mod=sum(grt, gasres04(r,grt));

* initialize reserve accounting:
cy_res(r,grt,ff)=0;
cy_res(r,"cnv",ff)=res950(r,ff);
cy_res("can",grt,"gas")=gasres04("can",grt);




