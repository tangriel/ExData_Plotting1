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
dateTime <- paste(as.Date(powerCons$Date), powerCons$Time)
powerCons$Datetime <- as.POSIXct(datetime)

# save to file, step 1: creating a file
png(file = "plot4.png", height=480, width=480) 

# create plot
par(mfrow = c(2, 2))
with(powerCons, {
      plot(powerCons$Global_active_power ~ powerCons$Datetime, type = "l", ylab = "Global Active Power", xlab = "");
      plot(powerCons$Voltage ~ powerCons$Datetime, type = "l", ylab = "Voltage", xlab = "datetime");
      plot(powerCons$Sub_metering_1 ~ powerCons$Datetime, type = "l", ylab = "Energy sub metering", xlab = "");
      lines(powerCons$Sub_metering_2 ~ powerCons$Datetime, type = "l", col = "red");
      lines(powerCons$Sub_metering_3 ~ powerCons$Datetime, type = "l", col = "blue");
      legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n");
      plot(powerCons$Global_reactive_power ~ powerCons$Datetime, type = "l", ylab = "Global_reactive_power", xlab = "datetime", yaxp = c(0.0, 0.5, 5))
})

# save to file, step 2: closing graphical device
dev.off()