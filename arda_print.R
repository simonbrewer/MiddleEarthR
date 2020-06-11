## Make basic 2D hillshading image
## Code modified from rayshader tutorial

library(rayshader)
library(raster)
library(rgdal)

contour = readOGR("./data/vectors/Contours_18.shp")
mincont = min(as.numeric(contour$Elevation), na.rm = TRUE)
maxcont = max(as.numeric(contour$Elevation), na.rm = TRUE)
rngcont = maxcont - mincont

arda = raster("data/raster/10K.jpg")
arda = aggregate(arda, fact = 10)

plot(arda)

minelev = cellStats(arda, min)
maxelev = cellStats(arda, max)

## Stretch elevation
arda = (arda / maxelev) * rngcont
## sea level offset
# arda = arda - ((17 / maxelev) * rngcont)

## Skirt offset
arda = arda + 500

#And convert it to a matrix:
arda_mat = raster_to_matrix(arda)

rgl::clear3d()
arda_mat %>%
  sphere_shade() %>%
  plot_3d(arda_mat,zscale=250)

render_camera(fov = 40, zoom = 0.25, theta = 35, phi = 30)

# save_3dprint("montereybay_3d.stl", maxwidth = 150, unit = "mm")