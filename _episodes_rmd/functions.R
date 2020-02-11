### These are functions found in the Data Carpentry for Agriculture Workshop

long2UTM <- function(long){
  utm <- (floor((long + 180)/6) %% 60) + 1
  return(utm)
}

cent_long <- function(sfobject){
  mean(st_bbox(sfobject)[c(1,3)])
}

cent_lat <- function(sfobject){
  mean(st_bbox(sfobject)[c(2,4)])
}

# utmzone <- long2UTM(mean(st_bbox(trial)[c(1,3)]))
# utmzone

as.Date.daymetr <- function(daymetdata){
  date <- as.Date(daymetdata$yday, origin = paste0(daymetdata$year-1, "-12-31"))
  return(date)
}

sumprec.by.monthyear <- function(data){
  data %>% dplyr::group_by(month, year) %>% dplyr::summarise(prec_month = sum(prec))
}

avgprec.by.month <- function(data){
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


# by_month <- by_month_year %>% dplyr::group_by(month) %>% dplyr::summarise(prec_avg = mean(prec_month))
# 
# 
# sumprec.by.monthyear(weather_data)
# 
# group.sum.xy(weather_data, month, year, prec_month, prec)
# 
# by_month_year <- weather_data %>% dplyr::group_by(month, year) %>% dplyr::summarise(prec_month = sum(prec))
# 
