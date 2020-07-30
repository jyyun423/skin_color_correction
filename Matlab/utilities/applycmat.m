function [applied_img] = applycmat(img,cmat)
% CORRECTED = apply_cmatrix(IM,CMATRIX)
%
% Applies CMATRIX to RGB input IM. Finds the appropriate weighting of the
% old color planes to form the new color planes, equivalent to but much
% more efficient than applying a matrix transformation to each pixel.

if size(img,3)~=3
    error('Apply color space transform to RGB image only.')
end

r = cmat(1,1)*img(:,:,1)+cmat(1,2)*img(:,:,2)+cmat(1,3)*img(:,:,3);
g = cmat(2,1)*img(:,:,1)+cmat(2,2)*img(:,:,2)+cmat(2,3)*img(:,:,3);
b = cmat(3,1)*img(:,:,1)+cmat(3,2)*img(:,:,2)+cmat(3,3)*img(:,:,3);

applied_img = cat(3,r,g,b);
end
