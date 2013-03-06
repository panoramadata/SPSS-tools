GET FILE='.../data.sav'.
use all.

freq var1 /hist.
freq var1 to var12 /format=notable /statistics.

sort cases by y.
freq y.

********* Flatliners ***********.

* Flatliners.
compute sd.brand = sd( vara1 to vara9 ).
compute sd.att1 = sd( varb1 to varb8 ).
compute sd.att2 = sd( varc1 to varc5).
* More batteries potentially

freq sd.brand sd.att1 sd.att2 /format=notable /statistics /percentiles= 5 10 25 75 95 .

compute d.brand = ( sd.brand < 0.5).
compute d.att1 = ( sd.att1 < 0.5).
compute d.att2 = ( sd.att2 < 0.5).

count flatlines = d.brand to d.att2 (1).
freq flatlines.

* Remove those with 60% or more flatlined batteries.
compute clean.sample = (flatlines  <= 1).
exe.
filter by clean.sample.

* Check across y.
use all.
format flatlines clean.sample (F1.0).

* split file by qcountry2.
set tnumbers = labels.
ctables /table  clean.sample > flatlines by y
  /CATEGORIES VARIABLES=flatlines EMPTY=EXCLUDE
  /CATEGORIES VARIABLES=clean.sample [1, 0] EMPTY=INCLUDE
 /table  flatlines [COLPCT.COUNT] by y.
set tnumbers = both.
