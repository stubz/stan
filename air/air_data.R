# http://heartruptcy.blog.fc2.com/blog-entry-93.html
# https://github.com/stan-dev/example-models/wiki/BUGS-Examples-Sorted-Alphabetically

# Whittemore and Keller (1988) use an approximate maximum likelihood approach to analyse 
# the data shown below on reported respiratory illness versus exposure to nitrogen 
# dioxide (NO 2 ) in 103 children. Stephens and Dellaportas (1992) later use Bayesian 
# methods to analyse the same data. 

# 

setwd("/Users/okada/myWork/mcmc/stan")

## Data ##
alpha <- 4.48        
beta <- 0.76         
sigma2 <- 81.14      
J <- 3               
y <- c(21, 20, 15)
n <- c(48, 34, 21)
Z <- c(10, 30, 50)

## Model Fit ##
library(rstan)
dat <- list(y=y, n=n, Z=Z, alpha=alpha, beta=beta, J=J, sigma2=sigma2)
fit1 <- stan(file="./air/air_model.stan", data = dat, iter=1000, chains=4)

## Model Summary ##
apply(extract(fit1)$X, 2, median) # (X[1], X[2], X[3]) = (13.6, 27.0, 41.0)
median(extract(fit1)$theta1); median(extract(fit1)$theta2) # -0.69, 0.04 
apply(extract(fit1)$X, 2, sd) # (X[1], X[2], X[3]) = (8.4, 7.7, 8.7)
sd(extract(fit1)$theta1); sd(extract(fit1)$theta2) # 1.2, 0.05
# similar to WinBUGS results

hist(extract(fit1)$theta1)
plot(fit1)
traceplot(fit1)

library(coda)
fit.coda<-mcmc.list(lapply(1:ncol(fit1),function(x) mcmc(as.array(fit1)[,x,])))
plot(fit.coda)

