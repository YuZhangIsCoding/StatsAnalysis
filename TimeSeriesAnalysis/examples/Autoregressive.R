library(stats)
library(lawstat)

table <- read.table('data/F_SERIES.DAT', skip = 25)
vec <- ts(table)

plot(1:length(vec), vec, type = 'o', pch = 18, col = 'blue',
     xlab = 'Observation', ylab = 'Series F')
## The data do not appear to have a seasonal component or a noticeable trend
fitting <- lm(vec ~ c(1:length(vec)))
abline(fitting)
summary(fitting)
## Fitting the data with a linear model, the p value for slope is 0.207,
## which is not significantly different from 0

ac <- acf(vec, type = c('correlation'), lag.max = 36, main = 'Autocorrelation of seires F')
round(c(ac$acf), 4)

plot(ac, ci = 0.95, ci.type='ma', main='ACF with 95% confidence limits', ylim = c(-1, 1))
## The ACF values alternate in sign and decay quickly after lag 2, indicating that an AR(2)
## model is approprate for the data.

AR <- ar(vec, order=2)
AR
AR$x.mean # delta in the formular
sqrt(diag(AR$asy.var.coef)) # standard error

## Use runs test to determine the randomness of residuals
rt = runs.test(AR$resid)
rt

p <- predict(AR, n.ahead=6)
p$pred
L90 <- p$pred-1.645*p$se
U90 <- p$pred+1.645*p$se

Period <- c((length(vec)+1):(length(vec)+6))
df <- data.frame(Period, L90, p$pred, U90)
print(df, row.names=FALSE) ## print out the dataframe

plot(c(1:length(vec)), vec, type = 'l', xlim=c(0, max(Period)),
     ylim=c(0, 100), ylab = 'Series F', xlab='Observation', col='black')
# points(p$pred, pch = 16, col = 'blue')
lines(Period, p$pred, type='o', pch = 16, col='blue')
lines(Period, L90, col='red')
lines(Period, U90, col='red')
