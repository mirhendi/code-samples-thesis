# Build GLRM model
GLRM_model <- function(omega, gamma, rank) {
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
  
  all_error_table = readRDS("all_error_table.rds")
  all_error_table = rbind(all_error_table, error_table)
  print(all_error_table)
  saveRDS(all_error_table, file = "all_error_table.rds")
  write.csv(all_error_table, file = "all_error_table.csv")
  
  return (glrm.model)
}