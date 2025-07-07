% =======================================================================
%  FIG 5 - Sleepiness Generalized Models Plotting Script
% -----------------------------------------------------------------------
% =======================================================================
clear;clc;

project_path = '\\vs03\VS03-SandD-2\NEW\WakingBrain\Publication\'; % insert the path root path containing code, data and figures dir
script_path = [project_path 'Scripts\'];
data_path = [project_path 'Data\fig5\']; % To adapt
fig_path = [project_path 'Figures\'];

cd([script_path 'func/stuff_4_sm'])
addpath(genpath(script_path))
load('NeighborMatrix_Sources_2447_Full.mat');
chanlocs2447 = NeighMat; clear NeighMat;

% -- Parameters ----------------------------------------
% time_section = 'sleep_30s';
time_section = 'awakening_20s';
var = 1; % only plot the effect of psd and not covariates
sig = 0.05;
sig_str = strrep(num2str(sig),'.','_');
stat_range = [-4 4];
save_figures = true; 
output_dir   = [fig_path 'fig5/'];      % save folder
if save_figures && ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% -- Plot corrected generalized models ----------------------------------------
files = get_file_list([data_path time_section '\']);

for f = 1:length(files) % model files
    disp(files{f})

    % read generalized models excel tables
    rstats = readtable([data_path time_section '\' files{f}]);
    rstats_col = rstats.Properties.VariableNames;

    var_str = rstats_col(1,contains(rstats_col,'z'))';
    if var==1; n_var = 1;else;n_var = length(find(contains(rstats_col,'z')));end
    var_idx = 1:n_var;
    zvals = table2array(rstats(:,contains(rstats_col,'z')));
    beta_pvals = table2array(rstats(:,contains(rstats_col,'_P')));

    for i = 1:n_var
        v = var_idx(i);
        var2plot=zvals(:,v);
        markers1=find(beta_pvals(:,v) < sig);
        data = zeros(2447,1);
        data(markers1)=1;
        results=var2plot;
        results=results.*data;
        results(results==0)=NaN;

        title_str = var_str{v,:}(1:end-5);
        title_str(title_str==':')='x';
        filename = [files{f}(1:end-5) '_' title_str '_' sig_str];
        plot_inflated_map(results,stat_range(1),stat_range(2),'stat-inv');

        if save_figures
            print([output_dir filename],'-depsc2');
        end

        clear markers1 var2plot temp savefile
        close
    end
    clear  rstats
end 




