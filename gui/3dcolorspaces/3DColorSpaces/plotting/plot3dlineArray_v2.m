%allLines_X,allLines_Y,allLines_Z: [nlines x npoints] matrixes, containing  in each line the coordinates of its points
%allLines_X:  each row contains the x coordinates of 1 line
%allLines_Y:  each row contains the y coordinates of 1 line
%allLines_Z:  each row contains the z coordinates of 1 line
function pH = plot3dlineArray_v2(allLines_X,allLines_Y,allLines_Z,varargin)

% figure;setStdPlotStyle(); hold on;
pH=[];
for jj=1:12
    p=plot3(allLines_X(jj,:),allLines_Y(jj,:), allLines_Z(jj,:),varargin{:});
    pH=[pH,p];
end

% camproj ortho, rotate3d on; %axis equal