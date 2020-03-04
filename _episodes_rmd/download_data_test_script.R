# trial setup run
# Step 1: set working directory
# Step 2: source functions.R from the web
# Step 3: download data 
# Step 4: test setup

# STEP 1: setwd
#setwd('/Users/jillnaiman/testwd/')  #### UPDATE HERE

# STEP 2: source functions.R from web 
source('https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/functions.R')

# STEP 3: re-download data, I don't *THINK* we will need this... I am lying we totally do.
download_workshop_data() # download all the data

# STEP 4: Run test script and see about outputs
run_workshop_test()


