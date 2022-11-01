#' Media e intervalo de confianza usando bootstrap
#'
#' @param x Numeric vector.
#' @param nboot Number of bootstrap resamples.
#' @param ci Confidence interval.
#' @param seed Reproducibility seed.
#' @param k Number of digits when printing the results.
#'
#' @export
mean_ic_boot <- function(x, nboot = 5000, ci = 0.95, seed = 1234, k = 1) {

  # Comprobación de errores
  stopifnot(
    "`x` no es un vector num\032rico" = is.numeric(x),
    "`x` no puede tener una longitud menor a 3" = length(x) >= 3
  )

  x <- x[!is.na(x)]
  n <- length(x)
  mu <- mean(x)

  set.seed(seed)
  z <- vapply(
    seq_len(nboot),
    function(i, j, k) {
      sum(j[sample.int(k, k, TRUE)])
    },
    FUN.VALUE = NA_real_,
    j = x,
    k = n
  )

  z <- z / n

  quant <- stats::quantile(z, c((1 - ci)/2, (1 + ci)/2))
  out <- c(Mean = mu, quant)

  class(out) <- "mean_ic"
  attr(out, "ci") <- ci
  attr(out, "digits") <- k
  attr(out, "bootstrap") <- z
  return(out)
}

#' @export
print.mean_ic <- function(x, ...) {
  x <- round(x, digits = attr(x, "digits"))
  out <- paste0(x[[1]], ", IC~",attr(x, "ci")*100,"%~[",x[[2]],", ",x[[3]],"]")
  print(out)
}
