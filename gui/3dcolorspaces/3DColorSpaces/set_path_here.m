close all;

restoredefaultpath;

thisScriptFullPath = mfilename('fullpath');
if isunix
    dirSep = '/';
else
    dirSep = '\';
end

rootFolder         = thisScriptFullPath(1:find(thisScriptFullPath==dirSep,1,'last'));
cd(rootFolder);    
addpath(genpath(rootFolder));

