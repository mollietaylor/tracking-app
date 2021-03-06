#
# Developer : Mollie Taylor (mollie.taylor@gmail.com)
# Date : 2013
# All code ©2013 Mollie Taylor
# All rights reserved
#

source("functions.R")

allTracks <- read.csv("allTracks.csv", 
	header = TRUE)

# rangeConst <- 0.05
# meanLon <- mean(allTracks$Longitude)
# meanLat <- mean(allTracks$Latitude)
# lonHiRange <- quantile(allTracks$Longitude, probs = c(1 - rangeConst))
# lonLoRange <- quantile(allTracks$Longitude, probs = c(rangeConst))
# lonRange <- lonHiRange - lonLoRange
# latHiRange <- quantile(allTracks$Latitude, probs = c(1 - rangeConst))
# latLoRange <- quantile(allTracks$Latitude, probs = c(rangeConst))
# latRange <- latHiRange - latLoRange
# # lonRange <- range(allTracks$Longitude)[2] - range(allTracks$Longitude)[1]
# # latRange <- range(allTracks$Latitude)[2] - range(allTracks$Latitude)[1]

allTracks$Latitude <- ifelse(is.na(allTracks$Seg), NA, allTracks$Latitude)
allTracks$Longitude <- ifelse(is.na(allTracks$Seg), NA, allTracks$Longitude)

library(ggmap)

# let user choose directory to save in:
library(tcltk)
mapDir <- tk_choose.dir(caption = "Choose directory to store maps")

specs <- mapSpecs(allTracks, 0)
# default map:
	mapImageData <- get_map(location = c(lon = specs$meanLon, 
		lat = specs$meanLat),
		zoom = 11,
		# size = c(500, 500),
		maptype = c("toner"), #toner, watercolor
		source = c("stamen"))
	ggmap(mapImageData,
		extent = "device", # takes out axis, etc.
		darken = c(0.6, "white")) + # makes basemap lighter
		geom_path(aes(x = Longitude,
			y = Latitude),
		data = allTracks,
		colour = "black", #F8971F F4640D
		size = 1.2,
		pch = 20) +
		geom_path(aes(x = Longitude,
			y = Latitude),
		data = allTracks,
		colour = "#F8971F", #F8971F F4640D
		size = 0.8,
		pch = 20)
	dev.copy(png, paste(mapDir, "/default.png", sep = ""))
	dev.off()


# mapWidth <- max(lonRange, latRange)

# mapZoom <- floor(13 - log2(10 * mapWidth))

# auto map:
	specs <- mapSpecs(allTracks, 0.05) # percentile
	mapImageData <- get_map(location = c(lon = mean(c(specs$lonLoRange, specs$lonHiRange)), 
		lat = mean(c(specs$latLoRange, specs$latHiRange))), # maybe use 20th/80th percentile or something instead of min/max
		zoom = specs$mapZoom,
		# size = c(500, 500),
		maptype = c("toner"), #toner, watercolor
		source = c("stamen"))
	ggmap(mapImageData,
		extent = "device", # takes out axis, etc.
		darken = c(0.6, "white")) + # makes basemap lighter
		geom_path(aes(x = Longitude,
			y = Latitude),
		data = allTracks,
		colour = "black", #F8971F F4640D
		size = 1.2,
		pch = 20) +
		geom_path(aes(x = Longitude,
			y = Latitude),
		data = allTracks,
		colour = "#F8971F", #F8971F F4640D
		size = 0.8,
		pch = 20)
	dev.copy(png, paste(mapDir, "/auto.png", sep = ""))
	dev.off()

# the past month:
allTracks$Date <- as.Date(allTracks$Date, "%Y/%m/%d")
lastMonth <- allTracks[which(allTracks$Date >= Sys.Date() - 30),]
specs <- mapSpecs(lastMonth, 0)
	mapImageData <- get_map(location = c(lon = mean(c(specs$lonLoRange, specs$lonHiRange)), 
		lat = mean(c(specs$latLoRange, specs$latHiRange))), # maybe use 20th/80th percentile or something instead of min/max
		zoom = specs$mapZoom,
		# size = c(500, 500),
		maptype = c("toner"), #toner, watercolor
		source = c("stamen"))
	ggmap(mapImageData,
		extent = "device", # takes out axis, etc.
		darken = c(0.6, "white")) + # makes basemap lighter
		geom_path(aes(x = Longitude,
			y = Latitude),
		data = lastMonth,
		colour = "black", #F8971F F4640D
		size = 1.2,
		pch = 20) +
		geom_path(aes(x = Longitude,
			y = Latitude),
		data = lastMonth,
		colour = "#F8971F", #F8971F F4640D
		size = 0.8,
		pch = 20)
	dev.copy(png, paste(mapDir, "/last-month.png", sep = ""))
	dev.off()