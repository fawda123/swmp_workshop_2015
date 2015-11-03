
# CLEAR OLD GRAPHICS  ... from the plot window only if the length of the device list (# of plots) is > 0
# Todd is only doing this to get rid of any old plots.
if ( length(dev.list()) > 0 ) { dev.off(dev.list()["RStudioGD"]) }


WQB <- read.csv("data_WQBCR.csv", header=TRUE)
#WQB <- read.csv("data_ACEBB.csv", header=TRUE)
#WQB <- read.csv("data_ELKNM.csv", header=TRUE)
#WQB <- read.csv("data_NOCRC.csv", header=TRUE)


plot.new()

par(mfrow=c(3,2)) # 3 rows x 2 columns

par(mfg=c(1,1))  # row 1 column 1
#  The "main=names(WQB[2]) gives the plot title the header column
plot(as.Date(WQB[[1]],"%m/%d/%Y"),WQB[[2]],col="red",main=names(WQB[2]))

par(mfg=c(2,1))
plot(as.Date(WQB[[1]],"%m/%d/%Y"),WQB[[3]],col="black",main=names(WQB[3]))


par(mfg=c(3,1))
plot(as.Date(WQB[[1]],"%m/%d/%Y"),WQB[[4]],col="orange",main=names(WQB[4]))


par(mfg=c(1,2))
plot(as.Date(WQB[[1]],"%m/%d/%Y"),WQB[[5]],col="green",main=names(WQB[5]))

par(mfg=c(2,2))
plot(as.Date(WQB[[1]],"%m/%d/%Y"),WQB[[6]],col="cyan",main=names(WQB[6]))

par(mfg=c(3,2))
plot(as.Date(WQB[[1]],"%m/%d/%Y"),WQB[[7]],col="pink",main=names(WQB[7]))

