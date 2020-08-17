%% 

checker2colors(outdoor001, [4,6], 'allowadjust', true)
%% 

patch_xyz = getcolorpatch('colorspace', 'xyz');
profile = 'indoor000.xml';
load('indoor000.mat');
patch = indoor000_patch;
img = indoor000;
%% 

weight = ones(1,24) / 2;
% weight(19) = 5;

W_f = colorbalance(patch, patch_xyz, 'model', 'fullcolorbalance', 'weights', weight);
fcbalanced_patch= patch * W_f;
%% 

colormat = W_f';
corrected_img = applycmat(img, colormat);
%% 

patch_lab = xyz2lab(fcbalanced_patch);
%% 

patch_err = angular_error_between_src_dst(fcbalanced_patch, patch_xyz);
patch_err = sum(patch_err) / 24;
%% 

colors2checker(patch_rgb)
colors2checker(patch)
colors2checker(fcbalanced_patch)

imshow(img)
imshow(corrected_img)