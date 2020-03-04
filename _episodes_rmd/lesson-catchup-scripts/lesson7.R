# Lesson 7 catch-up file - current as of March 4, 2020

# Find out whether you're working in the directory you intend:
getwd()

# Set working directory:
# If that isn't the directory you want to work in, 
# set your working directory.
# (If you changed the directory you used in lesson 2, 
# change it here.)
setwd("C:/DataHarvestingWin/WorkingDir")

# Source R scripts particular to this class
# If you saved your environment configuration file as
# package_load_and_test.R, do this.
# (You could also navigate to it in File-> Open and use
# the Source button.)
source('C:/DataHarvestingWin/WorkingDir/package_load_and_test.R')

# Loading boundary file
boundary <- read_sf("data/boundary.gpkg")

# Checking CRS
st_crs(boundary)

# Transforming to UTM
boundary_utm <- st_transform_utm(boundary)
st_crs(boundary_utm)

# Getting the trial design too
trial <- read_sf("data/trial.gpkg")

# Looking at trial CRS
st_crs(trial)

# Transforming to UTM
trial_utm <- trial

# EXERCISE: Same with yield data
yield <- read_sf("data/yield.gpkg")
st_crs(yield)
yield_utm <- st_transform_utm(yield)

# Same with abline file
abline = st_read("data/abline.gpkg")
st_crs(abline)
abline_utm = st_transform_utm(abline)

# Clean the yield data
# First look at what seems odd
hist(yield_utm$Yld_Vol_Dr)

# Trim the borders because those are often 
# differently seeded and fertilized than the rest
yield_clean_border <- clean_buffer(trial_utm, 15, yield_utm)

# Compare original and cleaned versions
yield_plot_orig <- map_points(yield_utm, "Yld_Vol_Dr", "Yield, Orig")
yield_plot_border_cleaned <- map_points(yield_clean_border, "Yld_Vol_Dr", "Yield, No Borders")
yield_plot_comp <- tmap_arrange(yield_plot_orig, yield_plot_border_cleaned, ncol = 2, nrow = 1)
yield_plot_comp

# Look at the cleaned histogram
hist(yield_clean_border$Yld_Vol_Dr)

# Some things are still odd, so let's clean again
yield_clean <- clean_sd(yield_clean_border, yield_clean_border$Yld_Vol_Dr)

# Let's look at the results of the second cleaning
hist(yield_clean$Yld_Vol_Dr)

# Look at the cleaned up yield map
yield_plot_clean <- map_points(yield_clean, "Yld_Vol_Dr", "Yield, Cleaned")
yield_plot_clean

# EXERCISE: Cleaning up the nitrogen data from asapplied.gpkg
nitrogen <- read_sf("data/asapplied.gpkg")
st_crs(nitrogen)
nitrogen_utm <- nitrogen
nitrogen_clean_border <- clean_buffer(trial_utm, 1, nitrogen_utm)
nitrogen_plot_orig <- map_points(nitrogen_utm, "Rate_Appli", "Nitrogen, Orig")
nitrogen_plot_border_cleaned <- map_points(nitrogen_clean_border, "Rate_Appli", "Nitrogen, No Borders")
nitrogen_plot_comp <- tmap_arrange(nitrogen_plot_orig, nitrogen_plot_border_cleaned, ncol = 2, nrow = 1)
nitrogen_plot_comp
nitrogen_clean <- clean_sd(nitrogen_clean_border, nitrogen_clean_border$Rate_Appli)
nitrogen_plot_clean <- map_points(nitrogen_clean, "Rate_Appli", "Nitrogen, Cleaned")
nitrogen_plot_clean
hist(nitrogen_clean$Rate_Appli)

# Designing trials: Making grids
width = m_to_ft(24) # convert from meters to feet
design_grids_utm = make_grids(boundary_utm,
                              abline_utm, long_in = 'NS', short_in = 'EW',
                              length_ft = width, width_ft = width)
st_crs(design_grids_utm)
st_crs(design_grids_utm) = st_crs(boundary_utm)

# Show the grid
plot(design_grids_utm$st_sfc.col_polygons_ls.)

# Lay the grid onto our field's boundary information
trial_grid_utm = st_intersection(boundary_utm, design_grids_utm)

# Show the field with the grid
plot(trial_grid_utm$geom)

# Place the cleaned yield data into the grid
subplots_data <- deposit_on_grid(trial_grid_utm, yield_clean, "Yld_Vol_Dr", fn = median)

# Display the results
map_poly(subplots_data, 'Yld_Vol_Dr', "Yield (bu/ac)")

# Next up: Doing the same for as-planted data
asplanted <- st_read("data/asplanted_new.gpkg")
st_crs(asplanted)
asplanted_utm <- asplanted # already in utm!
asplanted_clean <- clean_sd(asplanted_utm, asplanted_utm$Rt_Apd_Ct_)
asplanted_clean <- clean_buffer(trial_utm, 15, asplanted_clean)

# Show the results
map_points(asplanted_clean, "Rt_Apd_Ct_", "Seed")

# Using our grid with the as-planted data
subplots_data <- deposit_on_grid(subplots_data, asplanted_clean, "Rt_Apd_Ct_", fn = median)
subplots_data <- deposit_on_grid(subplots_data, asplanted_clean, "Elevation_", fn = median)

# Show the results
map_poly(subplots_data, 'Rt_Apd_Ct_', "Seed")

# Using our grid with the nitrogen as applied data
subplots_data <- deposit_on_grid(subplots_data, nitrogen_clean, "Rate_Appli", fn = median)

# Show the results
map_poly(subplots_data, 'Rate_Appli', "Nitrogen")

# Showing relationships between variables
# Yield and elevation:
ggplot() +
  geom_smooth(data = subplots_data, method = "gam", aes(y=Yld_Vol_Dr,x=Elevation_), size = 0.5, se=FALSE) +
  ylab('Yield (kg/ha)') +
  xlab('Elevation') + 
  theme_grey(base_size = 12)

# Yield and seed rates:
ggplot() +
  geom_smooth(data = subplots_data, method = "gam", aes(y=Yld_Vol_Dr,x=Rt_Apd_Ct_), size = 0.5, se=FALSE) +
  ylab('Yield (kg/ha)') +
  xlab('Seed (k/ha)') + 
  theme_grey(base_size = 12)

# Yield and nitrogen:
ggplot() +
  geom_smooth(data = subplots_data, method = "gam", aes(y=Yld_Vol_Dr,x=Rate_Appli), size = 0.5, se=FALSE) +
  ylab('Yield (kg/ha)') +
  xlab('Nitrogen') + 
  theme_grey(base_size = 12)

# Comparing what seed rate was intended with
# the seed rate that was applied, to see how accurate
# the variable rate application was

subplots_data <- deposit_on_grid(subplots_data, trial_utm, "SEEDRATE", fn = median)
map_poly(subplots_data, 'SEEDRATE', "Target Seed")
