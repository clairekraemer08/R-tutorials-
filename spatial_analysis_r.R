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
georgia_sf = st_as_sf(georgia) #convert sp to sf 
class(georgia_sf)
head(data.frame(georgia))
head(data.frame(georgia_sf)) #st dataframe have geometry attribute in addition
g2 <- as(georgia_sf, "Spatial") #convert st to sp 
class(g2)  


# 3.3 Reading and writing spatial data
# Often shape file --> use package rgdal and sf 
# 3.3.1 Reading to and writing from sp format : readOGR() , writeOGR() from rdgal 
writeOGR(obj=georgia, dsn=".", layer="georgia", 
         driver="ESRI Shapefile", overwrite_layer=T) #write a shape file from sp, create a shapefile and associated files in the current working directory.
# "." determines where the shp file is created 
new_georgia <- readOGR("georgia.shp") #read shape file from wd
class(new_georgia)
#read and write raster layers : readGDAL() , writeGDAL()
#3.3.2 Reading to and writing from sf format : st_read(), st_write()
g2 <- st_read("georgia.shp")
st_write(g2, "georgia.shp", delete_layer = T)

#3.4 Mapping: an introduction to tmap
rm(list=ls()) #clear environemnt 
data(georgia)
# 3.4.2 A quick tmap: qtm()
georgia_sf <- st_as_sf(georgia)
library(tmap)
qtm(georgia, fill = "red", style = "bw")
?qtm
qtm(georgia_sf, fill="MedInc", text="Name", text.size = 0.5, format="World_wide", style = "classic", text.root=5, fill.title="Median Income") #Map + detailed 

#3.4.3 Full map 
#tm_shape(), st_union()  (gUnaryUnion() as an alternative for sp in rgeos package)
g <- st_union(georgia_sf) #an outline is created 
#1st map : add color 
tm_shape(georgia_sf) +
  tm_fill("tomato")+  #map just flled in tomato 
#2nd map : add border 
  tm_borders(lty= "dashed" , col = "gold")+
#3rd map : add bg color  
  tm_style("natural", bg.color = "grey90")+
#4th map : add outline  
  tm_shape(g)+
  tm_borders(lwd =2)+
#5th map : add title   
  tm_layout(title = "The State of Georgia",
            title.size = 1,
            title.position = c(0.55, "top"))
#multiple different map from different datasets: 
# assign each map to variable t1 and t2
library(grid)
#1st plot of georgia
t1 <- tm_shape(georgia_sf)+
  tm_fill("coral")+
  tm_borders()+
  tm_layout(bg.color = "grey85")
#◘2nd plot of georgia
t2 <- tm_shape(georgia2)+
  tm_fill("orange")+
  tm_borders()+
  tm_layout(asp = 0.86, bg.color = "grey95")
#specify the layout oof the combined map plot 
grid.newpage()
pushViewport(viewport(layout=grid.layout(1,2)))
print(t1, vp=viewport(layout.pos.col=1 , height = 5))
print(t2, vp=viewport(layout.pos.col=2 , height = 5))
########
data.frame(georgia_sf)[,13]
# tm-tex() is used to add text on plot
tm_shape(georgia_sf)+
  tm_fill("white")+
  tm_borders()+
  tm_text("Name", size =0.3)+
  tm_layout(frame = F)
#subset the data , subset can be used to plot data on specific areas
index <- c(81, 82, 83, 150, 62, 53, 21, 16, 124, 121, 17) # index of counties taht we want to extract
georgia_sf_sub <-  georgia_sf[index,] #extract data from matchs
#plot the subset 
tm_shape(georgia_sf_sub) +
  tm_fill("gold1") +
  tm_borders("grey") +
  tm_text("Name", size = 1) +
  # add the outline
  tm_shape(g) +
  tm_borders(lwd = 2) +
  # specify some layout parameters
  tm_layout(frame = FALSE, title = "A subset of Georgia",
            title.size = 1.5, title.position = c(0., "bottom"))

# 3.4.4: ADDING CONTEXT
# In some case  a map with background context may be more informative 
#Load librairies
library(pacman)
pacman:: p_load(raster, OpenStreetMap, RgoogleMaps, grid, rgdal, tidyverse, reshape2, ggmosaic, GISTools, sf, tmap)
#Using OpenStreetMap
install.packages(c("OpenStreetMap"), depend = T)
library(OpenStreetMap) #plot you data over the tiles fropm OpenStreetMap
#here, easier to work with sp object
#define uper left, lower right corners
georgia.sub <- georgia[index, ] #get the subset with index of interest defined in the vector index
ul <-  as.vector(cbind(bbox(georgia.sub)[2,2], bbox(georgia.sub)[1,1]))
lr <- as.vector(cbind(bbox(georgia.sub)[2,1], bbox(georgia.sub)[1,2]))
#download the map tile 
myMap <-  openmap(ul,lr)
#plot the layer a,d the backdrop 
par(mar=c(0,0,0,0))
plot(myMap, removeMargin = F)
plot(spTransform(georgia.sub, osm()), add = T , lwd = 2) #spTransform from package rgdal
# ----> output map using OpenStreetMap

