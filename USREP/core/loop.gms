$TITLE Recursive-dynamic model


*  MODEL DEVELOPMENTS STILL TO BE DONE:
*	--- non-CO2 GHGs + trends for GHGs
*	--- shift in elasticities
*	--- backstops 
*	--- vintaging for backstops
*	--- bio-oil trade
*	--- vintaging for electricity sector (code is in place but this seems to cause problems)


*------------------------------------------------------------------------------
*       Include case file that defines policy variables, number of time
*       periods etc.:
*------------------------------------------------------------------------------

*$include useppa.cas

file logfile /l1.log/;

$if not set BAU $set BAU BAU_yes 

*	Read BAU profiles:
$if "%BAU%"=="BAU_yes" $goto BAUcont
$gdxin ..\results\all\merged.gdx
parameter vom_bau,govinc_bau,totco2_bau;
$load vom_bau=vom 
$load govinc_bau=govinc
$load totco2_bau=totco2
$label BAUcont


*-----------------------------------------------------------------------------------
*       Initialize the baseline
*-----------------------------------------------------------------------------------

*       Labor:

blabor(rs,c,"2004") = vfms("lab",c,rs);

*       Putty capital:

bkapital(rs,c,"2004")$sum(c.local,vfms("cap",c,rs)) = vfms("cap",c,rs) + vfms("cap",c,rs)/sum(c.local,vfms("cap",c,rs))*
                 (sum((i,v), v_k(i,v,rs))
*                 + sum(vbt$(active(vbt,r)$vintgbs(vbt,r)), sum(v, vb_k(vbt,v,r)))
*                + sum(vbt$(active(vbt,r)$vintgbs(vbt,r)), sum(v, vb_km(vbt,v,r)))
		);

*       Nuclear resource:

bn_r(rs,"2004") = sum(c,vfmsnh("nuc",c,rs));
bh_r(rs,"2004") = sum(c,vfmsnh("hyd",c,rs));

*       Government revenue:

bgrg(rs,pub,"2004") = vom(pub,rs);
bgrg(rs,"g","2004") = vom("g",rs);

*       Initial resource factor supply:

ini_ffacth(ff,rs,c) = vfmresh(ff,c,rs);
ini_ffact(ff,rs) = sum(c,vfmresh(ff,c,rs));
ini_ffacth("agr",rs,c) = vfmresh("agr",c,rs);
ini_ffact("agr",rs) = sum(c,vfmresh("agr",c,rs));

*       Resource factors:

bffact(rs,ff,"2004") = sum(c,vfmresh(ff,c,rs));
bffacth(rs,c,ff,"2004")= vfmresh(ff,c,rs);
bffacth(rs,c,"agr","2004") = vfmresh("agr",c,rs);
bffact(rs,"agr","2004") = sum(c,vfmresh("agr",c,rs));

*	Fossil energy production:
parameter e_prod;
e_prod(ff,rs,"2004") = eprod(ff,rs);

parameter aya0;

aya0(rs) =  sum(c,vfms("cap",c,rs))
		+  sum(c,vfms("lab",c,rs))
		+ sum(c,vfmsnh("nuc",c,rs))
		+ sum(c,vfmsnh("hyd",c,rs))
		+ sum((i,v)$vintg(i,rs),  v_k(i,v,rs))
*           + sum((vbt,v)$vintgbs(vbt,r), bv_k.l(vbt,v,r))
*           + sum((vbt,v)$vintgbs(vbt,r), bvm_k.l(vbt,v,r))
*           + (shale(r))$active("synf-oil",r)
           + sum((ff,c),vfmresh(ff,c,rs));


*	INCLUDE EU POLICY IN BASELINE (this overwrites the "bmk" parameter in the reporting file):
parameter byreg_,windex,byregsect_,bilat_;
variable windex_;

$if "%coa%"=="EU" $goto EU
$gdxin ..\results\%c%_EU_etNO_%ren%_%b%_%em%_%t%_%f%_%k%.gdx
$load byreg_=byreg windex_=w byregsect_=byregsect bilat_=bilat
windex(c,rs) = windex_.l(c,rs);
$goto notEU

$label EU
windex(g,rs) = 0;
byreg_("emit","scn",rs) = 0;
byregsect_("output","scn",i,rs) = 0;
byregsect_("imports","scn",i,rs) = 0;
byregsect_("int exports","scn",i,rs) = 0;
byregsect_("us imports","scn",i,rs) = 0;
byregsect_("us exports","scn",i,rs) = 0;
byregsect_("intl trade intensity","scn", i,s) = 0;
byregsect_("emit","scn",g,rs) = 0;
bilat_("imports","scn",i,rs,rsrs) = 0;
bilat_("exports","scn",i,rs,rsrs) = 0;

$label notEU

VINTG(PCGOODS,rs) = yes;

*-----------------------------------------------------------------------------------
*       CONTROL TIME PERIOD:
*-----------------------------------------------------------------------------------

modelstatus("t-1") = 0;

*	Declare the timestamp and runNumber variable:
$ontext
$set console
$If %system.filesys% == UNIX $set console /dev/tty
$If %system.filesys% == DOS $set console con
$If %system.filesys% == MS95 $set console con
$If %system.filesys% == MSNT $set console con
$If "%console%." == "." abort "filesys not recognized"
file fcon / '%console%' /;
$If %system.filesys% == MSNT $set runNumber ""
$If %system.filesys% == MSNT $set isUncertainty 0
parameter perios, fperios;
perios = 2004;
fperios = 2006;
modelstatus("t-1") = 0;
$offtext

parameter 
	lp(t) Years to previous time period;
lp(t) = 2;

parameter
        year_
        yearord Ordinality of year;

year_=%year%;

