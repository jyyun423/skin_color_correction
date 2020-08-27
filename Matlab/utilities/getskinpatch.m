function [skinpatch_gt] = getskinpatch(varargin)

% check input params
param = parseInput(varargin{:});
param = paramCheck(param);

% ground truth of skin color patch is given in Lab color space
skin_lab = ([...
    72 8 14
    73 9 16
    71 8 16
    69 10 15
    69 12 13
    67 10 16
    67 14 12
    66 8 19
    63 10 19
    63 16 15
    60 16 18
    57 10 21
    54 14 22
    51 14 22
    50 17 21
    44 14 20
    40 12 17
    34 9 11
    30 7 9]);

switch lower(param.colorspace)
    case 'srgb' % linear optimization
        skinpatch_gt = lab2rgb(skin_lab);
    case 'xyz'
        skinpatch_gt = lab2xyz(skin_lab);
    case 'lab'
        skinpatch_gt = skin_lab;
end

end


function param = parseInput(varargin)
% parse inputs & return structure of parameters
parser = inputParser;
parser.addParameter('colorspace', 'lab', @(x)ischar(x));
parser.parse(varargin{:});
param = parser.Results;
end


function param = paramCheck(param)
% check the parameters

% check the color space
colorspace_list = {'srgb', 'xyz', 'lab'};
if ~ismember(lower(param.colorspace), colorspace_list)
    error('%s is not a valid color balance model',...
        param.colorspace);
end

end

