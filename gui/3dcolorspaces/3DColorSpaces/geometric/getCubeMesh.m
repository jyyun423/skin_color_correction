% construct a cubic mesh of size n x n, each of the 6 sides made of squares or triangles
% based on optional param meshType
% 
% vlist0, flist0 are the 6 cube outer faces 
% vlist1, flist1 are the R=1,G=1,B=1 faces 
% 
function [vlist0, flist0, vlist1, flist1] = getCubeMesh(n, meshType)

if nargin < 2
    meshType.form = 'rectangle';
%     meshType.form      = 'triangle';
%     meshType.leftright = 0;
end


[vlist, flist] = getRectangleMesh(n,n, meshType);

N = size(vlist,1);
%xy plane  (z=0,z=1) low,up
vlistXY_low   = [vlist,zeros(N,1)];
vlistXY_up    = [vlist,ones(N,1)];

%xz        (y=0,y=1) left,right
vlistXZ_left  = [vlist(:,1),zeros(N,1),vlist(:,2)];
vlistXZ_righ  = [vlist(:,1),ones(N,1),vlist(:,2)];
%yz        (x=0,x=1) back,front
vlistYZ_back  = [zeros(N,1),vlist];
vlistYZ_front = [ones(N,1),vlist];


vlist0 = [vlistXY_low; vlistXY_up; vlistXZ_left; vlistXZ_righ; vlistYZ_back; vlistYZ_front];
flist0 = [flist;       flist+N;   flist+2*N;    flist+3*N;    flist+4*N;    flist+5*N]; %% KEEP CONTINUITY IN 3D mappings


%now the outer planes only (for HSV 2D plot)
vlist1 = [vlistXY_up; vlistXZ_righ; vlistYZ_front];
flist1 = [flist;       flist+N;   flist+2*N]; %% KEEP CONTINUITY IN 3D mappings

