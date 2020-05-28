#!/bin/bash

R CMD REMOVE h2o
R -e 'install.packages("h2o", type="source", repos="http://h2o-release.s3.amazonaws.com/h2o/rel-zahradnik/3/R")'
R -e 'install.packages(c("here", "R.utils"), repos = c("http://cran.us.r-project.org"))'