function [cbmat] = ...
    colorbalance(camera_response, target, varargin)

% Inputs:
% camera_response: 24x3 camera's sensor responses to the scene materials
% lin-raw RGB
% target: 24x3 patch sRGB color
%
% Optional Parameters:
% loss:     (default = mse)
% model:    remove the effects of the illumination
%           'whitebalance' | 'fullcolorbalance' (default = whitebalance)
% allowscale:        boolean value. If set to true, the camera responses
%                    will be first scaled by a factor such that the mse
%                    between camera's G values and target G (or Y, 
%                    depending on 'targetcolorspace') values is minimized.
%                    This option will be useful if the camera responses are
%                    in a different range from the target responses. When 
%                    this option is enabled, 'omitlightness' option will be 
%                    false. (default = true)
%
% Outputs:
% cbmat:    3x3 optimal color balance matrix
% errs:     color differences on training sample specified by metric

% check input params
param = parseInput(varargin{:});
param = paramCheck(param);

% check the inputs
% add here

% loss function handle
lossfun = eval(['@', param.loss]);

% print info
paramPrint(param);

% matrix calculation
% set init matrix
switch lower(param.model)
    case 'whitebalance'
    case 'fullcolorbalance'
        mat_r = lsqlin(camera_response, target(:,1));
        mat_g = lsqlin(camera_response, target(:,2));
        mat_b = lsqlin(camera_response, target(:,3));

        mat0 = [mat_r mat_g mat_b];
    otherwise
end

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
fprintf('================================================================= \n\n');
end
