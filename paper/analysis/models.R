# Cargamos librerías --------------------------------------------------------------------------

  library(data.table)
  data("males", package = "cyclismProj")

  # Función auxiliar
  plot_dens <- function(model) {
    yvar <- model[["model"]][[1]]
    dens <- density(yvar)
    plot(dens, main = sprintf("Distribución de %s", deparse(model$call$formula)))
    abline(v = 0, lty = 2)
    rug(yvar)
  }

  map <- function(x, method = "BCI", ci = 0.9) {
    x_dens <- density(x)
    x_map <- x_dens$x[which.max(x_dens$y)]
    list(map = x_map, ci = bayestestR::ci(x, method = method, ci = ci))
  }

  test_model <- function(formula, data) {
    model <- lm(formula, data)
    list(
      mod = model,
      lm = summary(model),
      normality = shapiro.test(x = resid(model))$p.value > 0.05
    ) |> print()
    invisible(model)
  }


# ∆SNS --------------------------------------------------------------------

  # modelo simple (solo intercepto)
  test_model(hrv_delta_sns ~ 1, males) # ***

  # imo
  test_model(hrv_delta_sns ~ datawizard::center(imo), males) # ***

  mod <- test_model(hrv_delta_sns ~ age * imo, males) # ***
  modelbased::estimate_slopes(mod, trend = "imo", at = c("age"), length = 100) |> plot()

  test_model(hrv_delta_sns ~  ftp_mean_power + age + imo, males) # ***
  modelbased::estimate_slopes(
    model = test_model(hrv_delta_sns ~  ftp_mean_power + age * imo, males),
    trend = "imo",
    at = c("age"),
    length = 100
  ) |> plot()

  # bone_mass_kg
  test_model(hrv_delta_sns ~ bone_mass_kg, males) # *
  mod <- test_model(hrv_delta_sns ~ age + bone_mass_kg, males) # *


# ∆ PNS -------------------------------------------------------------------

  # modelo simple
  test_model(hrv_delta_pns ~ 1, males)

  # ime
  test_model(hrv_delta_pns ~ ime, males) # *
  test_model(hrv_delta_pns ~ age + ime, males) # *
  test_model(hrv_delta_pns ~ age + ftp_mean_power + ime, males) # *


  test_model(hrv_delta_pns ~ age + ime, males) # *
  mod <- test_model(hrv_delta_pns ~ age * ime, males) # *
  modelbased::estimate_slopes(mod, trend = "ime", at = c("age"), length = 100) |> plot()
