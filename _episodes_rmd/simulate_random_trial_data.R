# Run some sim tests for this dataset
source('https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/functions.R')

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

################################################################

### SIMPLE EXAMPLE FROM GENERATING POINTS 

# INPUTS INTO MODEL
# will be given: rate applied for nitrogen, seeding rate (Rt_Apd_Ct_), and elevation
# OR: do we want to be given a grid and randomly select from a list of ... come back to in am
nPoints = 10000
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
coefsLin <- mvrnorm(n = nPoints, mu = coefficients(myMod), Sigma = vcov(myMod)) ### THIS BELOW IS WHAT WE SIMULATE
coefsLin = subset(coefs,complete.cases(coefs))
# write coefs to CSV
write.csv(coefsLin, '/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/coefs_fit.csv', row.names=F)
# check
#df = read.csv('/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/coefs_fit.csv')
# create random yields
yieldsModLin = coefsLin[,'(Intercept)'] + coefsLin[, 'Rate_Appli']*rapp + coefsLin[, 'Rt_Apd_Ct_']*rseed + 
  coefsLin[, 'Elevation_']*elev

# GLM poissonian model
myMod = glm(Yld_Vol_Dr~Rate_Appli+Rt_Apd_Ct_+Elevation_, data=completedf, family=poisson)
# create new dataframe
newdf = data.frame(rapp,rseed,elev)
colnames(newdf)=c('Rate_Appli', 'Rt_Apd_Ct_', 'Elevation_')
# clean out
completedf = subset(newdf, complete.cases(newdf))
# get expected value of y
mu.y <- predict(myMod, newdata=newdf, type='response')
yieldsMod <- replicate(1, rpois(rep(1, length(mu.y)), mu.y))


# PLOT:
# yield, nitrogen
#y=Yld_Vol_Dr,x=Rate_Appli
par(mfrow=c(1,3))
plot(subplots_data$Rate_Appli, subplots_data$Yld_Vol_Dr, ylim=c(100, 300))#, xlim=c(130, 250))
points(rapp, yieldsMod, col='blue')
points(rapp, yieldsModLin, col='red')

# seeding
#y=Yld_Vol_Dr,x=Rt_Apd_Ct_
plot(subplots_data$Rt_Apd_Ct_, subplots_data$Yld_Vol_Dr, ylim=c(100, 300))
points(rseed, yieldsMod, col='blue')
points(rseed, yieldsModLin, col='red')

# elevation
#y=Yld_Vol_Dr,x=Elevation_
plot(subplots_data$Elevation_, subplots_data$Yld_Vol_Dr, ylim=c(100, 300))
points(elev, yieldsMod, col='blue')
points(elev, yieldsModLin, col='red')

write.csv(coefs, '/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/coefs_fit_glm.csv', row.names=F)

#########################################
# CREATE NEW TRIAL GRID

# (I) Read in and transform our shape files
# NOTE: using stuff direct from "fixed" files
boundary <- st_read("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/boundary.gpkg") # read in boundary
abline <- st_read("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/abline.gpkg") # read in AB line

trialarea <- st_transform_utm(boundary)
abline_utm <- st_transform_utm(abline)

# (II) parameters
width_in_meters = 24 # width of grids is 24 meters
long_direction = 'NS' # direction of grid that will be long
short_direction = 'EW' # direction of grid that will be short
length_in_ft = 180 # length of grids in feet

# (III) making grids
width <- m_to_ft(24) # convert meters to feet
design_grids_utm <- make_grids(trialarea, abline_utm,
                               long_in = long_direction,
                               short_in = short_direction,
                               length_ft = length_in_ft,
                               width_ft = width)

# (IV) correcting the CRS and subsetting to our farm boundary
st_crs(design_grids_utm) <- st_crs(trialarea)
trial_grid <- st_intersection(trialarea, design_grids_utm)

# (V) Picking a range of seed and nitrogen rates for our trials
seed_rates <- c(31000, 34000, 37000, 40000)
nitrogen_rates <- c(160,200,225,250)
# and setting our headlands rates
seed_quo <- 37000
nitrogen_quo <- 225

# (VI) Depositing a these randomly distributed seed & nitrogen rates to our gridded field:
whole_plot <- treat_assign(trialarea, trial_grid, head_buffer_ft = width,
                           seed_treat_rates = seed_rates,
                           nitrogen_treat_rates = nitrogen_rates,
                           seed_quo = seed_quo,
                           nitrogen_quo = nitrogen_quo, set_seed=TRUE)

