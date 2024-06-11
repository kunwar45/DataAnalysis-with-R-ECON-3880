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


#  Data Wrangling May 30  -----

# group_by:
diamond <-  ggplot2::diamonds
# we have multiple obs for each CUT.
# if I ask what is teh average price based on cut?
# price for diamonds based on their cut ? Do they linearly linked?

diamond |> group_by(cut) # prepares teh data for next step so we do not see any change

diamond |> group_by(cut) |> 
            summarise(averg.price = mean(price))

# group_by is similar to pivot tables

# how about average price based on color?
diamond |> group_by(color) |> 
  summarise(averg.price = mean(price))

# we conclude : linear link price rises from D to J on average
# average based on cut and color? ANY IDEA or suggestion?
diamond |> group_by(color, cut) |> 
  summarise(averg.price = mean(price))
# plot the average price based on cut and color
# option 1:
cut.color.av.price <-   diamond |> group_by(color, cut) |> 
  summarise(averg.price = mean(price))

ggplot(cut.color.av.price) + 
  geom_point(aes(x = cut,
                 y = color , size = averg.price))

# option 2:
diamond |> group_by(color, cut) |> 
  summarise(averg.price = mean(price)) |> 
  ggplot() +
  geom_point(aes(x = cut,
                 y = color , size = averg.price))

# we can use group_by for any function that we have in R
# not just mean()

# number of observations based on cut
diamond |> group_by(cut) |> 
            summarise(n = n())

# let's copy diamonds data into excel. How?
# here we will copy and paste 

diamond |> clipr::write_clip()

# https://rforpoliticalscience.com/2023/01/15/cleaning-up-messy-world-bank-data/

# let's see how we read an EXCEL file into Rstudio
wdi <- readxl::read_excel("D:/R/Data_Extract_From_WDI.xlsx")
# the above code reads teh info from teh frist Sheet which is teh metadat 
# let's correct that
wdi <- readxl::read_excel("D:/R/Data_Extract_From_WDI.xlsx",
                          sheet = "Data")
# we have 3 empty rows in excel that casues R to read data incorrectly.
wdi <- readxl::read_excel("D:/R/Data_Extract_From_WDI.xlsx",
                          sheet = "Data", skip = 3 )

# let's see the data and see if it is ready for analysis? 1. Names, 2. Missing Values
# names are not that good let's clean them
janitor::clean_names(wdi)
wdi <-  janitor::clean_names(wdi)
# all columns are character!! so we need to convert them into numbers

# lets convert to numeric all the columns except the names. How?

# i can use one by one
wdi$x1960_yr1960 <- as.numeric(wdi$x1960_yr1960)
wdi$x1961_yr1961 <- as.numeric(wdi$x1961_yr1961)

# Let's google: tidyverse convert multiple columns to numeric

wdi <- wdi |> mutate(across("x1960_yr1960":"x2021_yr2021",
                            as.numeric))

# scientific numbers are confusing, we can ask R not to use it
options(scipen = 999)

# this includes many indicators for each country. 
# Let's examine GDP per capita (constant 2015 US$).
per.capita.gdp <- wdi |> 
  filter(series_name == "GDP per capita (constant 2015 US$)")

# let's create some descriptive stats about per capita gdp data
perCapGDP <- psych::describe(per.capita.gdp)

# data from WDI show the website

# data from Statistics Canada (StatCan)

# Data Wrangling June 3 ----
library(statcanR)


statcan_search(c("GDP", "province", "growth"), "eng")
# or can goolge for GDP province statcan and use teh table number from there

Data.from.StatCan <- statcan_download_data("3610040202", "eng")

# explore teh downloaded data. Next focus on CHAINED dollar values for ALL IDUSTRIES.
library(tidyverse)

province.gdp <-
  Data.from.StatCan |> filter(
    Value == "Chained (2017) dollars" &
      `North American Industry Classification System (NAICS)` == "All industries [T001]" 
  )

# how do I know what are the different values for North American Industry Classification System (NAICS)

# we can use a function called unique()

unique(Data.from.StatCan$`North American Industry Classification System (NAICS)`) 
unique(Data.from.StatCan$North American Industry Classification System (NAICS))  # because teh name of teh 
# variable is not a single word we need to use quotation marks

