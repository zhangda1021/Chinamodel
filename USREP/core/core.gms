$TITLE  GTAP-US-E MODEL

parameter id_neg;
id_neg(c,r) = vfms("cap",c,r)$(vfms("cap",c,r) lt 0);
id_neg("vfm",r) = vfm("cap","gas",r)$(vfm("cap","gas",r) lt 0);
display id_neg;


parameter co2intele;
co2intele(rs) =  sum(fe,bmkco2(fe,"ele",rs)) / vom("ele",rs);
display co2intele;

$ontext
set cc(rs)      Carbon constrained regions;

alias (cc,ccc);

cc(rs) = no;

cc("ca") = yes;
*cc(s) = yes;
*cc("eur") = yes;
*cc(s) = yes;
                                    

co2lim(cc) = 0.7 * refco2(cc);
rn_ls(cc) = 1;
lshare(h,cc)$rn_ls(cc) = 1;
carbrevf$(sum(s,co2lim(s))) = 1;
carbrevshare(h,s)$(sum(ss,sum(hh,uscensus_hhdata(ss,hh,"population")))$co2lim(s))
         = uscensus_hhdata(s,h,"population") / sum(s.local$co2lim(s),sum(hh,uscensus_hhdata(s,hh,"population")));
$offtext


$ontext
parameter       bmkco2  CO2 emissions at benchmark,
                co2lim  Exogenous CO2 limit;

bmkco2(rs) = sum((i,g)$(not sameas("ele",g)) ,euse(i,g,rs)*epslon(i)) + sum(i ,euse(i,"ele",rs)*epslonele(i));
co2lim(rs) = 0;
co2lim(cc) = 0.7*bmkco2(cc);
$offtext

$ontext
set
        ctrade(rs)      Countries involved in carbon trade;
ctrade(rs) = yes;

* introduce permit trading:
ctrade(cc) = yes;
ctrade(cc)$(card(ccc) le 1) = no;
ctrade(rs)$(not co2lim(rs)) = no;

$ontext
parameter
        carbrevf        Flag for receiving carbon revenue by US regions
        carbrevshare    Share for allocation carbon revenue across US regions
        rn_ls(rs)       Flag for revenue neutrality of government budget
        lshare          Share to determine lumpsum tax to maintain government revenue neutrality
;

*rn_ls(rs) = 1;

rn_ls(cc) = 1;

*       This is one for all hh now, but should be set up if we include more hh's:
*lshare(g,rs) = 1;
lshare(h,cc)$rn_ls(cc) = 1;

*       Turn on re-allocation of carbon revenue:
carbrevf = 0;
carbrevf$(sum(s,co2lim(s))) = 1;


*       Share out carbon revenue according population, i.e. on a per-capita basis:
carbrevshare(h,s)$(sum(ss,sum(hh,uscensus_hhdata(ss,hh,"population")))$co2lim(s))
         = uscensus_hhdata(s,h,"population") / sum(s.local$co2lim(s),sum(hh,uscensus_hhdata(s,hh,"population")));



parameter chk_carbrevshare;
chk_carbrevshare = sum(s$ctrade(s),sum(h,carbrevshare(h,s)));

display carbrevshare, chk_carbrevshare, ctrade, carbrevf, lshare, co2lim, bmkco2,vom;

display cons, h, gov, pb, g;
$offtext




$ontext
$model:gtap_us_e
$sectors:
        Y(g,rs)$(flag(g,rs) and yy(g,rs))               ! Supply
        YNH(nh,rs)$vomnh(nh,rs)                         ! Nuclear and hydro supply
        A(i,rs)$vam(i,rs)                               ! Armington composite supply
        M(i,rs)$vim(i,rs,"ftrd")                        ! Imports from international sources
        MUSA(i,rs)$vim(i,rs,"dtrd")                     ! Imports from US states
        YT(j)$vtw(j)                                    ! Transportation services
        FSUP(f,g,rs)$(cons(g,rs)$vfms(f,g,rs)$mf(f))    ! Factor supply by income class
        FSUPR(g,j,rs)$(cons(g,rs)$vfmresh(j,g,rs))      ! Factor supply of resource by income class
        W(g,rs)$cons(g,rs)                              ! Welfare index
        DV(i,v,rs)$sum(g,v_kh(i,g,v,rs))                ! Vintaged sectoral production
        KSUPV(i,g,v,rs)$(cons(g,rs)$v_kh(i,g,v,rs))     ! Vintaged capital supply
        CE(rs)$ctrade(rs)                               ! Carbon permit trading
        CEE(rs)$ctrade(rs)                              ! Carbon permit trading
	BS(rs)$flagcaexp(rs)				! Backstop technology for electricity

