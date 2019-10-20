## Project 2

Jianqiao Wang

#### Background

Urban Ministries of Durham helps homeless people by providing neighbors with emergency shelter and case management to help them overcome barriers such as unemployment, medical and mental health problems, past criminal convictions and addiction.

#### Data

The dataset records different kinds of support that UMDurham provided for homeless people in the last several years. It has more than 10 variables including date, family identifiers, finicial support, etc. Some variables are explained in the following table:

| Date               | Date service was provided                                   |
| ------------------ | :---------------------------------------------------------- |
| Client File Number | Family identifier (individual or family)                    |
| Food Provided for  | Number of people in the family for which food was provided  |
| Financial Support  | Money provided to clients. Service discontinued.            |
| Client File Merge  | Separate files were created for one family and merged later |

#### Goals

Project 2 is an extension of Project 1. The main goals of Project 2 is to answer display answers of the following questions on a dashboard:

- What is the trend of Number of People Receiving Food Every Day over Time?
- What is the trend of Food Pounds UMD Provided Every Day over Time?
- What is the trend of Clothing Items UMD Provided Every Day over Time?
- How many food pounds does UMD provide for one person? Is there a difference among different families and people?

#### Methods of Analysis

Packages ```tidyverse``` and ```ggplot``` is used to process and plot the data. For statistical analysis, **EM Clustering** and **Linear Regression** are used.

#### Results

Link to shiny app: <https://jianqiao-wang.shinyapps.io/project_2/>

To find the trend of specific kind of help over time, we may plot this variable by time to see if it is increasing or decreasing. As for average food pounds per person, linear model will be preferred. The coefficient will be average food pounds.

