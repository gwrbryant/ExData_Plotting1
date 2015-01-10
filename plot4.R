# This code is used to produce 4 time series plots of data in the
# Individual household electric power consumption dataset
# found in the UC Irvine's Machine Learning data repository
# The plots are saved as a PNG image, 480 x 480 pixels (the default), 96 dpi
# and a transparent background.
# Note that the reference figures are actually 504x504 pixels, with a 
# resolution of 96 dpi, and transparent background.
# There may potentially be some subtle effects due to differences 
# in size and platform rendering (this code ran under Win 7).

# The data interval is 1 minute, making the dataset very large. For this project
# we are only interested in the period 1-2 February 2007, and so will only read 
# in this subset of the data. We do this by calculating the data point number 
# corresponding to midnight on the 1/2/2007.

# First set the class of the variables we plan to read in. 
# Date and Time are initially read as "charecter", the remainder being "numeric"

    cols=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

# Use read.csv to read in the power data; note that the separator is ';', 
# but we aren't using read.csv2 because it appears to have a problem converting 
# the characters read in to numeric. Neither read.table nor read.csv have this 
# issue, but we need to specify the separator.

# We start by reading in the variable names and the first observation

    names<-read.csv("household_power_consumption.txt",
                     sep=";",header=TRUE,colClasses=cols,na.strings="?",
                     nrows=1)

# We assume that there is a point every minute from the starting time
# Calculate the number of lines to skip
    start<-strptime(paste(names$Date," ",names$Time), "%d/%m/%Y %H:%M:%S")
    end<-strptime(paste("1/2/2007"," ","00:00:00"), "%d/%m/%Y %H:%M:%S")
    
# Assumes time difference is in days
    
    points<-as.integer((end-start)*24*60)

# 1 minute data for 2 days correpsonds to 2880 rows
# Now read in the required data

    power<-read.csv("household_power_consumption.txt",
                    sep=";",colClass=cols,na.strings="?",
                    skip=points,nrows=2880)

# Note that this procedure uses the preceding line as the variable names
# Use the names from the top of the data file instead

    names(power)<-names(names)

# Calculate the date and time (DAT) to be used as the x-axis

    DAT<-strptime(paste(power$Date," ",power$Time), "%d/%m/%Y %H:%M:%S")

# Now open the graphic device (default is 480 x 480 pixels)

    png("plot4.png", bg="transparent", res=96, pointsize=9)

# Setup the 2 x 2 panel to put the 4 plots

    par(mfrow=c(2,2))

# Now generate the 4 plots

    with(power, {
        plot(DAT, Global_active_power, type="l", 
             xlab="",ylab="Global Active Power")

        plot(DAT, Voltage, type="l", xlab="datetime",ylab="Voltage")

        plot(DAT, Sub_metering_1, type="l", 
             xlab="",ylab="Energy sub metering")
        lines(DAT,Sub_metering_2, col="red")
        lines(DAT,Sub_metering_3, col="blue")

# The legend has no border in this case - set bty to "n", and
# scale the legend text by 0.95 to make it closer to the reference figure
    
        legend("topright", lty=1, col = c("black","red","blue"), 
               bty="n",legend = names(power[7:9]),cex=0.95)

        plot(DAT, Global_reactive_power, type="l", 
             xlab="datetime",ylab="Global_reactive_power")
} )

# Now turn off the graphics device

    dev.off()