yearord$(year_ eq 2004) = 1;
yearord$(year_ eq 2006) = 2;
yearord$(year_ eq 2008) = 3;
yearord$(year_ eq 2010) = 4;
yearord$(year_ eq 2012) = 5;
yearord$(year_ eq 2014) = 6;
yearord$(year_ eq 2016) = 7;
yearord$(year_ eq 2018) = 8;
yearord$(year_ eq 2020) = 9;
yearord$(year_ eq 2022) = 10;
yearord$(year_ eq 2024) = 11;
yearord$(year_ eq 2026) = 12;
yearord$(year_ eq 2028) = 13;
yearord$(year_ eq 2030) = 14;
yearord$(year_ eq 2032) = 15;
yearord$(year_ eq 2034) = 16;
yearord$(year_ eq 2036) = 17;
yearord$(year_ eq 2038) = 18;
yearord$(year_ eq 2040) = 19;
yearord$(year_ eq 2042) = 20;
yearord$(year_ eq 2044) = 21;
yearord$(year_ eq 2046) = 22;
yearord$(year_ eq 2048) = 23;
yearord$(year_ eq 2050) = 24;

abort$(yearord eq 0) "Yearord is zero";


*-----------------------------------------------------------------------------------
*       LOAD DATA FROM PREVIOUS YEAR:
*-----------------------------------------------------------------------------------

$if "%year%"=="2004" $goto skip2004

*       Define new parameters to read out data from previous year:
parameter vfmresh_, v_kh_, v_de_, v_dcarb_, v_mf_, v_df_, vafm_, vfmsnh_, vfms_, vom_, resdepl_;
$gdxin USREP_recursiveoutput_year%loadyear%.gdx
$load vfmresh_=vfmresh
$load v_kh_= v_kh
$load  v_de_=  v_de
$load v_dcarb_= v_dcarb
$load  v_mf_=  v_mf
$load v_df_= v_df
$load  vafm_=  vafm
$load vfmsnh_= vfmsnh
$load  vfms_=  vfms
$load vom_= vom
$load resdepl_= resdepl


*       Update model parameters:
vfmresh("agr",c,rs) = vfmresh_("agr",c,rs);
v_kh(i,c,v,rs) = v_kh_(i,c,v,rs);
v_de(rs,j,i,v) = v_de_(rs,j,i,v);
v_dcarb(rs,fe,i,v) = v_dcarb_(rs,fe,i,v);
v_mf(rs,i,"cap",v) = v_mf_(rs,i,"cap",v);
v_mf(rs,i,"lab",v) = v_mf_(rs,i,"lab",v);
v_df(rs,i,sf,v) = v_df_(rs,i,sf,v);
vafm(i,g,rs) = vafm_(i,g,rs);
vfmsnh(nh,c,rs) = vfmsnh_(nh,c,rs);
vfms(mf,c,rs) = vfms_(mf,c,rs);
$if not "%BAU%"=="BAU_yes" $goto govt
vom(pb,rs) = vom_(pb,rs);
$goto govt_continue
$label govt
* N.B.: vom for 2006 has been recorded as 2004:
vom(pb,rs) = sum(t$(ord(t) eq yearord-1),vom_bau("us1",t,pb,rs));
$label govt_continue
resdepl(rs,ff) = resdepl_(rs,ff);
$label skip2004
$if not "%year%"=="2004" $goto skip_depl
resdepl(rs,ff) = 0;
$label skip_depl


*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------
*       BEGIN LOOP HERE:
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------

