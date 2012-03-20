$title Report parameters 

r_kap(r,i) = r_kapr.l(r,i);
r_kap(s,i) = r_kaps.l(s,i);
r_nhkap(r,nh) = r_nhkapr.l(r,nh);
r_nhkap(s,nh) = r_nhkaps.l(s,nh);
r_labor(rs,i) = r_lab.l(rs,i);


aya(rs) =  sum(c,PFS.l("cap",c,rs)*vfms("cap",c,rs))
		+  sum(c,PFS.l("lab",c,rs)*vfms("lab",c,rs))
		+ sum(c,PSNH.l("nuc",rs)*vfmsnh("nuc",c,rs))
		+ sum(c,PSNH.l("hyd",rs)*vfmsnh("hyd",c,rs))
		+ sum((i,v,c)$vintg(i,rs), PKSUPVS.l(i,c,v,rs)*v_kh(i,c,v,rs))
*           + sum((vbt,v)$vintgbs(vbt,r), bv_k.l(vbt,v,r))
*           + sum((vbt,v)$vintgbs(vbt,r), bvm_k.l(vbt,v,r))
*           + (shale(r))$active("synf-oil",r)
           + sum((ff,c),PR.l(ff,c,rs)*vfmresh(ff,c,rs));

*	Government and tax revenue:
govinc(rs,pb) = govt.l(pb,rs);



*-----------------------------------------------------------------------------------
*	ENERGY STATISTICS

*	Energy production:
e_prd(rs,i) = eprod(i,rs)*y.l(i,rs);

e_prd(rs,"ele") = (eprod("ele",rs)*(1-sum(nh,shrnh(nh,"output",rs)))) * (y.l("ele",rs)*vom("ele",rs) + sum(v, dv_out.l("ele",v,rs)))
								  /vom("ele",rs);	

*	Energy demand by industrial sector by fuel (quad btu):
*en_neleinput(rs,enoe,i)$vafm(enoe,i,rs) = (r_enbnele.l(rs,enoe,i)+sum(v,ei_v.l(rs,enoe,i,v)))*euse(enoe,i,rs)/vafm(enoe,i,rs);

en_neleinput(rs,enoe,i)$vafm(enoe,i,rs) = (r_enbnele.l(rs,enoe,i)+sum(v,ei_v.l(rs,enoe,i,v)))*euse(enoe,i,rs)/vafm(enoe,i,rs);


en_eleinput(rs,i)$vafm("ele",i,rs) = (r_enbnele.l(rs,"ele",i)+sum(v,ei_v.l(rs,"ele",i,v)))*euse("ele",i,rs)/vafm("ele",i,rs);

*	Total sectoral energy demand (quad btu):
eeii(rs,i) = sum(enoe, en_neleinput(rs,enoe,i))+en_eleinput(rs,i);

*	Energy demand by household(quad btu):
eeci(rs,ener,c)$vafm(ener,c,rs)= r_afgc.l(rs,ener,c)*euse(ener,c,rs)/vafm(ener,c,rs);
eecii(rs,c) = sum(ener, eeci(rs,ener,c));

*	Compute the efficiency of fossil electricity:
ele_eff(rs)$(sum(enoe, en_neleinput(rs,enoe,"ele"))+en_eleinput(rs,"ele"))
			= e_prd(rs,"ele")/(sum(enoe, en_neleinput(rs,enoe,"ele"))+en_eleinput(rs,"ele"));
*	Update efficiency to convert renewables to primary energy equivalents:
*ele_pe(r,t)$(ord(t) eq 1) = ele_eff(r,t);
*ele_pe(r,t)$(ord(t) gt 1) = max(ele_eff(r,t),ele_pe(r,t-1));
*ele_eff(r,t) = ele_pe(r,t);



*-----------------------------------------------------------------------------------
*	PRICES

* how to calculate CPI ?
* Sebastian does :
cpi1 = sum(rs$rnum(rs),P.l("c",rs));

* Justin :
*cpi1 = sum((c,rs),P.L(c,rs)*vom(c,rs))/sum((c,rs),vom(c,rs));



report_prices1p(rs,"pinv") = P.l("i",rs)/cpi1;	
report_prices1p(rs,"pl") = PF.l("lab",rs)/cpi1;
report_prices1p(r,"pk") = PF.l("cap",r)/cpi1;
report_prices1p(s,"pk") = PMK.l/cpi1;

report_prices2p(rs,"p",i) = P.l(i,rs)/cpi1;
report_prices2p(rs,"pa",i) = PA.l(i,rs)/cpi1;
report_prices2p(rs,"pgov",pb) = P.l(pb,rs)/cpi1;
report_prices2p(rs,"pcons",c) = P.l(c,rs)/cpi1;
report_prices2p(rs,"pw",c) = PW.l(c,rs)/cpi1;

report_prices3p(rs,"pa_carb",fe,i)$(vafm(fe,i,rs)+euse(fe,i,rs)*epslon(fe)) = (PA.l(fe,rs)*vafm(fe,i,rs)/(vafm(fe,i,rs)+euse(fe,i,rs)*epslon(fe))
					+ PTCARB.l$ctrade(rs)*euse(fe,i,rs)*epslon(fe)/(vafm(fe,i,rs)+euse(fe,i,rs)*epslon(fe)))/cpi1;

