## Adding overlay

library(rayshader)
library(raster)

mext = extent(c(1120000, 1600000, 400000, 750000))

load("region.RData")

# calculate rayshader layers
ambmat <- ambient_shade(elev_mat, zscale = 30)
raymat <- ray_shade(elev_mat, zscale = 30, lambert = TRUE)
watermap <- detect_water(elev_mat, max_height = 17)

# plot 2D
elev_mat %>%
  sphere_shade(texture = "imhof4") %>%
  add_water(watermap, color = "imhof4") %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  plot_map()

# 2D plot with map overlay
elev_mat %>%
  sphere_shade(texture = "imhof4") %>%
  # add_water(watermap, color = "imhof4") %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  add_overlay(overlay_arr, alphalayer = 0.5) %>%
  plot_map()

zscale <- 10
rgl::clear3d()
elev_mat %>% 
  sphere_shade(texture = "imhof4") %>% 
  # add_water(watermap, color = "imhof4") %>%
  add_overlay(overlay_arr, alphalayer = 0.25) %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  plot_3d(elev_mat, zscale = zscale, windowsize = c(1200, 1000),
          # water = TRUE, soliddepth = -max(elev_mat)/zscale, wateralpha = 0,
          theta = 25, phi = 30, zoom = 0.65, fov = 60)

## Set camera position
render_camera(fov = 70, zoom = 0.4, theta = 25, phi = 35)

render_snapshot()
