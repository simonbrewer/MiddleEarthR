## Make 3D hillshading image

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

mordor = crop(arda, extent(c(1120000, 1600000, 400000, 750000)))
# arda2 = arda2 * 10
plot(mordor)

#And convert it to a matrix:
mordor_mat = raster_to_matrix(mordor)

# calculate rayshader layers
ambmat <- ambient_shade(mordor_mat, zscale = 30)
raymat <- ray_shade(mordor_mat, zscale = 30, lambert = TRUE)
watermap <- detect_water(mordor_mat, max_height = 0)

## 3D render (note the use of theta and phi to control angle and height)
## This opens an RGL-type window for zooming and panning
rgl::clear3d()
mordor_mat %>% 
  sphere_shade(texture = "imhof4") %>% 
  # add_water(watermap, color = "imhof4") %>%
  # add_overlay(overlay_arr, alphalayer = 0.25) %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  plot_3d(mordor_mat, zscale = 150, windowsize = c(1200, 1000),
          # water = TRUE, soliddepth = -max(elev_mat)/zscale, wateralpha = 0,
          theta = 25, phi = 30, zoom = 0.65, fov = 60)

## Set camera position
render_camera(fov = 20, zoom = 0.15, theta = 235, phi = 10)

# mordor_mat %>%
#   sphere_shade(texture = "desert") %>%
#   add_water(detect_water(mordor_mat, max_height = 17), color = "desert") %>%
#   add_shadow(ray_shade(mordor_mat, zscale = 3), 0.5) %>%
#   add_shadow(ambient_shade(mordor_mat), 0) %>%
#   plot_3d(mordor_mat, zscale = 1, fov = 0, theta = 305, zoom = 0.75, phi = 25, windowsize = c(1000, 800))

## Render current view with added focal depth
## focus - controls point of focus
## length - controls field. Smaller values give a wider field
render_depth(focus = 0.5, focallength = 35, clear = FALSE)

render_depth(focus = 0.37, focallength = 35, clear = FALSE, filename = "mtdoom")


