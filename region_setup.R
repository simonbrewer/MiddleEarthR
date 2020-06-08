## Make up elevation file and overlay for a region

library(rayshader)
library(raster)

arda = raster("data/raster/10K.jpg")
plot(arda)

## Regional extent (Mordor)
mext = extent(c(1120000, 1600000, 400000, 750000))

## Get overlay
overlay_stk <- stack("data/raster/overlay_72.png")

## resample
overlay_stk <- resample(overlay_stk, arda, method = "ngb")
## Crop overlay
overlay_stk = crop(overlay_stk, mext)
## Convert to array
overlay_arr <- as.array(overlay_stk/255)
## Set NAs in alpha channel to 0
overlay_arr[,,4][which(is.na(overlay_arr[,,4]))] <- 0

## Crop elevation
elevation = crop(arda, overlay_stk)
elev_mat <- raster_to_matrix(elevation)

save(elev_mat, overlay_arr, file = "region.RData")
