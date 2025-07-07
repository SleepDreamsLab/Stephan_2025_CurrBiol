
% =======================================================================
%  FIG 3 - EEG Time-Course Plotting Script
% -----------------------------------------------------------------------
% =======================================================================
clear;clc;

project_path = '\\vs03\VS03-SandD-2\NEW\WakingBrain\Publication\'; % insert the path root path containing code, data and figures dir
script_path = [project_path 'Scripts\'];
data_path = [project_path 'Data\']; % To adapt
fig_path = [project_path 'Figures\'];

cd([script_path 'func/stuff_4_sm'])
addpath(genpath(script_path))

% -- Choose stage and load variables ----------------------------------------
% stage = 'NREM';
stage = 'REM';
load([data_path 'fig3_' stage '.mat'])

% -- Parameters ----------------------------------------
[nvx, nfq, nt ] = size(rank_data);
save_figures = true;                    % save plotted figures
output_dir   = [fig_path 'fig3/'];      % save folder
freq_names = {'Delta', 'Theta', 'Alpha', 'Sigma', 'Beta'};
if save_figures && ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% -- Process each frequency ----------------------------------------

for fq = 1:nfq
    data2plot = squeeze(nanmedian(rank_data(:,fq,:),3));
    scale = [min(data2plot)+1 max(data2plot)-1];
    plot_inflated_map(data2plot,scale(1),scale(2),'grade');
    set(gcf,'PaperPositionMode','auto');
    if save_figures
    print([output_dir stage '_' freq_names{fq}],'-depsc2');
    end
    close;
end

