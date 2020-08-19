%% extract color patches from images

clear, clc, close all
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
%% 

colors = checker2colors(indoor001, [4,6], 'allowadjust', true);
save('colors') % do it in directory you want to save