unique(Data.from.StatCan$GEO )
unique(Data.from.StatCan$'GEO' )

# explore meaning of some varaibles such as dguid
# some columns are not needed.  How can I get the names of teh variables (columns) ?

names(province.gdp)
# let's keep only "REF_DATE" , "GEO" , "VALUE"

province.gdp <- province.gdp |> select(c(REF_DATE, GEO, VALUE))

# Do we need to keep month and day in REF_DATE? No so let's remove them
province.gdp$Year <- substr(province.gdp$REF_DATE, 1, 4)
province.gdp$Year <- substr(province.gdp$REF_DATE, 1, 5) # this is just to show how it works

# let's drop ref_date  HOW????
province.gdp$REF_DATE <- NULL
 # we could also use SELECT()
province.gdp <- province.gdp |> select(c(Year, GEO, VALUE))

# but usually we want to see the Year as columns (known as a WIDE data)
# see the graphs here:
# https://tavareshugo.github.io/r-intro-tidyverse-gapminder/09-reshaping/index.html

province.gdp.Wide <-
  province.gdp |> pivot_wider(names_from = Year, values_from = VALUE)

# BC vs AC ?  BEFORE COVID, AFTER COVIS :)

# R does not like a name that starts with a number!
province.gdp.Wide <-
  province.gdp |> pivot_wider(names_from = Year, values_from = VALUE,
                              names_prefix = "year_"  )
# why do we want  a long format for?
# Can we plot the data  and color them differently for P/Ts?
# This is much easier to do using LONG data set
province.gdp |> ggplot() + 
  geom_point(aes(x = Year , y = VALUE , color = GEO) , size = 2)

# Calculate the average GDP for each P/T separately
province.gdp |> group_by(GEO) |> summarize(Average.GDP = mean(VALUE))
# teh above code did not calculate the average for Nunavut becase of missning observation in 1997 and 1998

province.gdp |> group_by(GEO) |> summarize(Average.GDP = mean(VALUE , na.rm = TRUE))
# can we create number of observations, mean and Standard devition at teh same time for each P/T?
province.gdp |> group_by(GEO) |> 
              summarise(number.of.years = n(),
                        average = mean(VALUE , na.rm = TRUE),
                        SD = sd(VALUE , na.rm = TRUE)
                            )

# maybe would have been better to change the name from VALUE to PT.GDP. How?
province.gdp <- province.gdp |> rename(PT.GDP = VALUE) # inside rename (new name = old name)

# or 
province.gdp <- rename(province.gdp, "VALUE2" = "PT.GDP")

# there is another function called pivot_longer() that converts a wide dataset to a longer one.
?pivot_longer

province.gdp.long <- province.gdp.Wide |> 
                    pivot_longer(-GEO, names_to = "date",
                                 values_to = "GDP.values")
# teh first argument in teh pivot_longer means which columns you want to convert from WIDE to LONG
# -GEO means that SELECT all columns except GEO

# I   also could use ! instead of -
province.gdp.long <- province.gdp.Wide |> 
  pivot_longer(!GEO, names_to = "date",
               values_to = "GDP.values")

# another example of group_by using the flights data
# Does delay increase with distance? We have one origin and for each dest we have
# multiple flights so we need to summarize using group_by
flights <- nycflights13::flights

delay.df <- flights |>  group_by(dest) |> summarise(
    count = n(),
     dist = mean(distance, na.rm = TRUE),
     delay = mean(arr_delay, na.rm = TRUE)
      )
# some of the cases have very low number of occurrence so we drop them (n < 20)

delay.df <- delay.df |> filter( count > 20)

# let's create a plot to visualize this delay data
ggplot(delay.df, aes(x = dist, y = delay))+
  geom_point() +
  geom_smooth()

# difficult to see where the relationship changes. make it interactive
library(plotly)
plot1 <-  ggplot(delay.df, aes(x = dist, y = delay))+
  geom_point() +
  geom_smooth() 

ggplotly(plot1)

# It looks like delays increase with distance up to ~650 miles
# and then decrease. Maybe as flights get longer there's more
# ability to make up delays in the air?

ggplot(data = delay.df, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1 / 3) +
  geom_smooth(se = FALSE)

