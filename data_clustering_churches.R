# EXEMPLE OF DATA CLUSTERING using shape file of churches 
# https://gastongov.com/maps/gis_data_download/shapefiles.php


#Load the packages and the data 
rm(list=ls()) # clear the environment 
pacman::p_load(geometr, tidyverse, maptools, RgoogleMaps, rgeos, dismo) #load librairies 
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

mdist <- distm(churches)
hc <- hclust(as.dist(mdist), method="complete")
churches$clust <- cutree(hc, k=20)

# plot it 
tm_shape(churches)+
  tm_text("clust", size =0.3)+
  tm_layout(frame = F)


# data visualisation 


# interactive map using Leaflet
library(tmap)
churches_sf <- st_as_sf(churches_sp)
tmap_mode('view')# set to interactive view
tm_shape(churches_sf) + 
  tm_polygons(col = "#C6DBEF80")
#remember to reset the tmap_mod to plot