loop(t$((ord(t) le nper)$(modelstatus(t-1) eq 0)$(ord(t) eq yearord)),
*loop(t$((ord(t) le nper)$(modelstatus(t-1) eq 0)),

*	Timestamp:
$ontext
if(ord(t) eq 1,
* -UNC-
$if %isUncertainty% == 0 putclose fcon // "%case%     %runNumber%    ", fperios:8:0 //;
putclose logfile "       %case%     %runNumber%    ", fperios:8:0 /;
);


if(ord(t) ge 2,
* -UNC-
$if %isUncertainty% == 0 putclose fcon // "%case%     %runNumber%    ", perios:8:0 //;
putclose logfile "       %case%     %runNumber%    ", perios:8:0 /;
);

perios = perios + 2;
$offtext

*-----------------------------------------------------------------------------------
*       0. ESTABLISH TRENDS FOR NON-CO2 GHG GASES
*-----------------------------------------------------------------------------------

*MDV
$ontext
*       Methane and N2O:
oghg("ch4","agr",r) = oghg0("ch4","agr",r)*ch4_agr(t);
oghg("n2o","agr",r) = oghg0("n2o","agr",r)*n2o_agr(t);

*       Fossil (exponential decrease in emissions index from 1 to 0.1):
oghg("ch4",e,r)$(ord(t) gt 1) = oghg0("ch4",e,r)*1.1165* exp(-0.11* ord(t));

*       Adjust N2O in fossil use as well:
cghg("n2o",e,g,r)$(ord(t) gt 1) = cghg0("n2o",e,g,r)*1.1165* exp(-0.11* ord(t));

*       N2O - EIS:
oghg("n2o","eis",r) = oghg0("n2o","eis",r)*n2o_eis(t);

*       Methane (otherind, eint, fd):
oghg("ch4","oth",r) = oghg0("ch4","oth",r)*ch4_agr(t);
oghg("ch4","eis",r) = oghg0("ch4","eis",r)*ch4_eis(t);
oghg("ch4","fd",r) = oghg0("ch4","fd",r)*ch4_fd(t);
fcghg_h0(ghg,"fd",r,h) = fcghg_h(ghg,"fd",r,h)*ch4_fd(t);

*       Energy intensive:
cghg("sf6",e,"eis",r) = cghg0("sf6",e,"eis",r)*sf6_eis(t);
oghg("sf6","eis",r) = oghg0("sf6","eis",r)*sf6_eis(t);
cghg("pfc",e,"eis",r) = cghg0("pfc",e,"eis",r)*pfc_eis(t);
oghg("pfc","eis",r) = oghg0("pfc","eis",r)*pfc_eis(t);

*       Electricity:
cghg("sf6",e,"ele",r) = cghg0("sf6",e,"ele",r)*sf6_ele(t);
oghg("sf6","ele",r) = oghg0("sf6","ele",r)*sf6_ele(t);

*       Other ind:
cghg("hfc",e,"oth",r) = cghg0("hfc",e,"oth",r)*hfc_oth(t);
oghg("hfc","oth",r) = oghg0("hfc","oth",r)*hfc_oth(t);
cghg("pfc",e,"oth",r) = cghg0("pfc",e,"oth",r)*pfc_eis(t);
oghg("pfc","oth",r) = oghg0("pfc","oth",r)*pfc_eis(t);
$offtext

*-----------------------------------------------------------------------------------
*       I. RESOURCE DEPLETION AND RESOURCE RENTS SUPPLY
*-----------------------------------------------------------------------------------

*MDV
*$ontext
*       RESOURCE DEPLETION MODEL for all time periods after t=depper:



loop(ff,
if( (ord(t) ge depper(ff)),

*       Resource depletion: "R(e,t) = R(e,t-1) - 5 * fossil fuel production":

ffact(rs,ff)$(ffreserves(rs,ff) - sum(ts$(ord(ts) lt depper(ff)), lp(t)*e_prod(ff,rs,ts)))
				 = ini_ffact(ff,rs) * (ffreserves(rs,ff) - lp(t)*resdepl(rs,ff))
                              /(ffreserves(rs,ff) - sum(ts$(ord(ts) lt depper(ff)), lp(t)*e_prod(ff,rs,ts)));

ffact(rs,ff)$eprod(ff,rs) = max( 1e-2, ffact(rs,ff));

vfms("lab",c,rs) = vfms0("lab",c,rs) * sum(ts$(ord(ts) eq yearord+1),gprod(rs,ts));

vfmresh(ff,c,rs)$sum(c.local,vfmresh(ff,c,rs)) = vfmresh(ff,c,rs)/sum(c.local,vfmresh(ff,c,rs)) * ffact(rs,ff);

 );
);


*-----------------------------------------------------------------------------------
*       II. DETERMINE BACKSTOP TECHNOLOGY
*-----------------------------------------------------------------------------------

*if(backstop(t),

*MDV
$ontext
        active("ngcc",r)$((ord(t) ge 2)) = yes;
        active("ngcap",r)$((ord(t) ge 4)) = yes;
        active("igcap",r)$((ord(t) ge 4)) = yes;
        active("adv-nucl",r)$(ord(t) ge 4 and va(r,"ele")) = yes;

        active("bioele",r)$(ord(t) ge 1) = yes;
        active("wind",r)$(ord(t) ge 1) = yes;
        active("windbio",r)$(ord(t) ge 3) = yes;
        active("windgas",r)$(ord(t) ge 3) = yes;

        active("bio-oil",r)$((ord(t) ge 1) and sum(s,rr0(r,"agr"))) = yes;
        active("synf-oil",r)$((ord(t) ge 2)$rshale(r)) = yes;
        active("synf-gas",r)$((ord(t) ge 2) and va(r,"col") and vom(r,"gas")) = yes;
$offtext

*     else
*        active(bt,r) = no;
*);




*-----------------------------------------------------------------------------------
*       ACTIVATE POLICY VARIABLES
*-----------------------------------------------------------------------------------


*	Emissions reductions trajectory:
*co2lim(rs) = emisreduc(rs,t) * refco2(rs);
co2lim(rs) = emisreduc(rs,t) * sum((fe,g)$seccarb(g,fe,rs),bmkco2(fe,g,rs));
*sum(s,totco2_bau("bau",t,s));


*	Introduce permit trading:
ctrade(cc)$ctradet(cc,t) = yes;
ctrade(cc)$((card(cc) le 1)$ctradet(cc,t)) = no;
ctrade(rs)$((not co2lim(rs))$ctradet(rs,t)) = no;
*	Activate revenue-neutrality through lumpsum transfers:
rn_ls(rs)$rn_lst(rs,t) = yes;
*lshare(h,rs)$rn_ls(rs) = 1;

*	Turn on recycling of carbon revenue:
carbrevf = 0;
carbrevf$((sum(s,co2lim(s)))$carbrevft(t)) = 1;
*	Share out carbon revenue according population, i.e. on a per-capita basis:
carbrevshare(h,s)$(sum(ss,sum(hh,uscensus_hhdata(ss,hh,"population")))$co2lim(s))
	 = uscensus_hhdata(s,h,"population") / sum(s.local$co2lim(s),sum(hh,uscensus_hhdata(s,hh,"population")));

GOVBUDG.l(pb,rs)$rn_ls(rs) = 1;
GOVBUDG.lo(pb,rs)$rn_ls(rs) = -inf;
LSGOVNH.lo(g,rs)$rn_ls(rs) = -inf;

*	Target BAU government income:
$if "%year%"=="2004" $goto govbud_continue
govbudg0(pb,rs)$rn_ls(rs) = govinc_bau("bau",t,rs,pb);
$label govbud_continue

*);
*display carbrevshare,  ctrade, carbrevf, lshare, co2lim, refco2,vom, cc, rn_ls, rn_lst;
*$exit

*-----------------------------------------------------------------------------------
*       SOLVE STATEMENT FOR STATIC CORE MODEL
*-----------------------------------------------------------------------------------

$ontext
$if "%iter%"=="benchm" $goto continue
*$if "%year%"=="2004" $goto cont
$if "%year%"=="2004" $goto continue
$if not "%iter%"=="1" $goto skip_execloadpoint1
execute_loadpoint 'year%loadyear%_loadpoint.gdx';
$goto continue
$label cont
$label skip_execloadpoint1
execute_loadpoint 'gtap_us_e_p.gdx';
$label continue
$offtext
option savepoint=1;

gtap_us_e.iterlim = 100000;
$include gtap_us_e.gen

solve gtap_us_e using mcp;
option solprint = on;

modelstatus(t) = gtap_us_e.modelstat-1;
abort$((gtap_us_e.modelstat-1) gt 0) 'Model does not solve';

$ontext
gtap_us_e.iterlim = 10000;
$include gtap_us_e.gen
solve gtap_us_e using mcp;
*option solprint = off;
option solprint = on;
$offtext


*-----------------------------------------------------------------------------------
*       III. PASSING MODEL RESULTS (ABSENT TIME DIMENSION) TO REPORTING VARIABLES
*-----------------------------------------------------------------------------------

$include write_dyn_parameters.gms

*-----------------------------------------------------------------------------------
*       IV. Adjust elasticity and share parameters:
*-----------------------------------------------------------------------------------

*       Adjust energy elasticity:

*MDV
$ontext
delas = delas0 + shagd(t)*(ord(t)-1);
selas(r,s,"e_kl") = es_elas0(s) + shagp(s,t)*(ord(t)-1);

*       Adjust GHG elasticity:

sigg("ch4",g,r) = ch4_elas0(g,r) + shag_ch4(g,r,t)*(ord(t)-1);
sigg("n2o",g,r) = n2o_elas0(g,r) + shag_n2o(g,r,t)*(ord(t)-1);

*       Do the variable elasticity coefficient for HFC:
if(ord(t) ge 2,
sigg("hfc","oth",r) = sigg0("hfc","oth",r)*ord(t)/3;
siggv("oth",r) = 1.04*siggv("oth",r);
);
if(ord(t) ge 7,
sigg("hfc","oth",r) = sigg0("hfc","oth",r)*3;
);
$offtext


*-----------------------------------------------------------------------------------
*       V. UPDATE ENDOWMENTS AND TECHNOLOGIES FOR NEXT PERIOD
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------
*       1. Update malleable new capital:

*       Account correctly for capital demand after separating nuclear
*       and hydro generation:

r_kap(rs,i) = r_kap(rs,i)+sum(nh,r_nhkap(rs,nh))$elec(i);

*       Old capital net of depreciation:

oldcap(rs,i,t) = (1-depr(rs))**lp(t) * r_kap(rs,i);

*       If vintaging applies, theta is share of new vintage which is frozen
*       each period:

oldcap(rs,i,t)$vintg(i,rs) = (1-theta(i,t))*(1-depr(rs))**lp(t) * r_kap(rs,i);

*       Capital stocks are measured in units of benchmark rental
*       value -- we therefore use the benchmark rate of return
*       to convert investment into units of new capital:

ror(rs) = 0.1;
k_o(rs,t) = sum(c,bkapital(rs,c,t))/(ror(rs)*aya(rs));

*       Assume that economy is initially on a steady state and infer investment level
*       through "scale" parameter such that investment exactly replaces depreciated capital.
*       The steady state condition of course only holds if all other external forcing (pop. growth,
*       prod. growth, AEEI etc.) is zero.

scale(rs) = (sum(c,bkapital(rs,c,"2004")) - sum(c,bkapital(rs,c,"2004"))*(1-depr(rs))**lp(t))/(vom("i",rs)*ror(rs));

*       New capital:

newcap(rs,t) = scale(rs) * vom("i",rs)*Y.l("i",rs)*ror(rs);

*       Total capital:

totalcap(rs,t) = sum(i, oldcap(rs,i,t)) + newcap(rs,t);


*-----------------------------------------------------------------------------------
*       2. Update vintage capital stocks:

*	2-year vintage structure

*MDV
*$ontext
*$ontext
*       For non-backstop sectors:

*       Set small values to zero to prevent computational issues:

dv.l(i,v,rs)$(dv.l(i,v,rs) lt 1e-3) = 0;

v_k(i,v,rs)$vintg(i,rs) = srvshr(rs) * dv.l(i,v,rs) * v_mf(rs,i,"cap",v);
v_k(i,v5,rs)$vintg(i,rs)  = srvshr(rs) * theta(i,t) * r_kap(rs,i);

v_kh(i,c,v+1,rs)$vintg(i,rs) = vfms("cap",c,rs)/sum(c.local,vfms("cap",c,rs))*v_k(i,v,rs);
v_kh(i,c,v5,rs)$vintg(i,rs) = vfms("cap",c,rs)/sum(c.local,vfms("cap",c,rs))*v_k(i,v5,rs);
v_kh(i,c,v,rs)$(vintg(i,rs)$(v_kh(i,c,v,rs) lt 1e-4)) = 0;


*       For vintaged backstops:
*vb_kh(vbt,v+1,h,r)$vintgbs(vbt,r) = (hshkapital(r,h) * srvshr(r) * bv_k.l(vbt,v,r))$vb_dk(vbt,v,r);
*vb_kh(vbt,v5,h,r)$vintgbs(vbt,r) = hshkapital(r,h) * srvshr(r) * thetab(vbt,t) * (1-vbmalshr) * b_k.l(vbt,r);
*vb_kmh(vbt,v+1,h,r)$vintgbs(vbt,r) = hshkapital(r,h) * srvshr(r) * bvm_k.l(vbt,v,r);
*vb_kmh(vbt,v5,h,r)$vintgbs(vbt,r) = hshkapital(r,h) * srvshr(r) * thetab(vbt,t) * vbmalshr * b_k.l(vbt,r);
*vb_k(vbt,v+1,r)$vintgbs(vbt,r) = sum(h,vb_kh(vbt,v+1,h,r));
*vb_k(vbt,v5,r)$vintgbs(vbt,r) = sum(h,vb_kh(vbt,v5,h,r));
*vb_km(vbt,v+1,r)$vintgbs(vbt,r) = sum(h,vb_kmh(vbt,v+1,h,r));
*vb_km(vbt,v5,r)$vintgbs(vbt,r) = sum(h,vb_kmh(vbt,v5,h,r));

*       Update the coefficients for vintaged capital:

*       Vintage V+1 inherits the coefficients from vintage V:

v_de(rs,j,i,v+1) = v_de(rs,j,i,v);
v_dcarb(rs,fe,i,v+1) = v_dcarb(rs,fe,i,v);
v_mf(rs,i,"lab",v+1) = v_mf(rs,i,"lab",v);
v_mf(rs,i,"cap",v+1) = v_mf(rs,i,"cap",v);
v_df(rs,i,sf,v+1) = v_df(rs,i,sf,v);
*$offtext



*       Vintage V5 inherits the latest new-vintage coefficients:

v_de(rs,j,i,v5)$(Y.l(i,rs)*vom(i,rs) and vintg(i,rs)) = vv_de.l(i,j,rs)/(Y.l(i,rs)*vom(i,rs));
v_dcarb(rs,fe,i,v5)$(Y.l(i,rs)*vom(i,rs) and vintg(i,rs))  = vv_dcarb.l(fe,i,rs)/(Y.l(i,rs)*vom(i,rs));
v_dcarb(rs,en,"ele",v5)$(Y.l("ele",rs)*vom("ele",rs) and vintg("ele",rs))  = vv_dcarbele.l(en,"ele",rs)/(Y.l("ele",rs)*vom("ele",rs));

v_mf(rs,i,"lab",v5)$(Y.l(i,rs)*vom(i,rs) and vintg(i,rs)) = vv_mflab.l(i,rs)/(Y.l(i,rs)*vom(i,rs));
v_mf(rs,i,"cap",v5)$(Y.l(i,rs)*vom(i,rs) and vintg(i,rs)) = vv_mfcap.l(i,rs)/(Y.l(i,rs)*vom(i,rs));
v_dk(rs,i,v5)$(Y.l(i,rs)*vom(i,rs) and vintg(i,rs)) = vv_dk.l(i,rs)/(Y.l(i,rs)*vom(i,rs));
v_mf(s,i,"cap",v5) = v_dk(s,i,v5);
v_df(rs,i,j,v5)$(Y.l(i,rs)*vom(i,rs) and vintg(i,rs)) = vv_df.l(i,j,rs)/(Y.l(i,rs)*vom(i,rs));

*       Vintaged backstop V+1 inherits the coefficients from vintaged backstop V:

*vb_dl(vbt,v+1,r) = vb_dl(vbt,v,r);
*vb_dk(vbt,v+1,r) = vb_dk(vbt,v,r);
*vb_da(vbt,g,v+1,r) = vb_da(vbt,g,v,r);
*vb_dff(vbt,v+1,r) = vb_dff(vbt,v,r);
*vb_em(vbt,v+1,r) = vb_em(vbt,v,r);

*       Vintaged backstop V5 inherits the coefficients from the new vintage:

*vb_dl(vbt,v5,r) = 0;
*vb_dk(vbt,v5,r) = 0;
*vb_da(vbt,g,v5,r) = 0;
*vb_dff(vbt,v5,r) = 0;
*vb_em(vbt,v5,r) = 0;

*bin(vbt,r)$(active(vbt,r)) = b_k.l(vbt,r) + b_l.l(vbt,r) + sum(g,(b_a.l(vbt,g,r))) + b_ff.l(vbt,r);

*vb_dk(vbt,v5,r)$(bin(vbt,r) gt 0) = b_k.l(vbt,r)/bin(vbt,r);
*vb_dl(vbt,v5,r)$(bin(vbt,r) gt 0) = b_l.l(vbt,r)/bin(vbt,r);
*vb_da(vbt,g,v5,r)$(bin(vbt,r) gt 0) =  b_a.l(vbt,g,r)/bin(vbt,r);
*vb_dff(vbt,v5,r)$(bin(vbt,r) gt 0) = b_ff.l(vbt,r)/bin(vbt,r);
*vb_em(vbt,v5,r)$(bin(vbt,r) gt 0) = vb_em0(vbt,r);

*$offtext


*-----------------------------------------------------------------------------------
*       3. Update energy efficiency coefficients (AEEI):

*MDV
*$ontext

*       Private consumption, government and investment energy demand:

vafm(i,c,rs)$ne(i) = vafm0(i,c,rs) / sum(ts$(ord(ts) eq yearord+1),lamdace(rs,ts));
vafm(i,pb,rs)$ne(i) = vafm0(i,pb,rs) / sum(ts$(ord(ts) eq yearord+1),lamdage(rs,ts));
vafm(i,"i",rs)$ne(i) = vafm0(i,"i",rs) / sum(ts$(ord(ts) eq yearord+1),lamdaie(rs,ts));


*       Industrial energy demand:

vafm(ener,i,rs)$ne(i) = vafm0(ener,i,rs) / sum(ts$(ord(ts) eq yearord+1),lamdae(i,rs,ts));

*$offtext



*-----------------------------------------------------------------------------------
*       4. Update fixed factor supplies:

*       Fixed factor rent in AGR for land grows with exogenous rate:

*MDV
*$ontext
vfmresh("agr",c,rs) = ini_ffacth("agr",rs,c)*sum(ts$(ord(ts) eq yearord+1),fprod(rs,t));

*       Nuclear resource:

  vfmsnh("nuc",c,rs) = vfmsnh0("nuc",c,rs)*(1 + 0.005)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"eur") = vfmsnh0("nuc",c,"eur")*(1 + 0.003)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"asi") = vfmsnh0("nuc",c,"asi")*(1 + 0.01)**(lp(t)*ord(t));

  vfmsnh("nuc",c,"eur") = vfmsnh0("nuc",c,"eur")*(1 + 0.003)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"asi") = vfmsnh0("nuc",c,"asi")*(1 + 0.01)**(lp(t)*ord(t));

  vfmsnh("nuc",c,s)$(ord(t) le 2) = vfmsnh0("nuc",c,s)*(1 + 0.005)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"can")$(ord(t) le 2) = vfmsnh0("nuc",c,"can")*(1 + 0.011)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"mex")$(ord(t) le 2) = vfmsnh0("nuc",c,"mex")*(1 + 0.027)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"jpn")$(ord(t) le 2) = vfmsnh0("nuc",c,"jpn")*(1 + 0.000)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"anz")$(ord(t) le 2) = vfmsnh0("nuc",c,"anz")*(1 + 0.005)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"eur")$(ord(t) le 2) = vfmsnh0("nuc",c,"eur")*(1 + 0.0059)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"roe")$(ord(t) le 2) = vfmsnh0("nuc",c,"roe")*(1 + 0.01)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"rus")$(ord(t) le 2) = vfmsnh0("nuc",c,"rus")*(1 + 0.01)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"asi")$(ord(t) le 2) = vfmsnh0("nuc",c,"asi")*(1 + 0.020)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"chn")$(ord(t) le 2) = vfmsnh0("nuc",c,"chn")*(1 + 0.135)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"ind")$(ord(t) le 2) = vfmsnh0("nuc",c,"ind")*(1 + 0.049)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"bra")$(ord(t) le 2) = vfmsnh0("nuc",c,"bra")*(1 + 0.005)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"afr")$(ord(t) le 2) = vfmsnh0("nuc",c,"afr")*(1 + 0.0018)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"mes")$(ord(t) le 2) = vfmsnh0("nuc",c,"mes")*(1 + 0.005)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"lam")$(ord(t) le 2) = vfmsnh0("nuc",c,"lam")*(1 + 0.044)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"rea")$(ord(t) le 2) = vfmsnh0("nuc",c,"rea")*(1 + 0.175)**(lp(t)*ord(t));

  vfmsnh("nuc",c,s)$(ord(t) gt 2) = vfmsnh0("nuc",c,s)*(1 + 0.0005)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"can")$(ord(t) gt 2) = vfmsnh0("nuc",c,"can")*(1 + 0.001)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"mex")$(ord(t) gt 2) = vfmsnh0("nuc",c,"mex")*(1 + 0.017)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"jpn")$(ord(t) gt 2) = vfmsnh0("nuc",c,"jpn")*(1 + 0.000)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"anz")$(ord(t) gt 2) = vfmsnh0("nuc",c,"anz")*(1 + 0.000)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"eur")$(ord(t) gt 2) = vfmsnh0("nuc",c,"eur")*(1 + 0.05)**(5);
  vfmsnh("nuc",c,"roe")$(ord(t) gt 2) = vfmsnh0("nuc",c,"roe")*(1 + 0.02)**(5);
  vfmsnh("nuc",c,"rus")$(ord(t) gt 2) = vfmsnh0("nuc",c,"rus")*(1 + 0.01)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"asi")$(ord(t) gt 2) = vfmsnh0("nuc",c,"asi")*(1 + 0.010)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"bra")$(ord(t) gt 2) = vfmsnh0("nuc",c,"bra")*(1 + 0.001)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"afr")$(ord(t) gt 2) = vfmsnh0("nuc",c,"afr")*(1 + 0.0018)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"mes")$(ord(t) gt 2) = vfmsnh0("nuc",c,"mes")*(1 + 0.001)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"lam")$(ord(t) gt 2) = vfmsnh0("nuc",c,"lam")*(1 + 0.005)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"rea")$(ord(t) gt 2) = vfmsnh0("nuc",c,"rea")*(1 + 0.001)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"ind")$(ord(t) gt 2) = vfmsnh0("nuc",c,"ind")*(1 + 0.04)**(lp(t)*ord(t));

  vfmsnh("nuc",c,"chn")$(ord(t) gt 2) = vfmsnh0("nuc",c,"chn")*(1 + 0.051)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"chn")$(ord(t) gt 22) = vfmsnh0("nuc",c,"chn")*(1 - 0.01)**(lp(t)*ord(t));
  vfmsnh("nuc",c,"chn")$(ord(t) gt 33) = vfmsnh0("nuc",c,"chn")*(1 - 0.005)**(lp(t)*ord(t));