$commodities:
        P(g,rs)$(flag(g,rs) and pp(g,rs))               ! Domestic output price
        PA(i,rs)$vam(i,rs)                              ! Armington composite price
        PM(j,rs)$vim(j,rs,"ftrd")                       ! International import price
        PMUSA(i,rs)$vim(i,rs,"dtrd")                    ! Import price from US sources
        PT(j)$vtw(j)                                    ! Transportation services
        PF(f,rs)$(sum(c,vfms(f,c,rs))$(not mk(f,rs))$mf(f))     ! Primary factors rent
        PMK$(sum((f,rs),mk(f,rs)))                      ! Price for mobile capital across US regions
        PFS(f,g,rs)$(cons(g,rs)$vfms(f,g,rs)$mf(f))     ! Household-specific factor rents
        PTAX(rs)                                        ! Tax revenue market
        PCRU                                            ! World market crude oil price
        PS(f,g,rs)$(vfm(f,g,rs)$sf(f))                  ! Price for sector-specific resource (after applying personal income taxes)
        PSNH(nh,rs)$vomnh(nh,rs)                        ! Price for sector-specific resource (after applying personal income taxes)
        PR(j,g,rs)$(cons(g,rs)$vfmresh(j,g,rs))         ! Price for sector-specific resource by household (before personal income tax)
        PCARB(rs)$co2lim(rs)                            ! Shadow price of carbon
        PTCARB$card(ctrade)                             ! Traded carbon prices
        PW(g,rs)$cons(g,rs)                             ! Price of welfare
        PKSUPVS(i,g,v,rs)$(cons(g,rs)$v_kh(i,g,v,rs))   ! Vintaged capital supply
        PKSUPV(i,v,rs)$(sum(g$cons(g,rs),v_kh(i,g,v,rs)))       ! Vintaged capital supply
	PSB(rs)$(vfmbs("res",rs)$flagcaexp(rs))	! Price for backstop resource 

$consumers:
        RH(g,rs)$cons(g,rs)                             ! Representative household by income class
        GOVT(g,rs)$gov(g,rs)                            ! Government agent by institution
        taxrev(rs)                                      ! Tax revenue agent
        CARBAGENT$(sum(s,co2lim(s)))                    ! Agent that collect carbon revenue

$auxiliary:
        GOVBUDG(g,rs)$(rn_ls(rs)$gov(g,rs))             ! Revenue neutrality constraint
        LSGOVNH(g,rs)$(cons(g,rs)$rn_ls(rs))            ! Lump sum tax or subsidy to balance government budget

        CARBREV$carbrevf                                ! Carbon revenue
        CARBREVH(g,rs)$(carbrevf$cons(g,rs)$s(rs)$co2lim(rs))   ! Lump sum transfer due to allocation of carbon revenue

$auxiliary:
*        tauusa(i,rs)$tfix(i)$(state(rs))$(vim(i,rs,"dtrd"))                  ! Endogenous tax on US import aggregate
*        tauint(i,rs)$tfix(i)$(vim(i,rs,"ftrd"))                              ! Endogenous tax on international import aggregate
        ffadj(i,rs)$(ffix(i,rs)$(not sameas(i,"cru"))$vfm("res",i,rs))     
	crudeadj$(sum(rs,ffix("cru",rs)))


* SECTORAL PRODUCTION AND CONSUMPTION:
*       all sectors excluding AGR,ELE,primary energy sectors with resources,refined oil, private and public consumption,investment):
$prod:Y(g,rs)$((flag(g,rs) and oth(g,rs))$nsps(g))   m:sigma_klem(g,rs) kle(m):sigma_eva(g,rs) ele(kle):sigma_enoe(g,rs) ec(ele):sigma_en(g,rs) fe.tl(ec):0 va(kle):sigma_va(g,rs)
        o:P(g,rs)                       q:vom(g,rs)                             a:taxrev(rs)  t:rto(g,rs)
        i:PA(i,rs)                      q:vafm(i,g,rs)          i.tl:$fe(i) ec:$crud(i) ele:$elee(i) m:$(not ene(i))
        i:PCARB(rs)#(fe)$co2lim(rs)$seccarb(g,fe,rs)    q:bmkco2(fe,g,rs)       p:pcarbb fe.tl:
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf0(mf,g,rs))             va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))       q:vfm("cap",g,rs)       p:(1+rtf0("cap",g,rs))          va:    a:taxrev(rs) t:rtf("cap",g,rs)
        i:PS(sf,g,rs)                   q:vfm(sf,g,rs)          p:(1+rtf0(sf,g,rs))             va:    a:taxrev(rs) t:rtf(sf,g,rs)

