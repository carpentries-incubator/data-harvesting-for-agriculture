# Lesson 6 catch-up file - current as of March 4, 2020

# Find out whether you're working in the directory you intend:
getwd()

# Set working directory:
# If that isn't the directory you want to work in, 
# set your working directory.
# (If you changed the directory you used in lesson 2, 
# change it here.)
# setwd("C:/DataHarvestingWin/WorkingDir")

# Source R scripts particular to this class
# If you need to reload and saved your environment configuration file as
# package_load_and_test.R, remove the # before source.
# (You could also navigate to your file with File-> Open and use
# the Source button.)
#
# source('C:/DataHarvestingWin/WorkingDir/package_load_and_test.R')

# Let's load up some trial data and look at it.
planting <- read_sf("data/asplanted_new.gpkg")
nitrogen <- read_sf("data/asapplied_new.gpkg")
yield <- read_sf("data/yield_new.gpkg")
trial <- read_sf("data/trial_new.gpkg")

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
yield <- clean_sd(yield, yield$Yld_Vol_Dr, sd_no=3)

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
planting <- clean_sd(planting,planting$Rt_Apd_Ct_, sd_no=3)
map_asplanted <- map_points(planting, 'Rt_Apd_Ct_', "Applied Seeding Rate")

# Compare planting target to what actually happened
map_planting_comp <- tmap_arrange(map_asplanted, tgts, ncol = 2, nrow = 1)
map_planting_comp

# Nitrogen files next
nitrogen <- clean_sd(nitrogen, nitrogen$Rate_Appli, sd_no=3)
map_nitrogen <- map_points(nitrogen, 'Rate_Appli', 'Nitrogen')
map_nitrogen

# Compare nitrogen target to what actually happened
map_nitrogen_comp <- tmap_arrange(map_nitrogen, tgtn, ncol = 2, nrow = 1)
map_nitrogen_comp

# EXERCISE: Yield and application version
map_yield_asplanted <- tmap_arrange(map_yieldcl, map_asplanted, ncol = 2, nrow = 1)
map_yield_asplanted

