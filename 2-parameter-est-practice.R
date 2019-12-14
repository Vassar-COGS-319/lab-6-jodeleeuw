library(dplyr)
set.seed(12604)

# practice with parameter estimation

# we'll use the same linear model data as before.

intercept <- 3
slope <- 0.5

data.x <- runif(20, min=-10, max=10)
data.y <- rnorm(20, mean=(slope*data.x + intercept), sd = 1)

plot(data.x, data.y)
abline(a = intercept, b=slope, col="red")

model.data <- data.frame(x=data.x, y=data.y)

# now we need to write a function that calculates the RMSE for a given set of parameters
# because of the function we will use in a moment, this function must take a vector of parameters
# as the first argument. we can translate that vector back into the intercept and slope inside the function.

calculate.rmse <- function(parameters){
  intercept <- parameters[1]
  slope <- parameters[2]
  
  model.data <- model.data %>% 
    mutate(predicted.y = intercept + slope*x) %>%
    mutate(square.error = (predicted.y - y)^2)
  
  rmse <- sqrt(mean(model.data$square.error))
  
  return(rmse)
}

# now we use optim to find the best fitting parameters (minimize RMSE)

result <- optim(calculate.rmse, par = c(0,0))

# we can extract the parameters from optim, and plot the best fitting line

best.intercept <- result$par[1]
best.slope <- result$par[2]

abline(a=best.intercept, b=best.slope, col="blue")

# note that the best fitting line is not the same as the actual model that generated the data!
# if you were running the experiment that collected this data, what could you do to improve
# the estimate? get more data! try simulating that, and seeing if it helps. if you are done early,
# then try making a plot that has sample size on the X axis and error in the model parameter estimates on
# the Y axis...

