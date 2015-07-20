library(ggplot2)

url <- 'http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'

if (!file.exists('data/exdata-data-NEI_data.zip')) {
  download.file(url, 'data/exdata-data-NEI_data.zip')
  unzip('data/exdata-data-NEI_data.zip', exdir='./data')
}

pmEmissionsData <- readRDS('data/summarySCC_PM25.rds')
sourceClassificationCode <- readRDS('data/Source_Classification_Code.rds')

sources <- sourceClassificationCode[grepl("Coal", sourceClassificationCode$EI.Sector),]
sources <- sources$SCC
data <- pmEmissionsData[pmEmissionsData$SCC %in% sources,]
data <- aggregate(Emissions ~ year, data=data, sum)

plot <- qplot(year, Emissions, data=data, geom="path", main="Emissions From Coal Combustion-Related Sources in USA", xlab="Year", ylab="Emissions")
ggsave(plot, file="plot4.png", width=7, height=5)