*       AGR:
$prod:Y(g,rs)$((flag(g,rs) and oth(g,rs))$(not nsps(g))$agr(g)) s:sigma_erva(g,rs) lem:sigma_er(g,rs)  em(lem):sigma_ae(g,rs) m(em):0 ele(em):sigma_enoe(g,rs) ec(ele):sigma_en(g,rs) fe.tl(ec):0 va:esubkl(g,rs)
        o:P(g,rs)                       q:vom(g,rs)                             a:taxrev(rs)  t:rto(g,rs)
        i:PA(i,rs)                      q:vafm(i,g,rs)          i.tl:$fe(i) ec:$crud(i) ele:$elee(i) m:$(not ene(i))
        i:PCARB(rs)#(fe)$co2lim(rs)$seccarb(g,fe,rs)    q:bmkco2(fe,g,rs)       p:pcarbb fe.tl:
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf0(mf,g,rs))             va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))       q:vfm("cap",g,rs)       p:(1+rtf0("cap",g,rs))          va:    a:taxrev(rs) t:rtf("cap",g,rs)
        i:PS(sf,g,rs)                   q:vfm(sf,g,rs)          p:(1+rtf0(sf,g,rs))             lem:    a:taxrev(rs) t:rtf(sf,g,rs)

*       COL,CRU,GAS:
$prod:Y(g,rs)$((flag(g,rs) and oth(g,rs))$(not nsps(g))$res(g)) s:sigma_gr(g,rs) klm:0 fe.tl(klm):0 va(klm):sigma_va(g,rs)
        o:P(g,rs)                       q:vom(g,rs)                             a:taxrev(rs)  t:rto(g,rs)
        i:PA(i,rs)                      q:vafm(i,g,rs)          i.tl:$fe(i)  klm:$(not fe(i))
        i:PCARB(rs)#(fe)$co2lim(rs)$seccarb(g,fe,rs)    q:bmkco2(fe,g,rs)       p:pcarbb fe.tl:
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf0(mf,g,rs))             va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))       q:vfm("cap",g,rs)       p:(1+rtf0("cap",g,rs))          va:    a:taxrev(rs) t:rtf("cap",g,rs)
        i:PS(sf,g,rs)                   q:vfm(sf,g,rs)          p:(1+rtf0(sf,g,rs))                 a:taxrev(rs) t:rtf(sf,g,rs)

*       Refined OIL:
$prod:Y(g,rs)$((flag(g,rs) and oth(g,rs))$(not nsps(g))$roil(g))        m:sigma_klem(g,rs) kle(m):sigma_eva(g,rs) ele(kle):sigma_enoe(g,rs) ec(ele):sigma_en(g,rs) fe.tl(ec):0 va(kle):sigma_va(g,rs)
        o:P(g,rs)                       q:vom(g,rs)                             a:taxrev(rs)  t:rto(g,rs)
        i:PA(i,rs)                      q:vafm(i,g,rs)          i.tl:$fe(i) ele:$elee(i) m:$(not e(i))
        i:PCARB(rs)#(fe)$co2lim(rs)$seccarb(g,fe,rs)    q:bmkco2(fe,g,rs)       p:pcarbb fe.tl:
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf0(mf,g,rs))             va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))       q:vfm("cap",g,rs)       p:(1+rtf0("cap",g,rs))          va:    a:taxrev(rs) t:rtf("cap",g,rs)
        i:PS(sf,g,rs)                   q:vfm(sf,g,rs)          p:(1+rtf0(sf,g,rs))             va:    a:taxrev(rs) t:rtf(sf,g,rs)


*       INVESTMENT AND GOVERNMENT CONSUMPTION:
$prod:Y(g,rs)$(flag(g,rs)$(gov(g,rs) or inv(g,rs)))  s:sigma_govinv(g,rs) m:0 ele:sigma_enoe(g,rs) ec(ele):sigma_en(g,rs) fe.tl(ec):0
        o:P(g,rs)                       q:vom(g,rs)                             a:taxrev(rs)  t:rto(g,rs)
        i:PA(i,rs)                      q:vafm(i,g,rs)          i.tl:$fe(i) ec:$crud(i) ele:$elee(i) m:$(not ene(i))
        i:PCARB(rs)#(fe)$co2lim(rs)$seccarb(g,fe,rs)    q:bmkco2(fe,g,rs)       p:pcarbb fe.tl:


*       PRIVATE CONSUMPTION:
$prod:Y(g,rs)$(flag(g,rs)$cons(g,rs))   s:sigma_ct(g,rs) ntrn:sigma_ec(g,rs) m(ntrn):sigma_c(g,rs) e(ntrn):sigma_ef(g,rs) fe.tl(e):0
        o:P(g,rs)                       q:vom(g,rs)                             a:taxrev(rs)  t:rto(g,rs)
        i:PA(i,rs)                      q:vafm(i,g,rs)          i.tl:$fe(i)  m:$((not e(i))$(not trn(i))) e:$(e(i) and (not fe(i)))
        i:PCARB(rs)#(fe)$co2lim(rs)$seccarb(g,fe,rs)    q:bmkco2(fe,g,rs)       p:pcarbb fe.tl:


