* ..\parameters\dynamic_parameters.gms

*  This file defines parameters report writing. Declaration is not
*  allowed inside dynamic loop and hence all parameters declared 
*  here have the time dimension.                                       

*-----------------------------------------------------------------------------------------
*	REPORT PARAMETERS:
*-----------------------------------------------------------------------------------------

parameter
* BAU profiles:
	blabor		BAU labor supply trajectory
	bkapital		BAU capital stock
	bhshkapital	BAU Household share of capital
	bffact		BAU total fixed factor supply (over all HH)
	bffacth	BAU fixed factor supply by household
	bgrg		BAU government revenue
	bn_r		BAU nuclear resource supply
	bh_r		BAU hydro resource supply
	bn_rh		BAU nuclear resource supply by household
	bh_rh		BAU hydro resource supply by household
	bshale	BAU shale oil resource supply

	e_prd	Fossil fuel production (in quadrillion btu)
	ini_ffact		Initial total resource factor supply (over all HH)
	ini_ffacth	Initial resource factor supply by factor

	k_o		Capital-output ratio

* Prices:
	report_prices1		Report parameter for prices
	report_prices2		Report parameter for prices
	report_prices3		Report parameter for prices

	report_prices1p		Report parameter for prices relative to CPI
	report_prices2p		Report parameter for prices relative to CPI
	report_prices3p		Report parameter for prices relative to CPI

	report_pghg1		Report parameter for GHG prices
	report_pghg2		Report parameter for GHG prices
	report_pghg3		Report parameter for GHG prices

	seclab		Labor employed in sector s (quantity)
	seckap		Capital employed in sector s (quantity)

	doutput		Production destined for domestic markets (quantity)
	outputftrd	Production destined for foreign trade markets (quantity)
	outputdtrd	Production destined for domestic trade markets (quantity)

        nucl		Nuclear electric output (quad btu)
        hydr		Hydro electric output (quad btu)
	ele_nh

	inputffact	Resource inputs (quantity)
	inputffact_n	Nuclear resource input (quantity)
	inputffact_h	Hydro resource input (quantity)
 
	land_agri		Land in AGR (quantity)
	land_tot		Total land (quantity)
	land_shra		Share of land in AGR in total land