report_pghg1(s,"ptcarb") = PTCARB.l$ctrade(s)/cpi1;


*-----------------------------------------------------------------------------------


*	Consumption:
aca(rs,c) = p.l(c,rs)*vom(c,rs)*y.l(c,rs)/cpi1;
aca_allh(rs) = sum(c,aca(rs,c));

*	Investment:

aia(rs) = p.l("i",rs)*vom("i",rs)*y.l("i",rs)/cpi1;

*       Government:
aga(rs,pb) = p.l(pb,rs)*vom(pb,rs)*y.l(pb,rs)/cpi1;

*	Aggregate net exports:

axa(r) = sum((i,rr),
	imports_f.l(i,r,rr)*P.l(i,r)*(1+(rtms(i,r,rr)*(1-rtxs(i,r,rr))))
	-imports_f.l(i,rr,r)*P.l(i,rr)*(1+(rtms(i,rr,r)*(1-rtxs(i,rr,r))))
	)
	+
	sum((i,s),
	imports_f.l(i,r,s)*P.l(i,r)*(1+(rtms(i,r,s)*(1-rtxs(i,r,s))))
	-imports_u.l(i,s,r)*P.l(i,s)*(1+(rtms(i,s,r)*(1-rtxs(i,s,r))))
	);


axa(s) = sum((i,rr),
	imports_u.l(i,s,rr)*P.l(i,s)*(1+(rtms(i,s,rr)*(1-rtxs(i,s,rr))))
	-imports_f.l(i,rr,s)*P.l(i,rr)*(1+(rtms(i,rr,s)*(1-rtxs(i,rr,s))))
	)
	+
	sum((i,ss),
	imports_u.l(i,s,ss)*P.l(i,s)*(1+(rtms(i,s,ss)*(1-rtxs(i,s,ss))))
	-imports_u.l(i,ss,s)*P.l(i,ss)*(1+(rtms(i,ss,s)*(1-rtxs(i,ss,s))))
	);
  	
axa(rs) = axa(rs) / cpi1;

*       GNP accounting:
agnp(rs) = sum(c,aca(rs,c)) + aia(rs) + sum(pb,aga(rs,pb))+ axa(rs);

*----------------------------------------------------------------------------------- 
*	CONVERT ENERGY OUTPUT INTO HEAT UNITS AND TO CO2 EMISSIONS (CHAIN RULE):

*	Energy consumption (quad btu):

ee(rs,ener) = sum(i$vafm(ener,i,rs),(r_enbnele.l(rs,ener,i)+sum(v,ei_v.l(rs,ener,i,v)))*euse(ener,i,rs)/vafm(ener,i,rs))
		+sum(c$vafm(ener,c,rs),r_afgc.l(rs,ener,c)*euse(ener,c,rs)/vafm(ener,c,rs));



*sectco2(ener,i,rs)$(not sameas(ener, "ele")) = epslon(ener)*(r_enbnele.l(rs,ener,i)+sum(v,ei_v.l(rs,ener,i,v)))*euse(ener,i,rs)/vafm(ener,i,rs);
*sectco2(ener, "ele")) = epslon(ener)*(r_enbnele.l(rs,ener,i)+sum(v,ei_v.l(rs,ener,i,v)))*euse(ener,i,rs)/vafm(ener,i,rs);

		

*+sum(c$vafm(ener,c,rs),r_afgc.l(rs,ener,c)*euse(ener,c,rs)/vafm(ener,c,rs));


*NB: Fix this for dynamic model to correctly account for CRU emissions in electricity for GTAP regions. 

*	CO2 emissions --- EXCLUDING emissions from backstops:
co2f(rs,ener) = epslon(ener)* ee(rs,ener) ;


totco2(rs) = sum(ener,co2f(rs,ener));

*	Sectoral CO2 emissions (million metric tons):
ceei(rs,ener,i)$vafm(ener,i,rs) = (r_enbnele.l(rs,ener,i)+sum(v,ei_v.l(rs,ener,i,v)))*euse(ener,i,rs)/vafm(ener,i,rs);

*	CO2 from private consumption (million metric tons):
ceeci(rs,ener) = sum(c$vafm(ener,c,rs),r_afgc.l(rs,ener,c)*euse(ener,c,rs)/vafm(ener,c,rs));

*	Total sectoral CO2 emissions (million metric tons):
sectem(rs,i) = sum(ener, epslon(ener)*ceei(rs,ener,i));

*	Total emissions from private consumption (million metric tons):
houem(rs) = sum(ener, epslon(ener)*ceeci(rs,ener)); 



