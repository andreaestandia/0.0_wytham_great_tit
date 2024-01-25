# 0.0_wytham_great_tit_source.R
# 
# Copyright (c) Andrea Estandia, 2024, except where indicated
# Date Created: 2024-01-11


# --------------------------------------------------------------------------
# REQUIRES
# --------------------------------------------------------------------------

suppressPackageStartupMessages({
  library(tidyverse)
  #library(tidybayes)
  #library(brms)
  library(devtools)
  # library(janitor)
   library(dplyr)
  library(lubridate)
  library(sf)
  library(patchwork)
  library(gghighlight)
  library(viridis)
  library(adegenet)
  library(spdep)
  library(ade4)

})

text_size = 11
# --------------------------------------------------------------------------
# PATHS
# --------------------------------------------------------------------------

data_path <- file.path(getwd(), "data")
reports_path <- file.path(getwd(), "reports")
figures_path <- file.path(getwd(), "reports", "plots")

if (!dir.exists(data_path)) {
  dir.create(data_path, recursive = TRUE)
}

if (!dir.exists(figures_path)) {
  dir.create(figures_path, recursive = TRUE)
}

if (!dir.exists(reports_path)) {
  dir.create(reports_path, recursive = TRUE)
}


'%!in%' <- function(x,y)!('%in%'(x,y))