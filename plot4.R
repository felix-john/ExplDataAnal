## ExpDataAnal - Course Project 1 - Plot 4

## read in data (unzipping raw data in a temp file)
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download.file(fileUrl,temp)
data <- read.csv2(unz(temp, "household_power_consumption.txt"), nrows = 300000)
unlink(temp)

## clean dates
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$DateTime <- paste(as.character(data$Date), as.character(data$Time), sep = " ")
data$DateTime <- strptime(data$DateTime, format = "%Y-%m-%d %H:%M:%S")
data$DateTime <- as.POSIXct(data$DateTime)

# subset to relevant dates
rel.data <- data[(data$Date >= "2007-02-01" & data$Date <= "2007-02-02"),]

# convert to numeric 
for (i in 3:9) {
    rel.data[,i] <- as.numeric(levels(rel.data[,i]))[rel.data[,i]]
}

# create histogram
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))
# plot top left
plot(rel.data$DateTime, rel.data$Global_active_power, type =  "l", 
     ylab = "Global Active Power", xlab = "")

# plot top right
plot(rel.data$DateTime, rel.data$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")

# plot bottom left
plot(rel.data$DateTime, rel.data$Sub_metering_1, type =  "l", 
     ylab = "Energy sub metering", xlab = "")
lines(rel.data$DateTime, rel.data$Sub_metering_2, type =  "l", col = "red")
lines(rel.data$DateTime, rel.data$Sub_metering_3, type =  "l", col = "blue")
legend("topright", col = c("black", "red", "blue"), lty = 1,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")

# plot bottom right
plot(rel.data$DateTime, rel.data$Global_reactive_power, type = "l", 
     ylab = "Global_reactive_power", xlab = "datetime")

dev.off()