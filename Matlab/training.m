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

patch_srgb = getcolorpatch / 200; % scale by 200 <- why?
patch_xyz = getcolorpatch('colorspace', 'xyz');

% color space of patch
profile = 'IMG_8097.xml';
load('colors.mat');
img = colors;
%% 

% eliminate effects of illumination

W_f = colorbalance(img, patch_srgb, 'model', 'fullcolorbalance');
balanced_img = img * W_f;
%% 

% map camera sensor's color space to the desired perceptual color space

weight = ones(1,24);
CST = colorspacetransform(balanced_img, patch_xyz, 'weights', weight);
corrected_img = balanced_img * CST;
%% 

% compare with baselinemodel

csmat = getbaselinemodel(profile);
baseline_corrected_img = img * csmat;
%% 

colors2checker(img);
colors2checker(patch_srgb);
colors2checker(balanced_img);
colors2checker(baseline_corrected_img);