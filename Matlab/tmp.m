scaled_img = indoor000;
scaled_img(:,:,2) = scaled_img(:,:,2) / sqrt(2);

checker2colors(scaled_img, [4,6], 'allowadjust', true)
save('ans')
%% 

patch_xyz = getcolorpatch('colorspace', 'xyz');
profile = 'indoor000.xml';
load('indoor000.mat');
patch = ans;
img = indoor000;
% original_img = indoor000;
% img(:,:,2);
% patch(:,2) = patch(:,2)/ sqrt(2);
%% 

weight = ones(1,24) / 2;
% weight(1) = 6.5;
% weight(2) = 6.5;

W_f = colorbalance(patch, patch_xyz, 'model', 'fullcolorbalance', 'weights', weight);
fcbalanced_patch= patch * W_f;
% fcbalanced_patch = fcbalanced_patch * 255;
%% 

csmat = getbaselinemodel(profile);
baseline_corrected_patch = patch * csmat';
%% 

colormat = W_f';
corrected_img = applycmat(img, colormat);
baseline_corrected_img = applycmat(scaled_img, csmat);
%% 

patch_err = angular_error_between_src_dst(fcbalanced_patch, patch_srgb);
patch_baseline_err = angular_error_between_src_dst(baseline_corrected_patch, patch_srgb);
%% 

colors2checker(patch_srgb)
colors2checker(patch)
colors2checker(fcbalanced_patch)
colors2checker(baseline_corrected_patch)

imshow(tif)
imshow(img)
imshow(corrected_img)
imshow(baseline_corrected_img)