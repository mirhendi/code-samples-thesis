#Salam
#Initialization
closeAllConnections()
rm(list=ls())
setwd("~/Documents/Thesis/Codes/GLRM")
set.seed(45394338)
library(h2o)
h2o.init(nthreads = -1, min_mem_size = "8G")
source("GLRM_model.R")
source("GLRM_error.R")

# Load Data
data = (readRDS("clean_data.rds"))



# Define loss function
loss_type = vector('character')
loss_type_idx = vector('integer')
set_loss <- function(col_name, col_type) {
  loss_type_idx <<- c(loss_type_idx, (which(colnames(data) == col_name)-1))  # Because it's zero indexed
  loss_type <<- c(loss_type, col_type)
}

# Categorize data
categorical_cols = c(1, 11, 18, 20:21, 52:146)
for (i in categorical_cols){
  data[, i] = as.factor(data[, i])
}

set_loss ("Medication_new", "Ordinal")
set_loss ("Urinalysis_new", "Ordinal")
set_loss ("Glucose_Monitoring_new", "Ordinal")
set_loss ("Health_Rating_categorical", "Ordinal")
set_loss ("Diabetes_Rating_categorical", "Ordinal")

# Set binary loss function 
binary_cols = c(2:4, 12, 15:17, 19, 22, 25, 27, 147, 28:51, 148:436)
for (i in binary_cols){
  set_loss (colnames(data[i]), "Logistic")
}

num_cols = c(5:10, 26, 13:14, 23:24)
cat_cols =  1:length(data)
cat_cols = cat_cols[-c(num_cols)]

#########################################################
#Set Parameters
nfolds = 1 # No. of folds
gamma = -1
omega = 0
rank = 65
all_data = as.h2o(data)

cv_data = list(); # List of CV data
cv_data[[1]] <- as.h2o(data)

# Build GLRM model
if (gamma == -1) {
  regularization_x_var = "None"
  gamma_value = 0
} else {
  regularization_x_var = "UnitOneSparse"
  gamma_value = gamma
}

glrm.model = list()
model.x = list()
model.y = list()
estimated_model = list()
error_table = matrix (nrow = nfolds, ncol = 8)
colnames(error_table) <- c("Rank_K","Gamma_X", "Omega", "Fold_No", "Train MSE", "Train MCR", "Test MSE", "Test MCR")


model_no = 0
for (fold_no in 1:nfolds){
  model_no = model_no + 1
  glrm.model[[model_no]] = h2o.glrm(training_frame = cv_data[[fold_no]], 
                                    k = rank, transform ="NONE", 
                                    loss = "Quadratic", multi_loss = "Categorical", 
                                    loss_by_col = loss_type, loss_by_col_idx = loss_type_idx, 
                                    regularization_x = regularization_x_var, regularization_y = "None",
                                    gamma_x = gamma_value, gamma_y = 0,
                                    #min_step_size = 0.000001,
                                    #init_step_size = 50,
                                    init = "SVD", 
                                    #svd_method = "Power",
                                    max_iterations = 1500, 
                                    max_updates = 3000,
                                    ignore_const_cols = FALSE,
                                    seed = 45394338
  )
  plot(glrm.model[[model_no]])
  print(paste("Generating model", model_no, "completed!"))
  
  model.y[[model_no]] = glrm.model[[model_no]]@model$archetypes
  model.x[[model_no]] = (h2o.getFrame(glrm.model[[model_no]]@model$ representation_name))
  estimated_model[[model_no]] = predict(glrm.model[[model_no]], cv_data[[fold_no]])
  print(paste("Predicting model", model_no, "completed!"))
  
  error_table[model_no, "Rank_K"] = rank
  error_table[model_no, "Gamma_X"] = gamma
  error_table[model_no, "Omega"] = omega
  error_table[model_no, "Fold_No"] = fold_no
  
  model_data = estimated_model[[model_no]]
  
  eval_data = cv_data[[fold_no]]
  error = calc_GLRM_error(model_data, eval_data)
  error_table[model_no, "Train MSE"] = error [[1]]
  error_table[model_no, "Train MCR"] = error [[2]]
  
  eval_data = all_data
  error = calc_GLRM_error(model_data, eval_data)
  error_table[model_no, "Test MSE"] = error [[1]]
  error_table[model_no, "Test MCR"] = error [[2]]
  
  print(error_table)
  print("Calculating error compelted")
  print(Sys.time())
}

write.csv(as.data.frame(model.x[[1]]), file = "glrm_model_x.csv", row.names=FALSE)
h2o.shutdown()




