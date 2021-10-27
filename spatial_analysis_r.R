# Spatial analytics and GIS 
# CHAP 2 : Data and plot


# CHAP 3: Basic handling of spatial data in R
# sp, sf , tmap package 
# 3.1.1 Spatial data
#install several packages
library(pacman)

pacman:: p_load(raster,
              OpenStreetMap, 
              RgoogleMaps, 
              grid, 
              rgdal,
              tidyverse,
              reshape2,
              maptools,
              OpenStreetMap,
              ggmosaic, 
              GISTools,
              sf,
              tmap)

#3.2 Intro to sp and sf from "GisTools" package 
#sp data format  
# FORMAT 
# -------------------------------------
#SpatialPoints | SpatialPointsDataFrame
#SpatiaLines | SpatiaLinesDataFrame
#SpatialPolygons | SpatialPolygonsDataFrame 
#--------------------------------------
# --> New Haven and Georgia data 

#load Data Haven
data(newhaven) 

#List current fles
ls()

#check class
class(breach) #--> SpatialPoints
class(blocks) #--> SpatialPolygonsDataFrame

#acess head data from blocks
head(data.frame(blocks)) 
head(blocks@data)

# plot the data  
plot(blocks) 

#plot several layers:
# -  set parameters to display the plot, mar defines the white space c(below, left,abive, right)
par(mar=c(0,0,0,0))

#plot roads in red and add blocks
plot(roads, col="red")
plot(blocks, add = T) 

#sf data format "simple features" : seek to encode to conform formal standard (ISO 19125-1:2004)
# Point , Linestring, Polygon, Multipoint, Multilinestring, Multipolygon
# see vignette help 
vignette(package = "sf")
vignette("sf1" ,package = "sf") 

#sp object can be convert to sf
#load data 
data(georgia)

#convert sp to sf 
georgia_sf = st_as_sf(georgia) 

#check class & head
class(georgia_sf)
head(data.frame(georgia))
head(data.frame(georgia_sf)) #st dataframe have geometry attribute in addition

#convert st to sp 
g2 <- as(georgia_sf, "Spatial") 
class(g2)  


# 3.3 Reading and writing spatial data
# Often shape file --> use package rgdal and sf 
# 3.3.1 Reading to and writing from sp format : readOGR() , writeOGR() from rdgal 
# write a shape file from sp, create a shapefile and associated files in the current working directory.
# "." determines where the shp file is created 
writeOGR(obj=georgia, dsn=".", layer="georgia", 
         driver="ESRI Shapefile", overwrite_layer=T) 

#read shape file from wd
new_georgia <- readOGR("georgia.shp") 

# check class
class(new_georgia)


#read and write raster layers : readGDAL() , writeGDAL()
#3.3.2 Reading to and writing from sf format : st_read(), st_write()
g2 <- st_read("georgia.shp")

# writing from sf format
st_write(g2, "georgia.shp", delete_layer = T)

#3.4 Mapping: an introduction to tmap
# clear environement 
rm(list=ls()) 

# load data 
data(georgia)


# 3.4.2 A quick tmap: qtm()
# convert data 
georgia_sf <- st_as_sf(georgia)

# plot quickly
qtm(georgia, fill = "red", style = "bw")
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

data.frame(georgia_sf)[,13]
# tm-tex() is used to add text on plot
tm_shape(georgia_sf)+
  tm_fill("white")+
  tm_borders()+
  tm_text("Name", size =0.3)+
  tm_layout(frame = F)

#subset the data , subset can be used to plot data on specific areas
# index of counties taht we want to extract
index <- c(81, 82, 83, 150, 62, 53, 21, 16, 124, 121, 17) 

#extract data from matchs
georgia_sf_sub <-  georgia_sf[index,] 

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

#Using OpenStreetMap
#plot you data over the tiles fropm OpenStreetMap
#here, easier to work with sp object
#define uper left, lower right corners

#get the subset with index of interest defined in the vector index
georgia.sub <- georgia[index, ] 

# get upper left
ul <-  as.vector(cbind(bbox(georgia.sub)[2,2], bbox(georgia.sub)[1,1]))

# get lower right
lr <- as.vector(cbind(bbox(georgia.sub)[2,1], bbox(georgia.sub)[1,2]))

#download the map tile 
myMap <-  openmap(ul,lr)

#plot the layer a,d the backdrop 
par(mar=c(0,0,0,0))

plot(myMap, removeMargin = F)

#spTransform from package rgdal
plot(spTransform(georgia.sub, osm()), add = T , lwd = 2) 


