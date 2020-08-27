clear all;
close all;

n = 1;
meshType.form = 'triangle'; %Intersection with triangles is the only one we need and have
[vm, fm] = getCubeMesh(n,meshType);

figure(100);
Plot_Patch(vm,   fm,100,'EdgeColor','b'); view(-33, 20);

%intersect with plane x-y==0.5
Plane         = [1,-1,0,0.5];
% Plane         = [1,-1,0,0.25];
 
[Vertexes,Lines,Lengths] = intersectMeshPlane_v2(vm,fm,Plane);
Plot_Patch(Vertexes, Lines,100,'EdgeColor','r','LineWidth',2);
xlabel('x');ylabel('y');zlabel('z'); drawNewAxis3DHideOrig_v2(1.2,1.2,1.2, 0); grid off