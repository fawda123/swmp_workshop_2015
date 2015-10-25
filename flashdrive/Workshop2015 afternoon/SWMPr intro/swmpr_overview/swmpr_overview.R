# swmpr_overview code
# SWMPr workshop, Oct. 25, 2015

# install from CRAN (only do once)
install.packages('SWMPr')

# load for your current session
library(SWMPr)

help.search('retrieve', package = 'SWMPr')
help.search('organize', package = 'SWMPr')
help.search('analyze', package = 'SWMPr')
?import_local

# get data for apacpwq, all years

# location of data
mypath <- 'zip_ex'

# import and assign to 'dat'
dat <- import_local(mypath, 'apacpwq', trace = T) 

dat2 <- import_local(mypath, 'apacpwq2012', trace = T)
dat3 <- import_local(mypath, 'apadbnut', trace = F)

head(dat)
tail(dat)
View(dat)
str(dat)
attributes(dat)

help.search('organize', package = 'SWMPr')

# import data 
mypath <- 'zip_ex'
dat <- import_local(mypath, 'apaebmet') 
View(dat)
dat2 <- qaqc(dat)
View(dat2)

# different options for qaqc
dat2 <- qaqc(dat)
dat3 <- qaqc(dat, qaqc_keep = c('0', '-1'))
dat4 <- qaqc(dat, qaqc_keep = NULL)
dat5 <- qaqc(dat, qaqc_keep = 'CSM')

qaqcchk(dat)

# import apawq
mypath <- 'zip_ex'
dat <- import_local(mypath, 'apadbwq')
dat <- qaqc(dat)

# view help file
?subset.swmpr

# select the DO column
tmp <- subset(dat, select = 'do_mgl')
head(tmp)

# select DO and salinity
tmp <- subset(dat, select = c('do_mgl', 'sal'))
head(tmp)

# select a date range, July 2012
dates <- c('2012-07-01 12:00', '2012-07-31 6:30')
tmp <- subset(dat, subset = dates)
head(tmp) # view first six rows

mypath <- 'zip_ex'
dat <- import_local(mypath, 'apaebmet')
tmp <- qaqc(dat)
tmp <- subset(tmp, select = c('atemp', 'wspd'))
dates <- c('2012-01-01 0:0', '2012-01-31 0:0')
tmp <- subset(tmp, subset = dates)
# get observations after Jan 1, 2013
dates <- '2013-01-01 00:00'
tmp <- subset(dat, subset = dates, operator = '>=')

mypath <- 'zip_ex'
dat_met <- import_local(mypath, 'apaebmet')
dat_met <- qaqc(dat_met)
dat_wq <- import_local(mypath, 'apadbwq')
dat_wq <- qaqc(dat_wq)

# what does this do (hint: use View  or head to see the data)?
tmp1 <- comb(dat_wq, dat_met, timestep = 120)

tmp2 <- setstep(dat_wq, timestep = 60)

wqdat <- import_local('zip_ex', 'apadbwq2012')
wqdat <- qaqc(wqdat)
wqdat <- subset(wqdat, select = 'turb',
  subset = c('2012-08-01 0:0', '2012-08-31 0:0'))
metdat <- import_local('zip_ex', 'apaebmet2012')
metdat <- qaqc(metdat)
metdat <- subset(metdat, select = 'wspd',
 subset = c('2012-08-01 0:0', '2012-08-31 0:0'))
dat <- comb(wqdat, metdat, method = 'intersect', timestep = 60)
plot(turb ~ wspd, data = dat)
