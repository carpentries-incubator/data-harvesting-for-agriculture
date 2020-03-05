# Lesson 8 catch-up file - current as of March 4, 2020

# Find out whether you're working in the directory you intend:
getwd()

# Set working directory:
# If that isn't the directory you want to work in, 
# set your working directory.
# (If you changed the directory you used in lesson 2, 
# change it here.)
# setwd("C:/DataHarvestingWin/WorkingDir")

# Source R scripts particular to this class
# If you need to reload and saved your environment configuration file as
# package_load_and_test.R, remove the # before source.
# (You could also navigate to your file with File-> Open and use
# the Source button.)
#
# source('C:/DataHarvestingWin/WorkingDir/package_load_and_test.R')

# Getting SSURGO data
boundary <- read_sf("data/boundary.gpkg")
boundary.sp <- as(boundary, "Spatial")
ssurgo <- download_ssurgo("samplefield", boundary.sp)

# Renaming muagatt to something human friendly ("names")
names <- ssurgo$tabular$muaggatt 

# Listing the names
names

# Combining the soil name and spatial data into one
# dataframe in order to be able to use them together

spatial <- as(ssurgo$spatial, "sf")
spatial <- dplyr::rename(spatial, musym = MUSYM)
spatial <- dplyr::rename(spatial, mukey = MUKEY)
spatial <- merge(spatial, names, by = "musym")
head(spatial$muname)

# Saving what we've created as a geopackage
st_write(spatial, "data/ssurgo.gpkg", layer_options = 'OVERWRITE=YES')

# Exercise - using map_poly to create a map by soil type
map_soil <- map_poly(spatial, 'muname', "Soil Type")
map_soil

# Creating a soil_content dataframe with SSURGO data
soil_content <- c_s_s_soil(ssurgo = ssurgo)

# Display the contents
soil_content

# Getting DAYMET weather data for our test field
boundary <- read_sf("data/boundary.gpkg")
lon <- cent_long(boundary)
lat <- cent_lat(boundary)

# Checking the latitude and longitude of that test field
lat
lon

# Using download_dayment to get that location's weather
# and putting it into a dataframe named "weather"
weather <- download_daymet(site = "Field1", lat = lat, lon = lon, start = 2000, end = 2018, internal = TRUE)

# Examining that data with str()
str(weather)

# Exercise - Explore the weather data
weather_data <- weather$data
str(weather_data)

# Dates in dataframes
weather_data$date <- as.Date.daymetr(weather_data)
head(weather_data$date)

# Does R know that these items are dates or think they're text?
class(weather_data$date)

# Converting precipitation that was measured in mm to inches
head(weather_data$prcp..mm.day., n=20) # print 20 entries of precipitation column in mm

# Deciding that's a good enough idea to add a new column
# to the table to store all those values as inches

weather_data$prec <- mm_to_in(weather_data$prcp..mm.day.) # recall: ".." is treated just like any other letter or number in R!
head(weather_data$prec, n=20) # print 20 entries of precipitation column in inches

# Unit conversions
head(weather_data$tmax..deg.c., n=10) # maximum daily temp in C
head(weather_data$tmin..deg.c., n=10) # minimum daily temp in C
weather_data$tmax <- c_to_f(weather_data$tmax..deg.c.) 
weather_data$tmin <- c_to_f(weather_data$tmin..deg.c.)
head(weather_data$tmax, n=10) # maximum daily temp in F
head(weather_data$tmin, n=10) # minimum daily temp in F
max(weather_data$tmax)
min(weather_data$tmin)

# Adding another column to the data to store months
# so we can compare January 2001 to January 2018,
# February 2001 to February 2018, etc.

weather_data$month <- lubridate::month(weather_data$date, label = TRUE)
head(weather_data$month)

# Saving the file
write.csv(weather_data, "weather_2000_2018.csv") 

# Looking at adding and averaging precipitation values
by_month_year <- sumprec_by_monthyear(weather_data)
head(by_month_year)

# Why did we get all January events? Because that's how
# it's organized. Let's see what the month options are...
head(by_month_year$month)

# Getting more information about how dplyr works
vignette("dplyr")

# Let's look just at 2018
monthprec_2018 <- subset(by_month_year, year == 2018) 

# Now let's look at June 2015 in particular:
monthprec_2015 <- subset(by_month_year, year == 2015)
head(monthprec_2015)

# Everything that's NOT 2018 for comparing to 2018:
monthprec_not_2018 <- subset(by_month_year, year != 2018)
head(monthprec_not_2018)

# Another way to look at June 2015 in particular:
subset(by_month_year, year == 2015 & month == "Jun")

# Finding the average that's not 2018
# in order to see how 2018 compares to average
monthprec_avg_not_2018 <- avgprec_by_month(subset(by_month_year, year != 2018))
head(monthprec_avg_not_2018)

# Merging so that we compare 2018 to everything else
prec_merged <- merge(monthprec_2018, monthprec_avg_not_2018, by = "month")

# Making a diagram of that comparison
monthly_prec <- ggplot(prec_merged) + 
  geom_bar(aes(x = month, y = prec_month), stat = 'identity') 
monthly_prec + geom_point(aes(month, prec_avg), show.legend = TRUE) + ggtitle("2018 Monthly Precipitation Compared to Average")

