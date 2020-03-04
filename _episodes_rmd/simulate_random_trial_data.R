library(knitr)
library(sf)
library(httr)
library(rgdal)
library(rgeos)
library(maptools)
require(tmap)
require(ggplot2)
require(gridExtra)
library(readr)
library(measurements)
library(dplyr)
source('https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/functions.R')
library(data.table)

setwd("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd")

# (I) Read in and transform our shape files
boundary <- st_read("data/boundary.gpkg") # read in boundary
abline <- st_read("data/abline.gpkg") # read in AB line
planting <- read_sf("data/asplanted.gpkg")
nitrogen <- read_sf("data/asapplied.gpkg")
yield <- read_sf("data/yield.gpkg")
trial <- read_sf("data/trial.gpkg")

trialarea <- st_transform_utm(boundary)
abline_utm <- st_transform_utm(abline)

# (II) parameters
width_in_meters = 24 # width of grids is 24 meters
long_direction = 'NS' # direction of grid that will be long
short_direction = 'EW' # direction of grid that will be short
length_in_ft = 180 # length of grids in feet

# (III) making grids
width <- m_to_ft(24) # convert meters to feet
design_grids_utm <- make_grids(trialarea, abline_utm,
                               long_in = long_direction,
                               short_in = short_direction,
                               length_ft = length_in_ft,
                               width_ft = width)

# (IV) correcting the CRS and subsetting to our farm boundary
st_crs(design_grids_utm) <- st_crs(trialarea)
trial_grid <- st_intersection(trialarea, design_grids_utm)

# (V) Picking a range of seed and nitrogen rates for our trials
seed_rates <- c(31000, 34000, 37000, 40000)
nitrogen_rates <- c(160,200,225,250)
# and setting our headlands rates
seed_quo <- 37000
nitrogen_quo <- 225

# (VI) Depositing a these randomly distributed seed & nitrogen rates to our gridded field:
whole_plot <- treat_assign(trialarea, trial_grid, head_buffer_ft = width,
                           seed_treat_rates = seed_rates,
                           nitrogen_treat_rates = nitrogen_rates,
                           seed_quo = seed_quo,
                           nitrogen_quo = nitrogen_quo,
                           set_seed=TRUE)

# do simulation
trial <- whole_plot
simulated_trial = simulate_trial(whole_plot, yield, nitrogen, planting)
yield <- simulated_trial$yield
nitrogen <- simulated_trial$asapplied
planting <- simulated_trial$asplanted

# write the new files
st_write(trial, "data/trial_new.gpkg", layer_options = 'OVERWRITE=YES', delete_layer = TRUE)
st_write(yield, "data/yield_new.gpkg", layer_options = 'OVERWRITE=YES', delete_layer = TRUE)
st_write(nitrogen, "data/asapplied_new.gpkg", layer_options = 'OVERWRITE=YES', delete_layer = TRUE)
st_write(planting, "data/asplanted_new.gpkg", layer_options = 'OVERWRITE=YES', delete_layer = TRUE)
