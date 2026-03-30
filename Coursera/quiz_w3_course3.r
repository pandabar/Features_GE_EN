#1
getdata_data_ss06hid2 <- read.csv("~/Coursera/getdata_data_ss06hid2.csv", stringsAsFactors=TRUE)
agricultureLogical<-ifelse(getdata_data_ss06hid2$ACR==3 & getdata_data_ss06hid2$AGS==6, TRUE, FALSE)
which(agricultureLogical)

#2
library(jpeg)
a<-readJPEG("getdata_jeff.jpg", native = TRUE)
a
summary(a)
quantile(a, probs=c(0.3, 0.8))

#3
GDP <- read.csv("~/Coursera/getdata_data_GDP.csv", header=TRUE, skip=3)
GDP<-GDP[2:191,] #lots of NAs
edstats <- read.csv("~/Coursera/getdata_data_EDSTATS_Country.csv")
names(GDP)
names(edstats)
mergeddata<-merge(edstats, GDP, by.x="CountryCode", by.y="X", all=TRUE)
str(mergeddata$Ranking)
mergeddata$Ranking<-as.numeric(mergeddata$Ranking)
merged2<-mergeddata[order(mergeddata$Ranking, decreasing=TRUE),]
merged2[13,2]

#4
hi<-subset(merged2, Income.Group=="High income: OECD")
lo<-subset(merged2, Income.Group=="High income: nonOECD")
mean(hi$Ranking)
summary(lo$Ranking)

#5
library(dplyr)
q38<-quantile(merged2$Ranking, probs=.38, na.rm=TRUE)

new<- merged2 %>%
  mutate(qs =ntile(Ranking, 5))

table(new$Income.Group, new$qs)
