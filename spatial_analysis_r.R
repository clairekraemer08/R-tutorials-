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
#sp data format  
# FORMAT 
# -------------------------------------
#SpatialPoints | SpatialPointsDataFrame
#SpatiaLines | SpatiaLinesDataFrame
#SpatialPolygons | SpatialPolygonsDataFrame 
#--------------------------------------
# --> New Haven and Georgia data 
data(newhaven) #load Data Haven
ls()
class(breach) #--> SpatialPoints
class(blocks) #--> SpatialPolygonsDataFrame
head(data.frame(blocks)) #acess data from blocks
head(blocks@data)
plot(blocks) # plot the data  
#plo several layers
par(mar=c(0,0,0,0)) #set parameters to display the plot, mar defines the white space c(below, left,abive, right)
plot(roads, col="red") #plot roads in red
plot(blocks, add = T) # add blocks in black

#sf data format "simple features" : seek to encode to conform formal standard (ISO 19125-1:2004)
# Point , Linestring, Polygon, Multipoint, Multilinestring, Multipolygon
vignette(package = "sf")
vignette("sf1" ,package = "sf") #get detailed help 
#sp object can be convert to sf
data(georgia) #load data 
georgia_sf = st_as_sf(georgia) #convert to sf 
class(georgia_sf)
head(data.frame(georgia))
head(data.frame(georgia_sf)) #st dataframe havegeometry attribut in addition