# ----> output map using OpenStreetMap


#Using Googlemap 

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
# set to interactive view
tmap_mode('view')

# plot
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
#clear the environment 
rm(list=ls())

# load data 
data(newhaven)

# convert sp to sf
blocks_sf <-  st_as_sf(blocks)
breach_sf <-  st_as_sf(breach)
tracts_sf <- st_as_sf(tracts) 

# get summaries and classes 
summary(blocks_sf)
class(blocks_sf)
summary(breach_sf)
class(breach_sf) # it has only geometry attributes, no thematic attributes ie locations only 
summary(tracts_sf)
class(tracts_sf) # have a look at the attribute and classes

# convert to df
data.frame(blocks_sf)

#access attributes 
head(data.frame(blocks_sf))

# acces the names of the columns
colnames(blocks_sf)

#or
names(blocks_sf)

# the attribute _VACCANT describes the % of hh that are unoccupied 
#access the variable 
data.frame(blocks_sf$P_VACANT) 

# access directly from the sp object
blocks$P_VACANT

#attach the data so attribute can be accessed only by their name 
attach(data.frame(blocks_sf)) 

# plot hist

hist(P_VACANT)

# detach the data once used 
detach(data.frame(blocks_sf)) 

#the breach data can be used to create a heat map raster dataset
breach.dens = st_as_sf(kde.points(breach, lims = tracts))
summary(breach.dens)
breach.dens
plot(breach.dens)
# we can assign new attributes to the spatial objects  for sf and sp
. 
# create a normally distributed rndom value for each 129 areas in blocks_sf
blocks_sf$Randvar <- rnorm(nrow(blocks_sf))


# 3.5.3: Mapping polygons ans attributes 
#choropleth is thematic map where areas are shaded in proportion to their attributes. 
#use of he tmap package 

# set the plot mode
tmap_mode('plot')

# plot,  also possible with sp format 
tm_shape(blocks_sf) + 
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

# set up the layout and plot several figures
grid.newpage() 
pushViewport(viewport(layout = grid.layout(1,3)))
print(p1, vp = viewport(layout.pos.col = 1, height = 5))
print(p2, vp = viewport(layout.pos.col = 2, height = 5))
print(p3, vp = viewport(layout.pos.col = 3, height = 5))

# add a hostogram on the map for the distribution of th variable 
tm_shape(blocks_sf) +
  tm_polygons("P_OWNEROCC", title = "Owner Occ", palette = "-GnBu", 
              breaks = c(0, round(quantileCuts(blocks$P_OWNEROCC, 6), 1)), 
              legend.hist = T) +
  tm_scale_bar(width = 0.22) +
  tm_compass(position = c(0.8, 0.07)) +
  tm_layout(frame = F , title = "New Haven",
            title.size = 2, title.position = c(0.55, "top"),
            legend.hist.size= 0.5)

# possible to compute a derived attribute value on the fly in tmap              
# add a projection to tracts data and convert tracts data to sf
proj4string(tracts) <- proj4string(blocks)
tracts_sf <- st_as_sf(tracts)
tracts_sf <- st_transform(tracts_sf, "+proj=longlat +ellps=WGS84")
# plot
tm_shape(blocks_sf) +
  tm_fill(col="POP1990", convert2density=TRUE,
          style="kmeans", title=expression("Population (per " ∗ km^2 ∗ ")"), 
          legend.hist=F, id="name") +
  tm_borders("grey25", alpha=.5) +
  # add tracts context
  tm_shape(tracts_sf) +
  tm_borders("grey40", lwd=2) +
  tm_format( "NLD", bg.color="white", frame = FALSE, 
                legend.hist.bg.color="grey90")

#compute population density manually
#add area in km^2 to blocks 
blocks_sf$area = st_area(blocks_sf) / (1000*1000)
?st_area()
summary(blocks_sf$POP1990/blocks_sf$area)

# Map multiple attributes using tmap 
tm_shape(blocks_sf) +
  tm_fill(c("P_OWNEROCC", "P_BLACK"))+
  tm_borders()+
  tm_layout(legend.format = list(digits=0),
            legend.position = c("left", "bottom"),
            legend.text.size = 0.5, 
            legend.title.size = 0.8) # two maps 

# 3.5.4: Mapping Points and attributes
data(newhaven)

#convert to sf 
blocks_sf <- st_as_sf(blocks)
breach_sf <- st_as_sf(breach)

