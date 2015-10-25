
# CLEAR OLD GRAPHICS  ... from the plot window only if the length of the device list (# of plots) is > 0
# Todd is only doing this to get rid of any old plots.
if ( length(dev.list()) > 0 ) { dev.off(dev.list()["RStudioGD"]) }

WQB <- read.csv("data_WQBCR.csv", header=TRUE)
ACE <- read.csv("data_ACEBB.csv", header=TRUE)
ELK <- read.csv("data_ELKNM.csv", header=TRUE)
NOC <- read.csv("data_NOCRC.csv", header=TRUE)

plot.new()

par(mfrow=c(2,2))

par(mfg=c(1,1))
plot(as.Date(WQB[[1]],"%m/%d/%Y"),WQB[[3]],col="green",main="Waquoit Bay CR")

par(mfg=c(1,2))
plot(as.Date(ACE[[1]],"%m/%d/%Y"),ACE[[3]],col="red",main="Ace Basin BB")


par(mfg=c(2,1))
plot(as.Date(ELK[[1]],"%m/%d/%Y"),ELK[[3]],col="blue",main="Elkorn Slough NM")


par(mfg=c(2,2))
plot(as.Date(NOC[[1]],"%m/%d/%Y"),NOC[[3]],col="black", main="North Carolina RC")

