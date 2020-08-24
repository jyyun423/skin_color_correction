%% Training 

%% 

% set path

clc
clear

datasetDir = './dataset/skin/iphone7/patch/';
datasetname = [datasetDir '*.mat'];
dataset = dir(datasetDir);
length = length(dataset);
%% 

% get datas & ground truth patch data
patch_img = [];
% img = [];

for i=1:length
    if ~dataset(i).isdir
        load (dataset(i).name)
        patch_img = cat(3,patch_img,colors);
    end
end

patch_rgb = getcolorpatch();
patch_xyz = getcolorpatch('colorspace', 'xyz');
patch_lab = getcolorpatch('colorspace', 'lab');
%% 

% calculate 3x3 color correction matrix 
% choose the target color space; either srgb for display or xyz for
% perceptual purpose

weight = ones(1,24) / 2;
% weight(1) = 6.5;
% weight(2) = 6.5;
err = [];
W_f = [];
len = size(patch_img,3);

for k=1:len
    [W_f_tmp, err_tmp] = colorbalance(patch_img(:,:,k), patch_xyz,...
        'model', 'fullcolorbalance', 'weights', weight,...
        'loss', 'nonlinear', 'targetcolorspace', 'xyz');
    fcbalanced_patch = patch_img(:,:,k) * W_f_tmp;
    W_f = cat(3, W_f, W_f_tmp);
    err = cat(2,err, err_tmp);
end

% err = err / length;
