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

# also, old boundary
boundary_old <- st_read("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/boundary.gpkg") # read in boundary
boundary_old_utm <- st_transform_utm(boundary_old)


plot(boundary_old$geom)

abline <- st_read("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/abline.gpkg") # read in AB line
abline_utm = st_transform_utm(abline)

trial <- read_sf("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/trial.gpkg")
trial_utm <- trial

yield <- read_sf("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/yield.gpkg")
yield_utm <- st_transform_utm(yield)

hist(yield_utm$Yld_Vol_Dr)


yield_clean_border <- clean_buffer(trial_utm, 15, yield_utm)
yield_clean <- clean_sd(yield_clean_border, yield_clean_border$Yld_Vol_Dr)
hist(yield_clean$Yld_Vol_Dr)
# write cleaned
st_write(yield_clean, "/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/cleaned_gpkg/yield_clean.gpkg", layer_options = 'OVERWRITE=YES')

subplots_data <- deposit_on_grid(trial_utm, yield_clean, "Yld_Vol_Dr", fn = median)
map_poly(subplots_data_yield, 'Yld_Vol_Dr', "Orig Yield")


asplanted <- st_read("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/asplanted.gpkg")
asplanted_utm <- st_transform_utm(asplanted)
asplanted_clean <- clean_sd(asplanted_utm, asplanted_utm$Rt_Apd_Ct_)
asplanted_clean <- clean_buffer(trial_utm, 15, asplanted_clean)

subplots_data <- deposit_on_grid(subplots_data, asplanted_clean, "Rt_Apd_Ct_", fn = median)
subplots_data <- deposit_on_grid(subplots_data, asplanted_clean, "Elevation_", fn = median)

nitrogen <- read_sf("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/asapplied.gpkg")
nitrogen_utm = st_transform_utm(nitrogen)
nitrogen_clean_border <- clean_buffer(trial_utm, 1, nitrogen_utm)
nitrogen_clean <- clean_sd(nitrogen_clean_border, nitrogen_clean_border$Rate_Appli)
hist(nitrogen_clean$Rate_Appli)
subplots_data <- deposit_on_grid(subplots_data, nitrogen_clean, "Rate_Appli", fn = median)


# ggplot() +
#   geom_smooth(data = subplots_data, method = "gam", aes(y=Yld_Vol_Dr,x=Rt_Apd_Ct_), size = 0.5, se=FALSE) +
#   ylab('Yield (kg/ha)') +
#   xlab('Seed (k/ha)') + 
#   theme_grey(base_size = 12)
# 
# 

par(mfrow=c(1,3))

# grab stuff
myMod = lm(Yld_Vol_Dr~Rate_Appli+Rt_Apd_Ct_+Elevation_, data=subplots_data)
nPoints = 1000
rapp = seq(130, 200, length=nPoints)
rseed = seq(29000, 39000, length=nPoints)
elev = seq(1000, 1050, length=nPoints)
#rapp = seq(min(subplots_data$Rate_Appli, na.rm=TRUE), max(subplots_data$Rate_Appli, na.rm=TRUE), length=200)
#rseed = seq(min(subplots_data$Rt_Apd_Ct_, na.rm=TRUE), max(subplots_data$Rt_Apd_Ct_, na.rm=TRUE), length=200)
#elev = seq(min(subplots_data$Elevation_, na.rm=TRUE), max(subplots_data$Elevation_, na.rm=TRUE), length=200)

#yieldsMod = myMod$coefficients[1] + myMod$coefficients[2]*rapp + myMod$coefficients[3]*rseed + myMod$coefficients[4]*elev
yieldsSTD = coef(summary(myMod))[, "Std. Error"]

# generate new yields points from these fits
#for (i in 1:nPoints){
#  c1 = r(1)
#}
coeff1 = rnorm(nPoints, mean=myMod$coefficients[1], sd = yieldsSTD[1])
coeff2 = rnorm(nPoints, mean=myMod$coefficients[2], sd = yieldsSTD[2])
coeff3 = rnorm(nPoints, mean=myMod$coefficients[3], sd = yieldsSTD[3])
coeff4 = rnorm(nPoints, mean=myMod$coefficients[4], sd = yieldsSTD[4])

yieldsMod = coeff1 + coeff2*rapp + coeff3*rseed + coeff4*elev


# yield, nitrogen
#y=Yld_Vol_Dr,x=Rate_Appli
plot(subplots_data$Rate_Appli, subplots_data$Yld_Vol_Dr)
#lines(rapp, yieldsMod, col='blue')
points(rapp, yieldsMod, col='blue')

# seeding
#y=Yld_Vol_Dr,x=Rt_Apd_Ct_
plot(subplots_data$Rt_Apd_Ct_, subplots_data$Yld_Vol_Dr)
#lines(rseed, yieldsMod, col='blue')
points(rseed, yieldsMod, col='blue')

# elevation
#y=Yld_Vol_Dr,x=Elevation_
plot(subplots_data$Elevation_, subplots_data$Yld_Vol_Dr)
#lines(elev, yieldsMod, col='blue')
points(elev, yieldsMod, col='blue')


