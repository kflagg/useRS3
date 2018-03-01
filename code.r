# Structure of some common classes.
str(iris)
versicolor <- glm(I(Species == 'versicolor') ~
                 Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,
                  family = binomial, data = iris)
str(lm(Petal.Length ~ Species, data = iris))
petal <- t.test(iris$Petal.Length, mu = 4)
str(petal)


# Changing an object's class.
dframe <- data.frame(x = 1:4, y = 5:8, row.names = letters[1:4])
dframe
class(dframe) <- 'list'
dframe


# See what methods are available for objects of the lm class.
methods(class = 'lm')


# Compare some different summary methods.
summary
summary.data.frame
summary.lm
summary.default


# Where is the plot method for the lm class?
plot.lm
getS3method('plot', 'lm')


############################
# Simulation test example. #
############################

# The code below does a simulation test on a data vector called x.
# The null value is a variable called mu.
# This code is intended to go inside a function where x and mu are arguments.

# Sample size.
n <- length(x)

# Observed sample mean.
xbar <- mean(x)

# Subtract the observed mean and add the hypothesized mean to create a
# "sample" where the null hypothesis is true.
H0 <- x - xbar + mu

# Means of permutations (NA for now).
means <- rep(NA_real_, nsims)

# Loop nsims times...
for(i in 1:nsims){
  # ...sample with replacement (assuming the null value is the true mean)...
  sim <- sample(x = H0, size = n, replace = TRUE)

  # ...and save the simulated sample mean.
  means[i] <- mean(sim)
}

# Get the proportion of samples where the mean was less than the original
# sample mean (a left-tailed test).
p.value <- sum(xbar < means) / nsims

# You try: add code to check whether the alternative argument is "greater",
# "less", or "two-sided" and then calculate the appropriate p-value.

# This is helpful reporting information displayed by the print.htest function.
method <- 'One Sample Simulation Test'
estimate <- setNames(xbar, 'mean of x')
parameter <- setNames(nsims, 'number of simulations')
data.name <- deparse(substitute(x))
