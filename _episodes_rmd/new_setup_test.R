# trial setup run
# Step 1: set working directory
# Step 2: source functions.R from the web
# Step 3: use a "download_and_set_up_data" function 
#   that Jill will put into functions.R to create the 
#   "data" folder (OR plan to copy into whatever "data" folder is there) 
#    and download the data (we will probably need some sort of tryCatch here).
# Step 4: have a "test_my_setup" function in functions.R that runs the 
#    setup script and plots results of tests so that the participants 
#    can compare their plot to our plot

# STEP 1: setwd
setwd('/Users/jillnaiman/testwd/')  #### UPDATE HERE

# STEP 2: source functions.R from web 
source('https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/functions.R')

# STEP 3: re-download data, I don't *THINK* we will need this
# check if data directory exists
reDownloadData = TRUE # only if we wanna re-download the data for any reason
reDownloadTrialData = TRUE # this will download "new" trial data that was simulated

# URLs of data: original data
dataURLS = c("https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/asapplied.gpkg", 
             "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/asplanted.gpkg",
             "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/abline.gpkg", 
             "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/boundary.gpkg",
             "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/trial.gpkg",
             "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/yield.gpkg")

# URLs of simulated data
simsURLS = c("https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/asapplied_new.gpkg", 
             "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/asplanted_new.gpkg",
             "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/trial_new.gpkg",
             "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/yield_new.gpkg")

if (dir.exists(paste0(getwd(),"/data"))){
  #print('Data directory exists!')
  if (reDownloadData){
    for (i in 1:length(dataURLS)){
      # get names of files
      myList = strsplit(dataURLS[i],'/')
      fname = tail(myList[[1]],1)
      download.file(dataURLS[i], paste0(getwd(),"/data/",fname), method = "auto", quiet=FALSE)
    }    
  }
  # also update new ones
  if (reDownloadTrialData){
    for (i in 1:length(simsURLS)){
      # get names of files
      myList = strsplit(simsURLS[i],'/')
      fname = tail(myList[[1]],1)
      download.file(simsURLS[i], paste0(getwd(),"/data/",fname), method = "auto", quiet=FALSE)
    }    
  }  
} else { # create
  dir.create(paste0(getwd(),"/data"))
  # grab all data
  for (i in 1:length(dataURLS)){
    # get names of files
    myList = strsplit(dataURLS[i],'/')
    fname = tail(myList[[1]],1)
    download.file(dataURLS[i], paste0(getwd(),"/data/",fname), method = "auto", quiet=FALSE)
  }
  if (reDownloadTrialData){
    for (i in 1:length(simsURLS)){
      # get names of files
      myList = strsplit(simsURLS[i],'/')
      fname = tail(myList[[1]],1)
      download.file(simsURLS[i], paste0(getwd(),"/data/",fname), method = "auto", quiet=FALSE)
    }    
  }  
}