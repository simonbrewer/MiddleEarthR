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
plot(arda)

minelev = cellStats(arda, min)
maxelev = cellStats(arda, max)

## Stretch elevation
arda = (arda / maxelev) * rngcont
## sea level offset
arda = arda - ((17 / maxelev) * rngcont)

#And convert it to a matrix:
arda_mat = raster_to_matrix(arda)

arda_mat %>%
  sphere_shade() %>%
  plot_3d(arda_mat,zscale=50)


# save_3dprint("montereybay_3d.stl", maxwidth = 150, unit = "mm")