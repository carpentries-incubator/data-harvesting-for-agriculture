# Run some sim tests for this dataset
source('/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/functions.R')

# libraries
library(knitr)
library(sf)
library(fasterize)
library(raster)
library(rjson)
library(httr)
library(rgdal)
library(rgeos)
library(maptools)
library(knitr)
require(tmap)
require(ggplot2)
require(gridExtra)
library(daymetr)
library(readr)
library(measurements)
library(FedData)
library(lubridate)
library(data.table)
library(dplyr)
library(tidyverse)
library(tidyr)
library(broom)

boundary <- st_read("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/boundary_new.gpkg") # read in boundary

plot(boundary$geom)
