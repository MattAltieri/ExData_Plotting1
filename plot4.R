# Data file name
datafile <- "./data/household_power_consumption.txt"

# Download the file if it's not already downloaded.
if (!file.exists("./data")) { dir.create("./data")}
if (!file.exists(datafile)) {
    temp <- tempfile()
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
    unzip(temp, exdir="./data")
    unlink(temp)
    rm(temp)
}

# Read in the file
require(data.table)
require(dplyr)
suppressWarnings(temp_tbl <- fread(datafile, na.strings="?"))

# Set the temp_tbl$Date type to Date
temp_tbl[,Date:=as.Date(Date, format="%d/%m/%Y")]

# Subset for the days we need using dplyr and store to a new data.table
startDate <- as.Date("2007-02-01"); endDate <- as.Date("2007-02-02")
tbl <- filter(temp_tbl, Date >= startDate, Date <= endDate)

# Do some cleanup
rm(temp_tbl); gc()

# Fix formatting from dumb fread na.strings behavior
tbl[,Global_active_power:=as.numeric(Global_active_power)]
tbl[,Global_reactive_power:=as.numeric(Global_reactive_power)]
tbl[,Voltage:=as.numeric(Voltage)]
tbl[,Global_intensity:=as.numeric(Global_intensity)]
tbl[,Sub_metering_1:=as.numeric(Sub_metering_1)]
tbl[,Sub_metering_2:=as.numeric(Sub_metering_2)]
tbl[,Sub_metering_3:=as.numeric(Sub_metering_3)]

# Add a DateTime column
tbl[,DateTime:=as.POSIXct(paste(Date, Time))]

# Plot the following in a 2x2 set of panels
#       - Global Active Power over time (top left)
#       - Voltage over time (top right)
#       - Relative energy submetering 1, 2, 3 over time (bottom left)
#       - Global Reactive Power over time (bottom left)
# Save it to png

png("./plot4.png", width=480, height=480, units="px")

# Set up the panels
par(mfrow=c(2, 2))

# Global Active Power over time (top left)
with(tbl, plot(DateTime, Global_active_power, type="l", xlab="",
               ylab="Global Active Power"))

# Voltage over time (top right)
with(tbl, plot(DateTime, Voltage, type="l", xlab="datetime",
               ylab="Voltage"))

# Relative energy submetering 1, 2, 3 over time (bottom left)
with(tbl, plot(DateTime, Sub_metering_1, type="l", xlab="",
               ylab="Energy sub metering"))
with(tbl, lines(DateTime, Sub_metering_2, col="red"))
with(tbl, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty=1,
       bty="n",
       col=c("black", "red", "blue"))

# Global Reactive Power over time (bottom left)
with(tbl, plot(DateTime, Global_reactive_power, type="l", xlab="datetime",
               ylab="Global_reactive_power"))

dev.off()