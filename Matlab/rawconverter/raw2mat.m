%% convert raw datas to readable image data
% first use dcraw to convert .NEF file to .tiff file
% dcraw -v -w -T <raw_file_name>
% dcraw -4 -D -T <raw_file_name>

clear, clc, close all
%% linearizing

black = 400;
saturation = 16383;
lin_bayer = double(indoor_dark-black);
lin_bayer = lin_bayer / (saturation-black);
lin_bayer = max(0,min(lin_bayer, 1));
%% white balancing

wb_multipliers = [1.870605 1 1.437988];
mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,'rggb');
balanced_bayer = lin_bayer .* mask;
%% demosaicing

temp = uint16(balanced_bayer/max(balanced_bayer(:))*2^16);
lin_rgb = double(demosaic(temp,'rggb'))/2^16;
%% brightness and gamma correction

grayim = rgb2gray(lin_rgb);
grayscale = 0.25/mean(grayim(:));
bright_rgb = min(1,lin_rgb*grayscale);
nl_rgb = bright_rgb.^(1/2.2);
%% 

imshow(lin_rgb)