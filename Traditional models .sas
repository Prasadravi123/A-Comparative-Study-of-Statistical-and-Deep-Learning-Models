proc import datafile="/home/u64151948/MM711 2025/assessment/dissertation/df ets.csv"
out= tesla
dbms = csv;
run;

proc contents data=tesla; 
run;

proc sort data=tesla;
    by date;
run;

proc sgplot data=tesla;
    series x=date y=close;
    xaxis label="Month";
    yaxis label="Tesla Monthly Close";
run;

proc arima data=tesla;
    identify var=close stationarity=(adf);
run;
quit;

proc arima data=tesla;
    identify var= close(2);
run;
quit;


/* arima (1,1,1)---- best model */
proc arima data=tesla;
    identify var=close(2);
    estimate p=1 q=1;
run;
quit;

/*  ARIMA(0,1,1) */
proc arima data=tesla;
    identify var=close(2);
    estimate p=0 q=1;
run;
quit;

/*  ARIMA(1,1,0) */
proc arima data=tesla;
    identify var=close(2);
    estimate p=1 q=0;
run;
quit;

/*  ARIMA(2,1,2) */
proc arima data=tesla;
    identify var=close(1);
    estimate p=2 q=2;
run;
quit;


/*  ARIMA(1,1,2) */
proc arima data=tesla;
    identify var=close(2);
    estimate p=1 q=2;
run;
quit;

/*  ARIMA(2,1,1) */
proc arima data=tesla;
    identify var= close(2);
    estimate p=2 q=1;
run;
quit;

proc arima data=tesla;
    identify var=monthly_close(2);
    estimate p=1 q=1;
    forecast lead=12 interval=month id=month out=forecast_out;
run;
quit;

proc sgplot data=forecast_out;/*forecast*/
    series x=month y=monthly_close / lineattrs=(color=blue) legendlabel="Actual";
    series x=month y=forecast / lineattrs=(color=red) legendlabel="Forecast";
    band x=month lower=l95 upper=u95 / fill transparency=0.5 legendlabel="95% CI";
    xaxis label="Month";
    yaxis label="Tesla Monthly Close";
    keylegend / location=inside position=topright across=1;
run;

/*Log-Transformed Variable*/

data tesla_log;
    set tesla;
    log_close = log(close);
run;

proc sgplot data=tesla_log;
series x=date y=log_close;
run;

proc arima data=tesla_log;
identify var=log_close;
run;

proc arima data=tesla_log;
identify var=log_close(2);
run;

proc arima data=tesla_log;
    identify var=log_close stationarity=(adf);
run;
quit;

proc arima data=tesla_log;
identify var=log_close(2);
estimate p=1 q=1;
run;

/* ARIMA(0,1,1) */
proc arima data=tesla_log;
    identify var=log_close(2);
    estimate p=0 q=1;
run;
quit;

/* ARIMA(1,1,0) */
proc arima data=tesla_log;
    identify var=log_close(2);
    estimate p=1 q=0;
run;
quit;

/* ARIMA(2,1,2) */ ---
proc arima data=tesla_log;
    identify var=log_close(1);
    estimate p=2 q=2;
run;
quit;

/* ARIMA(1,1,2) */
proc arima data=tesla_log;
    identify var=log_close(2);
    estimate p=1 q=2;
run;
quit;

/* ARIMA(2,1,1) --- best model*/
proc arima data=tesla_log;
    identify var=log_close(2);
    estimate p=2 q=1;
run;
quit;

/* Forecast */
proc arima data=tesla_log;
    identify var=log_close(2);
    estimate p=2 q=1;
    forecast lead=12 interval=day id=date out=forecast_log;
run;
quit;

proc sgplot data=forecast_log;
    series x=date y=log_close / lineattrs=(color=blue) legendlabel="Actual";
    series x=date y=forecast / lineattrs=(color=red) legendlabel="Forecast";
    band x=date lower=l95 upper=u95 / fill transparency=0.5 legendlabel="95% CI";
    xaxis label="Month";
    yaxis label="Log Monthly Close";
    keylegend / location=inside position=topright across=1;
run;


/* hold out method*/

data tesla_train tesla_test;
    set tesla_log nobs=n;
    if _N_ <= 55 then output tesla_train;
    else output tesla_test;
