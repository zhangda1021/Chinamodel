 if not exist ..\results\%2 mkdir ..\results\%2

:start
cd..
cd core

:--------------------------------------------------------------------------------------------
TITLE RUNNING STATIC MODEL 
:--------------------------------------------------------------------------------------------

call gams exec  --c=%1 --coa=%2 --et=%3 --ren=%4 --b=%5 --em=%6 --t=%7 --f=%8 --k=%9   --ds=data_itarget_eis2_starget_cali2_rtarget_EPPA_CALIBAL  o=..\lst\exec.lst s=exec 

:--------------------------------------------------------------------------------------------
TITLE RUNNING DYNAMIC USREP FOR CASE: %1 %2 %3 %4 %5 %6 %7 %8 %9 
:--------------------------------------------------------------------------------------------

call gams loop  --year=2004 --loadyear=2004 --c=%1 --coa=%2 --et=%3 --ren=%4 --b=%5 --em=%6 --t=%7 --f=%8 --k=%9 r=exec o=..\lst\%1.lst gdx=..\results\%1_%2_%3_%4_%5_%6_%7_%8_%9.gdx


:end

cd..
cd active
TITLE DONE


