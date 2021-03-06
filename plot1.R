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

# Plot a histogram showing frequency of Global Active Power for the two days
# Save it to png
png("./plot1.png", width=480, height=480, units="px")
hist(tbl$Global_active_power, main="Global Active Power",
     xlab="Global Active Power (kilowatts)", col="red")
dev.off()