## Make basic 2D hillshading image
## Code modified from rayshader tutorial

library(rayshader)
library(raster)

arda = raster("data/raster/10K.jpg")
plot(arda)

mordor = crop(arda, extent(c(1120000, 1600000, 400000, 750000)))
# arda2 = arda2 * 10
plot(mordor)

#And convert it to a matrix:
mordor_mat = raster_to_matrix(mordor)

#We use another one of rayshader's built-in textures:
mordor_mat %>%
  sphere_shade(texture = "desert") %>%
  plot_map()

#sphere_shade can shift the sun direction:
mordor_mat %>%
  sphere_shade(sunangle = 45, texture = "desert") %>%
  plot_map()

#detect_water and add_water adds a water layer to the map:
mordor_mat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(mordor_mat, max_height = 17), color = "desert") %>%
  plot_map()

#And we can add a raytraced layer from that sun direction as well:
mordor_mat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(mordor_mat, max_height = 17), color = "desert") %>%
  add_shadow(ray_shade(mordor_mat), 0.5) %>%
  plot_map()

