%% convert raw datas to readable image data

clear, clc, close all
%% 

path = './dataset/iphone7/images/';
pathname = [path '*.DNG'];
pathsrawfiles = dir(pathname);
nfiles = length(pathsrawfiles);
%% 

% save DNG file as *.mat in same directory as DNG files
for num = 1:nfiles
    data = [path pathsrawfiles(num).name];
    matrawread(data);
end

%% 

dng = './dataset/iphone7/images/IMG_7952.DNG';
matrawread(dng);
imshow(raw);
%% 

raw = 'IMG_8097_xrite_st6.tif';
imshow(raw);