# Lesson 2 catch-up file - current as of Feb 20, 2020

# Set working directory:
# If you haven't re-started R Studio since doing lesson 1,
# you don't need to do this again. 
# If you have restarted R Studio, do this again.
# (If you changed the directory you used in lesson 1, 
# change it here and in the Source command too.)

setwd("C:/DataHarvestingWin/WorkingDir")

# Load your libraries
# Based upon the list at https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/package_load_and_test.R
#
# Again, if you haven't restarted since lesson 1, you can skip this.
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
# If you haven't restarted since lesson 1, you can skip this.
# If you have restarted, do this again.
# If you changed where your functions.R is saved in lesson 1, change it here too.

source('C:/DataHarvestingWin/WorkingDir/functions.R')

# Lesson 2 start: Loading a boundary file
boundary <- read_sf("data/boundary.gpkg")

# Find the center points
lon <- cent_long(boundary)
lat <- cent_lat(boundary)

# Show what those center points are
lon
lat

# Get daymet data relating to those center points
# from 2000 to 2018 and put it in a variable called "weather"
weather <- download_daymet(site = "Field1", lat = lat, lon = lon, start = 2000, end = 2018, internal = TRUE)

# Remember str from lesson 1?
# Let's look at our data structure here too.
str(weather)

# EXERCISE 1: 
# Let's get just the data out of that larger "weather" object
# and put it in a variable called weather_data.
weather_data <- weather$data
str(weather_data)

# There are years and the day number within the year
# but there aren't any dates in this dataset. 
# Let's fix that by adding a new column "date".

weather_data$date <- as.Date.daymetr(weather_data)
head(weather_data$date)

# Does R know that this is a column of "date" type data 
# and not a random set of words? If yes, it will tell us "Date".
class(weather_data$date)

# The precipitation data comes in in millimeters.
head(weather_data$prcp..mm.day., n=20) # print 20 entries of precipitation column in mm

# Let's change that to inches.
weather_data$prec <- mm_to_in(weather_data$prcp..mm.day.) # recall: ".." is treated just like any other letter or number in R!
head(weather_data$prec, n=20) # print 20 entries of precipitation column in inches

# EXERCISE 2
# Look at the original columns in the data
head(weather_data$tmax..deg.c., n=10) # maximum daily temp in C
head(weather_data$tmin..deg.c., n=10) # minimum daily temp in C

# Let's add two new columns to contain the Fahrenheit versions of those
weather_data$tmax <- c_to_f(weather_data$tmax..deg.c.) 
weather_data$tmin <- c_to_f(weather_data$tmin..deg.c.)

# Let's look at the first few lines of the results
head(weather_data$tmax, n=10) # maximum daily temp in F
head(weather_data$tmin, n=10) # minimum daily temp in F

# All the data is for individual days.
# Let's make it possible to group those days by the month they're in.
weather_data$month <- lubridate::month(weather_data$date, label = TRUE)
head(weather_data$month)

# Let's save what we've done so far in another CSV file.
write.csv(weather_data, "weather_2000_2018.csv") 

# Let's calculate how much precipitation happened each month.
by_month_year <- sumprec_by_monthyear(weather_data)
head(by_month_year)

# Show us the start of the list - 
# the first few days are all in January, of course
head(by_month_year$month)

# Getting more information about dplyr
vignette("dplyr")

# Splitting out 2018 from the rest of the years
monthprec_2018 <- subset(by_month_year, year == 2018) 

# EXERCISE 3 - June 2015 and everything not-2018
# Here's how to look at 2015 data
monthprec_2015 <- subset(by_month_year, year == 2015)
head(monthprec_2015)

# Here's how to gather up not-2018 information
monthprec_not_2018 <- subset(by_month_year, year != 2018)
head(monthprec_not_2018)

# Let's say we want just June 2015. 
# We can put together more than one matching condition with &
subset(by_month_year, year == 2015 & month == "Jun")

# Now we're looking at the average rainfall for
# every year other than 2018.
monthprec_avg_not_2018 <- avgprec_by_month(subset(by_month_year, year != 2018))
head(monthprec_avg_not_2018)

# Now we want to merge "2018" and "the average of everything not 2018"
# in order to be able to compare them to each other.
prec_merged <- merge(monthprec_2018, monthprec_avg_not_2018, by = "month")

# Making a graph with those two groups of data.
# The 2018 data is the bars.
# The average of every other year is the dots.
monthly_prec <- ggplot(prec_merged) + 
  geom_bar(aes(x = month, y = prec_month), stat = 'identity') 
monthly_prec + geom_point(aes(month, prec_avg), show.legend = TRUE) + ggtitle("2018 Monthly Precipitation Compared to Average")

