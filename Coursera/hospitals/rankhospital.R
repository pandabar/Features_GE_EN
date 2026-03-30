rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  h <- read.csv("outcome-of-care-measures.csv")
  h[h == "Not Available"] <- NA
  h<-h[, c(2,7,11,17,23)]
  colnames(h)<-c("name", "State", "ha", "hf", "pn")
  out<-c("heart attack"=3, "heart failure"=4, "pneumonia"=5) # refer to relevant cols
  ## Check that state and outcome are valid
  if (state %in% unique(h$State) ==FALSE) {
    stop("invalid state") 
  } else if (outcome %in% names(out)==FALSE) {
    stop("invalid outcome")
  } else {
    ##create a subset by state and turn relevant cols as numeric
    bests<-subset(h, State==state)
  bests[,c(3:5)] <- sapply(bests[,c(3:5)],as.numeric)
  ##arrange using order() which takes the name col to untie & removes na
  bests2<-bests[order(bests[,unname(out[outcome])], bests[,1], na.last = NA),]
  ## Return hospital name in that state with lowest 30-day death rate
  if (num=="best") {
    bests2[1,1]
  }
  else if (num == "worst") {
    bests2[nrow(bests2),1]
  }
  else if(num <= nrow(bests2)) {
    bests2[c(num),1]} #first row, col 2} 
  else {
    NA }
}
}
