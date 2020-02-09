# Both people running R locally and people using a USB stick should run this script.
# This loads the libraries into your computer's memory and makes them available to R
# to use.
#
# For people using the USB stick, you can run this right away.
# For people installing on their local computer, you should be finished with 
# the install script process before running this.
# (Look for the red Stop button and a > symbol to tell if you're done. If the
# console prompt says | , an installation is still in process.)

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
