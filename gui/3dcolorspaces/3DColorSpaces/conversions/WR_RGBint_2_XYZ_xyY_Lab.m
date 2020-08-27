% INPUT:
% --------
% RGBint: a Nx3 matrix with one RGB value per row, in [0..255]
%
% OUTPUT:
% --------
% XYZ : a Nx3 matrix, X = [0 .. 95.05  ], Y = [  0      .. 100     ], Z = [   0     .. 108.90  ]
% Lab : a Nx3 matrix, L = [0 .. 100    ], a = [-86.1846 ..  98.2542], b = [-107.863 ..  94.4824]
% xyY : a Nx3 matrix, x = [0.15 .. 0.64], y = [  0.060  ..   0.600 ], Y = [   0     .. 100     ]
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
function [XYZ, Lab, xyY] = WR_RGBint_2_XYZ_xyY_Lab(RGBint)


[XYZ] = RGBint_2_XYZ(RGBint);

[xyY] = XYZ_2_xyY(XYZ);

[Lab] = XYZ_2_Lab(XYZ);

end