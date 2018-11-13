## documents for vars can be found at https://cran.r-project.org/web/packages/vars/vars.pdf

library(vars)

table <- read.table('data/GasFurnace.DAT', skip=1)
vec <- ts(table)

par(mfrow = c(2, 1), mai=c(0.4,1,0.4,1))
plot(1:length(table$V1), table$V1, type='l', xlim=c(0, 60), col = 'red')
plot(1:length(table$V2), table$V2, type='l', xlim=c(0, 60), col = 'blue')

mvar <- VAR(vec, p=2)
mvar
plot(mvar)

# estimated coefficients
coef(mvar)

# predict

pred <- predict(mvar, n.ahead = 12, ci = 0.95)

## plot predictions
fanchart(pred)

## forcast error
fevd(mvar, n.ahead = 12)

fitted(mvar)

normality.test(mvar) # some tests

plot(mvar)

