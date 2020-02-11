### These are functions found in the Data Carpentry for Agriculture Workshop

long2UTM <- function(long){
  utm <- (floor((long + 180)/6) %% 60) + 1
  return(utm)
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

# by_month <- by_month_year %>% dplyr::group_by(month) %>% dplyr::summarise(prec_avg = mean(prec_month))
# 
# 
# sumprec.by.monthyear(weather_data)
# 
# group.sum.xy(weather_data, month, year, prec_month, prec)
# 
# by_month_year <- weather_data %>% dplyr::group_by(month, year) %>% dplyr::summarise(prec_month = sum(prec))
# 
