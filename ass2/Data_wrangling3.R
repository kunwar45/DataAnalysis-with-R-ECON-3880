# Data Wrangling 
# ECON 3880 
# May 21 2024

data1 <- c(4, 2) # this a vector
data1

data2 <- c("True", "False")   # this a vector
data2
data2 <- c(True, False)  # this is not going to work 

# I want to a combine the above 2 vectors
cbind(data1, data2)
data3 <- cbind(data1, data2)

data4 <- data.frame(data1, data2)

# data types
# check the data type
class(data4)
class(data3)

# we can see teh structure of data
str(data4)

## data frame
mydata <- ggplot2::diamonds

# to see some rows of teh data not all
head(mydata)
tail(mydata)

# let's say I want to see only top 3 rows
head(mydata, 3)

# dimension of data
dim(mydata)

str(mydata)
summary(mydata)

# selecting a specific row, or even observation
# say the first row and second column?
mydata[1 , 2  ]

#observation in row 25, column 4
mydata[25 , 4]

# First row ? 
mydata[1, ]   # leaving the space after , blank means all teh columns

#        First 20 rows ?
mydata[1:20 , ]

# Let's see from column 3 to 6 and row 5
mydata[5 , 3:6]
# incorrect way
mydata[5, 3 - 6]   # as we know 3-6 is equal to -3 and - means exclude
# so the above code excludes teh THIRD column (color)

# let's select column 7
mydata[  , 7]
# we can use teh name of the column to seelct instead of its position (location)

mydata[ , price]
mydata[ , "price"]

# remember we also can use teh following
mydata$price

mydata[5 , 4]
row5.column4 <-  mydata[5 , 4]

# Prices more than 18000
subset(mydata, price > 18000)

# let's see all the diamonds with a price less than 350 and
# also teh color E
subset(mydata, price < 350 & color = E )

subset(mydata, price < 350 & color = "E" )
subset(mydata, price < 350 & color = "E" )

#  <-   and = are equivalent 
subset(mydata, price < 350 & color == "E" )

# what is difference between = and ==  ?
2 = 2 
2 == 2  # bascially == means to check and verify if this is true or false
2 == 3

# another example using the data
mydata$color == "E"

#   Google r + operators
# diamonds with a color other than E
subset(mydata, color != "E")

#  OR condition 
subset(mydata, color == "H" | color == "E")

# let's create a new data set that includes only diamonds with color E or  H 
Only.H.E <-  subset(mydata, color == "H" | color == "E")


# to create a new column based on existing data
# 13% tax will be added to teh price. I want to create a column for tax
mydata$tax <- mydata$price * 0.13

# What if I do not want TAX column anymore?
mydata$tax <- NULL

##  data wrangling 2, May 23 ------

# Read data from other files --------------------------------------------------------

#   Create a CSV data in Excel and import it into R.
#
# Annual GDP growth rate of countries
GDP <-  read.csv("D:/Courses/ECON3880/GDP_World.csv") 

#   Define "working Directory"
setwd("D:/Courses/ECON3880")

GDP <- read.csv("./GDP_World.csv")

# we have another option to read csv files
library(readr)
GDP2 <- read_csv("./GDP_World.csv")

# R does not like to have a name for a varibale that starts with a number
str(GDP)

# notice that when we are creating R Notebook if we save data in teh same folder as teh RMd no need to mention WD


# a new package to examine teh data fast 
install.packages("skimr")

library(skimr)
skim(GDP)

# save our data as a csv
write.csv(GDP, "gallusGallus.csv")


# save an RDS file which is teh data format for R
saveRDS(GDP, "gallusGallus.rds")

# what if I want to read RDS data
z <- readRDS("gallusGallus.rds")

# let's verify that z and GDP are the same
all.equal(GDP, z)

# what if the file we want to open is not in the working directory?

# we have a data file called "TSMP_suicide.csv" located here: D:/data

