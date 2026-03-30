complete<-function(directory, id=1:332) {
  files_list <- list.files(directory, full.names=TRUE)
  my_dfs<-lapply(files_list[id], read.csv) #opens only those files, not all
  end<-data.frame()
for (i in 1:length(id)) {
  my_dfs[[i]] <-na.omit(my_dfs[[i]])
  mydf[[i]]<-c(id[[i]], nrow(my_dfs[[i]]))
  end <- do.call(rbind, mydf)
  output<-as.data.frame(end)
  colnames(output)<-c("id", "nobs")
}
  output
}
