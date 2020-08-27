% %% good for cube size n=17
% minDistDEG  = 2; %##################### mindist to filter out points too close to each other
% maxDistDEG  = 4;
% 
%% filter out too close by points and add missing ones; do not filter out corners
function [pList,cnt_Per_pts_kept,cnt_Per_pts_added] = makeUniformPerimeter(Vert_Perimeter,minDistDEG, maxDistDEG)



% 1) start from perimeter, make it a circular perimeter, last = first
Vert_Perimeter=[Vert_Perimeter;Vert_Perimeter(1,:)]; %make it circular

Np          = size(Vert_Perimeter,1);

midPt_abL   = mean(Vert_Perimeter,1);

diff1       =Vert_Perimeter-ones(Np,1)*midPt_abL; 
radii       =sqrt(sum(diff1.^2,2)); 
meanRadius  =mean(radii);
stepArcMinDistDEG = minDistDEG/180*pi*meanRadius;  % angleRadians * radius = arcLength
stepArcMaxDistDEG = maxDistDEG/180*pi*meanRadius;


P1prev                 = Vert_Perimeter(1,:);
cnt_Per_pts_kept = 1;
cnt_Per_pts_added= 0;


avgStep = meanRadius*2*pi/Np;
epsStep = avgStep/256;
% stepArcMinDistDEG
% stepArcMaxDistDEG

pList = P1prev;
cnt = 0;
for ip=2:Np-1

   P1 = Vert_Perimeter(ip,:);    

   t1 = Vert_Perimeter(ip,:)-Vert_Perimeter(ip-1,:);
   t2 = Vert_Perimeter(ip+1,:)-Vert_Perimeter(ip,:);
   iscorner = 0;
   if (sqrt(sum(t1.^2)) > epsStep) &&...  %avoid undetermined angles due to 0 length vectors
      (sqrt(sum(t2.^2)) > epsStep)
       thetaDEG2       = angDist2Vecs(t1, t2);           
       cnt = cnt+1;
       if abs(thetaDEG2) > 40 && abs(thetaDEG2) < 170 && cnt > 3
           cnt=0;
           iscorner = 1;
       end
   end
   
   %direct calc of angle P1-Pmid, Pprev-Pmid
   stepArc  = sqrt(sum((P1-P1prev).^2)); %traveled distance
   
   if (stepArc > stepArcMinDistDEG) || iscorner
        %check if need to INSERT a point in between
        if stepArc > stepArcMaxDistDEG
            Pnew                    = (P1prev+P1)/2;
            cnt_Per_pts_added = cnt_Per_pts_added+1;
            pList                   = [pList;Pnew];
        end
        %% insert current point
        P1prev                  = P1;    %for next iteration
        cnt_Per_pts_kept  = cnt_Per_pts_kept+1;
        pList = [pList;P1];
   end
end 


DEBUG = 0; %show how many lines were removed/added
% keyboard

if DEBUG
    Np1 = size(pList,1);    
    fprintf('PerimeterFix: Np=%d; Kept=%d, Added (interp) = %d,  Np1=%d \n', Np, cnt_Per_pts_kept, cnt_Per_pts_added, Np1);    

    %% check result

    % take center of gravity
    midPt_abL   = mean(Vert_Perimeter,1);

    figure(44); axis on;  hideCurrentAxisBox(0);
    view(0,90)
    placefig(44,1,1,1)
    for ii=1:Np
        P = Vert_Perimeter(ii,:);
        plot3(P(1),P(2),P(3),'b.');   
    %     segment0 = [midPt_abL;P];    
    end
    for ii=1:Np1
        P = pList(ii,:);
        plot3(P(1),P(2),P(3),'kd');   
        segment0 = [midPt_abL;P];
        plot3(segment0(:,1),segment0(:,2),segment0(:,3),'k');
    end
end