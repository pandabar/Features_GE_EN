data(iris)
tapply(iris$Sepal.Length, iris$Species, mean)
apply(iris[,1:4], 2, mean)
library(datasets)
#different ways to calculate mean by a given variable
data(mtcars)
head(mtcars)
tapply(mtcars$mpg, mtcars$cyl, mean)
sapply(split(mtcars$mpg, mtcars$cyl), mean)
with(mtcars, tapply(mpg, cyl, mean))
#what is the absolute difference between the average horsepower of 
#4-cylinder cars and the average horsepower of 8-cylinder cars
hpvals<-tapply(mtcars$hp, mtcars$cyl, mean)
hpvals[1] - hpvals [3]
# what happens if I do this
debug(ls)
ls
