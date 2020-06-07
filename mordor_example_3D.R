## Make 3D hillshading image

library(rayshader)
library(raster)

arda = raster("data/raster/10K.jpg")
plot(arda)

mordor = crop(arda, extent(c(1120000, 1600000, 400000, 750000)))
# arda2 = arda2 * 10
plot(mordor)

#And convert it to a matrix:
mordor_mat = raster_to_matrix(mordor)

## 3D render (note the use of theta and phi to control angle and height)
## This opens an RGL-type window for zooming and panning
mordor_mat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(mordor_mat, max_height = 17), color = "desert") %>%
  add_shadow(ray_shade(mordor_mat, zscale = 3), 0.5) %>%
  add_shadow(ambient_shade(mordor_mat), 0) %>%
  plot_3d(mordor_mat, zscale = 10, fov = 0, theta = 305, zoom = 0.75, phi = 25, windowsize = c(1000, 800))

## Render current view to RStudio plot window
render_snapshot()

## Render current view with added focal depth
## focus - controls point of focus
## length - controls field. Smaller values give a wider field
render_depth(focus = 0.5, focallength = 35, clear = FALSE)



