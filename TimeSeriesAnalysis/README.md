# Time Series Analysis 

This is a repo constructed for the study of Time Series Analysis. Thanks to [NIST](https://www.itl.nist.gov/div898/handbook/pmc/section4/pmc4.htm) and some other online sources. All theories parts will be put in this markdown file, and some other [examples](https://github.com/YuZhangIsCoding/StatsBasics/tree/master/TimeSeriesAnalysis/examples) will illustrate how to conduct time series analysis in python and R.

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
    
Smoothing reduces or cancel the effect due to random variation, and when properly applied, reveals more clearly the underlying trend, seasonal and cyclic components. Methods including **Averaging Methods** and **Exponential Smoothing Methods**

* Simple Average:

    * The "simple" average or mean of all past observations is only a useful estimate for forecasting when there are no trends or seasonality.
    * The average "weighs" all past observations equally. 

* Single Moving Average:
        
    Compute the mean of successive smaller sets of numbers of past data.

    **This method is best for volatile data with no trend or seasonality. It results in a straight, flat-line forecast.**

* Centered Moving Average:

    The previous moving average works well for odd time perids, but not so good for even time periods. If we avaerage an **even number of terms**, we need to smooth the smoothed values!

* Double Moving Averages for a Linear Trend Process

    Neither the mean nor the moving average of the most recent M values are able to cope with a significant trent when used as forcasts for the next period.

    This method calculates a second moving average from the original moving average, using the same value for M. As soon as both single and double moving averages are available, a computer routine uses these averages to compute a slope and intercept, and then forecasts one or more periods ahead.

    **This method is best for historical data with a trend but no seasonality. It results in a straight, sloped-line forecast.**

    (Personal understanding: this smoothing method assumes a linear trend for the moving average, and calculate the slope and intercept)

## Exponential Smoothing

Instead of weighing observations equally, Exponential Smoothing assigns **exponentially decreasing weights** as the observation get older. In other words, recent observations are given relatively more weight in forecasting than the older observations.

* Single Exponential Smoothing

    For any time period t, the smoothed value S<sub>t</sub> is found by computing 

    <img src="http://latex.codecogs.com/svg.latex?S_t={\alpha}y_{t-1}+(1-\alpha)S_{t-1}\qquad0<\alpha\le1{\quad}t\ge3"/>

    where y stands for the original observation, and &alpha; is called the smoothing constant. This smoothing scheme begins with the smoothed version of the second observation by setting S<sub>2</sub> to y<sub>1</sub>.

    **Note**: there's an alternative appraoch to exponential smoothing that replaces y<sub>t-1</sub> with y<sub>t</sub> introduced in [Exponentially Weighted Moving Average (EWMA) control charts](https://www.itl.nist.gov/div898/handbook/pmc/section3/pmc324.htm) by Roberts(1959)

    * Setting the first EWMA

        The initial EWMA plays an important role in computing all the subsequent EWMAs. One way as illustrated above is to set it to y<sub>1</sub>. Another way is to set it to the target of the process. Still another possibility would be to average the first few observations.

        * The smaller the value of &alpha;, the more important is the selection of the initial EWMA. The user would be wise to try a few methods before finalizing the settings.

    * Why is it called "Exponential":

        By substituding S<sub>t-1</sub> for S<sub>t</sub> and so forth, untial reach S<sub<2</sub>, we have:

        <img src="https://latex.codecogs.com/svg.latex?S_t=\alpha\sum_{i=1}^{t-2}(1-\alpha)^{i-1}y_{i-1}+(1-\alpha)^{t-2}S_2{\qquad}t\ge2"/>

        This illustrates the exponential behavior. The weights decrease geometrically and their sum is unity.

    * What is the "best" value for &alpha;

        When &alpha; is close to 1, dampening is quick and when &alpha; is close to 0, dampening is slow.

        Choose the best value for &alpha so the value which results in the smallest mean squared error(MSE).

        Methods like trial-and-error iteratively or use nonlinear optimizer that minimizes the sum of squares of residuals, like [Marquardt](https://en.wikipedia.org/wiki/Levenberg%E2%80%93Marquardt_algorithm).

    * Forecasting with single exponential smoothing

        From the basic equation:

        <img src="https://latex.codecogs.com/svg.latex?S_{t+1}={\alpha}y_{t}+(1-\alpha)S_{t}"/>

        This can be written as:
    
        <img src="https://latex.codecogs.com/svg.latex?S_{t+1}=S_t+\alpha\epsilon_t"/>

        where &epsilon;<sub>t</sub> is the forecast error (actual - forecast) for period t. In other words, the new forecast is the old one plus an adjustment for the error that occurred in the last forecast.

    * Bootstrapping of Forecasts

        Wish to forecast from some origin, usually the last data point, and no actual observations are available.

        <img src="https://latex.codecogs.com/svg.latex?S_{t+1}={\alpha}y_{origin}+(1-\alpha)S_t"/>

        where y<sub>origin</sub> remain constant.

    **This method, which results in a straight, flat-line forecast is best for volatile data with no trend or seasonality. The single coefficient &alpha; is not enough**

* Double Exponential Smoothing

    The single exponential smoothing could be improved by the introduction of a second equation with a second constant &gamma;, which must be chosen in conjuction with &alpha;.

    The method supports trends that change in different ways: an **additive** and a **multiplicative** depending on whether the trend is linear or exponential repectively.
    
    * Additive trend, also know as *Holt's linear trend model*: double exponential with a linear trend
    
        <img src="https://latex.codecogs.com/svg.latex?S_{t}={\alpha}y_{t}+(1-\alpha)(S_{t-1}+b_{t-1})"/>&nbsp;

        <img src="https://latex.codecogs.com/svg.latex?b_{t}={\gamma}(S_t-S_{t-1})+(1-\gamma)b_{t-1}"/>

        The first smoothing equation adjusts S<sub>t</sub> directly for the trend of the previous period, b<sub>t-1</sub>, by adding it to the last smoothed value, S<sub>t-1</sub>. This helps to eliminate the lag and brings S<sub>t</sub> to the appropriate base of the current value.

        The second smoothing equation then updates the trend, which is expressed as the difference between the last two values. This equation is similar to the basic form of single smoothing, but here applied to the updating of the trend.

        * Initial values:
        
            S<sub>1</sub> is in general set to y<sub>1</sub>.

            There are three suggestions for b<sub>1</sub>:

            1. b1 = y2-y1
            2. b1 = ((y2-y1)+(y3-y2)+(y4-y3))/3
            3. b1 = (yn-y1)/(n-1) 

            The values for &alpha; and &gamma; can be obtained via non-linear optimization techniques, such as the Marqartdt Algorithm.

        * Forecasting with Double Exponential Smoothing(LASP)

            The one-period-ahead forecast is given by:

            <img src="https://latex.codecogs.com/svg.latex?F_{t+1}=S_t+b_t"/>

            The m-periods-ahead forecast is given by:
    
            <img src="https://latex.codecogs.com/svg.latex?F_{t+m}=S_t+mb_t"/>

        * Compare with Linear Regression

            If it is desired to portray the growth process in a more **aggressive** manner, then one selects double smoothing. Otherwise, regression may be preferable. It should be noted that in linear regression "time" functions as the independent variable.

    * Multiplicative trend
    
        <img src="https://latex.codecogs.com/svg.latex?S_{t}={\alpha}y_{t}+(1-\alpha)(S_{t-1}R_{t-1})"/>&nbsp;

        <img src="https://latex.codecogs.com/svg.latex?R_{t}={\gamma}(S_t/S_{t-1})+(1-\gamma)R_{t-1}"/>

        The method can be described as modelling the trend in a multiplicative way because the forecasts are formed from the product of the level and growth rate. A logarithmic transformation is sometimes used to convert a multiplicative trend into an additive trend.
        
        * Forcast m periods ahead
        
            <img src="https://latex.codecogs.com/svg.latex?F_{t+m}=S_tR_t^m"/>
        
* Damped trend smoothing

    For long range (multi-step) forecasts, the trend may continue on unrealistically. Even more extreme are the forcasts generated by the exponential trend method. As such, it can be useful to dampen the trend over time.
    
    A damping coefficient &phi; is used to control the rate of dampening.
    
    * Additive dampening: dampen a trend linearly
    
        <img src="https://latex.codecogs.com/svg.latex?S_{t}={\alpha}y_{t}+(1-\alpha)(S_{t-1}+\{\phi}b_{t-1})"/>&nbsp;

        <img src="https://latex.codecogs.com/svg.latex?b_{t}={\gamma}(S_t-S_{t-1})+(1-\gamma)\{\phi}b_{t-1}"/>&nbsp;
        
        <img src="https://latex.codecogs.com/svg.latex?F_{t+m}=S_t+\sum\limits_{i=1}^m\phi^ib_t"/>
    
    * Multiplicative dampening: dampen the trend exponentially
    
        <img src="https://latex.codecogs.com/svg.latex?S_{t}={\alpha}y_{t}+(1-\alpha)(S_{t-1}R_{t-1}^\phi)"/>&nbsp;

        <img src="https://latex.codecogs.com/svg.latex?R_{t}={\gamma}(S_t/S_{t-1})+(1-\gamma)R_{t-1}^\phi"/>&nbsp;
        
        <img src="https://latex.codecogs.com/svg.latex?F_{t+m}=S_tR_t^{\sum\limits_{i=1}^m\phi^i}"/>

* Triple Exponential Smoothing, also called *Holt-Winter Exponential Smoothing*

    What happens if the data show trend and seasonality?

    Introduce a third equation to take care of seasonality/periodicity. The resulting set of equation is called the "Holt-Winners"(HW) method after the names of the inventors. The seasonality could also be modeled as either additive or multiplicative

    * Multiplicative seasonality

        <img src="https://latex.codecogs.com/svg.latex?S_{t}={\alpha}\frac{y_t}{I_{t-L}}+(1-\alpha)(S_{t-1}+b_{t-1})"/>&nbsp;
    
        <img src="https://latex.codecogs.com/svg.latex?b_{t}={\gamma}(S_t-S_{t-1})+(1-\gamma)b_{t-1}"/>&nbsp;
    
        <img src="https://latex.codecogs.com/svg.latex?I_{t}={\beta}\frac{y_t}{S_t}+(1-\beta)I_{t-L}"/>&nbsp;
    
        <img src="https://latex.codecogs.com/svg.latex?F_{t+m}=(S_t+mb_t)I_{t-L+m}"/>

        where *F* is the forecast at m periods ahead, *I* is the seasonal index, *b* is the trend factor, *S* is the smoothed observation. And &alpha;, &beta;, &gamma; are constants that must be estimated in such a way that the MSE is minimized. L is the number of periods in a complete season's data.

        * Initial values

            To initialize the HW method, we need **at least** one complete season's data to determine initial estimates of the seasonal indices I<sub>t-L</sub>. And to estimate the trend factor from one period to the next, it is advisable to use two complete seasons; that is 2L periods.

        * The general formula to estimate the initial trend is given by

            <img src="https://latex.codecogs.com/svg.latex?b=\frac{1}{L}\bigg(\frac{y_{L+1}-y_1}{L}+\frac{y_{L+2}-y_2}{L}+\dots+\frac{y_{L+L}-y_L}{L}\bigg)"/>

        * Seasonal Indices: 6 years with 4 quarters per year for example

            **Step 1**: compute the average of each of the 6 years

            <img src="https://latex.codecogs.com/svg.latex?A_p=\frac{\sum_{i=1}^{4}y_i}{4},{\qquad}p=1,2,\dots,6"/>

            **Step 2**: divide the observations by the appropriate yearly mean

            |1|2|3|4|5|6
            |-|-|-|-|-|-|
            |y<sub>11</sub>/A<sub>1</sub>|y<sub>21</sub>/A<sub>2</sub>|...|...|...|y<sub>61</sub>/A<sub>6</sub>|
            |...|...|...|...|...|...|
            |y<sub>14</sub>/A<sub>1</sub>|y<sub>24</sub>/A<sub>2</sub>|...|...|...|y<sub>64</sub>/A<sub>6</sub>|

            **Step 3**: the seasonal indices are formed by computing the average of each row:

            <img src="https://latex.codecogs.com/svg.latex?I_1=(y_{11}/A_1+y_{21}/A_2+y_{31}/A_3+y_{41}/A_4+y_{51}/A_5+y_{61}/A_6)"/>

            <img src="https://latex.codecogs.com/svg.latex?I_2=(y_{12}/A_1+y_{22}/A_2+y_{32}/A_3+y_{42}/A_4+y_{52}/A_5+y_{62}/A_6)"/>

            <img src="https://latex.codecogs.com/svg.latex?I_3=(y_{13}/A_1+y_{23}/A_2+y_{33}/A_3+y_{43}/A_4+y_{53}/A_5+y_{63}/A_6)"/>

            <img src="https://latex.codecogs.com/svg.latex?I_4=(y_{14}/A_1+y_{24}/A_2+y_{34}/A_3+y_{44}/A_4+y_{54}/A_5+y_{64}/A_6)"/>
            
    * Additive seasonality
    
        <img src="https://latex.codecogs.com/svg.latex?S_{t}={\alpha}(y_t-I_{t-L})+(1-\alpha)(S_{t-1}+b_{t-1})"/>&nbsp;
    
        <img src="https://latex.codecogs.com/svg.latex?b_{t}={\gamma}(S_t-S_{t-1})+(1-\gamma)b_{t-1}"/>&nbsp;
    
        <img src="https://latex.codecogs.com/svg.latex?I_{t}={\beta}(y_t-S_t)+(1-\beta)I_{t-L}"/>&nbsp;
    
        <img src="https://latex.codecogs.com/svg.latex?F_{t+m}=S_t+mb_t+I_{t-L+m}"/>
        
        *Similarily, dampening can be apply to this model*

## Univariate Time Series Models

The term "univariate time series" refers to a time series that consists of single (scalar) observations recorded sequentially over equal time increments.

* Stationarity
    
    A stationary process has the property that the mean, variance and autocorrelation structure do not change over time. In this context, stationarity means a flat looking series, without trend, constant variance over time, a constant autocorrelation structure over time and no periodic fluctuations (seasonality)

    Stationarity can usually be determined from a [run sequence plot](https://en.wikipedia.org/wiki/Run_chart)

    If the time series is not stationary, transformation can be done in following techniques:

    1. Difference the data. Given Z<sub>t</sub>, new series can be created:
        
        Y<sub>i</sub> = Z<sub>i</sub>-Z<sub>i-1</sub>

        The differenced data will contain one less point than the original data. Although you can difference the data more than once, one difference is usually sufficient

    1. If the data contains a trend, we can fit some type of curve to the data and then model the residuals from that fit. A simple fit, such as a straight line, is typically used, since the purpose is to remove long term trend.

    1. For non-constant variance, taking the logarithm or square root of the series may stabilized the variance. For negative data, add a suitable constant to make all the data positive before transformation. This constant should be subtracted from the model when predicting.

* Seasonality

    Seasonality means periodic fluctuations, which is quite common in economic time series, and less common in engineering and scientific data.   

    Following techniques can be used to detect seasonality:

    1. A run sequence plot will often show seasonality

    1. A seasonal subseries plot is a specialized technique for showing seasonality.

        * The seasonal subseries plot is only useful if the period of the seasonality is already known.
        * If the period is not known, an autocorrelation plot or spectral plot can be used to determine it.
        * If there is a large number of observations, then a box plot may be preferable
        * Sometimes, the series will need to be detrended before generating the plot.
        * Could answer questions like: is there a seasonal pattern, what's the nature of seasonality, is there a within-group pattern, are there outliers, etc

    1. Multiple box plots can be used as an alternative to the seasonal subseries plot to detect seasonality

    1. The [autocorrelation plot](https://www.itl.nist.gov/div898/handbook/eda/section3/autocopl.htm) can help identify seasonality

        * If there is significant seasonality, the autocorrelation plot should show spikes at lags equal to the period
        * The autocorrelation plot could also answer questions like: are the data random, is the observed time series white noise, sinusoidal, autoregressive, etc.
        
        **Note**: more about autocorrelation can be found on [this repo](https://github.com/YuZhangIsCoding/improvised/tree/master/AutoCorrelation).

* Common Approaches to Univariate Time Series

    1. Decompose the time series into a trend, seasonal, and residual component.
        * Triple exponential smoothing
        * Seasonal LOESS (locally estimated scatterplot smoothing)

    1. Analyze the series in the frequency domain. The spectral plot is the primary tool for the frequency analysis of time series.
        
    1. Autoregressive (AR) model is a common approach for modeling univariate time series.

    1. Another common approach for modeling univariate time series is the moving average (MA) model
    
    1. Combine both autoregressive and moving average model into ARMA or ARIMA model.

* [Autoregressive model](https://en.wikipedia.org/wiki/Autoregressive_model)

    <img src="https://latex.codecogs.com/svg.latex?X_t=\delta+\phi_1X_{t-1}+\phi_2X_{t-2}+\dots+\phi_pX_{t-p}+A_t"/>

    where *X<sub>t</sub>* is the time series, *A<sub>t</sub>* is white noise, and 

    <img src="https://latex.codecogs.com/svg.latex?\delta=\bigg(1-\sum\limits_{i=1}^{p}\phi_i\bigg)\mu"/>

    An autoregressive model is simply a linear regression of the current value of the series against one or more prior values of the series. The value of *p* is called the order of the AR model.
    
    An autoregressive model can thus be viewed as the output of an all-pole infinite impulse response filter whose input is white noise. And a one-time shock affects values of the evolving variable infinitely far into the future. Because each shock affects X values infinitely far into the future from when they occur, any given value X<sub>t</sub> is affected by shocks occurring infinitely far into the past. Thus, the autoregressive model is not always stationary as it may contain a unit root.
    
    * Choosing the maximum lag
    
        The partial autocorrelation of an AR(p) process is zero at lag p + 1 and greater, so the appropriate maximum lag is the one beyond which the partial autocorrelations are all zero.
        
    * Calculation of AR parameters
        
        Ordinary lease squares procedure or method of moments (through Yule-Walker equations).
        
* [Moving average model](https://en.wikipedia.org/wiki/Moving-average_model#Definition)

    <img src="https://latex.codecogs.com/svg.latex?X_t=\mu+A_t-\theta_1A_{t-1}-\theta_2A_{t-2}-\dots-\theta_qA_{t-q}"/>
 
    where *A<sub>t-i</sub>* are white noise terms, and &theta;<sub>1</sub>, ..., &theta;<sub>q</sub> are the parameters of the model. The value of *q* is called the order of the MA model.

    A moving average model is conceptually a linear regression of the current value of the series against the white noise or random shocks of one or more prior values of the series. The random shocks at each point are assumed to come from the same distribution, typically a normal distribution, with location at zero and constant scale. The distinction in this model is that these random shocks are propogated to future values of the time series. Fitting the MA estimates is more complicated than with AR models because the error terms are not observable. This means that iterative non-linear fitting procedures need to be used in place of linear least squares. MA models also have a less obvious interpretation than AR models.
    
    The moving-average model is essentially a finite impulse response filter applied to white noise. Two main distinctions from autoregressive model:
        
    1. The random shocks are propagated to future values of time series directly.
    1. In the MA model a shock affects X values only for the current period and q periods into the future; in contrast, in the AR model a shock affects X values infinitely far into the future

    * Fitting the model
    
        Fitting the MA estimates is more complicated than it is in autoregressive models (AR models), because the lagged error terms are not observable. This means that iterative non-linear fitting procedures need to be used in place of linear least squares.
        
        The autocorrelation function (ACF) of an MA(q) process is zero at lag q + 1 and greater. Therefore, we determine the appropriate maximum lag for the estimation by examining the sample autocorrelation function to see where it becomes insignificantly different from zero for all lags beyond a certain lag, which is designated as the maximum lag q.
    
    Sometimes the autocorrelation function and partial autocorrelation function will suggest that a MA model would be a better choice and sometimes both AR and MA terms should be used in the same model, which gives Box-Jenkins model.
    
    **Note**: the moving-average model should not be confused with aforementioned moving average method.

* [Box-Jenkins Model](https://en.wikipedia.org/wiki/Box%E2%80%93Jenkins_method)

    A combination of autoregressive model and moving average model.

    <img src="https://latex.codecogs.com/svg.latex?X_t=\delta+\phi_1X_{t-1}+\phi_2X_{t-2}+\dots+\phi_pX_{t-p}+A_t-\theta_1A_{t-1}-\theta_2A_{t-2}-\dots-\theta_qA_{t-q}-q"/>
    
    The model uses an iterative three-stage modeling approach
        
    1. Model identification and model selection:
            
        * Making sure that variables are stationary, identifying seasonality in the dependent series (seasonally differencing it if necessary), and use plots of autocorrelation and partial autocorrelation functions of dependent time series to decide which autoregressive or moving average component should be used.
            
        * Stationarity can be assessed from a run sequence plot. It can also be detected from an autocorrelation plot. Specifically, non-stationarity is often indicated by an autocorrelation plot with very slow decay.
            
        * Identify p and q by [Akaike infomation criterion (AIC)](https://en.wikipedia.org/wiki/Akaike_information_criterion) or the autocorrelation plot and the partial autocorrelation plot.
            
            AIC deals with the trade-off between the goodness of fit of the model and the simplicity of the model, by estimating the infomation lost.
            
            The sample autocorrelation plot and partial autocorrelation plot are compared to the theoretical behavior when the order is known. Specifically, for an AR(1) process, the autocorrelation function should have an exponentially decreasing appearance. However, higher-order AR processes are often a mixture of exponentially decreasing and damped sinusoidal components. And thus the partial autocorrelation plot is needed. And by placing a 95% confidence interval, we can examine the sample partial autocorrelation function to see if there is evidence of a departure from zero. If software does not generate confidence interval, it is approximately <img src="https://latex.codecogs.com/svg.latex?\pm2/\sqrt{N}"/>, with *N* donoting the sample size.
            
            The autocorrelation function of a MA(q) process becomes zero at lag q+1 and greater, so we examine the sample autocorrelation function to see where it essentially becomes zero.
            
            The following table summarizes hwo one can use autocorrelation function for model identification
            
            |Shape|Indicated Model|
            |-|-|
            |Exponential, decaying to zero|AR; use PACF to identify the order of the autoregressive model|
            |Alternating positive adn negative, decaying to zero|AR; use PACF to identify the order of the autoregressive model|
            |One or more spikes, rest are essentially zero|MA, order identified by where plot becomes zero|
            |Decay, starting after a few lags|ARMA|
            |All zero or close to zero|Data are essentially random|
            |High values at fixed intervals|Include seasonal autoregressive term|
            |No decay to zero|Series is not stationary|
            
            Hyndman & Athanasopoulos suggest the following:
            
            * The data may follow an ARIMA(p, d, 0) model if the ACF and PACF of the differenced data show the following patterns:
                
                ACF exponentially decaying or sinusoidal
                
                Significant spike at lag in PACF, but none beyond lag p
            * The data may follow an ARIMA(0, d, q) model:
            
                PACF is exponentially decaying or sinusoidal
                
                Significant spike at lag q in ACF, but none beyond lag q
            
    1. Parameter estimation.
        
        Most common methods use maximum likelihood estimation or non-linear least-squares estimation
        
    1. Model checking 
        
        Test whether the estimated model conforms to the specifications of a stationary univariate process. Plot the mean and variance of residuals over time and performing a [Ljung-Box test](https://en.wikipedia.org/wiki/Ljung%E2%80%93Box_test#Box-Pierce_test) or plotting autocorrelation and partial autocorrelation of the residuals are helpful to identify misspecification. If the estimation is inadequate, we have to return to step one and attempt to build a linear model.

    Some notes:

    * The Box-Jenkins model assumes that the time series is stationary. And it recommend differencing non-stationary series one or more times to achieve stationary. Doing so produces an ARIMA model, with the "I" standing for "Integrated".
    * Some formulation transform the serier by subtracting the mean, which yields a series with a mean of zero.
    * This model can be extended to include seasonal autoregressive and seasonal moving average terms.
    * The most general model includes difference operators, autoregressive terms, moving average terms, seasonal difference operators, seasonal autoregressive terms, and seasonal moving avarage terms.

    Some remarks:
        
    * Box-Jenkins models are quite flexible due to the inclusion of both autoregressive and moving average terms.
    * Chatfield recommends decomposition methods for series in which the trend and seasonal components are dominant.
    * Building good ARIMA models generally requires more experience than commonly used statistical methods such as regression.
    * **effective fitting of Box-Jenkins models requires at least a moderately long series. Chatfield recommends at least 50 observations. Many others would recommend at least 100 observations.**

    The estimation of parameters for Box-Jenkins models is a quite complicated non-linear estimation problem. The main approaches are non-linear least squares and maximum likelihood estimation. Maximum likelihood estimation is generally the preferred technique.

## Multivariate Time Series Models

The multivariate form of the Box-Jenkins univariate models is sometimes called the AutoRegressive Moving Average Vector (ARMAV) model, or simply ARMA process.

The ARMAV mdodel for a stationary multivariate time series, with a zero mean vector, represented by

<img src="http://latex.codecogs.com/svg.latex?x_t=(x_{1t},x_{2t},\dots,x_{nt})^T,\quad-\infty%3Ct%3C\infty"/>

is of the form

<img src="http://latex.codecogs.com/svg.latex?x_t=\phi_1x_{t-1}+\dots+\phi_px_{t-p}+\alpha_t-\theta_1\alpha_{t-1}-\dots-\theta_q\alpha_{t-q}"/>

where 
* x<sub>t</sub> and &alpha;<sub>t</sub> are n &times; 1 column vectors with &alpha;<sub>t</sub> representing multivariate white noise,
* &phi;<sub>k</sub> = {&phi;<sub>k,jj</sub>}, k = 1, 2, ..., p

    &theta;<sub>k</sub> = {&theta;<sub>k,jj</sub>}, k = 1, 2, ..., p
    
    are n &times; n matrices for autoregressive and moving average parameters,
    
* E[a<sub>t</sub>] = 0
* E[a<sub>t</sub>a'<sub>t-k</sub>] = 0, k &ne; 0

    E[a<sub>t</sub>a'<sub>t-k</sub>] = &sum;<sub>&alpha;</sub>, k = 0
    
    where &sum;<sub>&alpha;</sub> is the dispersion or covariance matrix of &alpha;<sub>t</sub>

The estimation of the matrix parameters and covariance matrix is complicated and very difficult without computer software. The estimation of the Moving Average matrices is especially an ordeal. If we opt to ignore the MA component(s) we are left with the [ARV](https://en.wikipedia.org/wiki/Vector_autoregression) model.

## Unevenly-spaced time series

An unevenly (or unequally or irregularly) spaced time series is a sequence of observation time and value pairs (tn, Xn) with strictly increasing observation times

A common approach to analyzing unevenly spaced time series is to transform the data into equally spaced observations using some form of interpolation - most often linear - and then apply existing methods for equally spaced data. However, transforming data in such a way can introduce a number of significant and hard to quantify biases, especially if the spacing of observations is highly irregular.

Python package [Traces](https://traces.readthedocs.io/en/master/) together with Pandas provide some functionalities for the analysis of unevenly spaced time series in their unaltered form.

## [Loess and Seasonoal loess](https://www.itl.nist.gov/div898/handbook/pmd/section1/pmd144.htm)

Locally estimated scatterplot smoothing (LOESS) and locally weighted scatterplot smoothing (LOWESS) is a method for fitting a smooth curve between two variables, for fitting a smooth surface between an outcome and up to four predictor variables.

LOESS combines much of the simplicity of linear least squares regression with the flexibility of nonlinear regression.

The smoothing parameter &alpha; is the fraction of the total number *n* of data points that are used in each local fit. Since a polynomial of degree k requires at least (k+1) points for a fit, the smoothing parameter &alpha;  must be between (&lambda;+1)/n and 1, with &lambda; denoting the degree of the local polynomial.

* &alpha; controls the flexibility of the LOWESS regression function. 

    * If &alpha; is too large, the regression will be over-smoothed, resulting in a loss of information, hence a large bias.
    * If the &alpha; is too small, there will be insufficient data for an accurate fit, resulting in a large variance.

* Degree of local polynomial

    First or second degree is used most often. Using a zero degree polynomial turns LOESS into a weighted moving average. High-degree polynomials would tend to overfit the data in each subset and are numerically unstable, making accurate computations difficult.

* Weight function

    The polynomial is fitted using weighted least squares, giving more weight to points near the point whose response is being estimated and less weight to points further away.

    The traditional weight function used for LOESS is the tri-cube weight function

    <img src="http://www.codecogs.com/svg.latex?w(x)=\big(1-|d|^3\big)^3"/>

    where d is the distance of a given data point from the point on the curve being fitted, scaled to lie in the range between 0 to 1.

* Advantages

    * Do not need the specification of a function to fit a model. Only need the smoothing parameter and degree of local polynomial.
    * Flexible, making it ideal for modeling complex processes for which no theoretical models exist.
    * Simplicity of the method.

* Disadvantages

    * Less efficient use of data than other least squares methods.
    * The regression function not easily represented by mathematical formula, making it difficult to transfer the results to others.
    * Computationally intensive.
