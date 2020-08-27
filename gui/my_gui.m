function varargout = my_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @my_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @my_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%default
function varargout = my_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function popupmenu1_Callback(hObject, eventdata, handles)

function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu2_Callback(hObject, eventdata, handles)

function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%
global sRGB_Values;
sRGB_Values= [...
[115,82,68];[194,150,130];[98,122,157];...
[87,108,67];[133,128,177];[103,189,170];...
[214,126,44];[80,91,166];[193,90,99];...
[94,60,108];[157,188,64];[224,163,46];...
[56,61,150];[70,148,73];[175,54,60];...
[231,199,31];[187,86,149];[8,133,161];...
[243,243,242];[200,200,200];[160,160,160];...
[122,122,121];[85,85,85];[52,52,52]];
%%
%%my functions
function myImage = selectimg()
[filename, pathname] = uigetfile({'*.jpg';'*.bmp'},'File Selector');
directory = strcat(pathname, filename);
myImage=imread(directory);

function xyz = convRGB2xyz(RGB)
XYZ=rgb2xyz(RGB);
sum=XYZ(:,1)+XYZ(:,2)+XYZ(:,3);
x=XYZ(:,1)./sum;
y=XYZ(:,2)./sum;
z=1-x-y;
xyz=cat(2,x,y,z);

function color=extract24from_colorchecker(img)
color=[];    
dx=fix(size(img,1)/4);
dy=fix(size(img,2)/6);
start=[fix(dx/2), fix(dy/2)];
for r=0:3
    for c=0:5
        tmp=squeeze(img(start(1)+r*dx, start(2)+c*dy, :))';
        color=[color;tmp];
    end
end

