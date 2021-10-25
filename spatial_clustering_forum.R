# Clustering spatial data in R?
# https://gis.stackexchange.com/questions/17638/clustering-spatial-data-in-r

pacman::p_load(sp, rgdal, geosphere, tmap)

# example data from the thread
x <- c(-1.482156, -1.482318, -1.482129, -1.482880, -1.485735, -1.485770, -1.485913, -1.484275, -1.485866)
y <- c(54.90083, 54.90078, 54.90077, 54.90011, 54.89936, 54.89935, 54.89935, 54.89879, 54.89902)
# convert to a SpatialPointDataFrame object
xy <-  SpatialPointsDataFrame(matrix(c(x,y), ncol = 2), data.frame(ID=seq(1:length(x))), proj4string = CRS("+proj=longlat +ellps=WGS84 + datum=WGS84"))
#generate a deodesic distance matrix in meters  using distm 
mdist <- distm(xy)
# cluster all points using a hierarchical clustering approach
hc <- hclust(as.dist(mdist), method="complete")
#define the distance threeshold (in this case 40 meters)
d = 40
# define clusters based on a tree "height" cutoff "d" and add them to the SpDataFrame
xy$clust <- cutree(hc, h=d)
head(xy)


# plot it 
tm_shape(xy)+
  tm_text("clust", size =0.7)+
  tm_layout(frame = F)

# Data visualisation 
pacman:: p_load(dismo, rgeos)
# expand the extent of ploting
xy@bbox[] <- as.matrix(extend(extent(xy), 0.001))
# get the centroid coords for each cluster 
cent <-  matrix(ncol=2, nrow=max(xy$clust) #create a matrix with lines = nb of clusters
for (i in 1:max(xy$clust))
  # gCentroid from the rgeos package 
  cent[i,] <- gCentroid(subset(xy, clust == i))@coords
#compute circles around the centroid coords using a 40 m radius 
#from the dismo package 
ci <- circles(cent, d=d, lonlat = T)
# plot 
plot(ci@polygons, axes = T)
plot(xy, col=rainbow(4)[factor(xy$clust)], add = T)  





  
