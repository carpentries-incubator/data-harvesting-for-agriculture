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