*	Electricity generation by fossil fuel:
eleccoal(rs) = (e_prd(rs,"ele")* en_neleinput(rs,"col","ele")
		/(en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele"))
		)$((en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele")) gt 0);
elecgas(rs) = (e_prd(rs,"ele")*en_neleinput(rs,"gas","ele")
		/(en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele"))
		)$((en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele")) gt 0);
elecoil(rs) = (e_prd(rs,"ele")*en_neleinput(rs,"oil","ele")
		/(en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele"))
		)$((en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele")) gt 0);

*	Electricity generation from nuclear and hydro:
*ele_nh(rs,nh) = YNH.l(nh,rs)$vomnh(nh,rs)*P.l("ele",rs)*vomnh(nh,rs)/vomnh(nh,rs) * shrnh(nh,"output",rs)*eprod("ele",rs);
ele_nh(rs,nh) = YNH.l(nh,rs)$vomnh(nh,rs) * shrnh(nh,"output",rs)*eprod("ele",rs);

*----------------------------------------------------------------------------------- 
*	Welfare:
welfare_indx(rs,c,"w") = w.l(c,rs);
welfare_indx(rs,c,"cons") = r_consh.l(rs,c);
welfare_indx(rs,c,"cons+leis") = r_consh.l(rs,c)+r_leish.l(rs,c);
welfare_indx(rs,c,"inv") = r_invh.l(rs,c);

hhinc_ref(rs,c) = rh.l(c,rs);

*	Report electricity generation by fuel:
elec_preg(rs,"coal") = eleccoal(rs)*1.055;
elec_preg(rs,"gas") = elecgas(rs)*1.055;
elec_preg(rs,"oil") = elecoil(rs)*1.055;
elec_preg(rs,"nuclear") = ele_nh(rs,"nuc")*1.055;
elec_preg(rs,"hydro") = ele_nh(rs,"hyd")*1.055;
elec_preg(s,"renewables")$flagcaexp(s) = r_bs.l(s) * sum(g,euse("ele",g,s)) / sum(g,vafm("ele",g,s));

*	Overwrite this for electricity exporters to CA (this is admittedly a quick and somewhat "dirty" calibration):

$ontext
elec_preg(s,"coal")$(flagcaexp(s)$elec_preg0("col",s)) = elec_preg(s,"coal")/elec_preg0("col",s) * eiaelegen("col",s);
elec_preg(s,"oil")$(flagcaexp(s)$elec_preg0("oil",s)) =elec_preg(s,"oil")/elec_preg0("oil",s) * eiaelegen("oil",s);
elec_preg(s,"gas")$(flagcaexp(s)$elec_preg0("gas",s)) =elec_preg(s,"gas")/elec_preg0("gas",s) * eiaelegen("gas",s);
elec_preg(s,"nuclear")$(flagcaexp(s)$elec_preg0("nuc",s)) = elec_preg(s,"nuclear")/elec_preg0("nuc",s) * eiaelegen("nuc",s);
elec_preg(s,"hydro")$(flagcaexp(s)$elec_preg0("hyd",s)) = elec_preg(s,"hydro")/elec_preg0("hyd",s) * eiaelegen("hyd",s);
elec_preg(s,"renewables")$flagcaexp(s) = r_bs.l(s) * sum(g,euse("ele",g,s)) / sum(g,vafm("ele",g,s));

*Fix for PACI region:
elec_preg("paci","oil") = y.l("ele","nv")/1.16051515194685 * eiaelegen("oil","paci");
elec_preg("paci","gas") = y.l("ele","nv")/1.16051515194685 * eiaelegen("gas","paci");
elec_preg("paci","coal") = y.l("ele","nv")/1.16051515194685 * eiaelegen("col","paci");
$offtext

$ontext
* EJ
elec_preg(rs,"coal") = eleccoal(rs)*1.055;
elec_preg(rs,"gas") = elecgas(rs)*1.055;
elec_preg(rs,"oil") = elecoil(rs)*1.055;
elec_preg(rs,"nuclear") = ele_nh(rs,"nuc")*1.055;
elec_preg(rs,"hydro") = ele_nh(rs,"hyd")*1.055;
$offtext
$ontext
elec_preg(r,"sol_wind",t) = BBWOUT("ele",r,t)*1.055;
elec_preg(r,"WINDBIO",t) = BBWBIOOUT("ele",R,T)*1.055;
elec_preg(r,"WINDGAS",t) = BBWGASOUT("ele",R,T)*1.055;
elec_preg(r,"bio",t) = BBBIOELEOUT("ele",r,t)*1.055;
elec_preg(r,"gas",t) = elecgas(r,t)*1.055;
elec_preg(r,"gas_ngcc",t) = bbngout("ele",r,t)*1.055;
elec_preg(r,"gas_ngcap",t) = bbncsout("ele",r,t)*1.055;
elec_preg(r,"coal_igcap",t) = bbicsout("ele",r,t)*1.055;
elec_preg(r,"nucl_new",t) = BBADVNUCL_BOUT("ELE",R,T)*1.055;
$offtext

*	Report primary energy use:
*	Regional enery use:

prim_ener(rs,e) = sum(i,en_neleinput(rs,e,i))+sum(c,eeci(rs,e,c))*1.055;
**	Refined oil demand excluding energy produced from biofuels (this is biofuels production. need to address trade issues!):
*prim_ener(r,"oil", t) = sum(g, en_neleinput(r,"oil",g,t)) +  sum(h,EECI(r,"oil",h,t)) - bbsoilout("oil", r, t) -bbbigasout("oil",r,t) + energy_htrn(r,t);
*prim_ener(r,"shale", t) = bbsoilout("cru", r, t);
prim_ener(rs,nh)$ele_eff2004(rs) = ele_nh(rs,nh)/ele_eff2004(rs)*1.055;
*prim_ener(r,"sol_wind", t)$ele_pe(r,t) = BBWOUT("ele",R,T)/ele_pe(r,t);
*prim_ener(r,"WINDBIO", t)$ele_pe(r,t) = BBWBIOOUT("ele",R,T)/ele_pe(r,t);
*prim_ener(r,"WINDGAS", t)$ele_pe(r,t) = BBWGASOUT("ele",R,T)/ele_pe(r,t);
*prim_ener(r,"bio-oil", t)$ele_pe(r,t) = BBBIOELEOUT("ele",R,T)/ele_pe(r,t) + bio_imq(r,t) + bio_dq(r,t);


*wchange(g,rs) = 100*(w.l(g,rs)-1);
wchange(g,rs)$windex(g,rs) = 100*(w.l(g,rs)/windex(g,rs)-1);

wchange_us("1") = sum((c,s),  (vom(c,s)+vinvs(c,s)+b_leis(c,s))/(sum((c.local,s.local), vom(c,s)+vinvs(c,s)+b_leis(c,s))) * wchange(c,s));
wchange_us("2") = sum((h,s),  (uscensus_hhdata(s,h,"population"))/(sum((h.local,s.local), uscensus_hhdata(s,h,"population"))) * wchange(h,s));
wchange_tot = sum((c,rs),  (vom(c,rs)+vinvs(c,rs)+b_leis(c,rs))/(sum((c.local,rs.local), vom(c,rs)+vinvs(c,rs)+b_leis(c,rs))) * wchange(c,rs));

* ---------------------------------------------------------------------------------------
* new reporting

* reminder : everything CO2 related must be re-multiplied by "carbscale"

bmkco2(i,g,rs) = bmkco2(i,g,rs) *carbscale;
refco2(rs) = refco2(rs) *carbscale;

* ------------ INDIRECT CARBON INTENSITY CALCULATION -------


*make A(to,from) matrix containing share of j going to i 
Amatrix(i,j,rs)$vom(j,rs) = vdfm(i,j,rs)/vom(j,rs);
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* FOR US, NOT TAKING IN ACCOUNT VIFM(DTRD) TO DO!!!

loop(rs,
* create (I-A) matrix which will be inverted
IA(i,i)$vom(i,rs) = (1-Amatrix(i,i,rs)); 
IA(i,j)$(vom(i,rs) and not sameas(i,j))= -Amatrix(i,j,rs);

* now invert this matrix:

execute_unload 'gdxforinverse.gdx' i,IA;
execute 'invert gdxforinverse.gdx i IA gdxfrominverse.gdx IAinverse';
execute_load 'gdxfrominverse.gdx' , IAinverse;
IAinverted(i,j,rs) = IAinverse(i,j);
);


co2intdir(i,rs)$vom(i,rs) = sum(fe,bmkco2(fe,i,rs)) /(vom(i,rs));


* calculate INDIRECT carbon intensity : including co2 to all intermediates (need to produce one unit of final demand or export)
* = e * (I-A)-1
co2int(j,rs) = sum(i, co2intdir(i,rs)*iainverted(i,j,rs));


*----------------------------------------------------

* some reporting sets

ncc(rs) = yes;
ncc(rs)$cc(rs) = no;
ccint(cc) =yes;
ccint(s) =no;
nccint(ncc) =yes;
nccint(s) =no;
regions(rs) = yes;
regions("us") = yes;
regions("cc") = yes;
regions("ncc") = yes;
regions("int") = yes;
regions("ccint") = yes;
regions("nccint") = yes;
i_(i) = yes;
i_("all") = yes;
i_("cru") = no;


*adjust vafm to add vintaged stuff :
vafm_.L(j,i,rs) =  vafm_.L(j,i,rs) + sum(v, ei_v.l(rs,j,i,v));	

pnum = cpi1;


byreg("Pcarb","scn",rs) = 1000/carbscale*Pcarb.L(rs)/pnum;

* this should include only one element :
byreg("wchange","scn",rs) = sum(c, wchange(c,rs));
byreg("wchange","scn","us1") = wchange_us("1");
byreg("wchange","scn","us2") = wchange_us("2");


byreg("emit","bmk",rs) = refco2(rs);
byreg("emit","bmk",rs)$byreg_("emit","scn",rs) = byreg_("emit","scn",rs);
byreg("emit","scn",rs) = sum((fe,g)$vafm(fe,g,rs),bmkco2(fe,g,rs) * vafm_.L(fe,g,rs)/vafm(fe,g,rs));
byreg("emit", "%chg",rs) = 100 * (byreg("emit","scn",rs) / byreg("emit","bmk",rs) -1);


byreg("emit","bmk","us") = sum(s, refco2(s));
byreg("emit","bmk","us") = sum(s, byreg("emit","bmk",s));
byreg("emit","scn","us") = sum(s, sum((fe,g)$vafm(fe,g,s),bmkco2(fe,g,s) * vafm_.L(fe,g,s)/vafm(fe,g,s)));
byreg("emit","%chg","us") = 100 * (byreg("emit","scn","us") / byreg("emit","bmk","us") -1);


* why are these not the same ?
*byreg("emit - test vafm_",rs) = sum((fe,g)$vafm(fe,g,rs), vafm_.L(fe,g,rs));
*byreg("emit - test vafm",rs) = sum((fe,g)$vafm(fe,g,rs), vafm(fe,g,rs));

*bilat("vafm diff",fe,g,rs) = vafm(fe,g,rs) - vafm_.L(fe,g,rs);

*byreg("emit",rs) = totco2(rs);

scns("bmk") = yes;
scns("scn") = yes;

byregsectelem("output") = yes;
byregsectelem("imports") = yes;
byregsectelem("exports") = yes;
byregsectelem("int imports") = yes;
byregsectelem("int exports") = yes;
byregsectelem("us imports") = yes;
byregsectelem("us exports") = yes;


byregsect("output","bmk",i,rs) = vom(i,rs);
byregsect("output","bmk",i,rs)$byregsect_("output","scn",i,rs) = byregsect_("output","scn",i,rs);
byregsect("output","scn",i,rs) = Y.L(i,rs) * vom(i,rs) + sum(v,dv_out.l(i,v,rs));
*byregsect("output","scn",i,rs) = Y.L(i,rs) * vom(i,rs);



* for electricity, need to add nuclear and hydro :
byregsect("output","bmk","ele",rs) = vom("ele",rs) + sum(nh, vomnh(nh,rs));
byregsect("output","bmk","ele",rs)$byregsect_("output","scn","ele",rs) = byregsect_("output","scn","ele",rs);
byregsect("output","scn","ele",rs) = Y.L("ele",rs) * vom("ele",rs) + sum(v, dv_out.l("ele",v,rs))+ sum(nh, YNH.L(nh,rs) * vomnh(nh,rs)); 
*byregsect("output","scn","ele",rs) = Y.L("ele",rs) * vom("ele",rs) +  sum(nh, YNH.L(nh,rs) * vomnh(nh,rs)); 


byregsect("imports","bmk",i,rs) = sum(rsrs, vxmd(i,rsrs,rs));
byregsect("imports","bmk",i,rs)$byregsect_("imports","scn",i,rs) = byregsect_("imports","scn",i,rs);
byregsect("exports","bmk",i,rs) = sum(rsrs, vxmd(i,rs,rsrs));
byregsect("exports","bmk",i,rs)$byregsect_("exports","scn",i,rs) = byregsect_("exports","scn",i,rs);

byregsect("imports","scn",i,rs) = sum(r, imports_f.L(i,r,rs)) + sum(s, imports_u.L(i,s,rs));
byregsect("exports","scn",i,r) = sum(rs, imports_f.L(i,r,rs));
byregsect("exports","scn",i,s) = sum(rs, imports_u.L(i,s,rs));


byregsect("int imports","bmk",i,rs) = sum(r, vxmd(i,r,rs));
byregsect("int imports","bmk",i,rs)$byregsect_("int imports","scn",i,rs) = byregsect_("int imports","scn",i,rs);
byregsect("int exports","bmk",i,rs) = sum(r, vxmd(i,rs,r));
byregsect("int exports","bmk",i,rs)$byregsect_("int exports","scn",i,rs) = byregsect_("int exports","scn",i,rs);

byregsect("int imports","scn",i,rs) = sum(r, imports_f.L(i,r,rs)) ;
byregsect("int exports","scn",i,r) = sum(rr, imports_f.L(i,r,rr)) ;
byregsect("int exports","scn",i,s) = sum(r, imports_u.L(i,s,r)) ;

*byregsect("int exports","scn",i,s) = sum(rs, imports_f.L(i,s,rs)) ;


byregsect("us imports","bmk",i,rs) = sum(s, vxmd(i,s,rs));
byregsect("us imports","bmk",i,rs)$byregsect_("us imports","scn",i,rs) = byregsect_("us imports","scn",i,rs);
byregsect("us exports","bmk",i,rs) = sum(s, vxmd(i,rs,s));
byregsect("us exports","bmk",i,rs)$byregsect_("us exports","scn",i,rs) = byregsect_("us exports","scn",i,rs);

byregsect("us imports","scn",i,rs) = sum(s, imports_u.L(i,s,rs)) ;
*byregsect("us exports","scn",i,r) = sum(rs, imports_u.L(i,r,s)) ;
byregsect("us exports","scn",i,r) = sum(s, imports_f.L(i,r,s)) ;
byregsect("us exports","scn",i,s) = sum(ss, imports_u.L(i,s,ss)) ;


*%chges :
byregsect(byregsectelem,"%chg",i,rs)$byregsect(byregsectelem,"bmk",i,rs) = 100*( byregsect(byregsectelem,"scn",i,rs) / byregsect(byregsectelem,"bmk",i,rs) -1); ;
byregsect(byregsectelem,"diff",i,rs)=  byregsect(byregsectelem,"scn",i,rs) - byregsect(byregsectelem,"bmk",i,rs) ; ;


byregsect("intl trade intensity","bmk", i,s)$(vom(i,s) +sum(r,vxmd(i,s,r))) = (sum(r,vxmd(i,r,s))+sum(r,vxmd(i,s,r)))/(vom(i,s)+sum(r,vxmd(i,r,s)));
byregsect("intl trade intensity","bmk", i,s)$byregsect_("intl trade intensity","scn", i,s) = byregsect_("intl trade intensity","scn", i,s);

byregsect("emit","bmk",g,rs) = sum((fe)$vafm(fe,g,rs), bmkco2(fe,g,rs) );
byregsect("emit","bmk",g,rs)$byregsect_("emit","scn",g,rs) = byregsect_("emit","scn",g,rs);
byregsect("emit","scn",g,rs) = sum((fe)$vafm(fe,g,rs), bmkco2(fe,g,rs) * vafm_.L(fe,g,rs)/vafm(fe,g,rs));


* competitiveness :
byregsect("competitiveness int","%chg",i,s)  = 100* (PM.L(i,s)/P.L(i,s) -1);
byregsect("competitiveness int","%chg",i,"all")  =  100* ( ( SUM(s, PM.L(i,s)* sum(r, vxmd(i,r,s))) / sum((s,r),vxmd(i,r,s)))
 	/ (sum(s, P.L(i,s)*vom(i,s)) / sum(s, vom(i,s))) -1);

byregsect("competitiveness dom","%chg",i,s)  = 100* (PMUSA.L(i,s)/P.L(i,s) -1);
byregsect("competitiveness dom","%chg",i,"all")  =  100* ( ( SUM(s, PMUSA.L(i,s)* sum(ss, vxmd(i,ss,s))) / sum((s,ss),vxmd(i,ss,s)))
			/ (sum(s, P.L(i,s)*vom(i,s)) / sum(s, vom(i,s))) -1);

* prices :
byregsect("PM","scn",i,rs)$vim(i,rs,"ftrd") = PM.L(i,rs)/pnum;
byregsect("P","scn",g,rs)$vom(g,rs) =  P.L(g,rs)/pnum;

* leakage rates:
*byreg("leakage","scn",rs)$(not cc(rs) and card(cc)) = 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
*		sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs));
* with EU in baseline:
byreg("leakage","scn",rs)$((not cc(rs) and card(cc))$(sum(cc(rsrs)
			$(not sameas(rsrs,"eur")), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs))))
		= 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
		sum(cc(rsrs)$(not sameas(rsrs,"eur")), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs));


* for EU alone:
byreg("leakage","scn",rs)$(not byreg_("emit","scn",rs) and (not cc(rs)))
		= 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
		sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs));


byreg("leakage","scn","all")$card(cc) = sum(rs,byreg("leakage","scn",rs));
byreg("leakage","scn","int")$card(cc) = sum(r,byreg("leakage","scn",r));
byreg("leakage","scn","us")$card(cc) = sum(s,byreg("leakage","scn",s));


*byreg("leakage_db","scn",rs)$(not cc(rs) and card(cc)) = 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
*		sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
*			- emisreduc("CA",t)*byreg("emit","bmk",rsrs)$(sameas(rsrs,"ca"))  );
* with EU in baseline:
byreg("leakage_db","scn",rs)$((not cc(rs) and card(cc))$(sum(cc(rsrs)$(not sameas(rsrs,"eur")), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
			- emisreduc("CA",t)*refco2(rsrs)$(sameas(rsrs,"ca")))) )

			= 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
		
			sum(cc(rsrs)$(not sameas(rsrs,"eur")), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
			- emisreduc("CA",t)*refco2(rsrs)$(sameas(rsrs,"ca"))  );

* for EU alone:
byreg("leakage_db","scn",rs)$((not byreg_("emit","scn",rs))$(not cc(rs) and card(cc))$(sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
			- emisreduc("CA",t)*byreg("emit","bmk",rsrs)$(sameas(rsrs,"ca")))) )

			= 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
		
			sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
			- emisreduc("CA",t)*refco2(rsrs)$(sameas(rsrs,"ca"))  );


