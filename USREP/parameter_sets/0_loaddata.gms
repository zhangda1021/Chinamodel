$title  read an INTEGRATED MODEL dataset

* Justin Caron, 01/10/2010
* update 26/11/2010

* based on Sebastian Rausch's IMPLANinGAMS code
* and Thomas Rutherford's GTAP7inGAMS package

* -------- NAMESET CHANGES ---------------------
*                       was             is
* institutions          i               ins
* sectors               s,g             i,j
* states (intra-ntl)    r,rr            s, ss
* GTAP regions          -               r
* aggregated SAM acc    j               sam


$if not set ds $set ds integrated
$if not set datadir $set datadir "..\data\"
$setglobal datadir %datadir%

SET     f(*)    Factors,
        t_(*)   Accounts,
        g(*)            Goods and final demands C G and I
        rs(*)   All regions (intra- and international);
$if exist %ds%.gdx $gdxin '%ds%.gdx'
$if not exist %ds%.gdx $gdxin '%datadir%%ds%.gdx'

$load rs f t_=t  g

* load r and s as subsets of rs
set     s(rs)   Intra-natinonal regions (states)
        r(rs)   Inter-national regions (GTAP);


$if exist %ds%.gdx $gdxin '%ds%.gdx'
$if not exist %ds%.gdx $gdxin '%datadir%%ds%.gdx'

$load s r

* load i and ins as subsets of g
set     ins(g)          Institutions
        i(g)            Goods and sectors
        h(g)            Households
        pub(g)          Public entities
        corp(g) Corporate entities
        c(g)            consumption end use ("c" for gtap + h for US)
        pb(g)           public end use ("g" for gtap + pub for US)
        us(rs)          US regions;



$load  i ins h pub corp

c(h) = yes;
c("c") = yes;
pb(pub) = yes;
pb("g") = yes;

us(s) = yes;

alias (h,hh),(i,j),(ins,ins2),(s,ss), (r,rr),(rs,rsrs), (g,gg) ;

SET     mkt /dmkt,ftrd,dtrd/,
        trd(mkt)/ftrd,dtrd/;

set lab(f) /lab/;

set
*       t      "Time periods" /2006, 2010, 2015, 2020, 2025, 2030, 2035, 2040, 2045, 2050,
*                2055, 2060, 2065, 2070, 2075, 2080, 2085, 2090, 2095, 2100/
        t      "Time periods" /2004,2006,2008,2010,2012,2014,2016,2018,2020,2022,2024,2026,2028,
                2030,2032,2034,2036,2038,  2040,2042,2044,2046,2048, 2050,2052,2054,2056,2058,  2060,2062,2064,2066,2068,
                2070,2072,2074,2076,2078, 2080,2082,2084,2086,2088,  2090,2092,2094,2096,2098, 2100/

alias (t,ts);


$ontext
*        Subset of regions

SET     OECD(RS)         /CAN, JPN, EUR, ANZ/;

SET     LDC(RS)  /MEX, ROE, RUS, ASI, CHN, IND, BRA, AFR, MES, LAM, REA/;

set ldc_rich(ldc) /MEX, BRA, ASI, LAM/;
set ldc_poor(ldc) /AFR, IND, REA/;
set ldc_mes(ldc) /MES/;


SET     JPN(RS) /JPN/;

SET     RUS(RS) /RUS/;
$offtext


* --------      DEFINE AND LOAD PARAMETERS:

PARAMETER

* Integrated parameters (based on GTAP7 namespace) - loaded

        vfm(f,g,rs)     Endowments - Firms' purchases at market prices,
        vdfm(i,g,rs)    Intermediates - firms' domestic purchases at market prices,
        vifm(i,g,rs,trd)        Intermediates - firms' imports at market prices (ADDED DIMENSION),
        vxmd(i,rs,rsrs) Trade - bilateral exports at market prices,
        evom(f,rs,*,*)          Factor supply
        rto(g,rs)       Output (or income) subsidy rates
        rtf(f,g,rs)     Primary factor and commodity rates taxes
        rtfd(i,g,rs)    Firms domestic tax rates
        rtfi(i,g,rs)    Firms' import tax rates
        rtxs(i,rs,rsrs) Export subsidy rates
        rtms(i,rs,rsrs) Import taxes rates
        vst(i,rs)       Trade - exports for international transportation
        vtwr(i,j,rs,rs) Trade - Margins for international transportation at world prices

* Integrated parameters (based on GTAP7 namespace) - computed
        vdm(g,rs)       Domestic output
        vom(g,rs)       Aggregate output
        vim(i,rs,trd)   Aggregate imports

* GTAP parameters - loaded

        evd(i,g,rs)     Volume of energy demand (mtoe),
        evt(i,rs,rsrs)  Volume of energy trade (mtoe),
        eco2(i,g,rs)    Volume of carbon emissions (Gg)
        esubd(i)        Elasticity of substitution (M versus D),
        esubva(g)       Elasticity of substitution between factors
        esubm(i)        Intra-import elasticity of substitution,
        etrae(f)        Elasticity of transformation,
        eta(i,rs)       Income elasticity of demand,
        epsilon(i,rs)   Own-price elasticity of demand,


* US model parameters - loaded

* STARRED ARE UNUSED AND CAN BE DELETED
*       vx(s,i)         Aggregate exports
*       vdxm(s,i,trd)   Output to export markets
*       vxm(s,i,trd)    National and international exports
*       vpm(s,h)        Aggregate consumption
        vinv(s)         Aggregate investment
*       vgm(s,pub)      Public sector demand
        evpm(s,j,g)     Goods supply (make and export),
        vprf(s,g)       Corporate profit
        vtrn(s,g,t_)    Transfers
*       vdmi(s,i)       Domestic output including institutional imake
*       trnsfer(s,g,t,ins2)     Inter-institutional transfers
*       iexport(s,g,j,trd) Institutional exports
        btax(i,s)       btax from vfm
        btaxincome(pub,t_,s) btax income to govs from evom
        nt(*)           net transfers

        shrnh           Shares for nuclear and hydro outputs and inputs

        stey0(s,*)              "2006 State level energy supplied (quadrillion Btu)"
        eind(rs,i,g)                    "Industrial energy demand (quadrillion btu)"
        efd(rs,*)                       "Final energy demand (quadrillion btu)"
        eimp(rs,*,trd)                  "Energy imports (quadrillion btu)"
        eexp(rs,*,trd)                  "Energy exports (quadrillion btu)"
        fossil_reserves(s,i)            "Fossil fuel reserves 2006 (quadrillion btu)"
        population_uscensus     "US Census 2006 population"
        wind_ele0               "Electricity produced from wind 2006 (billion btu)"
        geo_ele0                "Electricity produced from geothermal energy by the electric power sector 2006 (Billion Btu)"
        biomass_ele0            "Wood and waste consumed by the electric power sector 2006 (billion Btu)"
        biofuels_prod0          "Energy Production Estimates in Trillion Btu by Source and by State, 2007"

;
$load  vdfm     vifm vfm vprf evom evpm vtrn vst vtwr vinv btax vxmd btaxincome nt shrnh

*$load vdxm vx vxm  vgm  vpm vdmi trnsfer iexport

$load   stey0
$load        eind
$load        efd
$load   eimp
$load   eexp
$load   fossil_reserves
$load   population_uscensus=population
$load   wind_ele0
$load   geo_ele0
$load   biomass_ele0
$load   biofuels_prod0

* --------- GTAP 7 DATA ----------------------

* all based on GTAPinGAMS' gtap7data.gms file from Thomas Rutherford

* load GTAP parameters
$load esubd esubva esubm etrae eta epsilon
$load rto rtf rtfd rtfi rtxs rtms
$load evd evt eco2


set
        rnum(*) Numeraire region,
        sf(f)   Sluggish primary factors (sector-specific),
        mf(f)   Mobile primary factors,
*       ghg     Greenhouse gases /co2/,
        ghgsrc  Sources of greenhouse gas emissions /imp,dom/,
        src     Sources /domestic, imported/;


parameter
        rtf0(f,g,*)     Primary factor and commodity rates taxes
        rtfd0(i,g,*)    Firms domestic tax rates
        rtfi0(i,g,*,*)  Firms' import tax rates
        rtxs0(i,*,*)    Export subsidy rates
        rtms0(i,*,*)    Import taxes rates
        rto0;
rto0(i,rs) = rto(i,rs);
rtf0(f,g,rs) = rtf(f,g,rs);
rtfd0(i,g,rs) = rtfd(i,g,rs);
rtfi0(i,g,rs,"ftrd") = rtfi(i,g,rs);
rtxs0(i,rs,rsrs) = rtxs(i,rs,rsrs);
rtms0(i,rs,rsrs) = rtms(i,rs,rsrs);

parameter       pvxmd(i,*,*)    Import price (power of benchmark tariff)
                pvtwr(i,*,*)    Import price for transport services;

pvxmd(i,rsrs,rs) = (1+rtms0(i,rsrs,rs)) * (1-rtxs0(i,rsrs,rs));
pvtwr(i,rsrs,rs) = 1+rtms0(i,rsrs,rs);


* ---------- INTEGRATED COMPUTED PARAMETERS ---


vdm(i,rs) = sum(g, vdfm(i,g,rs));


* VOM - this one should be correct

*vom(i,r) = vdm(i,r) +  sum(rr, vxmd(i,r,rr)) + vst(i,r);
vom(i,rs) = vdm(i,rs) +  sum(rsrs, vxmd(i,rs,rsrs)) + vst(i,rs);


vom(c,rs) = sum(i, vdfm(i,c,rs)*(1+rtfd0(i,c,rs)) + sum(trd,vifm(i,c,rs,trd)*(1+rtfi0(i,c,rs,trd))));
vom(pb,rs) = sum(i, vdfm(i,pb,rs)*(1+rtfd0(i,pb,rs)) + sum(trd,vifm(i,pb,rs,trd)*(1+rtfi0(i,pb,rs,trd))));
vom("i",rs) = sum(i, vdfm(i,"i",rs)*(1+rtfd0(i,"i",rs)) + sum(trd,vifm(i,"i",rs,trd)*(1+rtfi0(i,"i",rs,trd))));


