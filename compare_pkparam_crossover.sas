data adam_bds2;
    set adam_bds;
    lnaval = log(aval);  /* lnAUC or lnCmax ... */
run;

ods output lsmeans = lsmean diffs=lsmdif;
proc mixed data = adam_bds2 ;
    class trtan group aperiod usubjid;
    model lnaval = trtan group aperiod/ddfm=kr;
    random usubjid;
    lsmeans trtan/pdiff cl alpha=0.1;/*90%CI*/
run;

data lsmean2;
    set lsmean;
    geomean = strip(put(exp(estimate), 8.4));
run;

data lsmdif2;
    set lsmdif;
    ratio = strip(put(exp(estimate), 8.4));
    lower_r = strip(put(exp(lower), 8.4));
    upper_r = strip(put(exp(upper), 8.4));
    
    /*if necessary, replace the numerator and denominator
    ratio = strip(put(exp(-estimate), 8.4));
    lower_r = strip(put(exp(-upper), 8.4));
    upper_r = strip(put(exp(-lower), 8.4));
    */
run;
