library(ggplot2)
library(raster)
library(rgdal)
library(rayshader)
library(scales)

contour = readOGR("./data/vectors/Contours_18.shp")
mincont = min(as.numeric(contour$Elevation), na.rm = TRUE)
maxcont = max(as.numeric(contour$Elevation), na.rm = TRUE)
rngcont = maxcont - mincont

arda = raster("data/raster/10K.jpg")
plot(arda)

# minelev = cellStats(arda, min)
# maxelev = cellStats(arda, max)
# 
# ## Stretch elevation
# arda = (arda / maxelev) * rngcont
# ## sea level offset
# arda = arda - ((17 / maxelev) * rngcont)
# 
arda2 = aggregate(arda, fact = 100)

arda.df = data.frame(coordinates(arda2),
                     z = getValues(arda2))

# arda.df$z[arda.df$z < -10] <- -10
arda.df$z[arda.df$z < -10] <- NA

#create graph
g<- ggplot(arda.df, aes(x = x, y = y, fill = z)) +
  geom_tile(color = "black")  +
  scale_fill_viridis_c(option = "D") + coord_fixed()
g

# g<- ggplot(arda.df, aes(x = x, y = y, fill = z)) +
#   geom_tile(color = "black")  +
#   scale_fill_gradientn(colors = terrain.colors(20)) + coord_fixed()
# g
# 
# g<- ggplot(arda.df, aes(x = x, y = y, fill = z)) +
#   geom_tile(color = "black")  +
#   scale_fill_gradient2(  low = muted("blue"),
#                          mid = "white",
#                          high = muted("green")) + coord_fixed()
# g
# 
# g<- ggplot(arda.df, aes(x = x, y = y, fill = z)) +
#   geom_tile(color = "black")  +
#   scale_fill_gradientn(colors = rev(marmap::etopo.colors(10))) + coord_fixed()
# g
# 
# g<- ggplot(arda.df, aes(x = x, y = y, fill = z)) +
#   geom_tile(color = "black") +
#   scale_fill_etopo() + coord_fixed()
# g
# 
rgl::clear3d()
plot_gg(g, width = 5, height = 4, scale = 50, multicore = FALSE, windowsize = c(1200, 960),
        fov = 70, zoom = 0.4, theta = 330, phi = 40)

render_camera(fov = 40, zoom = 0.25, theta = 35, phi = 30)

# rgl::clear3d()

