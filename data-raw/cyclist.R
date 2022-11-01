
# Importamos librerías ------------------------------------------------------------------------

  library(googlesheets4)
  library(data.table)

# Cargamos los datos de la web ----------------------------------------------------------------

  # Autenticación cuenta de google
  gs4_auth()

  # Descargamos los datos
  cyclist <- read_sheet(
    ss = "1eOEJzAfjgyvI8g9TG_pTLGdyMwqtC0s5JR83cGrEUpM",
    sheet = "BD para R"
  )

  # Convertimos a data.tabla
  setDT(cyclist)


# Limpieza de datos ---------------------------------------------------------------------------

  # Valores únicos de todas las variables no-numéricas
  lapply(Filter(f = function(i) !is.numeric(i), x = cyclist), unique)

  # Recodificación de factores
  cyclist[, `:=`(
    id = factor(id),
    sex = factor(sex),
    beck_dep_cat = factor(beck_dep_cat, levels = c("Minima", "Leve", "Moderada")),
    beck_anx_cat = factor(beck_anx_cat, levels = c("Muy baja", "Moderada", "Severa")))
  ]

  # Re-inspección para comprobar los cambios
  lapply(Filter(f = function(i) !is.numeric(i), x = cyclist), unique)


# Creación de variables ---------------------------------------------------

  # Creamos un delta para los datos de HRV
  cyclist[, `:=`(
    hrv_delta_pns = (hrv_post_pns - hrv_basal_pns),
    hrv_delta_stress = (hrv_post_stress - hrv_basal_stress),
    hrv_delta_sns = (hrv_post_sns - hrv_basal_sns)
  )]

# Exportamos los datos ------------------------------------------------------------------------

  # Datos con todos los ciclistas
  usethis::use_data(cyclist, overwrite = TRUE)

  # Datos sólo con los hombres y datos de variabilidad presentes
  males <- cyclist[!is.na(hrv_post_stress) & sex == "M"]
  males[, `:=`(sex = NULL, id = droplevels(id))]
  usethis::use_data(males, overwrite = TRUE)