# check out our plots, you know, if you wanna
# nitrogen_plot <- map_poly(whole_plot, "NRATE", "Nitrogen Treatment")
# seed_plot <- map_poly(whole_plot, "SEEDRATE", "Seedrate Treatment")
# treatment_plot_comp <- tmap_arrange(nitrogen_plot, seed_plot, ncol = 2, nrow = 1)
# treatment_plot_comp

# read
#coefs = read.csv('https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/data/coefs_fit.csv')
coefs = read.csv('https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/data/coefs_fit_glm.csv')

# INPUTS
yield2 <- read_sf("/Users/jillnaiman/trial-lesson_ag/_episodes_rmd/data/yield.gpkg") ## THIS WILL BE THEIR INPUT
asplanted <- st_read("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/asplanted.gpkg")
asapplied <- st_read("/Users/jillnaiman/Dropbox/agriculture_SC_workshop_Feb2020/shifted_gpkg/asapplied.gpkg")

# transform
if (st_crs(yield2) != st_crs(whole_plot)){
  yieldutm = st_transform_utm(yield2)
}
if (st_crs(asplanted) != st_crs(whole_plot)){
  asplanted = st_transform_utm(asplanted)
}
if (st_crs(asapplied) != st_crs(whole_plot)){
  asapplied = st_transform_utm(asapplied)
}
# also, add in random bigs
randomBigProb = 0.005 # will pull random big, looks like this happens ~0.003 of the time
maxBig = 1200
minBig = 400

randomBigProbApp = 0.005 # random as applied
maxBigApp = 50
minBigApp = 1300


# # NOTE!!!  This won't work for geometries that are bigger than originial!!
# # loop through each geometry
# print("This might take a little while... now is a great time for a coffee :)")
# # speed up -> preallocate, evidentally rbind is slow... hurray for R
# yieldOut = yieldutm
# yieldOut$Yld_Vol_Dr = rep(NA, length(yieldOut$Yld_Vol_Dr))# set to NAs initially
# 
# asappliedOut = asapplied
# asappliedOut$Rate_Appli = rep(NA, length(asappliedOut$Rate_Appli))
# 
# asplantedOut = asplanted
# asplantedOut$Rt_Apd_Ct_ = rep(NA, length(asplantedOut$Rt_Apd_Ct_))
# 
# index = 1
# indexApp = 1
# indexPlt = 1
# nPrint = 50
# for (i in 1:length(whole_plot$geom)){
# #for (i in 10:11){
#   samps = 0
#   yieldsMod = 0
#   if (i%%nPrint==0){
#     print(paste0('On ', i, ' of ', length(whole_plot$geom), ' geometries'))
#   }
#   yield_int <- st_intersection(yieldutm, whole_plot$geom[i])
#   asapplied_int <- st_intersection(asapplied, whole_plot$geom[i])
#   asplanted_int <- st_intersection(asplanted, whole_plot$geom[i])
#   
#   # grab elevation for calc
#   if (nrow(asplanted_int)>0){
#     ele = mean(asplanted_int$Elevation_)
#   } else {
#     ele = mean(asplanted$Elevation_)
#   }  
#   
#   # if any yield points in here, let's update them
#   if (nrow(yield_int) > 0) {
#     indexEnd = nrow(yield_int)+index
#     yieldOut$geom[index:indexEnd] = yield_int$geom
#     # update yields
#     mycoefs = coefs[sample(nrow(coefs), nrow(yield_int)), ]
#     yieldsMod = mycoefs[,'X.Intercept.'] + mycoefs[, 'Rate_Appli']*whole_plot$NRATE[i] + 
#       mycoefs[, 'Rt_Apd_Ct_']*whole_plot$SEEDRATE[i] + mycoefs[, 'Elevation_']*ele
#     # add in big stuff randomly 
#     samps = runif(length(yieldsMod))
#     yieldsMod[samps <= randomBigProb] = samps[samps <= randomBigProb]/randomBigProb*(maxBig-minBig) + minBig
#     # update yields
#     yieldOut$Yld_Vol_Dr[index:indexEnd] = yieldsMod
#     index = indexEnd+1
#   }
#   
#   # if any asapplied points in here, let's update them
#   if (nrow(asapplied_int) > 0) {
#     indexEndApp = nrow(asapplied_int)+indexApp
#     asappliedOut$geom[indexApp:indexEndApp] = asapplied_int$geom
#     # update yields
#     # add in big stuff randomly
#     samps = runif(length(asapplied_int$Rate_Appli))
#     asapplied_int$Rate_Appli[samps <= randomBigProbApp] = 
#       samps[samps <= randomBigProbApp]/randomBigProbApp*(maxBigApp-minBigApp) + minBigApp
#     asappliedOut$Rate_Appli[indexApp:indexEndApp] = asapplied_int
#     indexApp = indexEndApp+1
#   }
#   rm(yield_int)
#   rm(yieldsMod)
#   rm(asapplied_int)
# }
# 