suicide <- read.csv("TSMP_suicide.csv")
# but our working directory is D:/Courses/ECON3880 so how do we go 2 levels up?
# ../ to go 1 level up

suicide <- read.csv("../../data/TSMP_suicide.csv")

# let's go back to GDP data and see only Canada
CAN <- subset(GDP, Country.Name = Canada)
CAN <- subset(GDP, Country.Name == Canada)
CAN <- subset(GDP, Country.Name == "Canada")

# To filter data we can filter manually in View

# Subset using TidyVerse. What is Tidyverse?
library(tidyverse)
# https://cran.r-project.org/web/packages/tidyverse/

Can <- filter(GDP, Country.Name == "Canada")
# filter() is used to select some ROWs according to some conditions

# let's see PIPE  |>
# write the code the same way that you speak! Take GDP then filter ,,,, then show
# what we did in above example for Canada?
# I said take GDP, filter for Canada and shwo teh result

# let's transalte into R code
GDP |> filter(Country.Name == "Canada") |> view()

# short cut key for pipe  CTRL+Shift+M  
# older version of PIPE %>% 

# why to use pipe? ----
# let's use the data for flights from NY in 2013

flights <- nycflights13::flights
# let's explore the data types in this DF. It is tibble
# 1- lets's filter for destination AUS
# 2- then calculate and add a new column for speed (use mutate)
# 3- next only keep (year, month, day, dep_time, carrier, flight, speed)
# 4- Finally sort or arrange them according to speed.

# approach 1
flights1 <- filter(flights, dest == "AUs")
flights1 <- filter(flights, dest == "AUS")

flights2 <- mutate(flights1, speed = (distance / air_time) *60)

flights3 <- select(flights2,  year, month, day, dep_time, carrier, flight, speed)

final_flights_AUS <- arrange(flights3, speed)
# to put the fastes at the top
final_flights_AUS <- arrange(flights3, desc(speed))

# Approach 2 uisng teh PIPE for teh same question
final_aus <- flights |> filter(dest == "AUS") |> 
          mutate(speed = (distance / air_time) *60) |> 
          select(year, month, day, dep_time, carrier, flight, speed) |> 
         arrange( desc(speed))

# let's go back to GDP data
# we want only north american counties with high income levels

High.Income.NorthAm <- GDP |> 
  filter(IncomeGroup == "High income" &  Region == "North America")

# only South Asian and East Asia and Pacific countries
SA.EA.P.Countries <- GDP |>
  filter(Region == "South Asia" | Region == "East Asia & Pacific")


# Data Wrangling May 28 ------
# instead of repeating Region over and over we us eteh following approach
GDP |> filter(Region %in% c("South Asia" , "East Asia & Pacific"))

# keep only rows for "Latin America & Caribbean" and NOT high income
Latin.NotHigh.Income <-
  GDP |> filter(Region == "Latin America & Caribbean" ,
                IncomeGroup != "High income")

#Latin america and Caribbean countries with A growth rate equal or more than 5% in 2020

Latin.Growth5plus <- GDP |> filter(Region == "Latin America & Caribbean" , 
                                   x2020 > 5)

Latin.Growth5plus <- GDP |> filter(Region == "Latin America & Caribbean" , 
                                   X2020 > 5)

# What if we want to keep only more recent years of data?
# try to keep only X2020
 gdp2020 <- GDP |> select(X2020)
 # if I did not want to use piping for this case
 z <- select(GDP, X2020)

 # older version of pipe %>%
 GDP  %>% filter(Region == "Latin America & Caribbean") %>% 
   filter(IncomeGroup == "Upper middle income") %>%
   filter(X2020 < -10) 

 # using ViewPipeSteps addins. First you need to install ViewPipeSteps
 # then select you code that includes Piping and then select Addins from the menu bar
 # above, 

# another example of using pipe
 GDP |> filter(Region == "Latin America & Caribbean") |> 
   filter(IncomeGroup == "Upper middle income") 
          |> 
    filter(X2020 < -10)
