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

plot(dummyPoints)
points=dummyPoints

r=1:100
