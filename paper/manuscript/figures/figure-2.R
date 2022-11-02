
# Cargamos librerias ------------------------------------------------------

library(cyclismProj)
library(data.table)
library(modelbased)
library(datawizard)
library(ggplot2)
library(MASS)

data("males", package = "cyclismProj")

ggplot2::theme_set(new = theme_classic())

# Ajustamos modelo --------------------------------------------------------

fit <- rlm(formula = hrv_delta_sns ~ center(imo) * center(ftp_mean_power),
           data = males, maxit = 1e5, acc = 1e-10)

.slopes <- modelbased::estimate_slopes(fit, at = "ftp_mean_power", length = 100)

fig2a <- ggplot(.slopes, aes(ftp_mean_power, Coefficient)) +
  geom_line(col = "darkblue", lwd = 1) +
  geom_ribbon(aes(ymin = CI_low, ymax = CI_high), alpha = .2, show.legend = FALSE) +
  labs(x = "Mean power in FTP test", y = expression("Effect of MBI on "*Delta*"SNS")) +
  scale_color_brewer() +
  ggdist::theme_ggdist()

plot_data <- males[, .SD, .SDcols = grepl("pns|sns", names(males))] |>
  melt.data.table(measure.vars = patterns(SNS = "sns$", PNS = "pns$"))

plot_data[, variable := `levels<-`(variable, c("Basal", "Post-FTP", "Delta"))][]

fig2b <- ggplot(plot_data, aes(SNS, PNS)) +
  facet_grid(cols = vars(variable), scales = "free") +
  geom_point() +
  geom_smooth(method = MASS::rlm, col =  "darkblue") +
  ggdist::theme_ggdist()

fig2 <- see::plots(fig2a, fig2b, n_columns = 1, tags = "A", tag_suffix = ".")

ggsave("paper/manuscript/figures/figure-2.pdf", fig2, "pdf")
ggsave("paper/manuscript/figures/figure-2.tiff", fig2, "tiff", dpi = 360)