byreg("leakage_db","scn","all")$card(cc) = sum(rs,byreg("leakage_db","scn",rs));
byreg("leakage_db","scn","int")$card(cc) = sum(r,byreg("leakage_db","scn",r));
byreg("leakage_db","scn","us")$card(cc) = sum(s,byreg("leakage_db","scn",s));


* TRADE FLOWS :

* IGNORE TRADE OF CRUDE OIL FOR NOW !
bilatelem("exports")=yes;
bilatelem("imports")=yes;
bilatelem("exports - embco2")=yes;
bilatelem("imports - embco2")=yes;


* to, from :
bilat("imports","bmk",i,rs,rsrs) = vxmd(i,rsrs,rs);
bilat("imports","bmk",i,rs,rsrs)$bilat_("imports","scn",i,rs,rsrs) = bilat_("imports","scn",i,rs,rsrs);
bilat("imports - embco2","bmk",i,rs,rsrs) = co2int(i,rsrs) * vxmd(i,rsrs,rs);

* exports : from, to:
bilat("exports","bmk",i,rs,rsrs) = vxmd(i,rs,rsrs);
bilat("exports","bmk",i,rs,rsrs)$bilat_("exports","scn",i,rs,rsrs) = bilat_("exports","scn",i,rs,rsrs);
bilat("exports - embco2","bmk",i,rs,rsrs) = co2int(i,rs) * vxmd(i,rs,rsrs);

