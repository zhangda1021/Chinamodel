$title China model version 1

*-------------------------------------------------------------------
*       Read SAM data:
*-------------------------------------------------------------------

set     i_   SAM rows and colums indices   /
        1*30    Industries,
        31*60   Commodities,
        61      Labor,
        62      Capital,
        63      Household,
        64      Central Government,
        65      Local Government,
        66      Production tax,
        67      Commodity tax,
        68      Factor tax,
        69      Income tax,
        70      Domestic trade,
        71      Foreign trade,
        72      Investment,
        73      Inventory,
        74      Trade margin/;

alias (i_,j_);

set      r China provinces      /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;

parameter sam(r,i_,j_)  SAM data;

$gdxin sam5.gdx
$load sam=sam5

*-------------------------------------------------------------------
*       RELABEL SETS:
*-------------------------------------------------------------------

SET     f    Factors /cap,lab,res/
        g    Goods and final demands/
        AGR     "Crop cultivation,Forestry,Livestock and livestock products and Fishery"
        COAL    "Coal mining and processing"
        OIL     "Crude petroleum products"
        MM      "Metal minerals mining"
        NMM     "Non-metal minerals and other mining"
        FBT     "Food, baverage and tobacco"
        TXT     "Textiles"
        CLO     "Wearing apparel, leather, furs, down and related products"
        LOG     "Logging and transport of timber and furniture"
        PAP     "Paper, printing, record medium reproduction, cultural goods, toys, sporting and recreation products"
        ROIL    "Petroleum refining, coking and nuclear fuels"
        CHE     "Chemical engineering"
        NMP     "Non-metallic mineral products"
        MSP     "Metal smelting and processing"
        MP      "Metal product"
        GSM     "General and special  industrial machinery and equipment"
        TME     "Transport machinery and equipment"
        EME     "Electric machinery and equipment"
        CCE     "Communicatoin, computer and other electronic machinery and equipment"
        IM      "Instruments, meters ,other measuring equipment and cultural and office equipment"
        AC      "Arts and crafts products and other manufacturing  products"
        WAS     "Scrap and waste"
        ELEH    "Electricity production and supply, and steam and hot water production and supply"
        FG      "Gas production and supply"
        WT      "Water production and supply"
        CON     "Construction"
        TP      "Transportation and warehousing, Post"
        WRHR    "Wholesale and retail trade, Hotels and restraunts"
        OTH     "Other service industry"
        NG      "natural gas products"
        c       "Private consumption"
        cg      "Central Government"
        lg      "Local Government"
        i       "Investment"
        /
        i(g)    "Goods and sectors" /
        AGR     "Crop cultivation,Forestry,Livestock and livestock products and Fishery"
        COAL    "Coal mining and processing"
        OIL     "Crude petroleum products"
        MM      "Metal minerals mining"
        NMM     "Non-metal minerals and other mining"
        FBT     "Food, baverage and tobacco"
        TXT     "Textiles"
        CLO     "Wearing apparel, leather, furs, down and related products"
        LOG     "Logging and transport of timber and furniture"
        PAP     "Paper, printing, record medium reproduction, cultural goods, toys, sporting and recreation products"
        ROIL    "Petroleum refining, coking and nuclear fuels"
        CHE     "Chemical engineering"
        NMP     "Non-metallic mineral products"
        MSP     "Metal smelting and processing"
        MP      "Metal product"
        GSM     "General and special  industrial machinery and equipment"
        TME     "Transport machinery and equipment"
        EME     "Electric machinery and equipment"
        CCE     "Communicatoin, computer and other electronic machinery and equipment"
        IM      "Instruments, meters ,other measuring equipment and cultural and office equipment"
        AC      "Arts and crafts products and other manufacturing  products"
        WAS     "Scrap and waste"
        ELEH    "Electricity production and supply, and steam and hot water production and supply"
        FG      "Gas production and supply"
        WT      "Water production and supply"
        CON     "Construction"
        TP      "Transportation and warehousing, Post"
        WRHR    "Wholesale and retail trade, Hotels and restraunts"
        OTH     "Other service industry"
        NG      "Natural gas products"
        /
        ;