run;

proc arima data=tesla_train;
    identify var=log_close(2);
    estimate p=2 q=1;
    forecast lead=10 interval=day id=date out=forecast_holdout;
run;
quit;

data holdout_eval;
    merge forecast_holdout (in=f) tesla_test (in=t keep=date log_close);
    by date;
    if f and t;
run;

proc sgplot data=holdout_eval;
    series x=date y=log_close / lineattrs=(color=blue) legendlabel="Actual (Log)";
    series x=date y=forecast / lineattrs=(color=red) legendlabel="Forecast (Log)";
    band x=date lower=l95 upper=u95 / transparency=0.5 legendlabel="95% CI (Log)";
    xaxis label="Month";
    yaxis label="Log Close Price";
    keylegend / location=inside position=topright across=1;
run;

data accuracy;
    set holdout_eval;
    error = log_close - forecast;
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=accuracy mean;
    var abs_error sq_error;
run;





/*final forecast*/

data forecast_log_exp;
    set forecast_log;
    forecast_price = exp(forecast);
run;

data forecast_log_exp;
    set forecast_log;
    forecast_price = exp(forecast);
    actual_price = exp(log_close); 
run;


proc sgplot data=forecast_log_exp;
    series x=date y=actual_price / lineattrs=(color=blue) legendlabel="Actual Price";
    series x=date y=forecast_price / lineattrs=(color=red) legendlabel="Forecasted Price";
    xaxis label="Month";
    yaxis label="Tesla Monthly Close (Original Scale)";
    keylegend / location=inside position=topright across=1;
run;



/*********************************** mercedes*************************/

/*arima*/
data mercedes_monthly;
    infile "/home/u64151948/MM711 2025/assessment/dissertation/mercedes_full.csv" dlm=',' firstobs=1 dsd;
    input date : yymmdd10. close;
    format date yymmdd10.;
run;


proc print data=mercedes_monthly (obs=10);
run;

proc sort data=mercedes_monthly;
by date;
run;


proc arima data=mercedes_monthly;
identify var= close;
run;

proc arima data=mercedes_monthly;
identify var= close(1);
run;

data mercedes_monthly;
	set mercedes_monthly;
	log_close = log(close);
	run;
	

proc arima data=mercedes_monthly;
identify var =log_close(2);
run;

proc arima data=mercedes_monthly;
identify var =log_close(2);
estimate p=1 q=1;
run;


proc arima data=mercedes_monthly; /*best model 2,2,1*/
identify var =log_close(1);
estimate p=2 q=1;
run;


proc arima data=mercedes_monthly;
identify var =log_close(2);
estimate p=1 q=2;
run;


proc arima data=mercedes_monthly;
identify var =log_close(2);
estimate p=2 q=2;
run;


proc arima data=mercedes_monthly;
identify var =log_close(2);
estimate p=0 q=1;
run;


proc arima data=mercedes_monthly;
identify var =log_close(2);
estimate p=1 q=0;
run;

proc arima data=mercedes_monthly;
    identify var=log_close(2);
    estimate p=2 q=1;
    forecast lead=12 interval=day id=date out=forecast_log;
run;
quit;

proc print data=forecast_log;
run;

proc sgplot data=forecast_log;
    series x=date y=log_close / lineattrs=(color=blue) legendlabel="Actual";
    series x=date y=forecast / lineattrs=(color=red) legendlabel="Forecast";
    band x=date lower=l95 upper=u95 / transparency=0.5 legendlabel="95% CI";
    xaxis label="Date";
    yaxis label="Log Monthly Close";
    keylegend / location=inside position=topright across=1;
run;

data train test;
    set mercedes_monthly nobs=n;
    if _N_ <= (n - 12) then output train;
    else output test;
run;


proc arima data=train;
    identify var=log_close(2);
    estimate p=2 q=1;
    forecast lead=12 interval=month id=date out=forecast_test;
run;
quit;

data test_eval;
    merge test forecast_test(rename=(forecast=forecast_log));
    by date;
    error = log_close - forecast_log;
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=test_eval mean stddev;
    var abs_error sq_error;
run;

