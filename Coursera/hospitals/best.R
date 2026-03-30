best <- function(state, outcome) {
  ## Read outcome data
  h <- read.csv("outcome-of-care-measures.csv")
  h[h == "Not Available"] <- NA
  out<-c("heart attack"=11, "heart failure"=17, "pneumonia"=23) # refer to relevant cols
  ## Check that state and outcome are valid
  if (state %in% unique(h$State) ==FALSE) {
  stop("invalid state") 
  } else if (outcome %in% names(out)==FALSE) {
  stop("invalid outcome")
  } else
    ##create a subset by state and turn relevant cols as numeric
    bests<-subset(h, State==state)
    bests[,c(11,17,23)] <- sapply(bests[,c(11,17,23)],as.numeric)
    ##arrange using order() which takes the name col to untie & removes na
    bests2<-bests[order(bests[,unname(out[outcome])], bests[,2], na.last = NA),]
  ## Return hospital name in that state with lowest 30-day death rate
  bests2[1,2] #first row, col 2
}