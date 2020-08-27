%construct a cilinder mesh R=1; H=1;
% 
function [vlist, flist] = getCilinderMesh(na, nr, nh, meshType)
if nargin < 4
    meshType.form = 'rectangle';
%     meshType.form      = 'triangle';
%     meshType.leftright = 0;
end

aa = linspace(0,2*pi,na+1); % # radii = # angles na

tIdx = 0; %how many triangles are present so far
vlist=[];
flist=[];

% construct generating triangle for cicles
[vlist0, flist0] = getRectangleMesh(nr, 1, meshType);
m      = size(vlist0,1);  %# vertexes
%convert this rectangle to a circular sector
r   = vlist0(:,1);
phi = vlist0(:,2)*2*pi/na;
x   = r.*cos(phi);
y   = r.*sin(phi);
circSector = [x,y];

%% top circle
z  = 1;
for ia = 1:na
    phi = aa(ia);
    rotMat = [cos(phi),-sin(phi); sin(phi),cos(phi)];
    vlistNew = (rotMat*circSector.').';
    
    vlist = [vlist;[vlistNew,z*ones(m,1)]];
    flist = [flist;flist0+tIdx];    
    tIdx = tIdx+m;            %add # vertexes to counter    
end


%% bottom circle
z  = 0;
for ia = 1:na
    phi = aa(ia);    
    rotMat = [cos(phi),-sin(phi); sin(phi),cos(phi)];
    vlistNew = (rotMat*circSector.').';
    
    vlist = [vlist;[vlistNew,z*ones(m,1)]];
    flist = [flist;flist0+tIdx];    
    tIdx = tIdx+m;            %add # vertexes to counter    
end

%% side

% alfa, z square mesh na x nh
[vlistStripe, flistStripe] = getRectangleMesh(na, nh, meshType);
vlistStripe(:,1) = vlistStripe(:,1)*2*pi;

%make it a [0..2pi] x [0..1] stripe in alfa,z
alfa = vlistStripe(:,1);
z    = vlistStripe(:,2);
x    = cos(alfa);
y    = sin(alfa);
vlistSide = [x,y,z];

%merge it with proper indexes in flist
NV1    = size(vlist,1);
vlist = [vlist; vlistSide];
flist = [flist; flistStripe+NV1];  
    



