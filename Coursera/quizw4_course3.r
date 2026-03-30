#1
splnames<-strsplit(names(getdata_data_ss06hid),"wgtp")
splnames[123]

#2
data_GDP <- read.csv("~/Coursera/getdata_data_GDP.csv", skip=3)
View(data_GDP)
#millions<-subset(data_GDP, grepl("^ *[0-9]{1,3},[0-9]{3},[0-9]{3} *", data_GDP$US.dollars.))
millions<-data_GDP[2:191,]
millions$usd<-gsub(",","", millions$US.dollars.)
millions$usd<-as.numeric(millions$usd)
mean(millions$usd)

#3
grep("^United", millions$Economy)

#4
edstats <- read.csv("~/Coursera/getdata_data_EDSTATS_Country.csv")
names(GDP)
names(edstats)
mergeddata<-merge(edstats, GDP, by.x="CountryCode", by.y="X", all=TRUE)
junes<-grep("[fF]iscal [Yy]ear [Ee]nd: June", mergeddata$Special.Notes)

#5
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
library(lubridate)
justyear<-as.character(sampleTimes)
withday<-wday(sampleTimes, label=TRUE)
all<-data.frame(sampleTimes, justyear,withday)
colnames(all)<-c("original", "aschar", "weekday")
just2012<-subset(all, grepl("^2012", all$aschar) & all$weekday=="lun")
