# A function to perform a one sample simulation test of the mean.
# Arguments:
#  x            Data vector.
#  mu           Value of the true mean under the null hypothesis.
#  alternative  Type of alternative hypothesis (currently ignored).
#  nsims        Number of samples to simulate.
sim.test <- function(x, mu = 0, alternative = 'less', nsims = 1000){
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

  # Combine everything into a list.
  result <- list(
    estimate = estimate,
    parameter = parameter,
    p.value = p.value,
    null.value = mu,
    alternative = alternative,
    method = method,
    data.name = data.name,
    null.dist = means 
  )
  class(result) <- c('simtest', 'htest')

  return(result)
}

# Plot method for the simtest class.
# Arguments:
#  x         A simtest object.
#  line.col  Color of the line marking the observed sample mean.
#  ...       Other arguments to pass to hist (breaks, xlim, etc).
plot.simtest <- function(x, line.col = 'red', ...){
  # Histograms invisibly return an object containing their breaks, counts, etc.
  # Save that object so we can return it too.
  h <- hist(x$null.dist, ...)

  # You try: Use the breaks and counts/densities from h to shade in the p.value.

  # Add a vertical line to the plot.
  abline(v = x$estimate, col = line.col)

  # Save the point estimate as an attribution of the histogram object.
  attr(h, 'xbar') <- x$estimate

  # Invisibly return the histogram object.
  invisible(h)
}

