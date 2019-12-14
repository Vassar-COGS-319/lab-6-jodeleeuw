library(dplyr)

set.seed(12604) # setting the random number seed will make the results match across runs

# creating some fake data for a linear model to fit

# two parameters for the line
intercept <- 3
slope <- 0.5

# generate random X values
data.x <- runif(20, min=-10, max=10)

# then generate random Y values with noise around the X values.
data.y <- rnorm(20, mean=(slope*data.x + intercept), sd = 1)

# plot the data and the true underlying model
plot(data.x, data.y)
abline(a = intercept, b=slope, col="red")

# convert the data into a data frame
model.data <- data.frame(x=data.x, y=data.y)

# YOUR JOB:
# calculate the Root Mean Square Error for the true model.
# this involves: 
#   - finding the predicted y value for each x, according to the linear model
#   - finding the square error for each data point [predicted - data]^2
#   - taking the mean of the square errors, and then taking the sqrt of the mean.

# the answer is 0.935

model.data <- model.data %>% 
  mutate(predicted.y = intercept + slope*x) %>%
  mutate(square.error = (predicted.y - y)^2)

sqrt(mean(model.data$square.error))



# when you finish, if you are waiting: try to manually find a slope and intercept value that produces a
# lower RMSE than the true model.


