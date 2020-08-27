function h = plotArrow(p1,p2,L,alfa, plotTipOnly, tipParallelXY_OrthogonalXY)
% p1,p2 2D coordinates
% L = length of |p2-pA| = |p2-pB|, same units as p1,p2
% a = arrow aperture angle, between p2-pA and p2-pB
%               x pA
%                 \
% p1 +-------------+ p2
%                 /
%               x pB

if nargin < 5
    plotTipOnly = 0;
end
if nargin < 6
    tipParallelXY_OrthogonalXY = 1;
end
alfa = min(alfa, pi/2); %90 DEG at most

if length(p1) ==2
    %2D, p1=[p1x,p1y]
    p2mp1 = p2-p1;
    beta  = atan2(p2mp1(2),p2mp1(1));
    pAx   = p2(1) + L*cos(pi-alfa/2+beta);
    pAy   = p2(2) + L*sin(pi-alfa/2+beta);
    pBx   = p2(1) + L*cos(pi-alfa/2-beta);
    pBy   = p2(2) - L*sin(pi-alfa/2-beta);
    if ~plotTipOnly
        h1=line([p1(1),p2(1)],[p1(2),p2(2)]);
    else
        h1=[];
    end
    h2=line([p2(1),pAx],[p2(2),pAy]);
    h3=line([p2(1),pBx],[p2(2),pBy]);
    h = [h1,h2,h3];
elseif length(p1) == 3
    if (p1(3)~=p2(3))
        error('p1-p2 not parallel fo XY plane, not implemented');
    else
        z=p1(3);
    end
    if tipParallelXY_OrthogonalXY
        %3D, p1=[p1x,p1y,z], tip parallel to XY plane
        p2mp1 = p2-p1;
        beta  = atan2(p2mp1(2),p2mp1(1));
        pAx   = p2(1) + L*cos(pi-alfa/2+beta);
        pAy   = p2(2) + L*sin(pi-alfa/2+beta);
        pBx   = p2(1) + L*cos(pi-alfa/2-beta);
        pBy   = p2(2) - L*sin(pi-alfa/2-beta);
        if ~plotTipOnly
            h1=line([p1(1),p2(1)],[p1(2),p2(2)],[p1(3),p2(3)]);
            resetColor()
        else
            h1=[];
        end
        h2=line([p2(1),pAx],[p2(2),pAy],[p2(3),z]);
        resetColor()
        h3=line([p2(1),pBx],[p2(2),pBy],[p2(3),z]);
        resetColor()
    else
        %3D, p1=[p1x,p1y,z], tip orthogonal to XY plane
        p2mp1 = p2-p1;
        L12   = sqrt(sum((p2-p1).^2));
        pAx   = p2(1) - L*cos(alfa/2)*p2mp1(1)/L12;
        pAy   = p2(2) - L*cos(alfa/2)*p2mp1(2)/L12;
        pBx   = pAx;
        pBy   = pAy;
        pAz   = z+L*sin(alfa/2);
        pBz   = z-L*sin(alfa/2);
        
        if ~plotTipOnly
            h1=line([p1(1),p2(1)],[p1(2),p2(2)],[p1(3),p2(3)]);
            resetColor()
        else
            h1=[];
        end
        h2=line([p2(1),pAx],[p2(2),pAy],[p2(3),pAz]);
        resetColor()
        h3=line([p2(1),pBx],[p2(2),pBy],[p2(3),pBz]);        
        resetColor()
    end
    h = [h1,h2,h3];
    
end

function resetColor()
ax=gca;
if isprop(ax,'ColorOrderIndex'), set(ax,'ColorOrderIndex',1); end
