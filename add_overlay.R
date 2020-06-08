## Adding overlay

library(rayshader)
library(raster)

arda = raster("data/raster/10K.jpg")
plot(arda)

mext = extent(c(1120000, 1600000, 400000, 750000))

## Get overlay
overlay_stk <- stack("data/raster/overlay_72.png")
## resample
overlay_stk <- resample(overlay_stk, arda, method = "ngb")
## Crop
overlay_stk = crop(overlay_stk, mext)
## Crop elevation
mordor = crop(arda, overlay_stk)


# arda2 = arda2 * 10
plot(mordor)

## Check extents
compareRaster(overlay_stk, mordor, extent = FALSE, 
              rowcol = TRUE, crs = FALSE, stopiffalse = FALSE)
extent(overlay_stk)

#And convert it to a matrix:
mordor_mat = raster_to_matrix(mordor)

# calculate rayshader layers
ambmat <- ambient_shade(mordor_mat, zscale = 30)
raymat <- ray_shade(mordor_mat, zscale = 30, lambert = TRUE)
watermap <- detect_water(mordor_mat, max_height = 17)

# plot 2D
mordor_mat %>%
  sphere_shade(texture = "imhof4") %>%
  add_water(watermap, color = "imhof4") %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  plot_map()

## Get overlay
overlay_stk <- stack("data/raster/overlay_72.png")
## Crop
overlay_stk = crop(overlay_stk, mext)

## Check extents
compareRaster(overlay_stk, mordor, extent = FALSE, 
              rowcol = TRUE, crs = FALSE, stopiffalse = FALSE)

if (!compareRaster(r_rgb, elevation, extent = FALSE, rowcol = TRUE, crs = FALSE, stopiffalse = FALSE)) {
  r_rgb <- setExtent(r_rgb, extent(elevation))
}
if (!compareRaster(r_rgb, elevation, extent = TRUE, rowcol = TRUE, crs = FALSE, stopiffalse = FALSE)) {
  r_rgb_res <- resample(r_rgb, elevation, method = "ngb")
  r_rgb_array <- as.array(r_rgb_res/255)
} else {
  r_rgb_array <- as.array(r_rgb/255)
}