proc sql;
  select mean(abs_error) as MAE,
         mean(sq_error) as MSE,
         sqrt(mean(sq_error)) as RMSE
  from accuracy;
quit;




/****************************apple******************************/

proc import datafile="/home/u64151948/MM711 2025/assessment/dissertation/apple_final.csv"
out= apple
dbms = csv;
run;

proc contents data=apple; 
run;

proc sort data=apple;
    by date;
run;

proc sgplot data=apple;
    series x=date y=close;
    xaxis label="day";
    yaxis label="apple ";
run;

proc arima data=apple;
    identify var=close stationarity=(adf);
run;
quit;

proc arima data=apple;
    identify var= close(2);
run;
quit;


/* arima (1,1,1) */
proc arima data=apple;
    identify var=close(2);
    estimate p=1 q=1;
run;
quit;

/*  ARIMA(0,1,1) */
proc arima data=apple;
    identify var=close(2);
    estimate p=1 q=2;
run;
quit;

/*  ARIMA(1,1,0) */
proc arima data=apple;
    identify var=close(2);
    estimate p=2 q=1;
run;
quit;

/*  ARIMA(2,2,2) */
proc arima data=apple;
    identify var=close(2);
    estimate p=2 q=2;
run;
quit;


/*  ARIMA(1,1,2) */
proc arima data=apple;
    identify var=close(2);
    estimate p=1 q=2;
run;
quit;

/*  ARIMA(2,1,1) */
proc arima data=apple;
    identify var= close(2);
    estimate p=2 q=1;
run;
quit;

proc arima data=apple;
    identify var=close(2);
    estimate p=2 q=2;
    forecast lead=12 interval=day id=date out=forecast_out;
run;
quit;

proc sgplot data=forecast_out;/*forecast*/
    series x=date y=close / lineattrs=(color=blue) legendlabel="Actual";
    series x=date y=forecast / lineattrs=(color=red) legendlabel="Forecast";
    band x=date lower=l95 upper=u95 / fill transparency=0.5 legendlabel="95% CI";
    xaxis label="Month";
    yaxis label="Tesla Monthly Close";
    keylegend / location=inside position=topright across=1;
run;

/*Log-Transformed Variable*/

data apple_log;
    set apple;
    log_close = log(close);
run;

proc sgplot data=apple_log;
series x=date y=log_close;
run;

proc arima data=apple_log;
identify var=log_close;
run;

proc arima data=apple_log;
identify var=log_close(1);
run;

proc arima data=apple_log;
    identify var=log_close stationarity=(adf);
run;
quit;

proc arima data=apple_log;
identify var=log_close(1);
estimate p=1 q=1;
run;

/* ARIMA(0,1,1) */
proc arima data=apple_log;
    identify var=log_close(1);
    estimate p=0 q=1;
run;
quit;

/* ARIMA(1,1,0) */
proc arima data=apple_log;
    identify var=log_close(1);
    estimate p=1 q=0;
run;
quit;

/* ARIMA(2,1,2) */ --- /*best*/
proc arima data=apple_log;
    identify var=log_close(1);
    estimate p=2 q=2;
run;
quit;

/* ARIMA(1,1,2) */
proc arima data=apple_log;
    identify var=log_close(1);
    estimate p=1 q=2;
run;
quit;

/* ARIMA(2,1,1) */
proc arima data=apple_log;
    identify var=log_close(1);
    estimate p=2 q=1;
run;
quit;

/* Forecast */
proc arima data=apple_log;
    identify var=log_close(1);
    estimate p=2 q=1;
    forecast lead=12 interval=day id=date out=forecast_log;
run;
quit;

proc sgplot data=forecast_log;
    series x=date y=log_close / lineattrs=(color=blue) legendlabel="Actual";
    series x=date y=forecast / lineattrs=(color=red) legendlabel="Forecast";
    band x=date lower=l95 upper=u95 / fill transparency=0.5 legendlabel="95% CI";
    xaxis label="Month";
    yaxis label="Log Monthly Close";
    keylegend / location=inside position=topright across=1;
run;


/* hold out method*/

data tesla_train tesla_test;
    set apple_log nobs=n;
    if _N_ <= 55 then output tesla_train;
    else output tesla_test;
run;

