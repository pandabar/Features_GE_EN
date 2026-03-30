makeVector <- function(x = numeric()) {
  m <- NULL
  set <- function(y) {
    x <<- y
    m <<- NULL
  }
  get <- function() x
  setmean <- function(mean) m <<- mean
  getmean <- function() m
  list(set = set, get = get,
       setmean = setmean,
       getmean = getmean)
}

cachemean <- function(x, ...) {
  m <- x$getmean()
  if(!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  data <- x$get()
  m <- mean(data, ...)
  x$setmean(m)
  m
}

## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function

makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL
  seti <- function(y) {
    x <<- y
    inv <<- NULL
  }
  geti <- function() x
  setinv <- function(solve) inv <<- solve
  getinv <- function() inv
  list(seti = seti, geti = geti,
       setinv = setinv,
       getinv = getinv)
}


## This function gets the inverse matrix after being cached via makeCacheMatrix

cacheSolve <- function(x, ...) {
 inv <- x$getinv()
if(!is.null(inv)) {
  message("bleep bleep... perusing the depths of my database...")
  return(inv)
}
datai <- x$geti()
inv <- solve(datai, ...)
x$setinv(inv)
inv
  ## Return a matrix that is the inverse of 'x'
}