vdm(c,rs) = vom(c,rs);
vdm(pb,rs) = vom(pb,rs);

* VIM - should also be correct
vim(i,rs,trd) =  sum(g, vifm(i,g,rs,trd));

PARAMETER totalvom;
totalvom = sum((j,r), vdm(j,r));
display totalvom;

* ----- GTAP parameters -----------

parameter
        vtw(j)          Aggregate international transportation services,
        vb(*,*,*)       Current account balance;

vtw(j) = sum(rs, vst(j,rs));

* vb is defined as current account deficit: ie, is difference between imports and exports (should be positive for USA)
* it has to be equal to what country consumes - its endowments

* is going to be related to vtrn in IMPLAN somehow ..

* for GTAP regions, calculated as a residual:



vb("g","ftrd", r) = sum(c, vom(c,r)) + sum(pb, vom(pb,r)) + vom("i",r)

        - sum((f,t_), evom(f,r,"c",t_))
        - sum(j,  vom(j,r)*rto(j,r))
        - sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) + vifm(i,g,r,"ftrd")*rtfi(i,g,r)))
        - sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))
        - sum((i,rs), rtms(i,rs,r) *  (vxmd(i,rs,r) * (1-rtxs(i,rs,r)) + sum(j,vtwr(j,i,rs,r))))
        + sum((i,rs), rtxs(i,r,rs) * vxmd(i,r,rs));

vb("all", "all","chksum") = sum((g,r,trd), vb(g,trd,r));
display vb;

* what vb should be:

*----    879 PARAMETER vb  Current account balance

*USA        568.006,    EUR         56.740,    ROW       -624.747,    eas        560.953,    wes         58.395
*chksum -3.07844E-7



* IF TAKE ONLY EXPORTS TOAND FROM GTAP: VB CORRECT..
* SEE DIFFERENT TREATEMENT OF EXPORT IN ASSIGMENT OF VOM

* THIS IS GONNA HAVE TO ADD UP TO ZERO AT SOME POINT..

*       Determine which factors are sector-specific


mf(f) = yes$(1/etrae(f)=0);
sf(f) = yes$(1/etrae(f)>0);

display etrae,f;
display mf,sf;

parameter       mprofit Zero profit for m,
                yprofit Zero profit for y;

mprofit(i,rs) = sum(trd, vim(i,rs,trd)) - sum(rsrs, pvxmd(i,rsrs,rs)*vxmd(i,rsrs,rs)+sum(j, vtwr(j,i,rsrs,rs))*pvtwr(i,rsrs,rs));
mprofit(i,rs) = round(mprofit(i,rs),5);
display mprofit;
* mprofit also ok if take only gtap regions


yprofit(g,rs) = vom(g,rs)*(1-rto(g,rs))-sum(i, vdfm(i,g,rs)*(1+rtfd0(i,g,rs))
        + sum(trd, vifm(i,g,rs,trd)*(1+rtfi0(i,g,rs,trd)))) - sum(f, vfm(f,g,rs)*(1+rtf0(f,g,rs)));
yprofit(i,r) = round(yprofit(i,r),6)
display yprofit;

*       Define a numeraire region for denominating international
*       transfers:

rnum(rs) = yes$(vom("c",rs)=smax(rsrs,vom("c",rsrs)));
display rnum;


*NEW :
* ----------------------------------------------------------------------------------

$ONTEXT

*
*---------------------------------------------------------------------------------------
* changes relative to USREP :
* -------- NAMESET CHANGES ---------------------
*                       was             is
* institutions          i               ins
* sectors               s,g             i,j
* states (intra-ntl)    r,rr            s, ss
* GTAP regions          -               r
* aggregated SAM acc    j               sam

