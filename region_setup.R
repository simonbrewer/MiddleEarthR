## Make up elevation file and overlay for a region

library(rayshader)
library(raster)

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
