# EXEMPLE OF DATA CLUSTERING using shape file of churches 
# https://gastongov.com/maps/gis_data_download/shapefiles.php

setwd("C:\Users\Kraemer\Documents\PROGRAM DOCUMENTATION\R\R_tutorials_git\R-tutorials-")
#Load the packages and the data 
rm(list=ls()) # clear the environment 
pacman::p_load(geometr, tidyverse, maptools, RgoogleMaps, rgeos, dismo, st, tm, sf, geosphere, tmap) #load librairies 
churches <- st_read("SHP/Churches.shp") # read the shape file 
class(churches) # class is "sf " "dataframe"


# We want the CRS to be : "+proj=longlat +datum=WGS84 +no_defs"
churches <- st_transform(churches, crs("+proj=longlat +datum=WGS84 +no_defs")) # change the CRS 
churches <- churches %>%
  mutate(lat = unlist(map(churches$geometry,1)),
         long = unlist(map(churches$geometry,2))) # unlist to recover lat and lon keeping the data as sf

xy <- churches[,c("long","lat")] # substract the coordinate to have (lon,lat) 
churches_sp <- as(churches, "Spatial") #convert st to sp 
getCRS(churches_sp) #  get the CRS --> we get the CRS we wanted
xy <- as.data.frame(churches) # tranform to df to use the SpatialPointDataFrame command
xy <- xy[,c("long","lat")] # just keep the (lon,lat)


churches <- SpatialPointsDataFrame(xy,
                                   data = as.data.frame(churches), 
                                   proj4string = CRS(churches_sp@proj4string@projargs))

mdist <- distm(churches) # create a matrix of distance between points 
hc <- hclust(as.dist(mdist), method="complete") 
churches$clust <- cutree(hc, k=5)

# plot it quickly 
tm_shape(churches)+
  tm_text("clust", size =0.3)+
  tm_layout(frame = F)


# data visualisation 
# interactive map using Leaflet
pacman:: p_load(dismo, rgeos, tmap)
churches_sf <- st_as_sf(churches_sp)
tmap_mode('plot')# set to interactive view

# expand the extent of ploting
churches@bbox[] <- as.matrix(extend(extent(churches), 0.001))
# get the centroid coords for each cluster 
cent <-  matrix(ncol=2, nrow=max(churches$clust))#create a matrix with lines = nb of clusters
  for (i in 1:max(churches$clust))               
    cent[i,] <- gCentroid(subset(churches, clust == i))@coords # fill data to get centroids 
#compute circles around the centroid coords using a 40 m radius 
#from the dismo package 
ci <- circles(cent, d=5000, lonlat = T)
# plot 
plot(ci@polygons, axes = T)
plot(churches, col=rainbow(5)[factor(churches$clust)], add = T)  # plot 