# produced incorrect number of observations
 GDP |> filter(Region == "Latin America & Caribbean") |> 
   filter(IncomeGroup == "Upper middle income") 
 |> filter(X2020 < -10)

 # we have to put pipe at the end of each line not the bergining of the next line, it will not work
 GDP |> filter(Region == "Latin America & Caribbean") |> 
   filter(IncomeGroup == "Upper middle income") |> 
  filter(X2020 < -10)

 # keep only a few of the variables from GDP
 gdp.some.Vars <-
   GDP |> select(Country.Code, Indicator.Name, Region, IncomeGroup, X2010:X2016)
 
 # remember that SELECT() works for Columns unlike filter(), which was for rows

 # what if we want to change the order of variables in data, e.g. we want to have
 region.first <-
   gdp.some.Vars |> select(c(Region, IncomeGroup, everything()))

 # Sometimes it is easier to NOT SELECT a few columns 
 # and keep the rest
 # for example in GDP we do not want to have Region and Country Code
 
 No.region.no.code <- GDP |> 
                      select(!c(Region, Country.Code))

 # instead of ! we could use - as well 
 No.region.no.code <- GDP |> 
                      select(-c(Region, Country.Code))

# what are teh names of teh variables in teh dataset?
names(GDP) 

# Calculate the average growth rate from 2015 to 2016 and
# add it to the dataset, call this new variable AV
  GDP |> mutate(AV = (X2015 + X2016)/2)
 # if you want to add it to GDP for future use you have to assign it
GDP <-  GDP |> mutate(AV = (X2015 + X2016)/2)

# another approach
GDP$AV1 <- (GDP$X2015 + GDP$X2016)/2

# a few more info about the Select function
only.cols <- gdp.some.Vars |> select(Country.Code, starts_with("X20"))

# select(contains("X20"))
# select(ends_with("xyz"))
# select(where(is.numeric))

# what was the average growth rate of world in 2020?
mean(GDP$X2020)  # this did not work because we have missing observations in year 2020
# we can check to see if any obs is missing using the folloiwng 
is.na(GDP$X2020)

# how many missing observation do we have for X2020?
sum(is.na(GDP$X2020))

# now that we know 40 countries have missing observation
mean(GDP$X2020, na.rm = TRUE)

# Let's meet janitor
# install teh package called janitor
library(janitor)
GDP <- clean_names(GDP)

# Let's read some data from internet and create some graphs
data.from.internet <-
  read.csv(
    "https://raw.githubusercontent.com/plotly/datasets/master/flightdata.csv",
    stringsAsFactors = FALSE
  )

# let's use plotly to create a graph
library(plotly)
# two different approaches
plot1 <-
  ggplot(data.from.internet, aes(y = carrier, x = dest, colour = dest)) +
  geom_count(alpha = 0.9) +
  labs(title = "Flights from New York to major domestic destinations",
       x = "Origin and destination",
       y = "Airline")

ggplotly(plot1)

# second approach using the plotly itself
plot_ly(data.from.internet,
        x= ~dest,
        y = ~carrier,
        color = ~ dest  )
# Another graph to see teh relationships between pairs of variables
# let's use teh IRIS data and teh package called GGALLY
library(GGally)
plot2 <- ggpairs(iris, aes(color = Species))

ggplotly(plot2)

# https://rpubs.com/blscottnz/data_cleaning_and_viz


# to put several plots next to each other use gridExtra or Patchworks
# example
p1 <- ggplot(mtcars) + 
  geom_point(aes(mpg, disp)) + 
  ggtitle('First Plot')

p2 <- ggplot(mtcars) + 
  geom_boxplot(aes(gear, disp, group = gear)) + 
  ggtitle('Second Plot')

# if I want to put p1 and p2 side by side I need a package gridExtra
library(gridExtra)
grid.arrange(p1, p2, ncol = 2)
# what if I wanted to have them p2 below p1
grid.arrange(p1, p2, ncol = 1)

# google  patchworks yourself
