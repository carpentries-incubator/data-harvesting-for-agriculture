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
library("plyr")
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

# test ggplot2
df = data.frame("x"=c(1,2,3), "y"=c(1,2,3))
ggplot(df, aes(x=x, y=y)) + geom_point()

# test sf 
nc <- st_read(system.file("shape/nc.shp", package="sf"))
plot(nc$geometry) 

# test dplyr
names(nc)[1]
nc <- dplyr::rename(nc, area = AREA)
names(nc)[1]

# test gstat
library(sp)
data(meuse)
coordinates(meuse) = ~x+y
data(meuse.grid)
coordinates(meuse.grid) = ~x+y
gridded(meuse.grid) = TRUE

lzn.vgm = variogram(log(zinc)~1,data = meuse)
lzn.fit = fit.variogram(lzn.vgm, model = vgm(1, "Sph", 900, 1))
plot(lzn.vgm, lzn.fit)

# test tmap
tm_shape(nc) + tm_polygons('area')

# test measurements
conv_unit(2.54, "cm", "inch")

# test daymetr
df <- download_daymet(site = "Oak Ridge National Laboratories",
                      lat = 36.0133,
                      lon = -84.2625,
                      start = 2000,
                      end = 2010,
                      internal = TRUE,
                      simplify = TRUE) 

# test FedData
ssurgo <- get_ssurgo(template=c('NC019'), label='county')
plotssurgo <- ssurgo$spatial
plotssurgo <- plotssurgo[4000,]
plot(plotssurgo)

# test lubridate
ymd("20110604")

# test raster
r <- raster(nrows=10, ncols=10)
r <- setValues(r, 1:ncell(r))
plot(r)

# test data.table
DT = data.table(
  ID = c("b","b","b","a","a","c"),
  a = 1:6,
  b = 7:12,
  c = 13:18
)
DT

# test broom
lmfit <- lm(mpg ~ wt, mtcars)
tidy(lmfit)


