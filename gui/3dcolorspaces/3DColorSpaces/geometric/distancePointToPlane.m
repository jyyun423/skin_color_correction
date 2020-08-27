%Plane a 4 entry vector(nx,ny,nz,dPlane) : Plane equation = set of points {Q=(x,y,z) / <Q,n> == dPlane}
%dist_P_FromPLane = <(P-Q),n>/|n| = (<P,n> - <Q,n>)/|n| = (<P,n> - dPlane)/|n|
%normalization to |n| is not necessary if it is about the sign of d
% function d = distancePointToPlane(P, Plane)
function d = distancePointToPlane(P, Plane)

if length(P)     ~= 3
    error();
end
if length(Plane) ~= 4
    error();
end

% Px      = P(1);
% Py      = P(2);
% Pz      = P(3);
% nx      = Plane(1);
% ny      = Plane(2);
% nz      = Plane(3);
% dPlane  = Plane(4);
% d = Px*nx + Py*ny + Pz*nz - dPlane;


d = sum(P.*Plane(1:3))-Plane(4);

