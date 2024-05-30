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


##### session 3 May 14 ----
# or
ggplot(data = titanic) +
  geom_bar(aes(x = Survived), width = 0.1 , fill = "blue") +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
        vjust = "bottom", nudge_y = 15)

# let's convert the survived into a factor again    
titanic$Survived <- as.factor(titanic$Survived)

# How to remove the gray background?
ggplot(data = titanic) +
  geom_bar(aes(x = Survived), width = 0.1 , fill = "blue") +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = "bottom", nudge_y = 15) +
  theme_classic()

# we are using GGPLOT, what is GG ? Grammar of Graphics 
###  you can use Cheat Sheets to help you remember teh templates for plots

# let's change teh vertical axis to be from 0 to 600 and have 3 equal parts on that axis
ggplot(data = titanic) +
  geom_bar(aes(x = Survived), width = 0.1 , fill = "blue") +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) + 
  theme_classic() +
  ylim(0 , 600)

# Let's add some labels and titles
ggplot(data = titanic) +
  geom_bar(aes(x = Survived), width = 0.1 , fill = "blue") +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) + 
  theme_classic() +
  ylim(0 , 600) +
  labs(title = "Figure 1: Number of Survivers")

# what happens if we remove "s
ggplot(data = titanic) +
  geom_bar(aes(x = Survived), width = 0.1 , fill = "blue") +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) + 
  theme_classic() +
  ylim(0 , 600) +
  labs(title = Figure 1: Number of Survivers)

# adding titles for axes
ggplot(data = titanic) +
  geom_bar( aes(x = Survived), width = 0.1 , fill = "blue") +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) + ylim(0, 600) +
  theme_classic() +
  labs(title = "Figure 1: Number of Survivers") +
  xlab("Survived?") 

ggplot(data = titanic) +
  geom_bar(aes(x = Survived), width = 0.1 , fill = "blue") +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) + ylim(0, 600) +
  theme_classic() +
  labs(title = "Figure 1: Number of Survivers") +
  xlab("Survived?") +
  ylab("Number of passangers")

# Can we add subtitle?
ggplot(data = titanic) +
  geom_bar(aes(x = Survived), width = 0.1 , fill = "blue") +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) + ylim(0, 600) +
  theme_classic() +
  labs(title = "Figure 1: Number of Survivers") +
  xlab("Survived?") +
  ylab("Number of passangers") +
  labs(subtitle="This is the subtitle")

# add caption
ggplot(data = titanic) +
  geom_bar(aes(x = Survived), width = 0.1 , fill = "blue") +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) + ylim(0, 600) +
  theme_classic() +
  labs(title = "Figure 1: Number of Survivers" ,
       subtitle = "This is a subtitle",
       caption = "caption: Reference of data") +
  xlab("Survived ?") +
  ylab("Number of people")

# To save the plot
ggsave("MyFirstPlot.png")

# where did it save? you need to know your working directory
getwd()

# to create a working directory we can use teh following
setwd("D:/Courses/ECON3880")

# notice that in Windows yuo need to have / not \ in teh path 
setwd("D:\Courses\ECON3880")

# lets read a data set from our computer
library(readr)
fin_indicators <- read_csv("fin_indicators.csv")
View(fin_indicators)

# Get back to Titanic data
# Gender Based Analysis (GBA): Any differences between Male and Female?

# instead of coloring everything Blue we fill everything based on 
# gender by adding FILL = SEX

ggplot(data = titanic) +
  geom_bar(aes(x = Survived, fill= Sex  ), width = 0.1) +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) +
  theme_classic()

# Same code just change x and fill
ggplot(data = titanic) +
  geom_bar(aes(fill = Survived, x = Sex  ), width = 0.1) +
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) +
  theme_classic()

# to solve the problem (we have x= Se and x= Survived)
ggplot(data = titanic) +
  geom_bar(aes(fill = Survived, x = Sex  ), width = 0.1) +
  geom_text(stat = "count" ,
            aes(x = Sex , label = after_stat(count)),
            vjust = -0.8) +
  theme_classic()

#Let's put bars next to each other instead of stacking. 
# HOW???? use f1 for geom_bar 
ggplot(data = titanic) +
  geom_bar(aes(x = Survived , fill = Sex),  width = 0.8 ,
           position = position_dodge()) +  # position = "dodge" also works 
  geom_text(stat = "count" ,
            aes(x = Survived , label = after_stat(count)),
            vjust = -0.8) +
  theme_classic()

