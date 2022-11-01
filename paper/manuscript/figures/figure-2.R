
# Cargamos librerias ------------------------------------------------------

library(cyclismProj)
library(data.table)
library(modelbased)
library(ggplot2)
library(see)

data("males", package = "cyclismProj")

ggplot2::theme_set(new = theme_classic())

# Ajustamos modelo --------------------------------------------------------

fit <- lm(hrv_delta_pns ~ ime * waist_hip_ratio, males)
summary(fit, correlation = TRUE)

plot_data <- modelbased::estimate_slopes(
  model = fit,
  trend = "waist_hip_ratio",
  at = "ime",
  length = 300
)

plot_data <- as.data.table(plot_data)

plot_data[, Confidence := fifelse(p < 0.05, "Significativo", "No significativo")
          ][, grp := rleid(Confidence)]

p1 <- ggplot(plot_data, aes(ime, Coefficient)) +
  geom_hline(yintercept = 0, lty = 2) +
  geom_line(aes(group = 1, col = Confidence), lwd = 1) +
  geom_ribbon(aes(ymin = CI_low, ymax = CI_high, group = grp, fill = Confidence), alpha = 0.4) +
  labs(x = "IME", y = expression("Efecto de WH ratio en "*Delta*"PNS")) +
  theme(legend.position = "top") +
  see::scale_color_flat_d(aesthetics = c("color", "fill"), reverse = TRUE)

ggsave("paper/manuscript/figures/figure-2.pdf", p1, "pdf")
ggsave("paper/manuscript/figures/figure-2.tiff", p1, "tiff", dpi = 360)