proc arima data=tesla_train;
    identify var=log_close(2);
    estimate p=2 q=1;
    forecast lead=10 interval=day id=date out=forecast_holdout;
run;
quit;

data holdout_eval;
    merge forecast_holdout (in=f) tesla_test (in=t keep=date log_close);
    by date;
    if f and t;
run;

proc sgplot data=holdout_eval;
    series x=date y=log_close / lineattrs=(color=blue) legendlabel="Actual (Log)";
    series x=date y=forecast / lineattrs=(color=red) legendlabel="Forecast (Log)";
    band x=date lower=l95 upper=u95 / transparency=0.5 legendlabel="95% CI (Log)";
    xaxis label="Month";
    yaxis label="Log Close Price";
    keylegend / location=inside position=topright across=1;
run;

data accuracy;
    set holdout_eval;
    error = log_close - forecast;
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=accuracy mean;
    var abs_error sq_error;
run;





/*final forecast*/

data forecast_log_exp;
    set forecast_log;
    forecast_price = exp(forecast);
run;

data forecast_log_exp;
    set forecast_log;
    forecast_price = exp(forecast);
    actual_price = exp(log_close); 
run;


proc sgplot data=forecast_log_exp;
    series x=date y=actual_price / lineattrs=(color=blue) legendlabel="Actual Price";
    series x=date y=forecast_price / lineattrs=(color=red) legendlabel="Forecasted Price";
    xaxis label="Month";
    yaxis label="Tesla Monthly Close (Original Scale)";
    keylegend / location=inside position=topright across=1;
run;

/******************* apple with sentinment********************/

proc print data= apple;
run;

proc arima data=apple_log; /****** issue with correlation between the estimate parameters**/
    identify var= log_Close(1) minic crosscorr=Finbert_Edited(1);
    estimate p=2 q=2 input=(Finbert_Edited);
    forecast lead=30 out=sentinment_forecast;
run;



proc arima data=apple;/****** change alpha to 10 % *****/
    identify var= Close(1,12) minic crosscorr=Finbert_Edited(1,12);
    estimate q=(3)(12) input=(Finbert_Edited);
    forecast lead=30 out=sentinment_forecast;
run;


proc arima data=apple;/****** change alpha to 10 % without sentinment *****/
    identify var= Close(1,12);
    estimate q=(3)(12);
    forecast lead=30 out=sentinment_forecast;
run;

proc arima data=apple;/* good at 5% ----- best model*/
    identify var= Close(1,12) minic crosscorr=Finbert_Edited(1,12);
    estimate q=(12) input=(Finbert_Edited);
    forecast lead=30 out=sentinment_forecast;
run;


proc arima data=apple;/****** change alpha to 10 % without sentinment *****/
    identify var= Close(1,12);
    estimate q=(12);
    forecast lead=30 out=sentinment_fore;
run;



data eval_metrics;
    set sentinment_forecast;
    error = close - forecast;    
    abs_error = abs(error);          
    sq_error = error**2;              
run;

proc means data=eval_metrics mean;
    var abs_error sq_error;
    output out=metrics_summary mean=MAE MSE;
run;

data rmse;
    set metrics_summary;
    RMSE = sqrt(MSE);
run;

/*without*/
data eval_metrics;
    set sentinment_fore;
    error = close - forecast;    
    abs_error = abs(error);          
    sq_error = error**2;              
run;

proc means data=eval_metrics mean;
    var abs_error sq_error;
    output out=metrics_summary mean=MAE MSE;
run;

data rmse;
    set metrics_summary;
    RMSE = sqrt(MSE);
run;

/* Comparison of Forecasting Models with and without Sentiment */

/* The first result (MAE = 2.1708, MSE = 9.2494, RMSE = 3.0412) is from the model WITH sentiment input */
/* The second result (MAE = 2.1710, MSE = 9.2502, RMSE = 3.0414) is from the model WITHOUT sentiment */

/* The model WITH sentiment is slightly better in all error metrics (MAE, MSE, RMSE), 
   though the difference is marginal. 
   This suggests that sentiment contributes positively to forecast accuracy. */
/* Comparison of Forecasting Models with and without Sentiment */

