# Spatial analytics and GIS 
# CHAP 2 : Data and plot


# CHAP 3: Basic handling of spatial data in R
# sp, sf , tmap package 


# 3.1.1 Spatial data
#install several packages
install.packages(c("raster", "OpenStreetMap", 
                    "RgoogleMaps", "grid", "rgdal", "tidyverse", "reshape2", "ggmosaic", "GISTools", "sf", "tmap"))
#load several packages
my_package <- c("raster", "OpenStreetMap", 
                "RgoogleMaps", "grid", "rgdal", "tidyverse", "reshape2", "ggmosaic", "GISTools", "sf", "tmap")
lapply(my_package, require, character.only = TRUE)

#3.2 Intro to sp and sf from "GisTools" package 
#sp --> New Haven and Georgia data 
data(newhaven) #load Data Haven
ls()
class(breach) #--> SpatialPoints
class(blocks) #--> SpatialPolygonsDataFrame
head(data.frame(blocks)) #acess data from blocks
head(blocks@data)
plot(blocks) # plot the data  