* VINTAGED PRODUCTION:
$prod:DV(i,v,rs)$sum(g,v_kh(i,g,v,rs)) s:0 en.tl:0
        o:P(i,rs)                       q:1                             a:taxrev(rs)  t:rto(i,rs)
        i:PA(j,rs)$(not ene(j))         q:v_de(rs,j,i,v)
        i:PA("ele",rs)                  q:v_de(rs,"ele",i,v)
        i:PA(en,rs)                     q:v_de(rs,en,i,v)               en.tl:
        i:PCARB(rs)#(en)$co2lim(rs)$seccarb(i,en,rs)    q:v_dcarb(rs,en,i,v)    p:pcarbb  en.tl:
        i:PF("lab",rs)$(not mk("lab",rs))       q:v_mf(rs,i,"lab",v)    p:(1+rtf0("lab",i,rs))              a:taxrev(rs) t:rtf("lab",i,rs)
        i:PKSUPV(i,v,rs)                q:v_mf(rs,i,"cap",v)    p:(1+rtf0("cap",i,rs))              a:taxrev(rs) t:rtf("cap",i,rs)
        i:PS(sf,i,rs)                   q:v_df(rs,i,sf,v)       p:(1+rtf0(sf,i,rs))                a:taxrev(rs) t:rtf(sf,i,rs)


* FOSSIL ELECTRICITY PRODUCTION:
$prod:Y(g,rs)$(flag(g,rs) and ele(g,rs)) s:0 kle:esub(g,rs)   e(kle):sigma_enoe(g,rs) va(kle):sigma_va(g,rs) cog(e):sigma_cog(rs) co(cog):sigma_co(rs) en.tl(co):0
        o:P(g,rs)                       q:vom(g,rs)                             a:taxrev(rs)  t:rto(g,rs)
        i:PA(i,rs)$(not ene(i))         q:vafm(i,g,rs)
        i:PA(en,rs)                     q:vafm(en,g,rs)                 en.tl:
        i:PCARB(rs)#(en)$co2lim(rs)$seccarb(g,en,rs)    q:bmkco2(en,g,rs)       p:pcarbb                en.tl:
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf0(mf,g,rs))     va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))       q:vfm("cap",g,rs)       p:(1+rtf0("cap",g,rs))  va:    a:taxrev(rs) t:rtf("cap",g,rs)
        i:PA("ele",rs)                  q:vafm("ele",g,rs)                                      e:


* NUCLEAR AND HYDRO ELECTRICITY:
$prod:YNH(nh,rs)$vomnh(nh,rs)  s:sigmanh(nh,rs)  a:0 va(a):1
        o:P("ele",rs)                   q:vomnh(nh,rs)          a:taxrev(rs)  t:rto("ele",rs)
        i:PA(i,rs)                      q:vdfmnh(i,nh,rs)               a:
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfmnh(mf,nh,rs)       p:(1+rtf0(mf,"ele",rs))         va:    a:taxrev(rs) t:rtf(mf,"ele",rs)
        i:PMK$(sum(mf,mk(mf,rs)))       q:vfmnh("cap",nh,rs)    p:(1+rtf0("cap","ele",rs))      va:    a:taxrev(rs) t:rtf("cap","ele",rs)
        i:PSNH(nh,rs)$vfmnh("res",nh,rs) q:vfmnh("res",nh,rs)   p:(1+rtf0("cap","ele",rs))             a:taxrev(rs) t:rtf("cap","ele",rs)

* GENERIC BACKSTOP FOR ELECTRICITY
$prod:BS(rs)$flagcaexp(rs)	s:sigmabs(rs)  va:1
        o:P("ele",rs)                   q:1     a:taxrev(rs)  t:rto("ele",rs)
        i:PF(mf,rs)$(not mk(mf,rs))     q:(mbs*vfmbs(mf,rs))    p:(1+rtf0(mf,"ele",rs))         va:    a:taxrev(rs) t:rtf(mf,"ele",rs)
        i:PMK$(sum(mf,mk(mf,rs)))       q:(mbs*vfmbs("cap",rs))    p:(1+rtf0("cap","ele",rs))   va:    a:taxrev(rs) t:rtf("cap","ele",rs)
        i:PSB(rs)$vfmbs("res",rs)       q:(mbs*vfmbs("res",rs))   p:(1+rtf0("cap","ele",rs))          a:taxrev(rs) t:rtf("cap","ele",rs)


* CRUDE OIL IS GLOBALLY TRADED:
$prod:Y(g,rs)$cru(g,rs) s:esub(g,rs) e:esube(g,rs) fe.tl(e):0 klm:0 m(klm):esubn(g,rs) va(klm):esubkl(g,rs)
        o:PCRU                          q:vcrus(g,rs)   a:taxrev(rs)  t:rtocru(g,rs)
        i:PA(i,rs)                      q:vafm(i,g,rs)  i.tl:$fe(i)  m:$(not e(i)) e:$(e(i) and (not fe(i)))
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf0(mf,g,rs))     va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))       q:vfm("cap",g,rs)       p:(1+rtf0("cap",g,rs))  va:    a:taxrev(rs) t:rtf("cap",g,rs)
        i:PS(sf,g,rs)                   q:vfm(sf,g,rs)          p:(1+rtf0(sf,g,rs))     va:    a:taxrev(rs) t:rtf(sf,g,rs)



