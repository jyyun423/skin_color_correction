% Construct a planar mesh inside a given 3D perimeter contained within a plane.
% Useful to create internal uniform points from boundary intersection.
% The perimeter should be contained in a plane in order to prevent geometric distortions.
% 
% METHOD:
% ------
% 1) The mid point is computed
% 2) a radius from perimeter vertex to center is divided in equal parts
%    new vertex are added accordingly
% 3) A number of triangles (flist) define the mesh surface, together with the vertexes (Vert_tMesh)
% 
% INPUTS:
% -------
% Vert_Perimeter = each row a vertex on the perimeter
%                  the rows should be sorted in order of angular proximity (angle)
% minDistDEG     = avoid (discard) points closer than this
% maxDistDEG     = interpolate points when 
% 
% OUTPUTS:
% -------
% Vert_tMesh     = matrix of vertexes including internal points to perimeter
% flist          = list of faces (triangles) i.e. triplets of indexes in Vert_tMesh
function [Vert_tMesh,flist] = perimeter_2_mesh(Vert_Perimeter,minDistDEG, maxDistDEG)

% 1) filter out too close by points and add missing ones

% Np = size(Vert_Perimeter,1);
[pList_abL,c1,c2] = makeUniformPerimeter(Vert_Perimeter, minDistDEG, maxDistDEG);
Np1 = size(pList_abL,1);


%build 2D mesh, fixed L
pList_abL = [pList_abL;pList_abL(1,:)];
Np1       = Np1+1;
midPt     = mean(pList_abL,1);
Vert_tMesh     = midPt; 
indxm     = 1;
vcounter  = 1;
flist     = [];
a=1/3;b=2/3;
for ip=1:Np1-1
    P0 = pList_abL(ip,:);
    P1 = pList_abL(ip+1,:); 
    P12= ((1-a)*midPt+a*P1);
    P02= ((1-a)*midPt+a*P0);    
    P11= ((1-b)*midPt+b*P1);
    P01= ((1-b)*midPt+b*P0);
    
%            P12     P11
%             -+-----+---------+ P1
%        ----/
%    m +-------+-----+---------+  P0
%            P02     P01

    %put vertexes into list
    [Vert_tMesh,indxP02,vcounter] = addVertex2List(P02,Vert_tMesh,vcounter);    
    [Vert_tMesh,indxP12,vcounter] = addVertex2List(P12,Vert_tMesh,vcounter);
    %mid triangle
    flist = [flist; indxm,   indxP02, indxP12,];
    
    
    [Vert_tMesh,indxP01,vcounter] = addVertex2List(P01,Vert_tMesh,vcounter);    
    [Vert_tMesh,indxP11,vcounter] = addVertex2List(P11,Vert_tMesh,vcounter);
    
    %2 adj triangles
    flist = [flist; indxP02, indxP01, indxP11];
    flist = [flist; indxP02, indxP11, indxP12]; 
    
    [Vert_tMesh,indxP0,vcounter] = addVertex2List(P0,Vert_tMesh,vcounter);    
    [Vert_tMesh,indxP1,vcounter] = addVertex2List(P1,Vert_tMesh,vcounter);
    
    %2 adj triangles    
    flist = [flist; indxP01, indxP0,  indxP1];
    flist = [flist; indxP01, indxP1,  indxP11];
    
end
