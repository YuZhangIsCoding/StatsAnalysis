# Survival Analysis

This is a repo constructed for the study of survival analysis. Thanks to Wikipedia's page on [Survival Analysis](https://en.wikipedia.org/wiki/Survival_analysis) and Princeton's course on [Generalized Linear Models](http://data.princeton.edu/wws509/notes). All theory part will be put in this markdown file, and some practice examples will be illustrated in a jupyter notebook.

Some basic topic for survival analysis are covered:

* Life tables
* Survival function
* Hazard function
* Accelerated life model
* Propotional hazards regression
* Kaplan-Meier curves
* Log-rank test
* Survival trees and survival random forests

## Survival Analysis
* Survival analysis is a branch of statistics for analyzing the expected time unitl one more events happends.
* Answers Questions such as: what's the proportion of a population which will survive past a centain time? Of those that survived, at what rate will they die or fail?
* Assumes well defined events at specific time
    
    
Definition of common terms:

1. Events: death, disease, ..., events of interest
1. Time: the time from the beginning of an observation to (i) an event, or (ii) end of the study, or (iii) loss of contact.
1. Censoring: a subject does not have an event during the observation time
1. Survival function S(t): the probability that a subject survives longer than t.

## Life table

Summarizes survival data in terms of number of events and the proportion of surviving at each event time point.

Example:

|Time|n.risk|n.event|survival|std.err|lower CI|upper CI|
|-|-|-|-|-|-|-|
|events occurs (not censored)|number of subjects at risk, right before the point of t|events at t|survival function at t|

## Survival function

* T: non-negative random variable representing the waiting time until the occurance of an event
* f(t): probability density function (p.d.f) for continuous random variable T
* F(t): cumulative distribution function (c.d.f), given the probabiliry taht the event has occured by duration t:

    <img src="https://latex.codecogs.com/svg.latex?F(t)=Pr\{T<t\}"/>
    
* Survival function S(t), which gives the probabiliry of being alive just before duration t

    <img src="https://latex.codecogs.com/svg.latex?S(t)=Pr\{T{\ge}t\}=1-F(t)=\int_{t}^{\infty}f(x)dx"/>

## Harzard function

Instantaneous occurance rate of the event

<img src="https://latex.codecogs.com/svg.latex?\lambda(t)=\lim_{dt\to0}\frac{Pr\{t{\le}T<t+dt|T{\ge}t\}}{dt}"/>

The numerator is the condition probability and can be rewrite as:

<img src="https://latex.codecogs.com/svg.latex?Pr\{t{\le}T<t+dt|t{\ge}t\}=\frac{Pr\{t{\le}T<t+dt\&T{\ge}t\}}{Pr\{T{\ge}t\}}=\frac{f(t){\cdot}dt}{S(t)}"/>

The hazard function can be written as:

<img src="https://latex.codecogs.com/svg.latex?\lambda(t)=\frac{f(t)}{S(t)}"/>

And can be rewrite as

<img src="https://latex.codecogs.com/svg.latex?\lambda(t)=-\frac{d}{dt}{\log}S(t)"/>

Given boundary condition that S(0) = 1, integrate the previous equation from 0 to t, we got:

<img src="https://latex.codecogs.com/svg.latex?S(t)=\exp\{-\int_{0}^{t}\lambda(x)d(x)\}"/>

* Cumulative hazard (imagine as the sum of risks from 0 to t)

    <img src="https://latex.codecogs.com/svg.latex?\Lambda(t)=\int_{0}^{t}\lambda(x)d(x)"/>
    
    And the survival function could be expressed as:
    
    <img src="https://latex.codecogs.com/svg.latex?S(t)=\exp(-\Lambda(t))"/>

## Expectation of life

Integral of the survival function

<img src="https://latex.codecogs.com/svg.latex?\mu=\int_{0}^{\infty}tf(t)dt=\int_{0}^{\infty}S(t)dt"/>

Since

<img src="https://latex.codecogs.com/svg.latex?f(t)=-\frac{dS(t)}{dt}"/>

Then

<img src="https://latex.codecogs.com/svg.latex?\int_{0}^{\infty}tf(t)dt=-\int_{0}^{\infty}td(S(t))=-(\int_{0}^{\infty}d(t{\cdot}S(t))-\int_{0}^{\infty}S(t)dt=\int_{0}^{\infty}S(t)dt"/>

So,

<img src="https://latex.codecogs.com/svg.latex?\mu=\int_{0}^{\infty}S(t)dt"/>

## Improper random variables

There are cases when the event of interest is not bound to happen. E.g. some people will never get married.

2 ways to tuckle this:

1. Still use previously defined S(t) and &lambda;(t). S(&infin;) represents the portion of objects that never experience the event.
    * **The density could be improper, which fails to integrate to 1**
1. Only analyse on the event actually occurring

    <img src="https://latex.codecogs.com/svg.latex?f^{*}(t)=\frac{f(t)}{1-S(\infty)}"/>

    <img src="https://latex.codecogs.com/svg.latex?S^{*}(t)=\frac{S(t)-S(\infty)}{1-S(\infty)}"/>

    <img src="https://latex.codecogs.com/svg.latex?\lambda^{*}(t)=\frac{f^{*}(t)}{S^{*}(t)}=\frac{f(t)}{S(t)-S(\infty)}"/>
    
## Censoring

* Type 1: fixed censoring. N units with a fixed time &tau;. The probability that unit i will be alive at the end of the observatioin time is S(&tau;<sub>i</sub>)
* Type 2: a sample of n units is followed as long as necessary until d units have experienced the event. Total distribution is random
* Random censoring: each unit has potential censoring time C<sub>i</sub>, and a potential lifetime T<sub>i</sub>. We observe <img src="https://latex.codecogs.com/svg.latex?Y_i=min\{C_i,T_i\}"/>. And there's an indicator variable d<sub>i</sub> or &delta;<sub>i</sub> tells whether observation is terminated by death or censoring.

## Likelihood function for censored data

If the unit died at &t<sub>i</sub>

<img src="https://latex.codecogs.com/svg.latex?L_i=f(t_i)=S(t_i)\cdot\lambda(t_i)"/>

If alive,

<img src="https://latex.codecogs.com/svg.latex?L_i=f(t_i)=S(t_i)"/>

Combine these 2 together:

<img src="https://latex.codecogs.com/svg.latex?L=\prod_{i=1}{n}L_i=\prod_{i}\lambda(t_i)^{d_i}S(t_i)"/>

where d<sub>i</sub> is a death indicator

* d<sub>i</sub> = 1, when dead
* d<sub>i</sub> = 0, when alive

Take log in both sides:

<img src="https://latex.codecogs.com/svg.latex?\log{L}=\sum_{i=1}^{n}d_i\log\lambda(t_i)-\Lambda(t_i)"/>

Take exponential distribution for example,

Let <img src="https://latex.codecogs.com/svg.latex?D=\sum{D_i}"/> to be the toal number of death, <img src="https://latex.codecogs.com/svg.latex?T=\sum{t_i}"/> to be the total observation time.

Then the log-likelihood function could be rewrite as,

<img src="https://latex.codecogs.com/svg.latex?\log{L}=D\log\lambda-\lambda{T}"/>

From M.L.E

<img src="https://latex.codecogs.com/svg.latex?\hat{\lambda}=\frac{D}{T},\hat{var}(\hat{\lambda})=\frac{D}{T^2}"/>

## Accelerated life model

Let T<sub>i</sub> random variable representing the survival time of ith unit. Use a linear model to represent:

<img src="https://latex.codecogs.com/svg.latex?\log{T_i}=x_i'\beta+\epsilon_i"/>

Rewrite this equation and get:

<img src="https://latex.codecogs.com/svg.latex?T_i=\exp{x_i'\beta}T_{0i}"/>

where T<sub>0i</sub> is the exponential error term.

Let <img src="https://latex.codecogs.com/svg.latex?\gamma_i\equiv\exp{x_i'\beta}"/>

And also let S<sub>0</sub>(t) denote the survival function in group zero, i.e. reference group, and S<sub>0</sub>(t) in group one.

<img src="https://latex.codecogs.com/svg.latex?S_1(t)=S_0(t/\gamma)"/>

* **Probability of a member of group one will be alive at age t is exactly the same of age t/&gamma; in group zero.**
* **Accelerated life models are essentially standard regression models applied to the log of survival time, except that the observations are censored.**

## Proportional hazard model

<img src="https://latex.codecogs.com/svg.latex?\lambda_i(t|x_i)=\lambda_0(t)\exp\{x_i'\beta\}"/>

&lambda;<sub>0</sub>(t) is the baseline hazard function describes the risk for individuals with x<sub>i</sub> = 0.

exp{x<sub>i</sub>'&beta;} is the relative risk, a proportionate increase or reduction in risk which is the same for all duration t.

The previous equation could be rewritten as we take log on both sides:

<img src="https://latex.codecogs.com/svg.latex?\log\lambda_i(t|x_i)=\alpha_0(t)+x_i'\beta"/>

&alpha;<sub>0</sub>(t) is the log of the baseline hazard.

Since &beta; is constant for all t, integrate the initial equation:

<img src="https://latex.codecogs.com/svg.latex?\Lambda_i(t|x_i)=\Lambda_0(t)\exp\{x_i'\beta\}"/>

And finally:

<img src="https://latex.codecogs.com/svg.latex?S_i(t|x_i)=S_0(t)^{\exp\{x_i'\beta\}}"/>

* **The effect of covariate values x<sub>i</sub> on survival function is to raise it to a power given by the relative risk &gamma;<sub>i</sub> = exp{x<sub>i</sub>'&beta;}**

## Exponential regression model

Let <img src="https://latex.codecogs.com/svg.latex?\lambda_0(t)=\lambda_0"/> in the proportional hazard model,

then

<img src="https://latex.codecogs.com/svg.latex?\lambda_i(t|x_i)=\lambda_0\exp\{x_i'\beta\}"/>

* **Exponential regression model belongs to both proportional hazard and accelerated life families.**

## Weibull distribution

<img src="https://latex.codecogs.com/svg.latex?S(t)=\exp\{-({\lambda}t)^p\}"/>

and for parameters p > 0 and &lambda; > 0,

<img src="https://latex.codecogs.com/svg.latex?\lambda(t)=p\lambda({\lambda}t)^{p-1}"/>

* If p = 1, reduces to the exponential distribution and has constant risk over time
* If p > 1, risk increases over time
* p < 1, the risk decreases over time

In addition,

* Use Weibull risk and multiply hazard by &gamma;, still Weibull
* Use Weibull survival and deviding time by &gamma;, still Weibull

## General hazard rate model

**Add time-varying covariates and time-dependent effects**

<img src="https://latex.codecogs.com/svg.latex?\lambda_i(t|x_i(t))=\lambda_0(t)\exp\{x_i'(t)\beta(t)\}"/>

## Model fitting

1. Parametric approach. Assume a specific function form for baseline hazard &lambda;<sub>0</sub>(t), models like exponential, Weibull, gamma and generalized F distributions.
1. Flexible semi-parametric strategy. Make mild assumption about baseline hazard &lambda;<sub>0</sub>(t). Subdivide time into reasonable small intervals and assume baseline hazard is constant in each interval. (**Piece-wise model**)
1. Non-parametric. Estimation of regression coefficients &beta;, and leaving baseline hazard &lambda;<sub>0</sub>(t) unspecified. Rely on partial likelihood function.

1 &rarr; sufficient flexible with wide applicability.

2 &rarr; related to Poisson regression

## Piece-wise exponential model

Fitting a proportional hazard model with a usual form

<img src="https://latex.codecogs.com/svg.latex?\lambda_i(t|x_i)=\lambda_0(t)\exp\{x_i'\beta\}"/>

Assume &lambda;<sub>0</sub>(t) = &lambda;<sub>j</sub> for t in [&tau;<sub>j-1</sub>, &tau;<sub>j</sub>).

Then &lambda;<sub>0</sub>(t) contains J parameters, &lambda;<sub>1</sub>, ..., &lambda;<sub>J</sub>

* Closely-spaced boundaries when hazard changes rapidly
* Wider intervals when changes more slowly

## Discrete time models

Let T be discrete random variable that takes the values t<sub>1</sub> < t<sub>2</sub> < ... with probability

<img src="https://latex.codecogs.com/svg.latex?f(t_j)=f_j=Pr\{T=t_j\}"/>

then

<img src="https://latex.codecogs.com/svg.latex?S(t_j)=S_j=Pr\{T{\ge}t_j\}=\sum_{k=j}^{\infty}f_k"/>

Hazard at time t<sub>j</sub> as the conditional probabiliry of dying at that time given that one has survived to that point:

<img src="https://latex.codecogs.com/svg.latex?\lambda(t_j)=\lambda_j=Pr\{T=t_j|T{\ge}t_j\}=\frac{f_j}{S_j}"/>

And

<img src="https://latex.codecogs.com/svg.latex?S_j=(1-\lambda_1)\cdot(1-\lambda_2)...(1-\lambda_{j-1})"/>

## Discrete survival and logistic regression

<img src="https://latex.codecogs.com/svg.latex?\frac{\lambda(t_j|x_i)}{1-\lambda(t_j|x_i)}=\frac{\lambda_0(t_j)}{1-\lambda_0(t_j)}\exp\{x_i'\beta\}"/>

which gives

<img src="https://latex.codecogs.com/svg.latex?\textrm{logit}\lambda(t_j|x_i)=\alpha_j+x_i'\beta"/>

<img src="https://latex.codecogs.com/svg.latex?\alpha_j=\textrm{logit}\lambda_0(t_j)"/> is the logit of the baseline hazard

The likelihood function for discrete-time survival model under non-informative censoring coincides with teh binomial likelihood that would be obtained by treating the death indicator as independent Bernoulli or binomial.

## Kaplan-Meier plot (product limit estimator)

<img src="https://latex.codecogs.com/svg.latex?\hat{S}(t)=\prod_{i:t_i<t}(1-\frac{d_i}{n_i})"/>

d<sub>i</sub> is the number of events at t<sub>i</sub>

n<sub>i</sub> is the number of individuals known to survived at t<sub>i</sub>

* Advantage over Naive estimator: multiply terms with censoring time smaller than t
* Kaplan-Meier is limited to estimate survival adjusted for covariates. Parametric survival models, like Cox proportional hazard model, is useful in this scenario
* Greenwood's formula can be used to estimate the variance

    <img src="https://latex.codecogs.com/svg.latex?\hat{var}(\hat{S}(t))=\hat{S}(t)^2\sum_{i:t_i{\le}t}\frac{d_i}{n_i(n_i-d_i)}"/>

## Log-rank test (Mantel-Cox test)

The logrank test is a hypothesis test to compare the survival distributions of two samples

Let j = 1, 2, ..., J be the distinct time of observed events

N<sub>j</sub> = N<sub>1j</sub> + N<sub>2j</sub>, the number of subjects at risk right before j

O<sub>j</sub> = O<sub>1j</sub> + O<sub>2j</sub>, observed number of events at time j

<img src="https://latex.codecogs.com/svg.latex?E_{1j}=\frac{O_j}{N_j}N_{1j}"/>, expected value

<img src="https://latex.codecogs.com/svg.latex?V_j=\frac{O_j(N_{1j}/N_j)(1-N_{1j}/N_j)(N_j-O_j)}{N_{j-1}}"/>, variance

* logrank statistic

<img src="https://latex.codecogs.com/svg.latex?V_j=\frac{O_j(N_{1j}/N_j)(1-N_{1j}/N_j)(N_j-O_j)}{N_{j-1}}"/>, variance


