function [disp_left,disp_right,IL_resized,IR_resized]  = disparity_estimation(JL, JR, varargin)
%% parse inputs
g = inputParser; 
ValidDispFac = @(x) isnumeric(x) && (x >= 0.0) && (x <= 1.0);
WinSizeFac = @(x) isnumeric(x) && (x >= 0.0) && (x <= 0.2);
MedFiltWindow = @(x) isnumeric(x) && (x >= 0);
gaussFilt    = @(x) isnumeric(x) && (x>=0);

g.addOptional('max_disp_factor', 0.2, ValidDispFac);
g.addOptional('win_size_factor', 0.005, WinSizeFac);
g.addOptional('med_filt_window', 20, MedFiltWindow);
g.addOptional('gauss_filt', 2, gaussFilt);

g.parse(varargin{:});
max_disp_factor = g.Results.max_disp_factor;
win_size_factor = g.Results.win_size_factor;
med_filt_window = g.Results.med_filt_window;
gauss_filt = g.Results.gauss_filt;

fprintf('Performing Process with\n');
fprintf('DisparityMap Factor\t= %.3f\n', max_disp_factor);
fprintf('WindowSize Factor\t= %.3f\n', win_size_factor);
fprintf('Median Filter\t\t= %.3f\n', med_filt_window);
fprintf('---------------------------------------------\n');
fprintf('Step\t Task\t\t\t\t Time Est.\tTime\n');

%% depth map 
fprintf('6\t Creating Disparity Map\t\t 15.00s');
start = tic;
[disp_left,disp_right,IL_resized,IR_resized] = ...
    calculateDisparityMap(JL,JR,800,max_disp_factor,win_size_factor, gauss_filt,1,round(med_filt_window));
fprintf('\t\t%.2fs\n', toc(start));

end