###Get missing elevations from lat lon
library(RCurl)
library(XML)
library(raster)
library(gdata)

get.elev <- function(lon,lat){

###Flagstaff, AZ
###lat <- 35.1992;lon <- -111.6311
###2121 m

url <- paste(
                 "http://www.earthtools.org/height",
                 lat,
                 lon,
                 sep = "/"
             )

page <- getURL(url)
ans <- xmlTreeParse(page, useInternalNodes = TRUE)
heightNode <- xpathApply(ans, "//meters")[[1]]
(height <- as.numeric(xmlValue(heightNode)))
return(height)
}
