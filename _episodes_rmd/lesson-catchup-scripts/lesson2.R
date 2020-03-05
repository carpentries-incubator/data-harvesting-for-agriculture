# Lesson 2 catch-up file - current as of March 4, 2020

# Find out whether you're working in the directory you intend:
getwd()

# Set working directory:
# If that isn't the directory you want to work in, 
# set your working directory.
# (If you changed the directory you used in lesson 2, 
# change it here.)
# setwd("C:/DataHarvestingWin/WorkingDir")

# Source R scripts particular to this class
# If you saved your environment configuration file as
# package_load_and_test.R, do this.
# (You could also navigate to it in File-> Open and use
# the Source button.)
source('C:/DataHarvestingWin/WorkingDir/package_load_and_test.R')

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
