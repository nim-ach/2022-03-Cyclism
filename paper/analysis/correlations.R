# Cargamos librerías --------------------------------------------------------------------------

  library(data.table)
  library(correlation)
  data("males", package = "cyclismProj")

# Correlación de Spearman ---------------------------------------------------------------------

  # Todas las correlaciones usando método de spearman
  spearman_cors = correlation(
    data = males,
    p_adjust = "none",
    method = "spearman"
  ) |>
    subset(p < 0.05 & (grepl("delta", Parameter1) | grepl("delta", Parameter2)))

  # Transformamos a data.table para acortar código
  spearman_cors = as.data.table(spearman_cors)

  # Filtramos aquellas asociaciones significativas
  findings = spearman_cors[
    p < 0.05,
    .SD[order(abs(rho)), {
      paste0(Parameter1, " y ", Parameter2, ", $\\rho$ = ", round(rho, 2), ", *p* = ", round(p, 3))
    }]
  ]

  # Reportamos los hallazgos
  cat("# Hallazgos principales\n",
      "## Correlaciones (Spearman)\n",
      paste("- ", findings), "", sep = "\n",
      file = "paper/analysis_findings.md")
  file.edit("paper/analysis_findings.md")
