library(dplyr)
set.seed(12604)

# back to the linear model

intercept <- 3
slope <- 0.5

data.x <- runif(20, min=-10, max=10)
data.y <- rnorm(20, mean=(slope*data.x + intercept), sd = 1)

plot(data.x, data.y)
abline(a = intercept, b=slope, col="red")

model.data <- data.frame(x=data.x, y=data.y)

# write a function like the one that calculated RMSE, but this time calculate likelihood
# for the set of parameters. to do this, assume that each data point is normally distributed
# around the line with sd = 1. you'll set the mean of the normal distribution to be the model's
# predicted Y value for the given X value, and then use dnorm() to find the density of the normal.

# it'll be important to use negative log likelihood here.

calculate.likelihood <- function(parameters){
  intercept <- parameters[1]
  slope <- parameters[2]
  
  model.data <- model.data %>%
    mutate(y.pred = intercept + slope*x) %>%
    mutate(log.prob.y = dnorm(y, mean=y.pred, sd=1, log=T))
  
  return(-sum(model.data$log.prob.y))
}

# run optim() to find the best fitting parameters and plot a line showing the best model fit.
result <- optim(par=c(0,0), calculate.likelihood)

best.intercept <- result$par[1]
best.slope <- result$par[2]

abline(a=best.intercept, b=best.slope, col="blue")
