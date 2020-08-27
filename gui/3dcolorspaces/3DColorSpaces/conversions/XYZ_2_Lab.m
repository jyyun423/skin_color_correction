% INPUT:
% --------
% XYZ : a Nx3 matrix, X = [0 .. 95.05  ], Y = [  0      .. 100     ], Z = [   0     .. 108.90  ]
%
% OUTPUT:
% --------
% Lab : a Nx3 matrix, L = [0 .. 100    ], a = [-86.1846 ..  98.2542], b = [-107.863 ..  94.4824]
%
% note: r,g,b denote values in [0..1] but still in companded lightness (CRT domain)
%       i.e. r=R/255 etc
%
% -----------------------------------------------------------
% conversion chain :
% -----------------------------------------------------------
%                             95.047   ref D65 2° observer
%                             100
%                             108.883
%        2.4                    |              1/3
%         |                     v               |
% rgb -->(^)--> srgb --> XYZ ->(/)--> XYZ_1 ---(^)---> XYZ_1_gc --> Lab
%                         |
%                         v
%                        xyY
% -----------------------------------------------------------
% Conversion results are in line with :
% http://colormine.org/convert/xyz-to-hsv
% http://colormine.org/convert/RGB-to-xyz
% http://colormine.org/convert/RGB-to-lab
% http://colormine.org/convert/rgb-to-hsl
function [Lab] = XYZ_2_Lab(XYZ)

if size(XYZ,2) ~= 3
    error('each input row is expected to be one XYZ entry');
end
    
%% convert XYZ to Lab
% http://www.easyrgb.com/index.php?X=MATH&H=07
% % var_X = X / ref_X          //ref_X =  95.047   Observer= 2°, Illuminant= D65
% % ...
% % if ( var_X > 0.008856 ) var_X = var_X ^ ( 1/3 )
% % else                    var_X = ( 7.787 * var_X ) + ( 16 / 116 )
% % ...

% scale XYZ exactly in [0..1]
XYZ_1 = zeros(size(XYZ));

% ref_max_XYZ = [95.047 100 108.883]; %D65 2° observer
ref_max_XYZ = [95.05 100 108.90]; %D65 2° observer, corrected for Lab=[100,0,0] on RGB=[255 255 255]

XYZ_1(:,1) = XYZ(:,1) / ref_max_XYZ(1);
XYZ_1(:,2) = XYZ(:,2) / ref_max_XYZ(2);
XYZ_1(:,3) = XYZ(:,3) / ref_max_XYZ(3);

% Gamma compand
ThrLin2Gammaxyz  = 0.008856;
idxGamma         = find(XYZ_1 >  ThrLin2Gammaxyz);
idxLinear        = find(XYZ_1 <= ThrLin2Gammaxyz);
XYZ_1(idxGamma)  = XYZ_1(idxGamma).^(1/3);
XYZ_1(idxLinear) = 7.787 * XYZ_1(idxLinear)  + 16/116;

% CIE-L*ab
L = 116 * XYZ_1(:,2) - 16;
a = 500 * (XYZ_1(:,1) - XYZ_1(:,2));
b = 200 * (XYZ_1(:,2) - XYZ_1(:,3));
Lab = cat(2,L,a,b);

end