/* The first result (MAE = 2.1708, MSE = 9.2494, RMSE = 3.0412) is from the model WITH sentiment input */
/* The second result (MAE = 2.1710, MSE = 9.2502, RMSE = 3.0414) is from the model WITHOUT sentiment */

/*  The model WITH sentiment is slightly better in all error metrics (MAE, MSE, RMSE), 
   though the difference is marginal. 
   This suggests that sentiment contributes positively to forecast accuracy. */


/*************************** varmax******************************/
proc sort data=apple;
    by date;
run;

proc arima data= apple;
identify var=close(1);
run;
proc arima data=apple;
    identify var=close(2) stationarity=(adf);
run;

proc arima data=apple;
    identify var=finbert_edited(2) stationarity=(adf);
run;

data apple_diff2;
    set apple;
    dd_close = dif(close); /* 2nd difference of close */
    dd_sentiment = dif(finbert_edited); /* 2nd difference of sentiment */
run;

data apple_diff;
    set apple_diff2;
    if nmiss(of dd_close dd_sentiment) = 0;
run;

proc varmax data=apple;
    model close finbert_edited / p=1 q=0;
    output out=with lead=30;
run;


proc print data =with;
run;

proc varmax data=apple;
    model close / p=1 q=0;
    output out=without lead=30;
run;


/* For model WITH sentiment */
data eval_with;
    set with;
    error = close - for1;      
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=eval_with mean;
    var abs_error sq_error;
    output out=metrics_with mean=MAE MSE;
run;

data rmse_with;
    set metrics_with;
    RMSE = sqrt(MSE);
run;

proc sql;
  select mean(abs_error) as MAE,
         mean(sq_error) as MSE,
         sqrt(mean(sq_error)) as RMSE
  from eval_with;
quit;


/* For model WITHOUT sentiment */
data eval_without;
    set without;
    error = close - for1;
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=eval_without mean;
    var abs_error sq_error;
    output out=metrics_without mean=MAE MSE;
run;

data rmse_without;
    set metrics_without;
    RMSE = sqrt(MSE);
run;

proc sql;
  select mean(abs_error) as MAE,
         mean(sq_error) as MSE,
         sqrt(mean(sq_error)) as RMSE
  from eval_without;
quit;


/* VARMAX Model Evaluation:

   This comparison assesses the forecasting performance of two VARMAX models:
   1. Model with sentiment (close + finbert_edited)
   2. Model without sentiment (only close)

   Results:
   - With Sentiment:    RMSE = 2.9803, MSE = 8.8823, MAE = 2.1122
   - Without Sentiment: RMSE = 2.9826, MSE = 8.8960, MAE = 2.1106

   Interpretation:
   The model including sentiment scores shows a slightly lower RMSE and MSE.
   Although the improvement is marginal, it suggests sentiment may add small value to forecasting accuracy.
*/

/**************tesla varmax/***************/

data tesla_d;
    set tesla;
    d_close = dif(close); /* 2nd difference of close */
run;

proc varmax data=tesla_d;
    model d_close / p=1 q=0;
    output out=without lead=30;
run;


proc print data=without;
run;

/* For model WITHOUT sentiment */
data eval_without;
    set without;
    error = price - for1;
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=eval_without mean;
    var abs_error sq_error;
    output out=metrics_without mean=MAE MSE;
run;

data rmse_without;
    set metrics_without;
    RMSE = sqrt(MSE);
run;





/*************** mercedes Varmax**************/

proc varmax data= stock_data;
model close / p=1 q=0;
output out=without lead=30;
run;

data eval_without;
    set without;
    error = close - for1;
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=eval_without mean;
    var abs_error sq_error;
    output out=metrics_without mean=MAE MSE;
run;

data rmse_without;
    set metrics_without;
    RMSE = sqrt(MSE);
run;

proc sql;
  select mean(abs_error) as MAE,
         mean(sq_error) as MSE,
         sqrt(mean(sq_error)) as RMSE
  from eval_without;
quit;



/********************************microsoft**********************/


proc import datafile="/home/u64151948/MM711 2025/assessment/dissertation/microsoft_final.csv"
out= micro
dbms = csv;
run;

proc contents data=micro; 
run;

proc sort data=micro;
    by date;
run;

