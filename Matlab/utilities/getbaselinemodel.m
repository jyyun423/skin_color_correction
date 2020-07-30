function [csmat] = getbaselinemodel(profile)
xdoc = xmlread(profile);

dcpData = xdoc.getDocumentElement;
entries = dcpData.getChildNodes;
node = entries.getFirstChild;
clear xdoc dcpData entries

while ~isempty(node)
    if strcmpi(node.getNodeName, 'ColorMatrix1')
        break;
    else
        node = node.getNextSibling;
    end
end

temp = node.getTextContent;
temp = string(temp);
temp = split(temp);
temp = temp(2:10);
temp = double(temp);
temp = flip(temp);
temp = reshape(temp, 3,3);
csmat = temp;
end

