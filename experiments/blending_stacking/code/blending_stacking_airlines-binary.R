#!/usr/bin/env Rscript

experiment_name <- "blending_stacking"
dataset_name <- "airlines"

suppressMessages(library(R.utils))
library(here)
library(h2o)

# Load utils
source(here("utils", "automl_saveload.R"))
source(here("data", "airlines", "load_train_test.R"))

# Parse args
args <- commandArgs(trailingOnly = TRUE, asValues = TRUE)
machine <- ifelse(is.null(args$machine), "unknown", args$machine)
max_mem_size <- ifelse(is.null(args$max_mem_size), "AUTO", args$max_mem_size)
train_size <- ifelse(is.null(args$train_size), 10000, as.integer(args$train_size))
max_runtime_secs <- ifelse(is.null(args$max_runtime_secs), 3600, as.integer(args$max_runtime_secs))

cat("Using arguments:\n")
cat("machine:", machine, "\n")
cat("max_mem_size:", max_mem_size, "\n")
cat("train_size:", train_size, "\n")
cat("max_runtime_secs:", max_runtime_secs, "\n")

# Environment
if (max_mem_size == "AUTO") {
  if (machine == "h2oai-dl18") {  # 40 CPU, 102G RAM, 1 GPU
    max_mem_size <- "50G"
  } else if (machine == "g4dn.8xlarge") {  # 32 CPU, 128G RAM, 1 GPU
    max_mem_size <- "70G"
  } else if (machine == "c5.metal") {  # 96 CPU, 192G RAM, no GPU
    max_mem_size <- "96G"
  } else if (machine == "m5.2xlarge") {  # 8 CPU, 32G RAM, no GPU
    max_mem_size <- "16G"
  } else {
    max_mem_size <- NULL
  }  
}
min_mem_size <- max_mem_size

# Project name
project_prefix <- paste(dataset_name, train_size, max_runtime_secs, sep = "_")
h2o_version <- packageVersion("h2o")

# Make project & leaderboard directories
h2o_version <- packageVersion("h2o")
automl_projects_path <- here("experiments", experiment_name, "automl_projects", h2o_version, machine)
lb_path <- here("experiments", experiment_name, "leaderboards", h2o_version, machine)
dir.create(automl_projects_path, showWarnings = FALSE, recursive = TRUE)
dir.create(lb_path, showWarnings = FALSE, recursive = TRUE)



# Start H2O
h2o.init(min_mem_size = min_mem_size, max_mem_size = max_mem_size)

# In case there's an H2O cluster already running
h2o.removeAll()

# Load data
cat("Loading data...\n")
dat <- load_train_test(train_size = train_size, classification = TRUE)
# Split off a 10% blending (aka holdout metalearning) frame
splits <- h2o.splitFrame(dat$train, ratios = 0.9, seed = 1)

# Blending 10% (fastest)
cat("Starting H2O AutoML with 10% blending frame...\n")
project_name <- paste(dataset_name, train_size, max_runtime_secs, "blend10pct", sep = "_")
aml <- h2o.automl(y = dat$y, x = dat$x,
                  training_frame = splits[[1]],
                  blending_frame = splits[[2]],
                  leaderboard_frame = dat$test,
                  nfolds = 0,
                  project_name = project_name,
                  max_runtime_secs = max_runtime_secs,
                  seed = 1)
cat(paste0("Total AutoML runtime (secs): ", aml@training_info$duration_secs, "\n"))
print(aml@leaderboard)
aml_path <- paste0(automl_projects_path, "/", aml@project_name)
h2o.save_automl(aml, aml_path, force = TRUE)
lb <- h2o.get_leaderboard(aml, extra_columns = "ALL")
print(lb, n = nrow(lb))
h2o.exportFile(lb, path = paste0(lb_path, "/", project_name, ".csv"), force = TRUE)

rm(aml)
h2o.shutdown(prompt = FALSE)
Sys.sleep(10)