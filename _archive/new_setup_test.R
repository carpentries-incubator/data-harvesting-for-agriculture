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
#setwd('/Users/jillnaiman/testwd/')  #### UPDATE HERE

# STEP 2: source functions.R from web 
source('https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/functions.R')

# STEP 3: re-download data, I don't *THINK* we will need this... I am lying we totally do.
download_workshop_data() # download all the data

# STEP 4: Run test script and see about outputs


# check if data directory exists
# reDownloadData = TRUE # only if we wanna re-download the data for any reason
# reDownloadTrialData = TRUE # this will download "new" trial data that was simulated
# downloadScripts = TRUE # download lesson catchups
# 
# # URLs of data: original data
# dataURLS = c("https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/asapplied.gpkg", 
#              "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/asplanted.gpkg",
#              "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/abline.gpkg", 
#              "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/boundary.gpkg",
#              "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/trial.gpkg",
#              "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/yield.gpkg")
# 
# # URLs of simulated data
# simsURLS = c("https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/asapplied_new.gpkg", 
#              "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/asplanted_new.gpkg",
#              "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/trial_new.gpkg",
#              "https://github.com/data-carpentry-for-agriculture/trial-lesson/raw/gh-pages/_episodes_rmd/data/yield_new.gpkg")
# 
# # URLS of catchup scripts
# scriptURLS = c("https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/lesson-catchup-scripts/lesson1.R",
#                "https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/lesson-catchup-scripts/lesson2.R",
#                "https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/lesson-catchup-scripts/lesson3.R",
#                "https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/lesson-catchup-scripts/lesson4.R",
#                "https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/lesson-catchup-scripts/lesson5.R",
#                "https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/lesson-catchup-scripts/lesson6.R",
#                "https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/lesson-catchup-scripts/lesson7.R",
#                "https://raw.githubusercontent.com/data-carpentry-for-agriculture/trial-lesson/gh-pages/_episodes_rmd/lesson-catchup-scripts/lesson8.R")
# 
# if (dir.exists(paste0(getwd(),"/data"))){
#   #print('Data directory exists!')
#   if (reDownloadData){
#     for (i in 1:length(dataURLS)){
#       # get names of files
#       myList = strsplit(dataURLS[i],'/')
#       fname = tail(myList[[1]],1)
#       download.file(dataURLS[i], paste0(getwd(),"/data/",fname), method = "auto", quiet=FALSE)
#     }    
#   }
#   # also update new ones
#   if (reDownloadTrialData){
#     for (i in 1:length(simsURLS)){
#       # get names of files
#       myList = strsplit(simsURLS[i],'/')
#       fname = tail(myList[[1]],1)
#       download.file(simsURLS[i], paste0(getwd(),"/data/",fname), method = "auto", quiet=FALSE)
#     }    
#   }  
# } else { # create
#   dir.create(paste0(getwd(),"/data"))
#   # grab all data
#   for (i in 1:length(dataURLS)){
#     # get names of files
#     myList = strsplit(dataURLS[i],'/')
#     fname = tail(myList[[1]],1)
#     download.file(dataURLS[i], paste0(getwd(),"/data/",fname), method = "auto", quiet=FALSE)
#   }
#   if (reDownloadTrialData){
#     for (i in 1:length(simsURLS)){
#       # get names of files
#       myList = strsplit(simsURLS[i],'/')
#       fname = tail(myList[[1]],1)
#       download.file(simsURLS[i], paste0(getwd(),"/data/",fname), method = "auto", quiet=FALSE)
#     }    
#   }  
# }
# 
# # Also download all catchup scripts
# if (downloadScripts){
#   if (!(dir.exists(paste0(getwd(),"/lesson-catchup-scripts")))){
#     dir.create(paste0(getwd(),"/lesson-catchup-scripts"))
#   } 
#   
#   for (i in 1:length(scriptURLS)){
#     # get names of files
#     myList = strsplit(scriptURLS[i],'/')
#     fname = tail(myList[[1]],1)
#     download.file(scriptURLS[i], paste0(getwd(),"/lesson-catchup-scripts/",fname), method = "auto", quiet=FALSE)
#   }  
# }
# 


# STEP 4: "test my setup"
# make "test images folder" in working dir
run_workshop_test()


