# Both people running R locally and people using a USB stick should run this script.
# This loads the libraries into your computer's memory and makes them available to R
# to use
library("rgdal")
library("dplyr")
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

# test ggplot2
df = data.frame("x"=c(1,2,3), "y"=c(1,2,3))
ggplot(df, aes(x=x, y=y)) + geom_point()
