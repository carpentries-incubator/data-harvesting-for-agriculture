library("rgdal")
library("sp")
library("raster")
library("tmap")
library("maptools")
library("dplyr")
library("Hmisc")
library("sf")

#Here is one way of making the subplots. The method depends on the origrinal trial design.

# set direction
setwd("~/Downloads/data carpentry - data cleaning")

#Define information to be inserted into file names below 
farm<-"hord"
field<-"f98"
x<-c(farm,field,"trialdesign",2017)
file<-paste(x, collapse="_")
appmap <-  readOGR(".",file)
# Define the UTM zone #
sp::proj4string(appmap) <- sp::CRS('+proj=longlat +datum=WGS84')
#Calculate the utm zone (formula from wikipedia)
utmzone <- floor(((mean(bbox(appmap)[1,]) + 180) / 6) %% 60) + 1
# Convert to UTM #
appmap <- sp::spTransform(appmap,sp::CRS(paste0('+proj=utm +zone=',utmzone,' ellps=WGS84' )))
#check the appmap data frame
head(appmap)
tail(appmap)
appmap[220,5]

# Remove Partial Blocks and Blocks without Treatment #
# calculating the area for each plot, so that we can remove partial plots.
appmap$area <- area(appmap)
# show the area of each plot, and set a reasonable threshold for removing partial plots.
appmap$area
# Since the majority of plots are larger than 1571.88, we set the threshold to be 1571,
# and For the plots that are smaller than 1571, we assign its treat_type to be 26.
# This trial has 5 nitrogen treatment rates and 5 seed rates, therefore there are 25 treatments
# in total, and 26th treatment is the combination of statusquo rate of nitrogen and seed
# producer would have put down if not the trial experiment.
appmap$treat_type<-ifelse(appmap$area<=1571,26,appmap$treat_type)
#eliminate the plots with 26th treatment, because we only run analysis on the variable rates
# designed
appmap <- appmap[appmap$treat_type !=  26, ]
#check the data frame again, rename the target rates, and remove the unneccesary variables.
head(appmap)
appmap$CLIENT <- NULL
appmap$FARM <- NULL
appmap$FIELD <- NULL
appmap$Tgt_Nrate <- appmap$NRATE
appmap$Tgt_seedrate <- appmap$SEEDRATE
appmap$NRATE <- NULL
appmap$SEEDRATE <- NULL
appmap

# Create new plotid's #
appmap$new_plotid <- seq.int(nrow(appmap))

# Looping through to design new plots #
# Find coordinates of the plots #
# appmap1 <- subset(appmap, new_plotid == 1)
# head(appmap1)
coords1 <- appmap@polygons[[1]]@Polygons[[1]]@coords #Grabs the long and lat in a 5x2 matrix.

# Find the angle of the 
ror1 <- (coords1[4,2]-coords1[1,2])/(coords1[4,1]-coords1[1,1])
angle1 <- atan(ror1)
sin1 <- sin(angle1)
cos1 <- cos(angle1)
# 30 ft= 9.144 meters #
move <- c(9.144*cos1,9.144*sin1)

gsw1 <- coords1[1,]+move
gnw1 <- coords1[2,]+move
gne1 <- coords1[3,]-move
gse1 <- coords1[4,]-move

coords1_reduced <- rbind(t(gsw1),t(gnw1),t(gne1),t(gse1),t(gsw1))
coords1.dt <- data.table::as.data.table(coords1)
coords1_reduced.dt <- data.table::as.data.table(coords1_reduced)
###################Divide the reduced plot into four equally-sized partial plots.##########

#Find length of reduced plot, in meters:
plotlength1 <- rbind(gnw1,gne1)
subplotlength1 <- as.numeric(dist(plotlength1))/4

go <- c(subplotlength1*cos1, subplotlength1*sin1)

#Take first two vertices of the subplot, then create two more vertices that are used to make the next subplot.
#Subplots have to be 25% as long as the reduced plot.
coordssubplot1_1 <- rbind(coords1_reduced[1:2,],(coords1_reduced[2:1,]+rbind(go,go)),coords1_reduced[1,])
coordssubplot1_1.dt <- data.table::as.data.table(coordssubplot1_1)

coordssubplot1_2 <- rbind(coordssubplot1_1[4:3,],(coordssubplot1_1[3:4,]+rbind(go,go)),coordssubplot1_1[4,])
coordssubplot1_2.dt <- data.table::as.data.table(coordssubplot1_2)

coordssubplot1_3 <- rbind(coordssubplot1_2[4:3,],(coordssubplot1_2[3:4,]+rbind(go,go)),coordssubplot1_2[4,])
coordssubplot1_3.dt <- data.table::as.data.table(coordssubplot1_3)

