function [cstmat] = ...
    colorspacetransform(target, balanced_camera_response, varargin)

% Inputs:
% balanced_camera_response: 24x3 white balacned camera's sensor responses
% to the scene materials sRGB color
% target: 24x3 patch CIE XYZ color (or may use CIE Lab)
%
% Optional Parameters:
% loss:     (default = mse)
% model:    remove the effects of the illumination
%           'whitebalance' | 'fullcolorbalance' (default = whitebalance)
% weight:   color space transform weight
%
% Outputs:
% cbmat:    3x3 optimal color balance matrix
% errs:     color differences on training sample specified by metric

% check input params
param = parseInput(varargin{:});
param = paramCheck(param);

% check the inputs
% add here
% bias = camera_sensitivity * reflectance;
% bias = bias.';


% loss function handle
lossfun = eval(['@', param.loss]);

% matrix calculation
% set init matrix
mat_r = lsqlin(camera_response, target(:,1));
mat_g = lsqlin(camera_response, target(:,2));
mat_b = lsqlin(camera_response, target(:,3));

mat0 = [mat_r mat_g mat_b];

% mat0 = mat0.';

switch lower(param.loss)
    case 'mse' % linear optimization
        cbmat = mat0;
    otherwise
end

end


function param = parseInput(varargin)
% parse inputs & return structure of parameters
parser = inputParser;
parser.addParameter('loss', 'mse', @(x)ischar(x));
parser.addParameter('model', 'whitebalance', @(x)ischar(x));
parser.parse(varargin{:});
param = parser.Results;
end


function param = paramCheck(param)
% check the parameters

% check the color balance model
model_list = {'whitebalance', 'fullcolorbalance'};
if ~ismember(lower(param.model), model_list)
    error('%s is not a valid color balance model',...
        param.model);
end

%check the loss function
metric_list = {'mse'}; % add more
if ~ismember(lower(param.loss), metric_list)
    error('%s is not a valid loss function',...
        param.loss);
end
end


function paramPrint(param)
% make format pretty
attr_idx = [2, 1];

disp('Color balance training parameters:')
disp('=================================================================');
field_names = fieldnames(param);
field_name_dict.loss = 'Loss function';
field_name_dict.model = 'Color correction model';

for i = attr_idx
    len = fprintf('%s:',field_name_dict.(field_names{i}));
    fprintf(repmat(' ', 1, 42-len));
    fprintf('%s\n', string(param.(field_names{i})));
end
disp('=================================================================');
end