# let's adjust the numbers seen in the chart.
ggplot(data = titanic , aes(x = Survived , fill = Sex)) +
  geom_bar(position = position_dodge()) +
  geom_text(
    stat = "count" ,
    aes(label = after_stat(count)),
    vjust = -0.8 ,
    position = position_dodge(width = 0.8)
  ) +
  theme_classic() 

# Survival by Passenger Class?
ggplot(data = titanic , aes(x = Survived , fill = Pclass)) +
  geom_bar(position = position_dodge()) +
  geom_text(
    stat = "count" ,
    aes(label = after_stat(count)),
    vjust = -0.8 ,
    position = position_dodge(width = 0.8)
  ) +
  theme_classic()

# what went wrong?
# Pclass is a numeric variable and I need to convert it into a FActor
ggplot(data = titanic , aes(x = Survived , fill = as.factor( Pclass))) +
  geom_bar(position = position_dodge()) +
  geom_text(
    stat = "count" ,
    aes(label = after_stat(count)),
    vjust = -0.8 ,
    position = position_dodge(width = 0.8)
  ) +
  theme_classic()

# another way to create the chart
ggplot(data = titanic , aes(x = Pclass , fill = Survived)) +
  geom_bar(position = position_dodge()) +
  geom_text(
    stat = "count" ,
    aes(label = after_stat(count)),
    vjust = -0.8 ,
    position = position_dodge(width = 0.8)
  ) +
  theme_classic()

# who says money cannot buy happiness, here money buys life :)

# we can stack teh bars
ggplot(data = titanic , aes(fill = Survived , x = Pclass)) +
  geom_bar() +
  geom_text(stat = "count" ,
            aes(label = after_stat(count)),
            vjust = -.80 ,
            position = "stack") +
  theme_classic() 

# to adjust the location of numbers
ggplot(data = titanic , aes(fill = Survived , x = Pclass)) +
  geom_bar() +
  geom_text(stat = "count" ,
            aes(label = after_stat(count)),
            vjust = -.80 ,
            position = position_stack(vjust = 0.5)) +
  theme_classic()

# Is it possible to show the graph as a horizontal bars?
ggplot(data = titanic , aes(fill = Survived , x = Pclass)) +
  geom_bar() +
  geom_text(stat = "count" ,
            aes(label = after_stat(count)),
            vjust = -.80 ,
            position = position_stack(vjust = 0.5)) +
  theme_classic() +
  coord_flip()
# for fun
ggplot(data = titanic , aes(fill = Survived , x = Pclass)) +
  geom_bar() +
  geom_text(stat = "count" ,
            aes(label = after_stat(count)),
            vjust = -.80 ,
            position = position_stack(vjust = 0.5)) +
  theme_classic() + 
  coord_polar()

# Session 4 , May  ----
library(ggplot2) # we need to call our package every time
library(titanic)

titanic <- titanic_train
# survivor by age? Age is continues 
ggplot(data = titanic , aes(x = Age)) +
        geom_density()

# add some color to the graph
ggplot(data = titanic , aes(x = Age, fill = "gold")) +
  geom_density()
 # oops ! it did mot work because gold is not a variable included in the data
# so move fill = "gold" from inside teh aes( ) to geom_density()
ggplot(data = titanic , aes(x = Age)) +
  geom_density( fill = "gold")

# you can also change teh color of teh line from black to anything that you want

# survived by age
ggplot(data = titanic , aes(x = Age , fill = Survived)) +
  geom_histogram()

ggplot(data = titanic , aes(x = Age , fill = as.factor(Survived))) +
  geom_histogram()
# histogram looks very ugly let's change it to density
ggplot(data = titanic , aes(x = Age , fill = as.factor(Survived))) +
  geom_density()

# green curve covers teh red one and red one is not visible for young ages
ggplot(data = titanic , aes(x = Age , fill = as.factor(Survived))) +
  geom_density(alpha = 0.5)   # alpha controls teh Opacity

ggplot(data = titanic , aes(x = Age , fill = as.factor(Survived))) +
  geom_density(alpha = 0.7)

# Let's create a BoxPlot
#let make survived a factor

titanic$Survived <-  as.factor(titanic$Survived)
ggplot(data = titanic , aes(x = Survived , y = Age)) +
  geom_boxplot()

# outlier observation 
#  color the boxes based on gender to see the differences based on Sex
titanic$Survived <-  as.factor(titanic$Survived)
ggplot(data = titanic , aes(x = Survived , y = Age, fill = Sex)) +
  geom_boxplot()