* TRANSPORTATION MARGINS:
$prod:YT(j)$vtw(j)  s:1
        o:PT(j)         q:vtw(j)
        i:P(j,rs)       q:vst(j,rs)



* ARMINGTON AGGREGATE
$prod:A(i,rs)$vam(i,rs)  s:esubd(i)  usa:esubdusa(i,rs)
        o:PA(i,rs)      q:vam(i,rs)
        i:P(i,rs)       q:vdm(i,rs)                             usa:    p:(1+rtda0(i,rs))               a:taxrev(rs) t:rtda(i,rs)
        i:PMUSA(i,rs)   q:vim(i,rs,"dtrd")$state(rs)            usa:    p:(1+rtda0(i,rs))               a:taxrev(rs) t:rtda(i,rs) 
        i:PM(i,rs)      q:vim(i,rs,"ftrd")                              p:(1+rtia0(i,rs,"ftrd"))        a:taxrev(rs) t:rtia(i,rs,"ftrd")  
        i:PCRU          q:vcrud(i,rs)    p:(1+rtcru0(i,rs)) a:taxrev(rs) t:rtcru(i,rs)
        i:PT(j)         q:vtwrcru(j,i,rs) p:(1+rtcru0(i,rs)) a:taxrev(rs) t:rtcru(i,rs)


* FOREIGN IMPORTS
*       all sectors excluding electricity
$prod:M(i,rs)$(vim(i,rs,"ftrd")$(not elee(i)))  s:esubm(i)  r.tl:0
        o:PM(i,rs)      q:vim(i,rs,"ftrd")  
*+ a:taxrev(rs) n:tauint(i,rs)$tfix(i) 
        i:P(i,r)        q:vxmd(i,r,rs)  p:pvxmd(i,r,rs)   r.tl:         a:taxrev(r) t:(-rtxs(i,r,rs)) a:taxrev(rs) t:(rtms(i,r,rs)*(1-rtxs(i,r,rs)))
        i:PMUSA(i,rs)   q:vim(i,rs,"dtrd")$(not state(rs))
        i:PT(j)#(r)     q:vtwr(j,i,r,rs) p:pvtwr(i,r,rs)  r.tl:         a:taxrev(rs) t:rtms(i,r,rs)

*       electricity
$prod:M(i,rs)$(vim(i,rs,"ftrd")$elee(i))        s:esubm(i)  r.tl:0
        o:PM(i,rs)      q:vim(i,rs,"ftrd")  
*+ a:taxrev(rs) n:tauint(i,rs)$tfix(i)    
        i:P(i,r)        q:vxmd(i,r,rs)  p:pvxmd(i,r,rs)   r.tl:         a:taxrev(r) t:(-rtxs(i,r,rs)) a:taxrev(rs) t:(rtms(i,r,rs)*(1-rtxs(i,r,rs)))
* Specify border carbon adjustment for electricity imports to California from GTAP regions here:
        i:PCARB(rs)#(r)$co2lim(rs)$bca("ele",r,rs)      q:(co2intele(r)*vxmd("ele",r,rs))       p:pcarbb                r.tl:
        i:PMUSA(i,rs)   q:vim(i,rs,"dtrd")$(not state(rs))
        i:PT(j)#(r)     q:vtwr(j,i,r,rs) p:pvtwr(i,r,rs)  r.tl:         a:taxrev(rs) t:rtms(i,r,rs)


* US IMPORTS (BOTH FOR US STATES AND GTAP REGIONS)
*       all sectors excluding electricity
$prod:MUSA(i,rs)$(vim(i,rs,"dtrd")$(not elee(i))) s:esubmusa(i,rs) s.tl:0
        o:PMUSA(i,rs)   q:vim(i,rs,"dtrd") 
*+ a:taxrev(rs) n:tauusa(i,rs)$(tfix(i)$state(rs)) 
        i:P(i,s)        q:vxmd(i,s,rs)   p:pvxmd(i,s,rs)  a:taxrev(s) t:(-rtxs(i,s,rs)) a:taxrev(rs) t:(rtms(i,s,rs)*(1-rtxs(i,s,rs))) s.tl:
        i:PT(j)#(s)     q:vtwr(j,i,s,rs) p:pvtwr(i,s,rs)  a:taxrev(rs) t:rtms(i,s,rs) s.tl:

*       electricity
$prod:MUSA(i,rs)$(vim(i,rs,"dtrd")$elee(i)) s:esubmusa(i,rs) s.tl:0
        o:PMUSA(i,rs)   q:vim(i,rs,"dtrd") 