* ------- PARAMETER NAME CHANGES
* sectoral capital d.   kd0             vfm("cap",,)
* output tax rate       tx(s,i)         rto
* payroll tax rate      ssctf           rtf("lab",,)
* capital inc tax r.    txcorp          rtf("cap",
* hh specific lab end   labor(s,h)      vfms("lab",h,s)
* hh specific cap end   Kapital(s,h)    vfms("lab",h,s)



* ------ ELEMENTS IN US MODEL WITH NO EQUIVALENT IN GTAP
- multiple household types
- multiple governement agents

- factor endowments per household : created VFMS parameter
- tax revenues (output..) per gov agents, in trevrto
- personnal income tax (for hh's)
- household investment (aggregated investment vinv imputed to hh based on capital income)



* ------ elements of IMPLAN data relegated to adjustment factor

- stock adjustment (calculated from good supply evpm) - only to households, evpm for PUB and CORP are imputed to households based on capital income) - ADDED TO OUTPUT IN THE END

* ------ ELEMENTS IN GTAP WITH NO EQUIVALENT IN US MODEL

- rtfd / rtfm : firms tax rates .. input taxes and consumption taxes
- differentiated labor and capital tax rates betvdm(i,rs) = sum(g, vdfm(i,g,rs));
ween sectors (only one in IMPLAN)

$OFFTEXT


* ---- CALCULATE INTERMEDIATE PARAMETERS ---

parameter
        vinvs           "Investment demand by household type (imputed based on capital income)"
        vfms(f,g,rs)    "Factor endowment by household type"

        stk0            "Stock changes/institutional make+imports"
        hhadj(g,rs)             "Household adjustment factor"
        govadj(g,rs)            "Government adjustment factor"
        thetals         "Multiple of benchmark labor supply to determine leisure consumption" /0/;


* ---- ARMINGTON AGGREGATE:

* note: there are no rtfd value-added taxes in State-level data
parameter       rtda0(i,rs)     Benchmark domestic value-added tax rate,
                rtia0(i,rs,trd) Benchmark imports value-added tax rate,
                rtda(i,rs)      Applied domestic value-added tax rate,
                rtia(i,rs,trd)  Applied imports value-added tax rate
                vafm(i,g,rs)    Intermediate demand for Armington goods,
                vam(i,rs)       Aggregate supply of Armington goods;

vafm(i,g,rs) = max((vdfm(i,g,rs)*(1+rtfd0(i,g,rs))+sum(trd,vifm(i,g,rs,trd)*(1+rtfi0(i,g,rs,trd)))),0);

vam(i,rs) = sum(g$(NOT sameas(g,"ent")), vafm(i,g,rs));


rtda0(i,rs)$sum(g,vdfm(i,g,rs)) = sum(g,vdfm(i,g,rs)*rtfd0(i,g,rs))/sum(g,vdfm(i,g,rs));
rtia0(i,rs,trd)$sum(g,vifm(i,g,rs,trd)) = sum(g,vifm(i,g,rs,trd)*rtfi0(i,g,rs,trd))/sum(g,vifm(i,g,rs,trd));
rtda(i,rs) = rtda0(i,rs);
rtia(i,rs,trd) = rtia0(i,rs,trd);

parameter traderevenue(pub,s);
traderevenue("fdg",s) = sum((i,r), rtms(i,r,s) *  (vxmd(i,r,s) * (1-rtxs(i,r,s)) + sum(j,vtwr(j,i,r,s))))
        - sum((i,r), rtxs(i,s,r) * vxmd(i,s,r));
display traderevenue;


*----------------------------------------------------
* MODIFICATIONS TO IMPLAN DATA
*----------------------------------------------------

parameter totaltransfers;
totaltransfers(s,"before changes") = sum((t_,ins), vtrn(s,ins,t_));
display totaltransfers;

* first, recheck budget balances for states:
parameter balancecheck;
balancecheck("households",hh,s)$vom(hh,s) =
        (sum((f,t_) , evom(f,s,hh,t_)) + vprf(s,hh) + sum(j, evpm(s,j,hh)) + sum(t_, vtrn(s,hh,t_)))
        / vom(hh,s);

balancecheck("pub",pub,s) =
        (sum((f,t_) , evom(f,s,pub,t_)) + sum(t_,btaxincome(pub,t_,s)) + vprf(s,pub) + sum(j, evpm(s,j,pub)) + sum(t_, vtrn(s,pub,t_)) + traderevenue(pub,s))
        / vom(pub,s);

display balancecheck;
*ok here

* -- FACTOR ENDOWMENTS - EVOM..

* distribute labor endowments to  household type
* this distributes hh and ent labor endowment (small) to households
* labor endowment of govs not included here
vfms("lab",h,s) = sum(t_,evom("lab",s,h,t_))/sum((h.local,t_),evom("lab",s,h,t_))
                * (sum(i, vfm("lab",i,s))-sum((t_,pub),evom("lab",s,pub,t_)));

* distribute capital payments to each household type
* this distributes all capital endowment (incl ent and gov)
parameter capsh;
capsh(h,s)$sum((h.local,t_),evom("cap",s,h,t_)) = sum(t_,evom("cap",s,h,t_)) /sum((h.local,t_),evom("cap",s,h,t_));
capsh("hhl","scen") = capsh("hhl","scen") + 0.005;
capsh("hh150","scen") = capsh("hh150","scen") - 0.005;

vfms("cap",h,s) = capsh(h,s) * sum(i, vfm("cap",i,s));

* distribute resource payments to each household type
* this distributes all capital endowment (incl ent and gov)
*vfms("res",h,s) = sum(t_,evom("res",s,h,t_))
*               /sum((h.local,t_),evom("cap",s,h,t_)) * sum(i, vfm("cap",i,s));

* for resources, its already shared out:
vfms("res",h,s) = sum(t_,evom("res",s,h,t_));

* -- STOCK CHANGES
* Distribute stock changes in proportion to capital income:
*               note: evpm is good supply (make and export), from different elements of INS to sectors i, ent is heavily negative, h and gov slightly positive, overall negative
*               stock changes are goods supply from households + good supply from pub and corp distributed to households according to share of capital ownership
stk0(s,i,h)$sum((h.local,t_),evom("cap",s,h,t_)) 
		 = evpm(s,i,h) + sum(t_,evom("cap",s,h,t_))
                /sum((h.local,t_),evom("cap",s,h,t_)) * (sum(pub, evpm(s,i,pub)) + sum(corp,evpm(s,i,corp)));

*stk0(s,i,h)$vom(i,s) = evpm(s,i,h) + sum(t_$vom(i,s),evom("cap",s,h,t_))
*               /sum((h.local,t_)$vom(i,s),evom("cap",s,h,t_)) * (sum(pub, evpm(s,i,pub)) + sum(corp,evpm(s,i,corp)));

* these stock changes are all negative.

display stk0;

* -- INVESTMENT
* QQ : VINV WAS NOT BALANCED.. still dont understand why it is not equal to investment demand

* assign investment to households based on capital income:
* ASSUMPTION : use investment demand (should satisfy i zero pi automatically)
vinvs(h,s)$sum((h.local,t_),evom("cap",s,h,t_)) = sum(t_,evom("cap",s,h,t_))
                /sum((h.local,t_),evom("cap",s,h,t_))  * (sum(i,  vdfm(i,"i",s) + sum(trd, vifm(i,"i",s,trd))));


*       Stock changes/instituional make+export are fairly small relative to
*       production. We impute stock changes to sectoral production.
*       Sectoral production net of stock changes:

* NEW CHANGE HERE: TAKE OUT EVPM OUT OF OUTPUT.. SMALL CHANGE BUT NECESSARY ?
* QQ : WHY IS EVPM IN ORIGINAL ZERO-PI
vom(i,s) = vom(i,s) +  sum(h,stk0(s,i,h)) - sum(ins, evpm(s,i,ins));

* Adjust sectoral capital inputs:
vfm("cap",i,s) = vfm("cap",i,s) + sum(h,stk0(s,i,h));

* re-adjust capital endowments by household type:
vfms("cap",h,s) = vfms("cap",h,s) + sum(i,stk0(s,i,h));
* QUESTION : ADD THIS TO CAP OR LAB ?

* -- ADJUSTMENT FACTORS:
*       are used so that each household's budget balance is satisfied

* QQ : WHY DO WE TAKE OUT STOCK CHANGE HERE ! THIS MAKE RH BB NOT HOLD !!
* we take out stock change, but make no change to vdm = vom(hh)?
* dont see how this can work
* UNSURE STEP: TOOK OUT STOCK CHANGE HERE
hhadj(h,s) = vom(h,s) + vinvs(h,s) - sum(f, vfms(f,h,s));
*- sum(g, stk0(s,g,h));
govadj(pub,s) = vom(pub,s);

* check balance again here:
balancecheck("households",hh,s)$(vom(hh,s)) =
*       (sum((f,t_) , evom(f,s,hh,t_)) + vprf(s,hh) + sum(j, evpm(s,j,hh)) + sum(t_, vtrn(s,hh,t_)))
*       becomes:
        (sum(f, vfms(f,hh,s)) - vinvs(hh,s) + hhadj(hh,s)  )
                / (vom(hh,s));
* would hold if it werent for stock changes!

balancecheck("pub",pub,s) =
        govadj(pub,s)   / vom(pub,s);

display balancecheck;

*------------------------------------------------------------
* TAX RATES FOR IMPLAN DATA IN GTAPinGAMS FORMAT
*------------------------------------------------------------
parameter
        taxrevenue(g,rs)        tax revenue by institution
        trevbtax(s,pub)         "Tax revenue from output taxes"
        pitx(f,g,rs)            "Average personal income tax rate"
        pitx0(f,g,rs)           "Benchmark average personal income tax rate"
        hhpitx(s,h)             "Personal income tax payements (pitx)"
        taxrevhhpitx(s,pub)     "Tax revenue from personal income (pitx)"
        trevfica(s,pub)         "Tax revenue from social security taxes"
        trevficaw(s,pub)        "Tax revenue from social security taxes (employee)"
        trevficaf(s,pub)        "Tax revenue from social security taxes (employer)"
        txcorp(s)               "Capital income tax rate (based on corporate profits tax)"
        txcorp0(s)              "Capital income tax rate (based on corporate profits tax)"
        hhctax(s,h)             "Capital income tax payments (based on corporate profits tax)"
        trevctax(s,pub)         "Tax revenue from capital income tax";


parameter trevrto tax revenue from output tax - was trevbtax;

* -- OUTPUT TAX
* used to be tx(x,s)
rto(i,s)$vom(i,s) = btax(i,s) / vom(i,s) ;
rto0(i,s) = rto(i,s);


* tax revenues accrue to different governement agents
* this information is still in btaxincome at this point,
* in model it will be included in demand blocks for gov agents, and thus needs needs to be kept
trevrto(s,pub) = sum(t_, btaxincome(pub,t_,s));

display rto,trevrto;
* output taxes implies by IMPLAN are higher than those in GTAP, most revenues go to "STG"

* -- LABOR TAX
* based on FICA tax rates:
* note: sstw and sstf are the only accounts in evom for labor, gov
trevficaw(s,pub) = evom("lab",s,pub,"sstw");
trevficaf(s,pub) = evom("lab",s,pub,"sstf");
trevfica(s,pub) = trevficaw(s,pub) + trevficaf(s,pub);
evom("lab",s,pub,t_) = 0;
* this was purpusely not included in vfms.. so ok

rtf("lab",i,s) = sum(pub,trevfica(s,pub))/(sum(i.local,vfm("lab",i,s))-sum(pub,trevfica(s,pub)));
rtf0("lab",i,s) = rtf("lab",i,s);
* adjust labor flows
vfm("lab",i,s) = vfm("lab",i,s) / (1+rtf("lab",i,s));
display rtf;
* not to different from GTAP values, good


* -- CAPITAL INCOME TAX
* based on corporate profits tax payments:

* from Sebastian:       NB: Imputed capital income tax based on IMPLAN data seems to be to low.
*           Note that we can calibrate to any tax rate through appropriate
*           scaling of vtrn(s,"ent","ctax").

* calculate capital tax payments, distribute them to household based on share of capital payments.
hhctax(s,h)$sum(h.local,vfms("cap",h,s)) = vtrn(s,"ent","ctax") * vfms("cap",h,s)/sum(h.local,vfms("cap",h,s));
* negative values

* ASSUMPTION : all revenue accrues to FDG?
trevctax(s,"fdg") = -vtrn(s,"ent","ctax");
vtrn(s,"ent","ctax") = 0;

* ctax has no equivalent for gov entities (or households) in the vtrn parameter..
* thus, taking it out of ctax changes balance of transfers.
* ASSUMPTION : add it to FDG
vtrn(s,"fdg","ctax") = - trevctax(s,"fdg");
* this is done to keep sum of vtrn = current balance..

totaltransfers(s,"after ctax change") = sum((t_,ins), vtrn(s,ins,t_));

* calculate capital income tax rates (capital tax payments over capital ownwership)
rtf("cap",i,s) = sum(pub,trevctax(s,pub)) / (sum(h,vfms("cap",h,s))-sum(pub,trevctax(s,pub)));
rtf0("cap",i,s)= rtf("cap",i,s);

* Capital income tax seems high, compared to GTAP !
* Q for sebastian : why do you say this is low?

* adjust capital flows:
vfm("cap",i,s)$(1+rtf("cap",i,s)) = vfm("cap",i,s) / (1+rtf("cap",i,s));
vfms("cap",h,s) = vfms("cap",h,s) + hhctax(s,h);
*vfm(f,g,rs)$(vfm(f,g,rs) lt 1e-12) = 0;


balancecheck("sectors",i,s)$(
         sum(j, vdfm(j,i,s)) + sum((j,trd),vifm(j,i,s,trd)) + sum(f, vfm(f,i,s)*(1+rtf0(f,i,s)))  + sum(ins, evpm(s,i,ins)))
                 =  (vom(i,s)*(1-rto0(i,s))) / (
         sum(j, vdfm(j,i,s)) + sum((j,trd),vifm(j,i,s,trd)) + sum(f, vfm(f,i,s)*(1+rtf0(f,i,s)))  + sum(ins, evpm(s,i,ins)));
display balancecheck;
*ok here still

*  -- AVERAGE PERSONAL INCOME TAX (not in GTAP)
*        this is not in GTAP, not equivalent to labor tax

hhpitx(s,h) = vtrn(s,h,"pitx");
taxrevhhpitx(s,pub) = vtrn(s,pub,"pitx");
vtrn(s,h,"pitx") = 0;
vtrn(s,pub,"pitx") = 0;
* this two changes cancel each other out, no difference in total tranfers after this

set ftax(f) Factors that subejct to personal income tax /cap,lab/;

*       Initialize personal income tax rate parameter:
pitx(f,h,s) = 0;
pitx0(f,h,s) = 0;

*       Set personal income taxes for capital and labor:
pitx(ftax,h,s) = abs(hhpitx(s,h)) / (vfms("lab",h,s)+vfms("cap",h,s));
pitx0(ftax,h,s) = pitx(ftax,h,s);

display pitx, taxrevhhpitx;

totaltransfers(s,"after pitx change") = sum((t_,ins), vtrn(s,ins,t_));
display totaltransfers;

* -- TAX REVENUES
*       unified parameter for tax revenue in US states:
taxrevenue(pub,s) = trevrto(s,pub) + taxrevhhpitx(s,pub) + trevfica(s,pub) + trevctax(s,pub) + traderevenue(pub,s);

*       for gtap regions.. need to this as well, as we are using same structure
taxrevenue("g",r) =  sum(j,  vom(j,r)*rto(j,r)) +
 sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) + vifm(i,g,r,"ftrd")*rtfi(i,g,r)))
        + sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))
        + sum((i,rs), rtms(i,rs,r) *  (vxmd(i,rs,r) * (1-rtxs(i,rs,r)) + sum(j,vtwr(j,i,rs,r))))
        - sum((i,rs), rtxs(i,r,rs) * vxmd(i,r,rs));


parameter gtapbalance;
gtapbalance(r) = vom("c",r) + vom("g",r) + vom("i",r) -sum((pb,trd), vb(pb,trd,r)) - sum((t_,f), evom(f,r,"c",t_)) -taxrevenue("g",r);
display gtapbalance;


*------------------------------------------------------------------
* -- CURRENT ACCOUNT DEFICIT

