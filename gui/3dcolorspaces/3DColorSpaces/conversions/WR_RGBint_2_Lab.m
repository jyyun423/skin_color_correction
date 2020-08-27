% INPUT:
% --------
% RGBint: a Nx3 matrix with one RGB value per row, in [0..255]
%
% OUTPUT:
% --------
% Lab : a Nx3 matrix, L = [0 .. 100    ], a = [-86.1846 ..  98.2542], b = [-107.863 ..  94.4824]
%
% note: r,g,b denote values in [0..1] but still in companded lightness (CRT domain)
%       i.e. r=R/255 etc
% 
% Conversion results are in line with :
% http://colormine.org/convert/RGB-to-lab
function [Lab] = WR_RGBint_2_Lab(RGBint)

[XYZ] = RGBint_2_XYZ(RGBint);
[Lab] = XYZ_2_Lab(XYZ);

end