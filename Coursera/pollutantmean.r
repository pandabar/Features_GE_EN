pollutantmean<- function(directory, pollutant, id= 1:332) {
  files_list <- list.files("specdata", full.names=TRUE)   #creates a list of files
  alltogether<- data.frame() 
  for (i in id) {
    alltogether <-rbind(alltogether, read.csv(files_list[i]))
  }
  mean(alltogether[, pollutant], na.rm=TRUE)  
}

