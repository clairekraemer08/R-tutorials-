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


