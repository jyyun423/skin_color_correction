%given an Edge defined by 2 points, Edge=[P1,P2]
%and a Plane given by a normal n, and a const dPlane: Q=(x,y,z) / <Q,n> = dPlane
%finds the intersection P
function P = intersectEdgePlane(Edge,Plane)

if length(Edge) ~= 6
    error();
end

P1 = Edge(1:3);
P2 = Edge(4:6);
d1 = distancePointToPlane(P1, Plane);
d2 = distancePointToPlane(P2, Plane);
if d1*d2 > 0 %then both points are on same side of plane    
    P = [];
else
    if d1==0 && d2==0
        %the whole edge is on the plane! return no intersection, the other two edges of this triangle will have one point intersection anyways
        P = [];
    elseif d1==0
        P = P1;
    elseif d2==0
        P = P2;
    else
        % linePoint          == planePoint
        % P1+a*(P2-P1)       subst into <P,n> == dPlane
        %<P1+a*(P2-P1) , n > == dPlane
        %<P1,n> + a*<P2,n> - a*<P1,n> == dPlane    
        %(d1+dPlane) + a*(d2+dPlane) - a*(d1+dPlane) == dPlane        
        % d1 + dPlane + a*d2 + a*dPlane - a*d1 -a*dPlane == dPlane            
        % d1 + a*d2 - a*d1 == 0    --> a = d1/(d1-d2)
        a = d1/(d1-d2);
        P = P1 + a.*(P2-P1);
    end
end