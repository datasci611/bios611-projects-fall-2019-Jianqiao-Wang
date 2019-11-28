install.packages('reticulate', repo="http://cran.us.r-project.org")
library(reticulate)
rmarkdown::render("~/project_3/results/project_3.Rmd", "html_document")