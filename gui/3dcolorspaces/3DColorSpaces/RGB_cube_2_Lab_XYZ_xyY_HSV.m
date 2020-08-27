clear all;
close all;

meshType.form = 'rectangle';
% meshType.form = 'triangle';

set(0,'DefaultFigureRenderer','opengl')

viewRGB  = [119,38];
viewabL  = [45,28];
% viewXYZ  = [128,30];
viewXYZ  = [61,24];
% viewxyY  = [0,90];
viewxyY  = [14,54];
viewHSV  = [0 90];

facealpha    = 1; %0.94; Since 2014b facelapha messes up depth ?
% colPathcSpec = {'FaceColor','interp','edgecolor','none','facealpha',facealpha};
% colPathcSpec = {'FaceColor','interp','edgecolor',[135 170 190]/255,'linestyle',':','facealpha',facealpha};
colPathcSpec = {'FaceColor','interp','edgecolor',[128 128 128]/255,'linewidth',.15,'facealpha',facealpha};
hideAxis     = 1;

%% make an oversampled cube : triangular meshes on each face
%% =========================================================
%nRGB = # samlpe points per side of RGB cube: (nRGB+1)^2*6 vertexes in total
nRGB = 6;
% nRGB = 12;
% nRGB = 17;

%% get unit cube faces
[vm, fm, vm1,fm1] = getCubeMesh(nRGB, meshType);

%scale to 0..255
vmRGBint = vm*255;
vm1RGBint= vm1*255;

% PLOT GRIDLINES RGB CUBE
% +++++++++++++++++++++++
DD=1.05*255;
f10=figure(10);setStdPlotStyle();hold on;
Plot_Patch(vmRGBint, fm, 10); 
axis equal
xlabel('R');ylabel('G');zlabel('B'); drawNewAxis3DHideOrig_v2(DD,DD,DD,  hideAxis);
view(viewRGB);

% PLOT Solid RGB CUBE
% #######################
f11=figure(11);setStdPlotStyle();hold on;
p=patch('Vertices',vmRGBint,'Faces',fm, 'FaceVertexCData',vmRGBint/255, colPathcSpec{:});
axis equal, camproj perspective, rotate3d on
xlabel('R');ylabel('G');zlabel('B'); drawNewAxis3DHideOrig_v2(DD,DD,DD,  hideAxis);
view(viewRGB);


%% CONVERT to Lab XYZ xyY
%% =========================================================
%convert vertex coordinates to Lab XYZ xyY
[vmXYZ, vmLab, vmxyY] = WR_RGBint_2_XYZ_xyY_Lab(vmRGBint); %vmRGBint is companded space RGB cube 6 surfaces in [0..1]

vm_abL = [vmLab(:,2:3),vmLab(:,1)];      %reorder vertex coordinates as (a,b,L)

% normalize XYZ so as to make a section with X+Y+Z = 1;
ref_max_XYZ = [95.05 100 108.90];
vmXYZ_norm = vmXYZ;
vmXYZ_norm(:,1) = vmXYZ(:,1)./ref_max_XYZ(1);
vmXYZ_norm(:,2) = vmXYZ(:,2)./ref_max_XYZ(2);
vmXYZ_norm(:,3) = vmXYZ(:,3)./ref_max_XYZ(3);

% PLOT GRIDLINES LAB : [0..100], [-86.1846 .. 98.2542], [-107.863..94.4824]
% +++++++++++++++++++++++
f12=figure(12);setStdPlotStyle();hold on;
Plot_Patch(vm_abL, fm, 12);
xlabel('a');ylabel('b');zlabel('L'); drawNewAxis3DHideOrig_v2(128,128,130, hideAxis);
axis normal; axis([-128 128 -128 128 0 140]);
view(viewabL);

% PLOT SOLID LAB
% #######################
f22=figure(22);setStdPlotStyle();hold on;
p=patch('Vertices',vm_abL,'Faces',fm, 'FaceVertexCData',vmRGBint/255, colPathcSpec{:});
xlabel('a');ylabel('b');zlabel('L'); drawNewAxis3DHideOrig_v2(128,128,130, hideAxis);
axis normal; axis([-128 128 -128 128 0 140])
view(viewabL);


