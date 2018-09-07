# Survival Analysis
---
This is a repo constructed for the study of survival analysis. Thanks to Wikipedia's page on [Survival Analysis](https://en.wikipedia.org/wiki/Survival_analysis) and Princeton's course on [Generalized Linear Models](http://data.princeton.edu/wws509/notes). All theory part will be put in this markdown file, and some practice examples will be illustrated in a jupyter notebook.

Some basic topic for survival analysis are covered:

* Life tables
* Survival function
* Hazard function
* Kaplan-Meier curves
* Log-rank test
* Propotional hazards regression
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
