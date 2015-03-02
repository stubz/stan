# http://www.slideshare.net/teitonakagawa/stantutorialj
# first tutorila on stan
setwd("/Users/okada/myWork/mcmc/stan/rats")

# Gelfand etal. Rats data 
# http://mathstat.helsinki.fi/openbugs/Examples/Rats.html
# This example is taken from section 6 of Gelfand et al (1990), 
# and concerns 30 young rats whose weights were measured weekly 
# for five weeks. Part of the data is shown below, where Y(ij) is 
# the weight of the ith rat measured at age x(j) .
#
# We model the rats' weight by
# Y(ij) = alpha(i) + beta(i)*(x(j) - x_bar) + e(ij)
# Rats' growth depend on each rat, and it is represented by alpha(i) and beta(i).

# Stan needs a block of programs, and the blocks need to be in the specified orders
# 1. data{}
# 2. transformed data {}
# 3. parameters {} # parameters we want to generate as outputs
# 4. transformed parameters{}
# 5. model{}
# 6. generated quantities{}
N <- 30
T <- 5
x = c(8.0, 15.0, 22.0, 29.0, 36.0)
xbar = 22
y = structure(
  .Data = c(151, 199, 246, 283, 320,
            145, 199, 249, 293, 354,
            147, 214, 263, 312, 328,
            155, 200, 237, 272, 297,
            135, 188, 230, 280, 323,
            159, 210, 252, 298, 331,
            141, 189, 231, 275, 305,
            159, 201, 248, 297, 338,
            177, 236, 285, 350, 376,
            134, 182, 220, 260, 296,
            160, 208, 261, 313, 352,
            143, 188, 220, 273, 314,
            154, 200, 244, 289, 325,
            171, 221, 270, 326, 358,
            163, 216, 242, 281, 312,
            160, 207, 248, 288, 324,
            142, 187, 234, 280, 316,
            156, 203, 243, 283, 317,
            157, 212, 259, 307, 336,
            152, 203, 246, 286, 321,
            154, 205, 253, 298, 334,
            139, 190, 225, 267, 302,
            146, 191, 229, 272, 302,
            157, 211, 250, 285, 323,
            132, 185, 237, 286, 331,
            160, 207, 257, 303, 345,
            169, 216, 261, 295, 333,
            157, 205, 248, 289, 316,
            137, 180, 219, 258, 291,
            153, 200, 244, 286, 324),
  .Dim = c(30,5))

library(rstan)
dat <- list(y=y, x=x, xbar=xbar, N=N, T=T)
fit1 <- stan(file="rats_model.stan", data = dat, iter=1000, chains=4)
#  Elapsed Time: 26.9942 seconds (Warm-up)
#                4.14836 seconds (Sampling)
#                31.1426 seconds (Total)
apply(extract(fit1)$alpha, 2, median)
plot(fit1)
traceplot(fit1)
# once a model is fitted, we can use the fitted result as an input to fit the model
# with other data or settings. This would save us time of compiling the C++ code 
# for the model
fit2 <- stan(fit=fit1, data = dat, iter = 400, chain = 4)

#  Elapsed Time: 15.2295 seconds (Warm-up)
#                1.06947 seconds (Sampling)
#                16.299 seconds (Total)
apply(extract(fit2)$alpha, 2, median)
plot(fit2)
traceplot(fit2)

# Parallel calculation to speed up the fitting
library(doSNOW); library(foreach)
cl <- makeCluster(2)
registerDoSNOW(cl)
# parallel processing each chain of stan
sflist1 <- foreach(i=1:10, packages='rstan') %dopar% {  stan(fit=fit1, data = dat, chains=1, chain_id = i, refresh=-1)}
# merging the chains
f3 <- sflist2stanfit(sflist1)
plot(f3)
traceplot(f3)




