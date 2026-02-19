#===================================Point patterns with Ripley's K====================
#This script creates two point patterns, one clusters and one unifor and builds
#a function to compute and plot Ripley's K for each

#load spatstat,sf and ggplot

library(spatstat)
library(ggplot2)
library(sf)

#First build a clustered point pattern. We can do this simply by generating random x and y coordinates
#drawn from the same normal distribution for each (this means tha values for x and y will tend towards the mean so we can be sure of a clumped patter)

#set seed value for reproduceability
set.seed(9)
x <- rnorm(100, 100, 30)
y <- rnorm(100, 100, 30)

#create point pattern within a 200 by 200 unit square
dummyPoints <- ppp(x = x, y = y, window = square(200))

#plot
plot(dummyPoints)
points=dummyPoints

#create series of radii
r=1:100

#function to comute Ripley's K
funRipley=function(x,points){
  
  #get the intensity of the point pattern (~denisty)
  I=intensity(points)  
  
  #create two lists, one to collect theoreteical K values (assuming complete spatial randomness - CSR) 
  csrList=list()
  #and one for the empirical K (for the actual point pattern)
  kList=list()
  
  #for loop to iterate over all points and count the number of other points within distance x
  for(i in length(points)){
    #theoretical K under CSR is just intensity times the area of a circle with radius x divided by intensity, so just pi*r^2
    csrK=pi*x^2
    
    #now create a buffer of radius x and count all points within that buffer
    
    #buffer
    buff.i=st_buffer(st_as_sf(points[i]),dist=x)
    
    #the above buffer will buffer both the point and the window - we just want the point
    buff.i=buff.i[buff.i$label=="point",]
    
    #number of points within the buffer (minus the focal point itself- that doesn't count)
    numPoints=nrow(st_as_sf(points)[buff.i,])-1
    
    #K value 
    k=e.i/I
    
    #add theoretical K to the list
    csrList[[i]]=csrK
    #add the actual K to the other list
    kList[[i]]=k
    
    
  }
  
  df=data.frame(radius=x,crsK=mean(unlist(csrList)),empK=mean(unlist(kList)))
  
  return(df)
  
}

