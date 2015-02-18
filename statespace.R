setwd("/Users/okada/myWork/mcmc/stan")
library(rstan)
library(parallel)
data(Nile)
n <- length(Nile)
x <- c(rep(0, 27), rep(1, n - 27))

model.file <- "statespace.stan"

model <- stan_model(model.file)
seeds <- c(12, 123, 1234, 12345)

inits <- list(list(mu = rep(100, n), mu0 = 100,
                   lambda = -1000, sigma = c(1, 10)),
              list(mu = rep(1000, n), mu0 = 1000,
                   lambda = -1, sigma = c(10, 10)),
              list(mu = rep(500, n), mu0 = 500,
                   lambda = -10, sigma = c(100, 10)),
              list(mu = rep(5000, n), mu0 = 5000,
                   lambda = -100, sigma = c(10, 10)))
fit.l <- mclapply(1:4,
                  function(i) {
                      sampling(model,
                               data = list(N = n,
                                   y = as.vector(Nile),
                                   x = x),
                               pars = c("mu", "lambda", "sigma"),
                               chains = 1, chain_id = i,
                               seed = seeds[i], init = inits[i],
                               iter = 21000, warmup = 1000, thin = 20)
                }, mc.cores = 4)

fit <- sflist2stanfit(fit.l)
