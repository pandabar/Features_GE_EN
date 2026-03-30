rankall <- function(outcome, num = "best") {
## Read outcome data
h <- read.csv("outcome-of-care-measures.csv")
h[h == "Not Available"] <- NA
h<-h[, c(2,7,11,17,23)]
colnames(h)<-c("hospital", "state", "ha", "hf", "pn")
h[,c(3:5)] <- sapply(h[,c(3:5)],as.numeric)
h$state<-as.factor(h$state)
out<-c("heart attack"=3, "heart failure"=4, "pneumonia"=5) # refer to relevant cols
colnum<-unname(out[outcome])
## Check that state and outcome are valid
if (outcome %in% names(out)==FALSE) {
  stop("invalid outcome")
} else {
## For each state, find the hospital of the given rank
  df<-data.frame()
  byst<-split(h, h$state)
    rankbyst<-lapply(byst, function(x) x[order(x[,colnum], x$hospital, na.last = NA), ])
        if (num=="best") {
      df<-do.call(rbind, (lapply(rankbyst, function(x) x[1,c(1,2)])))
    }
    else if (num == "worst") {
      df<-do.call(rbind, (lapply(rankbyst, function(x) x[nrow(x),c(1,2)])))
  }
   else {
     getnrow<-sapply(rankbyst, nrow)
      if(num <= max(getnrow)) {
    df<-do.call(rbind, (lapply(rankbyst, function(x) x[num,c(1,2)])))
    }else {
      NA }
   }   
    ## Return a data frame with the hospital names and the
## (abbreviated) state name
df
}
}