#DATA FRAME ANALYSIS



#nb: how to use %>% %>% 
install.packages("tidyverse")
library(tidyverse)
data(mpg)
mpg %>% 
  filter(cty>21) %>% 
  head(3) %>% 
  print()


#extract colum from data frame
df[i]  /   df[[i]]  / df$name 
df[i,j]  / df[i,]  / df[,j]

#5.1: append a data to a vector 
v <- c(1,2,3)
newItem <- c(6,7,8)
c(v,newItem)
v <- c(v,4)
w <- c(10)
v <- c(v,w)

#5.2: insert data into a vector 
#append(vec, newvalues, after = n)
append(1:10, 99, after = 5)

#Recycling rule 
(1:3) + (1:6)
cbind(1:6 , 1:3)
(1:6) + (1:5)
(1:6) + 10

#5.4: Creating a Factor variable (categorical variable)
v <-  c("red","black","white")
f <- factor(v) #create factor using the factor function
f <- factor(v,levels = c("white", "black", "green", "red")) # if the vector contains subset of possible values and not the entire universe 
f

#5.5: Combining vectors in one vector and a factor 
aa <- c(1,2,3)
bb <- c(4,5,6)
cc<- c(7,8,9)
comb <- stack(list(a=aa,b=bb,c=cc))
print(comb)
aov(values ~ ind , data = comb  ) #annova test 

# 5.6: Creating a list 
x <-  1
y <- 8
z <- 9
lst <- list(x,y,z)
lst <- list(3.14, "Moe" , c(1,2,3),mean)
lst
lst[[1]] <- 3.14 #create a list by index position
lst <-  list(mid = 0.5, right = 0.845, far.right = 8.3685)


#5.7: Selecting list element by position 
lst[[n]] # access the nth element of the list 
lst[c(n1,n2,n4)] #return list of elements selected 
years <- list(1936,1954,1958) #exemple
years
years[[1]] # is an element and not a list
years[1] #is a list 
years[c(1,2)]#is a list
#checks
years[[1]] %>% 
  class() #check the class --> numeric
class(years[[1]])
years[1] %>% 
  class() #check the class --> list
class(years[1])









