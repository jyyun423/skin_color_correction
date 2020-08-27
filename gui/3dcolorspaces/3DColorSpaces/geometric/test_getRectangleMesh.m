clear all; close all;

nx = 4;
ny = 2;


meshType.form      = 'rectangle'; %default = rectangle
[vlist, flist] = getRectangleMesh(nx, ny, meshType);

figure(1);setStdPlotStyle(); hold on;
p=patch('Vertices',vlist,'Faces',flist,'facecolor','w','edgecolor','k');
axis([-0.1 1.1 -0.1 1.1])
xlabel('x');ylabel('y');


meshType.form      = 'triangle';
% meshType.leftright = 0; ; %default = 0
[vlist, flist] = getRectangleMesh(nx, ny, meshType);

figure(2);setStdPlotStyle(); hold on;
p=patch('Vertices',vlist,'Faces',flist,'facecolor','w','edgecolor','k');
axis([-0.1 1.1 -0.1 1.1])
xlabel('x');ylabel('y');


meshType.form      = 'triangle';
meshType.leftright = 1;
[vlist, flist] = getRectangleMesh(nx, ny, meshType);

figure(3);setStdPlotStyle(); hold on;
p=patch('Vertices',vlist,'Faces',flist,'facecolor','w','edgecolor','k');
axis([-0.1 1.1 -0.1 1.1])
xlabel('x');ylabel('y');


placefig(1, 2,3, 1)
placefig(2, 2,3, 2)
placefig(3, 2,3, 3)


