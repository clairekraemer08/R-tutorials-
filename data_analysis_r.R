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


#5.8 Selecting list element by name 
#want to access list element by their name 
lst <- list(black = 1, red = 2 , green = 3)
lst[["black"]]
lst["black"]
lst$black
lst[c("black","green")]

#5.9 Buliding a name/value association list 
#want to create dictionnary --> list function
values <- c(1,2,3)
names <- c("dark", "white","yellow")
lst <- list() #empty list
lst[names] <- values
values <- -2:2
names <- c("a", "b", "c", "d","e")
lst <- list()
lst[names] <- values
cat("The a limit is", lst[["a"]], "\n")


#5.10 Removing element from a list 
lst[["a"]]<- NULL #remove a from the list 
lst[c("a","b")] <-  NULL #remove several elemenfrom a list 

#5.11: Flattening a list into a vector 
#use the unlist function 
iq.score <- list(2,30,50,90)
mean(iq.score) #cannot 
mean(unlist(iq.score)) #fcan because unlisted
cat(iq.score, "\n") # cannot cat a list , only scalar and vectors 
cat("IQ Scores:", unlist(iq.score), "\n")


#5.12: Removing null element from a list 
#use the function compact
install.packages("purrr")
library(purrr)
lst <- list("Moe", NULL, "Curly")
compact(lst)

#5.13: Removing list element using a condition
lst <- list(NA, 0, NA) 
lst %>% discard(is.na)
lst <- list(3, "dog" , 2 , "cat", 1)
lst %>%  
  discard(is.character) #remove character from the list 
#create function that may delete either null or na 
is_na_null <- function(x) {
  is.na(x) || is.null(x)
}
lst <- list(1,NA,2,NULL,3)
lst %>% 
  discard(is_na_null)

mods <- list(lm(x~y1),
             lm(x~y2),
             lm(x~y3))
filter-r2 <- function(model) {
  summary(model)$r.squared < 0.7
}
mods %>% 
  discard(filter_r2) #we define a function to only keep r sqaured superior to 0.7 applyig then the discard funtion 


#5.14 Initializing a matrix 
#create a matrix 
matrix(0,2,3)
matrix(NA,2,3)
mat <- matrix(c(1,2,3),2,3) #difficult to read
print(mat)
theMatrix <-  c(
  1, 2, 3,
  1, 2, 3
)
mat <- matrix(theMatrix, 2, 3, byrow= TRUE)
print(mat)
#turn a vector into a matrix 
v <- c(1,2,3,4,5,6)
dim(v) <-  c(2,3)
print(v)

#Matrix operation 
t(A) #transpose
solve(A) #inverse
A %*% B #matrix multiplication 
diag(n) #contruct an identity matrix 


#5.16: Name to rows and column of matrix
rownames(mat) <- c("rowname1", "rowname2")
colnames(mat) #...

#5.17 Select row/column from matrix
mat[1,] #result b a vector 
mat[,3] 
mat[1, , drop = FALSE] #result be a one column matrix 


#5.18: Initializng a df from a column data 
#data.frame function
v1 <- c(1,5,8,6)
v2 <- c(2,5,3,6)
v3 <- c(8,9,6,32)
df <- data.frame(v1,v2,v3)
#if data is captured in a list of vectors : as.data.frame(list.f.vectors)
df <- data.frame(variable_1 = v1, variable_2 = v2, variable_3 = v3) #to overrride the column name


#5.19 Initializing a df from row data
#function rbind 
df1 <- data.frame(a=1, b=2, c="X")
df2 <- data.frame(a=23, b=27, c="X")
df3 <- data.frame(a=17, b=82, c="y")
df <- rbind(df1,df2,df3)
cbind(df1,df2,df3)
#beware: by default string are converted to factors --> see data.frame(..., stringAsFactors = FALSE)
i <- sapply(df, is.character) #which column is character 
df[3] <- lapply(df[3], as.factor) #convert to factor  
i <- sapply(df, is.factor) 
i


#5.20 : Append a row to a df 
data(mpg)
newrow <-  data.frame( manufacturer= "mercedes", model= "m4" ,displ = 1.8 , year =1997  , cyl =4 ,trans ="auto",      drv = "f" ,   cty=18  , hwy=29, fl= "p" ,   class= "compact")
#create anew row 
rbind(mpg, newrow)
#or rbind(mpg, data.frame( manufacturer= "mercedes", model= "m4" ,displ = 1.8 , year =1997  , cyl =4 ,trans ="auto",      drv = "f" ,   cty=18  , hwy=29, fl= "p" ,   class= "compact"))


#5.21: Selecting df column by position 
#use the select function
df %>%  select(n1,n2)
install.packages("dyplr")
library(dplyr)
mpg %>% 
  dplyr :: select(1,6)
#select is part of the tidyverse package dplyr 
#or
mpg[[2]] #return a vector 
mpg[2] #return a df 
mpg[c(1,6)] # return a df 



#5.22 Selecting data frame column by name 
mpg %>% 
  select("model","year")
#or
mpg[["model"]]
mpg["model"]
mpg[c("model", "year")]
mpg[,"model"] #matrix style 



#5.23: Changing name of df columns
df %>%  rename(newname = oldname , ...)
#other way 
colnames(mpg) <-c("newname1","newname2")
#select and rename at the same time
df %>%  select(tom=v1, v2)


#5.24: Removing NAs from df 



















