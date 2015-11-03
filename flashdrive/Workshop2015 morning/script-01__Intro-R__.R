
# Hi!  For best results, create a new project.  This removes any loaded libraries which may cause weird results.
#  For example, "plot" and "as.Date" may be modified depending on what other libraries (packages) you have loaded.


# CLEAR OLD GRAPHICS  ... from the plot window only if the length of the device list (# of plots) is > 0
# Todd is only doing this to get rid of any old plots.
if ( length(dev.list()) > 0 ) { dev.off(dev.list()["RStudioGD"]) }


#  What variables are in the workspace?
ls()

#  CLEAR OLD VARIABALES (clear the Workspace)
#  rm() will remove a single variable  ... I am passing a list of names from the ls() command
#  Todd is doing this to remove any old data.
rm(list = ls())


# Load the Waquoit Bay Childs River sample data ... a CSV file with a header row
WQB <- read.csv("data_WQBCR.csv", header=TRUE)


# NOW what variables are present in the workspace?   Also look in the RStudio "Environment" window
ls()


# What does WQB look like?  Show the first few rows     tail(WQB) will show the last few rows
head(WQB)

# What type class (type) of variable is WQB?
class(WQB)

# what is its structure?
str(WQB)


# How do I look at or access the individual parts?

# What are the column headings for WQB
names(WQB)


# You can access the "Temperature" column two ways.  I am sticking the output into head() to keep in short. (It is 3870 lines!)
# Remember capitalization matters.  The variable is "Temperature" .. not "temperature" or "TEMPERATURE"
# For some commands, you don't need to write the full name.  "Te" will work, but "T" alone will not because of "Turbidity"
head(WQB$Temp)

# This is identical to this below.   (Notice both outputs are a horizontal stream of numbers without formatting.)
head(WQB[[2]])

# If we only use one "[]" we get a different output.   The "[[]]" grabs a vector rather than the data.frame element
head(WQB[2])

#  The second example is returning the example as a data.frame piece.
#  It makes it easier for a human to read, but it is not a true "vector" and will cause an error if you try to use it elsewhere as a vector.
#  This is an example where testing the output before assigning it to a variable will help debug or prevent an error elsewhere

# If you are still confused ... try these commands  ...
class(WQB[2])
class(WQB[[2]])
# The first is a data.frame while the second is a numeric (num) vector
# Anything expecting a numeric vector will not like the data.frame version being passed to it


# Lets look at two different columns within this data.frame.

# First a quick refresher ... look what these calls do
c(1:6)
c(1,2,3,4,5,6)
c(1,6)

# To look at Date (column 1) and AirTemp (6), any of these commans will work.  I am still using "head()" to reduce screen output.


head(  WQB[c("DATE","AirTemp")]  )

head(  WQB[c(1,6)]  )



# Can I plot AirTemp vs DATE?
plot("DATE","AirTemp")

#  Above is identical ... and still does not work
plot(WQB[1],WQB[6])


#  I am looking at the pieces with str().   Those are data.frame parts.  They won't work
str(  WQB[c("DATE","AirTemp")]  )

# What if I pass them as vectors?
plot(WQB[[1]],WQB[[6]])


#  It sort of worked, but the "date" info is being treated as a string.  We can translate those strings into date elements with this

class(WQB$Date)
# Why didn't that work?   Remember, capitals matter!
class(WQB$DATE)

# ??!! What is a factor?    R has loaded the date column as a series of characters (not a number).
# The plot command is basically plotting 3870 categories on the X axis.

# How do I convert the factor data type to real dates?
apropos("date")

?as.Date

# I figure this out from one of the examples.  The capital %Y is for four-digit years.  Small %y is for two-digit years.
as.Date(WQB$DATE,"%m/%d/%Y") 


# What data type (class) is it now?
class ( as.Date(WQB$DATE,"%m/%d/%Y") )


# We can assign this to a variable (below) or use it directly
x <- as.Date(WQB$DATE,"%m/%d/%Y")


# All of these examples below work ... they pass the "date" time with is a numerical year+month+day equivalent.
#  I am changing the colors so you can see that each command worked.

plot(x,WQB[[6]])
plot(as.Date(WQB[[1]],"%m/%d/%Y"),WQB[[6]],col="green")
plot(as.Date(WQB$DATE,"%m/%d/%Y"),WQB$AirTemp,col="red")

# Looking at the help for plot   (like how did I know how to change colors?)
?plot
      
# You can change the x and y labels as well as the color
plot(as.Date(WQB$DATE,"%m/%d/%Y"),WQB$AirTemp,xlab="my x label", ylab="my y label")

# If you like HTML hexidecimal color better than text, that will work too ...          
plot(as.Date(WQB$DATE,"%m/%d/%Y"),WQB$AirTemp,xlab="my x label", ylab="my y label", col="#00ffff")
# Or even RBG percentages *0-1 only.  These are different from the 0-255 that some systems uses.
plot(as.Date(WQB$DATE,"%m/%d/%Y"),WQB$AirTemp,xlab="my x label", ylab="my y label", col=rgb(0.99,0,0.50))



# Unmentioned:  Below creates a subset of only WQB Temperatures of <10 ...

#  coldwater <- subset(WQB,WQB[[2]]<10,c[1,2,3]) 



