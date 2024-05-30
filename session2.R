# Visualization using ggplot2 ----

"hello"
print("hi")

4 + 2
 x = 4

 x <- 4 # assigning the value of 4 to x
#  ALT  - <- 
#    options - 
    
  y <- 2  
  
 x + y
 
# change x to 7
 x <- 7
x + y  
# explaining the meaning of # we use it to comment 

# R is case sensitive b and B are two different things
2 * 5
b <- 2 * 5

#let's assume that teh sales volum was 125
B <- 125
b
B

# I want to remove B
rm(B)  # this is called a function 

# I create a vector of numbers from 1 to 20
c(1:20)
# to add these into teh environment we assign it to a name
z <- c(1:20)
print(z)
Z  # this did not work bc it is Capital z
z

# what is teh mean of vector z?
mean(z)

mean <- mean(z)

# standard deviation?
sd(z)

# what is teh median of z?
median(z)
 #let's get help 
?median

?rnorm

# What is an R package? see the list of packages and install a few
# to call a package we use library()
library(titanic)

#let's install it first using teh Install button from the Packages tab (bottom right)

titanic <- titanic_train
# see the definition of variables in titanic_train?

# let's create a very high quality graph. 
#Number of survivors vs number of perished passengers on board Titanic.

plot(titanic)
plot(titanic$Survived)

# create better plots using ggplot2
install.packages("ggplot2")
library(ggplot2)

ggplot(data = titanic )

# Bob Ross
ggplot(data = titanic ) +
  geom_bar(mapping = aes(x = Survived))
# bars are too wide, we want them a bit narrower
# let's get help from google ggplot geom_bar narrow
ggplot(data = titanic ) +
  geom_bar(mapping = aes(x = Survived), width = 0.5)

ggplot(data = titanic ) +
  geom_bar(mapping = aes(x = Survived), width = 0.3)

# to change the color of the bars into Blue
ggplot(data = titanic ) +
  geom_bar(mapping = aes(x = Survived), width = 0.3, fill= "blue")

# we see decimal numbers on x axis but we need to see only 0 and 1
# google r convert numeric to levels

titanic$Survived <- as.factor(titanic$Survived)

ggplot(data = titanic ) +
  geom_bar(mapping = aes(x = Survived), width = 0.3, fill= "blue")

#  let's change the color into Green and also make teh borders Red
ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = Survived), width = 0.3, 
           fill = "green", color = "red")

ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = Survived), width = 0.3, 
           fill = "lightgoldenrod", color = "lightblue")

ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = Survived), width = 0.3, 
           fill = "lightgoldenrod", color = "lightpink1")

# create a bar chart for Sex and another one for pclass
ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = sex), width = 0.3, 
           fill = "green", color = "red")  # typo

ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = Sex), width = 0.3, 
           fill = "green", color = "red")

ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = Pclass), width = 0.3, 
           fill = "green", color = "red")

# How about adding the numbers/values to the chart for survivers
ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = Survived), width = 0.3, 
           fill = "lightgoldenrod", color = "lightpink1") +
  geom_text(stat = "count" , 
            aes(x = Survived , label = stat(count)))

# adjust the position of the numbers
ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = Survived), width = 0.3, 
           fill = "lightgoldenrod", color = "lightpink1") +
  geom_text(stat = "count" , 
            aes(x = Survived , label = stat(count)), 
            vjust = 5)

ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = Survived), width = 0.3, 
           fill = "lightgoldenrod", color = "lightpink1") +
  geom_text(stat = "count" , 
            aes(x = Survived , label = stat(count)), 
            vjust = -5)

ggplot(data = titanic) + 
  geom_bar(mapping = aes(x = Survived), width = 0.3, 
           fill = "lightgoldenrod", color = "lightpink1") +
  geom_text(stat = "count" , 
            aes(x = Survived , label = stat(count)), 
            vjust = - 0.5)




































  