function setAxisRGBcube(viewRGB, hideAxis)
axis normal equal, camproj ortho; 
axis([-0.1 1.1 -0.1 1.1 -0.1 1.1]*255); 
xlabel('R');ylabel('G');zlabel('B');

if hideAxis
    DD = 260;
    drawNewAxis3DHideOrig_v2(DD,DD,DD);
end


view(viewRGB); rotate3d on; 

%make sure titles are visible
set(gca,'Position', [0.13 0.1 0.775 0.75])

% % don't, else title will start rotating with patch..
% th=get(gca,'title');
% tpos=get(th,'position');
% set(th,'position',tpos+[0 0 0.1*tpos(3)])

