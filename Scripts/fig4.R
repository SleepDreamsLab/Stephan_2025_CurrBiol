# =======================================================================
  #  FIG 4 - Sleepiness across Stages Plotting Script
# -----------------------------------------------------------------------
  # Variables:
  #   time = 1:T                     # timepoints
#   sleep_onset = sf;             # time index of sleep → awakening
#   freq_colors = {...};          # length F RGB strings
#   baseline_window = [t1 t2];    # baseline time indices, e.g. [-30 -20] rel. to sf
#   alpha = 0.05;                 # significance level
# =======================================================================
  

rm(list=ls())
gc()

# ------ Loading libraries and custom functions ----------------------------
setwd('/Users/contretemps/Library/CloudStorage/GoogleDrive-aurelie.m.stephan@gmail.com/My Drive/Post-Doc/Insomnia/Analysis/R_scripts/')
packages = c('ggplot2','readxl')  
lapply(packages, require, character.only = TRUE)
source('aggregate_mean_se.R')

# ------ Parameters ----------------------------
save_fig = TRUE

# ------ Read data ----------------------------
path_project = '/Users/contretemps/Library/CloudStorage/GoogleDrive-aurelie.m.stephan@gmail.com/My Drive/Post-Doc/WakingBrain/Paper/current_draft/Accepted/Final_Submission/Git/'
path_figure = paste0(path_project,'Figures/fig4/')
path_data = paste0(path_project,'Data/data_sleepiness.RData')
load(path_data)
filename_figure = 'boxplot_scatter_sleepiness_stage'

# ------ Plot data ----------------------------
color_list <- c('#e33936','#a54ccf','#3076e6') # rouge violet bleu pour n2 n3 rem
agg <- aggregate(Sleepiness ~ Stage + sub, data_sleepiness,mean)
p <- ggplot( agg, aes(x=Stage, y=Sleepiness)) +
  geom_boxplot(aes(fill=Stage), width = .65, alpha = .1,outlier.alpha = 0) +
  geom_point(aes(colour=Stage), size=2.4, alpha=.65, position = position_jitter(w = 0.15, h = 0)) +
  scale_fill_manual(values=color_list) +
  scale_colour_manual(values=color_list) +
  ylim(c(1,6)) +
  ylab('Sleepiness') +
  xlab('Sleep Stage') +
  theme_bw() +
  theme(text = element_text(size=20)) 

if (save_fig){
  ggsave(paste(path_figure, filename_figure, ".png",sep=""),dpi = 300)
}

