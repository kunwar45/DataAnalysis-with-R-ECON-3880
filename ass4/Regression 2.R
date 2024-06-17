# Let's learn some regression analysis

# funny cartons about ML
#  https://data-mining.philippe-fournier-viger.com/funny-pictures-about-data-mining-machine-learning/

#   https://devopedia.org/supervised-vs-unsupervised-learning

# Linear regression
# Heiss Ch. 2

library(wooldridge)

# read data on CEO's salary (ceosal1) from wooldridge's package and name it CEO
ceo <-  wooldridge::ceosal1

#explore the data
skimr::skim(ceo) 

# Let's estimate the relationship between rate of return and the salary of CEOs

# let's start with a graph
ceo |> ggplot(aes(salary, roe)) +
  geom_point()

# outliers in salary, let's limit that to 3000. HOW? we could also filter teh data first before plotting
ceo |> ggplot(aes(salary, roe)) +
  geom_point() + xlim(0 , 3000)
  

# if we wanted to remove outliers from all our analysis we can use filter to drop them
ceo <- ceo |> filter(salary <= 3000)

# repeat  the graph 
ceo |> ggplot(aes(salary, roe)) +
  geom_point()

# add a trend line to the plot
ceo |> ggplot(aes(salary, roe)) +
  geom_point()+
  geom_smooth()

# it is not linear!
ceo |> ggplot(aes(salary, roe)) +
  geom_point()+
  geom_smooth(method = "lm", se = F) # this fits a linear model

# is it possible to have a better line? For example the red line or green one?
ceo |> ggplot(aes(roe,salary)) +
  geom_point()+
  geom_smooth(method = "lm", se = F) +
  geom_abline(intercept = 500, slope = 5,  color = "red" , size = 1) +
  geom_abline(intercept = 1200, slope = 12, color = "green", size = 2)
# which line to choose? Ordinary least squares (OLS) is going to help

# we use teh squard errors and sum them together for each potential line. next, we select
# a line that has teh minimum sum of squared errors

# Regression using OLS, Salary is called DEpendent variable and roe is called INDEPENDENT variable (or explanatory)
model1 <- lm(salary ~ roe, data = ceo)
# to see teh result of teh estimation
summary(model1)  # residual is the same as errors

# if I write teh results as an equation  salary = 809.646 + 15.802 *roe + error  (technically I must not include error here)


# June 11 -----
#to get the coefficients
model1$coefficients

# to get the slope
model1$coefficients[2]

### show Monte Carlo Simulation example

# section 4.5 of Hanck et al has another very good example of simulation here:
# https://www.econometrics-with-r.org/4.5-tsdotoe.html

# Pollution and house price in Boston 1970 census  ------------------------------

#   https://rpubs.com/ezrasote/housepricing

library(mlbench)
data(BostonHousing)
# let's rename teh dataset to make it shorter
df <- BostonHousing
str(df)

summary(df)

# missing data in the df?
Amelia::missmap(df, col=c('yellow','black'))

#high correlations? this is very important in regression
cor(select(df, -chas))
# let's visualize the correlation
corrplot::corrplot(cor(select(df, -chas)))
corrplot::corrplot(cor(select(df, -chas)), type = c("lower"))

# regression using  Boston housing data
# we want to see teh relationship between the median house value and a few of
# explanatory variables

# how median value of owner-occupied home is related to Crime, Average number of rooms,
# Property tax, Percentage of lower status of the population

# see https://rpubs.com/ezrasote/housepricing   for more details in case interested :)

model.boston <- lm(medv ~ crim + rm + tax + lstat, data = df)
summary(model.boston)

summary(model.boston) |> broom::tidy()

# see section 6.2 of Hanck et al for a very good graphic representation
# the above model that we estimated is called Multi Variable OLS (multivariate OLS)

##### Logistic regression Ch. 11 Hanck et al: 
library(AER)

# we have a data set related to mortgages in this package called HMDA
data(HMDA)
# let's rename that to mortgage
mortgage <- HMDA
summary(mortgage)

# make sure the dependent variable has a correct format
# convert 'deny' to numeric to be able to estimate linear model

mortgage$deny <- as.numeric(mortgage$deny) 

# but i want to have 1 and 0 not 1 and 2
mortgage$deny <- as.numeric(mortgage$deny) - 1

str(mortgage$deny)

plot(mortgage$deny)

# let's compare this with teh Boston housing median house price that we used above
plot(BostonHousing$medv)

#let's run a linear model. 
model.hmda.linear <- lm(deny ~ single + hschool + pirat, data = mortgage)
summary(model.hmda.linear) |> broom::tidy()

# let's see how deny and pirat are linked! let's create a grpah
ggplot(mortgage, aes(pirat, deny)) +
  geom_point() +
  geom_smooth(method = lm) 
# strange that the blue line can have values larger than 1 and lower than 0, while we know deny is 0 or 1 not more than that

# what is teh solution?
# we need to use LOGISTIC regression not a linear model here
# model mortgage application denial
model.logit1 <- glm(deny ~ single + hschool + pirat, data = mortgage,
                    family = "binomial")

summary(model.logit1)
# notice teh names of teh variables, sometimes are not exactly teh same as the name!

# FYI
# the estimated coefficients show the log odds, to get teh Odds Ratio:
exp(model.logit1$coefficients)

# the results can be used to estimate the Predicted Portability of different cases
# usually if teh predicted probability < 0.5 we call it NO (0) and
# if teh predicted probability >= 0.5 we call it YES (1)

# Lots of usage in Machine Learning (Classification)

# to get the confusion matrix
library(regclass)
confusion_matrix(model.logit1)  # this wil help you to see the accuracy of your model

# how can I get %s in this matrix not the absolute values? 
confusion_matrix(model.logit1) |> prop.table(margin = 1)*100
confusion_matrix(model.logit1)[1:2, 1:2] |> prop.table(margin = 1)*100

# FYI: google for False Positive and False Negative

# Now let's add other variables to teh model to see if they improve the model
# lets add mhist 
model.logit2 <- glm(deny ~ single + hschool + pirat + mhist, data = mortgage,
                    family = "binomial")
summary(model.logit2)

#let's add lvrat
model.logit3 <- glm(deny ~ single + hschool + pirat + mhist +lvrat, data = mortgage,
                    family = "binomial")
summary(model.logit3)

# can we put all the results from 3 logistic models in a single table?
# stargazer package
library(stargazer)

stargazer(model.logit1, model.logit2, model.logit3, type = "text")

# if you want to save it 
stargazer(model.logit1, model.logit2, model.logit3, type = "text", 
          title="Regression Results", 
          out = "regression results.txt")

# also you can seve that as HTML
stargazer(model.logit1, model.logit2, model.logit3, type = "html", title="Regression Results", 
          out = "regression results.html")
# you can also get a Latex table

# see here for more info https://libguides.princeton.edu/R-stargazer

# independent variable -> predictor or feature
# dependent variable -> label
# training and test data

# deny ~  .      # this means that use all teh varibales in teh data set except "deny" as 
                  #  teh dependent variables in teh model, so . is teh shorthand for ALL

# reinforcement learning AI














