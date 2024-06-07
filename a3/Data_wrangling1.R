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




