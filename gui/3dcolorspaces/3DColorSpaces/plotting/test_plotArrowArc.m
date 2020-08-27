close all
figure; hold on; axis equal

%draw a pi/4 sector on z=1
line([0 1 0],[0,0 0],[1 1 1]); line([0,sqrt(2)/2,0],[0,sqrt(2)/2,0],[1 1 1]);
% a circle
plotArrowArc(1,     0, 2*pi, 1,  'notip','linewidth',1,'color','k'); 
% three arrowed arcs length pi/4
plotArrowArc(.5,    0, pi/4, 1, 'linewidth',2,'color','k'); 
plotArrowArc(.75,pi/4, 2*pi, 1,'linestyle','-.'); 
plotArrowArc(.62,pi/4,    0, 1); 

% 
% 
% figure; hold on; axis equal
% % draw a circle
% plotArrowArc(1,     0, 2*pi, 1,  'notip','linewidth',1,'color','k'); 
% % draw two arrowed arcs length pi/4
% plotArrowArc(.5,    0, pi/4, 1, 'linewidth',2); 
% plotArrowArc(.62,pi/4,    0, 1, 'linestyle','-.'); 
