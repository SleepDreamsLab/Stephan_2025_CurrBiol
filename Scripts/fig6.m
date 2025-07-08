% =======================================================================
%  FIG 6 - Slow Waves Upon Awakening Plotting Script
% -----------------------------------------------------------------------
% =======================================================================
clear;clc;

project_path = ''; % insert the path root path containing code, data and figures dir
script_path = [project_path 'Scripts\'];
data_path = [project_path 'Data\']; % To adapt
fig_path = [project_path 'Figures\'];
addpath(genpath(script_path))
load([script_path 'func\stuff_4_topo\insidech.mat'])
load([script_path 'func\stuff_4_topo\NeighMat185.mat'])
load([script_path 'func\stuff_4_topo\chanlocs.mat'])
load([data_path 'fig6.mat'])


% -- Parameters ----------------------------------------
save_figures = true; 
output_dir   = [fig_path 'fig6/'];      % save folder
if save_figures && ~exist(output_dir, 'dir')
    mkdir(output_dir);
end
stages = {'NREM'};
sw_parameters = {'maxnegpkamp', 'density', 'mxdnslp', 'mxupslp', 'negpks'}';
comparison_pairs = {
    't_5sec',         't_45sec_30sec';
    't_30sec_5sec',   't_45sec_30sec'
};
colormap_vals = fliplr(brewermap(100, 'RdBu')')';
map_limits = [-4 4];
colorbar_option = 'without';   % 'with' or 'without'
n_permutations = 1000;
significance_threshold = 0.05;


% -- Main loop ----------------------------------------
for stage_idx = 1:length(stages)
    stage = stages{stage_idx};

    for param_idx = 1:length(sw_parameters)
        sw_param = sw_parameters{param_idx};
        time_labels = fieldnames(sw_bl.(stage).(sw_param));

        for comp_idx = 1:size(comparison_pairs, 1)
            cond1_label = comparison_pairs{comp_idx, 1};
            cond2_label = comparison_pairs{comp_idx, 2};

            % Retrieve data for both conditions
            cond1_data = sw_bl.(stage).(sw_param).(cond1_label)';
            cond2_data = sw_bl.(stage).(sw_param).(cond2_label)';

            % Run cluster-based permutation test
            results = nppt_test_parcc(cond1_data(:, insidech), ...
                                      cond2_data(:, insidech), ...
                                      'Paired', NeighMat, ...
                                      n_permutations, ...
                                      'both', ...
                                      significance_threshold, ...
                                      significance_threshold);

            % Extract t-values and significance
            t_values = results.t_real;
            t_values(~isfinite(t_values)) = NaN;
            significant_channels = find(results.h_real_cc);

            % Skip if data is empty or all NaN
            if all(isnan(t_values))
                continue;
            end

            % === Plot Topography ===
            figure;
            topoplot(t_values, chanlocs(1, insidech), ...
                'colormap', colormap_vals, ...
                'plotrad', 0.62, ...
                'headrad', 0.6, ...
                'maplimits', map_limits, ...
                'emarker2', {significant_channels, '.', [0.9 0.9 0.9], 20, 1});

            if strcmp(colorbar_option, 'with')
                colorbar;
            end

            % === Save Figure ===
            if save_figures
                limits_str = strrep(num2str(map_limits), ' ', '_');
                fig_name = sprintf('%s_%s_%s_vs_%s_%s_%scolorbar', ...
                    stage, sw_param, cond1_label, cond2_label, ...
                    limits_str, colorbar_option);
                print(fullfile(output_dir, fig_name), '-depsc2');
            end
            close;
        end
    end
end





