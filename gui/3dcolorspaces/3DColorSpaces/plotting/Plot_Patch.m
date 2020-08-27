%just a wrapper of patch
function Plot_Patch(vlist, flist, varargin)

fN = [];
if mod(length(varargin),2)
    fN = varargin{1};
    varargin = varargin(2:end);
end

if ~sum(strcmp(varargin,'FaceColor'))
    varargin = [varargin,'FaceColor','none'];
end

if isempty(fN)
    figure;setStdPlotStyle();
else
    set(0,'CurrentFigure',fN)
end
hold on;

patch('Vertices',vlist,'Faces',flist, 'FaceVertexCData',vlist,varargin{:});    
rotate3d on

% draw the patches with color
% f=figure;setStdPlotStyle();hold on;
% patch('Vertices',vlist,'Faces',flist, 'FaceVertexCData',vlist,'FaceColor','flat');
% xlabel('r');ylabel('g');zlabel('b');view(135,38);
% shading interp;
% axis equal; camproj perspective, rotate3d on