*       Hydro resources:

*       Hydro resources grow by x% annually:
 vfmsnh("hyd",c,rs) = vfmsnh0("hyd",c,rs) *(1 + 0.005)**(lp(t)*ord(t));
 vfmsnh("hyd",c,s) = vfmsnh0("hyd",c,s) *(1 + 0.0005)**(lp(t)*ord(t));
 
*       For non-oecd the resource grows by 0.75%:
*vfmsnh("hyd",c,ldc) = vfmsnh0("hyd",c,ldc) *(1 + 0.0075)**(lp(t)*ord(t));

*       For CHN,EEX, and BRA the resource grow by 1.5%:
 vfmsnh("hyd",c,"chn") = vfmsnh("hyd",c,"chn")*(1 + 0.015)**(lp(t)*ord(t));
 vfmsnh("hyd",c,"mes") = vfmsnh("hyd",c,"mes")*(1 + 0.0125)**(lp(t)*ord(t));
 vfmsnh("hyd",c,"rus") = vfmsnh("hyd",c,"rus")*(1 + 0.001)**(lp(t)*ord(t));
*$offtext

*       Save nuclear and hydro BAU profiles:

bn_rh(rs,c,t+1) = vfmsnh("nuc",c,rs);
bh_rh(rs,c,t+1) = vfmsnh("hyd",c,rs);


