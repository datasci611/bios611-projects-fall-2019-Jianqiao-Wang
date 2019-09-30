library(tidyverse)
library(mclust)
library(lubridate)

# ---Data Preprocessing---
# Load UMD data
# Select Date, Food.Provided.for and Food.Pounds columns.
umd_df = read.csv('~/Documents/GitHub/bios611-projects-fall-2019-Jianqiao-Wang/project_1/data/UMD_Services_Provided_20190719.tsv', sep = '\t', header = TRUE)
umd_df = select(umd_df, c(Date, Food.Provided.for, Food.Pounds))

# Formulate Date columns with as.Date
umd_df$Date = as.Date(umd_df$Date, "%m/%d/%Y")

# Remove rows with missing data
# Sort data by Date
umd_df = umd_df %>% 
  drop_na() %>%
  arrange(Date) %>%
  mutate(year=year(Date)) # extract year from Date variable

# Plot the data points to see which data (outliers) should be removed
# Food.Pounds ~ Food.Provided.for
ggplot(umd_df, aes(Food.Provided.for, Food.Pounds)) +
  geom_point(size=0.5) +
  labs(x='Number of People Provided for', y='Food Pounds')


# Food.Provided.for ~ Date
ggplot(umd_df, aes(Date, Food.Provided.for)) + 
  geom_point(size=0.5) + 
  labs(x='Time', 
       y='Number of People Provided for')

# Food.Pounds ~ Date
ggplot(umd_df, aes(Date, Food.Pounds)) + 
  geom_point(size=0.5) + 
  labs(x='Time', 
       y='Food Pounds')

# Remove outliers and data points after 2020
umd_df = umd_df %>%
  filter(Food.Pounds < 100, Food.Provided.for < 60) %>%
  filter(Date < as.Date('2019-09-24'), Date > as.Date('2000-01-01'))




# ---Food Plots over Time---
# Figure 1: Number of People that UMD provided food for Every Day over Time
total_food_provided_for = aggregate(Food.Provided.for~Date, umd_df, sum)
ggplot(number_of_people_every_day, aes(x=Date, y=Food.Provided.for)) + 
  geom_point(size=0.2) + 
  labs(x='Time', 
       y='Number of People Every Day', 
       title='Number of People Every Day over Time') + 
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_smooth()

# Figure 2: Total Food Pounds UMD provided Every Day over Time
total_food_pound = aggregate(Food.Pounds~Date, umd_df, sum)
ggplot(total_food_pound_every_day, aes(x=Date, y=Food.Pounds)) + 
  geom_point(size=0.2) +
  labs(x='Time', 
       y='Total Food Pounds Every Day', 
       title='Total Food Pounds Every Day over Time') + 
  theme(plot.title=element_text(hjust=0.5)) +
  geom_smooth()




# ---Average Food Pounds per person---
# Figure 3: Average Food Pounds per person
ggplot(umd_df, aes(Food.Provided.for, Food.Pounds, color=year)) +
  geom_point(size = 1) + 
  labs(x='Number of People', 
       y='Food Pounds', 
       title='Average Food Pounds per person') +
  theme(plot.title=element_text(hjust=0.5)) +
  them_minimal()

# Fit EM clustering algorithm
# Divide data points into 2 clusters by Food.Provided.for and Food.Pounds
fit = umd_df %>%
  select(c(Food.Provided.for, Food.Pounds)) %>%
  Mclust(G=2)

# Assign each data points with estimated cluster
umd_df$cluster = as.factor(fit$classification)
umd_df$uncertainty = fit$uncertainty

# Figure 4: Average Food Pounds per person colored by cluster
ggplot(umd_df, aes(x=Food.Provided.for, y=Food.Pounds, color=cluster, group=cluster)) +
  geom_point() + 
  geom_smooth(method='lm', se=FALSE, formula=y~x-1) +
  labs(x='Number of People', 
       y='Food Pounds', 
       title='Average Food Pounds per person') + 
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_discrete('Group')

# Fit data with simple linear model without intercept by group
model = list()
model$one = lm(Food.Pounds~Food.Provided.for-1, filter(umd_df, cluster==1))
model$two = lm(Food.Pounds~Food.Provided.for-1, filter(umd_df, cluster==2))

# R square statistic for two linear models
summary(model$one)$r.squared
summary(model$two)$r.squared

# Coefficients of two linear models
model$one$coefficients
model$two$coefficients
