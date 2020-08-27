function linkRotations( figArray )
%LINKROTATIONS Summary of this function goes here
%   Detailed explanation goes here

N=length(figArray);
axL = [];
for ii=1:N
    ff = figArray(ii);
    thisAxes = findall(ff,'type','axes','Visible','on');
    axL = [axL,thisAxes(end)];
end

hlink = linkprop(axL,{'CameraPosition','CameraUpVector','CameraTarget'});
key = 'graphics_linkprop';
setappdata(axL(1),key,hlink);% Store link object on first axes

