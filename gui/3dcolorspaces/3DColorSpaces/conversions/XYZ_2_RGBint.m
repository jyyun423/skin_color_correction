% INPUT:
% --------
% XYZ : a Nx3 matrix, X = [0 .. 95.05  ], Y = [  0      .. 100     ], Z = [   0     .. 108.90  ]
%
% OUTPUT:
% --------
% RGBint: a Nx3 matrix with one RGB value per row, in [0..255]
% 
function RGBint = XYZ_2_RGBint(XYZ)

if size(XYZ,2) ~= 3
    error('each input row is expected to be one XYZ entry');
end

% http://www.easyrgb.com/index.php?X=MATH&H=01#text1
XYZ = XYZ/100;

% this is the inverse of the matrix used in RGBint_2_XYZ_xyY_LAB
invM =  [
   3.240625477320053  -1.537207972210319  -0.498628598698248
  -0.968930714729320   1.875756060885242   0.041517523842954
   0.055710120445511  -0.204021050598487   1.056995942254388   ];

sr = XYZ(:,1)*invM(1,1) + XYZ(:,2)*invM(1,2) + XYZ(:,3)*invM(1,3);
sg = XYZ(:,1)*invM(2,1) + XYZ(:,2)*invM(2,2) + XYZ(:,3)*invM(2,3);
sb = XYZ(:,1)*invM(3,1) + XYZ(:,2)*invM(3,2) + XYZ(:,3)*invM(3,3);    

srgb = cat(2,sr,sg,sb);

ThrLin2Gamma = 0.0031308;
indexGamma  = find(srgb >  ThrLin2Gamma);
indexLinear = find(srgb <= ThrLin2Gamma);

RGB = zeros(size(srgb));
RGB(indexGamma)  = 1.055 * srgb(indexGamma).^(1/2.4) - 0.055;
RGB(indexLinear) = 12.92 * srgb(indexLinear);

RGBint = RGB*255; %keep precision

end
