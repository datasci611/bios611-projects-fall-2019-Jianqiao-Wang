## Project 3

Jianqiao Wang

#### Background

Urban Ministries of Durham helps homeless people by providing neighbors with emergency shelter and case management to help them overcome barriers such as unemployment, medical and mental health problems, past criminal convictions and addiction.

#### Data

This dataset is from the shelter side of UMD. It includes a lot of data about clients upon entry to and exit from the shelter, including age, gender, race, mental health, income, insurance, and many other variables spread across many tables. Specifically, we are interested in clients demographics.

| Covariate     | Value                                                        |
| ------------- | :----------------------------------------------------------- |
| Race          | American Indian or Alaska Native, White, Asian, Native Hawaiian or Other Pacific Islander, Black or African American |
| Ethnicity     | Non-Hispanic/Non-Latino, Hispanic/Latino                     |
| VeteranStatus | No, Yes                                                      |
| Gender        | Female, Male, Trans Female (MTF or Male to Female)           |

#### Goals

The main purpose of this project is to test whether client demographics have an effect on their length of stay in UMD. Specifically, we are interested in the effects of age, gender, race, ethnicity and veteran status. 

#### Make

All codes and scripts are in directory **scripts/** . One could use **scp** to upload **scripts/** to VCL. After that, one only need to run

```
make
```

on the command line to obtain project 3 report: **project_3.html**. 

#### Tools

* **Docker**: Build useful images on VCL, such as Python and R.
* **Python**: Data wrangling and regression analysis.
* **R**: Useful plots and Rmarkdown.
* **Makefile**: Wrap up every file for project 3.



