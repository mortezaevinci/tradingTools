function structarray = mergedissimilarstructures(structures, defaultempty)
    %structures: a cell array of scalar structures to merge
    %defaultempy: the value to use to fill missing fields. Optional, default = []
    %structarray: a structure array the same size as the input structures cell array. 
    % The fields of structurarray is the union of the fields of the input structures
    
    %TODO: input validation
    if nargin < 2
        defaultempty = [];
    end
    fieldunion = cellfun(@fieldnames, structures, 'UniformOutput', false);
    fieldunion = unique(vertcat(fieldunion{:}));
    structarray = repmat({defaultempty}, numel(structures), numel(fieldunion));
    for sidx = 1:numel(structures)
        [~, destcol] = ismember(fieldnames(structures{sidx}), fieldunion);
        structarray(sidx, destcol) = struct2cell(structures{sidx});
    end
    structarray = reshape(cell2struct(structarray, fieldunion, 2), size(structures));
end