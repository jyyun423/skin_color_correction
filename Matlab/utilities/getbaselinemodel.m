function [cstmat] = getbaselinemodel(xml)

xdoc = xmlread(xml);

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

tmp = node.getTextContent;
tmp = split(string(tmp));
ccmat = tmp(~strcmp(tmp,""));
clear tmp ans node

ccmat = flip(ccmat);
ccmat = reshape(str2double(ccmat),3,[])';

cstmat = ccmat;

end

