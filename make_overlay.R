## Make overlay for rayshader

library(rgdal)
library(raster)

arda = raster("data/raster/10K.jpg")

mordor = crop(arda, extent(c(1120000, 1600000, 400000, 750000)))
# arda2 = arda2 * 10
plot(mordor)

## Shapefiles
forests = readOGR("data/vectors/Forests.shp")
forests = crop(forests, mordor)
rivers = readOGR("data/vectors/Rivers.shp")
rivers = crop(rivers, mordor)