* ASSUMPTION : FOR NOW, ASSUME ONLY GOVERNMENT FINANCES CURRENT ACCOUNT DEFICITS IN STATES
* in theory, it might be possible to determine from the VTRN parameter which parts go to
* households and which part goes to government entities..
* we singled out two potential accounts which could correspond to current account " TRNS" AND "SRPL"
* but where not able to identify which one exactly.. work on this maybe
* for now, assign deficit to FDG

* should be able to add deficits for states and get US deficit ? I think so..
* current account deficit for US is supposed to be 566.288

* calculate current account deficit for states (deficit both to states and other regions)
* ASSUMPTION : assign trade balance to this
* thus the 40 billion transfers to the US do not appear in the model at this point

vb("fdg","ftrd",s) =   sum((i,r),vxmd(i,r,s))  - sum((i,r),vxmd(i,s,r));

vb("fdg","dtrd",s) =   sum((i,ss),vxmd(i,ss,s))  - sum((i,ss),vxmd(i,s,ss));
vb("all", "all","chksum") = sum((g,rs,trd), vb(g,trd,rs));
display vb;
* the 40 remaining are the "other transfers" which constitute the difference beteween CA and TB in the USA
* VB in states correpsonds to the sum of tranfers


* sum of transfers should be equal to current account deficits, check this:
parameter testvb;
testvb("transfers",s) =   sum((t_,ins), vtrn(s,ins,t_)) / sum((g,trd), vb(g,trd,s));
display testvb;
*yes

* -----------------------------------------------------------------
* ADJUSTMENT PARAMETERS

*  Update income adjustment parameters:
hhadj(h,s) = hhadj(h,s) - hhpitx(s,h) - hhctax(s,h);
govadj(pub,s) = govadj(pub,s) -taxrevenue(pub,s) - sum((trd), vb(pub,trd,s)) ;
* this means doing :
*govadj(s,pub) = govadj(s,pub) - trevrto(s,pub) - taxrevhhpitx(s,pub)
*               - trevfica(s,pub) - trevctax(s,pub) -  traderevenue(pub,s);

display hhadj, govadj;
* hhadj positive, govadj negative for fdg, positive for stg
* hhadj and govadj include the current account deficit

* --- CHECK BALANCE AGAIN HERE:
balancecheck("households",hh,s)$(vom(hh,s)) =
        (sum(f, vfms(f,hh,s) * (1-pitx(f,hh,s))) - vinvs(hh,s) + hhadj(hh,s)  )
                / (vom(hh,s));

balancecheck("pub",pub,s)$vom(pub,s) =
        (govadj(pub,s) +taxrevenue(pub,s) +sum((g,trd), vb(g,trd,s)) )
        / vom(pub,s);

display balancecheck;
*HERE NOT OK ANY MORE

* -----------------------------------------------------------------
* GTAP DATA ADPTATION :

* assign per household values to gtap regions:
vfms(f,"c",r) = sum((t_),evom(f,r,"c",t_));
vinvs("c",r) = vom("i",r);

* implicit (tax) transfer from private to public demand:
* include these within the adjustment hhadjparameters:
hhadj("c",r) =   vom("c",r) +  vom("i",r) - sum((f,t_), evom(f,r,"c",t_));
govadj("g",r) =  - hhadj("c",r);
display hhadj;
display govadj;



* define CIF trade flows out of US states
* !!! USE VIM FOR NOW, NEEDS CLEAN-UP
* use "dtrd" in vim for GTAP regions, as meaning "from US states"
*parameter usexportscif;
*usexportscif(i,rs) = sum(s,pvxmd(i,s,rs) * vxmd(i,s,rs)) + sum((j,s), vtwr(j,i,s,rs));
* use vim(i,rs,"dtrd") instead of this :

vim(i,r,"dtrd") = sum(s,pvxmd(i,s,r) * vxmd(i,s,r)) + sum((j,s), vtwr(j,i,s,r)*pvtwr(i,s,r));


*       Resource rents by household by type:

parameter vfmresh "Resource rents by household by sector";
vfmresh(j,c,rs)$sum(j.local,vfm("res",j,rs)) = vfms("res",c,rs)*vfm("res",j,rs)/sum(j.local,vfm("res",j,rs));


*       CHECK ZERO PROFITS FOR ELECTRICITY SECTOR:

parameter zprf_ele;

zprf_ele(rs) = vom("ele",rs) * (1-rto("ele",rs))
                - sum(i,vafm(i,"ele",rs))
                - sum(f,vfm(f,"ele",rs)*(1+rtf(f,"ele",rs)));

display zprf_ele;

*       SEPARATE NUCLEAR AND HYDRO FROM ELECTRICITY GENERATION:

parameter
        vomnh           Output of nuc and hyd
        vfmnh           Factor inputs for nuc and hyd
        vdfmnh          Inputs for nuc and hyd ;

set nh Nuclear and hydro  /nuc,hyd/;

parameter chkvfm;
chkvfm(f,rs) = 1;

set iter Iterations to avoid negative imputed vfm after including nuclear and hydro /1*100/;

parameter shrnhoutput,idneg,idneglog,vom__,vfm__,vafm__,taxrev0;

idneg(rs) = 0;
vom__(i,rs) = vom(i,rs);
vfm__(f,i,rs) = vfm(f,i,rs);
vafm__(i,g,rs) = vafm(i,g,rs);

taxrev0(f,rs,"b4",c) = vfms(f,c,rs)*pitx(f,c,rs);


*** CODE THAT separates nuc and hyd from total electricity generation:
*$ontext

set s_exp /AZ,CA,NV,UT,PACI/;

table shrnh_(*,s_exp)
	AZ	CA	NV	UT	PACI
HYD	0.0657	0.2642	0.1068	0.0231	0.7662
NUC	0.2303	0.1571	0.0000	0.0000	0.0000
;
shrnh("nuc","output",s_exp) = shrnh_("nuc",s_exp);
shrnh("hyd","output",s_exp) = shrnh_("hyd",s_exp);


loop(iter,

*       Reduce share of nuclear and hydro if imputed capital demand for non-nuclear+hydro is negative:
shrnh(nh,"output",rs)$idneg(rs) = shrnh(nh,"output",rs) * (1-0.01*ord(iter));

*       Iteration log:
shrnhoutput(nh,rs,iter) = shrnh(nh,"output",rs);

*       Nuclear and hydro output:
vomnh(nh,rs) =  shrnh(nh,"output",rs) * vom__("ele",rs);

*       Input demands:
vfmnh("lab",nh,rs) = shrnh(nh,"lab",rs) * vomnh(nh,rs) * (1-rto("ele",rs))/(1+rtf("lab","ele",rs));
vfmnh("cap",nh,rs)$(1+rtf("cap","ele",rs)) = shrnh(nh,"cap",rs) * vomnh(nh,rs) * (1-rto("ele",rs))/(1+rtf("cap","ele",rs));
vfmnh("res",nh,rs)$(1+rtf("cap","ele",rs)) = shrnh(nh,"res",rs) * vomnh(nh,rs) * (1-rto("ele",rs))/(1+rtf("cap","ele",rs));
vdfmnh(i,nh,rs)$vafm__(i,"ele",rs) = vafm__(i,"ele",rs)/sum(i.local,vafm__(i,"ele",rs)) *  sum(i.local,shrnh(nh,i,rs)) * vomnh(nh,rs)* (1-rto("ele",rs));

*       Recalibrate output, capital, and labor, srv, and oth for electricity generated from fossil fuel:
vom("ele",rs) = vom__("ele",rs) - sum(nh,vomnh(nh,rs));

vfm("lab","ele",rs) = vfm__("lab","ele",rs) - sum(nh,vfmnh("lab",nh,rs));
vfm("cap","ele",rs) = vfm__("cap","ele",rs) - sum(nh,vfmnh("cap",nh,rs))-sum(nh,vfmnh("res",nh,rs));
vafm(i,"ele",rs) = vafm__(i,"ele",rs) - sum(nh,vdfmnh(i,nh,rs));

*       Check sign of imputed values:
chkvfm(f,rs) = vfm(f,"ele",rs)$(vfm(f,"ele",rs) lt 0);
chkvfm(i,rs) = vafm(i,"ele",rs)$(vafm(i,"ele",rs) lt 0);

*       Identify negative values and record log:
idneg(rs) = 1$(chkvfm("cap",rs) lt 0 or chkvfm("lab",rs) lt 0 or sum(i,chkvfm(i,rs)) lt 0);
idneglog(rs,iter) = idneg(rs);

);

shrnhoutput(nh,rs,"%dev")$shrnhoutput(nh,rs,"1") = 100*(shrnhoutput(nh,rs,"100") / shrnhoutput(nh,rs,"1")-1);

abort$(smin((rs,f),chkvfm(f,rs)) lt -1e-12) "Imputed vfm is negative (see mergedata.gms)",chkvfm;
abort$(smin((rs,i),chkvfm(i,rs)) lt -1e-12) "Imputed vafm is negative (see mergedata.gms)",chkvfm;

display idneg,idneglog,shrnhoutput;

*       Define resource rents for nuc and hyd:

parameter vfmsnh        Base year rents for nuclear and hydro resource;

*       Use capital income share to distribute rents among households within a given US state/region.

vfmsnh(nh,c,rs) = vfms("cap",c,rs)/sum((c.local),vfms("cap",c,rs)) * vfmnh("res",nh,rs);

*       Reduce capital endowments to accommodate resource supplies for nuc and hyd:

vfms("cap",c,rs) = vfms("cap",c,rs) - sum(nh,vfmsnh(nh,c,rs));

*       Adjust personal income rate on capital to generate benchmark tax revenue:

taxrev0(f,rs,"after",c) = vfms(f,c,rs)*pitx(f,c,rs);

pitx("cap",c,rs)$vfms("cap",c,rs) = taxrev0("cap",rs,"b4",c)/vfms("cap",c,rs);
pitx0("cap",c,rs) = pitx("cap",c,rs);
*$offtext



