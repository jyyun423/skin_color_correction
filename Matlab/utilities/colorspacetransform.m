function [cstmat] = ...
    colorspacetransform(balanced_camera_response, target, varargin)

% Inputs:
% balanced_camera_response: 24x3 white balacned camera's sensor responses
% to the scene materials sRGB color
% target: 24x3 patch CIE XYZ color (or may use CIE Lab)
%
% Optional Parameters:
% loss:     (default = mse)
% weights:   color space transform weight
%            it should be 1x24 vector (default = [1, 1, ..., 1])
% Outputs:
% cbmat:    3x3 optimal color balance matrix
% errs:     color differences on training sample specified by metric

% check input params
param = parseInput(varargin{:});
param = paramCheck(param);

% check the inputs
N = size(balanced_camera_response, 1);
assert(size(balanced_camera_response, 2) == 3,...
       'Both test and target responses must be Nx3 matrices.');
if ~isempty(param.weights)
    assert(numel(param.weights) == N,...
           'The number of weights does not match the number of test samples.');
end

% normalize the weights
if ~isempty(param.weights)
    param.weights = N * param.weights / sum(param.weights);
else
    param.weights = ones(N, 1);
end

% convert target responses to L*a*b* values
target_lab = xyz2lab_(100*target); % for nonlinear opt

% loss function handle
lossfun = eval(['@', param.loss]);

% print info
paramPrint(param);

% matrix calculation
% set init matrix
mat0 = (balanced_camera_response' * diag(param.weights) * balanced_camera_response)^(-1) *...
          balanced_camera_response' * diag(param.weights) * target;

% mat0 = mat0.';

switch lower(param.loss)
    case 'mse' % linear optimization
        cstmat = mat0;
    otherwise
end

end


function param = parseInput(varargin)
% parse inputs & return structure of parameters
parser = inputParser;
parser.addParameter('loss', 'mse', @(x)ischar(x));
parser.addParameter('weights', [], @(x)validateattributes(x, {'numeric'}, {'positive'}));
parser.parse(varargin{:});
param = parser.Results;
end


function param = paramCheck(param)
% check the parameters

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
param.weights = sprintf('[%.2G, ..., %.2G]',...
                        param.weights(1), param.weights(end));

disp('Color space transform training parameters:')
disp('=================================================================');
field_names = fieldnames(param);
field_name_dict.loss = 'Loss function';
% field_name_dict.metric = 'Color difference metrics';
% field_name_dict.model = 'Color correction model';
% field_name_dict.observer = 'CIE standard colorimetric observer';
field_name_dict.weights = 'Sample weights';

for i = attr_idx
    len = fprintf('%s:',field_name_dict.(field_names{i}));
    fprintf(repmat(' ', 1, 42-len));
    fprintf('%s\n', string(param.(field_names{i})));
end
disp('=================================================================');
end
