# People who are installing in advance to put this on their own computer 
# should run this script. It will likely take several hours.
#
# People who are using USB keys SHOULD NOT run this script. This has all been done 
# on the USB keys already, to save time during the workshop.

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

# The next step is to run the load-and-test script.