*+ a:taxrev(rs) n:tauusa(i,rs)$(tfix(i)$state(rs)) 
        i:P(i,s)        q:vxmd(i,s,rs)   p:pvxmd(i,s,rs)  a:taxrev(s) t:(-rtxs(i,s,rs)) a:taxrev(rs) t:(rtms(i,s,rs)*(1-rtxs(i,s,rs))) s.tl:
        i:PT(j)#(s)     q:vtwr(j,i,s,rs) p:pvtwr(i,s,rs)  a:taxrev(rs) t:rtms(i,s,rs) s.tl:
* Specify border carbon adjustment for electricity imports to California from US states here:
        i:PCARB(rs)#(s)$co2lim(rs)$bca("ele",s,rs)      q:(co2intele(s)*vxmd("ele",s,rs))       p:pcarbb                s.tl:




* FACTOR SUPPLY BY HH INCOME CLASS (NET OF PAYROLL AND PERSONAL INCOME TAXES):

*        mobile factors:
$prod:FSUP(f,c,rs)$(cons(c,rs)$vfms(f,c,rs)$mf(f))
        o:PF(f,rs)$(not mk(f,rs))       q:vfms(f,c,rs)  a:taxrev(rs) t:pitx(f,c,rs)
        o:PMK$mk(f,rs)                  q:vfms(f,c,rs)  a:taxrev(rs) t:pitx(f,c,rs)
        i:PFS(f,c,rs)                   q:vfms(f,c,rs)

*       resource factors:
$prod:FSUPR(c,j,rs)$(cons(c,rs)$vfmresh(j,c,rs))
        o:PS("res",j,rs)                q:vfmresh(j,c,rs) a:taxrev(rs) t:pitx("res",c,rs)
        i:PR(j,c,rs)                    q:vfmresh(j,c,rs)

*       vintaged capital:
$prod:KSUPV(i,c,v,rs)$v_kh(i,c,v,rs)
        o:PKSUPV(i,v,rs)        q:v_kh(i,c,v,rs)  a:taxrev(rs) t:pitx("cap",c,rs)
        i:PKSUPVS(i,c,v,rs)     q:v_kh(i,c,v,rs)


*       WELFARE INDEX:
$prod:W(g,rs)$cons(g,rs) s:sigma_leiscons(g,rs) a:0
        o:PW(g,rs)                      q:(vom(g,rs)+vinvs(g,rs)+b_leis(g,rs)*(1-pitx0("lab",g,rs)))
        i:P(g,rs)                       q:vom(g,rs)     a:
        i:P("i",rs)                     q:vinvs(g,rs)   a:
        i:PFS("lab",g,rs)               q:b_leis(g,rs)  p:(1-pitx0("lab",g,rs))


*       HOUSEHOLD INCOME BY INCOME CLASS:
$demand:RH(c,rs)$cons(c,rs)
        d:PW(c,rs)                      q:(vom(c,rs)+vinvs(c,rs)+b_leis(c,rs))
        e:PFS(mf,c,rs)                  q:(vfms(mf,c,rs)+b_leis(c,rs)$lab(mf))
        e:PKSUPVS(i,c,v,rs)             q:v_kh(i,c,v,rs)
        e:PSNH(nh,rs)$vfmnh("res",nh,rs) q:vfmsnh(nh,c,rs)
        e:PR(j,c,rs)$(not sameas(j,"cru"))              q:vfmresh(j,c,rs)  r:ffadj(j,rs)$ffix(j,rs) 
        e:PR("cru",c,rs)                    q:vfmresh("cru",c,rs)  r:crudeadj$(sum(rsrs,ffix("cru",rsrs))) 
	e:PSB(rs)$(vfmbs("res",rs)$flagcaexp(rs))		q:bsendow(rs)

       e:P("c",rnum)                   q:hhadj(c,rs)
* Lump-sum tax transfer to maintain government neutrality:
        e:P("c",rnum)$rn_ls(rs)         q:(-1)          r:LSGOVNH(c,rs)$cons(c,rs)
* For GTAP regions, carbon permits enter here:
        e:PCARB(rs)$(co2lim(rs)$r(rs))  q:co2lim(rs)
* US regions receive carbon revenue here:
        e:P("c",rnum)$carbrevf$cons(c,rs)$s(rs)         q:1             r:CARBREVH(c,rs)$(carbrevf$cons(c,rs)$s(rs)$co2lim(rs))


*       AGENT COLLECT CARBON REVENUE WHICH IS AVAILABLE FOR REVENUE RECYCLING:
$demand:CARBAGENT$(sum(s,co2lim(s)))
        d:P("c",rnum)
        e:PCARB(s)$co2lim(s)            q:co2lim(s)
        e:P("c",rnum)$carbrevf          q:(-1)          r:CARBREV

$constraint:CARBREV$carbrevf
        sum(rs$rnum(rs),P("c",rs) * CARBREV) =e=   sum(s$co2lim(s),PCARB(s) * co2lim(s));