*** CODE THAT reduces size of electricity sector and adds nuc and hyd sectors without accommodating 
*	outputs and inputs into original SAM, i.e. we truly add sectors instead of separating them 
*	out of existing ELE. Unlike the approach above, this approach avoids distorting the size of
*	nuc and hyd generation.

$ontext
*       Nuclear and hydro output:
shrnh("nuc","output","paci") = 0;
vomnh(nh,rs) =  shrnh(nh,"output",rs) * vom__("ele",rs);

*       Input demands:
vfmnh("lab",nh,rs) = shrnh(nh,"lab",rs) * vomnh(nh,rs) * (1-rto("ele",rs))/(1+rtf("lab","ele",rs));
vfmnh("cap",nh,rs)$(1+rtf("cap","ele",rs)) = shrnh(nh,"cap",rs) * vomnh(nh,rs) * (1-rto("ele",rs))/(1+rtf("cap","ele",rs));
vfmnh("res",nh,rs)$(1+rtf("cap","ele",rs)) = shrnh(nh,"res",rs) * vomnh(nh,rs) * (1-rto("ele",rs))/(1+rtf("cap","ele",rs));
vdfmnh(i,nh,rs)$vafm__(i,"ele",rs) = vafm__(i,"ele",rs)/sum(i.local,vafm__(i,"ele",rs)) *  sum(i.local,shrnh(nh,i,rs)) * vomnh(nh,rs)* (1-rto("ele",rs));

*	Scale existing ELE generation:
*       Recalibrate output, capital, and labor, srv, and oth for electricity generated from fossil fuel:
parameter scale_ele;
scale_ele(rs) = (vom__("ele",rs) - sum(nh,vomnh(nh,rs)))/vom__("ele",rs);

vom("ele",rs) = scale_ele(rs) * vom__("ele",rs);
vfm("lab","ele",rs) = scale_ele(rs) * vfm__("lab","ele",rs);
vfm("cap","ele",rs) = scale_ele(rs) * vfm__("cap","ele",rs);
vafm(i,"ele",rs) = scale_ele(rs) * vafm__(i,"ele",rs);

*       Define resource rents for nuc and hyd:

parameter vfmsnh        Base year rents for nuclear and hydro resource;

*	Update capital and labor endowment:
vfms("cap",c,rs) = vfms("cap",c,rs) + vfms("cap",c,rs)/sum(c.local,vfms("cap",c,rs)) 
		* (sum(nh,vfmnh("cap",nh,rs)) - (1-scale_ele(rs)) * vfm__("cap","ele",rs)); 
vfms("lab",c,rs) = vfms("lab",c,rs) + vfms("lab",c,rs)/sum(c.local,vfms("lab",c,rs)) 
		* (sum(nh,vfmnh("lab",nh,rs)) - (1-scale_ele(rs)) * vfm__("lab","ele",rs)); 

*       Use capital income share to distribute rents among households within a given US state/region.

vfmsnh(nh,c,rs) = vfms("cap",c,rs)/sum((c.local),vfms("cap",c,rs)) * vfmnh("res",nh,rs);

*       Reduce capital endowments to accommodate resource supplies for nuc and hyd:

vfms("cap",c,rs) = vfms("cap",c,rs) - sum(nh,vfmsnh(nh,c,rs));

*       Adjust personal income rate on capital to generate benchmark tax revenue:

taxrev0(f,rs,"after",c) = vfms(f,c,rs)*pitx(f,c,rs);

pitx("cap",c,rs)$vfms("cap",c,rs) = taxrev0("cap",rs,"b4",c)/vfms("cap",c,rs);
pitx0("cap",c,rs) = pitx("cap",c,rs);
$offtext

*--------------------------------------------------------------------------
*       Do a CES calibration to a given price supply elasticity for nuclear and hydro:

PARAMETER neta          Price elasticity of supply for nuclear,
          heta          Price elasticity of supply for hydro,
          sharenh       Cost share of nuclear or hydro
          sigmanh       Elasticity of substitution between value added and nuclear or hydro resource;

*       Price supply elasticity from EPPA 4 (assumed to be identical across all US states):

neta(rs)=0.5;
neta("usa")=0.25;
neta("eur")=0.50;
neta("jpn")=1.00;
neta("can")=0.40;
neta("rus")=0.25;
neta("roe")=0.25;
neta("asi")=0.60;
neta("chn")=0.60;
neta("ind")=0.60;

heta(rs)=0.5;
heta("jpn")=0.25;
heta("anz")=0.25;


*       Zero profit for nuclear and hydro electicity generation:

parameter zprf_nuchyd;
zprf_nuchyd(rs,nh) = vomnh(nh,rs)*(1-rto("ele",rs))
                                - vfmnh("cap",nh,rs)*(1+rtf("cap","ele",rs))
                                - vfmnh("lab",nh,rs)*(1+rtf("lab","ele",rs))
                                - vfmnh("res",nh,rs)*(1+rtf("cap","ele",rs))
                                - sum(i,vdfmnh(i,nh,rs));
display zprf_nuchyd;

*       Zero profit for non-nuclear+hydro electricity:
zprf_ele(rs) = vom("ele",rs) * (1-rto("ele",rs))
                - sum(i,vafm(i,"ele",rs))
                - sum(f,vfm(f,"ele",rs)*(1+rtf(f,"ele",rs)));


display zprf_ele;

*abort$(abs(smin(rs,sum(nh,zprf_nuchyd(rs,nh))+zprf_ele(rs))) gt 1e-8) "Zero profit conditions for electricity production does not hold (see loaddata.gms)";


display rtf,rto;

* -----------------------------------------------------------------
* SOME BASIC ENERGY STUFF

set
        fe(i)   Fossil fuels       /oil, gas, col/     ,
        ene(g)  All energy goods /cru,col,oil,gas,ele/ ,
        en(i)   Energy goods (including crude)/cru,col,oil,gas/ ,
        elee(i) Electricity/ele/ ,
        e(g)    Energy inputs        /col,oil,gas,ele/   ,
	crud(g)  Crude oil /cru/
        xe(i)   Exhaustible energy    /col,cru,gas/
	nene(g)
*       border(i,rsrs,rs)  Country pairs with border adjustment
;

nene(g) = yes$(not ene(g));

*	Sets and identifiers for EPPA sectors/nesting structure:
set	
	agr(g)	/agr/
	roil(g) /oil/
	elecc(g) /ele/
	res(g)  /col,cru,gas/
	trn(g) /trn/;

parameter nsps(g)	"All sectors excluding agr,ele,xe,oil,cons,inv";

nsps(g) = yes$((not agr(g))$(not roil(g))$(not elecc(g))$(not res(g))
			$(not sameas("c",g))$(not pub(g))$(not sameas("i",g))$(not sameas("g",g)));

	

* -----------------------------------------------------------------
* CRUDE OIL TREATMENT

parameter       vcrud(i,rs)     Net value of crude oil demand,
                vcrus(g,rs)     Net value of crude oil supply,
                vtwrcru(j,i,rs) Value of crude oil transport costs,
                rtocru(g,rs)    Benchmark tax rate on crude oil supply,
                rtcru0(i,rs)    Benchmark tax rate on crude oil,
                rtcru(i,rs)     Counterfactual tax rate on crude oil;

loop(i$sameas(i,"cru"),

*       Value of crude supply (net export subsidy):

  vcrus(i,rs) = vom(i,rs) - sum(rsrs, vxmd(i,rs,rsrs)*rtxs(i,rs,rsrs));

*       Crude oil output tax net export subsidy:
  rtocru(i,rs)$vcrus(i,rs) = (rto(i,rs)*vom(i,rs)-sum(rsrs, vxmd(i,rs,rsrs)*rtxs(i,rs,rsrs)))/vcrus(i,rs);

*       Value of crude oil demand net subsidy and tariff charges:
  vcrud(i,rs) = vdm(i,rs) + sum(rsrs,vxmd(i,rsrs,rs)*(1-rtxs(i,rsrs,rs)));

*       Value of transport inputs to crude imports in region rs:
  vtwrcru(j,i,rs) = sum(rsrs,vtwr(j,i,rsrs,rs));

*       Benchmark tax+tariff rate on crude oil demand
*       in region rs:
  rtcru0(i,rs)$(vcrud(i,rs)+sum(j,vtwrcru(j,i,rs))) = (rtda0(i,rs)*vdm(i,rs)+rtia0(i,rs,"ftrd")*vim(i,rs,"ftrd") +
                sum(rsrs,rtms(i,rsrs,rs)*(1-rtxs(i,rsrs,rs))*vxmd(i,rsrs,rs)) +
                sum((j,rsrs), rtms(i,rsrs,rs)*vtwr(j,i,rsrs,rs)))
                / (vcrud(i,rs)+sum(j,vtwrcru(j,i,rs)));

  vdm(i,rs) = 0;
  vim(i,rs,"ftrd") = 0;
 vim(i,rs,"dtrd") = 0;

);
rtcru(i,rs) = rtcru0(i,rs);
display rtcru;

parameter crudeuse      Crude oil inputs;
crudeuse("value",g,rs) = vafm("cru",g,rs);
crudeuse("share",g,rs)$(vafm("cru",g,rs)+vafm("oil",g,rs))
        = vafm("cru",g,rs)/(vafm("cru",g,rs)+vafm("oil",g,rs))
display crudeuse;

parameter       crudeshare      Crude input value share;
crudeshare(rs,g)$vom(g,rs) = vafm("cru",g,rs)/(vom(g,rs)*(1-rto(g,rs)));
display crudeshare;

*-----------------------------------------------
* MODEL SET-UP STUFF :
* -----------------------------------------------
*       Set up logical arrays defining model sparsity:

