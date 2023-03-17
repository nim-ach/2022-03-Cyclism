library(data.table)
library(gtsummary)
library(gt)

X <- tibble::tribble(
   ~AM_media_1, ~AM_mediana_1,   ~AM_peak_1,  ~AM_media_2, ~AM_mediana_2,   ~AM_peak_2,  ~AM_media_3, ~AM_mediana_3, ~AM_peak_3,
   267251,    28222,  591418,  162206,    17095,  301264,  205917,   205346,  418177,
   268406,   281854,  596399,  347814,    35757,  722669,  358002,   372557,  740007,
   111093,   110473,  190938,  101655,   103042,  155797,  137879,   128601,  173504,
   219303,   228893,  360028,  244101,   245464,  333307,  298055,   303069,  380214,
   381409,   254604,  692229,  363172,   418228,  782696,  318443,   377945,  629699,
   258209,   251969,  344892,  210713,   225412,  365095,  240783,   225354,  356003,
   298389,   276595,  597319,  275746,    32589,  549038,   42444,   360336,  568131,
   205375,   220965,  379474,  185252,   196045,  270245,  199585,   208111,  362676,
   307963,    28476,     397,  213777,   203645,  282697,   24454,   239057,  349984,
   460341,   465033,  657276,  368297,   351886,  418936,  400073,   379944,  453689,
   256396,   251569,  283920,  183616,   167644,  220111,  228370,   210883,  261446
  )

X <- as.data.table(X)

theme_gtsummary_language("es")
tbl <- tbl_summary(data = X,
            statistic = all_continuous() ~ "{mean} ± {sd}",
            digits = everything() ~ 1,
            label = list(
              AM_media_1 ~ "AM Media",
              AM_mediana_1 ~ "AM Mediana",
              AM_peak_1 ~ "AM Peak",
              AM_media_2 ~ "AM Media",
              AM_mediana_2 ~ "AM Mediana",
              AM_peak_2 ~ "AM Peak",
              AM_media_3 ~ "AM Media",
              AM_mediana_3 ~ "AM Mediana",
              AM_peak_3 ~ "AM Peak"
            ))

tbl <- as_gt(tbl)
tab_footnote(tbl, "AM = Actividad muscular", cells_body(5))
