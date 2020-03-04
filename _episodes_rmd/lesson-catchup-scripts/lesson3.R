# Lesson 3 catch-up file - current as of Feb 20, 2020

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

# Let's load a boundary file
boundary <- read_sf("data/boundary.gpkg")

# Let's check its Coordinate Reference System (CRS)
st_crs(boundary)

# Let's look at the start of the geometry information
head(boundary$geom)

# Let's convert it from lat/long to UTM
boundaryutm <- st_transform_utm(boundary)
st_crs(boundaryutm)

# EXERCISE: Exploring Geospatial Files
# Load the planting information
planting <- read_sf("data/asplanted.gpkg")
st_crs(planting)
planting$geom

#Let's change it to UTM
plantingutm <- st_transform_utm(planting)
st_crs(plantingutm)

# Let's save it to a file called boundary_utm.gpkg
st_write(boundaryutm, "boundary_utm.gpkg", layer_options = 'OVERWRITE=YES')

# Let's draw a plot of it
plot(boundary$geom)

# Let's color it in with the difference between the 
# header areas and the rest of the field
map_poly(boundary, 'Type', 'Part of Field')

# Downloading SSURGO data
# Note: Sometimes the SSURGO servers give errors here.
# Check with the instructors for alternatives if so.
boundary <- subset(boundary, Type == "Trial")
boundary.sp <- as(boundary, "Spatial")
ssurgo <- download_ssurgo("samplefield", boundary.sp)

# There's something called muaggatt in the data.
# Let's put that in a variable called "names"
# (which is much human-friendlier than "muaggatt")
names <- ssurgo$tabular$muaggatt 

# Let's display what's in that data
names

# The people who created the data weren't entirely
# consistent. Something's called MUSYM in one spot
# and musym in another, and we need to fix that
# to be able to compare the soil data and the spatial
# data. (Same is true of MUKEY and mukey.)

spatial <- as(ssurgo$spatial, "sf")
spatial <- dplyr::rename(spatial, musym = MUSYM)
spatial <- dplyr::rename(spatial, mukey = MUKEY)
spatial <- merge(spatial, names, by = "musym")
head(spatial$muname)

# Let's write this to a file too.
st_write(spatial, "data/ssurgo.gpkg", layer_options = 'OVERWRITE=YES')

# Making a color coded map with what we've assembled
map_soil <- map_poly(spatial, 'muname', "Soil Type")
map_soil

# Taking a look at soil type
soil_content <- c_s_s_soil(ssurgo = ssurgo)
soil_content