proc sgplot data=micro;
    series x=date y=close;
    xaxis label="day";
    yaxis label="apple ";
run;


/*Log-Transformed Variable*/

data micro;
    set micro;
    log_close = log(close);
run;

proc sgplot data=micro;
series x=date y=log_close;
run;

proc arima data=micro;
identify var=log_close;
run;

proc arima data=micro;
identify var=log_close(1);
run;

proc arima data=micro;
    identify var=log_close stationarity=(adf);
run;
quit;

proc arima data=micro;/****best***/
identify var=log_close(1);
estimate p=1 q=1;
run;

/* ARIMA(0,1,1) */
proc arima data=micro;
    identify var=log_close(1);
    estimate p=0 q=1;
run;
quit;

/* ARIMA(1,1,0) */
proc arima data=apple_log;
    identify var=log_close(1);
    estimate p=1 q=0;
run;
quit;


/* ARIMA(1,1,2) */
proc arima data=micro;
    identify var=log_close(1);
    estimate p=1 q=2;
run;
quit;

/* ARIMA(2,1,1) --- best model*/
proc arima data=micro;
    identify var=log_close(1);
    estimate p=2 q=1;
run;
quit;

/* Forecast */
proc arima data=micro;
    identify var=log_close(2);
    estimate p=1 q=1;
    forecast lead=30 interval=day id=date out=forecast_log;
run;
quit;

proc sgplot data=forecast_log;
    series x=date y=log_close / lineattrs=(color=blue) legendlabel="Actual";
    series x=date y=forecast / lineattrs=(color=red) legendlabel="Forecast";
    band x=date lower=l95 upper=u95 / fill transparency=0.5 legendlabel="95% CI";
    xaxis label="Month";
    yaxis label="Log Monthly Close";
    keylegend / location=inside position=topright across=1;
run;


/* hold out method*/

data tesla_train tesla_test;
    set micro nobs=n;
    if _N_ <= 55 then output tesla_train;
    else output tesla_test;
run;

proc arima data=tesla_train;
    identify var=log_close(1);
    estimate p=1 q=1;
    forecast lead=10 interval=day id=date out=forecast_holdout;
run;
quit;

data holdout_eval;
    merge forecast_holdout (in=f) tesla_test (in=t keep=date log_close);
    by date;
    if f and t;
run;

proc sgplot data=holdout_eval;
    series x=date y=log_close / lineattrs=(color=blue) legendlabel="Actual (Log)";
    series x=date y=forecast / lineattrs=(color=red) legendlabel="Forecast (Log)";
    band x=date lower=l95 upper=u95 / transparency=0.5 legendlabel="95% CI (Log)";
    xaxis label="Month";
    yaxis label="Log Close Price";
    keylegend / location=inside position=topright across=1;
run;

data accuracy;
    set holdout_eval;
    error = log_close - forecast;
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=accuracy mean;
    var abs_error sq_error;
run;





/*final forecast*/

data forecast_log_exp;
    set forecast_log;
    forecast_price = exp(forecast);
run;

data forecast_log_exp;
    set forecast_log;
    forecast_price = exp(forecast);
    actual_price = exp(log_close); 
run;


proc sgplot data=forecast_log_exp;
    series x=date y=actual_price / lineattrs=(color=blue) legendlabel="Actual Price";
    series x=date y=forecast_price / lineattrs=(color=red) legendlabel="Forecasted Price";
    xaxis label="Month";
    yaxis label="Tesla Monthly Close (Original Scale)";
    keylegend / location=inside position=topright across=1;
run;

/********************* with sentinment*********************************/
proc arima data=micro;
    identify var=log_Close crosscorr=Finbert_Edited;
    estimate p=1 q=1 input=(Finbert_Edited);
    forecast lead=30 out=arimax_forecast;
run;

proc arima data=micro;
    identify var=log_Close(1) crosscorr=Finbert_Edited(1);
    estimate p=1 q=0 input=(Finbert_Edited);
    forecast lead=30 out=arimax_forecast;
run;


proc arima data=micro;
    identify var=log_Close(1) crosscorr=Finbert_Edited(1);
    estimate p=1 q=1 input=(Finbert_Edited);
    forecast lead=30 out=arimax_forecast;