*-----------------------------------------------------------------------------------
*       5. Assign the new endowments for labor, capital and fixed factors:

*       NB: gprod is the total augmentation rate of labor force growth comprising
*           population and productivity growth.

*MDV
vfms("lab",c,rs) = vfms0("lab",c,rs) * sum(ts$(ord(ts) eq yearord+1),gprod(rs,ts));

*       Use previous period capital holdings to compute households shares of aggregate capital:

hshkapital(rs,c) = vfms("cap",c,rs)/sum(c.local,vfms("cap",c,rs));
bhshkapital(rs,c,t) = hshkapital(rs,c);
*MDV
vfms("cap",c,rs) = hshkapital(rs,c) * totalcap(rs,t);


*       Save the BAU profiles:

blabor(rs,c,t+1)   = vfms("lab",c,rs);
bkapital(rs,c,t+1) = vfms("cap",c,rs) + hshkapital(rs,c) *
                ( sum( (i,v), v_k(i,v,rs)) 
*                 + sum( (vbt,v), vb_k(vbt,v,r)) + sum( (vbt,v), vb_km(vbt,v,r)) 
		 );

*       Backstop capital tracking:

*ppvbk(vbt,v,r,t)$vintgbs(vbt,r) = pvbk.l(vbt,v,r);
*vvbk(vbt,v,r,t)$vintgbs(vbt,r)  = vb_k(vbt,v,r);
*ppvbkm(vbt,v,r,t)$vintgbs(vbt,r) = pvbkm.l(vbt,v,r);
*vvbkm(vbt,v,r,t)$vintgbs(vbt,r)  = vb_km(vbt,v,r);
*tvbk(vbt,r,t)$vintgbs(vbt,r)   = sum(v, vvbk(vbt,v,r,t)) + sum(v, vvbkm(vbt,v,r,t));