alias (i,j) , (g,gg) , (r,rr);

*       Map i set to new subsets:

set     mapf(i_,f) /
        61.lab
        62.cap/,

        mapic(i_,i) /
        1.AGR
        2.COAL
        3.OIL
        4.MM
        5.NMM
        6.FBT
        7.TXT
        8.CLO
        9.LOG
        10.PAP
        11.ROIL
        12.CHE
        13.NMP
        14.MSP
        15.MP
        16.GSM
        17.TME
        18.EME
        19.CCE
        20.IM
        21.AC
        22.WAS
        23.ELEH
        24.FG
        25.WT
        26.CON
        27.TP
        28.WRHR
        29.OTH
        30.NG
        /

        mapjc(i_,i) /
        31.AGR
        32.COAL
        33.OIL
        34.MM
        35.NMM
        36.FBT
        37.TXT
        38.CLO
        39.LOG
        40.PAP
        41.ROIL
        42.CHE
        43.NMP
        44.MSP
        45.MP
        46.GSM
        47.TME
        48.EME
        49.CCE
        50.IM
        51.AC
        52.WAS
        53.ELEH
        54.FG
        55.WT
        56.CON
        57.TP
        58.WRHR
        59.OTH
        60.NG
        /

        gov(g) Government agents /
        cg Central government
        lg Local government
        /
        maph(i_,g) /63.c/
        mapg(i_,gov) /64.cg,65.lg/
        mapinv(i_,g) /72.i/
;

alias (gov,govv);

set     trd Domestic and foreign markets /dtrd,ftrd/
        tb  Trade surplus or deficit /s,d/;

*-------------------------------------------------------------------
*       LABEL DATA:
*-------------------------------------------------------------------

parameter
        vom(g,r)       "Aggregate output"
        vom_(i,j_,r)   "Aggregate output"

        vfm(f,g,r)     "Endowments "
        evom(f,r)      "Factor supply"

        vafm(i,g,r)    "Intermediate demand for Armington goods,"
        vafm_(i,j_,r)  "Intermediate demand for Armington goods"
*	no data on vdfm and vifm
*       vdfm(i,g,rs)    Intermediates - firms' domestic purchases at market prices,
*       vifm(i,g,rs,trd)        Intermediates - firms' imports at market prices (ADDED DIMENSION),
        vxm(i,r,trd)   "Domestic and foreign exports "
        vim(i,r,trd)   "Aggregate imports"
        vtax(g,r)      "Output tax payments"
        vsub(g,r)      "Output subsidy payments"
        vtrdm(g,r)     "Trade margins"

        vinvta(i,r)     "Inventory additions (column)"
        vinvtd(i,r)     "Inventory deletions (row)"
        vtrnm(i,r)      "Transportation margins"

        vdepr(f,r)		"Depreciation of capital"
        vtrdbal(r,trd,tb)	"Balance of payments surplus or deficit"

        vinvs(r,g)		"Investment demand by agent"
        vinvsn(r,g)		"Negative demand to close investement account (need to revisit)"
        vinvch(r)		"Inventory change in household account"
        vttrn(r,g,gg)		"Transfer payments between agents (from-to)"

        vtaxrev(r,g)		"Tax revenue for government agent"
;


