clear all; close all;

% n = 1;
% n = 2;
% n = 3;
% n = 4;
n = 5;

meshType.form = 'rectangle';

% 1 outer shell only
[vlist, flist] = getCubeMesh(n,meshType);

figure(1)
patch('Vertices',vlist,'Faces',flist, 'facecolor','w','facealpha',0.85); 
axis([-0.1 1.1 -0.1 1.1 -0.1 1.1]); axis equal
xlabel('r');ylabel('g');zlabel('b'); view(55,24)

% 2 inner shells too
[vlist, flist] = getCubeSolidMesh(n,meshType);

figure(2)
patch('Vertices',vlist,'Faces',flist, 'facecolor','w','facealpha',0.5); 
axis([-0.1 1.1 -0.1 1.1 -0.1 1.1]); axis equal
xlabel('r');ylabel('g');zlabel('b'); view(55,24)


meshType.form      = 'triangle';

% 1 outer shell only
[vlist, flist] = getCubeMesh(n,meshType);

figure(3)
patch('Vertices',vlist,'Faces',flist, 'facecolor','w','facealpha',0.85); 
axis([-0.1 1.1 -0.1 1.1 -0.1 1.1]); axis equal
xlabel('r');ylabel('g');zlabel('b'); view(55,24)

% 2 inner shells too
[vlist, flist] = getCubeSolidMesh(n,meshType);

figure(4)
patch('Vertices',vlist,'Faces',flist, 'facecolor','w','facealpha',0.5); 
axis([-0.1 1.1 -0.1 1.1 -0.1 1.1]); axis equal
xlabel('r');ylabel('g');zlabel('b'); view(55,24)
    
placefig(3, 2,3, 4)
placefig(4, 2,3, 5)
placefig(1, 2,3, 1)
placefig(2, 2,3, 2)

linkRotations([1 2 3 4]); rotate3d on