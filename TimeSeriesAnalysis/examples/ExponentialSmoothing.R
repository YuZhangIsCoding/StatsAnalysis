## There are a lot of functions in R that can do exponential smoothing
## including HoltWinters, ses (ses, holt, hw) and ets
## HoltWinters can not do damped smoothing, but ses and ets could.

library(forecast)
library(stats)

## simple exponential smoothing
data <- ts(c(71, 70, 69, 68, 64, 65, 72, 78, 75, 75, 75, 70))

fit1 <- HoltWinters(data, alpha=0.1, beta = FALSE, gamma = FALSE)
fit1
fit1$SSE

fit2 <- HoltWinters(data, alpha=0.5, beta = FALSE, gamma = FALSE)
fit2
fit2$SSE

fit3 <- HoltWinters(data, beta = FALSE, gamma = FALSE)
fit3$alpha
fit3$SSE

fcast1 <- forecast(fit1, h = 3)
fcast2 <- forecast(fit2, h = 3)
fcast3 <- forecast(fit3, h = 3)

plot(data, type = 'o', col = 'black', xlim=c(1, 15), pch = 16)
lines(2:length(data), fit1$fitted[, 1], col='red')
lines(2:length(data), fit2$fitted[, 1], col='blue')
lines(2:length(data), fit3$fitted[, 1], col='gold')
legend(x ='topleft', legend = c('fit1', 'fit2', 'fit3'), 
       col = c('red', 'blue', 'gold'), lwd=1)
lines((length(data)+1):(length(data)+3), fcast1$mean, col = 'red', type = 'o')
lines((length(data)+1):(length(data)+3), fcast2$mean, col = 'blue', type = 'o')
lines((length(data)+1):(length(data)+3), fcast3$mean, col = 'gold', type = 'o')

## Double exponential smoothing
data <- ts(c(6.4,  5.6,  7.8,  8.8, 11. , 11.6, 16.7, 15.3, 21.6, 22.4))

fit1 <- HoltWinters(data, alpha= 0.3623, beta =1, gamma = FALSE)
fit2 <- HoltWinters(data, gamma = FALSE)

fit1$SSE
fit2$SSE
  
fcast1 <- forecast(fit1, h = 3)
fcast2 <- forecast(fit2, h = 3)
fcast3 <- holt(data, h = 3, damped=TRUE)

plot(data, type = 'o', col = 'black', xlim=c(1, 15), ylim=c(4, 35), pch = 16)
lines(3:length(data), fit1$fitted[, 1], col='red')
lines(3:length(data), fit2$fitted[, 1], col='blue')
lines(1:length(data), fcast3$fitted, col='gold')
legend(x ='topleft', legend = c('fit1', 'fit2', 'fit3'), 
       col = c('red', 'blue', 'gold'), lwd=1)
lines((length(data)+1):(length(data)+3), fcast1$mean, col = 'red', type = 'o')
lines((length(data)+1):(length(data)+3), fcast2$mean, col = 'blue', type = 'o')
lines((length(data)+1):(length(data)+3), fcast3$mean, col = 'gold', type = 'o')

## Triple exponential smoothing
data <- read.table('data/TriExp.dat', skip=25)
data <- ts(data['V4'], frequency = 4)

plot(data)
fit1 <- HoltWinters(data, seasonal='additive')
fit2 <- HoltWinters(data, seasonal='multiplicative')
fit3 <- ets(data, model='ZAA', damped = TRUE)
fit4 <- ets(data, model='ZAM', damped = TRUE)

fcast1 <- forecast(fit1, h=8)
fcast2 <- forecast(fit2, h=8)
fcast3 <- forecast(fit3, h=8)
fcast4 <- forecast(fit4, h=8)
fcast5 <- hw(data, seasonal = 'additive', h=8, damped=TRUE)
fcast6 <- hw(data, seasonal = 'multiplicative', h=8, damped=TRUE)

plot(data, type = 'o', col = 'black', xlim=c(1, 10), ylim=c(300, 1000), pch = 16)
lines(fit1$fitted[, 1], col='red')
lines(fit2$fitted[, 1], col='gold')
lines(fit3$fitted[, 1], col='yellowgreen')
lines(fit4$fitted[, 1], col='cyan')
lines(fcast5$fitted[, 1], col='blue')
lines(fcast6$fitted[, 1], col='purple')

lines(fcast1$mean, type='o', col='red')
lines(fcast2$mean, type='o', col='gold')
lines(fcast3$mean, type='o', col='yellowgreen')
lines(fcast4$mean, type='o', col='cyan')
lines(fcast5$mean, type='o', col='blue')
lines(fcast6$mean, type='o', col='purple')
legend(x ='topleft', legend = c('fit1', 'fit2', 'fit3', 'fit4', 'fit5', 'fit6'), 
       col = c('red', 'gold', 'yellowgreen', 'cyan', 'blue', 'purple'), lwd=1)