*	land_shrb(	Share of land in backstop in total land

        aya                Total factor income by region (in current value)
        aca              Consumption by region by household (in current value)
	aca_allh		Regional total private consumption (in current value)
	cons_sec	Household consumption of non-energy commodities (in current value)
	cons_enersh	Household share of energy consumption 
        aka                Capital supplies (quantity)
        ala                Labor supplies (in efficient unit)
        afa              Fixed factor supplies (quantity)

	armsup		Armington supply (quantity)

        imflow_v         Import flow by good by region by trade type (current value)
        exflow_v         Export flow by good by region by trade type  (current value)
        imflow_q         Import flow by good by region by trade type (quantity)
        exflow_q         Export flow by good by region by trade type  (quantity)
        netflow_v        Net import flow by good by region by trade type  (current value)
        eimflow          Energy import, by type (quad btu)
        eexflow          Energy export, by type (quad btu)

	en_neleinput Energy input into energy aggregation EXCLUDING ele (quad btu)
	en_eleinput Electricity input into energy aggregation (quad btu)
        eeii             Total energy demand by production (quad btu)
        eeci            Energy demand by household (quad btu)
        eecii             Total energy demand by household tpye (quad btu)

	ele_eff			 "Electric efficency (=ele output in btu / energy input in btu)"
	tot_eff			 "US electric efficiency (=ele output in btu / energy input in btu)"
	ele_pe		 Electric efficiency for primary equivalent conversion

        bbsolout          Demand for "solar"
        bbsoilout         Demand for "synf-oil"
        bbsgasout        Demand for "synf-gas"
        bbwout            Demand for "wind"
        bbbioeleout       Demand for "bioelec"
        bbbigasout	 Demand for "bio-oil"
        bbicsout          Demand for "igcap"
        bbncsout          Demand for "ngcap"
        bbngout           Demand for "ngcc"
	bbadvnucl_bout		 Demand for "adv-nuc"
	bbwbioout	 Demand for "windbio"
	bbwgasout	 Demand for "windgas"

	coal_gas		 Coal input in coal gasification (quad btu)
	roil_inp		 Crude oil input in refined oil production (quad btu)

        telecprd          Total electricity production (quad btu)
        elselec          Share from fossil fuels conventional technology
        elsnucl          Share from nuclear (share based on physical quantity)
        elshydro         Share from hydro (share based on physical quantity)
        elssol           Share from "solar" (share based on physical quantity)
        elswind          Share from "wind" (share based on physical quantity)
        elswindbio       Share from "windbio" (share based on physical quantity)
        elswindgas       Share from "windgas" (share based on physical quantity)
        elsbioele        Share from "bioelec" (share based on physical quantity)
        elsics           Share from "igcap" (share based on physical quantity)
        elsncs           Share from "ngcap" (share based on physical quantity)
        elsng            Share from "ngcc" (share based on physical quantity)
	elsadvnuclShare from "adv-nuc"  (share based on physical quantity)

        ee               Energy consumption (in quad btu)

        co2f             CO2 emissions by region by energy type ---excluding emissions from backstops (million metric tons)

        ceei           CO2 emission by fuel, from production sector (million metric tons)
        ceeci            CO2 emission by fuel, from consumption sector (million metric tons)
	sectem		Total sectoral CO2 emissions (million metric tons)
	houem	Total emissions from private consumption (million metric tons)

        ceeib         CO2 emission by fuel INCLUDING backstops (million metric tons)

	totco2			Total CO2 from fossil burning INCLUDING backstops and shale oil (million metric tons)
	totco2t			Total CO2 from fossil burning INCLUDING backstops and shale oil (million metric tons)
	govinct
	totsecemi		"Total sectoral emissions (co2 plus ghgs)"
	vgmt
	vgmtt
* Sequestration accounting:
        ngseq              Annual ngcap sequestration (million metric tons) 
        igseq             Annual igcap sequestration (million metric tons)
        cumnseq           Cumulative carbon sequestered by ngcap (million metric tons)
        cumiseq           Cumulative carbon sequestered by igcap (million metric tons)
	cumseq	Cummulative carbon sequestered (million metric tons)

	ghgky			"GHG emissions by sectors (million metric tons)"
	tghgky			"Total GHG emissions excluding CO2 (all sector and private) (million metric tons"

        aia               Total investment (in current value)
        aiia              Total nvestment (quantities)

        aga           Total government expenditure (in current value)
        agga         Total government expenditure (quantities)

        axa                Net exports (in current value)

        agnp               "GNP (based on expenditures) (current value)"
        agnppc             "GNP per capita (based on expenditures) (current value)"
        aignp              "GNP (income-based) (current value)"

	ener_int		"Energy intensity (energy use (quad btu)/GNP)"

* Backstop inputs:
        einnucl           primary thermal energy input into nuclear (quad btu)
        einhydro          primary energy input into hydropower (quad btu)
        einwind           thermal equivalent of electricity produced by wind (quad btu)
        einwindbio        thermal equivalent of electricity produced by wind (quad btu)
        einwindgas        thermal equivalent of electricity produced by wind (quad btu)
        einbioele         primary thermal energy input into biomass electric (quad btu)
	einadvnucl		primary energy input into advanced nuclear (quad btu)
        einsol            thermal equivalent of electricity produced by wind (quad btu)
        einng             ngcc energy input (quad btu)
        einncs            ngcap energy input (quad btu)
        einics            igcap energy input (quad btu)
        einsyng           coal input to synthesis gas (quad btu)
        einsyno           shale input to synthesis oil (quad btu)
	einbigas	biomass input to biomass refoil (quad btu)

        elecoal           Coal input to electric sector (quad btu)
        elegas            Gas input to electric sector (quad btu)
        eleoil            Oil input to conventional electric sector (quad btu)
        elenucl           Nuclear input to electric sector (quad btu)

        eeib           Energy demand by production sectors with backstops (quad btu)

* Electricity production by fossil fuel:
	eleccoal	Electricity generation from coal (quad btu)
        elecgas           Electricity generation from gas (quad btu)
        elecoil	Electricity generation from refined oil (quad btu)

* Backstop efficiencies:
        effng             "Fuel efficiency of NGCC (quad btu / quad btu)"
        effncs            "Fuel efficiency of NGCAP (quad btu / quad btu)"
        effics            "Fuel efficiency of IGCAP (quad btu / quad btu)"
 
* Backstop input tracking:
$ontext
        qbk(vbt,r,t)            Capital input to backstop
        qbl(vbt,r,t)            Labor input to backstop
        qba(vbt,g,r,t)          Fuel input to backstop
        qbff(vbt,r,t)           Fixed factor input to backstop
        qbpc(vbt,r,t)           Carbon permit input to backstop - non-tradable
        qbptc(vbt,r,t)         	Carbon permit input to backstop - tradable
        qbfc(vbt,r,t)           Carbon permit input to backstop - final demand

* Vintaging share parameters:
        vbt_dl(vbt,v,r,t)
        vbt_dk(vbt,v,r,t)
        vbt_da(vbt,g,v,r,t)
        vbt_dff(vbt,v,r,t)
	vbt_em(vbt,v,r,t)	Fraction of carbon not sequestered
$offtext

* Production indices:
	bdv			Vintaged production index
	ebact			Backstop activtiy index

* Bio-oil trade: 
	report_bioimf
	report_bioimi
	report_bioex
	report_bioimff
	report_bioimif
	report_bioexf
	bio_imq	"Total (domestic + foreign) bio-oil imports ---quad btu"
	bio_dq	"Regionally produced bio-oil used for final and industrial demand--quantity"

	bio_intim	"Total foreign bio-oil imports ---quad btu"
	bio_intex	"Total foreign bio-oil exports ---quad btu"

	modelstatus		"0 = Normal completion, 1 = Solution error"

	govinc			"Government income (current value)"
	leiscons		"Leisure consumption (current value)"
	welfare_indx		"Welfare index"

	cons_ref		"Private consumption (reference) (current value)"
	leis_ref		"Leisure consumption (reference) (current value)"
	hhinc_ref		"Household income (reference)"
	co2_ref     "CO2 emissions (reference)"
	ghg_refr        "GHG emissions (reference)"
	ghgs_ref	        "Sectoral GHG emissions (reference)"
	co2s_ref		"Sectoral CO2 emissions (reference)"
	welfare_ref		"Welfare index (reference)"
	tottaxrev_ref		"Total tax revenue (reference case) (current value)"
	govinc_ref		"Government income (reference case) (current value)"
	gdp_ref			"GDP reference"
	report_allowval		"Report parameter for US allowance value"
	report_allowvalregion	"Report parameter for regional allowance value"
	report_allowvalhh	"Report parameter for allowance value by household"
	BAU_tottaxrev	BAU total tax revenue (excluding GHG taxes)
	BAU_welfare	BAU welfare index
	BAU_hhinc	BAU household income

	report_pinctrate	Endogenous personal income tax rate




* Consumer price indices:
	cpi1			"Paasche consumer price index"

*	Fixed factor endowments for backstop vintages:
	report_vb_k
	report_vb_kh

	energy_prodcons  "Report parameter: energy production and consumption (quad btu)"


	elec_preg	"Regional electricity generation by type (EJ)"
	prim_ener	"Primary energy use (EJ) --use efficiency of fossil electricity to convert to PE equivalent"

;

*tottaxrev_ref(t) = 0;

*co2_ref(t,r) = 0;
*ghg_ref(ghg,t,r) = 0;

BAU_tottaxrev(t) = 0;
BAU_welfare(rs,g,t,"w") = 0;
BAU_welfare(rs,g,t,"cons") = 0;
BAU_welfare(rs,g,t,"cons+leis") = 0;
BAU_hhinc(rs,g,t)=0;