coordssubplot1_4 <- rbind(coordssubplot1_3[4:3,],(coordssubplot1_3[3:4,]+rbind(go,go)),coordssubplot1_3[4,])
coordssubplot1_4.dt <- data.table::as.data.table(coordssubplot1_4)

# Create polygons #
poly1_1<-Polygon(coordssubplot1_1)
poly1_2<-Polygon(coordssubplot1_2)
poly1_3<-Polygon(coordssubplot1_3)
poly1_4<-Polygon(coordssubplot1_4)

# Put polygons in a list #
list1<-Polygons(list(poly1_1,poly1_2,poly1_3,poly1_4),"1")
plots<-SpatialPolygons(list(list1))
polyproj <- CRS(paste0('+proj=utm +zone=',utmzone,' ellps=WGS84'))
proj4string(plots) <- polyproj

plotid <- unique(appmap@data$new_plotid)
# Loop through all plots taking off ends, splitting into 4 plots, and rbinding to the first polygon
for (i in plotid[-1]) {
  # Find coordinates of the plots #
  appmap1 <- subset(appmap, new_plotid == i)
  coords1 <- appmap1@polygons[[1]]@Polygons[[1]]@coords #Grabs the long and lat in a 5x2 matrix.
  
  # Find the angle of the 
  ror1 <- (coords1[4,2]-coords1[1,2])/(coords1[4,1]-coords1[1,1])
  ror1
  angle1 <- atan(ror1)
  angle1
  
  sin1 <- sin(angle1)
  cos1 <- cos(angle1)
  # 30 ft= 9.144 meters #
  move <- c( 9.144*cos1, 9.144*sin1   )
  
  gsw1 <- coords1[1,]+move
  gnw1 <- coords1[2,]+move
  gne1 <- coords1[3,]-move
  gse1 <- coords1[4,]-move
  
  coords1_reduced <- rbind(t(gsw1),t(gnw1),t(gne1),t(gse1),t(gsw1))
  coords1_reduced
  
  coords1.dt <- data.table::as.data.table(coords1)
  coords1_reduced.dt <- data.table::as.data.table(coords1_reduced)
  
  ###################Divide the reduced plot into four equally-sized partial plots.##########
  
  #Find length of reduced plot, in meters:
  plotlength1 <- rbind(gnw1,gne1)
  subplotlength1 <- as.numeric(dist(plotlength1))/4
  
  go <- c( subplotlength1*cos1, subplotlength1*sin1   )
  
  #Take first two vertices of the subplot, then create two more vertices that are used to make the next subplot.
  #Subplots have to be 25% as long as the reduced plot.
  coordssubplot1_1 <- rbind(coords1_reduced[1:2,],(coords1_reduced[2:1,]+rbind(go,go)),coords1_reduced[1,])
  coordssubplot1_1.dt <- data.table::as.data.table(coordssubplot1_1)
  
  coordssubplot1_2 <- rbind(coordssubplot1_1[4:3,],(coordssubplot1_1[3:4,]+rbind(go,go)),coordssubplot1_1[4,])
  coordssubplot1_2.dt <- data.table::as.data.table(coordssubplot1_2)
  
  coordssubplot1_3 <- rbind(coordssubplot1_2[4:3,],(coordssubplot1_2[3:4,]+rbind(go,go)),coordssubplot1_2[4,])
  coordssubplot1_3.dt <- data.table::as.data.table(coordssubplot1_3)
  
  coordssubplot1_4 <- rbind(coordssubplot1_3[4:3,],(coordssubplot1_3[3:4,]+rbind(go,go)),coordssubplot1_3[4,])
  coordssubplot1_4.dt <- data.table::as.data.table(coordssubplot1_4)
  
  # Create polygons #
  poly1_1<-Polygon(coordssubplot1_1)
  poly1_2<-Polygon(coordssubplot1_2)
  poly1_3<-Polygon(coordssubplot1_3)
  poly1_4<-Polygon(coordssubplot1_4)
  
  # Put polygons in a list #
  list1<-Polygons(list(poly1_1,poly1_2,poly1_3,poly1_4),"1")
  plot1<-SpatialPolygons(list(list1))
  polyproj <- CRS(paste0('+proj=utm +zone=',utmzone,' ellps=WGS84'))
  proj4string(plot1) <- polyproj
  plots <- rbind(plots,plot1,makeUniqueIDs=TRUE)
}
plot(plots)

# Transform into WGS84 #
subplots <- spTransform(plots, CRS("+proj=longlat +datum=WGS84"))
plot(subplots)

#save the new shapefile
x<-c(farm,field,"subplots","2017.shp")
file<-paste(x, collapse="_")
shapefile(subplots, file,overwrite=TRUE)

