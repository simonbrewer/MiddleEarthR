## Make up elevation file and overlay for a region

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

