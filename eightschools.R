setwd("/Users/okada/myWork/mcmc/stan")
library(rstan)

## set data
J <- 8
y <- c(28, 8, -3, 7, -1, 1, 18, 12)
sigma <- c(15, 10, 16, 11, 9, 11, 10, 18)
schools_data <- c("J", "y", "sigma")

fit1 <- stan(file="eightschools.stan", data=schools_data, iter=100, chains=4)
print(fit1, pars=c("theta", "mu", "tau", "lp__"), probs=c(.1,.5,.9))

