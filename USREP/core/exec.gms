$ontext

:echo	====================================================
:echo	US Regional Model --- Global GTAP Model
:echo	.
:echo	Massachusetts Institute of Technology
:echo	.
:echo	http://mit.edu/globalchange
:echo	====================================================

: Sebastian Rausch
: rausch@mit.edu
: August 2011

$offtext

* Include data
$include ..\parameter_sets\0_loaddata.gms

* Capital vintaging
$include ..\parameter_sets\1_vintaging.gms

* Include GHG data (only for EPPA sectoral aggregation):
$include ..\parameter_sets\1_ghgdata.gms

$include ..\parameter_sets\eppatrend_e5.gms

$include ..\parameter_sets\7_1_reportpar_loop.gms

* Intra-period model
$include core.gms



