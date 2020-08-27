function addCircularLabels_HSV_HSL(h)
if nargin < 1
    h=1;
end
%% add circular labels
phis = (0:30:330);
R1 = 1; R2 = 1.05; R3 = 1.15;
for ii=1:length(phis)
    a = phis(ii)/180*pi;
    x = cos(a);
    y = sin(a);
    plot3([R1,R2]*x,[R1,R2]*y,[1 1]*h,'k','linewidth',2);
%     text(R3*x*(1.1-0.1*cos(a))-.02,R3*y*(1+0.0*abs(sin(a))),h,sprintf('%d',phis(ii)));


   th= text(R3*x, R3*y,h,sprintf('%d',phis(ii)));
   set(th,'HorizontalAlignment','center')
   

end

end

