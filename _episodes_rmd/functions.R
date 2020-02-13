### These are functions found in the Data Carpentry for Agriculture Workshop

utm_zone <- function(long){
  utm <- (floor((long + 180)/6) %% 60) + 1
  return(utm)
}

st_transform_utm <- function(sfobject){
  utmzone <- utm_zone(mean(st_bbox(sfobject)[c(1,3)]))
  projutm <- as.numeric(paste0("326", utmzone))
  newobj <- st_transform(sfobject, projutm)
  return(newobj)
}

# `long2UTM()` is a function written to take the argument `long` and output the
# result of the equation. `floor()` returns the largest integer that is not
# greater than the input.  The `st_bbox()` function returns the bounding box of
# the dataset, i.e. the four corners defining a rectangle that would contain all
# of the polygons.  By taking the mean of the first and third items returned by
# `st_bbox()`, we get the longitude of the point directly in the center of the box.
# 
# The code below pastes together the full
# ESPG code for any `utmzone` we calculate with `long2UTM`. `paste0()` pastes
# together the two arguments `"326"` and `utmzone` as string. But when we transform
# `trial` into UTM, we only need the ESPG number. So we convert that to numeric with
# `as.numeric()`, giving us a final ESPG of `r paste0("326", utmzone)`.

cent_long <- function(sfobject){
  mean(st_bbox(sfobject)[c(1,3)])
}

cent_lat <- function(sfobject){
  mean(st_bbox(sfobject)[c(2,4)])
}

as.Date.daymetr <- function(daymetdata){
  date <- as.Date(daymetdata$yday, origin = paste0(daymetdata$year-1, "-12-31"))
  return(date)
}

sumprec_by_monthyear <- function(data){
  data %>% dplyr::group_by(month, year) %>% dplyr::summarise(prec_month = sum(prec))
}

avgprec_by_month <- function(data){
  data %>% dplyr::group_by(month) %>% dplyr::summarise(prec_avg = mean(prec_month)) 
}

# conversions 
c_to_f <- function(varc){
  conv_unit(varc, "C", "F") 
}

mm_to_in <- function(varc){
  conv_unit(varc, "mm", "inch") 
}

cm_to_in <- function(varc){
  conv_unit(varc, "cm", "inch") 
}

ha_to_ac <- function(varc){
  conv_unit(varc, "hectare", "acres") 
}

kg_to_lb <- function(varc){
  conv_unit(varc, "kg", "lb") 
}

map_poly <- function(sfobject, variable, name){
  tm_shape(sfobject) + tm_polygons(variable, title = name) +
    tm_layout(legend.outside = TRUE, frame = FALSE) 
}

map_points <- function(sfobject, variable, name){
  tm_shape(sfobject) + tm_dots(variable, title = name) +
    tm_layout(legend.outside = TRUE, frame = FALSE) 
}

wt_mean <- function(property, weights)
{
  # compute thickness weighted mean, but only when we have enough data
  # in that case return NA
  
  # save indices of data that is there
  property.that.is.na <- which( is.na(property) )
  property.that.is.not.na <- which( !is.na(property) )
  
  if( length(property) - length(property.that.is.na) >= 1)
    prop.aggregated <- sum(weights[property.that.is.not.na] * property[property.that.is.not.na], na.rm=TRUE) / sum(weights[property.that.is.not.na], na.rm=TRUE)
  else
    prop.aggregated <- NA
  
  return(prop.aggregated)
}

profile_total <- function(property, thickness)
{
  # compute profile total
  # in that case return NA
  
  # save indices of data that is there
  property.that.is.na <- which( is.na(property) )
  property.that.is.not.na <- which( !is.na(property) )
  
  if( length(property) - length(property.that.is.na) >= 1)
    prop.aggregated <- sum(thickness[property.that.is.not.na] * property[property.that.is.not.na], na.rm=TRUE)
  else
    prop.aggregated <- NA
  
  return(prop.aggregated)
}

# define a function to perfom hz-thickness weighted aggregtion
component_level_aggregation <- function(i)
{
  # horizon thickness is our weighting vector
  hz_thick <- i$hzdepb.r - i$hzdept.r
  
  # compute wt.mean aggregate values
  clay <- wt_mean(i$claytotal.r, hz_thick) 
  silt <- wt_mean(i$silttotal.r, hz_thick)
  sand <- wt_mean(i$sandtotal.r, hz_thick)
  # compute profile sum values
  water_storage <- profile_total(i$awc.r, hz_thick)
  
  # make a new dataframe out of the aggregate values
  d <- data.frame(cokey=unique(i$cokey), clay=clay, silt=silt, sand=sand, water_storage=water_storage)
  
  return(d)
}

mapunit_level_aggregation <- function(i)
{
  # component percentage is our weighting vector
  comppct <- i$comppct.r 
  
  # wt. mean by component percent
  clay <- wt_mean(i$clay, comppct)
  silt <- wt_mean(i$silt, comppct)
  sand <- wt_mean(i$sand, comppct)
  water_storage <- wt_mean(i$water_storage, comppct)
  
  # make a new dataframe out of the aggregate values
  d <- data.frame(mukey=unique(i$mukey), clay=clay, silt=silt, sand=sand, water_storage=water_storage)
  
  return(d)
}

###############################################
# using these functions on my data
c_s_s_soil <- function(ssurgo){
  
  chorizon<-ssurgo$tabular$chorizon
  
  component<-ssurgo$tabular$component 
  
  # aggregate horizon data to the component level
  chorizon.agg <- ddply(chorizon, .(cokey), .fun=component_level_aggregation, .progress='text')
  
  # join up the aggregate chorizon data to the component table
  comp.merged <- merge(component, chorizon.agg, by='cokey')
  
  # aggregate component data to the map unit level
  component.agg <- ddply(comp.merged, .(mukey), .fun=mapunit_level_aggregation, .progress='text')
  
  # save data to the ssurgo shapefile
  spatial <- as(ssurgo$spatial, "sf")
  spatial <- rename(spatial, c("MUKEY" = "mukey"))
  spatial <- merge.data.frame(spatial, component.agg, by="mukey")
  spatial <- spatial[,-5]
  spatial <- dplyr::distinct(spatial)
  spatial <- spatial[,6:9]
  return(spatial)
}
