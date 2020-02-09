# People who are using USB keys SHOULD NOT run this script. This has all been done 
# on the USB keys already, to save time during the workshop.
#
# ONLY eople who are installing in advance to put this on their own computer 
# should run this script. It will likely take several hours, and that would take
# too much time from the workshop. However, the advantage is that it will run 
# more quickly on your own computer if you choose to preinstall it.
# 
# (If you're not sure if the process is complete, Look for the red Stop button 
# and a > symbol to tell if you're done. If the console prompt says | , an 
# installation is still in process.)

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
