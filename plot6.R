library(ggplot2)

url <- 'http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FpmEmissionsData_data.zip'

if (!file.exists('data/exdata-data-pmEmissionsData_data.zip')) {
  download.file(url, 'data/exdata-data-pmEmissionsData_data.zip')
  unzip('data/exdata-data-pmEmissionsData_data.zip', exdir='./data')
}

pmEmissionsData <- readRDS('data/summarySCC_PM25.rds')
sourceClassificationCode <- readRDS('data/Source_Classification_Code.rds')

vehicles <- grepl("vehicle", sourceClassificationCode$sourceClassificationCode.Level.Two, ignore.case=TRUE)
vehiclessourceClassificationCode <- sourceClassificationCode[vehicles,]$sourceClassificationCode
vehiclespmEmissionsData <- pmEmissionsData[pmEmissionsData$sourceClassificationCode %in% vehiclessourceClassificationCode,]

# Subset the vehicles pmEmissionsData data by each city's fip and add city name.
vehiclesBaltimorepmEmissionsData <- vehiclespmEmissionsData[vehiclespmEmissionsData$fips=="24510",]
vehiclesBaltimorepmEmissionsData$city <- "Baltimore City"

vehiclesLApmEmissionsData <- vehiclespmEmissionsData[vehiclespmEmissionsData$fips=="06037",]
vehiclesLApmEmissionsData$city <- "Los Angeles County"

# Combine the two subsets with city name into one data frame
bothpmEmissionsData <- rbind(vehiclesBaltimorepmEmissionsData,vehiclesLApmEmissionsData)

png("plot6.png",width=480,height=480,units="px",bg="transparent")

ggp <- ggplot(bothpmEmissionsData, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

dev.off()