%given 
%triangleV :  3 vertexes of a triangle, one per row
%Plane     :  a Plane [nx,ny,nz,dP] given by a normal n, and a const dP / {<(x,y,z)),n> == dP}
%finds the edge intersection (6 coord, 2 points) with given triangle
% 
%      \    
%       \
%        \    x p3      triangleV     = [p1,p2,p3]
%       PBo             EdgeIntersect = [PA,PB]
%  p1 x    \
%           oPA                
%            \
%        x p2 \ Plane
% 
function EdgeIntersect = intersectTrianglePlane(triangleV,Plane)
P1  = triangleV(1,:);
P2  = triangleV(2,:);
P3  = triangleV(3,:);

P12 = intersectEdgePlane([P1,P2],Plane); %--> empty
P13 = intersectEdgePlane([P1,P3],Plane); %--> PB
P23 = intersectEdgePlane([P2,P3],Plane); %--> PA

EdgeIntersect = [P12,P13,P23]; %most often one of these 3 is supposed to be empty
if length(EdgeIntersect)> 6  %in this case we got 3 non empty intersections, 2 must be the same
    if      all(P12==P13)
        EdgeIntersect = [P12,P23];
    elseif  all(P12==P23)
        EdgeIntersect = [P12,P13];        
    elseif  all(P13==P23)
        EdgeIntersect = [P12,P13];        
    else
        keyboard
        error('something weird happened');
    end
end