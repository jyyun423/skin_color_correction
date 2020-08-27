% Construct a 2D rectangular mesh of size nx x ny, made of n^2 squares or 2*n*n triangles
% Inputs:
% ------
% nx,ny : nr of subdivisions along x and y
%
% meshType: structure specifying the form of the mesh
% meshType.form      = ['rectangle'|'triangle']
% meshType.leftright = for 'triangle' form specifies orientation of triangles
%
% Triangular mesh is computationally simpler than rectangular, and is useful
% in computing intersections in 3D with less effort
% Moreover it better exploits a fixed nr of vertexes into smaller sub-areas,
% resulting in better fill ratio / aliasing effects, when handling difficult shapes
% 
% Outputs:
% -------
% vlist : a matrix with a 2D coordinate (x,y) of each vertex per row
% flist : a matrix with the indexes of the faces into vlist
%
% e.g. meshType.form = 'rectangle'
% connect a 4 vertex square into 4 squares (nx=ny==2)
%           1 +-----+-----+ 4
%             |     |     |
%             |     |     |                   C     D
%         m/n +<----+---->+         n=2       |     |     |
%             |     |     |                   |     |     |
%             |     |     |                   |     |     |
%           2 +-----+-----+ 3                A+-----+B----+
%                   k/n                      k,n
%                                     n = 1, 2, 3 , 4
%vlist = list of vertexes  : K1 x 2   K1 = 4, 9, 16, 25   = (n+1)^2
%flist = list of rectangles: K2 x 4   K2 = 1, 4,  9, 16   = n^2   (indexes into vertex list)
%
% e.g. meshType.form = 'triangle'
% connect a 4 vertex square into 8 triangles
%           1 +-----+-----+ 4
%             | \   | \   |                                     ACB,BCD (leftright=1, as in the figure)
%             |   \ |   \ |                   C     D           ADB,DAC (leftright=0)
%         m/n +<----+---->+         n=2       |\  b | \   |
%             | \   |\    |                   |  \  |  \  |
%             |   \ |  \  |                   | a  \|    \|
%           2 +-----+-----+ 3                A+-----+B----+
%                   k/n                      k,n
%constructs a 2D square mesh of size n x n, made of 2*n*n triangles
%                                     n = 1, 2, 3 , 4
%vlist = list of vertexes  : K1 x 2   K1 = 4, 9, 16, 25   = (n+1)^2
%flist = list of triangles : K2 x 3   K2 = 2, 8, 18, 32   = n^2 * 2  (indexes into vertex list)
%
function [vlist, flist] = getRectangleMesh(nx,ny, meshType)
% No default meshType at this level, leave it one level higher
% if nargin < 3
%     %     meshType.form = 'rectangle';
%     meshType.form      = 'triangle';
%     meshType.leftright = 0;
% end

if ~isstruct(meshType)
    error('meshType needs to have at least one field, meshType.form ');
end

% vm = [0 0 0  ; 1 0 0  ; 1 1 0  ; 0 1 0  ];  %4 vertexes on z==0

%vlist = [0 0  ; 1 0 ; 1 1 ; 0 1 ];
vlist = [];
flist = [];
vcounter = 0;

if strcmp(meshType.form,'rectangle')
    
    
    for k = 0:nx-1
        for m = 0:ny-1
            %1 square, (ABCD); 4 vertexes A,B,C,D
            Ax = k;   Ay=m;
            Bx = k+1; By=m;
            Cx = k;   Cy=m+1;
            Dx = k+1; Dy=m+1;
            
            %add (k,n) vertex to list
            [vlist,indxA,vcounter] = addVertex2List([Ax/nx,Ay/ny],vlist, vcounter);
            [vlist,indxB,vcounter] = addVertex2List([Bx/nx,By/ny],vlist, vcounter);
            [vlist,indxC,vcounter] = addVertex2List([Cx/nx,Cy/ny],vlist, vcounter);
            [vlist,indxD,vcounter] = addVertex2List([Dx/nx,Dy/ny],vlist, vcounter);
            flist = [flist; indxA indxC indxD indxB];
        end
    end
    
elseif strcmp(meshType.form,'triangle')
    if ~isfield(meshType,'leftright')
        meshType.leftright = 0;
    end
    
    for k = 0:nx-1
        for m = 0:ny-1
            %2 triangles, a(ACB),b(BCD); 4 vertexes A,B,C,D
            Ax = k;   Ay=m;
            Bx = k+1; By=m;
            Cx = k;   Cy=m+1;
            Dx = k+1; Dy=m+1;
            
            %add (k,n) vertex to list
            [vlist, indxA,vcounter] = addVertex2List([Ax/nx,Ay/ny],vlist, vcounter);
            [vlist, indxB,vcounter] = addVertex2List([Bx/nx,By/ny],vlist, vcounter);
            [vlist, indxC,vcounter] = addVertex2List([Cx/nx,Cy/ny],vlist, vcounter);
            [vlist, indxD,vcounter] = addVertex2List([Dx/nx,Dy/ny],vlist, vcounter);
            if meshType.leftright  % \ ACB
                flist = [flist; indxA indxC indxB];
                flist = [flist; indxB indxC indxD];
            else                   % / ADB
                flist = [flist; indxA indxD indxB];
                flist = [flist; indxD indxA indxC];
            end
        end
    end
else
    error('invalid meshType.form param');
end
