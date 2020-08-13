%% 

checker2colors(outdoor001, [4,6], 'allowadjust', true)
%% 

patch_xyz = getcolorpatch('colorspace', 'xyz');
profile = 'indoor000.xml';
load('indoor000.mat');
patch = indoor000_patch;
img = indoor000;
type(profile)
%% 

weight = ones(1,24) / 2;
% weight(1) = 6.5;
% weight(2) = 6.5;

W_f = colorbalance(patch, patch_xyz, 'model', 'fullcolorbalance', 'weights', weight);
fcbalanced_patch= patch * W_f;
%% 

colormat = W_f';
corrected_img = applycmat(img, colormat);
baseline_corrected_img = applycmat(img, csmat);
%% 

patch_err = angular_error_between_src_dst(fcbalanced_patch, patch_xyz);
patch_baseline_err = angular_error_between_src_dst(baseline_corrected_patch, patch_xyz);
%% 

colors2checker(patch_xyz)
colors2checker(patch)
colors2checker(fcbalanced_patch)

imshow(img)
imshow(corrected_img)