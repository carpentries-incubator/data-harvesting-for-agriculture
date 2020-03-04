# Lesson 1 catch-up file - current as of March 4, 2020

# Set working directory:
# If you get an error here,
# go to the "Session" menu -> "Set Working Directory" -> 
# "Choose Directory" to pick your working folder.
# For these examples to work as written, you want
# to pick a working directory which contains a 
# subdirectory called "data" which has your data files in it.
# Our assumption is that this will be either
#
# (Windows) C:/DataHarvestingWin/Workingdir 
# or
# (Mac) ~/DataHarvestingMac/Workingdir
#
#

setwd("C:/DataHarvestingWin/WorkingDir")

# Load your libraries
# Based upon the list at https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/package_load_and_test.R
#

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
# If you get an error message here,
# check that you have the contents of the latest functions.R 
# (found at  https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/functions.R  )
# in your working directory.

source('C:/DataHarvestingWin/WorkingDir/functions.R')

# If you need to download the sample data
# Visit:
# https://uofi.box.com/v/dataharvestingdata
# * Click the Download button to get the zip file
# * Uncompress the zip file
# * If you have a previous data folder in your working directory
#   rename it to something like dataOld
# * Copy your new edition of the data folder into WorkingDir
#   so that you have the new data in the "data" subdirectory
#   (i.e. "DataHarvestingWin\WorkingDir\data\(the data files are here))

# Programming concepts

# Silly cheese example, we won't need this again, but
# if you want to see it work...

todays_cheese <- "Stilton" # assign the value of Stilton to a variable called "todays_cheese" -- we don't want to use apostrophes in variable names, so today's_cheese wouldn't work.

print(todays_cheese) # print out the value of the variable to the screen

cheese_variety <- "Stilton" # quotes help your text variables get assigned correctly, especially if it's a multi-word unit like "Double Gloucester cheese"

cheese_amount <- 0.25 # in cups

eggs <- 2 # this will be stored as an integer
cheese_quantity <- 2.0 # this will be stored as a float aka decimal number

# Working with some real data

# Load a CSV (spreadsheet) type file into a variable called fert_use
fert_use <- read.csv("data/fertilizer_use.csv")

# Look at the first few lines of that file
head(fert_use)

# Look at specifically 4 lines of that file
head(fert_use, n=4)

# Find out more about what head does
?head

# Look at what's specifically in the Year column in that dataframe
head(fert_use$Year, n=4)

# Look at what's in the Crop column in that dataframe
head(fert_use$Crop, n=4)

# Find out more about the structure of the data
str(fert_use)

# Doing stuff with your data in R

# What's the earliest year?
min(fert_use$Year)

# What's the latest year?
max(fert_use$Year)

# What's the least amount of nitrogen applied?
min(fert_use$Nitrogen)

# Wait, what's up with NA? Show me more of the data
head(fert_use$Nitrogen, n=50)

# Tell me more about the min function
?min

# How do we prevent those NA values from showing up?
min(fert_use$Nitrogen, na.rm = TRUE)

# EXERCISE 1
# Finding the max
max(fert_use$Nitrogen, na.rm=TRUE)

# EXERCISE 2
# What's a max crop? (Hint: This will return an error.)
max(fert_use$Crop, na.rm=TRUE)

# You can't get the "max" value of something that's not a number.)