*       Record time paths:

*bffact(r,ff,t) = sum(h,ffacth(r,h,ff));
*bffacth(r,ff,h,t) = ffacth(r,h,ff);
*bffact(r,"agr",t+1) = sum(h,ffacth(r,h,"agr"));
*bffacth(r,"agr",h,t+1) = ffacth(r,h,"agr");
*bn_r(r,t+1) = n_r0(r);
*bh_r(r,t+1) = h_r0(r);

*       Use base year fixed factor rents for t < depper:

loop(ff,
 if( (ord(t) lt depper(ff)),
 ini_ffacth(ff,rs,c) = vfmresh(ff,c,rs);
 );
);



*-----------------------------------------------------------------------------------
*       6. Update government expenditures for different government
*          institutions (proportional to aggregate income):

*MDV
vom(pb,rs) = vom0(pb,rs) * aya(rs) / aya0(rs);

*-----------------------------------------------------------------------------------
*       7. Update backstop resource:

$ontext
*       Solar:
bres("solar",r)$(ord(t) ge 1)= bres("solar",r) +
                inish("solar",r)*bsin("solar","ffa")*
                (sum(s, eouti.l(r,"ele",s))+eoutf.l(r,"ele"))*badjst("solar",r);
*       Wind:
bres("wind",r)$(ord(t) ge 1)= bres("wind",r) +
                inish("wind",r)*bsin("wind","ffa")*
                (sum(s, eouti.l(r,"ele",s))+eoutf.l(r,"ele"))*badjst("wind",r);
