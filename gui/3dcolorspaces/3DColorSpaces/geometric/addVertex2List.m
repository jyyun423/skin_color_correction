function [vlist,indxP11,vcounter] = addVertex2List(P11,vlist,vcounter)

if ~isempty(vlist)
    [isthere,indxP11]=ismember(P11,vlist,'rows');
else
    isthere = 0;
end
if ~isthere
    vcounter = vcounter+1;
    indxP11  = vcounter;
    vlist    = [vlist; P11];        
end    