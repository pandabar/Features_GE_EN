mydata<-merges("data", 1:28)
write.csv(mydata, "data_merged.csv", row.names = FALSE)

##open
data_merged <- read_csv("data_merged.csv")

library(RJSONIO)

#dejsonification of the cols with learntype, aoa, etc. This creates a list for each speaker. We convert each list element to dataframe and then we attached the subject id to it
res2<-subset(data_merged, trial_index==5)
just5<-lapply(res2$response, FUN=function(x){ as.list(fromJSON(x))})
df <- lapply(just5, FUN=as.data.frame)
for (i in 1:length(df)) {
  df[[i]]$subject<-res2$subject[i]
  
}

#Here I just converted the LearnType col into LearnType1
for (i in 1:length(df)) {
  if (names(df[[i]][3])=="LearnType") {
    print("yes")
    names(df[[i]])[names(df[[i]]) == 'LearnType'] <- 'LearnType1'
  }
}
##Here I created a vector with the LearnTypes in order. Then for every dataframe in the list df i check which of the LearnTypes are (not) present. Then I Attach the absent Learntypes as a column to each of the dataframes in df. Now every dataframe has 6 LearnType cols.
lts<-c(paste0("LearnType", seq(1:6)))
for (i in 1:length(df)) {
  xx<-lts[(lts %in% names(df[[i]]))==F]
  df[[i]][ ,xx] <- NA
}
#Now that every dataframe in df has the same cols, I give them a fixed order, and then they are rbind. Now all what was in df is one single dataframe. 
order<-c("native", "AOL", lts, "which", "AOA", "timespent", "subject")
ayayay<-do.call(rbind, lapply(df, function(x) x[match(order, names(x))]))

#I need to remove my own responses
whoisme<-subset(data_merged, trial_index==2)
#I am 38s2 (my "code" is 12345)
#And I also remove the person (0sr9) who said German was their native language
ayayay2<-subset(ayayay, subject!="0sr9" & subject!="38s2")
#here I merged with the main dataframe called data. 
data_merged2<-subset(data_merged, subject!="0sr9" & subject!="38s2")
djsonified<-merge(x=data_merged2,y= ayayay2, all=TRUE)

#and save.
write.csv(djsonified, file="readyformining.csv", row.names=FALSE)
