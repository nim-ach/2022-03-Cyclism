
# Import packages ---------------------------------------------------------

library(cyclismProj)
library(data.table)
library(gt)
library(gtsummary)

# Load data ---------------------------------------------------------------

data <- males

# Data preparation --------------------------------------------------------

body_composition <- c("weight", "height", "bmi", "imo", "ime", "waist_hip_ratio", "mme", "visceral_fat",
                      "fat_mass_perc", "muscle_mass_perc", "bone_mass_perc", "residual_mass_perc",
                      "water_aec_act", "water_aic", "water_act", "water_aec")

vars <- c("age", body_composition)

tbl <- tbl_summary(data,
            include = body_composition,
            type = everything() ~ "continuous",
            digits = everything() ~ 1,
            missing = "no",
            sort = everything() ~ "alphanumeric",
            label = list(
              weight ~ "Weight",
              height ~ "Height",
              bmi ~ "Body mass index",
              imo ~ "Muscle bone index",
              ime ~ "Skeletal muscle index",
              mme ~ "Skeletal muscle mass",
              waist_hip_ratio ~ "Waist-Hip ratio",
              fat_mass_perc ~ "Fat mass",
              muscle_mass_perc ~ "Muscle mass",
              bone_mass_perc ~ "Bone mass",
              residual_mass_perc ~ "Residual mass",
              visceral_fat ~ "Visceral fat",
              water_aec_act ~ "ECW/TCW",
              water_aic ~ "ICW",
              water_act ~ "TCW",
              water_aec ~ "ECW"
            )) |>
  as_kable()



saveRDS(tbl, "paper/manuscript/tables/table-1.RDS")


# Table generation --------------------------------------------------------



# Table exportation -------------------------------------------------------


