function [cbmat, errs] = ...
    colorbalance(camera, target, varargin)

% Inputs:
% camera_response: Nx3 camera's sensor responses to the scene materials
% range [0, 1]
% lin-raw RGB
% target: Nx3 patch sRGB color range [0, 1]
%
% Optional Parameters:
% loss:     linear or nonlinear
% model:    remove the effects of the illumination
%           'whitebalance' | 'fullcolorbalance' (default = whitebalance)
% weight:   
% targetcolorspace: sRGB / xyz > for srgb target, error metric is angular
% reproduction err for xyz deltaE00
%
% Outputs:
% cbmat:    3x3 optimal color balance matrix
% errs:     color differences on training sample specified by metric

% check input params
param = parseInput(varargin{:});
param = paramCheck(param);

% check the inputs

% target_lab
target_lab = getcolorpatch('colorspace', 'lab');

N = length(camera(1));

% normalize the weights
if ~isempty(param.weights)
    param.weights = N * param.weights / sum(param.weights);
else
    param.weights = ones(N, 1);
end

% print info
paramPrint(param);

mat0 = (camera' * diag(param.weights) * camera)^(-1) *...
          camera' * diag(param.weights) * target;

switch lower(param.loss)
    case 'linear'
        matrix = mat0;
    otherwise
        matrix = @(x) reshape(x, 3, 3);
        predicted_response = @(x) camera * matrix(x);

        switch lower(param.targetcolorspace)
            case 'srgb'
                errs = @(x) angular_error(predicted_response(x), target); % is angular error for normalized rgb?
            case 'xyz'
                predicted_lab = @(x) xyz2lab(predicted_response(x));
                errs = @(x) deltaE2000_error(predicted_lab(x), target_lab);
        end

        errs = @(x) param.weights' .* errs(x);
        costfun = @(x) mean(errs(x));

        Aeq = []; beq = []; % ?

        options = optimoptions(@fmincon,...
                               'MaxFunctionEvaluations', 1000,...
                               'MaxIterations',200,...
                               'Display','iter',...
                               'Algorithm','sqp',...
                               'PlotFcns',[]);
        matrix = fmincon(costfun, mat0(:), [], [], Aeq, beq, [], [], [], options);
        matrix = reshape(matrix, 3, 3);
end

cbmat = matrix;
predicted = camera * cbmat;

switch lower(param.targetcolorspace)
    case 'srgb'
        errs = angular_error(predicted, target);
    case 'xyz'
        lab_predicted = xyz2lab(predicted);
        errs = deltaE2000_error(lab_predicted, target_lab);
end

end


function param = parseInput(varargin)
% parse inputs & return structure of parameters
parser = inputParser;
parser.addParameter('loss', 'linear', @(x)ischar(x));
parser.addParameter('model', 'whitebalance', @(x)ischar(x));
parser.addParameter('weights', [], @(x)validateattributes(x, {'numeric'}, {'positive'}));
parser.addParameter('targetcolorspace', 'xyz', @(x)ischar(x));
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
metric_list = {'linear', 'nonlinear'};
if ~ismember(lower(param.loss), metric_list)
    error('%s is not a valid loss function',...
        param.loss);
end
end


function paramPrint(param)
% make format pretty
attr_idx = [2, 1, 3, 4];
param.weights = sprintf('[%.2G, ..., %.2G]',...
                        param.weights(1), param.weights(end));

if strcmpi(param.targetcolorspace, 'sRGB')
    param.targetcolorspace = 'sRGB';
elseif strcmpi(param.targetcolorspace, 'XYZ')    
    param.targetcolorspace = 'CIE XYZ';
end

disp('Color balance training parameters:')
disp('=================================================================');
field_names = fieldnames(param);
field_name_dict.loss = 'Loss function';
field_name_dict.model = 'Color correction model';
field_name_dict.targetcolorspace = 'Color space of the target responses';
field_name_dict.weights = 'Sample weights';

for i = attr_idx
    len = fprintf('%s:',field_name_dict.(field_names{i}));
    fprintf(repmat(' ', 1, 42-len));
    fprintf('%s\n', string(param.(field_names{i})));
end
fprintf('================================================================= \n\n');
end
