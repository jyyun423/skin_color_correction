% INPUT:
% --------
% RGBint: a Nx3 matrix with one RGB value per row, in [0..255]
%
% OUTPUT:
% --------
% XYZ : a Nx3 matrix, X = [0 .. 95.05  ], Y = [  0      .. 100     ], Z = [   0     .. 108.90  ]
%
% note: r,g,b denote values in [0..1] but still in companded lightness (CRT domain)
%       i.e. r=R/255 etc
%
% Conversion results are in line with :
% http://colormine.org/convert/RGB-to-xyz
function [XYZ] = RGBint_2_XYZ(RGBint)

if size(RGBint,2) ~= 3
    error('each input row is expected to be one RGB entry');
end
if (max(max(RGBint))) > 256
    error('RGB values out of range');
end

%scale to [0..1]
rgb = RGBint/255;

%% convert rgb to XYZ
% Input RGB is companded, needs first to go to linear RGB (median ^2.24 gamma), usually named "rgb uncompanding"
% such uncompanding is linear below a threshold and exponential above it
% convert rgb to linear lighness srgb: https://en.wikipedia.org/wiki/SRGB

% http://www.easyrgb.com/index.php?X=MATH&H=02#text2
ThrLin2Gamma    = 0.04045;
idxGamma        = find(rgb >  ThrLin2Gamma);
idxLinear       = find(rgb <= ThrLin2Gamma);

% Gamma uncompand
srgb            = zeros(size(rgb));
srgb(idxGamma)  = ((rgb(idxGamma) + 0.055) / 1.055).^2.4;
srgb(idxLinear) = rgb(idxLinear) / 12.92;

% Linear map [0..1] to  [0..c], c ~ 1 (see later)
M = [0.4124  0.3576  0.1805 ;
     0.2126  0.7152  0.0722 ;
     0.0193  0.1192  0.9505  ];

X = srgb(:,1)*M(1,1) + srgb(:,2)*M(1,2) + srgb(:,3)*M(1,3);
Y = srgb(:,1)*M(2,1) + srgb(:,2)*M(2,2) + srgb(:,3)*M(2,3);
Z = srgb(:,1)*M(3,1) + srgb(:,2)*M(3,2) + srgb(:,3)*M(3,3);
% X,Y,Z unit scale until here ...

%% assign output XYZ xyY in proper scale
XYZ = 100*cat(2,X,Y,Z);

end