# plot
tm_shape(blocks_sf) + #plot the blocks lines
  tm_polygons("white")+ 
  tm_shape(breach_sf)+ 
  tm_dots(size = 0.5, shape=19, col="red", alpha = 0.5)

#load data on earthquake events 
data(quakes)

#look at the 6 first records
head(quakes)

#takes the quaes data and construct a sf , easy way is to convert df>sp>sf
#define the coordinates 
coords.tmp <- cbind(quakes$long, quakes$lat)

#create the SpatialPointDataFrame
quakes.sp <- SpatialPointsDataFrame( coords.tmp, 
                                     data = data.frame(quakes),
                                     proj4string = CRS ("+proj=longlat"))

#convert to sf 
quakes_sf <-  st_as_sf(quakes.sp)

#plot Fiji earthquake data 
tm_shape(quakes_sf) +
  tm_dots(size = 0.5, alpha =0.3)

# how to plot the depth 
#load librairy 
library(grid)

#by size
p1 <-  tm_shape(quakes_sf)+
  tm_bubbles("depth", scale = 1 , shape = 19, alpha = 0.3, title.size = "Quake Depth")

#by colour 
p2 <-  tm_shape(quakes_sf)+
  tm_dots("depth", shape = 19, alpha = 0.5, size = 0.6, 
          palette = "PuBuGn", 
          title = "Quake Depths")

#multiple plots 
grid.newpage()
             
#set up the layout 
pushViewport(viewport(layout= grid.layout(1,2)))

#plot using print()
print(p1, vp=viewport(layout.pos.col = 1, height = 5))
print(p2, vp=viewport(layout.pos.col = 2, height = 5))


#Possible to plot a subset 
# plot only earhquakes with a high magnitude 
# create the index 
index <- quakes_sf$mag > 5.5
typeof(index)
summary(index) 

#select he subset assign to tmp 
tmp <- quakes_sf[index, ]

#plot the subset 
tm_shape(tmp) +
  tm_dots(col= brewer.pal(5, "Reds")[4], shape=19, 
          alpha = 0.5, size = 1) +
  tm_layout(title="Quakes >5.5", 
            title.position = c("centre", "top"))

# get a sub sample 
sub_quakes <- quakes[(quakes$mag > 5 & quakes$mag < 6), ]

# plot with google maps contex using the RgoogleMaps package
library(RgoogleMaps)

#defne lat and lon 
Lat <- as.vector(quakes$lat)
Long <- as.vector(quakes$long)

#get the map tiles
#need to be online

MyMap <- MapBackground(lat=Lat, lon=Long, zoom = 10, 
                       maptype = "satellite")
PlotOnStaticMap(MyMap,Lat,Long,cex=tmp,pch=1, 
                col='#FB6A4A50')


#Mapping lines an attributes
rm(list=ls())
data(newhaven)

#assign a coordinate system to roads 
proj4string(roads) <- proj4string(blocks)

# 1. create a clip area 
xmin <- bbox(roads)[1,1]
ymin <- bbox(roads)[2,1]
xmax <- xmin + diff(bbox(roads)[1,]) / 2
ymax <- ymin + diff(bbox(roads)[2,]) / 2
xx = as.vector(c(xmin, xmin, xmax, xmax, xmin))
yy = as.vector(c(ymin, ymax, ymax, ymin, ymin))
# 2. create a spatial polygon from this
crds <- cbind(xx,yy)
Pl <- Polygon(crds)
ID <- "clip"
Pls <- Polygons(list(Pl), ID=ID)
SPls <- SpatialPolygons(list(Pls))
df <- data.frame(value=1, row.names=ID)
clip.bb <- SpatialPolygonsDataFrame(SPls, df)
proj4string(clip.bb) <- proj4string(blocks)
# 3. convert to sf
# convert the data to sf
clip_sf <- st_as_sf(clip.bb)
roads_sf <- st_as_sf(roads)
# 4. clip out the roads and the data frame
roads_tmp <- st_intersection(st_cast(clip_sf), roads_sf) # get the intersection
st_intersection(st_geometry(st_cast(clip_sf)), st_geometry(roads_sf))

# plot of different road type by color 
tm_shape(clip_sf)+
  + tm_polygons(col="grey", border.col="white")
tm_shape(roads_tmp)+
tm_lines( col="AV_LEGEND", lwd=2, scale=2, legend.lwd.show = FALSE ,palette = "Blues")+ 
tm_layout(legend.title.size= 1)

