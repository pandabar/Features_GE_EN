merges<- function(directory, nf=1:28) {
  files_list <- list.files("data", full.names=TRUE)   #creates a list of files
  alltogether<- data.frame() 
for (i in nf) {
  alltogether<-rbind(alltogether, read.csv(files_list[i]))
}
  return(alltogether)
}


