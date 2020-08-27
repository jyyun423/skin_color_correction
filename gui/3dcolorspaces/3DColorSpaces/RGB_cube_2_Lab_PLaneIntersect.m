% STUDY Lab section plane at constant L,
% and how it maps to RGB cube
clear all;
close all;

meshType.form = 'triangle'; %must be triangle

set(0,'DefaultFigureRenderer','opengl')


%% choose params
% L_section = 60; 
L_section = [32, 53, 74];
% L_section = [32, 53, 60, 91];
% L_section = [32, 53, 87]; %<-- %pure B,R,G
% L_section = [60 91 96]; % pure M C Y

% WR_RGBint_2_Lab([255,0,0;0,255,0;0,0,255; 255,255,0; 255,0,255; 0,255,255])
% ans =
%    53.2329   80.1053   67.2228  R
%    87.7370  -86.1884   83.1861  G
%    32.3026   79.1936 -107.8537  B
%    97.1382  -21.5608   94.4877  Y
%    60.3199   98.2497  -60.8330  M
%    91.1165  -48.0840  -14.1278  C
   

Plot_IntersectionGrid = 0;
gridCol               = [1,1,1]*0.8; %'k';
faceAlphaIntersect    = 0.85;

facealpha             = 1; %0.94; Since 2014b falcelapha seems to mess up depth ?
colPathcSpec          = {'FaceColor','interp','edgecolor','none','facealpha',facealpha};
hideAxis              = 1;


viewRGB  = [106,42];
viewabL  = [45,16];


%% make an oversampled cube : triangular meshes on each face
%% =========================================================
%nRGB = # samlpe points per side of RGB cube: (nRGB+1)^2*6 vertexes in total
nRGB = 12;
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
patch('Vertices',vmRGBint,'Faces',fm, 'FaceVertexCData',vmRGBint/255, colPathcSpec{:});
axis equal, camproj ortho, rotate3d on
xlabel('R');ylabel('G');zlabel('B'); drawNewAxis3DHideOrig_v2(DD,DD,DD,  hideAxis);
view(viewRGB);


%% CONVERT to Lab XYZ xyY
%% =========================================================
%convert vertex coordinates to Lab 
vmLab  = WR_RGBint_2_Lab(vmRGBint); %vmRGBint is companded space RGB cube 6 surfaces in [0..1]

vm_abL = [vmLab(:,2:3),vmLab(:,1)];      %reorder vertex coordinates as (a,b,L)

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



% ============================================================================================================================
%% COMPUTE INTERSECTIONS Lab with constant L plane and map back to RGB (some more fancy stuff)
% ============================================================================================================================
%% ===============================
%% Now only the sides in RGB
%% ===============================
[allLines_R,allLines_G,allLines_B] = getCubeSidesOversampled(nRGB,255);
f33=figure(33);setStdPlotStyle(); hold on;
plot3dlineArray_v2(allLines_R,allLines_G,allLines_B,'color','k');
camproj ortho; axis equal;
xlabel('R');ylabel('G');zlabel('B'); drawNewAxis3DHideOrig_v2(255,255,255, hideAxis * 0);
view(viewRGB);

%add them to figure 11
set(0,'CurrentFigure',11)
plot3dlineArray_v2(allLines_R,allLines_G,allLines_B,'color','w');


%% ===============================
%% CONVERT RGB sides to Lab
%% =========================================================
%convert vertex coordinates to Lab
[nlines,npts] = size(allLines_R);
allLines_a = zeros(nlines,npts);allLines_b = zeros(nlines,npts);allLines_L = zeros(nlines,npts);
for iline = 1:nlines
    for ipt = 1:npts
        rgbVec = [allLines_R(iline,ipt),allLines_G(iline,ipt),allLines_B(iline,ipt)];
        [LAB] = WR_RGBint_2_Lab(rgbVec);
        allLines_a(iline,ipt) = LAB(2);
        allLines_b(iline,ipt) = LAB(3);
        allLines_L(iline,ipt) = LAB(1);
    end
