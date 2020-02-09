install.packages("ggplot2")
install.packages("rgdal") # I'm not sure that we ever use rgdal as we use class sf rather than spdf; I will check this
install.packages("dplyr") 
install.packages("sf")
install.packages("gstat")
install.packages("tmap")
install.packages("measurements")
install.packages("daymetr")
install.packages("FedData")
install.packages("lubridate")
install.packages("raster")
install.packages("data.table")
install.packages("broom")

#install.packages("tibble") # need this or no? # I believe this is installed with dplyr so no, but I will check this
# Can confirm it's installed with dplyr - Dena

# to use
library("ggplot2")
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

# test ggplot2
df = data.frame("x"=c(1,2,3), "y"=c(1,2,3))
ggplot(df, aes(x=x, y=y)) + geom_point()
