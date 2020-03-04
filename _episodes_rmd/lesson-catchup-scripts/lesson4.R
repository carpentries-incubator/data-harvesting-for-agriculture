# Lesson 4 catch-up file - current as of Feb 20, 2020

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

# Let's load up some trial data and look at it.
planting <- read_sf("data/asplanted.gpkg")
nitrogen <- read_sf("data/asapplied.gpkg")
yield <- read_sf("data/yield.gpkg")
trial <- read_sf("data/trial.gpkg")

# What are the names of the variables in the nitrogen dataframe (created from the as-applied gpkg)?
names(nitrogen)

# How about the yield variables?
names(yield)

# Planting variables next
names(planting)

# EXERCISE: Yield Map
# First check the variable names
names(yield)

# Then use map_points() to make a map of bushels per acre
map_yieldog <- map_points(yield, 'Yld_Vol_Dr', 'Yield (bu/ac)')
map_yieldog

# Note the map doesn't have much contrast. That's
# because some odd values haven't been cleaned up
# and it's skewing the rest of the results.

# Here's an example of data cleaning that doesn't
# involve our map, just a demonstration with numbers.
real_data <- c(900, 450, 200, 320)
error_data <- c(900, 4500, 200, 320)
mean(real_data)
mean(error_data)

# Let's draw a diagram of our error example
plot(error_data) # use plot function on error rate

# Let's put NA on the numbers that are clearly wrong
error_data[error_data > 2000] <- NA # set any values bigger than 2000 to the NA tag
error_data

# Let's do some math on the cleaned up example
mean(error_data, na.rm=TRUE)

# Let's try some cleaning on our real data now
yield <- clean_sd(yield, yield$Yld_Vol_Dr)

# Here's what the cleaned map looks like
map_yieldcl <- map_points(yield, 'Yld_Vol_Dr', 'Yield (bu/ac)')
map_yieldcl

# Let's compare original and cleaned data maps side by side
map_yield_comp <- tmap_arrange(map_yieldog, map_yieldcl, ncol = 2, nrow = 1)
map_yield_comp

# EXERCISE: Trial design map
# Let's try that side by side again, this time
# with the seed map and the nitrogen map.
tgts <- map_poly(trial, 'SEEDRATE', 'Seed') 
tgtn <- map_poly(trial, 'NRATE', 'Nitrogen')
trial_map <- tmap_arrange(tgts, tgtn, ncol = 2, nrow = 1)
trial_map

# Let's work with planting files now
planting <- clean_sd(planting,planting$Rt_Apd_Ct_)
map_asplanted <- map_points(planting, 'Rt_Apd_Ct_', "Applied Seeding Rate")

# Compare planting target to what actually happened
map_planting_comp <- tmap_arrange(map_asplanted, tgts, ncol = 2, nrow = 1)
map_planting_comp

# Nitrogen files next
nitrogen <- clean_sd(nitrogen, nitrogen$Rate_Appli)
map_nitrogen <- map_points(nitrogen, 'Rate_Appli', 'Nitrogen')
map_nitrogen

# Compare nitrogen target to what actually happened
map_nitrogen_comp <- tmap_arrange(map_nitrogen, tgtn, ncol = 2, nrow = 1)
map_nitrogen_comp

# EXERCISE: Yield and application version
map_yield_asplanted <- tmap_arrange(map_yieldcl, map_asplanted, ncol = 2, nrow = 1)
map_yield_asplanted

