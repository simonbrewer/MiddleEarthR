library(ggplot2)
library(raster)
library(rayshader)

arda = raster("data/raster/10K.jpg")
arda2 = aggregate(arda, fact = 100)

arda.df = data.frame(coordinates(arda2),
                     z = getValues(arda2))

#create graph
g<- ggplot(arda.df, aes(x = x, y = y, fill = z)) +
  geom_tile(color = "black")  +
  scale_fill_viridis_c(option = "C") + coord_fixed()
g
