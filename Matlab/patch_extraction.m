
clear, clc, close all
%% extract color patches from iphone7 images (get raw image file using VSCO)
% don't need to process image before extracting patch
%% extract color patches from nikonD850 images
% use adobe dng converter to convert .NEF files to .dng files
% before extracting patch, convert raw file to matrix using raw_process.m
% since original dng file only provides thumbnail of image
%% 

path = './dataset/skin/iphone7/original/';
pathname = [path '*.mat'];
pathsmat = dir(pathname);
nfiles = length(pathsmat);
savepath = './dataset/skin/iphone7/patch/';
%% 

for num = 5:nfiles
    load (pathsmat(num).name)
    colors = checker2colors(raw, [4,6], 'allowadjust', true);
    save(pathsmat(num).name,'colors') % do it in directory you want to save
end
