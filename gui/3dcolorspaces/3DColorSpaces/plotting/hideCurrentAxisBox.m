function hideCurrentAxisBox(hide)

ax=get(gcf,'CurrentAxes');
if hide
    set(ax,'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1]); 
else
    set(ax,'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0]); 
end