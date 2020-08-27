function setStdPlotStyle()

%set(gca,'FontSize',14); set(gca,'FontName','Times'); set(gcf,'Color',[0.95,0.95,0.95]); grid on;
%set(gca,'FontSize',14); set(gca,'FontName','Times'); set(gcf,'Color',[1,1,1]);

set(gca,'FontSize',16); set(gca,'FontName','Times'); set(gcf,'Color',[1,1,1]);
% 
% xlabel(' ','FontSize',16,'FontName','Times');
% ylabel(' ','FontSize',16,'FontName','Times');

set(0,'defaultaxesfontname','Times'); %use set(gcf,...) iso set(0,...) to change only current plot
set(0,'defaultaxesfontsize',16);

v = version('-release'); vn=str2double(v(1:4))*10+(v(5)-'a')+1;
if vn>=20142 %>= 2014b
    str1 = sprintf('Fg.%d',get(gcf,'Number'));
else
    str1 = sprintf('Fg.%d',gcf);    
end
set(gcf,'Numbertitle','off','Name',str1);
set(gca,'Layer','top') % without this Matlab 2014b openGl has problems with patches!





%Tips and tricks:

%set(gca, 'LooseInset', get(gca,'TightInset'))  ;%REDUCE WHITE SPACE AROUND FIGURES
% subplot('position',[0.025 0.025 0.95 0.95]); %remove ugly white space, beginx, bginy, widthx, widthy in percent
% subplot('position',[0.1 0.1 0.9 0.9]); %remove ugly white space, beginx, bginy, widthx, widthy in percent

%this trick to reduce white spaces between subplots
% t = 0:0.001:2*pi+0.001;
% figure(2);
% for i = 1 : 25;
%     subaxis(5,5,i, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
%     plot(t, sin(i*t));
%     axis tight
%     axis off
% end
