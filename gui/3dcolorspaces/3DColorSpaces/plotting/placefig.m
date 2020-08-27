function placefig(fig,m,n,k, forcedW, forcedH, setVirtualScreenSize, ws,hs)
% PLACEFIG(fh,m,n,k,varargin) - puts figure fh in position k of a m x n array of figures on the screen.
% 
%   m x n picture matrix, set at location k, row-wise-counting
%         k (m=2,n=3)   x          y        
%         1  2  3       1  2  3    1   1   1
%         4  5  6       1  2  3    2   2   2
% 
%   PLACEFIG([],[],[],[], [], [], 1, w, h)
%   Set virtual screen size to w x h pixels. Call it before the ordinary placefig command.
% 
%   EXAMPLE: put figure to cover top half of the screen
%   figure(31);
%   placefig(31, 2,1,1);
% 
%   EXAMPLE: put figure to cover top/left quarter of the screen
%   placefig(31, 2,2,1);
% 
%   EXAMPLE: force figure size in pixels
%   placefig(31, 2,2,1,800,600)
% 
%   rev.2, Massimo Ciacci, Jan 01, 2016

persistent kFix
persistent virtualScreenSize

if ~ishandle(fig)
    return;
end

if isempty(fig)
    return;
end

figure(fig);

if nargin < 4
    error('too few arguments: placefig(fig,m,n,k,...)')
end
if isempty (kFix)
    kFix=1;
    virtualScreenSize.isset = false;
    virtualScreenSize.w     = 0;
    virtualScreenSize.h     = 0;
end

if exist('setVirtualScreenSize','var')
    if setVirtualScreenSize
        virtualScreenSize.isset = true;
        virtualScreenSize.w     = ws;
        virtualScreenSize.h     = hs;
    end
    return
end

if exist('forcedW','var') && exist('forcedH','var')
    forceSize = true;
    origfigpos=get(fig,'position');
    if forcedW < 0
        forcedW = origfigpos(3);
        forcedH = origfigpos(4);
    end
else
    forceSize = false;
end

if ~exist('k','var')
    k    = kFix;
    kFix = kFix+1;
end


k = mod(k-1,m*n)+1;

x = mod(k-1,n)+1; %x index
y = ceil(k/n);


if (virtualScreenSize.isset)
    w                = virtualScreenSize.w;
    h                = virtualScreenSize.h;
    dataCell         = num2cell(get(0,'ScreenSize'));
    [u1 u2 truew trueh] = deal(dataCell{:});
else
    dataCell    = num2cell(get(0,'ScreenSize'));
    [u1 u2 w h] = deal(dataCell{:});
    truew       = w;
    trueh       = h;
    
    mp = get(0, 'MonitorPositions');
    if size(mp,1) > 1
        
        try
            %use the smallest screen (multiple monitors detected)
            %         e.g.:
            %         mp =
            %         1281           1        2360        1920     %rightmost monitor
            %            1           1        1280        1024     %leftmost monitor
            %
            %         xOffset      yOffset    xEnd        yEnd
            scrsz1 = [1+(mp(1,3)-mp(1,1)),1+(mp(1,4)-mp(1,2))]; %1080 x 1920
            scrsz2 = [1+(mp(2,3)-mp(2,1)),1+(mp(2,4)-mp(2,2))]; %1280 x 1024
            
            %choose leftmost screen
            if mp(1,1) < mp(2,1)
                leftmost = scrsz1;
            else
                leftmost = scrsz2;
            end
            truew = leftmost(1);
            trueh = leftmost(2);
            w = truew;
            h = trueh;
            
        catch ME
            disp('Oh oh');
        end
    end
end

botMargin =  8;
topMargin =  8;
lftMargin =  8;
rgtMargin =  8;
disth     =  8;  %make sure  outsideTop does not heppen or this will be ignored !
distw     =  8;
% WinTitleHeight = 10; %let it happen, maximize figure size

if forceSize
    topMargin = 20;
    botMargin = 0;
    disth     = 0;
end

hTot      = h-botMargin-topMargin - (m-1)*disth;
wTot      = w-lftMargin-rgtMargin - (n-1)*distw;

hFig = floor(hTot/m) ;
wFig = floor(wTot/n) ;
hFig2= hFig +disth;
wFig2= wFig +distw;


%original figure size
fig_size = num2cell(get( gcf, 'Position' ));
[u1 u2 figw figh] = deal(fig_size{:});

diffh = 0;
if (forceSize)
    diffh = max(hFig-forcedH,0); %if height smaller get diff to align on top
    wFig = forcedW;
    hFig = forcedH;
end

%   x             y             k (m=2,n=3)
%
%   1  2  3       1   1   1     1  2  3    ^
%                                          | hTot
%   1  2  3       2   2   2     4  5  6    v
%

yBotLeftFig = (m-y)*hFig2+botMargin + diffh; %use calculated Fig sizes here
xBotLeftFig = (x-1)*wFig2+lftMargin; %use calculated Fig sizes here

yTop        = yBotLeftFig+hFig;
% outsideTop  = yTop + topMargin + WinTitleHeight - trueh;
outsideTop  = yTop + topMargin - trueh;
if (outsideTop>0)
    yBotLeftFig = yBotLeftFig-outsideTop;
end

xRight        = xBotLeftFig+wFig;
outsideRight  = xRight  - truew;
if (outsideRight>0)
    xBotLeftFig = xBotLeftFig-outsideRight;
end

set(gcf,'visible','off');
set(fig,'position',[xBotLeftFig, yBotLeftFig, wFig, hFig]);
set(gcf,'visible','on');

