

# CLEAR OLD GRAPHICS
if ( length(dev.list()) > 0 ) { dev.off(dev.list()["RStudioGD"]) }


#----------------------------------------------------------------------
# The WQB dates are daily values.  What if I want to go to months?   
#----------------------------------------------------------------------

#  THERE ARE MULTIPLE WAYS TO DO THIS ...  Marcus' programs included

# Remember "x"?     strftime(x,"%Y/%m") ... you can use that or the full code below


# What does strftime do?
?strftime

# Create a series of monthly dates (stripping the day)

# View it (don't save it)
strftime( as.Date(WQB$DATE,"%m/%d/%Y"),"%Y/%m")

# Save it to variable "monthlyX"

monthlyX <- strftime( as.Date(WQB$DATE,"%m/%d/%Y"),"%Y/%m/15")

# What does aggregate do?
?aggregate

# Subset the original data into monthlyX units.  
#  IMPORTANT "FUN = mean" tells it average all of the daily values (into a single monthly mean)
#  If this were rain fall, we may want to us "FUN = sum" to create a total monthly sum of rain
#  Otherwise, we would get the daily average rain fall

aggregate(WQB$AirTemp ~ monthlyX, FUN = mean)

# This creates a new table of month-by-year date *STRINGS" and monthly mean AirTemps

monAIR <- aggregate(WQB$AirTemp ~ monthlyX, FUN = mean)

str(monAIR)
# The date column is not dates.  We need to as.Date it to plot with it
# Worse ... the "DATES" column is now called "monthlyX" ... and is %Y/%m vs old %m/%d/%Y

as.Date(monAIR$monthlyX,"%Y/%m/%d")

str(as.Date(monAIR$monthlyX,"%Y/%m/%d"))
str(monAIR$`WQB$AirTemp`)
x1 <- as.Date(monAIR$monthlyX,"%Y/%m/%d")
y1 <- monAIR$`WQB$AirTemp`


plot.new()
 plot(x1,y1,col="red")
 lines(x1,y1,col="blue")

 
 

 
 
 