run;

/*****************microsoft****************/
proc arima data=micro;
    identify var=Close(1) crosscorr=Finbert_Edited(1);
    estimate q=(1)(9) input=(Finbert_Edited);
    forecast lead=30 out=arimax_forecast;
run;

proc arima data=micro;
    identify var=Close(1);
    estimate q=(1)(9);
    forecast lead=30 out=arimax;
run;





data eval_metrics;
    set arimax_forecast;
    error = close - forecast;    
    abs_error = abs(error);          
    sq_error = error**2;              
run;

proc means data=eval_metrics mean;
    var abs_error sq_error;
    output out=metrics_summary mean=MAE MSE;
run;

data rmse;
    set metrics_summary;
    RMSE = sqrt(MSE);
run;


data eval_metrics;
    set arimax;
    error = close - forecast;    
    abs_error = abs(error);          
    sq_error = error**2;              
run;

proc means data=eval_metrics mean;
    var abs_error sq_error;
    output out=metrics_summary mean=MAE MSE;
run;

data rmse;
    set metrics_summary;
    RMSE = sqrt(MSE);
run;

/* The following metrics compare models with and without sentiment input.
   Based on the results:

   - Model with sentiment:
       MAE = 3.709748274
       MSE = 25.921569163
       RMSE = 5.0913229285

   - Model without sentiment:
       MAE = 3.7099161604
       MSE = 25.926720122
       RMSE = 5.0918287601

   Conclusion:
   The model **with sentiment input** shows slightly better performance across all error metrics
   (MAE, MSE, RMSE). Therefore, sentiment scores provide marginal improvement in forecasting accuracy.
*/



data micro_diff;
    set micro;
    dd_close = dif(close); /* 2nd difference of close */
    dd_sentiment = dif(finbert_edited); /* 2nd difference of sentiment */
run;

data micro_diff;
    set micro_diff;
    if nmiss(of dd_close dd_sentiment) = 0;
run;

proc varmax data=micro_diff;
    model dd_close dd_sentiment / p=1 q=0;
    output out=with_mi lead=30;
run;

proc varmax data=micro;
    model close finbert_edited / p=1 q=0;
    output out=with_mi lead=30;
run;


proc print data =with;
run;

proc varmax data=micro;
    model close  / p=1 q=0;
    output out=without_mi lead=30;
run;


/* For model WITH sentiment */
data eval_with_mi;
    set with_mi;
    error = close - for1;      
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=eval_with_mi mean;
    var abs_error sq_error;
    output out=metrics_with mean=MAE MSE;
run;

data rmse_with;
    set metrics_with;
    RMSE = sqrt(MSE);
run;


/* For model WITHOUT sentiment */
data eval_without_mi;
    set without_mi;
    error = close - for1;
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=eval_without_mi mean;
    var abs_error sq_error;
    output out=metrics_without mean=MAE MSE;
run;

data rmse_without;
    set metrics_without;
    RMSE = sqrt(MSE);
run;

/* 
Comparison of VARMAX Model Performance:

The first set of metrics corresponds to the VARMAX model using only the stock price (close). 
The second set of metrics includes both stock price (close) and sentiment score (finbert_edited).

Results:
- Without Sentiment:
    MAE  = 3.7190
    MSE  = 26.1880
    RMSE = 5.1174

- With Sentiment:
    MAE  = 3.7178
    MSE  = 25.8393
    RMSE = 5.0832

Conclusion:
Incorporating sentiment into the VARMAX model slightly improved the forecasting accuracy, 
as seen from lower MAE, MSE, and RMSE values. Although the improvement is marginal, it 
demonstrates the potential of combining financial news sentiment with historical prices 
for more informed stock forecasting.
*/



proc ucm data=micro;
	model log_close = finbert_edited;
    level;
    forecast lead=30 out= sm_forecast;
run;

data eval_sm;
    set sm_forecast;
    error = log_close - forecast;
    abs_error = abs(error);
    sq_error = error**2;
run;

proc means data=eval_sm mean;
    var abs_error sq_error;
    output out=metrics_sm mean=MAE MSE;
run;


data rmse_sm;
set metrics_sm;
rmse = sqrt(mse);
run;