set     state(rs)       flag for US states
        flag(g,rs)      flag set for production blocks
	flagcaexp(rs)   "CA + regions exporting ele to CA"
        cons(g,rs)      flag set for private demand
        gov(g,rs)       flag set for public demand
        inv(g,rs)       flag set for investment demand
        pcarbsink(g,rs) flag which defines which gov entities receive carbon permits
        yy(g,rs)                Sectors which are in the model
        pp(g,rs)                Commodities with domestic markets
        cru(g,rs)        Crude oil sector
        oil(g,rs)        Oil refining sector
        oth(g,rs)        Other sectors
        col(g,rs)  Coal extraction and distribution sector
        gas(g,rs)  Gas extraction and distribution sector
        ele(g,rs)  Electricity
        elec(i)    Electricity
        enoe(i)   /col,cru,oil,gas/
        oill(i)         "Refined oil"                           /oil/
        gass(i)         "Natural gas"                           /gas/
        coll(i)         "Coal"                                  /col/
        noe(i)
        ne(i)           "Energy w/o CRU"                        /col,oil,gas,ele/
        ener(i)         "Energy markets"
                        /  gas
                           ele
                           oil
                           col
                           cru      /
;

flagcaexp(rs) = no;
*flagcaexp("ca") = yes;
*flagcaexp("nv") = yes;
*flagcaexp("ut") = yes;
*flagcaexp("paci") = yes;
*flagcaexp("az") = yes;


yy(g,rs) = yes$(vom(g,rs)>1e-10);
cru("cru",rs) = yes$(vom("cru",rs) > 1e-10);
ele("ele",rs) = yes$vom("ele",rs);
oth(yy(g,rs)) = yes$((not cru(g,rs))$(not ele(g,rs)));
oil("oil",rs) = yes$vom("oil",rs);
col("col",rs) = yes$vom("col",rs);
gas("gas",rs) = yes$vom("gas",rs);
elec("ele") = yes;
noe(i) = yes$((not enoe(i))$(not elec(i)));

pp(g,rs)$(not cru(g,rs)) = yes$vom(g,rs);
display pp;

state(s) = yes;

flag(g,rs)$(vom(g,rs)>1e-10) = yes;
*flag("c",s) = no;
*flag("g",s) = no;
display flag;


cons(h,s) = yes;
cons("c",r) = yes;
display cons;


gov(pub,s) = yes;
gov("g",r) = yes;
display gov;

inv("i",rs) = yes;

* QUESTION : where do carbon permit revenues accrue to ? for now, fdg
*  made set of governement receivers of carbon permit revenues

pcarbsink("fdg",s) = yes;
pcarbsink("g",r) = yes;
display pcarbsink;

* Flag for mobile capital across US regions:
$if not set mobcapus $set mobcapus yes

set mk(f,rs)    "Flag for mobile capital across US regions --default yes";

mk("cap",s)=%mobcapus%;

* ----------------------------------------------------------------------------------
*	Calibrate benchmark electricity fuel mix:

*	Model benchmark for elec_preg if EU is base:
set ccf /col,oil,gas,nuc,hyd/;
table elec_preg0(ccf,s)
	AK	AZ	CA	FL	NV	NY	TX	UT	NENG	SEAS	NEAS	SCEN	NCEN	MOUN	PACI
OIL	0.003	0	0.008	0.083	0	0.014	0.008	0	0.003	0.018	0.015	0.011	0.003	0.003	
GAS	0.015	0.076	0.268	0.271	0.068	0.081	0.624	0.011	0.029	0.169	0.144	0.243	0.029	0.045	
col	0.002	0.126	0.008	0.242	0.032	0.045	0.641	0.135	0.016	1.497	2.024	0.386	0.65	0.375	
nuc		0.127	0.191	0.127		0.188	0.19		0.279	0.984	1.523	0.138	0.253		
hyd	0.005	0.036	0.285	0.001	0.028	0.121	0.003	0.005	0.071	0.118	0.06	0.012	0.04	0.144	0.551
;

*	EIA data on ele generation (in MwH) for 2006

table eiaelegen(ccf,s) "EIA data on ele generation (in MwH) for 2006" 
	AZ		CA		NV		UT		PACI
COL	40442855	2049947		7253521		36855550	10292046
OIL	73371		1542848		17347		62126		9104524
GAS	32869047	113463455	21184135	3388550		18734052
NUC	24012231	31763804			
HYD	6846471		53427698	3401337		952259		124927497
;

eiaelegen(ccf,s) = 3.6*1e-9*eiaelegen(ccf,s);

*  ------  ELASTICITIES -----------
parameter
                esub(g,rs)              Top-level elasticity (energy versus non-energy),
                esubn(g,rs)             Top-level elasticity (among non-energy goods),
                esubkl(g,rs)            Capital-labor elasticity
                esubmusa(i,rs)          Elasticity of substitution between US sources
                esubdusa(i,rs)          Elasticity of substitution between local and other State imports (only valid for US states) ;

esub(g,rs)    = 0.5;
esubn(c,rs) = 1.0;
esubkl(g,rs)  = esubva(g);


* elasticity of substitution between goods produced within state and from other US states
* we do not have econometric estimates of this, but should be quite high
*esubdusa(i,s) =  4 * esubd(i);
* SEE BELOW

* -- BORDER EFFECT CALIBRATION

parameter       bordereffect(i)
                shr_mr(i,r,s)   share of each importer r in international imports
                shr_m(i,s)      share of international imports
                shr_musa(i,s)   share of domestic imports in US consumption
                shr_ms(i,ss,s)  share of each domestic importer in domestic imports
                eta_mr(i,r,s)   price elasticity of imports from r
                eta_m(i,s)      price elasticity of international import aggregate
                eta_musa(i,s)   CALIBRATED price elasticity of domestic import aggregate
;

*using AvW2003 estimate /2.24/
bordereffect(i) = 2.24;
bordereffect("TRN") = 1.5;
bordereffect("SRV") = 1.5;
bordereffect("ELE") = 1.5;


shr_mr(i,r,s)$sum(r.local,vxmd(i,r,s)) = vxmd(i,r,s) / sum(r.local,vxmd(i,r,s));
shr_m(i,s)$vam(i,s) = vim(i,s,"ftrd") / vam(i,s);
shr_musa(i,s)$(vim(i,s,"dtrd") + vdm(i,s)) = vim(i,s,"dtrd") /(vim(i,s,"dtrd") + vdm(i,s)) ;
shr_ms(i,ss,s)$sum(ss.local, vxmd(i,ss,s)) = vxmd(i,ss,s) /     sum(ss.local, vxmd(i,ss,s)) ;

eta_mr(i,r,s) = esubm(i) * (shr_mr(i,r,s) -1) + esubd(i)*(shr_mr(i,r,s)*shr_m(i,s) - shr_mr(i,r,s));

*eta_m(i,s)$shr_m(i,s) = esubd(i)*(shr_m(i,s) - 1);
*nov 2011 : fixed this
eta_m(i,s) = esubd(i)*(shr_m(i,s) - 1);

*eta_musa(i,s) = esubdusa(i) * (shr_musa(i,s)-1) + esubd(i) * ((1- shr_m(i,s))*shr_musa(i,s) -shr_musa(i,s));

* price elasticity of domestic import aggregate is a function of the price elasticity of international import aggregate
eta_musa(i,s) = eta_m(i,s)*bordereffect(i);

* use it to calibrate esubdusa :
*esubdusa(i,s)$(shr_musa(i,s) -1) = (eta_musa(i,s) - esubd(i)*(((1-shr_m(i,s))*shr_musa(i,s)) - shr_musa(i,s))) / (shr_musa(i,s)-1);
esubdusa(i,s)$(shr_musa(i,s) -1) = (eta_musa(i,s) + esubd(i)*shr_m(i,s)*shr_musa(i,s)) / (shr_musa(i,s)-1);


display shr_mr, shr_m, eta_mr, eta_m, eta_musa, esubm, esubd, esubdusa;

* QUICK FIX ON ASSIGNING POSITIVE VALUE SHARE FOR RESOURCE IN GAS PRODUCTION (FIX LATER SOMEWHEERE UP IN DATA BUILDSTREAM):
*	Assign new value share of gas resource gross of tax:
parameter vfm_gas;
vfm("res","gas",r) = 0.01*vom("gas",r);
rtf("res","gas",r) = rtf("cap","gas",r);
rtf0("res","gas",r) = rtf0("cap","gas",r);
vfm("cap","gas",r) = vfm("cap","gas",r) - vfm("res","gas",r);
vfmresh("gas",c,r) = vfmresh("gas",c,r) + vfm("res","gas",r);
vfms("cap",c,r) = vfms("cap",c,r) - vfm("res","gas",r);


* -- RESOURCE SUPPLY CALIBRATION
*       TREAT RESOURCES AS A SPECIFIC FACTOR:
*evom("res",rs) = 0;

parameter       etaen(g)        Elasticity of supply /
                        col     1
                        gas     1,
                        cru     0.5 /;

parameter       rvshare(f,rs,g) Resource value share;
rvshare("res",rs,en(i))$vom(i,rs) = vfm("res",i,rs)*(1+rtf0("res",i,rs))/vom(i,rs);
rvshare("cap",rs,en(i))$vom(i,rs) = vfm("cap",i,rs)*(1+rtf0("cap",i,rs))/vom(i,rs);
display rvshare;

*       Elasticity of substitution is calibrated to provide the
*       specified elasticity of supply:

parameter       esubfe(rs,g)    Elasticity of substitution in fossil energy;
esubfe(rs,g)$(1-rvshare("res",rs,g))  =
        rvshare("res",rs,g)/(1-rvshare("res",rs,g)) * etaen(g);
display esubfe;

*       Elasticity of substitution for cru, gas and col:

esub(xe,r) = esubfe(r,xe);
*esubm(i) = min(esubm(i),10);
*esubd(i) = min(esubd(i),esubm(i)/2);

parameter esube(g,rs) Elasticity of substitution between energy sources;

esube(c,rs) = 0.25;
esube(ene,rs) = 0;
esube(g,rs)$((not ene(g))$(not c(g))) = 1;


$include consistency_check

*       1 mtoe = 39652608749183 btu

efd(r,i) = evd(i,"c",r) * 39652608749183 / 1e15;
eind(r,i,j) = evd(j,i,r) * 39652608749183 / 1e15;

eimp(r,i,"ftrd") = sum(rr,evt(i,rr,r) * 39652608749183 / 1e15);
eexp(r,i,"ftrd") = sum(rr,evt(i,r,rr) * 39652608749183 / 1e15);

parameter eprod Energy production by region;

