%% Training 

%% 

img(2,2,1)
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

for i=1:length
    if ~dataset(i).isdir
        load (dataset(i).name)
        patch_img = cat(3,patch_img,data);
    end
end

% for j=1:profilelength
%     if ~profile(j).isdir
%         patch_profile = [patch_profile; profile(j).name];
%     end
% end

patch_srgb = getcolorpatch / 243; % scale by 200 <- why?
patch_xyz = getcolorpatch('colorspace', 'xyz');
%% 

% tmp
profile = 'IMG_8097.xml';
load('colors.mat');
patch = colors;
img = IMG_8097;
%% 

% eliminate effects of illumination

weight = ones(1,24) / 2;
weight(1) = 6.5;
weight(2) = 6.5;

W_f = colorbalance(patch, patch_srgb, 'model', 'fullcolorbalance', 'weights', weight);
balanced_img = patch * W_f;

% %% 
% 
% % map camera sensor's color space to the desired perceptual color space
% 
% CST = colorspacetransform(balanced_img, patch_xyz, 'weights', weight);
% corrected_patch = balanced_img * CST; % xyz color space
% corrected_patch = xyz2rgb(corrected_patch);
%% 

% get baseline model's output

csmat = getbaselinemodel(profile);
baseline_corrected_patch = patch * csmat';
%% 

% apply to image

colormat = (W_f + csmat)';
corrected_img = applycmat(img, colormat);
baseline_corrected_img = applycmat(img, csmat);
%% 

% tmp

I = eye(3);
temp = applycmat(img, I);
%% 

colors2checker(patch_srgb);
colors2checker(colors);
colors2checker(balanced_img);
colors2checker(baseline_corrected_patch);

imshow(corrected_img);
imshow(baseline_corrected_img);
imshow(img);
imshow(temp);