# Let's create plots based on Sex and Passenger class
# how many variables we want to use?
ggplot(titanic , aes(x = Sex , fill = Survived)) +
  geom_bar() +
  facet_wrap( ~Pclass)

# # Survival by Age, Sex, Pclass
ggplot(titanic , aes(x = Age , fill = Survived)) +
  geom_bar() +
  facet_wrap( ~Pclass + Sex)
# because Age is continuous it does not make sense to use geom_bar

ggplot(titanic , aes(x = Age , fill = Survived)) +
  geom_density() +
  facet_wrap( ~Pclass + Sex)

# lets use alpha for opacity 
ggplot(titanic , aes(x = Age , fill = Survived)) +
  geom_density(alpha = 0.7) +
  facet_wrap( ~Pclass + Sex)

# let's arrange the plots differently
ggplot(titanic , aes(x = Age , fill = Survived)) +
  geom_density(alpha = 0.7) +
  facet_grid( Pclass ~ Sex)

# let's see another dataset
eco <- economics

# plot date vs pce (a time series plot)
plot(eco$date , eco$pce)

# using ggplot
ggplot(eco, aes(x = date, y = pce) ) +
  geom_line(size = 0.5, colour = "#112446") +
  theme_minimal()

# let's use the mtcars that we used in teh R Notebook example
mtcars$cyl <- as.factor(mtcars$cyl)

ggplot(mtcars , aes(x = wt , y = mpg)) +
  geom_point()
# to show teh relationship easier
ggplot(mtcars , aes(x = wt , y = mpg)) +
  geom_point() +
  geom_smooth()
# to make teh blue line as a LINE
ggplot(mtcars , aes(x = wt , y = mpg)) +
  geom_point() +
  geom_smooth( method = lm)

# lets add number of cylinders to teh picture
ggplot(mtcars , aes(x = wt , y = mpg)) +
  geom_point(aes(color = cyl   , shape = cyl)) +
  geom_smooth( method = lm)

# let's have different trend line for different cyl
ggplot(mtcars , aes(x = wt , y = mpg)) +
  geom_point(aes(color = cyl   , shape = cyl)) +
  geom_smooth( method = lm,  aes(  color = cyl))

# adding labels to teh points
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  geom_text(aes(label = rownames(mtcars)))

# to solve teh overlap of teh labels
# google geom_text label overlap
 # install ggrepel 
library(ggrepel)
ggplot(mtcars, aes(wt, mpg, label = rownames(mtcars))) +
  geom_text_repel() +
  geom_point(color = 'red')

# jitter
# let's read some data into R from Excel
# using code
jitter_example <- read_excel("D:/Courses/ECON3880/jitter_example.xlsx")

View(jitter_example)

# let's change teh name of this data set
df <-  jitter_example

# create a scatter plot between x and y from df
ggplot(data = df , aes(x , y)) +
  geom_point(size = 3)
 # we conclude that the data is distributed uniformly. is it?
ggplot(data = df , aes(x , y)) +
  geom_point(size = 3) +
  geom_jitter()
  
ggplot(data = df , aes(x , y)) +
  geom_point(size = 3) +
  geom_jitter(size = 4)

#  Try google geom_count() and see what it does

# an easier way to do basic graphs .
library(esquisse)
esquisser()  # this will run and open a new window

# interactive plots using Plotly

library(plotly)

fig1 <- plot_ly(
  data = iris,
  x = ~ Sepal.Length,
  y = ~ Petal.Length,
  color = ~ Species)
# to see fig1
fig1


# basic example of plotly charts: https://plotly.com/r/candlestick-charts/
library(quantmod)

getSymbols("COST",src='yahoo')

df <- data.frame(Date=index(COST),coredata(COST))
#df <- tail(df, 30)

fig <- df %>% plot_ly(x = ~Date, type="candlestick",
                      open = ~COST.Open, close = ~COST.Close,
                      high = ~COST.High, low = ~COST.Low) 
fig <- fig %>% layout(title = "Basic Candlestick Chart")

fig

# using ggplot2 nd plotly together
# I copied he code from above and give it a name, for example plot_titanic

plot_titanic <-  ggplot(data = titanic , aes(fill = Survived , x = Pclass)) +
  geom_bar() +
  geom_text(stat = "count" ,
            aes(label = after_stat(count)),
            vjust = -.80 ,
            position = "stack") +
  theme_classic()

# to make it interactive
ggplotly(plot_titanic)

# # google R Graph Gallery for cool plots

# The END :)








  