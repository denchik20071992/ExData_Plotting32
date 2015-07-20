url <- 'http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'

if (!file.exists('data/exdata-data-NEI_data.zip')) {
  download.file(url, 'data/exdata-data-NEI_data.zip')
  unzip('data/exdata-data-NEI_data.zip', exdir='./data')
}

pmEmissionsData <- readRDS('data/summarySCC_PM25.rds')
sourceClassificationCode <- readRDS('data/Source_Classification_Code.rds')

data <- pmEmissionsData[pmEmissionsData$fips == "24510",]
data <- aggregate(Emissions ~ year, data=data, sum)

png("plot2.png",width=480,height=480,units="px",bg="transparent")
barplot(
  data$Emissions,
  names.arg=data$year,
  xlab="Year",
  ylab="PM2.5 Emissions (Tons)",
  main="Total PM2.5 Emissions From all Baltimore City Sources"
)
dev.off()
