data {
  int<lower=0> J; // the number of schools = 8 
  real y[J];      // estimated treatment effect
  real<lower=0> sigma[J];  // standard error of effect estimates
}
parameters{
  // the unknowns to be estimated in the model fit
  real mu;
  real<lower=0> tau; // sd of the population of school effects
  vector[J] eta;     // school level errors
}
transformed parameters {
  // transforming parameters will allow samplers to run more efficiently
  vector[J] theta; // transformed from the parameters above, namely mu, tau and eta.
  theta <- mu + tau*eta;
}
model {
  eta ~ normal(0, 1);
  y ~ normal(theta, sigma); 
  // we could write : for (j in 1:J) y[j] ~ normal(theta[j],sigma[j]); 
}