$constraint:CARBREVH(g,rs)$(carbrevf$cons(g,rs)$s(rs)$co2lim(rs))
        CARBREVH(g,rs) =e= carbrevshare(g,rs) * CARBREV;



*       CARBON TRADING:
$prod:CE(rs)$ctrade(rs)
        o:PCARB(rs)$co2lim(rs)  q:1
        i:PTCARB                q:1

$prod:CEE(rs)$ctrade(rs)
        i:PCARB(rs)$co2lim(rs)  q:1
        o:PTCARB                q:1


*	FIXING TRADE:
*$constraint:tauint(i,rs)$(vim(i,rs,"ftrd")$tfix(i))
*	M(i,rs) - 1 =e= 0;

*$constraint:tauusa(i,rs)$(vim(i,rs,"dtrd")$tfix(i)$state(rs))
*	MUSA(i,rs) - 1 =e= 0;

*	FIXING FOSSIL FUEL PRICES:
$constraint:ffadj(i,rs)$(ffix(i,rs)$(not sameas(i,"cru"))$vfm("res",i,rs))
        P(i,rs) =e= sum(c,vom(c,rs)/sum(c.local,vom(c,rs))*PW(c,rs));
*sum(rsrs$rnum(rsrs),P("c",rsrs));

*	For CRUDE oil:
$constraint:crudeadj$(sum(rs,ffix("cru",rs)))
        PCRU =e= 1;
*sum(rsrs$rnum(rsrs),P("c",rsrs));


*       GOVERNMENT INCOME BY INSTITUTION:
$demand:GOVT(pb,rs)$gov(pb,rs)
        d:P(pb,rs)                      q:vom(pb,rs)
        e:P("c",rnum)                   q:(vb(pb,"ftrd",rs) +vb(pb,"dtrd",rs))
        e:P("c",rnum)                   q:govadj(pb,rs)
        e:ptax(rs)                      q:taxrevenue(pb,rs)
        e:P("c",rnum)$rn_ls(rs)         q:1             r:GOVBUDG(pb,rs)$rn_ls(rs)


*       TAX REVENUE AGENT:
$demand:taxrev(rs)
        d:ptax(rs)                      q:1

*       BUDGET NEUTRALITY for each government agent in each region:
$constraint:GOVBUDG(g,rs)$(rn_ls(rs)$gov(g,rs))
        GOVT(g,rs) =e= govbudg0(g,rs);

*       LUMP-SUM TAX to maintain budget neutrality:
$constraint:LSGOVNH(g,rs)$(cons(g,rs)$rn_ls(rs))
        LSGOVNH(g,rs) =e= lshare(g,rs) * sum(pb$gov(pb,rs),GOVBUDG(pb,rs));



$report:
  v:r_lab(rs,i)                                  i:PF("lab",rs)          prod:Y(i,rs)
  v:r_kapr(r,i)                                 i:PF("cap",r)          prod:Y(i,r)
  v:r_kaps(s,i)                                 i:PMK                    prod:Y(i,s)

  v:r_nhkapr(r,nh)$vomnh(nh,r)    i:PF("cap",r)                 prod:YNH(nh,r)
  v:r_nhkaps(s,nh)$vomnh(nh,s)   i:PMK                  prod:YNH(nh,s)

  v:vv_de(i,j,rs)$flag(i,rs)      i:PA(j,rs)   prod:Y(i,rs)

  v:vv_dcarb(fe,i,rs)$(co2lim(rs)$flag(i,rs)  and oth(i,rs))      i:PCARB(rs)#(fe)   prod:Y(i,rs)
  v:vv_dcarbele(en,i,rs)$(co2lim(rs)$flag(i,rs)  and ele(i,rs))      i:PCARB(rs)#(en)   prod:Y(i,rs)

  v:vv_mflab(i,rs)$(flag(i,rs)$(not mk("lab",rs)))      i:PF("lab",rs)   prod:Y(i,rs)
  v:vv_mfcap(i,rs)$(flag(i,rs)$(not mk("cap",rs)))      i:PF("cap",rs)   prod:Y(i,rs)
  v:vv_dk(i,rs)$(flag(i,rs)$mk("cap",rs))      i:PMK   prod:Y(i,rs)
  v:vv_df(i,j,rs)$flag(i,rs)      i:PS(j,i,rs)  prod:Y(i,rs)

  v:dv_out(i,v,rs)$sum(g,v_kh(i,g,v,rs))        o:p(i,rs)               prod:DV(i,v,rs)


  v:r_enbnele(rs,j,i)$flag(i,rs)                                i:pa(j,rs)      prod:y(i,rs)

  v:r_conshg(rs,i,g)$(flag(g,rs)$cons(g,rs))                               i:pa(i,rs)      prod:Y(g,rs)



  v:r_afgc(rs,i,g)                              i:pa(i,rs)      prod:y(g,rs)


