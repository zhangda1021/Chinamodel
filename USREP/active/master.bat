@echo.off

:echo	====================================================
:echo	US Regional Model --- Global GTAP Model
:echo	.
:echo	Massachusetts Institute of Technology
:echo	.
:echo	http://mit.edu/globalchange
:echo	====================================================

: Sebastian Rausch and Justin Caron
: rausch@mit.edu, jcaron@mit.edu
: February 2012

if not exist ..\results mkdir ..\results

goto merge


goto end
:--------------------------------------------------------------------
: CORE POLICY SCENARIOS

:call loop2004 C EU etNO renL bREF emREF tON fON kON 
:call loop2004 C trdNO etNO renL bREF emREF tON fON kON 
:call loop2004 C trdNO etYES renL bREF emREF tON fON kON 
:call loop2004 C trdYES etNO renL bREF emREF tON fON kON 
:call loop2004 C trdYES etYES renL bREF emREF tON fON kON 


:--------------------------------------------------------------------
: SENSITIVITY ANALYSIS
: sa

: Identify leakage channels:
:	capital 
:call loop2004 S EU etNO renL bREF emREF       tOFF fOFF kON 
:call loop2004 S trdNO etNO renL bREF emREF    tOFF fOFF kON 
:call loop2004 S trdNO etYES renL bREF emREF   tOFF fOFF kON 
:call loop2004 S trdYES etNO renL bREF emREF   tOFF fOFF kON 
:call loop2004 S trdYES etYES renL bREF emREF  tOFF fOFF kON 
:	trade
call loop2004 S EU etNO renL bREF emREF       tON fOFF kOFF 
call loop2004 S trdNO etNO renL bREF emREF    tON fOFF kOFF 
call loop2004 S trdNO etYES renL bREF emREF   tON fOFF kOFF 
call loop2004 S trdYES etNO renL bREF emREF   tON fOFF kOFF 
call loop2004 S trdYES etYES renL bREF emREF  tON fOFF kOFF 
:	fossil fuel price:
:call loop2004 S EU etNO renL bREF emREF       tOFF fON kOFF 
:call loop2004 S trdNO etNO renL bREF emREF    tOFF fON kOFF 
:call loop2004 S trdNO etYES renL bREF emREF   tOFF fON kOFF 
:call loop2004 S trdYES etNO renL bREF emREF   tOFF fON kOFF 
:call loop2004 S trdYES etYES renL bREF emREF  tOFF fON kOFF 

: Low border effect and ref esubmusa (LOW-BASE):
call loop2004 S EU etNO renL bLOW emREF tON fON kON 
call loop2004 S trdNO etNO renL bLOW emREF tON fON kON 
call loop2004 S trdNO etYES renL bLOW emREF tON fON kON 
call loop2004 S trdYES etNO renL bLOW emREF tON fON kON 
call loop2004 S trdYES etYES renL bLOW emREF tON fON kON 

: Ref border effect and low esubmusa (BASE-LOW):
call loop2004 S EU etNO renL bREF emLOW tON fON kON 
call loop2004 S trdNO etNO renL bREF emLOW tON fON kON 
call loop2004 S trdNO etYES renL bREF emLOW tON fON kON 
call loop2004 S trdYES etNO renL bREF emLOW tON fON kON 
call loop2004 S trdYES etYES renL bREF emLOW tON fON kON 

: Low border effect and low esubmusa (LOW-LOW):
call loop2004 S EU etNO renL bLOW emLOW tON fON kON 
call loop2004 S trdNO etNO renL bLOW emLOW tON fON kON 
call loop2004 S trdNO etYES renL bLOW emLOW tON fON kON 
call loop2004 S trdYES etNO renL bLOW emLOW tON fON kON 
call loop2004 S trdYES etYES renL bLOW emLOW tON fON kON 

: High (=HO) border effect and high esubmusa (HIGH-HIGH):
call loop2004 S EU etNO renL bHO emHO tON fON kON 
call loop2004 S trdNO etNO renL bHO emHO tON fON kON 
call loop2004 S trdNO etYES renL bHO emHO tON fON kON 
call loop2004 S trdYES etNO renL bHO emHO tON fON kON 
call loop2004 S trdYES etYES renL bHO emHO tON fON kON 

: Sensitivity of renewables (change EOS bw K/L-fixed factor):
call loop2004 S EU etNO renH bREF emREF tON fON kON 
call loop2004 S trdNO etNO renH bREF emREF tON fON kON 
call loop2004 S trdNO etYES renH bREF emREF tON fON kON 
call loop2004 S trdYES etNO renH bREF emREF tON fON kON 
call loop2004 S trdYES etYES renH bREF emREF tON fON kON 

goto merge
goto end

:--------------------------------------------------------------------
: MERGE SCENARIOS AND OUTPUT TO EXCEL:
:merge
cd..\results
call gdxmerge *.gdx

:call gdxxrw i=merged.gdx o=prices.xlsx par=report_prices2p rng=report_prices2p!a2 cdim=0
call gdxxrw i=merged.gdx o=compare.xlsx  @dumppar.rpt
call gdxxrw i=merged.gdx o=byreg.xlsx par=byreg rng=byreg!a2 cdim=0
:call gdxxrw i=merged.gdx o=byregsect.xlsx par=byregsect rng=byreg!a2 cdim=0

goto end
:	Split reporting for bilat:
cd..\results\scenarios_for_bilat
call gdxmerge *.gdx
call gdxxrw i=merged.gdx o=bilat.xlsx par=bilat rng=bilat!a2 cdim=0

cd ..\active
:TITLE DONE
:end