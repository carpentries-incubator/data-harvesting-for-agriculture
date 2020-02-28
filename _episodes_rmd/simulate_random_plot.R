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
#require(ggplot2)
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

par(mfrow=c(1,1))
boundary <- st_read("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/boundary.gpkg") # read in boundary
boundary_utm <- st_transform_utm(boundary)

# Old boundary to grab only trial area
# also, old boundary
boundary_old <- st_read("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/boundary.gpkg") # read in boundary
boundary_old_utm <- st_transform_utm(boundary_old)
#plot(boundary_old$geom)

# not sure if we need abline yet?
abline <- st_read("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/abline.gpkg") # read in AB line
abline_utm = st_transform_utm(abline)

# trial grid
trial <- read_sf("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/trial.gpkg")
##trial <- st_read("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/trial.gpkg") # read in boundary
trial_utm <- trial # note: DO NOT TRY TO CONVERT TO UTM
# make sure we only get in "trial" part of the grid -> from the old boundary file
#boundary_trial = subset(boundary_old_utm, boundary_old_utm$Type == 'Trial')
trial_grid <- trial_utm # was subsetting with "Trial" but not anymore
#trial_grid <- st_intersection(trial_utm, boundary_trial)
# check out this boundary
#par(mfrow=c(1,1))
#tm_shape(trial_grid) + tm_borders(col='blue')


# Yield data - what was actually plotted
yield <- read_sf("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/yield.gpkg")
yield_utm <- st_transform_utm(yield)
# if you wanna check it out
#hist(yield_utm$Yld_Vol_Dr)

#  now cleaning for yields
yield_clean_border <- clean_buffer(trial_utm, 15, yield_utm) # clean border
yield_clean <- clean_sd(yield_clean_border, yield_clean_border$Yld_Vol_Dr) # clean by 3SD
hist(yield_clean$Yld_Vol_Dr) # if you wanna check the cleaned data

# deposit yields on grid - this are plants that actually grew
subplots_data <- deposit_on_grid(trial_grid, yield_clean, "Yld_Vol_Dr", fn = median) # deposit yields
map_poly(subplots_data, 'Yld_Vol_Dr', "Orig Yield") # plot

# these are seeds as planted
asplanted <- st_read("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/asplanted.gpkg")
asplanted_utm <- st_transform_utm(asplanted)
plot(asplanted_utm$geom)
asplanted_clean_border <- clean_buffer(trial_utm, 15, asplanted_utm)
plot(asplanted_clean_border$geom)
asplanted_clean <- clean_sd(asplanted_clean_border, asplanted_clean_border$Rt_Apd_Ct_)

# maken some plots:
#asplanted_plot <- map_points(asplanted_clean, "Rt_Apd_Ct_", "Seed")
#trial_plot <- map_poly(subplots_data, 'Yld_Vol_Dr', "Orig Yield")
#boundary_plot <- map_poly(boundary_old, 'Type', "Type")
#plot_comp <- tmap_arrange(asplanted_plot, trial_plot, boundary_plot, ncol = 3, nrow = 1)
#plot_comp

# deposit the elevation and rate applied as elevation & rt applied
subplots_data <- deposit_on_grid(subplots_data, asplanted_clean, "Rt_Apd_Ct_", fn = median) # deposit planted seeds
subplots_data <- deposit_on_grid(subplots_data, asplanted_clean, "Elevation_", fn = median) # deposit elevation
# this is the designed rate too:
map_seed = map_poly(trial_utm, "SEEDRATE", "SEEDRATE")
#subplots_data <- deposit_on_grid(subplots_data, asplanted_clean, "Elevation_", fn = median)

# aggregated asplanted grid plot
#asplanted_plot_grid <- map_poly(subplots_data, "Rt_Apd_Ct_", "Rt_Apd_Ct_")
#asplanted_plot_grid
#plot_comp2 <- tmap_arrange(asplanted_plot_grid, map_seed, ncol = 2, nrow = 1)
#plot_comp2

#map_points(asplanted_clean, "Rt_Apd_Ct_", "Seed")
#plot(trial_utm$geom)

# plot cleaned value
#hist(asplanted_clean$Rt_Apd_Ct_)

# asplanted vs. yield
#par(mfrow=c(1,1))
#plot(subplots_data$Rt_Apd_Ct_, subplots_data$Yld_Vol_Dr)


nitrogen <- read_sf("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/asapplied.gpkg")
nitrogen_utm = st_transform_utm(nitrogen)
#nitrogen_clean_border <- clean_buffer(trial_utm, 1, nitrogen_utm) # can't really clean, or so they say
#nitrogen_clean <- clean_sd(nitrogen_clean_border, nitrogen_clean_border$Rate_Appli)
nitrogen_clean <- clean_sd(nitrogen_utm, nitrogen_utm$Rate_Appli)
hist(nitrogen_clean$Rate_Appli)
subplots_data <- deposit_on_grid(subplots_data, nitrogen_clean, "Rate_Appli", fn = median)


# INPUTS INTO MODEL
# will be given: rate applied for nitrogen, seeding rate (Rt_Apd_Ct_), and elevation
# OR: do we want to be given a grid and randomly select from a list of ... come back to in am
nPoints = 1000
rapp = seq(130, 200, length=nPoints)
#rapp_rates = c(130, 160,200,225,250) # only certain rates
#rapp = sample(rapp_rates, size=nPoints, replace=TRUE)
rseed_rates = c(30000, 32000, 34000, 36000, 38000) # only certain rates
rseed = sample(rseed_rates, size=nPoints, replace=TRUE)
elev = seq(1000, 1050, length=nPoints)


# FIT MODEL AND GRAB YIELDS OUT
# do simple MLR/GLM
#myMod = lm(Yld_Vol_Dr~Rate_Appli+Rt_Apd_Ct_+Elevation_, data=subplots_data)
myMod = glm(Yld_Vol_Dr~Rate_Appli+Rt_Apd_Ct_+Elevation_, data=subplots_data) ### THIS IS WHAT WE WANT TO SAVE

## read in model here!

# simulate the range of coefficients
coefs <- rnorm(n = nPoints, mean = coefficients(myMod), sd = vcov(myMod)) ### THIS BELOW IS WHAT WE SIMULATE
# create random yields
yieldsMod = coefs[,'(Intercept)'] + coefs[, 'Rate_Appli']*rapp + coefs[, 'Rt_Apd_Ct_']*rseed + coefs[, 'Elevation_']*elev



# PLOT:
# yield, nitrogen
#y=Yld_Vol_Dr,x=Rate_Appli
plot(subplots_data$Rate_Appli, subplots_data$Yld_Vol_Dr)#, ylim=c(100, 300))#, xlim=c(130, 250))
#lines(rapp, yieldsModLine, col="red")
points(rapp, yieldsMod, col='blue')

# seeding
#y=Yld_Vol_Dr,x=Rt_Apd_Ct_
plot(subplots_data$Rt_Apd_Ct_, subplots_data$Yld_Vol_Dr)#, ylim=c(100, 300))
#lines(rseed, yieldsModLine, col="red")
points(rseed, yieldsMod, col='blue')

# elevation
#y=Yld_Vol_Dr,x=Elevation_
plot(subplots_data$Elevation_, subplots_data$Yld_Vol_Dr)#, ylim=c(100, 300))
#lines(elev, yieldsModLine, col="red")
points(elev, yieldsMod, col='blue')