# rewrite the above code using pipes (instead of step by step as we saw above)
flights |> group_by(dest) |>
  summarise(
    count = n(),
    dist = mean(distance, na.rm = T),
    delay = mean(arr_delay, na.rm = T)
  ) |>
  filter(count > 20) |>
  ggplot(mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1 / 3) +
  geom_smooth(se = F)

# sometimes it is better to break the code into several steps to prevent mistakes. For example,
# an example
# how many different airplanes (different tailnum) have been used by DL?
z <- flights |> filter(carrier == "DL")
z |> select(tailnum) |> nrow()
 # the above code gives us teh number of flights not airplanes
z |> select(tailnum) |> unique() |> nrow()

# or 
n_distinct(z$tailnum)

# creating new categorical variable called Long or SHORT Haul
# 1st approach using the same logic as Excel
flights$long.short <- if_else(flights$distance > 4800 , "long_haul", "Not_long_haul")


# 2nd approach: using case_when() also can be used for the same purpose.
flights <- flights |> 
  mutate(flihgt_group = case_when(
    distance <= 1500 ~ "Short" , 
    distance <=4800 ~ "Medium" ,
    distance > 4800 ~ "Long" ))

# to check
unique(flights$flihgt_group)

# how many for each group?
table(flights$flihgt_group)

# do we get the same results using if_else and case_when? use table() to confirm
table(flights$flihgt_group , flights$long.short)

# Data Wrangling June 6 ----
# let's see another cross tabulation functions using diamonds data
table(diamonds$cut, diamonds$color)
prop.table(diamonds$cut, diamonds$color) # generates an error
table(diamonds$cut, diamonds$color) |> prop.table() # this gives proportion out of all observations
table(diamonds$cut, diamonds$color) |> prop.table( margin = 2)

# our objective of cleaning data is to create a TIDY data

# what are the datasets that are imbeded in R
data()
data(package = .packages(all.available = TRUE)) # all data including those from packages

# visually see missing data
titanic <- titanic::titanic_train
Amelia::missmap( titanic, col = c('yellow', 'black'))

# Can we do a calculations for all numeric variables at once? google that
#   https://www.statology.org/dplyr-summarise-multiple-columns/
mean.median.flight1 <- flights |> summarise_if(is.numeric,
                                               funs(n(),
                                                    mean (., na.rm = T) ,
                                                    median (. , na.rm = T)))


# or use across() and Where() which is a newer function
mean.median.flight2 <- flights |> summarise(across(.cols = where(is.numeric),
                                                   .fns = list(n = ~ n(), mean = mean,
                                                               med = median)))

# or simply use skim
library(skimr)
z <- skim(flights)

# Merging 2 data sets
# read Excel files merge1 and merge2

# graph for different types of join
# https://rpubs.com/jcross/joins
# https://jules32.github.io/r-for-excel-users/vlookup.html

file1 <- readxl::read_excel('D:/R/merge1.xlsx')
file2 <- readxl::read_excel('D:/R/merge2.xlsx')
  
merged <- file1 |> left_join(file2 , by = "Country")

# what if the common key between 2 data set have different names? google
# if you want to use BASE R you can use merge() instead of joins

# psych::describe()
psych::describe(diamonds)

psych::describeBy(diamonds , group =  "cut")

# write your own functions
# an example 

x <- 2
y <- x + 10

x <- 25
y <- x + 10

# instead of repeating teh same calculation many times, we can write a function
my.first.function <-  function(x){
  y <-  x + 10
  y
}

# I want to use teh function for x = 2, x= 5, ..
my.first.function(20)

my.first.function(5)
# we could use loop here as well to run the function based on many values for x

# WDI---------------------------------------
library(WDI)

wdi <- WDI(
  country = c("US", "CAN"),
  indicator = "NY.GDP.PCAP.KD",
  start = 2016,
  end = 2020,
  language = "en"
)


# another examples using WDI
# https://worldpoliticsdatalab.org/tutorials/data-wrangling-and-graphing-world-bank-data-in-r-with-the-wdi-package/
# http://svmiller.com/blog/2021/02/gank-world-bank-data-with-wdi-in-r/


# an empirical example 

#  http://lab.rady.ucsd.edu/sawtooth/RAnalytics/visualization.html

# THE END ------------



















