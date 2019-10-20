library(tidyverse)
library(mclust)
library(lubridate)
library(anomalize)

# ---Background---
umd_description = "Urban Ministries of Durham (UMD) is a program that helps homeless people by providing neighbors with emergency shelter and case management to help them overcome barriers such as unemployment, medical and mental health problems, past criminal convictions and addiction."
data_description = "The data provided by UMD recorded different kinds of support that UMD provided for homeless people from 1931. It has more than 10 variables including date, family identifiers, financial support, etc."



# ---Purpose of Analysis---
purpose = c("What is the trend of Number of People Receiving Food Every Day over Time?",
            "What is the trend of Food Pounds UMD Provided Every Day over Time?",
            "What is the trend of Clothing Items UMD Provided Every Day over Time?",
            "How many food pounds does UMD provide for one person? Is there a difference among different families and people?")



# ---Data Preprocessing---
# Load UMD data
# Select Date, Food.Provided.for, Food.Pounds and Clothing.Item columns
# Rename columns
umd_df = read.csv('data/UMD_Services_Provided_20190719.tsv', sep = '\t', header = TRUE)
umd_df = select(umd_df, c(Date, Food.Provided.for, Food.Pounds, Clothing.Items))
names(umd_df) = c("Date", "Number of People Receiving Food", "Food Pounds", "Clothing Items")

# Formulate Date columns with as.Date
umd_df$Date = as.Date(umd_df$Date, "%m/%d/%Y")

# Sort data by Date
umd_df = umd_df %>% 
  arrange(Date) %>%
  mutate(year=year(Date)) # extract year from Date variable

# Remove data points after 2020 and data points before 2000
umd_df = umd_df %>%
  filter(Date < as.Date('2019-09-24'), Date > as.Date('2000-01-01'))

# IQR method to find outliers
outliers <- function(x) {
  lowerq = quantile(x)[2]
  upperq = quantile(x)[4]
  iqr = upperq - lowerq
  upper = (iqr * 1.5) + upperq
  lower = lowerq - (iqr * 1.5)
  return(c(upper, lower))
}




# ---Question 1-3: trend of different variables against time---
# Plot the trend of a type of help over time
trend <- function(variable){
  # aggregate value target variable by Date.
  trend_df = umd_df %>%
    select(Date, matches(variable)) %>%
    drop_na() %>%
    group_by(Date) %>%
    summarise(total=sum(get(variable)))
  
  # find outliers
  outlier_bound = outliers(trend_df$total)
  
  # remove outliers
  trend_df = trend_df %>%
    filter(total < outlier_bound[1], total > outlier_bound[2])
  
  # plot the trend of variable over time
  p <- ggplot(trend_df, aes(x=Date, y=total)) +
    geom_point(size=0.2) +
    geom_smooth() +
    labs(x='Time',
         y=paste(variable, 'Every Day'),
         title=paste(variable, 'Every Day over Time')) +
    theme(plot.title = element_text(hjust = 0.5))
  return(p)
}

# Trend plot interpretation
trend_interpretation = tibble(`Number of People Receiving Food` = c("Number of People Receiving Food Every Day increases during 2005 and 2017, which is attributable to UMD’s great work.", 
                                                              "The growth slowed down during 2010 and 2013, which indicates that UMD is ending some people’s homelessness.", 
                                                              "Number of People Receiving Every Day starts to decrease after 2017, which indicates that UMD has ended many people’s homelessness since 2017."),
                              `Food Pounds` = c("Food Pounds UMD Provided Every Day generally increase during 2006 and 2017.",
                                                "Food Pounds UMD Provided Every Day decrease during 2011 and 2013, which indicates that UMD is ending some people’s homelessness.",
                                                "Food Pounds UMD Provided Every Day decrease after 2017, which indicates that UMD has ended many people’s homelessness since 2017."),
                              `Clothing Items` = c("Clothing Items UMD Provided Every Day increase during 2002 and 2010.",
                                                   "Clothing Items UMD Provided Every Day is a convex function of Time during 2011 and 2015.",
                                                   "Clothing Items UMD Provided Every Day start to decrease after 2015, which indicates that UMD has ended many people’s homelessness since 2015"))



# ---Question 4: Average Food Pounds per person---
# Extract food data, including Number of People Receiving and Food Pounds
# Remove outliers
food_data = umd_df %>%
  select(`Number of People Receiving Food`, `Food Pounds`) %>%
  drop_na() %>%
  filter(`Food Pounds` < 100, `Number of People Receiving Food` < 60)

# Fit EM clustering algorithm
# Divide data points into 2 clusters by Food.Provided.for and Food.Pounds
set.seed(435)
fit = food_data %>%
  Mclust(G=2)

# Assign each data points with estimated cluster
food_data$Group = as.factor(fit$classification)
food_data$uncertainty = fit$uncertainty

# Figure 4: Average Food Pounds per person colored by cluster
average_food_plot <- ggplot(food_data, aes(x=`Number of People Receiving Food`, y=`Food Pounds`, color=Group, group=Group)) +
                  geom_point(size=1.5) +
                  geom_smooth(method='lm', se=FALSE, formula=y~x-1) +
                  labs(x='Number of People Receiving Food',
                       y='Food Pounds',
                       title='Food Pounds against Number of People Receiving Food') +
                  theme_minimal() +
                  theme(plot.title = element_text(hjust = 0.5))

# Fit data with simple linear model without intercept by group
model = list()
model$one = lm(`Food Pounds`~`Number of People Receiving Food`-1, filter(food_data, Group==1))
model$two = lm(`Food Pounds`~`Number of People Receiving Food`-1, filter(food_data, Group==2))

# Figure 4 interpretation
average_food_interpretation = c("There are two groups of data points in this plot: one with big derivative and the other with small derivative.",
                                "Derivative can be seen as estimated Average Food Pounds per person.",
                                "EM algorithm appropriately divides the data into two groups as expected.",
                                "Simple linear model without intercept has a good fit of two groups.",
                                "For Group 1, UMD provides 8.45 pounds of food for each person.",
                                "For Group 2, UMD provided 0.62 pounds of food for each person.",
                                "A big difference in Average Food Pounds per Person exists between these two groups!")
# calculator interpretation
calculator = "Here is a calculator to estimate pounds of food UMD should provided for certain number of people in different groups:"