* scenario :
* imports to, from :
bilat("imports","scn",i,rs,r) = imports_f.L(i,r,rs);
bilat("imports","scn",i,rs,s) = imports_u.L(i,s,rs);

bilat("imports - embco2","scn",i,rs,r) = co2int(i,r) * imports_f.L(i,r,rs) ;
bilat("imports - embco2","scn",i,rs,s) = co2int(i,s) * imports_u.L(i,s,rs) ;


* exports : from, to:
bilat("exports","scn",i,r,rs) = imports_f.L(i,r,rs) ;
bilat("exports","scn",i,s,rs) = imports_u.L(i,s,rs) ;

bilat("exports - embco2","scn",i,r,rs) = co2int(i,r) * imports_f.L(i,r,rs) ;
bilat("exports - embco2","scn",i,s,rs) = co2int(i,s) * imports_u.L(i,s,rs) ;


bilat(bilatelem,scns,i,rs,"US") = sum(s,bilat(bilatelem,scns,i,rs,s));
bilat(bilatelem,scns,i,rs,"CC") = sum(cc,bilat(bilatelem,scns,i,rs,cc));
bilat(bilatelem,scns,i,rs,"NCC") = sum(ncc,bilat(bilatelem,scns,i,rs,ncc));
bilat(bilatelem,scns,i,rs,"INT") = sum(r,bilat(bilatelem,scns,i,rs,r));
bilat(bilatelem,scns,i,rs,"CCINT") = sum(ccint,bilat(bilatelem,scns,i,rs,ccint));
bilat(bilatelem,scns,i,rs,"NCCINT") = sum(nccint,bilat(bilatelem,scns,i,rs,nccint));
bilat(bilatelem,scns,"all",rs,regions) = sum(i_, bilat(bilatelem,scns,i_,rs,regions));

