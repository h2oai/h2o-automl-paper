# Load and prep Airlines data
load_train_test <- function(train_size = 100000, test_size = 100000, classification = TRUE) {
  
  cat("Loading Airlines Departure Delay data...\n")
  
  train_path <- here("data", "airlines", sprintf("airlines_train_%.0f.csv", train_size))
  test_path <- here("data", "airlines", sprintf("airlines_test_%.0f.csv", test_size))
  train <- h2o.importFile(train_path)
  test <- h2o.importFile(test_path)
  if (classification) {
    y <- "IsDepDelayed"
    x <- setdiff(names(train), c(y, "DepDelay"))
  } else {
    y <- "DepDelay"
    x <- setdiff(names(train), c(y, "IsDepDelayed"))
  }
  
  return(list(y = y, x = x, train = train, test = test))
}
