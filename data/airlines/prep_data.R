#!/usr/bin/env Rscript

library(h2o)

h2o.init(max_mem_size = "50G")

# Airlines Departure Delay Data
# original data can be found at http://www.transtats.bts.gov/
# more info here (though this only goes to 2008): http://stat-computing.org/dataexpo/2009/the-data.html
# we further process a version hosted on H2O S3 to forumulate a version of the data with 
# features to predict both departure delay in seconds, and encoded as a binary response (YES/NO) 
airlines_url <- "https://h2o-airlines-unpacked.s3.amazonaws.com/allyears.1987.2013.csv"
skipped_columns <- c(1, 5, 7, 10, 11, 12, 13, 14, 15, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30)
cat("Import data from S3...\n")
data <- h2o.importFile(airlines_url, skipped_columns = skipped_columns)
reordered_cols <- c("IsDepDelayed", "DepDelay", "Month", "DayofMonth", "DayOfWeek", "CRSDepTime", "CRSArrTime", "UniqueCarrier", "Origin", "Dest", "Distance")
data2 <- data[data$DepDelay!=NaN, reordered_cols]
# if you want a clean full version, save this
#h2o.exportFile(data2, path = "airlines_1987-2013_departuredelay.csv")

# make subsets for training and testing
set.seed(1)
row_ids <- sample(1:nrow(data2), size = nrow(data2))

# make train sets
#train_10k <- data2[sort(row_ids[1:10000]), reordered_cols]
#train_100k <- data2[sort(row_ids[1:100000]), reordered_cols]
#train_1M <- data2[sort(row_ids[1:1000000]), reordered_cols]
#train_10M <- data2[sort(row_ids[1:10000000]), reordered_cols]
#train_100M <- data2[sort(row_ids[1:100000000]), reordered_cols]

# last 100k is test set
n <- nrow(data2)
test_100k <- data2[sort(row_ids[seq(n-99999, n, 1)]), reordered_cols]

cat("Save train and test files...\n")
cat("Exporting airlines_train_10000.csv...\n")
#h2o.exportFile(train_10k, path = "airlines_train_10000.csv")
cat("Exporting airlines_train_100000.csv...\n")
#h2o.exportFile(train_100k, path = "airlines_train_100000.csv")
cat("Exporting airlines_train_1000000.csv...\n")
#h2o.exportFile(train_1M, path = "airlines_train_1000000.csv")
cat("Exporting airlines_train_10000000.csv...\n")
#h2o.exportFile(train_10M, path = "airlines_train_10000000.csv")
cat("Exporting airlines_train_100000000.csv...\n")
#h2o.exportFile(train_100M, path = "airlines_train_100000000.csv")
cat("Exporting airlines_test_100000.csv...\n")
h2o.exportFile(test_100k, path = "airlines_test_100000.csv")

