function drawNewAxis3DHideOrig_v2(xlen,ylen,zlen,hideOrig)
if nargin <4
    hideOrig=1;
end
if nargin <3
    try
        allAxes = findall(gcf,'type','axes');
        axNoLegendsOrColorbars= allAxes(~ismember(get(allAxes,'Tag'),{'legend','Colobar'}));
        hpl1 = findobj(axNoLegendsOrColorbars,'Type','line');
        hpl2 = findobj(axNoLegendsOrColorbars,'Type','patch');
        if isempty(hpl1)
            hpl = hpl2;
        else
            hpl = hpl1;
        end
        xx=get(hpl,'Xdata'); xlen=max(max(max(xx)));
        yy=get(hpl,'Ydata'); ylen=max(max(max(yy)));
        zz=get(hpl,'Zdata'); zlen=max(max(max(zz)));
        xlen = xlen*1.05;
        ylen = ylen*1.05;
        zlen = zlen*1.05;
        
    catch MSG
        MSG
        %         keyboard
    end
end

if hideOrig
    %hide original boxed axes (although box was off!)
    hideCurrentAxisBox(1);
end

delta=0.05;

plot3([0,xlen],[0,0]   ,[0,0],   'k','LineWidth',2);
plot3([0,0],   [0,ylen],[0,0],   'k','LineWidth',2);
plot3([0,0],   [0,0]   ,[0,zlen],'k','LineWidth',2); axis tight;
set(get(gca, 'XLabel'), 'Position',[(1+delta)*xlen  -delta*ylen    delta*zlen],'color',[0 0 0 ]);
set(get(gca, 'YLabel'), 'Position',[-delta*xlen   (1+delta)*ylen   delta*zlen],'color',[0 0 0 ]);
set(get(gca, 'ZLabel'), 'Position',[0     0   (1+delta)*zlen],'color',[0 0 0 ]);

% camproj ortho, rotate3d on, grid on
% rotate3d on, grid on
