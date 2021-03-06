%% apply to image

% load image file in matlab workspace and change its name to img
% image should be normalized if image class is either uint8 or uint16
switch class(img)
    case 'double'
        % do nothing
    case 'uint8'
        img = double(img) / (2^8 - 1);
    case 'uint16'
        img = double(img) / (2^16 - 1);
    otherwise
        error('The image class must be ''double'' or ''uint8'' or ''uint16''.');
end

% transpose color transform matrix is needed
% the matrix we've got contains column vectors of [r g b]
% we need row vectors of [r g b]
ct = W_f(:,:,5)';

% apply color matrix to image

corrected_img = applycmat(img, ct);
%% display corrected img

% if you want to display the output, 
% xyz to rgb color space transform is needed
rgb = xyz2rgb(corrected_img, 'WhitePoint', 'd50');
imshow(rgb)
%% extract skin color

% change the layout according to the number of skin color patch in image
skincolors = checker2colors(corrected_img, [4,1], 'allowadjust', true, 'colorfun', 'mean');
