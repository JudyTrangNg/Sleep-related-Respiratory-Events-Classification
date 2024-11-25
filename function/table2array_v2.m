function arr = table2array_v2(T)
    [numRows, numCols] = size(T);
    arr = cell(numRows, numCols);
    for col = 1:numCols
        % Extract the column data
        columnData = T{:, col};
        
        % Check the type of the column data
        if iscell(columnData)
            % If the column data is a cell array, assign it directly
            arr(:, col) = columnData;
        else
            % Otherwise, convert to a cell array and assign
            arr(:, col) = num2cell(columnData);
        end
    end
    arr = convertCharsToStrings(arr);
end