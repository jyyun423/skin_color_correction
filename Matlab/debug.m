%% 

checker2colors(outdoor001, [4,6], 'allowadjust', true)
%% color correction matrix debugging

patch_xyz = getcolorpatch('colorspace', 'xyz');
patch_rgb = getcolorpatch();
patch_lab = getcolorpatch('colorspace', 'lab');
load('indoor000.mat');
camera_respons_patch = indoor000_patch;
img = indoor000;
%% 

weight = ones(1,24) / 2;
% weight(19) = 5;

[W_f, err] = colorbalance(camera_respons_patch, patch_xyz, 'model', 'fullcolorbalance', 'weights', weight, 'loss', 'nonlinear');
fcbalanced_patch= camera_respons_patch * W_f;
%% 
cam_lab = xyz2lab(camera_respons_patch);
original_err = deltaE2000_error(cam_lab, patch_lab);
%% 

colormat = W_f';
corrected_img = applycmat(img, colormat);
%% 

angular_err = angular_error(fcbalanced_patch, patch_rgb);
angular_err = sum(angular_err) / 24;
%% 

fcbalanced_patch_lab = xyz2lab(fcbalanced_patch);
de_err = deltaE2000_error(fcbalanced_patch, patch_lab);
%% 

colors2checker(patch_rgb)
colors2checker(camera_respons_patch)
colors2checker(fcbalanced_patch)

imshow(img)
imshow(corrected_img)
%% shading compensation debugging


tmp = shadecompensation(outdoor001, [4,6], 'allowadjust', true);