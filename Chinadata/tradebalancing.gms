$ontext

        Production activities   A (30) (1-30)
        Commodities             C (30) (31-60)
        Primary Factors         F (2)  (61-62: 61:labor, 62: capital)
        Households              H (1)  (63)
        Central Government      G1(1)  (64)
        Provincial Government   G2(1)  (65)
        Types of taxes          T (4)  (66-69: 66: production tax, 67: commodity tax, 68: factor tax, 69: income tax)
        Rest of country         DX(1)  (70: domestic inflow and outflow)
        Rest of world           X (1)  (71: import and export)
        Investment-savings      I (2)  (72:Capital formation, 73: Inventory change)
        Trade margin            M (1)  (74)

Here is a "MAP" of the SAM with the names of the submatrices which
contain data.  All cells with no labels are empty:



           A       C        F       H      G1      G2       T       DX      X      I1      I2      M
        ------------------------------------------------------------------------------------------------
A       |       |   ac  |       |       |       |       |   sa  |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
C       |   ca  |       |       |   ch  |       |  g2d  |       |   der |   er  |  cs1  |  cs2  |  trn  |
        ------------------------------------------------------------------------------------------------
F       |   fa  |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
H       |       |       |   hf  |       |       |  hg2  |       |   dhr |   hr  |       |       |       |
        ------------------------------------------------------------------------------------------------
G1      |       |       |       |       |       |  g1g2 |       |       |       |  cg1s |       |       |
        ------------------------------------------------------------------------------------------------
G2      |       |       |       |       | g2g1  |       |   tr  |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
T       |   ta  |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
DX      |       |  drc  |       |  drh  |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
X       |       |   rc  |       |   rh  |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
I1      |       |       |   dp  |  psv1 | g1sv  |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
I2      |       |   ic  |       |  psv2 |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
M       |       |   mrg |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
$offtext
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder1 '%projectfolder%/data/gdx/finalbalancing2'

*SAM table
set     i   SAM rows and colums indices   /
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
alias (i,j);
set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;

parameter sam4(r,i,j)           SAM v4.0 ready for rebalancing

$gdxin '%inputfolder1%/sam4.gdx'
$load sam4

positive variables finalsam (r,i,j)
positive variables rowsum(r,i)
positive variables columnsum(r,i)
positive variables domesticinsum(i)
positive variables domesticoutsum(i)
variable jj

Equations
        rsum
        csum
        sumbalance
        drcsum
        dxsum
        tradebalance
        obj
;

rsum(r,i)..
sum(j,finalsam(r,i,j))=e=rowsum(r,i);

csum(r,i)..
sum(j,finalsam(r,j,i))=e=columnsum(r,i);

sumbalance(r,i)..
rowsum(r,i)=e=columnsum(r,i);

drcsum(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticinsum(i)=e=sum(r,finalsam(r,"70",i));

dxsum(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticoutsum(i)=e=sum(r,finalsam(r,i,"70"));

tradebalance(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticinsum(i)=e=domesticoutsum(i);

obj..
*jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam4(r,i,j)))));
jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam4(r,i,j)))))+10000*sum(r,sum(i$((ord(i)=32) or (ord(i)=33) or (ord(i)=41) or (ord(i)=53) or (ord(i)=54) or (ord(i)=60) or (ord(i)=70) or (ord(i)=71)),sum(j$((ord(j)=2) or (ord(j)=3) or (ord(j)=11) or (ord(j)=23) or (ord(j)=24) or (ord(j)=30) or (ord(j)=70) or (ord(j)=71)),sqr(finalsam(r,i,j)-sam4(r,i,j)))));

Model gua /all/;
loop(r,
loop(i,
loop(j,
finalsam.l(r,i,j)=sam4(r,i,j);
);););
loop(r,
loop(i,
loop(j,
if (sam4(r,i,j)=0,
finalsam.fx(r,i,j)=0;
);
);
);
);
gua.iterlim=100000;
gua.reslim=100000000000;
Solve gua minimizing jj using nlp;
display finalsam.l;


set     negval5(i,j)     Flag for negative elements;
set     empty5(i,*)      Flag for empty rows and columns;
parameter       chkfinalsam(i,*)       Consistency check of social accounts;
parameter totoutput3(r);
loop(r,
totoutput3(r)=0;
);
loop(r,
loop(i$((ord(i)>=31) and (ord(i)<=60)),
totoutput3(r)=totoutput3(r)+sum(j,finalsam.l(r,i,j));
);
);

parameter sam5(r,i,j);
loop(r,
loop(i,
loop(j,
sam5(r,i,j)= finalsam.l(r,i,j);
);
);
);

