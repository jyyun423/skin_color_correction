% INPUT:
% --------
% Lab : a Nx3 matrix, L = [0 .. 100    ], a = [-86.1846 ..  98.2542], b = [-107.863 ..  94.4824]
%
% OUTPUT:
% --------
% XYZ : a Nx3 matrix, X = [0 .. 95.05  ], Y = [  0      .. 100     ], Z = [   0     .. 108.90  ]
function [XYZ] = Lab_2_XYZ(Lab)

if size(Lab,2) ~= 3
    error('each input row is expected to be one Lab entry');
end

% http://www.easyrgb.com/index.php?X=MATH&H=08#text8
Y = (Lab(:,1) + 16) / 116;
X = Lab(:,2) / 500 + Y;
Z = Y - Lab(:,3) / 200;

XYZ_1_gc = cat(2,X,Y,Z); %in 0..1

% Gamma expand
ThrLin2Gammaxyz  = 0.008856;
idxGamma         = find(XYZ_1_gc.^3 >  ThrLin2Gammaxyz);
idxLinear        = find(XYZ_1_gc.^3 <= ThrLin2Gammaxyz);
XYZ_1            = zeros(size(XYZ_1_gc));
XYZ_1(idxGamma)  = XYZ_1_gc(idxGamma).^3;
XYZ_1(idxLinear) = ( XYZ_1_gc(idxLinear) - 16 / 116 ) / 7.787;

% scale XYZ_1 from [0..1] in [95.047 100 108.883]
XYZ      = zeros(size(XYZ_1_gc));

% ref_max_XYZ = [95.047 100 108.883]; %D65 2° observer
ref_max_XYZ = [95.05 100 108.90]; %D65 2° observer, corrected for Lab=[100,0,0] on RGB=[255 255 255]

XYZ(:,1) = XYZ_1(:,1) * ref_max_XYZ(1);
XYZ(:,2) = XYZ_1(:,2) * ref_max_XYZ(2);
XYZ(:,3) = XYZ_1(:,3) * ref_max_XYZ(3);


end

