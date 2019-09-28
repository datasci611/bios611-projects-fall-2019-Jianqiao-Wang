library(tidyverse)
library(mclust)
library(lubridate)

# Load UMD data and Select variables that is useful
umd_df = read.csv('~/Documents/GitHub/bios611-projects-fall-2019-Jianqiao-Wang/project_1/data/UMD_Services_Provided_20190719.tsv', sep = '\t', header = TRUE)
umd_df = select(umd_df, c(Date, Food.Provided.for, Food.Pounds))

# Formulate Date with as.Date
umd_df$Date = as.Date(umd_df$Date, "%m/%d/%Y")

# Remove rows with missing data and Sort data by Date
umd_df = umd_df %>% 
  drop_na() %>%
  arrange(Date) %>%
  mutate(year=year(Date))

# Plot the data points to see which data should be removed
ggplot(umd_df, aes(Food.Provided.for, Food.Pounds)) +
  geom_point(size=0.5) +
  labs(x='Number of People Provided for', y='Food Pounds')

ggplot(umd_df, aes(Date, Food.Provided.for)) + 
  geom_point(size=0.5) + 
  labs(x='Time', y='Number of People Provided for')

ggplot(umd_df, aes(Date, Food.Pounds)) + 
  geom_point(size=0.5) + 
  labs(x='Time', y='Food Pounds')

# Remove outliers and unreasonable data
umd_df = umd_df %>%
  filter(Food.Pounds < 100, Food.Provided.for < 60) %>%
  filter(Date < as.Date('2019-09-24'), Date > as.Date('2000-01-01'))

# Plot: Total Food Pound in one day ~ Date
total_food_pound = aggregate(Food.Pounds~Date, umd_df, sum)
ggplot(total_food_pound, aes(x=Date, y=Food.Pounds)) + 
  geom_point(size=0.2) +
  labs(x='Time', y='Food Pounds') + 
  geom_smooth()

# Plot: Number of People that UMD Provided food for in one day ~ Date
total_food_provided_for = aggregate(Food.Provided.for~Date, umd_df, sum)
ggplot(total_food_provided_for, aes(x=Date, y=Food.Provided.for)) + 
  geom_point(size=0.2) + 
  labs(x='Time', y='Food Provided for') + 
  geom_smooth()

# Plot: Total Food Pound in one day ~ Number of People that UMD Provided food for in one day
ggplot(umd_df, aes(Food.Provided.for, Food.Pounds, color=year)) +
  geom_point(size=1) + 
  labs(x='Number of People', y='Food Pounds')

# EM clustering, 2 cluster
fit = umd_df %>%
  select(c(Food.Provided.for, Food.Pounds)) %>%
  Mclust(G=2)

umd_df$cluster = as.factor(fit$classification)
umd_df$uncertainty = fit$uncertainty

# Plot: Total Food Pound in one day ~ Number of People that UMD Provided food for in one day
# by cluster with fitted simple linear regression.
ggplot(umd_df, aes(x=Food.Provided.for, y=Food.Pounds, color=cluster, group=cluster)) +
  geom_point() + 
  geom_smooth(method='lm', se=FALSE, formula=y~x-1) +
  labs(x='Number of People', y='Food Pounds') + 
  theme_minimal() +
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
