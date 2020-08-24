%% apply to image

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
%% 

% if you want to display the output, 
% xyz to rgb color space transform is needed
rgb = xyz2rgb(corrected_img, 'WhitePoint', 'd50');
imshow(rgb)