* % changes
bilat(bilatelem,"%chg",i_,rs,regions)$bilat(bilatelem,"bmk",i_,rs,regions) = 100 * (bilat(bilatelem,"scn",i_,rs,regions) / bilat(bilatelem,"bmk",i_,rs,regions) - 1);

bilat(bilatelem,"diff",i_,rs,regions) =  bilat(bilatelem,"scn",i_,rs,regions) - bilat(bilatelem,"bmk",i_,rs,regions);


* TERMS OF TRADE 

*parameter Pnet price net of carbon permit;

pnet(g,rs)$vom(g,rs) = (P.L(g,rs)*vom(g,rs) -pcarb.L(rs) * sum(fe, bmkco2(fe,g,rs))) / vom(g,rs);

*parameter pctPcarb percent of price which is not pcarb;
pctPcarb(g,rs)$p.L(g,rs) = 100 * (pnet(g,rs) / p.L(g,rs));

display pnet, pctPcarb;

* BEWARE : DONT WANT TO CAPTURE CRUDE HERE !
* DONT UNDERSTAND WHY CRUDE IS COUNTED..

byregsect("tot - int","scn",i,s)$(not sameas("cru",i)) = sum(r, vxmd(i,s,r) * (P.L(i,s)/pnum-1)) - sum(r, vxmd(i,r,s) * (PM.L(i,s)/pnum-1));
byregsect("tot - int","scn","cru",s) =  (pcru.L/pnum-1) * sum(r,  vxmd("cru",s,r) -  vxmd("cru",r,s));  


