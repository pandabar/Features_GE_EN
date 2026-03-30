this <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode<- readLines(this)
close(this)
htmlCode

library(utils)
    
ah<-read.fwf("getdata_wksst8110.for", widths= c(10,5,4,4,4,5,4,5,4), header=FALSE, skip=4)
View(ah)