install.packages("ggplot2")
install.packages("rgdal")
install.packages("dplyr") 
#install.packages("tibble") # need this or no?

# to use
library(ggplot2)
library(rgdal)
library(dplyr)

# test ggplot2
df = data.frame("x"=c(1,2,3), "y"=c(1,2,3))
ggplot(df, aes(x=x, y=y)) + geom_point()
