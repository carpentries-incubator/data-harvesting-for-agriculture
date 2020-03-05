# Lesson 5 catch-up file - current as of March 5, 2020

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

# Loading boundary file
boundary <- read_sf("data/boundary.gpkg")

# Loading in abline
abline <- st_read("data/abline.gpkg") # read in AB line


# Checking CRS
st_crs(boundary)
st_crs(abline)

# Transforming to UTM
trialarea <- st_transform_utm(boundary)
abline_utm <- st_transform_utm(abline)

# Designing a grid
width_in_meters = 24 # width of grids is 24 meters
long_direction = 'NS' # direction of grid that will be long
short_direction = 'EW' # direction of grid that will be short
length_in_ft = 180 # length of grids in feet

# Making the grid
width <- m_to_ft(24) # convert meters to feet
design_grids_utm <- make_grids(trialarea, abline_utm,
                               long_in = long_direction,
                               short_in = short_direction,
                               length_ft = length_in_ft,
                               width_ft = width)

# Making sure the CRS is the same in both
st_crs(design_grids_utm) <- st_crs(trialarea)

# Putting the grid on top of the trial area
trial_grid <- st_intersection(trialarea, design_grids_utm)

# Display the results
tm_shape(trial_grid) + tm_borders(col='blue')

# Sample rates to apply to the grid
seed_rates <- c(31000, 34000, 37000, 40000)
nitrogen_rates <- c(160,200,225,250)

# Here's what goes in the headlands, which aren't
# part of the trial area
seed_quo <- 37000
nitrogen_quo <- 225

# Creating a treatment plot
whole_plot <- treat_assign(trialarea, trial_grid, head_buffer_ft = width,
                           seed_treat_rates = seed_rates,
                           nitrogen_treat_rates = nitrogen_rates,
                           seed_quo = seed_quo,
                           nitrogen_quo = nitrogen_quo,
                           set_seed=TRUE)

# Let's look at the start of that data
head(whole_plot)

# Let's draw some diagrams of it
nitrogen_plot <- map_poly(whole_plot, "NRATE", "Nitrogen Treatment")
seed_plot <- map_poly(whole_plot, "SEEDRATE", "Seedrate Treatment")
treatment_plot_comp <- tmap_arrange(nitrogen_plot, seed_plot, ncol = 2, nrow = 1)
treatment_plot_comp

