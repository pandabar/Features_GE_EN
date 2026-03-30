#install.packages("sqldf")
library(sqldf)
acs<-read.csv("getdata_data_ss06pid2.csv", header=TRUE, sep=",")
sqldf("select pwgtp1 from acs where AGEP <50")
sample<-acs[1:10, c(8,160)]
samesasunique<-sqldf("select distinct AGEP from acs")