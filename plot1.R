# Checks for data directory and creates one if it doesn't exist
if (!file.exists("data")) {
      message("Making data folder")
      dir.create("data")
}
if (!file.exists("data/Dataset.zip")) {
      # download initial dataset if necessary
      fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      zipFile="data/Dataset.zip"
      message("Downloading data")
      download.file(fileURL, destfile=zipFile)
      unzip(zipFile, exdir="data")
}
      
# get full dataset
powerCons_full <- read.csv("./data/household_power_consumption.txt", header=T, sep=';', na.strings="?")
powerCons_full$Date <- as.Date(powerCons_full$Date, format="%d/%m/%Y")
      
# subset the data
powerCons <- subset(powerCons_full, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
rm(powerCons_full)
      
# convert dates
datetime <- paste(as.Date(powerCons$Date), powerCons$Time)
powerCons$Datetime <- as.POSIXct(datetime)

# save to file, step 1: creating a file
png(file = "plot1.png", height=480, width=480) 

# create plot
hist(powerCons$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")

# save to file, step 2: closing graphical device
dev.off()