
# CLEAR OLD GRAPHICS  ... from the plot window only if the length of the device list (# of plots) is > 0
# Todd is only doing this to get rid of any old plots.
if ( length(dev.list()) > 0 ) { dev.off(dev.list()["RStudioGD"]) }


WQB <- read.csv("data_WQBCR.csv", header=TRUE)
ACE <- read.csv("data_ACEBB.csv", header=TRUE)
ELK <- read.csv("data_ELKNM.csv", header=TRUE)
NOC <- read.csv("data_NOCRC.csv", header=TRUE)

# This script is identical to #05 ... but I am using a function to replace the mostly-duplicated code steps.
#  I first plot oxygen ... request a "press enter" (in case running non-stepped), and then plot temperature

#---- This function take a Sites data.frame and the column # and plots it

plot.NERRSvar <- function(SITE,VAR.num,VAR.color) {
  SITE.mDATE <- strftime( as.Date(SITE$DATE,"%m/%d/%Y"),"%Y/%m/15")
  SITE.mOxy <- aggregate(SITE[[VAR.num]] ~ SITE.mDATE, FUN = mean)
  plot(as.Date(SITE.mOxy[[1]],"%Y/%m/%d"),SITE.mOxy[[2]],col="orange",main="SITE")
  lines(as.Date(SITE.mOxy[[1]],"%Y/%m/%d"),SITE.mOxy[[2]],col="orange")
}

plot.new()

par(mfrow=c(2,2))

par(mfg=c(1,1))
plot.NERRSvar(WQB,3)

par(mfg=c(1,2))
plot.NERRSvar(ELK,3)

par(mfg=c(2,1))
plot.NERRSvar(ACE,3)

par(mfg=c(2,2))
plot.NERRSvar(NOC,3)

readline("Press <return to continue") 


plot.new()

par(mfrow=c(2,2))

par(mfg=c(1,1))
plot.NERRSvar(WQB,2)
par(mfg=c(1,2))
plot.NERRSvar(ELK,2)

par(mfg=c(2,1))
plot.NERRSvar(ACE,2)

par(mfg=c(2,2))
plot.NERRSvar(NOC,2)
