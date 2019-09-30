##Project 1

Jianqiao Wang

####Background

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

I'm interested in associations between time and different kinds of support. Did UMDurham provide more help as time goes by? I'm also interested in summary statistics about support this program provided, such as average food pound per person. Moreover, I want to know if there is a difference among different families or people. As for my future analysis, variables such as Date, Food Provided for and Food Pounds will play an important role.

To find the trend of specific kind of help over time, we may plot this variable by time to see if it is increasing or decreasing. As for average food pounds per person, linear model will be preferred. The coefficient will be average food pounds.

