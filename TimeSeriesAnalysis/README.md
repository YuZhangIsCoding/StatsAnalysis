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

        where y<sub>origin</sub> remain constatnt.

    **This method, which results in a straight, flat-line forecast is best for volatile data with no trend or seasonality. The single coefficient &alpha; is not enough**

* Double Exponential Smoothing

    The single exponential smoothing could be improved by the introduction of a second equation with a second constant &gamma;, which must be chosen in conjuction with &alpha;.

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

* Damped trend smoothing (not covered in NIST) contains &alpha;, &beta; and &gamma;

* Triple Exponential Smoothing

    What happens if the data show trend and seasonality?

    Introduce a third equation to take care of seasonality/periodicity. The resulting set of equation is called the "Holt-Winners"(HW) method after the names of the inventors.

    The basic equations are:

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

    **This method is best for data with trend and seasonality that does not increase over time. It results in a curved forecast that shows the seasonal changes in the data**