# # copied from before:
# library("rgdal")
# library("plyr")
# library("dplyr")
# library("sp")
# library("sf")
# library("gstat")
# library("tmap")
# library("measurements")
# library("daymetr")
# library("FedData")
# library("lubridate")
# library("raster")
# library("data.table")
# library("broom")
# library("ggplot2")
# 
# #set margins
# par(mar=c(1,1,1,1))
# 
# 
# if (!(dir.exists(paste0(getwd(),"/test_images")))){
#   dir.create(paste0(getwd(),"/test_images"))
# }
# 
# # plot #1
# jpeg(paste0(getwd(),"/test_images/plot1_ggplot2.jpg"))
# # test ggplot2
# df = data.frame("x"=c(1,2,3), "y"=c(1,2,3))
# myPlot1 = ggplot(df, aes(x=x, y=y)) + geom_point()
# #plot(myPlot1)
# #pushViewport(myPlot1)
# # grab data, plot with default
# plot(myPlot1$data)
# dev.off()
# 
# 
# # plot #2
# jpeg(paste0(getwd(),"/test_images/plot2_sf.jpg"))
# # test sf 
# plot.new()
# nc <- st_read(system.file("shape/nc.shp", package="sf"))
# #pushViewport(plot(nc$geometry) )
# #x = recordPlot(nc$geometry)
# plot(nc$geometry)
# dev.off()
# 
# # text #1
# # test dplyr
# names(nc)[1]
# nc <- dplyr::rename(nc, area = AREA)
# text1 = names(nc)[1]
# 
# # plot #3
# jpeg(paste0(getwd(),"/test_images/plot3_gstat.jpg"))
# # test gstat
# library(sp)
# data(meuse)
# coordinates(meuse) = ~x+y
# data(meuse.grid)
# coordinates(meuse.grid) = ~x+y
# gridded(meuse.grid) = TRUE
# #   plot
# lzn.vgm = variogram(log(zinc)~1,data = meuse)
# lzn.fit = fit.variogram(lzn.vgm, model = vgm(1, "Sph", 900, 1))
# myPlot = plot(lzn.vgm, lzn.fit)
# plot(myPlot)
# dev.off()
# 
# # plot #4
# jpeg(paste0(getwd(),"/test_images/plot4_tmap.jpg"))
# # test tmap
# #nc <- st_read(system.file("shape/nc.shp", package="sf"))
# myMap = tm_shape(nc) + tm_polygons('area')
# #plot(myMap)
# tmap_save(myMap, paste0(getwd(),"/test_images/plot4_tmap.jpg"))
# dev.off()
# 
# # text #2
# # test measurements
# text2 = conv_unit(2.54, "cm", "inch")
# 
# # plot #5
# jpeg(paste0(getwd(),"/test_images/plot5_daymetr.jpg"))
# # test daymetr
# df <- download_daymet(site = "Oak Ridge National Laboratories",
#                       lat = 36.0133,
#                       lon = -84.2625,
#                       start = 2000,
#                       end = 2010,
#                       internal = TRUE,
#                       simplify = TRUE)
# plot(df$year, df$value)
# dev.off()
# 
# # plot 6
# jpeg(paste0(getwd(),"/test_images/plot6_ssurgo.jpg"))
# # test FedData
# ssurgo <- get_ssurgo(template=c('NC019'), label='county')
# plotssurgo <- ssurgo$spatial
# plotssurgo <- plotssurgo[4000,]
# plot(plotssurgo)
# dev.off()
# 
# # text #3
# # test lubridate
# text3 = ymd("20110604")
# 
# # plot 7
# # test raster
# jpeg(paste0(getwd(),"/test_images/plot7_raster.jpg"))
# r <- raster(nrows=10, ncols=10)
# r <- setValues(r, 1:ncell(r))
# plot(r)
# dev.off()
# 
# # plot 8
# jpeg(paste0(getwd(),"/test_images/plot8_datatable.jpg"))
# # test data.table
# DT = data.table(
#   ID = c("b","b","b","a","a","c"),
#   a = 1:6,
#   b = 7:12,
#   c = 13:18
# )
# #DT
# plot(DT$a, DT$b)
# dev.off()
# 
# # plot 9
# jpeg(paste0(getwd(),"/test_images/plot9_broom.jpg"))
# # test broom
# lmfit <- lm(mpg ~ wt, mtcars)
# myFit = tidy(lmfit)
# plot(c(myFit$estimate, myFit$statistic, myFit$std.error, myFit$p.value))
# dev.off()
# 
# print(' ')
# print(' ')
# print('Three text elements:')
# print(text1)
# print(text2)
# print(text3)
# 
# 
