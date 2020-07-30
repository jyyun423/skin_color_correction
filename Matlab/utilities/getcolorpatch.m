function [patch_gt] = getcolorpatch(varargin)

% check input params
param = parseInput(varargin{:});
param = paramCheck(param);

sRGB_Values = ([...
115,82,68
194,150,130
98,122,157
87,108,67
133,128,177
103,189,170
214,126,44
80,91,166
193,90,99
94,60,108
157,188,64
224,163,46
56,61,150
70,148,73
175,54,60
231,199,31
187,86,149
8,133,161
243,243,242
200,200,200
160,160,160
122,122,121
85,85,85
52,52,52]);

switch lower(param.illuminant)
    case 'd65' % linear optimization
        patch_gt = sRGB_Values;
    otherwise
end

switch lower(param.colorspace)
    case 'srgb' % linear optimization
        patch_gt = patch_gt;
    case 'xyz'
        patch_gt = srgb2xyz(patch_gt);
    otherwise
end

end


function param = parseInput(varargin)
% parse inputs & return structure of parameters
parser = inputParser;
parser.addParameter('colorspace', 'sRGB', @(x)ischar(x));
parser.addParameter('illuminant', 'D65', @(x)ischar(x));
parser.parse(varargin{:});
param = parser.Results;
end


function param = paramCheck(param)
% check the parameters

% check the color space
colorspace_list = {'srgb', 'xyz'};
if ~ismember(lower(param.colorspace), colorspace_list)
    error('%s is not a valid color balance model',...
        param.colorspace);
end

%check the loss function
illuminant_list = {'d65'}; % add more
if ~ismember(lower(param.illuminant), illuminant_list)
    error('%s is not a valid loss function',...
        param.illuminant);
end
end
