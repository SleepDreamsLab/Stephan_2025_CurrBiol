function [file_list, dir_list] = get_file_list(dirname,ext,filetype,foldertype)

if nargin < 2
    ext = '';
    filetype = 'char';
    foldertype = 'folder';
elseif nargin == 3
    foldertype = 'folder';
elseif nargin == 2
    filetype = 'char';
    foldertype = 'folder';
end

if strcmp(foldertype,'subfolders')
    temp = dir(fullfile(dirname,'**',ext));
else
    temp = dir([dirname ext]);
end
dir_list = [];
if ~isempty(temp)
    if strcmp(temp(1).name,'.'); f1 = 3; else; f1=1; end % remove . and ..
    allf={temp(:).name};
    fileidx = cellfun(@(a) strcmp(a(1),'.')==0,allf);
    file_list = allf(fileidx)';
    alld={temp(:).folder};
    dir_list = alld(fileidx)';
    if length(file_list) == 1 && strcmp(filetype,'char')
        file_list = file_list{1};
    end
else
    file_list = [];
end