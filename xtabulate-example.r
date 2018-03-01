# This is an example of a class I created while taking STAT 448 (Mixed Models).
# It builds on top of xtable and includes some additional summary output that
# I typically wanted.

library(xtable)

xtabulate <- function(x, ...) UseMethod('xtabulate')
xtabulate.lm <- function(x, caption = NULL, ...){
  xsum <- summary(x)
  ans <- list(tab = xtable(x, caption = caption, ...),
              sigma = xsum$sigma,
              df = xsum$df[2],
              r.squared = xsum$r.squared,
              adj.r.squared = xsum$adj.r.squared,
              fstat = xsum$fstatistic)
  class(ans) <- 'xtabulate.lm'
  return(ans)
}

print.xtabulate.lm <- function(x,
    caption.placement = getOption("xtable.caption.placement", "bottom"),
    table.placement = getOption("xtable.table.placement", "ht"),
    floating = getOption("xtable.floating", TRUE), ...){
  
  # Get the caption.
  caption <- attr(x$tab, 'caption')

  # Start the table environment.
  if(floating){
    cat('\\begin{table}[', table.placement, ']\\centering\n')
    if(!is.null(caption) & caption.placement == 'top'){
      cat('\\caption{', caption, '}\n')
    }
  }

  # Print the xtable and summary info.
  print(x$tab, floating = FALSE, ...)
  cat('\nResidual standard error: ', signif(x$sigma, 4), ' on ',
      x$df, ' degrees of freedom\n\\\\Multiple R-squared: ',
      round(x$r.squared, 4), ', Adjusted R-squared: ',
      round(x$adj.r.squared, 4), '\n\\\\F-statistic: ',
      signif(x$fstat[1], 4), ' on ', x$fstat[2], ' and ',
      x$fstat[3], ' DF, p-value: ',
      signif(pf(x$fstat[1], x$fstat[2], x$fstat[3],
                lower.tail = FALSE), 4), '\n', sep = '')

  # End the table environment
  if(floating){
    if(!is.null(caption) & !caption.placement == 'top'){
      cat('\\caption{', caption, '}\n')
    }
    cat('\\end{table}\n')
  }
}
