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
trial_utm <- trial # note: DO NOT TRY TO CONVERT

# Yield data - what was actually plotted
yield <- read_sf("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/yield.gpkg")
yield_utm <- st_transform_utm(yield)
# if you wanna check it out
#hist(yield_utm$Yld_Vol_Dr)

#  now cleaning
yield_clean_border <- clean_buffer(trial_utm, 15, yield_utm) # clean border
yield_clean <- clean_sd(yield_clean_border, yield_clean_border$Yld_Vol_Dr) # clean by 3SD
hist(yield_clean$Yld_Vol_Dr) # if you wanna check the cleaned data
# write cleaned
st_write(yield_clean, "/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/cleaned_gpkg/yield_clean.gpkg", layer_options = 'OVERWRITE=YES')

subplots_data <- deposit_on_grid(trial_utm, yield_clean, "Yld_Vol_Dr", fn = median)
map_poly(subplots_data_yield, 'Yld_Vol_Dr', "Orig Yield")


asplanted <- st_read("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/asplanted.gpkg")
asplanted_utm <- st_transform_utm(asplanted)
plot(asplanted_utm$geom)
asplanted_clean_border <- clean_buffer(trial_utm, 15, asplanted_utm)
plot(asplanted_clean_border$geom)
asplanted_clean <- clean_sd(asplanted_clean_border, asplanted_clean_border$Rt_Apd_Ct_)
#par(mfrow=c(1,2))
asplanted_plot <- map_points(asplanted_clean, "Rt_Apd_Ct_", "Seed")
trial_plot <- map_poly(subplots_data_yield, 'Yld_Vol_Dr', "Orig Yield")
boundary_plot <- map_poly(boundary_old, 'Type', "Type")
plot_comp <- tmap_arrange(asplanted_plot, trial_plot, boundary_plot, ncol = 3, nrow = 1)
plot_comp

#map_points(asplanted_clean, "Rt_Apd_Ct_", "Seed")
#plot(trial_utm$geom)

hist(asplanted_clean$Rt_Apd_Ct_)

subplots_data <- deposit_on_grid(subplots_data, asplanted_clean, "Rt_Apd_Ct_", fn = median)
#subplots_data2 <- deposit_on_grid(trial_utm, asplanted_clean, "Rt_Apd_Ct_", fn = median)

subplots_data <- deposit_on_grid(subplots_data, asplanted_clean, "Elevation_", fn = median)

nitrogen <- read_sf("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/asapplied.gpkg")
nitrogen_utm = st_transform_utm(nitrogen)
nitrogen_clean_border <- clean_buffer(trial_utm, 1, nitrogen_utm)
nitrogen_clean <- clean_sd(nitrogen_clean_border, nitrogen_clean_border$Rate_Appli)
hist(nitrogen_clean$Rate_Appli)
subplots_data <- deposit_on_grid(subplots_data, nitrogen_clean, "Rate_Appli", fn = median)

# Plot fit model
par(mfrow=c(1,3))
# do simple MLR
myMod = lm(Yld_Vol_Dr~Rate_Appli+Rt_Apd_Ct_+Elevation_, data=subplots_data)
nPoints = 1000
rapp = seq(130, 200, length=nPoints)
rseed = seq(29000, 39000, length=nPoints)
elev = seq(1000, 1050, length=nPoints)

# Grab SE about each coefficient
yieldsSTD = coef(summary(myMod))[, "Std. Error"]

# generate new yields points from these fits, but with randomly chosen coefficients
#coeff1 = rnorm(nPoints, mean=myMod$coefficients[1], sd = yieldsSTD[1])
coeff1 = myMod$coefficients[1]
coeff2 = rnorm(nPoints, mean=myMod$coefficients[2], sd = yieldsSTD[2])
coeff3 = rnorm(nPoints, mean=myMod$coefficients[3], sd = yieldsSTD[3])
coeff4 = rnorm(nPoints, mean=myMod$coefficients[4], sd = yieldsSTD[4])
# create new model:
yieldsMod = coeff1 + coeff2*rapp + coeff3*rseed + coeff4*elev

yieldsModLine = myMod$coefficients[1] + myMod$coefficients[2]*rapp + myMod$coefficients[3]*rseed + myMod$coefficients[4]*elev

# PLOT:
# yield, nitrogen
#y=Yld_Vol_Dr,x=Rate_Appli
plot(subplots_data$Rate_Appli, subplots_data$Yld_Vol_Dr, ylim=c(100, 300))
lines(rapp, yieldsModLine, col="red")
#points(rapp, yieldsMod, col='blue')

# seeding
#y=Yld_Vol_Dr,x=Rt_Apd_Ct_
plot(subplots_data$Rt_Apd_Ct_, subplots_data$Yld_Vol_Dr, ylim=c(100, 300))
lines(rseed, yieldsModLine, col="red")
#points(rseed, yieldsMod, col='blue')

# elevation
#y=Yld_Vol_Dr,x=Elevation_
plot(subplots_data$Elevation_, subplots_data$Yld_Vol_Dr, ylim=c(100, 300))
lines(elev, yieldsModLine, col="red")
#points(elev, yieldsMod, col='blue')


