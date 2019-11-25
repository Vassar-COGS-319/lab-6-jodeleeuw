library(readr)
library(ggplot2)

# the final exercise here is to apply maximum likelihood estimating to a cognitive model of categorization.
# we've seen the exemplar model several times now. the basic idea is that we remember all instances of a category,
# and then compare new instances to our stored memories. we probabilistically assign category membership based on
# the similarity to the category relative to similarity to other categories.

# in the model below, an additional parameter and mechanism is added to the exemplar model: forgetting.
# we assume that recently seen things are more likely to contribute to similarity judgments than old items.
# this is implemented by allowing the memory for old items to decay.

# your task here is to compare the model with the additional parameter to the original. 
# do AIC/BIC prefer the new or the old?


# LOADING and VISUALIZING the data

categorization.data <- read_csv('experiment-data.csv', col_types = cols(category=col_factor()))

ggplot(categorization.data, aes(x=x,y=y,color=category,shape=correct))+
  geom_point()+
  theme_bw()


# CREATING THE EXEMPLAR MODEL

# this is provided to you, but it's worth taking some time to understand what's happening here.

# parameters:
# training.data contains all of the stimuli seen so far
# stimulus.x is the x value of the to-be-categorized stimulus
# stimulus.y is the y value of the to-be-categorized stimulus
# stimulus.category is the actual category membership of the to-be-categorized stimulus
# sensitivity controls how much generalization the model does for measurements of similarity.
#     high values lead to much less generalization (items must be very near together to be similar)
# decay.rate controls how fast the memories decay. a decay.rate of 0 produces no decay. 

exemplar.model.predict <- function(training.data, stimulus.x, stimulus.y, stimulus.category, sensitivity, decay.rate){
  training.data <- training.data %>% 
    # first calculate the distance between the stimulus and all items in memory
    mutate(distance = sqrt((stimulus.x - x)^2 + (stimulus.y - y)^2)) %>%
    # then covert this distance to a similarity, based on the sensitivity
    mutate(similarity = exp(-sensitivity * distance)) %>%
    # calculate how much each item has decayed. we assume that items at the bottom
    # of the data frame have been seen more recently.
    mutate(memory.weight = exp(-decay.rate * (n() - row_number()))) %>%
    # finally, weight the similarity scores by the decay.
    mutate(weighted.similarity = similarity * memory.weight)
  
  # take the sum of the similarity for each category.
  training.data.summary <- training.data %>%
    group_by(category) %>%
    summarize(total.similarity = sum(weighted.similarity))
  
  # calculate overall similarity to all items in memory
  overall.similarity <- sum(training.data.summary$total.similarity)
  # calculate similarity to the target category
  target.similiarity <- training.data.summary %>% filter(category==stimulus.category) %>% pull(total.similarity)
  # calculate the probability of a correct response
  p.correct <- target.similiarity / overall.similarity
  return(p.correct)
}

# Your job is now to write the likelihood function.

# This will be similar to the previous functions you've written. The first argument needs to be params for optim to work.
# We can also pass in the experiment.data.

# The main issue to solve here is that you have to calculate the p(response) for each trial in the data,
# but the training.data that you pass into the model function will change for each trial, because the 
# subject will have seen new exemplars. For example, on trial 100, trials 1-99 are the training data.

# I suggest using a for loop to implement this. Also, let's ignore the first 10 trials because the behavior
# of the model is noisy with only a small number of trials. We'll treat those trials as "warm-up".

# hints: 
# create a variable to store the log.likelihood and update it on each loop of the for loop
# on each loop, extract the current stimulus and the training data.
# run the exemplar.model.predict function to get the p(correct)
# if the subject responded correctly then p(data) for that trial is p(correct)
# else the p(data) for that trial is 1-p(correct).

# Return the negative log likelihood

exemplar.model.likelihood <- function(params, experiment.data){
  sensitivity <- params[1]
  decay.rate <- params[2]
  
  # fill in the rest...
}

# Use optim() to fit the model to this data.
# Note: In optim() you can tell it to display updates as it goes with:
# optim( ... , control=list(trace=4))


# Now try fitting a restricted version of the model, where we assume there is no decay.
# Fix the decay.rate parameter to 0, and use optim to fit the sensitivity parameter.
# You can do this by copying the likelihood function above and just setting decay.rate to 0 inside the function.
# Note that you will need to use method="Brent" in optim() instead of Nelder-Mead because there is 
# only one parameter to fit.
# The brent method also requires an upper and lower boundary:
# optim( ..., upper=100, lower=0, method="Brent")


# What's the log likelihood of both models? (see the $value in the result of optim),
# remember this is the negative log likeihood, so multiply by -1.

# What's the AIC and BIC for both models? Which model should we prefer?
# AIC formula = 2k - 2ln(L)
# BIC formula = k*ln(N) - 2ln(L)
# k = number of free parameters, N = sample size, L = likelihood, ln(L) = log likelihood