eprod(i,s) = stey0(s,i);
eprod(j,r) = sum(i, eind(r,i,j))+efd(r,j)+sum(trd,eexp(r,j,trd)+eimp(r,j,trd));

display efd,eind,eimp,eprod;

parameter euse  "Energy use (quad btu)";

euse(i,j,rs) = eind(rs,j,i);
euse(i,"c",r) = efd(r,i);
euse(i,c,s)$sum(c.local,vafm(i,c,s)) = vafm(i,c,s)/sum(c.local,vafm(i,c,s)) * efd(s,i);

*--------------------------------------------------------------------------
*       CO2 emissions coefficients:
*--------------------------------------------------------------------------

parameter
        EPSLON(*)   "Carbon dioxid emission coefficients for physical units (million metric tons / quadrillion btu)"
                    /col        93.98
                     gas        53.06
                     oil        66
                     cru        73.54/;

*       Use those coefficients to match US total emissions:

epslon("col") = 93.08;
epslon("gas") = 53.06;
epslon("oil") = 66;
epslon("cru") = 0;
epslon("crude") = 73.54;
*epslon("cru") = 73.54;

parameter epslonele;
epslonele(en) = epslon(en);
epslonele("cru") = epslon("crude");


*       WE FOLLOW BALLARD (2000) TO CALIBRATE COMPENSATED AND UNCOMPENSATED LABOR SUPPLY ELASTICITIES:

*       (NB: Given estimates for the uncompensated and compensated supply elasticities, we calibrate the value
*       of leisure in the benchmark, and the EOS bw consumption and leisure.)

parameter
        elas_uncomp     Uncompensated labor supply elasticity /0.05/
        elas_comp       Compensated labor supply elasticity /0.3/
        diff_elas       Difference bw compensated and uncompensated elasticity
        sigma_leiscons  Calibrated elasticity of substitution bw leisure and consumption in utility function
;

diff_elas = elas_comp - elas_uncomp;

parameter
        b_leis  Benchmark value of leisure
;

b_leis(g,rs) = diff_elas / (1-diff_elas) * (vom(g,rs)+vinvs(g,rs));

*       Calibrate EOS bw leisure and other consumption in utility function:

sigma_leiscons(g,rs)$b_leis(g,rs) = elas_comp / (1-diff_elas) * vfms("lab",g,rs) / b_leis(g,rs);



$include ..\data\UScensus_popdata.gms


parameter
        govbudg0;

govbudg0(pb,rs) = vom(pb,rs);

parameter modelstatus;

set     ff(i)           "Extracted fossil fuels"                /cru,gas,col/;


parameter depper(ff);
depper(ff) = 2;


*       Some capital formation definitions:

parameter
        housav(rs,t)             Household saving
        newcap(rs,t)             New capital
        oldcap(rs,i,t)           Old capital
        oldcapg(rs,t)            Old capital employed by government
        totalcap(rs,t)           Total capital;



parameter vafm0,vfmsnh0,vom0, vfms0;

vafm0(i,g,rs) = vafm(i,g,rs);

vfmsnh0(nh,c,rs) = vfmsnh(nh,c,rs);

vom0(g,rs) = vom(g,rs);

vfms0(mf,c,rs) = vfms(mf,c,rs);

parameter r_kap,r_nhkap,r_labor;

parameter resdepl  "Cumulative depletion of fossil fuel up to t";


$ontext
* This is the value fo esubdusa that we calibrate using Justin's approach. The model has problems to solve with such high values.
----   4841 PARAMETER esubdusa  Elasticity of substitution between local and other State imports (only valid for US states)

             AK          CA          FL          NY          TX        NENG        SEAS        NEAS        SCEN        NCEN

COL      32.020                                                                  73.187                             114.623
OIL                                     1.67849E+17      21.587                  29.839      32.988      36.739
ELE      29.400                              28.550                  26.956                                          29.025
GAS                                                      29.163                                          29.345      41.459
MAN      24.512      31.720      44.627      29.069      30.654      38.579      37.013      40.502      40.921      46.180
SRV      27.309      20.795      20.995      21.065      21.728      21.809      22.397      21.897      24.448      22.712
TRN      21.893      19.628      24.925      23.078                  24.769      19.827      20.290                  21.264
AGR     108.844      29.096      44.943      43.367      34.514      49.872      34.794      34.665      37.181      31.315
EIS      26.558      30.391      36.524      33.288      35.261      34.548      33.808      30.438      34.991      37.202

  +        MOUN        PACI

COL      64.272
ELE      28.848
MAN      45.295      36.888
SRV      22.361      22.146
TRN      22.736      22.161
AGR      39.497      32.885
EIS      37.959      35.557
$offtext
*       We arbitrarily lower the calibrated elasticities:
*esubdusa(i,rs) = .5*esubdusa(i,rs);
esubdusa(i,s)$(esubdusa(i,s) > 100) = 100;
*esubdusa"gas",rs) = 5;

* Elasticity of substitution of imports  from between US states
*	if a US region is the importer
esubmusa(i,s) = 2*esubdusa(i,s);
*	if a international region is the importer
esubmusa(i,r) = 2*esubm(i);

parameter ele_eff2004;

ele_eff2004(rs)$(sum(i, euse(i,"ele",rs)))
                        = eprod("ele",rs)/(sum(i, euse(i,"ele",rs)));


parameter       bmkco2  CO2 emissions at benchmark
                refco2  CO2 emissions at benchmark,
                co2lim  Exogenous CO2 limit;

* for GTAP regions :
bmkco2(fe,g,r)$vafm(fe,g,r) = eco2(fe,g,r);
*bmkco2(fe,g,r)$vafm(fe,g,r) = euse(fe,g,r)*epslon(fe);
*       include crude oil:
*bmkco2("cru",g,rs)$vafm("cru",g,r) = eco2("cru",g,r);

* for US states :
bmkco2(fe,g,s) = euse(fe,g,s)*epslon(fe);

* this includes crude ..
*bmkco2(i,"ele",rs) = euse(i,"ele",rs)*epslonele(i);

*refco2(rs) = sum((i,g)$(not sameas("ele",g)) ,euse(i,g,rs)*epslon(i)) + sum(i ,euse(i,"ele",rs)*epslonele(i));
refco2(rs) = sum((fe,g)$vafm(fe,g,rs),bmkco2(fe,g,rs))
*+ bmkco2("cru","ele",rs)
;

co2lim(rs) = 0;
refco2("us") = sum(s, refco2(s));

display refco2;


* Policy flags:

parameter
        rn_lst  Flag for revenue neutrality
        ctradet Flag for CAT policy
        carbrevft
        ctrade
        seccarb  Flag to include sector under the carbon policy
        bca      Flag for border adjustment
;

seccarb(g,i,rs) = no;
bca(g,rs,rsrs) = no;

parameter
        carbrevf        Flag for receiving carbon revenue by US regions
        carbrevshare    Share for allocation carbon revenue across US regions
        rn_ls(rs)       Flag for revenue neutrality of government budget
        lshare          Share to determine lumpsum tax to maintain government revenue neutrality;

set cc(rs);
cc(rs) = no;
rn_ls(rs) = no;
carbrevf = 0;

ctrade(rs) = no;

rn_lst(rs,t) = no;
ctradet(rs,t) = no;
carbrevft(t) = no;

carbrevshare(c,rs) = 0;
lshare(g,rs) = 0;

parameter
        emisreduc(rs,t) Emissions reductions as a fraction of BAU emissions;

emisreduc(rs,t) = 0;

parameter wchange,wchange_us,wchange_tot, pnum;

parameter Pnet price net of carbon permit;


parameter pctPcarb percent of price which is not pcarb;



set ccint(rs), nccint(rs), ncc(rs), regions(*), i_(*) ;
set bilatelem, byregsectelem, scns;


* define reporting parameters here :

set limit;

parameter byreg, bysect, byregsect, bilat, macro;

* 1000 works well
parameter carbscale carbon rescaling /1000 /;
* have to rescale co2 because the solver has solving problems : use your  economic intuition to pick a random number
* until your favourite version of GAMS decides it can handle it

parameter pcarbb        "Normalization for carbon price";
pcarbb = 1e-6 * carbscale;

* rescaling emissions
bmkco2(i,g,rs) = bmkco2(i,g,rs)
 /carbscale
;
refco2(rs) = refco2(rs)
/carbscale
;

epslon(i) = epslon(i)/carbscale;


* for indirect co2 int calculation

parameter       adjvdfm adjusted intermediate demand (includes intra-regional exports),
                adjvxmd adjusted exports (without intra-regional flows),
                vdfmtransposed ,
                Amatrix A matrix expressed as proportion of production,
                IA I-A matrix,
                IAinverse(i,j) temporary inverted I-A matrix,
                IAinverted(i,j,rs)  inverted matrix,
                fd final demand,
                Ex exports,
                output  sectoral output (x),
                co2emit         co2 emissions,
                co2intdir direct carbon intensity in kg per dollar,
                co2int indirect carbon intensity in kg per dollar;


set ids(rs) /moun,paci/
    oths(rs)
    nonca(rs);

oths(s) = yes$(not ids(s));
nonca(rs) = yes$(not sameas(rs,"ca"));


*	Elasticities for EPPA nesting structure:

parameter
	sigma_en(g,rs)  "EOS btw non-electric energy"
	sigma_enoe(g,rs) "EOS btw en and electricity"
	sigma_eva(g,rs)	"EOS btw energy/electricity and va" 
	sigma_va(g,rs)	"EOS btw capital and labor"
	sigma_klem(g,rs) "EOS btw KLE and M"
        sigma_cog       "EOS bw coal/oil and natural gas"
        sigma_co        "EOS bw coal and oil"
	sigma_ae(g,rs)  "EOS bw energy/electricity and materials in AGR"
	sigma_er(g,rs)	"EOS bw EM and land in AGR"
	sigma_erva(g,rs) "EOS bw EM/land and va in AGR"
	sigma_gr(g,rs)	"EOS bw KLM and resources for primary energy sectors"
	sigma_govinv(g,rs) "EOS bw materials and energy in government and investment demand" 
	sigma_ct(g,rs)   "EOS bw TRN and non-transport in private consumption"
	sigma_ec(g,rs)	"EOS bw energy and non-energy in private consumption"
	sigma_c(g,rs)  "EOS bw non-energy in private consumption"
	sigma_ef(g,rs) "EOS bw energy in private consumption"
