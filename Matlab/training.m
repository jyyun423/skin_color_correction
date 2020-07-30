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

patch_gt = getcolorpatch / 200;

% color space of patch
profile = 'IMG_8097.xml';
load('colors.mat');
img = colors;
%% 

% eliminate effects of illumination

W_f = colorbalance(patch_gt, img, 'model', 'fullcolorbalance');
corrected_img = img * W_f;
%% 

% compare with baselinemodel

csmat = getbaselinemodel(profile);
baseline_corrected_img = img * csmat;
%% 

colors2checker(img);
colors2checker(patch_gt);
colors2checker(corrected_img);
colors2checker(baseline_corrected_img);