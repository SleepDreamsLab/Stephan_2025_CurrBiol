aggregate_mean_se <- function(formula,data,na_omit){
  
  
  
  agg <- aggregate(formula ,data,mean)
  agg_se <- aggregate(formula,data,se)
  agg$se <- agg_se[,as.character(strsplit(as.character(formula),'~')[2])]
  
  # set appropriate class
  for (element in colnames(agg)) {
    if (is_character(agg[1,element])){
      agg[,element] <- as.factor(agg[,element])
    } else if (is.numeric(agg[1,element])) {
      agg[,element] <- as.numeric(agg[,element])
    }
  }
  
  # na handling
  if (is_true(na_omit)){agg <- na.omit(agg)}
  
  return(agg)
}