# 3.5.6 Mapping Raster Attributes 
#How raster attributes can be mapped in sf 
#load the meuse.grid data
rm(list=ls())
pacman::p_load(raster)
data(meuse.grid)
class(meuse.grid) # df
summary(meuse.grid)
plot(meuse.grid$x, meuse.grid$y, asp = 1)

#can be converted to a SpatialPixelsDataFrame and than to a raster

#convert to SpatialPixelsDataFrame
meuse.sp = SpatialPixelsDataFrame(points =
                                    meuse.grid[c("x", "y")], data = meuse.grid, 
                                  proj4string = CRS("+init=epsg:28992"))


#convert to raster 
meuse.r <- as(meuse.sp, "RasterStack")

plot(meuse.r)
plot(meuse.sp[,5])
spplot(meuse.sp[, 3:4])
image(meuse.sp[, "dist"], col = rainbow(7))
spplot(meuse.sp, c("part.a", "part.b", "soil", "ffreq"),
       col.regions=topo.colors(20))


# possible to control more attributes
# set the tmap mode to plot 
tmap_mode('plot')
# map dist and freq attributes
tm_shape(meuse.r) +
  tm_raster(col = c("dist", "ffreq"), title = c("Distance","Flood Freq"), 
            palette = "Reds", style = c("kmeans", "cat"))


# set the tmap mode to view
tmap_mode('view')
# map the dist attribute
tm_shape(meuse.r) +
  tm_raster(col = "dist", title = "Distance", breaks = c(seq(0,1,0.2))) +
  tm_layout(legend.format = list(digits = 1))


tm_shape(meuse.r) +
  tm_raster(col="soil", title="Soil", 
            palette="Spectral", style="cat") +
  tm_scale_bar(width = 0.3) +
  tm_compass(position = c(0.74, 0.05)) +
  tm_layout(frame = F, title = "Meuse flood plain", 
            title.size = 2, title.position = c("0.2", "top"), 
            legend.hist.size = 0.5)

# Simple descriptive statistical analysis.
#  How to develop a basic statistical analysis of attributes
pacman::p_load(tidyverse, reshape2)

#  3.6.1 Histograms and Boxplots
#  "table()": count of categorical variables/discrete data 
#  "summary()", "fivenum()" : summaries for continuous variables
data(newhaven)
summary(blocks$P_VACANT)
fivenum(blocks$P_VACANT)
#  standard approache with hist 
hist(blocks$P_VACANT, breaks = 40, col = "cyan", 
     border = "salmon",
     main = "The distribution of vacant property percentages",
     xlab = "percentage vacant", xlim = c(0,40))
# ggplot approach 
ggplot(blocks@data , aes(P_VACANT)) +
  geom_histogram(col = "salmon", fill = "cyan", bins = 40)+
  xlab("percentage vacant")+
  labs(title = "The distributon of vacant property percentages")

#  Boxes on high / low vacancy areas (where proportion of vacant properties is > 10%)
# using ggplot : geom_boxplot

melt(blocks@data)

#a logical test
index <- blocks$P_VACANT > 10

#assign 2 : high , 1: low
blocks$vac <- index+1

#label it / convert the variable into factor 
blocks$vac <- factor(blocks$vac, labels = c("Low", "High"))
blocks@data

# apply the geom_boxplot function 
ggplot(melt(blocks@data[, c("P_OWNEROCC", "P_WHITE", "P_BLACK", "vac")]),
        aes(variable, value)) +
  geom_boxplot() +
  facet_wrap(~vac) # define the value to separe into groups


# add features
ggplot(melt(blocks@data[, c("P_OWNEROCC", "P_WHITE", "P_BLACK", "vac")]),
       aes(variable, value)) +
  geom_boxplot(colour = "yellow", fill = "wheat", alpha = 0.7) +
  facet_wrap(~vac) +
  xlab("") +
  ylab("Percentage") +
  theme_dark() +
  ggtitle("Boxplot of High and Low property vacancies")

# 3.6.2 Scatter Plots and Regressions
# visualize trends 
plot(blocks$P_VACANT/100, blocks$P_WHITE/100) #scatter plot 
plot(blocks$P_VACANT/100, blocks$P_BLACK/100)

# assign some variable 
p.vac <- blocks$P_VACANT/100
p.w <- blocks$P_WHITE/100
p.b <-  blocks$P_BLACK/100

#bind together 
df <- data.frame(p.vac, p.w, p.b) 

#fit regression 
mod.1 <-  lm(p.vac ~ p.w , data = df)
mod.2 <- lm(p.vac ~p.b, data =df) 

# access result of the regression 
summary(mod.1)