byregsect("int (pnet)","scn",i,s)$(not sameas("cru",i)) = sum(r, vxmd(i,s,r) * (Pnet(i,s)/pnum-1)) - sum(r, vxmd(i,r,s) * (PM.L(i,s)/pnum-1));
* ADD CRUDE!

byregsect("tot - int - imports","scn",i,s)$(not sameas("cru",i)) = sum(r, vxmd(i,r,s) * (PM.L(i,s)/pnum-1));
byregsect("tot - int - imports","scn","cru",s) = (pcru.L/pnum-1) * sum(r, vxmd("cru",r,s));  

byregsect("tot - int - exports","scn",i,s)$(not sameas("cru",i)) = sum(r, vxmd(i,s,r) * (P.L(i,s)/pnum-1)) ;
byregsect("tot - int - exports","scn","cru",s) = (pcru.L/pnum-1) * sum(r, vxmd("cru",S,R));  

byregsect("tot - cc","scn",i,s)$(not sameas("cru",i))  = sum(cc, vxmd(i,s,cc) * (P.L(i,s)/pnum-1)) - sum(cc, vxmd(i,cc,s) * (PM.L(i,s)/pnum-1));
byregsect("tot - ncc","scn",i,s)$(not sameas("cru",i)) = sum(rsrs.local$ncc(rsrs), vxmd(i,s,rsrs) * (P.L(i,s)/pnum-1)) - sum(rsrs.local$ncc(rsrs), vxmd(i,rsrs,s) * (PM.L(i,s)/pnum-1));

byregsect("tot - dom","scn",i,s)$(not sameas("cru",i)) = sum(ss, vxmd(i,s,ss) * (P.L(i,s)/pnum-1)) - sum(ss, vxmd(i,ss,s) * (PMUSA.L(i,s)/pnum-1));
*tot("dom cc",i,s) = sum(cc, vxmd(i,s,cc) * (P.L(i,s)-1)) - sum(cc, vxmd(i,cc,s) * (PM.L(i,s)-1));
*tot("dom ncc",i,s) = sum(ncc, vxmd(i,s,ncc) * (P.L(i,s)-1)) - sum(ncc, vxmd(i,ncc,s) * (PM.L(i,s)-1));


