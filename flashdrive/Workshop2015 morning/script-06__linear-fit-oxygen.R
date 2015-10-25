

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

WQB.mDATE <- strftime( as.Date(WQB$DATE,"%m/%d/%Y"),"%Y/%m/15")
WQB.mOxy <- aggregate(WQB$Oxygen ~ WQB.mDATE, FUN = mean)

plot(as.Date(WQB.mOxy[[1]],"%Y/%m/%d"),WQB.mOxy[[2]],col="orange",main="WQB")
lines(as.Date(WQB.mOxy[[1]],"%Y/%m/%d"),WQB.mOxy[[2]],col="orange")

abline(lm(WQB.mOxy[[2]]~as.Date(WQB.mOxy[[1]],"%Y/%m/%d")))


par(mfg=c(1,2))


ACE.mDATE <- strftime( as.Date(ACE$DATE,"%m/%d/%Y"),"%Y/%m/15")
ACE.mOxy <- aggregate(ACE$Oxygen ~ ACE.mDATE, FUN = mean)
plot(as.Date(ACE.mOxy[[1]],"%Y/%m/%d"),ACE.mOxy[[2]],col="orange",main="ACE")
lines(as.Date(ACE.mOxy[[1]],"%Y/%m/%d"),ACE.mOxy[[2]],col="orange")

# abline adds a line to the current plot (vs. going to a new plot)
abline(lm(ACE.mOxy[[2]]~as.Date(ACE.mOxy[[1]],"%Y/%m/%d")))



par(mfg=c(2,1))

ELK.mDATE <- strftime( as.Date(ELK$DATE,"%m/%d/%Y"),"%Y/%m/15")
ELK.mOxy <- aggregate(ELK$Oxygen ~ ELK.mDATE, FUN = mean)

plot(as.Date(ELK.mOxy[[1]],"%Y/%m/%d"),ELK.mOxy[[2]],col="orange",main="ELK")
lines(as.Date(ELK.mOxy[[1]],"%Y/%m/%d"),ELK.mOxy[[2]],col="orange")

abline(lm(ELK.mOxy[[2]]~as.Date(ELK.mOxy[[1]],"%Y/%m/%d")))


par(mfg=c(2,2))

NOC.mDATE <- strftime( as.Date(NOC$DATE,"%m/%d/%Y"),"%Y/%m/15")
NOC.mOxy <- aggregate(NOC$Oxygen ~ NOC.mDATE, FUN = mean)

plot(as.Date(NOC.mOxy[[1]],"%Y/%m/%d"),NOC.mOxy[[2]],col="orange",main="NOC")
lines(as.Date(NOC.mOxy[[1]],"%Y/%m/%d"),NOC.mOxy[[2]],col="orange")

abline(lm(NOC.mOxy[[2]]~as.Date(NOC.mOxy[[1]],"%Y/%m/%d")))

