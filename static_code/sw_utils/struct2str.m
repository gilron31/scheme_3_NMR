function [ ret ] = struct2str( strct )
cel = struct2cell(strct);
fields = fieldnames(strct);
si = size(cel);
cel = reshape(cel,si(1),si(2));
strs = '';
for ind = 1:length(cel)
    thisstr = fields(ind);
    text2 = char(thisstr);
    text1 = mat2str(cell2mat(cel(ind)));
    thisstr = [text2 ': ' text1];
    strs = [strs thisstr char(10)];
end
ret = strs;
ret(find(ret=='_')) = ' ' ;
end

