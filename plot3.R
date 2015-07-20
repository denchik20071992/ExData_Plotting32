library(ggplot2)

url <- 'http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'

if (!file.exists('data/exdata-data-NEI_data.zip')) {
  download.file(url, 'data/exdata-data-NEI_data.zip')
  unzip('data/exdata-data-NEI_data.zip', exdir='./data')
}

pmEmissionsData <- readRDS('data/summarySCC_PM25.rds')
sourceClassificationCode <- readRDS('data/Source_Classification_Code.rds')

data <- pmEmissionsData[pmEmissionsData$fips == "24510",]
data <- aggregate(Emissions ~ year + type, data=data, sum)

png("plot3.png",width=480,height=480,units="px",bg="transparent")
ggp <- ggplot(data,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))


dev.off()