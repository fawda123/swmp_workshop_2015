# swmpr_analyze code
# SWMPr workshop October 25, 2015

# clear workspace and load SWMPr
rm(list = ls())
library(SWMPr)

help.search('analyze', package = 'SWMPr')

mypath <- 'zip_ex'
dat <- import_local(mypath, 'cbmmcwq2012')
tmp <- qaqc(dat)
tmp <- subset(tmp, select = 'do_mgl', subset = c('2012-10-01 0:0', 
  '2012-10-31 0:0'))
plot(tmp)

tmp2 <- na.approx(tmp, params = 'do_mgl', maxgap = 100)
plot(tmp)
plot(tmp2)

mypath <- 'zip_ex'
dat <- import_local(mypath, 'cbmipwq')
tmp <- qaqc(dat)
tmp <- subset(tmp, select = 'do_mgl')
do_smooth <- smoother(tmp, window = 5000)
plot(tmp)
lines(do_smooth, col = 'red')

mypath <- 'zip_ex'
dat <- import_local(mypath, 'cbmipwq')
tmp <- qaqc(dat)
tmp <- subset(tmp, select = 'do_mgl')
tmp <- na.approx(tmp, maxgap = 5000)
do_smooth <- smoother(tmp, window = 5000)
plot(tmp)
lines(do_smooth, col = 'red')

mypath <- 'zip_ex'
dat <- import_local(mypath, 'cbmipwq')
tmp <- qaqc(dat)
tmp <- subset(tmp, select = 'do_mgl')
aggtmp <- aggreswmp(tmp, by = 'quarters')
aggtmp <- aggreswmp(tmp, by = 'years')
aggtmp <- aggreswmp(tmp, by = 'weeks')
fun_in <- function(x)  var(x, na.rm = TRUE)
aggtmp <- aggreswmp(tmp, FUN = fun_in, 'years')

# use aggs_out to get all
aggtmp <- aggreswmp(tmp, by = 'quarters', aggs_out = TRUE)
# use boxplot 
boxplot(do_mgl ~ datetimestamp, data = aggtmp, ylab = 'do_mgl', ylim = c(0, 15))

# try any of these examples
map_reserve('jac')

map_reserve('elk', zoom = 13,
  map_type = 'hybrid')

map_reserve('gtmss', zoom = 15,
  map_type = 'satellite',
  text_col = 'lightblue')

# import
mypath <- 'zip_ex'
dat <- import_local(mypath, 'cbmipwq2011')
# plot
overplot(dat, select = c('do_mgl', 'temp'),
  subset = c('2011-08-01 0:0', '2011-08-31 0:0'))

# import
mypath <- 'zip_ex'
dat <- import_local(mypath, 'cbmipwq')

# plot
plot_summary(dat, 'temp')
