corr<-function(directory, threshold=0) {
  y<-vector("numeric", 0)
      x<-complete(directory, id)
      x1<-subset(x, nobs > threshold)
      print(nrow(x1))
       for (i in 1:nrow(x1)) {
        y[i]<-cor(my_dfs[[x1[i,1]]]$nitrate, my_dfs[[x1[i,1]]]$sulfate, use = "complete.obs")
        
      
       }
      y
             }
  