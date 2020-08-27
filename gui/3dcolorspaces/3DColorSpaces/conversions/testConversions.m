close all
clear all

clc

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
% All conversion funcs in this folder
% -----------------------------------------------------------
% 
%  RGBint <---> XYZ <---> Lab
%    ^           ^
%    |           |
%    v           v
%   HSV         xyY
%   HSL
% 
%   3      2     2    2     = 9 funcs
% -----------------------------------------------------------


% REF
% http://colormine.org/convert/RGB-to-xyz
% http://colormine.org/convert/RGB-to-Yxy
% http://colormine.org/convert/RGB-to-Lab
% http://colormine.org/convert/RGB-to-hsv
% http://colormine.org/convert/RGB-to-hsl

% or 
% http://www.color-hex.com/color/010f14

% ----
% RGB = [1 71 250]
% XYZ = [19.521 11.415  91.617]
% xyY = [0.159286  0.09314   11.415]
% Lab = [40.27  52.45  -91.79]
% 
% HSV = [223.1325, 99.20, 49.21]
% HSL = [223.1325, 99.6 , 98.04]

% ----
% RGB = [1 15 20]
% XYZ = [0.309 0.3986 0.72244]
% xyY = [0.2164 0.2786  0.398]
% Lab = [3.6 -2.837 -4.1255]
% 
% HSV = [195.789  95  7.84]
% HSL = [223.13 99.20 49.215]

    % adjusting rounding of reference D65
    % orig
    % ref_max_XYZ = [95.047 100 108.883]; %D65 2° observer
    % XYZ_2_RGBint(Lab_2_XYZ([100,  0,  0])) %  254.9986  255.0025  254.9797  ... some inaccurate XYZ scale?
    % XYZ_2_Lab(RGBint_2_XYZ([255,255,255])) %  100.0000    0.0053   -0.0104
    % changed
    % ref_max_XYZ = [95.05 100 108.90]; %D65 2° observer, corrected
    % XYZ_2_RGBint(Lab_2_XYZ([100,  0,  0])) %  255.0000  255.0000  255.0000 
    % XYZ_2_Lab(RGBint_2_XYZ([255,255,255])) %  100.0000    0.0000    0.0000


% RGBint = [1 71 250; 1 15 20]
RGBint = [0   0   0; 
          1   1   1; 
          255 0   0;   %r
          255 255 0;   %y                 
          0   255 0;   %g
          0   255 255; %c        
          0   0   255; %b
          255 0   255; %m
          128 128 128; %mid grey    L=50
          192 192 192; %light grey  L=75
          255 255 255]




%% test RGB to LaB chain and backwards

%fwd
[XYZ] = RGBint_2_XYZ(RGBint)
[Lab] = XYZ_2_Lab(XYZ)
[xyY] = XYZ_2_xyY(XYZ)

% fwd wrappers
% [XYZ_0, Lab_0, xyY_0] = WR_RGBint_2_XYZ_xyY_Lab(RGBint)
% [Lab_1]               = WR_RGBint_2_Lab(RGBint)


%bckwd
[XYZ1]    = xyY_2_XYZ(xyY)
[XYZ2]    = Lab_2_XYZ(Lab)
[RGBint1] = XYZ_2_RGBint(XYZ)


%% test RGB to HSV and backwards
%fwd
[HSVpc, HSLpc] = RGBint_2_HSVpc_HSLpc(RGBint)

%bckwd
[RGBint2] = HSVpc_2_RGBint(HSVpc)
[RGBint3] = HSLpc_2_RGBint(HSLpc)