;

*	N.B.: All values for elasticities are taken from EPPA4, JP Report 125.

sigma_ct(g,rs) = 1;
sigma_ec(g,rs) = .25;
sigma_c(g,rs) = .25;
sigma_ef(g,rs) = .4;

sigma_eva(g,rs)	= .5;
sigma_enoe(g,rs) = .5;
sigma_en(g,rs) = 1;

sigma_ae(g,rs) = 0.3;
sigma_er(g,rs) = 0.6;
sigma_erva(g,rs) = 0.7;

sigma_va(g,rs)= 1;
sigma_klem(g,rs) = 0;

sigma_cog(rs) = 1;
sigma_co(rs) = 0.3;

sigma_gr(g,rs) = esubfe(rs,g);

sigma_govinv(g,rs)$gov(g,rs) = 0.5; 
sigma_govinv(g,rs)$inv(g,rs) = 0; 


PARAMETER	nper;
nper = 24;


*	RULE OF THUMB ARMINGTON ELASTICITIES:
esubdusa(i,s) = 2*esubd(i);
esubmusa(i,s) = 4*esubd(i);

*	SPECIFY GENERIC BACKSTOP TECHNOLOGY:
parameter
	sigmabs(rs)	"EOS bw KL and fixed factor"
        vfmbs(*,rs)     "Backstop input value shares"
	bsendow(rs)	"Endowment of backstop fixed factor"
	mbs		"Markup on backstop"
	etabs		"Price elasticity for backstop supply";

mbs = 1.01;
*	Input shares add to unity:
vfmbs("res",s)$flagcaexp(s) = 0.1;
vfmbs("lab",s)$flagcaexp(s) = (1-vfmbs("res",s)) * 0.2;
vfmbs("cap",s)$flagcaexp(s) = (1-vfmbs("res",s)) * 0.8;

bsendow(s)$flagcaexp(s) = .1;




*	DEFINE SCENARIOS HERE:

set 
	cov_i_ca(g) "Sectors covered under CA CAT" /nmm,i_s,ppp,oil,crp,ele/
	cov_i_eu(g) "Sectors covered under EU-ETS" /nfm,nmm,i_s,ppp,oil,crp,ele/;
seccarb(i,fe,"ca")$(not sameas(fe,"col")) = yes; 
seccarb("c",fe,"ca")$(not sameas(fe,"col")) = yes; 
seccarb(cov_i_ca,fe,"ca") = yes; 
seccarb(cov_i_eu,fe,"eur") = yes; 

*	%2 argument: coa

$if "%coa%"=="BAU"  emisreduc(s,t) = 0;
$if "%coa%"=="BAU"  cc(rs) = no;
$if "%coa%"=="BAU"  cc(rs)$(sum(t, emisreduc(rs,t))) = yes;
$if "%coa%"=="BAU"  ctradet(rs,t)$emisreduc(rs,t) = yes;
$if "%coa%"=="BAU"  rn_lst(rs,t)$emisreduc(rs,t) = yes;
$if "%coa%"=="BAU"  lshare(h,rs)$sum(t,rn_lst(rs,t)) = 1;
$if "%coa%"=="BAU"  carbrevft(t) = 1;

$if "%coa%"=="CA"   emisreduc("CA",t) = 0.9;
$if "%coa%"=="CA"   emisreduc("EUR",t) = 0.8;
$if "%coa%"=="CA"   cc(rs) = no;
$if "%coa%"=="CA"   cc(rs)$(sum(t, emisreduc(rs,t))) = yes;
$if "%coa%"=="CA"   ctradet(rs,t)$emisreduc(rs,t) = yes;
$if "%coa%"=="CA"   rn_lst(rs,t)$emisreduc(rs,t) = yes;
$if "%coa%"=="CA"   lshare(h,rs)$sum(t,rn_lst(rs,t)) = 1;
$if "%coa%"=="CA"   carbrevft(t) = 1;

$if "%coa%"=="EU"   emisreduc("EUR",t) = 0.8;
$if "%coa%"=="EU"   cc(rs) = no;
$if "%coa%"=="EU"   cc(rs)$(sum(t, emisreduc(rs,t))) = yes;
$if "%coa%"=="EU"   ctradet(rs,t)$emisreduc(rs,t) = yes;
$if "%coa%"=="EU"   rn_lst(rs,t)$emisreduc(rs,t) = yes;
$if "%coa%"=="EU"   lshare(h,rs)$sum(t,rn_lst(rs,t)) = 1;
$if "%coa%"=="EU"   carbrevft(t) = 1;

$if "%coa%"=="trdNO"   emisreduc("CA",t) = 0.9;
$if "%coa%"=="trdNO"   emisreduc("EUR",t) = 0.8;
$if "%coa%"=="trdNO"   cc(rs) = no;
$if "%coa%"=="trdNO"   cc(rs)$(sum(t, emisreduc(rs,t))) = yes;
$if "%coa%"=="trdNO"   ctradet(rs,t)$emisreduc(rs,t) = no;
$if "%coa%"=="trdNO"   rn_lst(rs,t)$emisreduc(rs,t) = yes;
$if "%coa%"=="trdNO"   lshare(h,rs)$sum(t,rn_lst(rs,t)) = 1;
$if "%coa%"=="trdNO"   carbrevft(t) = 1;

$if "%coa%"=="trdYES"   emisreduc("CA",t) = 0.9;
$if "%coa%"=="trdYES"   emisreduc("EUR",t) = 0.8;
$if "%coa%"=="trdYES"   cc(rs) = no;
$if "%coa%"=="trdYES"   cc(rs)$(sum(t, emisreduc(rs,t))) = yes;
$if "%coa%"=="trdYES"   ctradet(rs,t)$emisreduc(rs,t) = yes;
$if "%coa%"=="trdYES"   rn_lst(rs,t)$emisreduc(rs,t) = yes;
$if "%coa%"=="trdYES"   lshare(h,rs)$sum(t,rn_lst(rs,t)) = 1;
$if "%coa%"=="trdYES"   carbrevft(t) = 1;

*	%3 argument: electricity tariff for CA
$if "%et%"=="etYES"   bca(elee,"moun","ca") = 1; 
$if "%et%"=="etYES"   bca(elee,"paci","ca") = 1; 
$if "%et%"=="etYES"   bca(elee,"can","ca") = 1; 
$if "%et%"=="etYES"   bca(elee,"nv","ca") = 1; 
$if "%et%"=="etYES"   bca(elee,"az","ca") = 1; 
$if "%et%"=="etYES"   bca(elee,"ut","ca") = 1; 


*	%4 argument: vintaging
SET PCGOODS(i) / EIS, MAN, TRN, AGR, ELE, CRP,NMM, I_s,NFM, ppp/;
*$if "%et%"=="vYES" VINTG(PCGOODS,rs) = yes;
*$if "%et%"=="vNO" VINTG(PCGOODS,rs) = no;
*	%4 argument: change EOS for renewable backstop
$if "%ren%"=="renL" etabs = 2.7;
$if "%ren%"=="renH" etabs = 10;
sigmabs(s)$flagcaexp(s) = etabs * vfmbs("res",s)/(1-vfmbs("res",s));

*	Treat existing hydro as including renewables, and calculate a pric supply elasticity
*	that is a weigted average of hydro elasticity (=0.5) and elasticity for 
*	for renewable electricity supply (LOW and HIGH).
heta("ca")=0.52*0.5+0.48*etabs;
heta("az")=0.99*0.5+0.01*etabs;
heta("nv")=0.4*0.5+0.6*etabs;
heta("ut")=0.22*0.5+0.78*etabs;
heta("paci")=0.04*0.5+0.96*etabs;

sharenh(nh,rs)$vomnh(nh,rs) = vfmnh("res",nh,rs)/vomnh(nh,rs);
sigmanh("nuc",rs)$(1-sharenh("nuc",rs))= neta(rs)*sharenh("nuc",rs)/(1-sharenh("nuc",rs));
sigmanh("hyd",rs)$(1-sharenh("hyd",rs))= heta(rs)*sharenh("hyd",rs)/(1-sharenh("hyd",rs));
*	Assume that nuclear cannot expand in the US:
sigmanh("nuc",s) = 0;


*	%5 argument: border effect
$if "%b%"=="bLOW" esubdusa(i,s) = esubd(i);
$if "%b%"=="bHO" esubdusa(i,s) = 4*esubd(i);

*	%6 argument: esubmusa (=EOS between US states imports)
$if "%em%"=="emLOW" esubmusa(i,s) = 2*esubd(i);
$if "%em%"=="emHO" esubmusa(i,s) = 8*esubd(i);

*	%7 argument: blocking the trade channel
parameter tfix(i) flag for fixing trade flows to bmk;
tfix(i) = no;
$if "%t%"=="tOFF" tfix(i) = yes;
$if "%t%"=="tOFF" tfix("gas") = no;
$if "%t%"=="tOFF" tfix("col") = no;
$if "%t%"=="tOFF" tfix("cru") = no;
*  Allow trade in AGR and SRV to adjust (if we block all, model is infeasible)
*$if "%t%"=="tOFF" tfix("agr") = no;
*$if "%t%"=="tOFF" tfix("srv") = no;
$if "%t%"=="tOFF" esubm(i)$tfix(i) = 0;
$if "%t%"=="tOFF" esubmusa(i,rs)$tfix(i) = 0;

*	%8 argument: blocking the capital channel
*		turn off cap mob: 
$if "%k%"=="kOFF" mk("cap",s)= no;

*	%9 argument: blocking the fossil fuel price channel
parameter ffix(i,rs) flag for fixing fossil fuel prices;
ffix(i,rs) = no;
$if "%f%"=="fOFF" ffix("gas",rs) = yes;
$if "%f%"=="fOFF" ffix("col",rs) = yes;
$if "%f%"=="fOFF" ffix("cru",rs) = yes;

