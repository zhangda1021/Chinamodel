if exist %1.cas goto start

echo	.
echo	.
echo	Cannot find the case file %1.cas in this directory.
echo	.
goto end

:start
cd..
cd core

if not exist ..\results\%1 mkdir ..\results\%1

:--------------------------------------------------------------------------------------------
TITLE RUNNING STATIC MODEL 
:--------------------------------------------------------------------------------------------

:call gams exec --ds=data_itarget_EPPA_starget_USREP_rtarget_EPPA_BAL o=..\lst\exec.lst s=exec 
:call gams exec --ds=data_itarget_EPPA_starget_USREP_rtarget_2_BAL o=..\lst\exec.lst s=exec 
call gams exec --ds=data_itarget_eis_starget_us_rtarget_eppa_BAL o=..\lst\exec.lst s=exec 

:call gams exec --ds=data_itarget_EPPA_starget_USREP_rtarget_6_BAL o=..\lst\exec.lst s=exec 
echo $include ..\active\%1.cas		>useppa.cas
echo $include ..\active\%1.bau		>useppa.bau
echo $setglobal case %1			>report.inc


:--------------------------------------------------------------------------------------------
TITLE RUNNING DYNAMIC USREP FOR CASE: %1
:--------------------------------------------------------------------------------------------

call gams loop	o=..\lst\%1.lst r=exec gdx=..\results\%1\output_%1

:	Store output in a second folder to facilitate merge across scenarios (this 
:	is controlled from master.bat file):
:copy ..\results\%1\output_%1.gdx ..\results\all_scenarios\%1.gdx

:end

cd..
cd active
TITLE DONE






