complete<-function(directory, id=1:332) {
  files_list <- list.files("specdata", full.names=TRUE)   #creates a list of files
  df<-lapply(files_list, read.csv)
  id2<- c(2, 4, 8, 10, 12)
  for (i in id2) {
    df[[i]]<- na.omit(df[[i]])
    nobs<-nrow(df[[i]])
    vt<-c(i, nobs)
    
  }
  this <- do.call(rbind, vt)
  colnames(this)<-c("id", "nobs")
print(this)
}


  