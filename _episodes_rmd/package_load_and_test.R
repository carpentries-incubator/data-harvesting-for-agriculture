# trial setup run
# Step 1: set working directory
# Step 2: source functions.R from the web
# Step 3: test library setup
# Step 4: download data 

# STEP 1: setwd
#setwd("C:/DataHarvestingWin/WorkingDir")  #### UPDATE HERE

# STEP 2: source functions.R from web 
source('https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/functions.R')

# STEP 3: Run library test
#run_workshop_test(workingDir="C:/DataHarvestingWin/WorkingDir")
run_workshop_test() # default

# STEP 4: re-download data
download_workshop_data() # download all the data


# When you've run this script, look for:
# [1] "Three text elements:"
# [1] "area"
# [1] 1
# [1] "2011-06-04"
# in your console window. 
#
# Then in File Explorer, inside your working directory, look for a folder called test_images
# containing 9 images of data.