*       Aggregate output:
loop(i$(ord(i) le 30),
loop(i_$(ord(i_) eq ord(i)),
loop(j_$(ord(j_) eq 30+ord(i)),
*loop(i_$(ord(i_) le 30),
*loop(j_$(ord(j_) eq 30+ord(i_)),
*vom_(i,j_,r) = sum(mapic(i_,i), sam(r,i_,j_));
vom(i,r) = sam(r,i_,j_);
);
);
);
*vom(i,r) = sum(j_,vom_(i,j_,r));
*display vom;

*       Factor payments by sector:
vfm(f,i,r) = sum(mapf(j_,f),sum(mapic(i_,i),sam(r,j_,i_)));
display vfm;

*       Intermediate demands for Armington goods:
vafm(j,i,r) =  sum((mapic(i_,i),mapjc(j_,j)),sam(r,j_,i_));
vafm(j,"c",r) =  sum((maph(i_,g),mapjc(j_,j)),sam(r,j_,i_));
vafm(j,"i",r) =  sum((mapinv(i_,g),mapjc(j_,j)),sam(r,j_,i_));
vafm(j,gov,r) =  sum((mapg(i_,gov),mapjc(j_,j)),sam(r,j_,i_));

*       Domestic and foreign exports and immports:
vxm(i,r,"dtrd")  = sum(mapjc(i_,i),sam(r,i_,"70"));
vxm(i,r,"ftrd")  = sum(mapjc(i_,i),sam(r,i_,"71"));

vim(i,r,"dtrd")  = sum(mapjc(i_,i),sam(r,"70",i_));
vim(i,r,"ftrd")  = sum(mapjc(i_,i),sam(r,"71",i_));

*       Output/subsidy taxes:
vtax(i,r) = sum(mapic(i_,i),sam(r,"66",i_));
vsub(i,r) = sum(mapic(i_,i),sam(r,i_,"66"));

*       Trade margins:
vtrdm(i,r) = sum(mapjc(i_,i),sam(r,"74",i_));

*       Inventory additions and deletions:
vinvtd(i,r) = sum(mapjc(i_,i),sam(r,"73",i_));
vinvta(i,r)  = sum(mapjc(i_,i),sam(r,i_,"73"));

*       Transport margins:
vtrnm(i,r) = sum(mapjc(i_,i),sam(r,i_,"74"));

*       Earnings from factor supply:
evom(f,r) = sum(mapf(j_,f),sam(r,"63",j_));
vdepr(f,r) = sum(mapf(j_,f),sam(r,"72",j_));

*       Balance of payments surplus:
vtrdbal(r,"dtrd","s") = sam(r,"70","63");
vtrdbal(r,"ftrd","s") = sam(r,"71","63");
vtrdbal(r,"dtrd","d") = sam(r,"63","70");
vtrdbal(r,"ftrd","d") = sam(r,"63","71");

*       Investment demand by agent:
vinvs(r,"c") = sam(r,"72","63");
vinvs(r,"cg") = sam(r,"72","64");

*       Inventory change in household account:
vinvch(r) = sam(r,"73","63");

*       Transfer payments;
vttrn(r,"lg","cg") = sam(r,"64","65");
vttrn(r,"cg","lg") = sam(r,"65","64");
vttrn(r,"lg","c") = sam(r,"63","65");

*       Tax revenue:
vtaxrev(r,"lg") = sam(r,"65","66");

*       Negative demand to close investment account (need to revisit!):
vinvsn(r,"cg") =  sam(r,"64","71");


*       Compute additional parameter to define model:
vom("c",r) = sum(j,vafm(j,"c",r));
vom(gov,r) = sum(j,vafm(j,gov,r));
vom("i",r) = sum(j,vafm(j,"i",r));

parameter
        vam     Armginton production;

vam(i,r) = sum(trd,vim(i,r,trd)) + vom(i,r);


*       Check sparsity:

parameter total_supply,intermediate_demand;
total_supply(i,r) = vom(i,r) + sum(trd,vim(i,r,trd)) + vinvtd(i,r);
intermediate_demand(j,i,r) = vafm(j,i,r);

parameter chk_vafm;
*chk_vafm(i,g,r) = yes$(vafm(i,g,r) and (not sum(trd,vim(i,r,trd))));
chk_vafm(i,j,r) = yes$(intermediate_demand(i,j,r) and (not total_supply(i,r)));

display chk_vafm;
$exit

*-------------------------------------------------------------------
*       ACCOUNTING MODEL IN MPSGE TO ILLUSTRATE IDENTITIES
*       IN SAM TABLES
*-------------------------------------------------------------------

$ontext
$model:china_accmodel


$sectors:
        Y(g,r)$vom(g,r)                              ! Sectoral production and final demands
        A(i,r)$vam(i,r)                              ! Armington composite supply
        X(i,trd,r)$vxm(i,r,trd)                      ! Domestic and international exports

$commodities:
        P(g,r)$vom(g,r)                              ! Domestic output price
        PA(i,r)$vam(i,r)                             ! Armington composite price
        PF(f,r)                                      ! Factor prices
        PTAX(g,r)$(vtax(g,r)-vsub(g,r))              ! Tax payments
        PEX(i)                                       ! Price of domestic exports
        PFX

$consumers:
        RH(r)                                        ! Representative household
        GOVT(r)$vom("lg",r)                          ! Government entity by province comprising local and central government activity


* SECTORAL PRODUCTION AND FINAL DEMANDS:
$prod:Y(g,r)$vom(g,r)
        o:P(g,r)                       q:vom(g,r)
        o:PTAX(g,r)                    q:vsub(g,r)
        i:PA(i,r)                      q:vafm(i,g,r)
        i:PF(f,r)                      q:vfm(f,g,r)
        i:PTAX(g,r)                    q:vtax(g,r)

* DOMESTIC AND INTERNATIONAL EXPORTS:
$prod:X(i,trd,r)$vom(i,r)
        o:PEX(i,trd)                   q:vxm(i,r,trd)
        i:P(i,r)                       q:vxm(i,r,trd)

* ARMINGTON AGGREGATION FOR DOMESTIC AND IMPORTED VARITIES:
$prod:A(i,r)$vam(i,r)
        o:PA(i,r)      q:vam(i,r)
        i:P(i,r)       q:vom(i,r)
        i:PEX(i,trd)   q:vim(i,r,trd)


* HOUSEHOLD INCOME BY INCOME CLASS:
$demand:RH(r)
        d:P("c",r)       q:vom("c",r)
        e:PF(f,r)        q:evom(f,r)
        e:PF("cap",r)    q:(-vdepr("cap",r))
        e:P("i",r)       q:(-vinvs(r,"c"))
* Inventory net additions:
        e:P(i,r)         q:(vinvta(i,r)-vinvtd(i,r))
* BOP:
        e:PEX("oth","ftrd")      q:(sum(trd,vtrdbal(r,trd,"s")-vtrdbal(r,trd,"d")))


* GOVERNMENT ENTITY BY PRONVINCE:
$demand:GOVT(r)$vom("lg",r)
        d:P("lg",r)       q:vom("lg",r)
* "Central government" portion of income:
        e:PEX("oth","ftrd") q:(-vttrn(r,"cg","lg"))
        e:PEX("oth","ftrd") q:vttrn(r,"lg","cg")
        e:PEX("oth","ftrd") q:vinvsn(r,"cg")
        e:P("i",r)       q:(-vinvs(r,"cg"))
* "Local government" portion of income:
        e:PEX("oth","ftrd") q:vttrn(r,"cg","lg")
        e:PEX("oth","ftrd") q:(-vttrn(r,"lg","c"))
        e:PEX("oth","ftrd") q:(-vttrn(r,"lg","cg"))
        e:PTAX(i,r)      q:(vtax(i,r)-vsub(i,r))

$offtext
$sysinclude mpsgeset china_accmodel


*       Replicate benchmark equilibrium:
china_accmodel.iterlim = 0;
china_accmodel.workspace = 100;
$include china_accmodel.gen
solve china_accmodel using mcp;
