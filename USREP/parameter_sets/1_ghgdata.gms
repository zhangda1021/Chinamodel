*------------------------------------------------------------------------------
*	Add GHG inventory data for US regions:
*------------------------------------------------------------------------------

*	Read US GHG inventory data:

SET GHG GREEN HOUSE GAS POLLUTANTS /CH4, N2O, PFC, SF6, HFC/
set value /data/;

parameter usghg_(ghg,*,value)	US GHG inventories (in million metric ton CO2e)
	  usghg(ghg,*)	US GHG inventories (in million metric ton CO2e);

*$call 'gdxxrw i=..\ghg_data\ghgdata_for_model.xls o=..\ghg_data\ghgdata_for_model.gdx par=usghg_ rng="gamstable!a1" rdim=2 cdim=1';
$gdxin ..\data\ghg_data\ghgdata_for_model
$load usghg_

usghg(ghg,i) = usghg_(ghg,i,"data");
usghg(ghg,"hh_cons") = usghg_(ghg,"hh_cons","data");

display usghg_,i,ghg;

*	Infer state shares from GHG inventories:

parameter ghg_inv(s,ghg,*)	State non-CO2 GHG emission by sector (million ton CO2e);
 
*	For AGR we use state share of national ag production from IMPLAN:

ghg_inv(s,ghg,"agr") = vom("agr",s) / sum(s.local,vom("agr",s)) * usghg(ghg,"agr");

*	For methane emissions from coal sector we use EIA state coal production:
 
ghg_inv(s,ghg,"col") = stey0(s,"col") / sum(s.local,stey0(s,"col")) * usghg(ghg,"col");

*	Emissions for refined oil products are determined by states' oil consumption:
 
ghg_inv(s,ghg,"oil") = sum(i,eind(s,i,"oil")) / sum(s.local,sum(i,eind(s,i,"oil"))) * usghg(ghg,"oil");

*	Gas emissions are determined by states' gas consumption:
 
ghg_inv(s,ghg,"gas")$sum(s.local,sum(i,eind(s,i,"gas"))) = sum(i,eind(s,i,"gas")) / sum(s.local,sum(i,eind(s,i,"gas"))) * usghg(ghg,"gas");

*	TRN emissions are determined by value of TRN output:

ghg_inv(s,ghg,"trn") = vom("trn",s) / sum(s.local,vom("trn",s)) * usghg(ghg,"trn"); 

*	SF6 emissions from ELE are based on state-level electricity generation:

ghg_inv(s,ghg,"ele") = stey0(s,"ele") / sum(s.local,stey0(s,"ele")) * usghg(ghg,"ele");

*	EIS and OTH emissions are determined by value of production:

ghg_inv(s,ghg,"eis") = vom("eis",s) / sum(s.local,vom("eis",s)) * usghg(ghg,"eis"); 
ghg_inv(s,ghg,"oth") = vom("man",s) / sum(s.local,vom("man",s)) * usghg(ghg,"oth"); 

*	Methane and N2O emissions by household consumption are based on state's population
*	share:

ghg_inv(s,ghg,"hh_cons") = population_uscensus(s,"2006") / sum(s.local,population_uscensus(s,"2006")) * usghg(ghg,"hh_cons"); 


*------------------------------------------------------------------------------
*	Add GHG inventory data for GTAP regions (using EPPA5 data):
*------------------------------------------------------------------------------


