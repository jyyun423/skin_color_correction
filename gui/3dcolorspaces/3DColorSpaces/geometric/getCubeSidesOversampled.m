% getCubeSidesOversampled(1) returns 12 2-point lines (edges) , each line is a pair   of points {(P1x,P2x),(P1y,P2y),(P1z,P2z)}
% getCubeSidesOversampled(2) returns 12 3-point lines         , each line is a triple of points {(P1x,P2x,P3x),(P1y,P2y,P3y),(P1z,P2z,P3z)}
% oversampled line is useful to trace mapping to another space
function [allLines_Xcoord,allLines_Ycoord,allLines_Zcoord] = getCubeSidesOversampled(n, A)
%% Motivation: draw the 6 faces but only the 12 sides , but oversampled with n+1 points per side
% 
%      +- - - +
%    /    z / |
%  +- - - +   | y
%  |      |   +
%  |      | /
%x +- - - +

%right face (x=0):
%z=0; x=0;    / lower
%z=1; x=0;    / upper
%y=0; x=0;    / left
%y=1; x=0;    / right

%left  face (x=1)
%bot   face (z=0)
%top   face (z=1)
%front face (y=0)
%rear  face (y=1)
if nargin<2
    A=1;
end
%right face (x=0):
sweep = linspace(0,1,n+1);
line1_x = zeros(1,n+1);     line1_y = sweep;        line1_z = zeros(1,n+1); %z=0; x=0;    / bot
line2_x = zeros(1,n+1);     line2_y = sweep;        line2_z = ones(1,n+1);  %z=1; x=0;    / top
line3_x = zeros(1,n+1);     line3_y = zeros(1,n+1); line3_z = sweep;        %y=0; x=0;    / front
line4_x = zeros(1,n+1);     line4_y = ones(1,n+1);  line4_z = sweep;        %y=1; x=0;    / back

%bot face (z=0):
line5_x = ones(1,n+1);      line5_y = sweep;        line5_z = zeros(1,n+1); %left
line6_x = sweep;            line6_y = zeros(1,n+1); line6_z = zeros(1,n+1); %front
line7_x = sweep;            line7_y = ones(1,n+1);  line7_z = zeros(1,n+1); %back

%left face (x=1):
line8_x = ones(1,n+1);      line8_y = zeros(1,n+1); line8_z = sweep;        %front
line9_x = ones(1,n+1);      line9_y = sweep;        line9_z = ones(1,n+1);  %top
lineA_x = ones(1,n+1);      lineA_y = ones(1,n+1);  lineA_z = sweep;        %back

%top face (z=1)
lineB_x = sweep;            lineB_y = zeros(1,n+1); lineB_z = ones(1,n+1);  %front
lineC_x = sweep;            lineC_y = ones(1,n+1);  lineC_z = ones(1,n+1);  %back

allLines_Xcoord = A.*[line1_x;line2_x;line3_x;line4_x;line5_x;line6_x;line7_x;line8_x;line9_x;lineA_x;lineB_x;lineC_x];
allLines_Ycoord = A.*[line1_y;line2_y;line3_y;line4_y;line5_y;line6_y;line7_y;line8_y;line9_y;lineA_y;lineB_y;lineC_y];
allLines_Zcoord = A.*[line1_z;line2_z;line3_z;line4_z;line5_z;line6_z;line7_z;line8_z;line9_z;lineA_z;lineB_z;lineC_z];