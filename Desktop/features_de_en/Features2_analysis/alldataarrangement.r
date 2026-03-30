features_exp_15092023 <- read.csv("C:/Users/#4757-NBAsusUX310U/OneDrive/Escritorio/features_reloaded/features_exp_15092023.csv")
View(features_exp_15092023)
data<- features_exp_15092023

#subset rows with responses to questions on being a native speaker of German (nativeornot), and to the learning process (nndata).
nativeornot<-subset(data, data$internal_node_id=="0.0-2.0")
nativeornot$responses <-as.character(nativeornot$responses)
nndata<-subset(data, data$internal_node_id=="0.0-3.0-0.0")
nndata$responses<-as.character(nndata$responses)

#dejsonification of nativeornot
library(RJSONIO)
res1 <- do.call(rbind.data.frame,
 #              lapply(nativeornot$responses, FUN=function(x){ as.list(fromJSON(x))}))
 lapply(nativeornot$responses, FUN=function(x){ as.list(fromJSON(x))}))
native<-data.frame(nativeornot$subject,res1$Q0)
colnames(native)<-c("subject", "nativeornot")
data$group<-native$nativeornot[match(data$subject, native$subject)]

#dejsonification of the cols with learntype, aoa, etc. This creates a list for each speaker. We convert each list element to dataframe and then we attached the subject id to it

res2<-lapply(nndata$responses, FUN=function(x){ as.list(fromJSON(x))})
df <- lapply(res2, FUN=as.data.frame)
for (i in 1:length(df)) {
  df[[i]]$subject<-nndata$subject[i]
 
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

#here I merged with the main dataframe called data. 
djsonified<-merge(x=data,y= ayayay, all=TRUE)

#and save.
write.csv(djsonified, file="C:/Users/#4757-NBAsusUX310U/OneDrive/Escritorio/features_reloaded/readyformining7.csv", row.names=FALSE)


###I didn't use this Henri solution, but I'll leave it here for future reference
deal_with_learntypes <- function(x) {
  a<-which(str_detect(names(x), pattern="LearnType"))
  melt(x, measure.vars=a)
}

 df2<-lapply(df, deal_with_learntypes)                              
df3<-do.call(rbind, df2) 


