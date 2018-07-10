calc_GLRM_error <- function(model_data, eval_data) {
  
  model_data = as.data.frame(model_data)
  eval_data = as.data.frame(eval_data)
  
  MCE = 0
  SE = 0
  num_cnt = 0
  cat_cnt = 0
  
  for (i in 1: dim(eval_data)[2]){
    if (i %in% cat_cols){
      for (j in 1: dim(eval_data)[1]){
        if(!is.na(eval_data[i,j])){
          if (as.numeric(eval_data[i,j]) != as.numeric(model_data[i,j])){
            MCE = MCE + 1
          } 
          cat_cnt = cat_cnt +1
        }
      }  
    } else if (i %in% num_cols) {
      for (j in 1: dim(eval_data)[1]){
        if(!is.na(eval_data[i,j])){
          SE = (as.numeric(eval_data[i,j]) - as.numeric(model_data[i,j]))^2 + SE
          num_cnt = num_cnt +1
        }
      }  
    }
  }
  
  MSE = SE/num_cnt
  MCR = MCE/cat_cnt
  return (list(MSE = MSE, MCR = MCR))
}

  