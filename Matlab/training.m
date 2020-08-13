%% Training 

%% 

% set path

clc
clear

datasetDir = './dataset/iphone7/patch/';
datasetname = [datasetDir '*.mat'];
dataset = dir(datasetDir);
length = length(dataset);

profileDir = './dataset/iphone7/profiles/';
profilename = [profileDir '*.xml'];
profile = dir(profileDir);
profilelength = size(profile, 1);
%% 

% get datas & ground truth
patch_img = [];
patch_profile = [];
img = [];

for i=1:length
    if ~dataset(i).isdir
        load (dataset(i).name)
        patch_img = cat(3,patch_img,data);
    end
end

for j=1:profilelength
    if ~profile(j).isdir
        patch_profile = [patch_profile; profile(j).name];
    end
end

% for m=1:length
% end

patch_xyz = getcolorpatch('colorspace', 'xyz');
patch_lab = getcolorpatch('colorspace', 'lab');
%% 

% eliminate effects of illumination of patch

% weight = ones(1,24) / 2;
% weight(1) = 6.5;
% weight(2) = 6.5;
err = 0.0;
W_f = [];

for k=1:length
    W_f_tmp = colorbalance(patch_img(k), patch_xyz, 'model', 'fullcolorbalance', 'weights', weight);
    fcbalanced_patch = patch * W_f_tmp;
    W_f = cat(3, W_f, W_f_tmp);
    err = err + angular_error_between_src_dst(fcbalanced_patch, patch_xyz);
end

err = err / length;
%% 

% apply to image

corrected_img = [];

for l=1:length
    colormat_tmp = W_f(l)';
    corrected_img = cat(4, corrected_img, applycmat(img, colormat_tmp);
end
%% 

colors2checker(patch_srgb);
colors2checker(colors);
colors2checker(balanced_patch);

imshow(corrected_img);
imshow(img);
