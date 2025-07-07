
% =======================================================================
%  FIG 1 - EEG Time-Course Plotting Script
% -----------------------------------------------------------------------
% =======================================================================
clear;clc; 

project_path = '' % put the path to the root directory of this repository
script_path = [project_path 'Scripts\'];
data_path = [project_path 'Data\']; 
fig_path = [project_path 'Figures\'];
addpath(genpath(script_path))

% -- Choose stage, figure (1=awakening, 2 = arousal) and load variables ----------------------------------------
stage = 'NREM';
% stage = 'REM';
% fig = '1';
fig = '2';
load([data_path 'fig' fig '_' stage '.mat'])

% -- Parameters ----------------------------------------
[ nfq, nt ] = size(mean_data);
time = 1:nt;                            % time axis
show_SE      = true;                    % display shaded standard error
save_figures = true;                    % save plotted figures
output_dir   = [fig_path 'fig' fig '/'];      % save folder
sf_index     = 30;            % sleep→awake timepoint index
baseline_idx = 1:10;  % baseline window indices
freq_colors = {'MidnightBlue','DeepSkyBlue','SeaGreen','Gold','Crimson','DarkRed'};
freq_names = {'Delta', 'Theta', 'Alpha', 'Sigma', 'Beta'};
% create folder if needed
if save_figures && ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% -- Loop over frequencies ---------------------------------
for fq = 1:nfq
    % extract and smooth
    y = squeeze(mean_data(fq, :));      % use channel 1
    se = squeeze(sd_data(fq, :));

    % create figure
    figure('Units','normalized','Position',[0.3 0.2 0.4 0.3]);
    hold on;
    xlabel('Time (s relative to awakening)');
    ylabel('Power (norm.)');
    title(freq_names{fq});
    
    % zero-line (reference)
    plot(time, zeros(size(time)), 'Color', [0.6 0.6 0.6], 'LineStyle', '--');

    % shaded error band
    if show_SE
        top = y + se;
        bot = y - se;
        fill([time, fliplr(time)], [top, fliplr(bot)], ...
             rgb(freq_colors{fq}), 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    end

    % main line
    plot(time, y, 'Color', rgb(freq_colors{fq}), 'LineWidth', 2);

    % mark sleep-onset line
    yl = ylim; plot([sf_index sf_index], yl, 'k-', 'LineWidth', 2);

    % adjust x-axis to center on sleep-onset
    x_ticks = get(gca, 'XTick');
    set(gca, 'XTickLabel', x_ticks - sf_index);
    xlim([1 nt]);
    
    % save figure
    if save_figures
        print(gcf, [output_dir, stage '_' freq_names{fq}], '-depsc2');
        close;
    end
end

% =======================================================================





