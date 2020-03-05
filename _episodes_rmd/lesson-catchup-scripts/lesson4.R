# Lesson 4 catch-up file - current as of March 4, 2020

# Find out whether you're working in the directory you intend:
getwd()

# Set working directory:
# If that isn't the directory you want to work in, 
# set your working directory.
# (If you changed the directory you used in lesson 2, 
# change it here.)
# setwd("C:/DataHarvestingWin/WorkingDir")

# Source R scripts particular to this class
# If you saved your environment configuration file as
# package_load_and_test.R, do this.
# (You could also navigate to it in File-> Open and use
# the Source button.)
source('C:/DataHarvestingWin/WorkingDir/package_load_and_test.R')

# Load the sample field's boundary information
boundary <- read_sf("data/boundary.gpkg")

# Look at its coordinate reference system (CRS)
st_crs(boundary)

# Look at the first few lines of the file
head(boundary$geom)

# Transforming it from lat/long to UTM
boundaryutm <- st_transform_utm(boundary)
st_crs(boundaryutm)

# Exercise: Exploring geospatial files
planting <- read_sf("data/asplanted.gpkg")
st_crs(planting)
planting$geom
plantingutm <- st_transform_utm(planting)
st_crs(plantingutm)

# Save the data as a new file
st_write(boundaryutm, "boundary_utm.gpkg", layer_options = 'OVERWRITE=YES', update = TRUE)

# Using plot to look at the boundary
plot(boundary$geom)