#Using Googlemap 
install.packages(c("RgoogleMaps"),depend=T)
library(RgoogleMaps)
library(maptools)
#convert the subset
shp <- SpatialPolygons2PolySet(georgia.sub) # Convert SpatialPolygons to PolySet data
#determine the extent of the subset 
bb <- qbbox(lat = shp[,"Y"], lon=shp[,"X"]) #compute the bounding lat lon
#download map data and store it
myMap <- GetMap.bbox(bb$lonR, bb$latR, destfile = "DC.jpg")
#plot the layer and the backdrop
par(mar=c(0,0,0,0))
PlotPolysOnStaticMap(myMap , shp, lwd= 2,
                     col= rgb (0.25,0.25,0.25,0.025), add=F)

#using Leaflet (tmap package) , cool for interactive map 
library(tmap)
tmap_mode('view')# set to interactive view
tm_shape(georgia_sf_sub) + 
  tm_polygons(col = "#C6DBEF80")
#remember to reset the tmap_mod to plot
tmap_mode("plot")

# 3.4.5 SAVING THE MAP 
# plot > export > copy to clipboard/ save as image 
# saving usng R command enable changes : call the draw using source("filename.R)
source("newhavenmap.R")



# 3.5: MAPPING SPAIAL DATA ATTRIBUTES
#3.5.2 Attributes and data frames
library(pacman)
pacman:: p_load(raster, OpenStreetMap, RgoogleMaps, sp, sf, grid, rgdal, tidyverse, reshape2, ggmosaic, GISTools, sf, tmap)
#Using 
rm(list=ls()) #clear the environment 
data(newhaven)
ls() #load and list 
blocks_sf <-  st_as_sf(blocks)
breach_sf <-  st_as_sf(breach)
tracts_sf <- st_as_sf(tracts) # covert sp to sf
summary(blocks_sf)
class(blocks_sf)
summary(breach_sf)
class(breach_sf) # it has only geometry attributes, no thematic attributes ie locations only 
summary(tracts_sf)
class(tracts_sf) # have a look at the attribute and classes
data.frame(blocks_sf)
head(data.frame(blocks_sf)) #access attributes 
colnames(blocks_sf) # acces the names of the columns
#or
names(blocks_sf)
# the attribute _VACCANT describes the % of hh that are unoccupied 
data.frame(blocks_sf$P_VACANT) #access the variable 
blocks$P_VACANT # access directly from the sp object
attach(data.frame(blocks_sf)) #attach the data so attribute can be accessed only by their name 
hist(P_VACANT) # one can directly access the data and plo the hist
detach(data.frame(blocks_sf)) # detach the data once used 
#the breach data can be used to create a heat map rasterdatased
breach.dens = st_as_sf(kde.points(breach, lims = tracts))
summary(breach.dens)
breach.dens
plot(breach.dens)
# we can assign new attributes to the spatial objects  for sf and sp. 
# create a normally distributed rndom value for each 129 areas in blocks_sf
blocks_sf$Randvar <- rnorm(nrow(blocks_sf))


# 3.5.3: Mapping polygons ans attributes 
#choropleth is thematic map where areas are shaded in proportion to their attributes. 
#use of he tmap package 

tmap_mode('plot')
tm_shape(blocks_sf) + # also possible with sp format 
  tm_polygons("P_OWNEROCC") #includes the legend atomatically 

# one can control the class interval
tm_shape(blocks_sf)+
  tm_polygons("P_VACANT", breaks = seq(0,100, by= 25))

#other way 
tm_shape(blocks_sf) +
  tm_polygons("P_OWNEROCC", breaks =  c(10,40,60,90))

#legend placement and title 
tm_shape(blocks_sf)+
  tm_polygons("P_OWNEROCC", title= "Owner Occ") +
  tm_layout(legend.title.size = 1,
            legend.text.size = 1,
            legend.position = c(0.1,0.1))
#colorsare generated using the RColorBrewer package loaded with tmap andGIStools
display.brewer.all()
brewer.pal(5,'Blues') # n = number of scales , display a   list of color ref 

tm_shape(blocks_sf)+
  tm_polygons("P_OWNEROCC", title = "Owner Occ", palette = "Reds")+
  tm_layout(legend.title.size= 1)

# multiple plots - equal interval - k(means) interval - quantiles interval 
# 1: equal intervals
p1 <- tm_shape(blocks_sf)+
  tm_polygons("P_OWNEROCC", title = "Owner occ", palette = "Blues")+
  tm_layout(legend.title.size = 0.7)
# 2 : Mean kernel 
p2 <- tm_shape(blocks_sf)+
  tm_polygons("P_OWNEROCC", title = "Owner occ", palette = "Oranges", style = "kmeans")+
  tm_layout(legend.title.size = 0.7)
#3: quantiles 
p3 <- tm_shape(blocks_sf)+
  tm_polygons("P_OWNEROCC", title = "Owner occ", palette = "Greens", breaks = c(0, round(quantileCuts(blocks_sf$P_OWNEROCC, 6), 1)))+
  tm_layout(legend.title.size = 0.7)
library(grid)
grid.newpage() # set up the layout 
pushViewport(viewport(layout = grid.layout(1,3)))
print(p1, vp = viewport(layout.pos.col = 1, height = 5))
print(p2, vp = viewport(layout.pos.col = 2, height = 5))
print(p3, vp = viewport(layout.pos.col = 3, height = 5))

# add a hostogram on the map for the distribution of th variable 