*       Bio-ele:
bres("bioele",r)$(ord(t) ge 1)= bres("bioele",r) +
                inish("bioele",r)*bsin("bioele","ffa")*
                (sum(s, eouti.l(r,"ele",s))+eoutf.l(r,"ele"))*badjst("bioele",r);

*       Resource depletion for shale oil:

rshale(r) = rshale(r) - lp(t)*ej_95d("cru")*EB.L("synf-oil",r)$active("synf-oil",r);
rshale(r) = rshale(r) - lp(t)*EB.L("synf-oil",R)$active("synf-oil",r);
shale(r)$rshale0(r) = shale(r)*rshale(r)/rshale0(r);
shaleh(r,h) = kapital(r,h)/sum(hh,kapital(r,hh)) * shale(r);
bshale(r,t) = shale(r);


*       NB: Use capital shares from previous period to share out resource supply by household:

bresh(r,bt,h) = HSHkapital(r,h) * bres(bt,r);


bbres("adv-nucl",r,t+1)$(ord(t) eq 1) = max(0.00001, inish("adv-nucl",r)*outt.l(r,"ele"));
bbres("adv-nucl",r,t+1)$((ord(t) gt 1)$(bbadvnucl_bout("ele",r,t) gt 0)) = bbres("adv-nucl",r,t) +
        bsinc("adv-nucl","ffa",r)*badjst("adv-nucl",r)*vtote(r,"ele")/edtot(r,"ele")*
        (0.93*bbadvnucl_bout("ele",r,t) + 3.2*bbadvnucl_bout("ele",r,t)**2);
bbres("adv-nucl",r,t+1)$((ord(t) gt 1)$((banucoutdom.l(r,"ele")
) le 0)) = max(bbres("adv-nucl",r,"2010"), bbres("adv-nucl",r,t) * srvshr(r));

bbres("ngcc",r,t+1)$(ord(t) eq 1) = max(0.00001, inish("ngcc",r)*outt.l(r,"ele"));
bbres("ngcc",r,t+1)$((ord(t) gt 1)$(bbngout("ele",r,t) gt 0)) = bbres("ngcc",r,t) +
        bsinc("ngcc","ffa",r)*badjst("ngcc",r)*(vtote(r,"ele")/edtot(r,"ele"))*
        (0.93*bbngout("ele",r,t) + 3.2*bbngout("ele",r,t)**2);
bbres("ngcc",r,t+1)$((ord(t) gt 1)$((bngoutdom.l(r,"ele")
) le 0)) = max(bbres("ngcc",r,"2010"), bbres("ngcc",r,t) * srvshr(r));

bbres("ngcap",r,t+1)$(ord(t) eq 1) = max(0.00001, inish("ngcap",r)*outt.l(r,"ele"));
bbres("ngcap",r,t+1)$((ord(t) gt 1)$(bbncsout("ele",r,t) gt 0)) = bbres("ngcap",r,t) +
        bsinc("ngcap","ffa",r)*badjst("ngcap",r)*(vtote(r,"ele")/edtot(r,"ele"))*
        (0.93*bbncsout("ele",r,t) + 3.2*bbncsout("ele",r,t)**2);
bbres("ngcap",r,t+1)$((ord(t) gt 1)$((bncsoutdom.l(r,"ele")
) le 0)) = max(bbres("ngcap",r,"2010"), bbres("ngcap",r,t) * srvshr(r));

bbres("igcap",r,t+1)$(ord(t) eq 1) = max(0.00001, inish("ngcap",r)*outt.l(r,"ele"));
bbres("igcap",r,t+1)$((ord(t) gt 1)$(bbicsout("ele",r,t) gt 0)) = bbres("igcap",r,t) +
        bsinc("igcap","ffa",r)*badjst("igcap",r)*(vtote(r,"ele")/edtot(r,"ele"))*
        (0.93*bbicsout("ele",r,t) + 3.2*bbicsout("ele",r,t)**2);
bbres("igcap",r,t+1)$((ord(t) gt 1)$((bicsoutdom.l(r,"ele")
) le 0)) = max(bbres("igcap",r,"2010"), bbres("igcap",r,t) * srvshr(r));

