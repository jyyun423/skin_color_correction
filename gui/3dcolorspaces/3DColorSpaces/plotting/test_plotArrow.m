close all
clear all



%% test 1: a 2D arrow point to point
% figure();
% p1 = [1,1];
% p2 = [0,2];
% L  = .5;
% alfa = 30/180*pi;
% plotArrow(p1,p2,L,alfa, 0);

%% test 2: N 2D arrows along a circle
figure(23);
aa1=linspace(0,2*pi,500);
plot(cos(aa1),sin(aa1),'k');
axis equal
hold on

N = 9;  %# arrows in total
L = .2; % arrow size, choose small wrt R (<= .2*R)
plotTipOnly = 0;

R = 1;
arrowAspectRatio1 = L/R
%if this > .2 arrow will look decentered too

alfa = 30/180*pi;
aa=linspace(0,2*pi,N+1);
for ii=1:N
    p1 = [cos(aa(ii)),sin(aa(ii))];

    %nice centering
    p2 = [cos(aa(ii)+atan(L)),sin(aa(ii)+atan(L))]; 

    %shortest segment before looks tangent inside
%     p2 = [cos(aa(ii)+pi/31),sin(aa(ii)+pi/31)]; 

    %longest segment before looks tangent outside
%     p2 = [cos(aa(ii)+pi/15),sin(aa(ii)+pi/15)]; 
    
    %this looks tangent inside, p1-p2 : too short wrt R
%     p2 = [cos(aa(ii)+pi/64),sin(aa(ii)+pi/64)]; 

    %this looks tangent outside, p1-p2 : too long wrt R
%     p2 = [cos(aa(ii)+pi/6),sin(aa(ii)+pi/6)]; 

    h=plotArrow(p1,p2,L,alfa, plotTipOnly);
    set(h,'color','r','linewidth',3);
end
arrowAspectRatio2 = L/sqrt(sum((p2-p1).^2))
%if this outside [0.9 .. 2] arrow will be tangent to circle

ok1 = arrowAspectRatio1 <= 0.2
ok2 = arrowAspectRatio2 >= .9 && arrowAspectRatio2 <= 2



%% test 3: N 3D arrows along a circle on a plane parallel to XY
figure(25);grid on; hold on;
z = 1;
aa1=linspace(0,2*pi,500);
plot3(cos(aa1),sin(aa1),z*ones(size(aa1)),'k');
axis equal; hold on

N = 9;  %# arrows in total
L = .15; % arrow size, choose small wrt R (<= .2*R)
plotTipOnly = 1;
tipParallelXY_OrthogonalXY = 1;

alfa = 60/180*pi;
aa=linspace(0,2*pi,N+1);
for ii=1:N
    p1 = [cos(aa(ii)),sin(aa(ii)),z];
    %nice centering
    p2 = [cos(aa(ii)+atan(L)),sin(aa(ii)+atan(L)),z]; 
    h=plotArrow(p1,p2,L,alfa, plotTipOnly,tipParallelXY_OrthogonalXY);
    set(h,'color','r','linewidth',3);
end
view(21,58)

%% test 4: same as 3 but tipParallelXY_OrthogonalXY = 0
figure(26);grid on; hold on;
plot3(cos(aa1),sin(aa1),z*ones(size(aa1)),'k');
axis equal; hold on

tipParallelXY_OrthogonalXY = 0;
for ii=1:N
    p1 = [cos(aa(ii)),sin(aa(ii)),z];
    %nice centering
    p2 = [cos(aa(ii)+atan(L)),sin(aa(ii)+atan(L)),z]; 
    h=plotArrow(p1,p2,L,alfa, plotTipOnly,tipParallelXY_OrthogonalXY);
    set(h,'color','r','linewidth',3);
end
view(13,20)


placefig(25,2,2,1)
placefig(26,2,2,2)
