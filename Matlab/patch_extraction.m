
clear, clc, close all
%% extract color patches from iphone7 images (get raw image file using VSCO)
% don't need to process image before extracting patch

info_phone = imfinfo('indoor000.dng');
%% 

path = './dataset/skin/iphone7/original/';
pathname = [path '*.dng'];
pathsmat = dir(pathname);
nfiles = length(pathsmat);
savepath = './dataset/skin/iphone7/patch/';
%% 

for num = 1:nfiles
    load (pathsmat(num).name)
    colors = checker2colors(raw, [4,6], 'allowadjust', true);
    save(pathsmat(num).name,'colors') % do it in directory you want to save
end
%% extract color patches from nikonD850 images
