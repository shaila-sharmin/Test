# Load the data
## Data preparation
### Download the data file
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fname = "Assignment2_data.zip"
download.file(url,fname)
### Unzip the file
unzip(fname)
### Read the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Plot 6
### Compare vehicle emissions between Los Angeles and Baltimore
Baltimore.NEI <- subset(NEI, fips=="24510" & type=="ON-ROAD")
LA.NEI <- subset(NEI, fips=="06037" & type=="ON-ROAD")

# Aggregate emissions
Baltimore.Emissions <- aggregate(Baltimore.NEI$Emissions,
                                 by=list(Baltimore.NEI$year),
                                 FUN=sum)
LA.Emissions <- aggregate(LA.NEI$Emissions,
                          by=list(LA.NEI$year),
                          FUN=sum)

Baltimore.Emissions$city = rep("Baltimore",nrow(Baltimore.Emissions))
LA.Emissions$city = rep("Los Angeles",nrow(LA.Emissions))

names(Baltimore.Emissions)[1] <- "year"
names(LA.Emissions)[1] <- "year"

# Bind the single DF
Emissions = rbind(Baltimore.Emissions, LA.Emissions)

# Make histogram plot for comparison
png("plot6.png", width = 700, height = 400)
ggplot(Emissions,
       aes(as.factor(year), x,
           fill = as.factor(year)))+
        xlab("Year") +
        ylab("PM2.5 emissions") +
        ggtitle("Total vehicle PM 2.5 emission from 1998 to 2008") +
        geom_histogram(stat = "identity") +
        facet_grid(. ~ city) +
        scale_fill_discrete(name = "Year")
dev.off()