end
% a_range = [min_a,max_a]
% b_range = [min_b,max_b]
%Plot Add these Lab sides in white to Lab solid
set(0,'CurrentFigure',22)
pH = plot3dlineArray_v2(allLines_a,allLines_b,allLines_L,'color','w');
camproj ortho


f44=figure(44);setStdPlotStyle(); hold on;
plot3dlineArray_v2(allLines_a,allLines_b,allLines_L,'color','k');
camproj ortho
xlabel('a');ylabel('b');zlabel('L'); drawNewAxis3DHideOrig_v2(128,128,140, hideAxis * 0);
view(viewabL);


%% constant L secions in Lab
for pp=1:length(L_section)
    
    L_section_this = L_section(pp);
    
    %Intersect RGB edges mapped to Lab with a plane BETA at constant L in abL
    %we obtain a perimeter curve (1D in 3D)    
    Plane_BETA_abL           = [0,0,1,L_section_this];
    [Vertexes_sBETA_abL,Lines_sBETA_abL]     = intersectMeshPlane_v2(vm_abL, fm, Plane_BETA_abL);

    %% color the plane on Lab space...
    % inputs:
    % Vertexes_sBETA_abL : coordinate of points on intersection plane , perimeter of surface on solid boundaries
    % Lines_sBETA_abL    : indexes of lines [i1,i2] between two points
    %                      discarded, since we build a 2D mesh from perimeter
    
    %% =======================================================
    %% construct a mesh inside the perimeter
    %% creates internal uniform points from boundary intersection
    %% =======================================================
    minDistDEG =  5; %skip radii closer than this
    maxDistDEG = 10; %add radii when smaller than this
    [vlist_abL,flist] = perimeter_2_mesh(Vertexes_sBETA_abL,minDistDEG, maxDistDEG);
    
    if Plot_IntersectionGrid
        %plot mesh as lines
        Plot_Patch(vlist_abL, flist,44,'EdgeColor',gridCol,'LineWidth',1);
    else        
        set(0,'CurrentFigure',44)
    end
    
    %plot colored patch in abL
    vlistLab = [vlist_abL(:,3),vlist_abL(:,1),vlist_abL(:,2)]; % reorder abL to Lab
    vlistRGBint = XYZ_2_RGBint(Lab_2_XYZ(vlistLab));              % map back intersection to RGB for cData
    p=patch('Vertices',vlist_abL,'Faces',flist, 'FaceVertexCData',vlistRGBint/255,'FaceColor','interp','EdgeColor','none');
    set(p,'facealpha',faceAlphaIntersect);
    axis normal; axis([-128 128 -128 128 0 140])
    view(viewabL);
    
    
    %% plot mapped back intersection to RGB space
    Vertexes_sBETA_abL      = vlist_abL;
    Lines_sBETA_abL         = flist;
    Vertexes_sBETA_Lab_2RGBint = vlistRGBint;
    % % Vertexes_sBETA_abL : coordinate of points on intersection plane , perimeter of surface on solid boundaries
    % % Lines_sBETA_abL    : indexes of lines [i1,i2] between two points
    if Plot_IntersectionGrid
        Plot_Patch(Vertexes_sBETA_Lab_2RGBint, Lines_sBETA_abL,33,'EdgeColor',gridCol,'LineWidth',1);
    else
        
        set(0,'CurrentFigure',33)
    end
    %plot colored patch in RGB
    p=patch('Vertices',Vertexes_sBETA_Lab_2RGBint,'Faces',flist, 'FaceVertexCData',Vertexes_sBETA_Lab_2RGBint/255,'FaceColor','interp','EdgeColor','none');
    set(p,'facealpha',faceAlphaIntersect);    
    view(viewRGB);
    
end

set([f10 f11 f12 f22 f33 f44], 'menubar', 'none');
set([f10 f11 f12 f22 f33 f44], 'toolbar', 'none');

placefig(f12,2,3,4); placefig(f44,2,3,5); placefig(f22,2,3,6);
placefig(f10,2,3,1); placefig(f33,2,3,2); placefig(f11,2,3,3);

pause(0.1)
linkRotations( [f12  f22 f44] );
linkRotations( [f10  f11 f33] );
