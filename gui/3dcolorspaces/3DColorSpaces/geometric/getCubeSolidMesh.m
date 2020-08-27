% Whereas getCubeTrgMesh only provides the 6 sides of a cube (3 with constant V=255 and 3 with V=0)
% This function acts as a wrapper and provides K cubes
function [vlist, flist] = getCubeSolidMesh(n, meshType)

% n=2 : Main cube    [0               1  ]  n=1
% 
% n=2 : Main cube    [0      0.5      1  ]  n=2
% 
% n=3 : Main cube    [0 0.33     0.66 1  ]  n=3
%       Second cube  [  0.33     0.66    ]  n=1    L=1/3, Off=1/3
% 
% n=4 : Main cube    [0 0.25 0.5 0.75 1  ]  n=4
%       Second cube  [  0.25 0.5 0.75    ]  n=2    L=3/4, Off=1/4
% 
% n=5 : Main cube    [0 0.2  0.4  0.6  0.8   1 ]  n=5
%       Second cube  [  0.2  0.4  0.6  0.8     ]  n=3    L=4/5, Off=1/5
%       Third  cube  [       0.4  0.6          ]  n=1    L=1/5, Off=2/5

[vlist, flist] = getCubeMesh(n, meshType);
a = 0;
b = 1;
N = size(vlist,1);
for k=(n-2:-2:1)
    a=a+1/n;
    b=b-1/n;
    L = b-a;
    [vlist_i, flist_i] = getCubeMesh(k, meshType);
    vlist_i=vlist_i*L+a;
    flist_i=flist_i+N;
    N = N + size(vlist_i,1);
    vlist = [vlist;vlist_i];
    flist = [flist;flist_i];
end

