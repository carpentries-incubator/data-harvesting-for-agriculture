library(sf)
library(httr)
library(rgdal)
library(rgeos)
library(maptools)
require(tmap)
require(ggplot2)
require(gridExtra)
library(readr)
library(measurements)
library(dplyr)

# functions
source('~/trial-lesson_ag/_episodes_rmd/functions.R')

nitrogen <- read_sf("~/trial-lesson_ag/_episodes_rmd/data/asapplied_new.gpkg")
yield <- read_sf("~/trial-lesson_ag/_episodes_rmd/data/yield_new.gpkg")
trial <- read_sf("~/trial-lesson_ag/_episodes_rmd/data/trial_new.gpkg")
planting <- read_sf("~/trial-lesson_ag/_episodes_rmd/data/asplanted_new.gpkg")


# clean outliers from yield 
yield <- clean_sd(yield, yield$Yld_Vol_Dr, sd_no=3)

map_yieldcl <- map_points(yield, 'Yld_Vol_Dr', 'Yield (bu/ac)')
map_yieldcl

# clean as planted
planting <- clean_sd(planting,planting$Rt_Apd_Ct_, sd_no=3)

# clean nitrogen application
nitrogen <- clean_sd(nitrogen, nitrogen$Rate_Appli, sd_no=3)

# --------- Exercise Prompt ---------
# With the seeding rate and the nitrogen application rate, we can calculate the cost per 
#  grid. We will use the USDA’s Recent Costs and Returns database for corn, and the USDA’s 
#  Fertilizer Use and Price database for the cost of nitrogen application.

# The database indicates that our seed cost per acre of corn for 2019 averaged 
#  $615.49 per acre, and that fertilizers and chemicals together come to $1,091.89 per 
#  acre. For this exercise, we are going to simplify the model and omit equipment 
#  fuel and maintenance costs, irrigation water, and the like, and focus only on seed 
#  cost and “nitrogen”. We assume that the baseline seed rate is 37,000 seeds per 
#  acre (seed_quo) (although compare this article which posits 33,000). We assume that 
#  the baseline nitrogen application rate is 172 lbs of nitrogen per acre (without 
#  specifying the source, urea or ammonia) as the 2018 baseline.

# We apply these base prices to our trial model to obtain a “seed rate” price of 
#  $615.49/37,000 = $0.0166 per seed and a “nitrogen rate” price of 
#  $1,091.89/172 = $6.35 per lb of nitrogen.

# Using this information, produce a map like in the previous example with the cost indicated.

# Cost = $0.0166 X (as planted rate) + $6.35 X (as applied nitrogen rate)
#      = $0.0166 X (trial$SEEDRATE) + $6.35 X (trial$NRATE)
# e.g. :
#tgts <- map_poly(trial, 'SEEDRATE', 'Seed')
#tgtn <- map_poly(trial, 'NRATE', 'Nitrogen')
trial$COST = 0.0166*trial$SEEDRATE + 6.35*trial$NRATE
map_cost = map_poly(trial, 'COST', 'Cost in US $')
map_cost


## ----------------------- ##

## Solo Exercise: Gross Profit per Grid
# The USDA database indicates $4,407.75 as the baseline gross value of production 
#  for corn per acre in 2019. Assuming the baseline yield is 1,124 bushels per acre 
#  with a price per bushel of $3.91, produce a map with the gross profit per acre indicated.