byreg("tot - int",scns,s) = sum(i, byregsect("tot - int",scns,i,s));
byreg("tot - int - imports",scns,s) = sum(i, byregsect("tot - int - imports",scns,i,s));
byreg("tot - int - exports",scns,s) = sum(i, byregsect("tot - int - exports",scns,i,s));
     
     
byreg("tot - int (pnet)",scns,s) = sum(i, byregsect("tot - int (pnet)",scns,i,s));
     
     
byreg("tot - dom",scns,s) = sum(i, byregsect("tot - dom",scns,i,s));
byreg("tot - cc",scns,s) = sum(i, byregsect("tot - cc",scns,i,s));
byreg("tot - ncc",scns,s) = sum(i, byregsect("tot - ncc",scns,i,s));


$exit

parameter tradebystate;

bilat("bmk","imports",i,s,r) =  vxmd(i,r,s);
bilat("bmk","exports",i,s,r) =  vxmd(i,s,r);
bilat("bmk","imports","all",s,r) = sum(i, vxmd(i,r,s));
bilat("bmk","exports","all",s,r) = sum(i, vxmd(i,s,r));
bilat("bmk","imports",i,s,"CC") = sum(ccint, vxmd(i,ccint,s));
bilat("bmk","exports",i,s,"CC") = sum(ccint, vxmd(i,s,ccint));
bilat("bmk","imports",i,s,"NCC") = sum(nccint, vxmd(i,nccint,s));
bilat("bmk","exports",i,s,"NCC") = sum(nccint, vxmd(i,s,nccint));
bilat("bmk","imports",i,s,"DOM") = sum(ss, vxmd(i,ss,s));
bilat("bmk","exports",i,s,"DOM") = sum(ss, vxmd(i,s,ss));

parameter donaldduck;
donaldduck(i,r,rsrs) = trade_.L(i,r,rsrs);



bilat("scn","imports",i,s,r)  = trade_.L(i,r,s);	  
bilat("scn","exports",i,s,r)  = tradeUSA_.L(i,s,r);
bilat("scn","imports","all",s,r) = sum(i, trade_.L(i,r,s));	  
bilat("scn","exports","all",s,r) = sum(i, tradeUSA_.L(i,s,r));
*bilat("scn","imports",i,s,"CC") = sum(r$cc(r), trade_.L(i,r,s));
bilat("scn","imports",i,s,"CC") = sum(ccint, donaldduck(i,ccint,s));
bilat("scn","exports",i,s,"CC") = sum(r$ccint(r), tradeUSA_.L(i,s,r));
*bilat("scn","imports",i,s,"NCC") = sum(r$ncc(r), trade_.L(i,r,s));
bilat("scn","imports",i,s,"NCC") = sum(nccint, donaldduck(i,nccint,s));
bilat("scn","exports",i,s,"NCC") = sum(r$nccint(r), tradeUSA_.L(i,s,r));
bilat("scn","imports",i,s,"DOM") = sum(ss, tradeUSA_.L(i,ss,s));
bilat("scn","exports",i,s,"DOM") = sum(ss, tradeUSA_.L(i,s,ss));


bilat("scn%","imports",i,s,r)$bilat("bmk","imports",i,s,r) = 100*(bilat("scn","imports",i,s,r) /bilat("bmk","imports",i,s,r)-1);
bilat("scn%","exports",i,s,r)$bilat("bmk","exports",i,s,r) = 100*(bilat("scn","exports",i,s,r) /bilat("bmk","exports",i,s,r)-1);
bilat("scn%","imports","all",s,r)$bilat("bmk","imports","all",s,r) = 100*(bilat("scn","imports","all",s,r) /bilat("bmk","imports","all",s,r)-1);
bilat("scn%","exports","all",s,r)$bilat("bmk","exports","all",s,r) = 100*(bilat("scn","exports","all",s,r) /bilat("bmk","exports","all",s,r)-1);
bilat("scn%","imports",i,s,"CC")$bilat("bmk","imports",i,s,"CC") = 100*(bilat("scn","imports",i,s,"CC") /bilat("bmk","imports",i,s,"CC")-1);
bilat("scn%","exports",i,s,"CC")$bilat("bmk","exports",i,s,"CC") = 100*(bilat("scn","exports",i,s,"CC") /bilat("bmk","exports",i,s,"CC")-1);
bilat("scn%","imports",i,s,"NCC")$bilat("bmk","imports",i,s,"NCC") = 100*(bilat("scn","imports",i,s,"NCC") /bilat("bmk","imports",i,s,"NCC")-1);
bilat("scn%","exports",i,s,"NCC")$bilat("bmk","exports",i,s,"NCC") = 100*(bilat("scn","exports",i,s,"NCC") /bilat("bmk","exports",i,s,"NCC")-1);
bilat("scn%","imports",i,s,"DOM")$bilat("bmk","imports",i,s,"DOM") = 100*(bilat("scn","imports",i,s,"DOM") /bilat("bmk","imports",i,s,"DOM")-1);
bilat("scn%","exports",i,s,"DOM")$bilat("bmk","exports",i,s,"DOM") = 100*(bilat("scn","exports",i,s,"DOM") /bilat("bmk","exports",i,s,"DOM")-1);


