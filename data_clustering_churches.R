# EXEMPLE OF DATA CLUSTERING using shape file of churches 
# https://gastongov.com/maps/gis_data_download/shapefiles.php


# set working directory 
setwd("C:\Users\Kraemer\Documents\PROGRAM DOCUMENTATION\R\R_tutorials_git\R-tutorials-")

# clear the environement 
rm(list=ls()) 

#load the packages 
pacman::p_load(geometr, tidyverse, maptools, RgoogleMaps, rgeos, dismo, st, tm, sf, geosphere, tmap) #load librairies 

# read the shape file 
churches <- st_read("SHP/Churches.shp") 

# see the class of data 
class(churches) # class is "sf " "dataframe"

# Define the wanted CRS : we want the CRS to be : "+proj=longlat +datum=WGS84 +no_defs"
churches <- st_transform(churches, crs("+proj=longlat +datum=WGS84 +no_defs")) # change the CRS 

# unlist to recover lat and lon keeping the data as sf
churches <- churches %>%
  mutate(lat = unlist(map(churches$geometry,1)),
         long = unlist(map(churches$geometry,2)))

# substract the coordinate to have (lon,lat) 
xy <- churches[,c("long","lat")] 

#convert st to sp 
churches_sp <- as(churches, "Spatial") 

#  get the CRS --> we get the CRS we wanted
getCRS(churches_sp) 

# tranform to df to use the SpatialPointDataFrame command
xy <- as.data.frame(churches)

# just keep the (lon,lat)
xy <- xy[,c("long","lat")]

# convert to a SpatialPointDataFrame object
churches <- SpatialPointsDataFrame(xy,
                                   data = as.data.frame(churches), 
                                   proj4string = CRS(churches_sp@proj4string@projargs))

#check the class 
class(churches)

# create a matrix of distance between points 
mdist <- distm(churches) 

# cluster all points using a hierarchical clustering approach
hc <- hclust(as.dist(mdist), method="complete") 

# define clusters based on a tree "height", set thedesired number of clusters and add them to the SpDataFrame
churches$clust <- cutree(hc, k=5)

# 1:  plot it quickly 
tm_shape(churches)+
  tm_text("clust", size =0.3)+
  tm_layout(frame = F)

# 2: data visualization 
# load libraries 
pacman:: p_load(dismo, rgeos, tmap)

# expand the extent of ploting
churches@bbox[] <- as.matrix(extend(extent(churches), 0.001))

# get the centroid coords for each cluster : create a matrix with lines = nb of clusters
cent <-  matrix(ncol=2, nrow=max(churches$clust)) 
  for (i in 1:max(churches$clust))               
    cent[i,] <- gCentroid(subset(churches, clust == i))@coords # fill data to get centroids 

#compute circles around the centroid coords using a 40 m radius (dismo package)
ci <- circles(cent, d=5000, lonlat = T)

# plot 
plot(ci@polygons, axes = T)
plot(churches, col=rainbow(5)[factor(churches$clust)], add = T)  



