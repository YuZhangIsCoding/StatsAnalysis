# Time Series Analysis 

This is a repo constructed for the study of Time Series Analysis. Thanks to [NIST](https://www.itl.nist.gov/div898/handbook/pmc/section4/pmc4.htm) and some other online sources. All theories parts will be put in this markdown file, and some other examples will be illustrated in the jupyter notebook.

## Time Series Analysis
    
* Data points taken over time may have an interval structure (like autocorrelation, trend or seasonal variation)
* Applications:
        
    * Obtain an understanding of the underlying forces and structure that produced the observed data
    * Fit a model and proceed to forecasting, monitoring or even feedback and feedforward control
    * Economic forecasting, sales forecasting, yield Projections
* Techniques:
    * Box-Jenkins ARIMA Models
    * Box-Jenkins Multivariate Models
    * Holt-Winter Exponential Smoothing (single, double, triple)

## Smoothing
    
Smoothing reduces or cancel the effect due to random variation, and when properly applied, reveals more clearly the underlying trend, seasonal and cyclic components.
        
* Averaging Methods
* Exponential Smoothing Methods

* Simple Average:

    * The "simple" average or mean of all past observations is only a useful estimate for forecasting when there are no trends.
    * The average "weighs" all past observations equally. 

* Single Moving Average:
        
Compute the mean of successive smaller sets of numbers of past data.

This method is best for volatile data with no trend or seasonality. It results in a straight, flat-line forecast.

* Centered Moving Average:

The previous moving average works well for odd time perids, but not so good for even time periods. If we avaerage an even number of terms, we need to smooth the smoothed values!

* Double Moving Averages for a Linear Trend Process

Neither the mean nor the moving average of the most recent M values are able to cope with a significant trent when used as forcasts for the next period.

This method calculates a second moving average from the original moving average, using the same value for M. As soon as both single and double moving averages are available, a computer routine uses these averages to compute a slope and intercept, and then forecasts one or more periods ahead.

This method is best for historical data with a trend but no seasonality. It results in a straight, sloped-line forecast.

(Personal understanding: this smoothing method assumes a linear trend for the moving average, and calculate the slope and intercept)

* Exponential Smoothing

Instead of weighing observations equally, Exponential Smoothing assigns exponentially decreasing weights as the observation get older. In other words, recent observations are given relatively more weight in forecasting than the older observations.
