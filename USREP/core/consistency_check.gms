$TITLE  INTRA-PERIOD CORE MODEL


* --------------------------------------------------------------------------
* CONSISTENCY CHECKS
* --------------------------------------------------------------------------


* --------- ZERO-PI CONDITIONS ------------


parameter mprofit2, Yprofit2, Yprofit3, FSUPprofit, YTprofit, Aprofit, MUSAprofit,  RHbalance, GOVTbalance  ;


* for GTAP regions:
mprofit2(i,rs,"ftrd") = vim(i,rs,"ftrd") - sum(rsrs, pvxmd(i,rsrs,rs)*vxmd(i,rsrs,rs)+sum(j, vtwr(j,i,rsrs,rs))*pvtwr(i,rsrs,rs));

* for US states:
mprofit2(i,s,"ftrd") = vim(i,s,"ftrd") - sum(r, pvxmd(i,r,s)*vxmd(i,r,s)+sum(j, vtwr(j,i,r,s))*pvtwr(i,r,s));
* dtrd includes flows from own region. there are neither tariffs nor trade flows
mprofit2(i,s,"dtrd") = vim(i,s,"dtrd") - sum(ss, vxmd(i,ss,s));
mprofit2(i,rs,trd) = round(mprofit2(i,rs,trd),5)+eps;
display mprofit2;

yprofit2(g,rs) = vom(g,rs)*(1-rto(g,rs))-sum(i, vdfm(i,g,rs)*(1+rtfd0(i,g,rs))
        + sum(trd, vifm(i,g,rs,trd)*(1+rtfi0(i,g,rs,trd)))) - sum(f, vfm(f,g,rs)*(1+rtf0(f,g,rs))) +EPS ;
display yprofit2;

* using Armington aggregate:
yprofit3(g,rs) = vom(g,rs)*(1-rto(g,rs))-sum(i, vafm(i,g,rs)) - sum(f, vfm(f,g,rs)*(1+rtf0(f,g,rs))) +EPS ;
display yprofit3;

balancecheck("sectors",i,s)$
         (
         sum(j, vdfm(j,i,s)) + sum((j,trd),vifm(j,i,s,trd)) + sum(f, vfm(f,i,s)*(1+rtf0(f,i,s))) )

                 =  (vom(i,s)*(1-rto0(i,s))) / (
         sum(j, vdfm(j,i,s)) + sum((j,trd),vifm(j,i,s,trd)) + sum(f, vfm(f,i,s)*(1+rtf0(f,i,s))) );


display balancecheck;
*ok here still
* used to hold : vdm + exp + vst = vom = vdfm +vifm +vfm +btax+ evpm


parameter donald, mickey;
donald(i,s) = sum((g,trd),vifm(i,g,s,trd)*(1+rtfi0(i,g,s,trd))) - vim(i,s,"dtrd")*(1+rtda0(i,s))
        -vim(i,s,"ftrd")* (1+rtia0(i,s,"ftrd"));
mickey(i,s) = sum((g), vdfm(i,g,s)*(1+rtfd0(i,g,s))) - vdm(i,s);

display donald, mickey;

* how would I write the FSUP condition?
FSUPprofit(f,rs) = sum(g,vfm(f,g,rs)) - sum(c, vfms(f,c,rs));
display FSUPprofit;

*for states
*Aprofit(i,s)$vam(i,s) = vam(i,s) - vdm(i,s)*(1+rtda0(i,s)) - vim(i,s,"dtrd")*(1+rtda0(i,s))
*       -vim(i,s,"ftrd")* (1+rtia0(i,s,"ftrd")) +eps;
Aprofit(i,s)$vam(i,s) = vam(i,s) - vdm(i,s) - vim(i,s,"dtrd")-vim(i,s,"ftrd") +eps;


*for gtap regions
Aprofit(i,r)$vam(i,r) = vam(i,r) - vdm(i,r)*(1+rtda0(i,r)) -vim(i,r,"ftrd")* (1+rtia0(i,r,"ftrd"));
aprofit("cru",rs) = vam("cru",rs) - vcrud("cru",rs)     *(1+rtcru0("cru",rs)) - sum(j, vtwrcru(j,"cru",rs) *(1+rtcru0("cru",rs)));
display Aprofit;


MUSAprofit(i,rs)  = vim(i,rs,"dtrd") -  sum(s,vxmd(i,s,rs)*pvxmd(i,s,rs)) - sum((j,s), vtwr(j,i,s,rs) *pvtwr(i,s,rs)) +eps ;
display MUSAprofit;

RHbalance(c,rs)$cons(c,rs) = vom(c,rs) + vinvs(c,rs) - sum(f, vfms(f,c,rs)*(1-pitx(f,c,rs))) - hhadj(c,rs)  +eps;
display cons, RHbalance;

GOVTbalance(pb,rs)$gov(pb,rs) = vom(pb,rs) - govadj(pb,rs) - taxrevenue(pb,rs) -sum((trd), vb(pb,trd,rs)) +eps ;

parameter gtapbalance;
gtapbalance(r) = vom("c",r) + vom("g",r) + vom("i",r) -sum((pb,trd), vb(pb,trd,r)) - sum((t,f), evom(f,r,"c",t)) -taxrevenue("g",r);
*gtapbalance(r) = sum((pb,trd), vb(pb,trd,r));


display gov, GOVTbalance, vom, govadj, taxrevenue, vb, pb, gtapbalance;

* this holds
*balancecheck("pub",pub,s) =
*       (govadj(pub,s) +taxrevenue(pub,s) +sum((g,trd), vb(g,trd,s)) )
*       / vom(pub,s);


* off, probably because of vb

YTprofit(j)$vtw(j)  = vtw(j) - sum(rs, vst(j,rs));
display YTprofit;
*ok

display taxrevenue, rtocru;

display state, vfm, vfms, pitx, vxmd, vim, rtda, rtia;



* for sluggissh factor transformation, just need to define total factor endowments:
parameter vfmstot;
vfmstot(f,rs) = sum(c,vfms(f,c,rs));


* --------- MARKET CLEARING CONDITIONS ------------
parameter mkt_pf;

mkt_pf(f,rs) = sum(c,vfms(f,c,rs)*(1-pitx(f,c,rs))) - sum(g,vfm(f,g,rs));

display mkt_pf,vfmstot,pitx,vfms,vfm,flag,vdm;
*display vcrud,rtf,pitx0,oth,flag,co2lim,rtf,rtf0,vafm,vfm,govadj;