function comparegt_xyY(a, b)
global sRGB_Values; %sRGB values should be added sts
gt=convRGB2xyz(sRGB_Values);
a=convRGB2xyz(a);
b=convRGB2xyz(b);
X0=squeeze(gt(:,1))';
Y0=squeeze(gt(:,2))';
X1=squeeze(a(:,1))';
X2=squeeze(b(:,1))';
Y1=squeeze(a(:,2))';
Y2=squeeze(b(:,2))';
figure;
plotChromaticity();
hold on;
scatter(gt(:,1),gt(:,2), 'k');
c=cellstr(num2str([1:24]'));
dd=0.015;
text(gt(:,1)+dd,gt(:,2),c);
plot([X0; X1], [Y0; Y1],'b-', 'LineWidth', 2);   
plot([X0; X2], [Y0; Y2],'r-', 'LineWidth', 2);
title(['Comparison between original(blue) and destination(red)' ]);

function xyz=plotpointsxyz(sRGB)
len=size(sRGB,1);
xyz=convRGB2xyz(sRGB);
figure;
plotChromaticity();
hold on
scatter(xyz(:,1),xyz(:,2), 'k');
c=cellstr(num2str([1:len]'));
dd=0.01;
text(xyz(:,1)+dd,xyz(:,2)+dd,c);
hold off

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function my_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
enabletable(handles,  false );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function selectimg_Callback(hObject, eventdata, handles)
enabletable(handles, false);
%clc;clear all;
[filename, pathname] = uigetfile({'*.jpg';'*.bmp'},'File Selector');
handles.myImage = strcat(pathname, filename);
global AAA;
AAA=imread(handles.myImage);
axes(handles.img1);
imshow(handles.myImage)
guidata(hObject,handles);
set(handles.text4,'string',filename);

function comparing_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.jpg';'*.bmp'},'File Selector');
handles.myImage = strcat(pathname, filename);
global BBB;
BBB=imread(handles.myImage);
axes(handles.img2);
imshow(handles.myImage)
guidata(hObject,handles);
set(handles.text5,'string',filename);

function arr=readtable(handles)
    arr=get(handles.uitable1, 'data');


function convert_Callback(hObject, eventdata, handles)
contents2=cellstr(get(handles.popupmenu2,"String"));
val2=contents2(get(handles.popupmenu2, "Value"));
contents3=cellstr(get(handles.popupmenu3,"String"));
val3=contents3(get(handles.popupmenu3, "Value"));
global AAA;
data=0;
if(strcmp(val3,"img")) %if img mode
    if(strcmp(val2,"CIE xyY"))
        axes(handles.img2);
        data=rgb2xyz(AAA);
        imshow(data);
    elseif(strcmp(val2,"CIE LAB"))
        axes(handles.img2);
        data=rgb2lab(AAA);
        imshow(data);
    end 
else %if pixel mode
    data=str2double(readtable(handles));
    n=0;
    for i=1:7
        if(data(i, 1)<256 &&data(i, 2)<256 &&data(i, 3)<256) n=n+1;
        else break; end
    end
    if(n<1) return; end
    if(strcmp(val2,"CIE xyY"))
        display_table(handles, data(1:n,:), convRGB2xyz(data(1:n,:)));
        set(handles.uitable1, 'columnname', {'R', 'G', 'B'});
        set(handles.uitable2, 'columnname', {'x', 'y', 'Y'});
    elseif(strcmp(val2,"CIE LAB"))
        display_table(handles, data(1:n,:), rgb2lab(data(1:n,:)./255));
        set(handles.uitable1, 'columnname', {'R', 'G', 'B'});
        set(handles.uitable2, 'columnname', {'L', 'A', 'B'});
    end
end

%guidata(hObject,handles);


function display_table(handles, a, b)
    set (handles.uitable1,'ColumnWidth', {60,60,60});
    set (handles.uitable2,'ColumnWidth', {60,60,60});
    set(handles.uitable1, "Data", num2cell(a));
    set(handles.uitable2, "Data", num2cell(b));

% --- Executes on button press in compare.
function compare_Callback(hObject, eventdata, handles)
global AAA;
global BBB;
contents2=cellstr(get(handles.popupmenu2,"String"));
val2=contents2(get(handles.popupmenu2, "Value"));

if(get(handles.radiobutton1, "Value")) %if convert mode
    m1="Select pixels to convert, and press Enter after choosing all";
    string = sprintf('%s', m1);
    set(handles.messages, 'String', string);
    
    figure; imshow(AAA);
    RGB_pixel_values=impixel; close;
    if(strcmp(val2,"CIE xyY"))
        xyz_pixel_values=plotpointsxyz(RGB_pixel_values);
        display_table(handles, RGB_pixel_values,xyz_pixel_values);
        set(handles.uitable1, 'columnname', {'R', 'G', 'B'});
        set(handles.uitable2, 'columnname', {'x', 'y', 'Y'});
    elseif(strcmp(val2,"CIE LAB"))
        lab_pixel_values=rgb2lab(RGB_pixel_values./255);
        display_table(handles, RGB_pixel_values,lab_pixel_values);
        set(handles.uitable1, 'columnname', {'R', 'G', 'B'});
        set(handles.uitable2, 'columnname', {'L', 'a', 'b'});
    end
elseif(get(handles.radiobutton2, "Value"))%if compare mode
    color1=extract24from_colorchecker(AAA);
    color2=extract24from_colorchecker(BBB);
    if(strcmp(val2,"CIE xyY"))
        %show results on gamut
        comparegt_xyY(color1, color2);
        display_table(handles, convRGB2xyz(color1),convRGB2xyz(color2));
        set(handles.uitable1, 'columnname', {'x', 'y', 'z'});
        set(handles.uitable2, 'columnname', {'x', 'y', 'z'});
    elseif(strcmp(val2,"CIE LAB"))
        %show_table_xyz(handles, RGB_pixel_values,xyz_pixel_values);
    end
end
    
    


%%
%radio buttons
% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
set(handles.uitable1,'ColumnEditable',true(1,3))
if(get(handles.radiobutton1, 'Value'))
    set(handles.radiobutton2, 'Value', 0);
end
set(handles.comparing,'Enable','off');
set(handles.convert,'Enable','on');
set(handles.popupmenu3,'Enable','on');

m1="In Converting Mode, you can: ";
m2="1. convert a RGB image (by 'Select Original Img'), or ";
m3="2. convert manually set RGB values (by 'Edit Table')";
m4="to a designated color space ";
m5="3. select pixels on the image to convert ('Compare Pixels')";

string = sprintf('%s%s%s%s%s', m1, m2, m3, m4, m5);
set(handles.messages, 'String', string);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
if(get(handles.radiobutton2, 'Value'))
    set(handles.radiobutton1, 'Value', 0);
end
set(handles.comparing,'Enable','on');
set(handles.convert,'Enable','off');
set(handles.popupmenu3,'Enable','off');

m1="In Comparing Mode, you can: ";
m2="Select two color checker images(by 'Select Original Img', 'Select Comparing Img')";
m3="and compare 24 colors in xyY color space('Compare Pixels')";
string = sprintf('%s%s%s%s\n', m1, m2, m3);
set(handles.messages, 'String', string);


function enabletable(handles, bool )
set (handles.uitable1,'ColumnWidth', {60,60,60});
set (handles.uitable2,'ColumnWidth', {60,60,60});    
set (handles.uitable1,'Data',cell(7,3));
set (handles.uitable2,'Data',cell(7,3));
set(handles.uitable1,'ColumnEditable',bool);
set(handles.uitable2,'ColumnEditable',bool);

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Function not for use
function uitable1_CellEditCallback(hObject, eventdata, handles)

function uitable1_CreateFcn(hObject, eventdata, handles)

function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function radiobutton1_CreateFcn(hObject, eventdata, handles)
function radiobutton2_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
enabletable(handles, true);
m1="Input rgb values by editing the table on the left ";
m2="They will be converted to the designated color space";
m3="Press enter after editing each cell";
string = sprintf('%s%s%s%s\n', m1, m2, m3);
set(handles.messages, 'String', string);
