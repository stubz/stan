data{
  int<lower=0> J;
  int y[J];
  vector[J] Z; // we can use vector. It will avoid a use of for loop
  int n[J];
  real alpha;
  real beta;
  real <lower=0> sigma2;
}
transformed data{
  real <lower=0> sigma;
  sigma <- sqrt(sigma2);
}
parameters{
  real theta1;
  real theta2;
  vector[J] X;
}
model{
  theta1 ~ normal(0, 100); // uninformed normal
  theta2 ~ normal(0, 100);
  X ~ normal(alpha+beta*Z, sigma);
  y ~ binomial_logit(n, theta1 + theta2*X);
}
