# let's imagine that we scaled up Fisher's tea tasting experiment
# and had 10 people each taste 8 cups of tea, counting the number 
# of correct responses for each person.

tea.tasting.data <- data.frame(
  subject = 1:10,
  correct.responses = c(5,3,8,6,5,3,7,4,4,8)
)

# first: what's the likelihood of a model that says that everyone is randomly guessing?
# to answer this you need to calculate the probability of each subject's number of correct
# responses assuming that each subject has a 50% chance of a correct response. you can use
# the binomial distribution for this, specifically the dbinom() function, which gives the
# density of the binomial distribution.






# second: generalize your code above into a function that takes a single argument, theta,
# and calculates the likelihood for that model.

calculate.likelihood <- function(theta){

  
}

# third: generate a plot with theta values on the X-axis, and L(H) on the Y-axis.
# hint: create an array of X values from 0 to 1 in small steps, then use sapply() to
# get the corresponding array of Y values.