* Foreign imports
  v:imports_f(i,r,rs)$vim(i,rs,"ftrd")  i:P(i,r)        prod:M(i,rs)
* US imports:
  v:imports_u(i,s,rs)$vim(i,rs,"dtrd")  i:P(i,s)        prod:MUSA(i,rs)

  v:r_consh(rs,g)$cons(g,rs)    i:P(g,rs)        prod:W(g,rs)
  v:r_leish(rs,g)$cons(g,rs)    i:PFS("lab",g,rs)        prod:W(g,rs)
  v:r_invh(rs,g)$cons(g,rs)    i:P("i",rs))      prod:W(g,rs)

  v:vafm_(i,g,rs)       i:PA(i,rs)      prod:Y(g,rs)
  v:ei_v(rs,j,i,v)$sum(g,v_kh(i,g,v,rs))                        i:pa(j,rs)      prod:dv(i,v,rs)



  v:imp_pcarb_u2(i,s,rs)$(vim(i,rs,"dtrd")$co2lim(rs)$bca(i,s,rs))      i:PCARB(rs)#(s)         prod:MUSA(i,rs)
  v:imp_pcarb_u(i,s,rs)$(vim(i,rs,"dtrd")$co2lim(rs)$bca(i,s,rs))       i:PCARB(rs)             prod:MUSA(i,rs)

  v:report_pt(j,i,s,rs)                 i:PT(j)#(s)     prod:MUSA(i,rs)

  v:r_bs(rs)$flagcaexp(rs)	o:P("ele",rs) prod:bs(rs)

$offtext
$sysinclude mpsgeset gtap_us_e

*       Initialize variables:

PCARB.L(rs)$co2lim(rs) = pcarbb;
PCARB.L(rs)$(not co2lim(rs)) = 0;


PFS.L(f,c,rs) = 1-pitx0(f,c,rs);
taxrev.l(rs) = sum(pb, taxrevenue(pb,rs));

GOVBUDG.l(pb,rs)$rn_ls(rs) = 1;
GOVBUDG.lo(pb,rs)$rn_ls(rs) = -inf;
LSGOVNH.lo(g,rs)$rn_ls(rs) = -inf;

*tauusa.lo(i,rs)$(tfix(i)$(state(rs))$(vim(i,rs,"dtrd"))) = -inf;           
*tauint.lo(i,rs)$(tfix(i)$(vim(i,rs,"ftrd"))) = -inf;                       

*tauusa.l(i,rs)$(tfix(i)$(state(rs))$(vim(i,rs,"dtrd"))) = 1;           
*tauint.l(i,rs)$(tfix(i)$(vim(i,rs,"ftrd"))) = 1;                       


ffadj.l(i,rs)$(ffix(i,rs)$(not sameas(i,"cru"))$vfm("res",i,rs)) = 1;
crudeadj.l$(sum(rs,ffix("cru",rs))) = 1;

*crudeadj.FX = 1;

*       Recalibrate the new vintage capital:
y.l(i,rs)$VINTG(i,rs) = 1 - CLAY_SHR(i,rs);
dv.l(i,V,rs)$VINTG(i,rs) = vom(i,rs) * CLAY_SHR(i,rs) * VINT_SHR(V,rs);

PKSUPVS.l(i,c,v,rs) = 1-pitx0("cap",c,rs);

*	Fix trade flows at benchmark:
M.fx(i,rs)$(vim(i,rs,"ftrd")$tfix(i)) = 1;
MUSA.fx(i,rs)$(vim(i,rs,"dtrd")$state(rs)$tfix(i)) = 1;

*       Replicate benchmark equilibrium:
gtap_us_e.iterlim = 100000;
gtap_us_e.workspace = 1000;
$include gtap_us_e.gen
option savepoint=1;
*.solve gtap_us_e using mcp;


$exit
parameter wchange,wchange_us,wchange_tot;
wchange(g,rs) = 100*(w.l(g,rs)-1);
wchange_us("1") = sum((c,s),  (vom(c,s)+vinvs(c,s)+b_leis(c,s))/(sum((c.local,s.local), vom(c,s)+vinvs(c,s)+b_leis(c,s))) * wchange(c,s));
wchange_us("2") = sum((h,s),  (uscensus_hhdata(s,h,"population"))/(sum((h.local,s.local), uscensus_hhdata(s,h,"population"))) * wchange(h,s));
wchange_tot = sum((c,rs),  (vom(c,rs)+vinvs(c,rs)+b_leis(c,rs))/(sum((c.local,rs.local), vom(c,rs)+vinvs(c,rs)+b_leis(c,rs))) * wchange(c,rs));

display wchange,wchange_us,wchange_tot,ptcarb.l,pcarb.l;
*,CARBAGENT.l,CARBREV.l,CARBREVH.l,GOVBUDG.l,LSGOVNH.l;