bbres("windbio",r,t+1)$(ord(t) eq 1) = max(0.00001, inish("windbio",r)*outt.l(r,"ele"));
bbres("windbio",r,t+1)$((ord(t) gt 1)$(bbwbioout("ele",r,t) gt 0)) = bbres("windbio",r,t) +
        bsin("windbio","ffa")*badjst("windbio",r)*vtote(r,"ele")/edtot(r,"ele")*
*       (0.93*bbwbioout("ele",r,t) + 3.2*bbwbioout("ele",r,t)**2);
        (0.93*bbwbioout("ele",r,t) + .2*bbwbioout("ele",r,t));
bbres("windbio",r,t+1)$((ord(t) gt 1)$((bwbiooutdom.l(r,"ele")
) le 0)) = max(bbres("windbio",r,"2010"), bbres("windbio",r,t) * srvshr(r));

bbres("windgas",r,t+1)$(ord(t) eq 1) = max(0.00001, inish("windgas",r)*outt.l(r,"ele"));
bbres("windgas",r,t+1)$((ord(t) gt 1)$(bbwgasout("ele",r,t) gt 0)) = bbres("windgas",r,t) +
        bsin("windgas","ffa")*badjst("windgas",r)*vtote(r,"ele")/edtot(r,"ele")*
*       (0.93*bbwgasout("ele",r,t) + 3.2*bbwgasout("ele",r,t)**2);
        (0.93*bbwgasout("ele",r,t) + .2*bbwgasout("ele",r,t));
bbres("windgas",r,t+1)$((ord(t) gt 1)$((bwgasoutdom.l(r,"ele")
) le 0)) = max(bbres("windgas",r,"2000"), bbres("windgas",r,t) * srvshr(r));


*       Set resource supply for vintaged backstops:

bres(vbt,r) = bbres(vbt,r,t+1);
bresh(r,vbt,h) = HSHkapital(r,h) * bres(vbt,r);

*       Save BAU profiles:

bbres(bt,r,t+1) = bres(bt,r);
bbresh(bt,r,t+1,h) = bresh(r,bt,h);

*       Initialize backstop vintage reporting variables to zero:

r_enbnele.l(r,enoe,s) = 0;
r_enbele.l(r,ele,s) = 0;
ei_v.l(g,enoe,v,r) = 0;
ei_v_ele.l(g,v,r) = 0;
vbout_dom.l(g,bt,v,r) = 0;
vbout_pnr.l(g,bt,v,r,pool) = 0;
vbmout_dom.l(g,bt,v,r) = 0;
vbmout_pnr.l(g,bt,v,r,pool) = 0;
b_k.l(bt,r) =0;
b_l.l(bt,r) =0;
b_a.l(bt,g,r)=0;
b_ff.l(bt,r) =0;
b_pc.l(bt,r) =0;
b_ptc.l(bt,r) =0;
b_fc.l(bt,r) =0;
bv_ff.l(vbt,v,r)=0;
bv_l.l(vbt,v,r)=0;
bv_k.l(vbt,v,r)=0;
bv_a.l(vbt,v,g,r)=0;
bv_pc.l(vbt,v,r)=0;
bv_ptc.l(vbt,v,r)=0;
bv_fc.l(vbt,v,r)=0;
bvm_ff.l(vbt,v,r)=0;
bvm_l.l(vbt,v,r)=0;
bvm_k.l(vbt,v,r)=0;
bvm_a.l(vbt,v,g,r)=0;
bvm_pc.l(vbt,v,r)=0;
bvm_ptc.l(vbt,v,r)=0;
bvm_fc.l(vbt,v,r)=0;
$offtext

*       Cumulative depletion of fossil fuel up to t:

$if not "%iter%"=="l" $goto skip_depll
resdepl(rs,ff) = resdepl(rs,ff) + e_prd(rs,ff);
$label skip_depll

*-----------------------------------------------------------------------------------
*       LOOP FOR RECURSIVE MODEL ENDS HERE
*-----------------------------------------------------------------------------------

);

display refco2, co2lim;

*-----------------------------------------------------------------------------------
*       SAVE DATA FOR NEXT TIME PERIOD
*-----------------------------------------------------------------------------------

*       Save savepoint.gdx from final iteration in a given year to obtain better restart at next year:

$if not "%iter%"=="l" $goto skip_copy
execute_unload "USREP_recursiveoutput_year%year%.gdx" vfmresh v_kh v_de v_dcarb v_mf v_df vafm vfmsnh vfms vom resdepl
$call copy gtap_us_e_p.gdx year%year%_loadpoint.gdx
$label skip_copy

*execute_unload "..\..\data_exchange\nonelec_co2emis_USREP_%CES%.gdx" totco2t 
*execute_unload "..\..\data_exchange\bauprofiles_%BAU%.gdx" govinct=govinc_ref vgmtt=vgm_ref

parameter wchange,wchange_us,wchange_tot;
wchange(g,rs) = 100*(w.l(g,rs)-1);
wchange_us("1") = sum((c,s),  (vom(c,s)+vinvs(c,s)+b_leis(c,s))/(sum((c.local,s.local), vom(c,s)+vinvs(c,s)+b_leis(c,s))) * wchange(c,s));
wchange_us("2") = sum((h,s),  (uscensus_hhdata(s,h,"population"))/(sum((h.local,s.local), uscensus_hhdata(s,h,"population"))) * wchange(h,s));
wchange_tot = sum((c,rs),  (vom(c,rs)+vinvs(c,rs)+b_leis(c,rs))/(sum((c.local,rs.local), vom(c,rs)+vinvs(c,rs)+b_leis(c,rs))) * wchange(c,rs));

parameter ptcarbk;
ptcarbk(rs) =1000/carbscale*Pcarb.L(rs)/pnum;

display wchange,ptcarbk,carbrevshare,LSGOVNH.l;


display bca,co2lim,ptcarbk;
*imp_pcarb_u.l,imp_pcarb_u2.l,report_pt.l;


