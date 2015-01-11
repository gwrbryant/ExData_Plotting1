# This code is used to produce a histogram of data in the 
# Individual household electric power consumption dataset
# found in the UC Irvine's Machine Learning data repository
# The plot is saved as a PNG image, 480 x 480 pixels (the default), 96 dpi
# and a transparent background.
# Note that the reference figure is actually 504x504 pixels, with a 
# resolution of 96 dpi, and transparent background.
# There may potentially be some subtle effects due to differences 
# in size and platform rendering (this code ran under Win 7).
#
# The data set can be found on the Coursera project site and/or downloaded from
# https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip
# The following code assumes the file has already been downloaded and 
# extracted to the working directory prior to running it.
#
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

# Open the PNG graphic device
    
    png("plot1.png", bg="transparent", res=96, pointsize=9)

# Make sure we are only putting one plot on the (default) 480 x 480 pixels    

    par(mfrow=c(1,1))

# Plot the histogram - filled in red with the required titles

    hist(power$Global_active_power,col="red",
         xlab="Global Active Power (kilowatts)",
         main="Global Active Power")

# Now close the graphics device

    dev.off()