% hideAxis=0;
% PLOT GRIDLINES XYZ  [0..95.05],[0..100],[0..108.90]
% +++++++++++++++++++++++
f13=figure(13);setStdPlotStyle();hold on;
Plot_Patch(vmXYZ, fm, 13);
xlabel('X');ylabel('Y');zlabel('Z'); drawNewAxis3DHideOrig_v2(128,128,130, hideAxis);
axis equal; axis([-10 128 -10 128 0 140]);
view(viewXYZ);


% PLOT SOLID XYZ 
% #######################
f23=figure(23);setStdPlotStyle();hold on;
p=patch('Vertices',vmXYZ,'Faces',fm, 'FaceVertexCData',vmRGBint/255, colPathcSpec{:});
xlabel('X');ylabel('Y');zlabel('Z'); drawNewAxis3DHideOrig_v2(128,150,130, hideAxis);
axis equal; axis([-10 128 -10 128 0 140]);
view(viewXYZ);


hideAxis=0;
% PLOT GRIDLINES xyY [0.150..0.640], [0.060..0.600], [0..100]
% +++++++++++++++++++++++
f14=figure(14);setStdPlotStyle();hold on;
Plot_Patch(vmxyY, fm, 14);
xlabel('x');ylabel('y');zlabel('Y'); drawNewAxis3DHideOrig_v2(0.7,0.7,100, hideAxis);
axis normal; axis([-0.2 0.8 -0.2 0.8 0 140]);
view([15,22]);


% PLOT SOLID xyY 
% #######################
f24=figure(24);setStdPlotStyle();hold on;
p=patch('Vertices',vmxyY,'Faces',fm, 'FaceVertexCData',vmRGBint/255, colPathcSpec{:});
set(p,'FaceAlpha',1) %no transparency here...
xlabel('x');ylabel('y');zlabel('Y'); drawNewAxis3DHideOrig_v2(0.7,0.7,110, hideAxis);
axis([-0.1 0.8 -0.1 0.8 0 140]);
view(viewxyY);

%replicate figure once again with a 2D view (from top)
f25=figure(25);setStdPlotStyle();hold on;
p=patch('Vertices',vmxyY,'Faces',fm, 'FaceVertexCData',vmRGBint/255, colPathcSpec{:});
set(p,'FaceAlpha',1) %no transparency here...
xlabel('x');ylabel('y');zlabel('Y'); drawNewAxis3DHideOrig_v2(0.7,0.7,110, hideAxis);
axis([-0.1 0.8 -0.1 0.8 0 140]);
view(0,90);




%% CONVERT to HSV, 2D disc (3 outer faces of RGB cube -> top face HSV)
%% =========================================================
hsvValMax   = 224; %choose Value constant value to be displayed

%% use outer RGB cube planes (i.e. skip those containing val< max) --> get a disc V=Vmax
vm_RGBint_constV = vm1RGBint./255.*hsvValMax; % vmRGBint are RGB in [0..255], 
                                              % vm_RGBint_constV are scaled to [0...Vmax]

vmHSVpc  =  RGBint_2_HSVpc_HSLpc(vm_RGBint_constV);   %convert vertex coordinates to HSV

%HSV disc vertexes, Cartesian coordinates
vmHSVpc_cart = HSVpolar_to_cartesian( vmHSVpc );


% PLOT GRIDLINES HSV
% +++++++++++++++++++++++
f102=figure(102);setStdPlotStyle();hold on;
Plot_Patch(vmHSVpc_cart, fm1, 102);
addCircularLabels_HSV_HSL();
axis normal equal 
view(viewHSV); title('HSV image of RGB cube')




% PLOT colored HSV DISK (top surface)
% #######################
f202=figure(202);setStdPlotStyle();hold on; axis off;
p=patch('Vertices',vmHSVpc_cart,'Faces',fm1, 'FaceVertexCData',vm_RGBint_constV/255, colPathcSpec{:});
% ax=gca;
addCircularLabels_HSV_HSL();
% axis(ax);
axis normal equal off 
rotate3d off
% hideCurrentAxisBox(1);
view(viewHSV); title(sprintf('HSV; V=%d (%2.1f%%)',round(hsvValMax),hsvValMax/255*100))

% return
placefig(202,2,3,4)
placefig(24,2,3,5)
placefig(25,2,3,6)

placefig(11,2,3,1)
placefig(23,2,3,2)
placefig(22,2,3,3)



