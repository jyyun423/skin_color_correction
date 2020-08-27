clear all;
close all;

n=2;
[allLines_Xcoord,allLines_Ycoord,allLines_Zcoord] = getCubeSidesOversampled(n);
figure;setStdPlotStyle(); hold on;
for jj=1:12
    plot3(allLines_Xcoord(jj,:),allLines_Ycoord(jj,:), allLines_Zcoord(jj,:),'-o');
end
view(-33, 20)
camproj ortho, rotate3d on
axis equal