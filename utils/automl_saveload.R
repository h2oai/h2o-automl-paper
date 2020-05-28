library(R.utils)
# Note: For saving AutoML objects, if path is NULL (default), 
# then save in pwd with project_name as folder name

.dump_aml_frames <- function(aml, path, force = FALSE) {
  frames <- c(attr(aml@leaderboard, "id"), attr(aml@event_log, "id"))
  frames <- c(frames,
              unlist(sapply(aml@leaderboard$model_id, function(model_id)
                h2o.getModel(model_id)@model$cross_validation_holdout_predictions_frame_id$name)))
  return(Filter(Negate(is.null), lapply(frames, function(frame) {
    tryCatch({ #  If autoML doesn't set keep_cross_validation_predictions, individual models have it set to T but the frames don't exist
      h2o.exportFile(h2o.getFrame(frame), paste0(path, "/frames/", frame), force = force)
      list(name = frame, path = paste0("/frames/", frame))
    }, error=function(e) return(NULL))
  })))
}

.dump_aml_models <- function(aml, path, force = FALSE) {
  return(lapply(aml@leaderboard$model_id, function (model_id) {
    h2o.saveModel(h2o.getModel(model_id), paste0(path, "/models/"), force = force)
    list(name = model_id, path = paste0("/models/", model_id))
  }))
}

h2o.save_automl <- function(aml, path = NULL, force = FALSE) {
  if (is.null(path)) {
    path <- paste0(getwd(), "/", aml@project_name)
  }
  if (file.exists(path)) {
    if (force) {
      warning("File ", path, " already exists.")
    } else {
      stop("File ", path, " already exists.")
    }
  }
  mkdirs(path)
  mkdirs(paste0(path, "/frames"))
  mkdirs(paste0(path, "/models"))
  captureOutput({
    jsonlite::write_json(
      x = list(
        project_name = aml@project_name,
        leader = aml@leader@model_id,
        leaderboard = attr(aml@leaderboard, "id"),
        event_log = attr(aml@event_log, "id"),
        modeling_steps = aml@modeling_steps,
        training_info = aml@training_info,
        aml_frames = .dump_aml_frames(aml, path, force),
        aml_models = .dump_aml_models(aml, path, force)
      ),
      path = paste0(path, "/aml.json"),
      pretty = TRUE,
      auto_unbox = TRUE
    )
  })
  return(path)
}


h2o.load_automl <- function(path) {
  json <- jsonlite::read_json(paste0(path, "/aml.json"))
  captureOutput({
    for (frame in json$aml_frames) {
      h2o.importFile(paste0(path, frame$path), destination_frame = frame$name)
    }
    for (model in json$aml_models) {
      m <- h2o.loadModel(paste0(path, model$path))
      if (model$name != m@model_id) {
        stop("Model loaded under a wrong name. Expected: ",
             model$name,
             " actual: ",
             m@model_id)
      }
    }
  })
  return(
    new(
      "H2OAutoML",
      project_name = json$project_name,
      leader = h2o.getModel(json$leader),
      leaderboard = h2o.getFrame(json$leaderboard),
      event_log = h2o.getFrame(json$event_log),
      modeling_steps = json$modeling_steps,
      training_info = json$training_info
    )
  )
}

# # Test functionality:
# 
# # First run this
# library(h2o)
# h2o.init()
# prostate_path <- system.file("extdata", "prostate.csv", package = "h2o")
# prostate <- h2o.importFile(path = prostate_path, header = TRUE)
# y <- "CAPSULE"
# prostate[,y] <- as.factor(prostate[,y])  #convert to factor for classification
# aml <- h2o.automl(y = y, training_frame = prostate, max_runtime_secs = 30)
# aml_path <- h2o.save_automl(aml, path = NULL)
# h2o.shutdown(prompt = FALSE)
# Sys.sleep(10)
# rm(aml)
# 
# # After shutting down H2O, re-start and load from the path
# library(h2o)
# h2o.init()
# aml <- h2o.load_automl(path = aml_path)
# lb <- aml@leaderboard
# # not currently working
# #lb <- h2o.get_leaderboard(aml)
# #lb <- h2o.get_leaderboard(aml, extra_columns = "ALL")
