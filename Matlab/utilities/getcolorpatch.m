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
52,52,52]) / 255;

xyz_Values = ([...
0.11543,0.10100,0.07214
0.39121,0.35800,0.28848
0.18992,0.19300,0.38600
0.10621,0.13300,0.07595
0.26831,0.24300,0.50119
0.32796,0.43100,0.49760
0.37422,0.30100,0.06434
0.14469,0.12000,0.42103
0.29312,0.19800,0.15594
0.09312,0.06600,0.16761
0.34425,0.44300,0.11868
0.46544,0.43100,0.08758
0.08843,0.06100,0.32344
0.14931,0.23400,0.10623
0.20665,0.12000,0.05674
0.56334,0.59100,0.10311
0.30932,0.19800,0.34246
0.15400,0.19800,0.43371
0.88237,0.90000,1.06292
0.57942,0.59100,0.69799
0.35491,0.36200,0.42753
0.19412,0.19800,0.23384
0.08824,0.09000,0.10629
0.03039,0.03100,0.03661]);

Lab_Values = ([...
38.02,	12.21,	14.37
66.37,	13.07,	16.99
51.04,	0.36,	-22.19
43.21,	-16.87,	21.96
56.39,	12.61,	-25.49
71.62,	-30.59,	1.14
61.74,	27.61,	58.22
41.22,	17.61,	-43.16
51.61,	42.91,	14.73
30.88,	26.07,	-23.50
72.43,	-28.41,	59.48
71.62,	12.37,	67.05
29.66,	27.41,	-51.15
55.48,	-41.10,	33.63
41.22,	50.94,	25.94
81.35,	-3.92,	79.11
51.61,	48.96,	-15.81
51.61,	-21.65,	-26.65
96.00,	-0.0002,	0.0002
81.35,	-0.0002,	0.0001
66.67,	-0.0002,	0.0001
51.61,	-0.0001,	0.0001
35.98,	-0.0001,	0.0001
20.44,	-0.0001,	0.0001
]);

switch lower(param.colorspace)
    case 'srgb' % linear optimization
        patch_gt = sRGB_Values;
    case 'xyz'
        patch_gt = xyz_Values;
    case 'lab'
        patch_gt = Lab_Values;
end

end


function param = parseInput(varargin)
% parse inputs & return structure of parameters
parser = inputParser;
parser.addParameter('colorspace', 'sRGB', @(x)ischar(x));
% parser.addParameter('illuminant', 'D65', @(x)ischar(x));
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

% %check the illuminant
% illuminant_list = {'d65'}; % add more
% if ~ismember(lower(param.illuminant), illuminant_list)
%     error('%s is not a valid illuminant',...
%         param.illuminant);
% end
end
