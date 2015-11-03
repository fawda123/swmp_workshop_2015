

#
# " WG124:  Basic Visualization Toolkit ";
#
#
# " VERY IMPORTANT:  Data must be in the standard WG125 'YYYY_MM_15' format or the match-up will not work. ";
#
# "---------------------------------------------------------------------------------------------------------------------";


#   install.packages("fields")


#                         " Clear all variables ... "
rm(list = ls());


#                         " Load a fully filled 1900-to-2010-by-12-months array of blanks.";
#                         " This is done to fill any missing months or years in the incoming data. ";
#                         " It was renamed .fsv to not show up in menu listing below.";

fillblanks <- read.csv('data-WG125/blank_1900-to-2010.fsv',header=TRUE,as.is=TRUE,dec='.',sep=',',na.string="na");



#                         " Below is a 'repeating menu until User enters a Zero' loop ";
iEXIT <- 0;
#"----------------------- REPEATING MENU LOOP (begin) ------------------------------------------------------------";
while (iEXIT < 1 ) {
  
  
  #                         " Clear 'loadDATA' variable at start of each loop ";  
  loadDATA <- 0;
  remove(loadDATA);
  
  #                         " Look in the directory 'data-WG125load' for any '.csv' files.";
  #                         " Make all eligible files into a menu of name choices. A zero will exit the menu.";
  filenames <- list.files(path="data-WG125", pattern=".csv");
  filename <- filenames[menu(filenames,title="Available Time Series Sites:")];
  
  if (length(filename) < 1 ) {
    
    iEXIT <- 1; 
    
  } else {
    
    
    #                        " Load the menu selected file and look at the headers. ";
    
    loadDATA <-  read.csv( paste('data-WG125/',filename,sep=''), header=TRUE, as.is=TRUE, dec='.', sep=',',na.string=" ");
    
    #                        " If the data file has more than two columns, let user pick what variable they want.";
    if ( length(colnames(loadDATA)) > 2 ) {
      iVARpick <- menu(colnames(loadDATA));
    } else {
      iVARpick <- 2;  # "If only two columns, automatically select the only data column.";
    }
    
    #                        " R automatically replaces spaces in column headers with periods. ";
    #                        " This reverts that for the variable name strings";
    tmp <- gsub("\\."," ",colnames(loadDATA));
    stdVARname <- tmp[iVARpick];
    stdSITEname <- filename;
    
    
    #                         " Load the raw data and (only) the selected variable column into rawDATA. ";
    rawDATA = loadDATA[,c(1,iVARpick)];
    #                         " Log10 the (assumed biological) variable.  [It may be better to load already log data?] ";
    rLOGtmp = log10(rawDATA[,2]);
    rawDATA[,2] = rLOGtmp;

    #                         " 'Filled' will have any missing months or years filled with 'na'.  Use column [,2] ";
    filled <- merge(rawDATA,fillblanks,by.x=1,by.y=1,all=TRUE);
    
    #                         " 'cleanDATA' contains only years and months with data present. ";
    cleanDATA = na.omit(rawDATA);
    
    #                         " Calculated the first year with data in the incoming time series. ";
    tmp <- as.POSIXlt(as.Date(rawDATA[,1],format="%Y_%m_%d"))$year+1900;  
    #" tsSTARTyear = tmp[which.min(tmp)]; ";
    #                       " Find the nearest year (step of 5) at or below tsSTARTyear ";
    tsSTARTyear <- round( (( tmp[which.min(tmp)] - 2)/5.),0) * 5.;  

    #                         " Must be 2010 because that is where blank-1900-to-2010 ends. ";
    tsENDyear = 2010; 
    
    
    #"------------------------------------------------------------------------------------------------------------";
    #"------------------------------------------------------------------------------------------------------------";
    # "Set up a graphing windows with two columns or three rows each ... ";

    par(mfrow=c(3,2));

    # "  The graphics are plotted in this order:  upper-left, upper-right, middle-left, middle-right, lower-left, lower-right ";

    #"------------------------------------------------------------------------------------------------------------";
    

    #"------------------------------------------------------------------------------------------------------------";
    #"   WG125 Monthly Mean Matrix  (uses relative value color bar) ";
    #"------------------------------------------------------------------------------------------------------------";

    library(fields);
        
    #                       " Use the starting year (tsSTARTyear) to cut the filled array (1900-2010) existing data only. ";
    iSTyearOFFset = ((tsSTARTyear - 1900)*12);
    cutfilled <- filled[-(1:iSTyearOFFset),c(1,2)];
    
    years = tsSTARTyear:tsENDyear;
    nbyears = length(years);
    
    monthstr = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
    
    #                          " Built a 12 month by years array ";
    monthlybox <- ts(cutfilled[,2],deltat=1/12);
    
    #                          " Convert monthlybox into an array ";
    datamm = array(monthlybox, dim = c(12, nbyears));

    matrixMM = t(datamm); #"Transpose";
    
    if (nbyears < 11) {	
      xpositions = 0:(nbyears - 1) / (nbyears - 1); 
      xlabels = paste(years);
    } else {
      nbyearsaxis = length(seq(tsSTARTyear-tsSTARTyear,tsENDyear-tsSTARTyear,by=5));
      xpositions = 0:(nbyearsaxis - 1) / (nbyearsaxis - 1);
      xlabels = c(seq(tsSTARTyear,tsENDyear,by=5));
    }
    
    ypositions =  0:11 / 11;
    ylabels = monthstr;


    cbar.monthlymean = colorRampPalette(c("#00007F","blue","#007FFF","cyan","#7FFF7F","yellow","#FF7F00","red","#7F0000"));

    image(matrixMM, col = cbar.monthlymean(100), axes = FALSE, frame.plot = TRUE, xlab = "", ylab = "",main="Monthly Means (ranked)");
    
    axis(1, lty = "solid", lwd = 1, tck = 0, at = xpositions, labels = xlabels, las = 2, mgp = c(0, 0.6, 0), cex.axis = 1.2, font.axis = 2);
    axis(2, lty = "solid", lwd = 1, tck = 0, at = ypositions, labels = ylabels, las = 2, mgp = c(0, 0.6, 0), cex.axis = 1.2, font.axis = 2);
    grid(nx = nbyears, ny = NA, col = "white", lty = "solid", lwd = 2);
    grid(nx = NA, ny = 12, col = "white", lty = "solid", lwd = 2);
    box();

    
    #"------------------------------------------------------------------------------------------------------------";
    #"   SEASONAL CYCLE PLOT: ";
    #"------------------------------------------------------------------------------------------------------------";

    #" library(pastecs);   I am not sure if these are required anymore." ;
    #" library(date);" ;
    
    #                          " Convert the (filled) time series into a 12 column (months) by year array.  ";
    monthlybox <- ts(filled[,2],deltat=1/12);

    #                          " Plot the Seasonal Cycle using boxes and whiskers for each month ... (pastecs) ";
    boxplot(split(monthlybox,cycle(monthlybox)),names=month.abb,col="green",main=paste("Seasonal Cycle\n",stdVARname," @ ",stdSITEname));
    

    


    #"------------------------------------------------------------------------------------------------------------";
    #"   WG125 Monthly Anomaly Matrix  (uses blue,light-blue,pink,red color bar)";
    #"------------------------------------------------------------------------------------------------------------";
    
    library(fields);

    #                       " Use the starting year (tsSTARTyear) to cut filled array (1900-2010) to size. ";
    iSTyearOFFset = ((tsSTARTyear - 1900)*12);
    cutfilled <- filled[-(1:iSTyearOFFset),c(1,2)];
    
    years = tsSTARTyear:tsENDyear;
    nbyears = length(years);
    
    
    monthstr = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

    #                          " Built a 12 month by years array ";
    monthlybox <- ts(cutfilled[,2],deltat=1/12);
    
    #                          " Convert monthlybox into an array ";
    datamm = array(monthlybox, dim = c(12, nbyears));

    #                          " Calculate monthly anomalies ";
    datama = (datamm - rowMeans(datamm, na.rm = TRUE)) / sd(t(datamm), na.rm = TRUE);

    matrixMA = t(datama); #"Transpose";
    
    if (nbyears < 11) {	
      xpositions = 0:(nbyears - 1) / (nbyears - 1); 
      xlabels = paste(years);
    } else {
      nbyearsaxis = length(seq(tsSTARTyear-tsSTARTyear,tsENDyear-tsSTARTyear,by=5));
      xpositions = 0:(nbyearsaxis - 1) / (nbyearsaxis - 1);
      xlabels = c(seq(tsSTARTyear,tsENDyear,by=5));
    }
    

    #                         " Set up a color bar of blue or red, using step 4 to create light blue and pink (salmon?) ";



    ypositions =  0:11 / 11;
    ylabels = monthstr;

    cbar.monthlyanom = two.colors(n=4,start="#0000ff",end="#ff0000");

    image(matrixMA, col = cbar.monthlyanom, axes = FALSE, frame.plot = TRUE, xlab = "", ylab = "",main="Monthly Anomalies (ranked)");
    
    axis(1, lty = "solid", lwd = 1, tck = 0, at = xpositions, labels = xlabels, las = 2, mgp = c(0, 0.6, 0), cex.axis = 1.2, font.axis = 2);
    axis(2, lty = "solid", lwd = 1, tck = 0, at = ypositions, labels = ylabels, las = 2, mgp = c(0, 0.6, 0), cex.axis = 1.2, font.axis = 2);
    grid(nx = nbyears, ny = NA, col = "white", lty = "solid", lwd = 2);
    grid(nx = NA, ny = 12, col = "white", lty = "solid", lwd = 2);
    box();



    #"------------------------------------------------------------------------------------------------------------";
    #"   SCATTER PLOT:  Monthly mean values by year ";
    #"------------------------------------------------------------------------------------------------------------";    
    
    #                          " 'as.Date' converts the YYYY_MM_DD dates into decimal years for plotting ";
    plot(as.Date(cleanDATA[,1],"%Y_%m_%d"),cleanDATA[,2],ylab="values",main=paste("Monthly Mean Values by Year\n",stdVARname," @ ",stdSITEname));
    
    #                          " 'abline' plots a line of the linear model ('lm') ";
    abline(lm(cleanDATA[,2]~as.Date(cleanDATA[,1],"%Y_%m_%d")),col="red",lty="dotted",lwd=2);
    


    #"------------------------------------------------------------------------------------------------------------";
    #"   WG125 Annual Anomalies Plot  ";
    #"------------------------------------------------------------------------------------------------------------";

    tmpvar <- aggregate(cleanDATA[,2],list(cut(as.Date(cleanDATA[,1],"%Y_%m_%d"),"y")),mean);
    
    tsanndate <- as.POSIXlt(tmpvar[,1])$year+1900 ;
    tmin = min(tsanndate); 
    
    tsannmean <- tmpvar[,2];
    tsannscor <- tsannmean - mean(tsannmean);
    
    ymin = min(tsannscor);
    ymax = max(tsannscor);
    if (ymin > ymax) {
      ymax = abs(ymin);
    }

    years = tsSTARTyear:tsENDyear;
    nbyears = length(years);

    if (nbyears < 11) {	
      xpositions = 0:(nbyears - 1) / (nbyears - 1); 
      xlabels = paste(years);
    } else {
      nbyearsaxis = length(seq(tsSTARTyear-tsSTARTyear,tsENDyear-tsSTARTyear,by=5));
      xpositions = 0:(nbyearsaxis - 1) / (nbyearsaxis - 1);
      xlabels = c(seq(tsSTARTyear,tsENDyear,by=5));
    }

    plot(tsanndate,tsannscor,type="h",col=ifelse( tsannscor > 0,  'red', 'blue'),xlim=c(tsSTARTyear,tsENDyear),xlab="Years", ylim=c(-1*ymax,ymax), ylab="SCOR anom", frame.plot=TRUE, lend="butt", lwd=8,main=paste("ANNUAL ANOMALIES:\n",stdVARname," @ ",stdSITEname));  
    
    #"------------------------------------------------------------------------------------------------------------";    




  } # "length(name) > 0"
      #"----------------------- REPEATING MENU LOOP (end) ------------------------------------------------------------";     
 }

