close all
clear all
clc

set(0,'DefaultFigureRenderer','opengl')
opengl hardware

meshType.form = 'rectangle';
% meshType.form = 'triangle';

viewRGB         = [110,24];
viewHSV         = [15 45];
viewHSL         = [15 45];
facealpha       = 1; %0.94; In Matlab 2014b facealpha gone?
hideAxis        = 1;

max_V = 100*7/8; 
max_L = 60;

nRGB  = 8; %nr pts in each RGB axis
nH    = 24; %nr of angles = nr hues in HSV,HSL

colPathcSpecNoEdge  = {'FaceColor','interp','edgecolor','none','facealpha',facealpha};
colPathcSpecYesEdge = {'FaceColor','interp','edgecolor','k','facealpha',facealpha,'linewidth',.5};

%% make a SOLID RGB CUBE
%% =========================
% [vlistCube01, flistCube01] = getCubeSolidMesh(nRGB); %Full solid rgb 0..1
[vlistCube01, flistCube01] = getCubeMesh(nRGB,meshType); %outer surface rgb 0..1
vlistRGBint = vlistCube01*255*max_V/100;

strMaxV=sprintf(' - maxV=%2.1f%%',max_V);
f1033=figure(1033);setStdPlotStyle();hold on;
p=patch('Vertices',vlistRGBint,'Faces',flistCube01, 'FaceVertexCData',vlistRGBint/255, colPathcSpecYesEdge{:});
setAxisRGBcube(viewRGB,hideAxis);
title(['\bf{RGB cube : FIX V}',strMaxV])

%% Map Cube to HSV / HSL
% PLOT solid HSL / HSV VOLUME maps
[vmHSVpc,vmHSLpc]  =  RGBint_2_HSVpc_HSLpc(vlistRGBint);   %convert vertex coordinates to HSV
maxL = max(vmHSLpc(:,3));
strMaxL=sprintf(' - maxL=%2.1f%%',maxL);

[ vmHSV_cart ] = HSVpolar_to_cartesian( vmHSVpc );
[ vmHSL_cart ] = HSVpolar_to_cartesian( vmHSLpc );


f103=figure(103);setStdPlotStyle();hold on;
p=patch('Vertices',vmHSV_cart,'Faces',flistCube01, 'FaceVertexCData',vlistRGBint/255, colPathcSpecYesEdge{:});
setAxisHSVcilinder(viewHSV,'V',max_V, hideAxis)
title('HSV image of RGB cube')

f203=figure(203);setStdPlotStyle();hold on;
p=patch('Vertices',vmHSL_cart,'Faces',flistCube01, 'FaceVertexCData',vlistRGBint/255, colPathcSpecYesEdge{:});
setAxisHSVcilinder(viewHSL,'L',max_L, hideAxis)
title(['HSL image of RGB cube',strMaxL])


%% make a solid HSV cilinder
%% =========================
[vlist_4_HSV, flistHSV] = getCilinderMesh(nH,nRGB,nRGB, meshType); %unit dimensions here
vlist_4_HSV(:,3)        = vlist_4_HSV(:,3)*max_V;  %scale Value
strMaxV=sprintf(' - maxV=%2.1f%%',max_V);

% map to color space polar coordinates
[ vlistHSV ]            = HSVcartesian_to_polar( vlist_4_HSV );

% map HSV coord to RGB to give color.. and for later
vlistRGBint_fromHSV     = HSVpc_2_RGBint(vlistHSV);

f1035=figure(1035);setStdPlotStyle();hold on;
p=patch('Vertices',vlist_4_HSV,'Faces',flistHSV, 'FaceVertexCData',vlistRGBint_fromHSV/255, colPathcSpecYesEdge{:});
setAxisHSVcilinder(viewHSV,'V',max_V, hideAxis)
title(['\bf{HSV cilinder : FIX V}',strMaxV])

%% Map HSV Cilinder to RGB (we just did that)
f105 = figure(105);setStdPlotStyle();hold on;
p=patch('Vertices',vlistRGBint_fromHSV,'Faces',flistHSV, 'FaceVertexCData',vlistRGBint_fromHSV/255, colPathcSpecYesEdge{:});
setAxisRGBcube(viewRGB,hideAxis);
title(['RGB image of HSV cilinder',strMaxV])

%% Map HSV cilinder to HSL
[~,vmHSLpc1]      =  RGBint_2_HSVpc_HSLpc(vlistRGBint_fromHSV);   %convert vertex coordinates to HSV
[ vmHSLpc1_cart ] = HSVpolar_to_cartesian( vmHSLpc1 );

f205=figure(205);setStdPlotStyle();hold on;
p=patch('Vertices',vmHSLpc1_cart,'Faces',flistHSV, 'FaceVertexCData',vlistRGBint_fromHSV/255, colPathcSpecYesEdge{:});
setAxisHSVcilinder(viewHSL,'L',max_L, hideAxis)
title(['HSL image of HSV cilinder',strMaxL])


%% make a solid HSL cilinder
%% =========================
[vlist_4_HSL, flistHSL] = getCilinderMesh(nH,nRGB,nRGB,meshType); %unit dimensions here
vlist_4_HSL(:,3)        = vlist_4_HSL(:,3)*max_L;  %scale Lightness
strMaxL=sprintf(' - maxL=%2.1f%%',max_L);

% map to color space polar coordinates
[ vlistHSL ]            = HSVcartesian_to_polar( vlist_4_HSL );

% map HSL coord to RGB to give color.. and for later
vlistRGBint_fromHSL     = HSLpc_2_RGBint(vlistHSL);

f1037=figure(1037);setStdPlotStyle();hold on;
p=patch('Vertices',vlist_4_HSL,'Faces',flistHSL, 'FaceVertexCData',vlistRGBint_fromHSL/255, colPathcSpecYesEdge{:});
setAxisHSVcilinder(viewHSL,'L',max_L, hideAxis)
title(['\bf{HSL cilinder : FIX L}',strMaxL])

%% Map HSV Cilinder to RGB (we just did that)
f107 = figure(107);setStdPlotStyle();hold on;
p=patch('Vertices',vlistRGBint_fromHSL,'Faces',flistHSL, 'FaceVertexCData',vlistRGBint_fromHSL/255, colPathcSpecYesEdge{:});
setAxisRGBcube(viewRGB,hideAxis);
title(['RGB image of HSL cilinder',strMaxL])


%% Map HSL cilinder to HSV
[vmHSVpc2,vmHSLpc2]      =  RGBint_2_HSVpc_HSLpc(vlistRGBint_fromHSL);   %convert vertex coordinates to HSV
[ vmHSVpc2_cart ] = HSVpolar_to_cartesian( vmHSVpc2 );

f207=figure(207);setStdPlotStyle();hold on;
p=patch('Vertices',vmHSVpc2_cart,'Faces',flistHSL, 'FaceVertexCData',vlistRGBint_fromHSL/255, colPathcSpecYesEdge{:});
setAxisHSVcilinder(viewHSV,'V',max_V, hideAxis)
title(['HSV image of HSL cilinder',strMaxL])

%bottom row
placefig(f107,3,3,7); placefig(f207,3,3,8); placefig(f1037,3,3,9);
placefig(f105,3,3,4); placefig(f1035,3,3,5); placefig(f205,3,3,6);
placefig(f1033,3,3,1); placefig(f103,3,3,2); placefig(f203,3,3,3);

pause(0.1)

linkRotations( [203  205 1037] )
linkRotations( [103  207 1035] )
linkRotations( [1033 105 107] )