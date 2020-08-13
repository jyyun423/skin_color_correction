function [shading_removed_img] = rmshading(gray_patch, img)

shading_removed_img = img / gray_patch;

end

