function setAxisHSVcilinder(viewHSV,Zlab,ZlabHeight,hideAxis)

addCircularLabels_HSV_HSL(ZlabHeight);
camproj ortho;
axis([-1.3 1.3 -1.3 1.3 -0.1 101]);
zlabel(Zlab);

%xlabel('s*cos(h)');ylabel('s*sin(h)');  %ugly

% axis square  ;
set(gca,'DataAspectRatio',[1 1 100])

% if hideAxis
%     drawNewAxis3DHideOrig_v2(1.2,1.2,130);
%     set(get(gca, 'ZLabel'),'color',[0 0 1])
% end

set(gca,'xtick',[],'ytick',[])
ax=get(gcf,'CurrentAxes');
set(ax,'XColor',[1 1 1],'YColor',[1 1 1]);  %hide x,y axis


% add a circular hue label
aStart = 0/180*pi;
aEnd   = 75/180*pi;
R = 1.2;
text(1.08*R*cos(aEnd),1.08*R*sin(aEnd),ZlabHeight,'H','fontsize',14);
plotArrowArc( R, aStart, aEnd, ZlabHeight , 'color','k','linewidth',1)
grid on
view(viewHSV); rotate3d on

%make sure titles are visible
set(gca,'Position', [0.13 0.1 0.775 0.75])

