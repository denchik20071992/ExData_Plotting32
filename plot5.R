library(ggplot2)

url <- 'http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'

if (!file.exists('data/exdata-data-NEI_data.zip')) {
  download.file(url, 'data/exdata-data-NEI_data.zip')
  unzip('data/exdata-data-NEI_data.zip', exdir='./data')
}

pmEmissionsData <- readRDS('data/summarySCC_PM25.rds')
sourceClassificationCode <- readRDS('data/Source_Classification_Code.rds')

sources <- sourceClassificationCode[grepl("On-Road", sourceClassificationCode$EI.Sector),]
sources <- sources$SCC
data <- pmEmissionsData[pmEmissionsData$SCC %in% sources,]
data <- pmEmissionsData[pmEmissionsData$fips == "24510",]
data <- aggregate(Emissions ~ year, data=data, sum)


png("plot5.png",width=480,height=480,units="px",bg="transparent")
ggp <- ggplot(data,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

dev.off()