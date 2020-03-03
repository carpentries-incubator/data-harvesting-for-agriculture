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

# READING IN FILES TO GENERATE "FAKE" DATA & TRANSFORMING
par(mfrow=c(1,1))
# Old boundary to grab only trial area
# also, old boundary -- this is where the *real* trial data comes from
boundary_old <- st_read("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/boundary.gpkg") # read in boundary
boundary_old_utm <- st_transform_utm(boundary_old)
#plot(boundary_old$geom)

# not sure if we need abline yet?
abline <- st_read("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/abline.gpkg") # read in AB line
abline_utm = st_transform_utm(abline)

# trial grid
trial <- read_sf("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/trial.gpkg")
trial_utm <- trial # note: DO NOT TRY TO CONVERT TO UTM
trial_grid <- trial_utm # was subsetting with "Trial" but not anymore

# Yield data - what was actually harvested
yield <- read_sf("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/yield.gpkg")
yield_utm <- st_transform_utm(yield)

#  now cleaning for yields
yield_clean_border <- clean_buffer(trial_utm, 15, yield_utm) # clean border
yield_clean <- clean_sd(yield_clean_border, yield_clean_border$Yld_Vol_Dr) # clean by 3SD
#hist(yield_clean$Yld_Vol_Dr) # if you wanna check the cleaned data

# deposit yields on grid - this are plants that actually grew
subplots_data <- deposit_on_grid(trial_grid, yield_clean, "Yld_Vol_Dr", fn = median) # deposit yields
#map_poly(subplots_data, 'Yld_Vol_Dr', "Orig Yield") # plot

# these are seeds as planted
asplanted <- st_read("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/asplanted.gpkg")
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
# this is the designed rate too, for plotting
#map_seed = map_poly(trial_utm, "SEEDRATE", "SEEDRATE")
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


nitrogen <- read_sf("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/asapplied.gpkg")
nitrogen_utm = st_transform_utm(nitrogen)
#nitrogen_clean_border <- clean_buffer(trial_utm, 1, nitrogen_utm) # can't really clean, or so they say
#nitrogen_clean <- clean_sd(nitrogen_clean_border, nitrogen_clean_border$Rate_Appli)
nitrogen_clean <- clean_sd(nitrogen_utm, nitrogen_utm$Rate_Appli)
hist(nitrogen_clean$Rate_Appli)
subplots_data <- deposit_on_grid(subplots_data, nitrogen_clean, "Rate_Appli", fn = median)

###########################################################################
# FIT MODEL AND GRAB YIELDS OUT

# Plot model
# PLOT:
# yield, nitrogen
#y=Yld_Vol_Dr,x=Rate_Appli
par(mfrow=c(1,3))
plot(subplots_data$Rate_Appli, subplots_data$Yld_Vol_Dr)

# seeding
#y=Yld_Vol_Dr,x=Rt_Apd_Ct_
plot(subplots_data$Rt_Apd_Ct_, subplots_data$Yld_Vol_Dr)

# elevation
#y=Yld_Vol_Dr,x=Elevation_
plot(subplots_data$Elevation_, subplots_data$Yld_Vol_Dr)

# create new dataframe
y = subplots_data$Yld_Vol_Dr
x1 = subplots_data$Rate_Appli
x2 = subplots_data$Rt_Apd_Ct_
x3 = subplots_data$Elevation_

newdf = data.frame(y,x1,x2,x3)
colnames(newdf)=c('Yld_Vol_Dr', 'Rate_Appli', 'Rt_Apd_Ct_', 'Elevation_')
# clean out
completedf = subset(newdf, complete.cases(newdf))

# do simple MLR/GLM
myMod = lm(Yld_Vol_Dr~Rate_Appli+Rt_Apd_Ct_+Elevation_, data=completedf)
#myMod = glm(Yld_Vol_Dr~Rate_Appli+Rt_Apd_Ct_+Elevation_, data=subplots_data) ### THIS IS WHAT WE WANT TO SAVE
#myMod = glm(Yld_Vol_Dr~Rate_Appli+Rt_Apd_Ct_+Elevation_, data=completedf, family=poisson())

################################################################

### SIMPLE EXAMPLE FROM GENERATING POINTS

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

## read in model here!

# simulate the range of coefficients
# reference: https://www.jamesuanhoro.com/post/2018/05/07/simulating-data-from-regression-models/
#coefs <- rnorm(n = nPoints, mean = coefficients(myMod), sd = vcov(myMod)) ### WHY NO WORK I ASK YOU
library(MASS) # For multivariate normal distribution, handy later on
coefs <- mvrnorm(n = nPoints, mu = coefficients(myMod), Sigma = vcov(myMod)) ### THIS BELOW IS WHAT WE SIMULATE
# create random yields
yieldsMod = coefs[,'(Intercept)'] + coefs[, 'Rate_Appli']*rapp + coefs[, 'Rt_Apd_Ct_']*rseed + coefs[, 'Elevation_']*elev



# PLOT:
# yield, nitrogen
#y=Yld_Vol_Dr,x=Rate_Appli
plot(subplots_data$Rate_Appli, subplots_data$Yld_Vol_Dr)#, ylim=c(100, 300))#, xlim=c(130, 250))
points(rapp, yieldsMod, col='blue')

# seeding
#y=Yld_Vol_Dr,x=Rt_Apd_Ct_
plot(subplots_data$Rt_Apd_Ct_, subplots_data$Yld_Vol_Dr)#, ylim=c(100, 300))
points(rseed, yieldsMod, col='blue')

# elevation
#y=Yld_Vol_Dr,x=Elevation_
plot(subplots_data$Elevation_, subplots_data$Yld_Vol_Dr)#, ylim=c(100, 300))
points(elev, yieldsMod, col='blue')


