# Lesson 6 catch-up file - current as of Feb 20, 2020

# Set working directory:
# If you haven't re-started R Studio since the previous lesson,
# you don't need to do this again. 
# If you have restarted R Studio, do this again.
# (If you changed the directory you used in lesson 1, 
# change it here and in the Source command too.)

setwd("C:/DataHarvestingWin/WorkingDir")

# Load your libraries
# Based upon the list at https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/package_load_and_test.R
#
# Again, if you haven't restarted since the previous lesson, you can skip this.
# If you have restarted, do these again.

library("rgdal")
library("plyr")
library("dplyr")
library("sp")
library("sf")
library("gstat")
library("tmap")
library("measurements")
library("daymetr")
library("FedData")
library("lubridate")
library("raster")
library("data.table")
library("broom")
library("ggplot2")

# Source R scripts particular to this class
# If you haven't restarted since the previous lesson, you can skip this.
# If you have restarted, do this again.
# If you changed where your functions.R is saved in lesson 1, change it here too.

source('C:/DataHarvestingWin/WorkingDir/functions.R')

# Starting to create a trial design - load files
boundary <- st_read("data/boundary.gpkg") # read in boundary
abline <- st_read("data/abline.gpkg") # read in AB line

# Check coordinate reference system
st_crs(boundary)
st_crs(abline)

# Transform them from lat/long to UTM
boundary_utm <- st_transform_utm(boundary)
abline_utm <- st_transform_utm(abline)

# remove headlands
trialarea <- subset(boundary_utm, Type == "Trial")

# define our parameters
width_in_meters = 24 # width of grids is 24 meters
long_direction = 'NS' # direction of grid that will be long
short_direction = 'EW' # direction of grid that will be short
length_in_ft = 180 # length of grids in feet

# make grids
width <- m_to_ft(24) # convert meters to feet
design_grids_utm <- make_grids(trialarea, abline_utm,
                               long_in = long_direction,
                               short_in = short_direction,
                               length_ft = length_in_ft,
                               width_ft = width)

# overlay grids on trial area
st_crs(design_grids_utm) <- st_crs(trialarea)
trial_grid <- st_intersection(trialarea, design_grids_utm)

# look at the plots
tm_shape(trial_grid) + tm_borders(col='blue')

# determine subplot treatments
seed_rates <- c(31000, 34000, 37000, 40000)
nitrogen_rates <- c(160,200,225,250)

# here's what goes in the headlands
seed_quo <- 37000
nitrogen_quo <- 225

# generate treatment map
whole_plot <- treat_assign(trialarea, trial_grid, head_buffer_ft = width,
                           seed_treat_rates = seed_rates,
                           nitrogen_treat_rates = nitrogen_rates,
                           seed_quo = seed_quo,
                           nitrogen_quo = nitrogen_quo)

# check it out
head(whole_plot)

# show side by side comparisons
nitrogen_plot <- map_poly(whole_plot, "NRATE", "Nitrogen Treatment")
seed_plot <- map_poly(whole_plot, "SEEDRATE", "Seedrate Treatment")
treatment_plot_comp <- tmap_arrange(nitrogen_plot, seed_plot, ncol = 2, nrow = 1)
treatment_plot_comp

