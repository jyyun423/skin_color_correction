function [ h ] = plotArrowArc( arcR, aStart, aEnd, z , varargin)
%PLOTARROWARC Summary of this function goes here
%   Detailed explanation goes here
% Plots an arc on a plane Z=z cnetered aroun the z axis,
% with radius arcR, beginning at position R,aStart to R,aEnd
%
% Special varargin in first position
% 'noTip' : plots only the arc, without arrow
%
% Example:
%
% figure; hold on; axis equal
% % draw a circle
% plotArrowArc(1,     0, 2*pi, 1,  'notip','linewidth',1,'color','k');
% % draw two arrowed arcs length pi/4
% plotArrowArc(.5,    0, pi/4, 1, 'linewidth',2);
% plotArrowArc(.62,pi/4,    0, 1, 'linestyle',':');

%check argument noTip if any
if isempty(varargin)
    noTip = 0;
else
    noTip = strcmp(varargin{1},'noTip') ||  strcmp(varargin{1},'notip');
    if noTip, varargin = varargin(2:end); end
end

aa1   = linspace(aStart,aEnd,100);
resetColor()
h1    = plot3(arcR*cos(aa1),arcR*sin(aa1),z*ones(size(aa1)));
resetColor()

p2    = [arcR*cos(aEnd),arcR*sin(aEnd),z];
aSign = sign(aEnd-aStart); if aSign==0,aSign=1;end
da    = pi/30; % (pi/15..pi/31) else tip looks tangent on one side
p1    = [arcR*cos(aEnd-da*aSign),arcR*sin(aEnd-da*aSign),z];

if ~noTip
    %     L     = .15*arcR; % arrow size, choose small wrt R (<= .2*R)
    %     alfa  = 60/180*pi;
    L     = .1*arcR; % arrow size, choose small wrt R (<= .2*R)
    alfa  = 40/180*pi;
    tipParallelXY_OrthogonalXY = 1;
    h2    = plotArrow(p1,p2,L,alfa, 1,tipParallelXY_OrthogonalXY);
else
    h2 = [];
end

hT = [h1,h2];
if ~isempty(varargin)
    set(hT,varargin{:});
end
if nargout > 0
    h=hT;
end

end


function resetColor()
ax=gca;
if isprop(ax,'ColorOrderIndex')
    set(ax,'ColorOrderIndex',1)
end
end