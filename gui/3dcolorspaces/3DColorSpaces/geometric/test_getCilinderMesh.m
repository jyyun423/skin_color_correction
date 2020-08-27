close all;
clear all;

meshType.form = 'rectangle';
[vlist, flist] = getCilinderMesh(360/30,10,10, meshType);

figure(1);setStdPlotStyle(); hold on;
patch('Vertices',vlist,'Faces',flist, 'facecolor','w','facealpha',0.8); 
axis([-1.1 1.1 -1.1 1.1 -0.1 1.1])
axis equal
view(55,24)


meshType.form = 'triangle';
[vlist, flist] = getCilinderMesh(360/30,10,10, meshType);

figure(2);setStdPlotStyle(); hold on;
patch('Vertices',vlist,'Faces',flist, 'facecolor','w','facealpha',0.8); 
axis([-1.1 1.1 -1.1 1.1 -0.1 1.1])
axis equal
view(55,24)

placefig(1, 2,3, 1)
placefig(2, 2,3, 2)