nPrint = 50
for (i in 1:length(whole_plot$geom)){
  myOut2 = 0
  asappliedOut2 = 0
  asplantedOut2 = 0
  samps = 0
  if (i%%nPrint==0){
    print(paste0('On ', i, ' of ', length(whole_plot$geom), ' geometries'))
  }
  yield_int <- st_intersection(yieldutm, whole_plot$geom[i])
  asapplied_int <- st_intersection(asapplied, whole_plot$geom[i])
  asplanted_int <- st_intersection(asplanted, whole_plot$geom[i])
  if (flagapp == 0){
      asappliedOut = asapplied_int
      if (nrow(asapplied_int)>0){
        asappliedOut$Rate_Appli = whole_plot$NRATE[i]
      }
      flagapp = 1
  } else {
    if (nrow(asapplied_int)>0){
      asappliedOut2 = asapplied_int
      asappliedOut2$Rate_Appli = whole_plot$NRATE[i]
      # add in big stuff randomly
      samps = runif(length(asappliedOut2$Rate_Appli))
      asappliedOut2$Rate_Appli[samps <= randomBigProbApp] = 
        samps[samps <= randomBigProbApp]/randomBigProbApp*(maxBigApp-minBigApp) + minBigApp
      asappliedOut = rbind(asappliedOut, asappliedOut2)
    }
  }    
  if (flaggplant == 0){
    asplantedOut = asplanted_int
    if (nrow(asplanted_int)>0){
      asplantedOut$Rt_Apd_Ct_ = whole_plot$SEEDRATE[i]
    }
    flaggplant = 1
  } else {
    if (nrow(asplanted_int)>0){
      asplantedOut2 = asplanted_int
      asplantedOut2$Rt_Apd_Ct_ = whole_plot$SEEDRATE[i]
      asplantedOut = rbind(asplantedOut, asplantedOut2)
    }
  }    
  
  
  if (length(row(yield_int)) > 0){ # have entries, update
    # grab random index of row for coefficients of fit
    if (nrow(asplanted_int)>0){
      ele = mean(asplanted_int$Elevation_)
    } else {
      ele = mean(asplanted$Elevation_)
    }
    mycoefs = coefs[sample(nrow(coefs), nrow(yield_int)), ]
    yieldsMod = mycoefs[,'X.Intercept.'] + mycoefs[, 'Rate_Appli']*whole_plot$NRATE[i] + 
      mycoefs[, 'Rt_Apd_Ct_']*whole_plot$SEEDRATE[i] + mycoefs[, 'Elevation_']*ele
    # add in big stuff randomly - DO NOT
    samps = runif(length(yieldsMod))
    yieldsMod[samps <= randomBigProb] = samps[samps <= randomBigProb]/randomBigProb*(maxBig-minBig) + minBig
    if (flag == 0){
      myOut = yield_int
      myOut$Yld_Vol_Dr = yieldsMod
      flag = 1
    } else {
      myOut2 = yield_int
      myOut2$Yld_Vol_Dr = yieldsMod
      myOut = rbind(myOut, myOut2)
    }
  } else { # no entries
    if (flag == 0){
      myOut = yield_int
      flag = 1
    } else {
      myOut2 = yield_int
      myOut = rbind(myOut, myOut2)
    }
  }
  rm(myOut2)
  rm(asappliedOut2)
  rm(asplantedOut2)
  rm(yield_int)
  rm(asapplied_int)
  rm(asplanted_int)
  rm(samps)
}

#see:
# > plot(subplots_data$geometry[10])
# > yield_int <- st_intersection(yield_clean, subplots_data$geometry[10])
# Warning message:
#   attribute variables are assumed to be spatially constant throughout all geometries 
# > plot(yield_int$geom)


# others
trial_utm <- whole_plot
yield_utm <- myOut
yield_clean_border <- clean_buffer(trial_utm, 15, yield_utm)


# testing to see what is taking so long
print("This might take a little while... now is a great time for a coffee :)")
for (i in 1:length(whole_plot$geom)){
  if (i%%10==0){
    print(paste0('On ', i, ' of ', length(whole_plot$geom), ' geometries'))
  }
  yield_int <- st_intersection(yieldutm, whole_plot$geom[i])
  asapplied_int <- st_intersection(asapplied, whole_plot$geom[i])
  asplanted_int <- st_intersection(asplanted, whole_plot$geom[i])
}
