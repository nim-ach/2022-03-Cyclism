
# Cargamos librerias ------------------------------------------------------

library(cyclismProj)
library(data.table)
library(ggplot2)
library(see)

# Importamos los datos ----------------------------------------------------

males <- cyclismProj::males

# Seleccionamos variables a graficar --------------------------------------

.ind_vars <- grep(pattern = "sd",
                 x = grep(pattern = "basal|post",
                          x = names(males),
                          value = TRUE),
                 invert = TRUE,
                 value = TRUE)


# Transformamos a formato largo -------------------------------------------

## ggplot2 maneja de manera máas eficiente el formato largo

plot_data <- data.table::melt(data = males[, .SD, .SDcols = .ind_vars],
                              measure.vars = .ind_vars)

plot_data[, `:=`(
  FTP = ifelse(grepl("post", variable), "Post", "Pre"),
  Index = data.table::fcase(
    grepl("sns", variable), "SNS index",
    grepl("pns", variable), "PNS index",
    grepl("stress", variable), "Stress index"
  )
)][, id := data.table::rleid(value), .(FTP, variable)]

plot_data <- data.table::melt(
  data = plot_data[
    j = list(
      Post = value[FTP == "Post"],
      Pre = value[FTP == "Pre"]),
    by = .(Index, id)],
  measure.vars = c("Pre", "Post"),
  variable.name = "FTP")

p1 <- ggplot2::ggplot(plot_data, ggplot2::aes(x = FTP, y = value, col = Index, fill = Index)) +
  ggplot2::facet_wrap(~Index, scales = "free_y") +
  ggplot2::geom_point(alpha = 0.25) +
  ggplot2::geom_line(aes(group = id), alpha = 0.25) +
  ggplot2::stat_summary(aes(pch = Index), fun.data = mean_cl_boot, size = 0.8) +
  ggplot2::geom_boxplot(width = 0.1, col = "black", position = position_nudge(x = c(-.18, .18)),
               outlier.shape = NA, show.legend = FALSE) +
  see::scale_color_flat_d(aesthetics = c("color", "fill")) +
  ggplot2::labs(fill = NULL, pch = NULL, col = NULL, x = NULL, y = NULL) +
  ggplot2::theme_classic(base_size = 14) +
  ggplot2::theme(legend.position = "none")

ggplot2::ggsave(filename = "paper/manuscript/figures/figure-1.pdf", plot = p1, device = "pdf")
ggplot2::ggsave(filename = "paper/manuscript/figures/figure-1.tiff", plot = p1, device = "tiff", dpi = 360)
