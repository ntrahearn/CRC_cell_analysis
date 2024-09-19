function count = countCellAdj(fPath, label1, label2, maxDist, numCells)
    if ~iscell(label1)
        label1 = {label1};
    end
    
    if ~iscell(label2)
        label2 = {label2};
    end

    T = readtable(fPath);
    l1Cells = table2array(T(ismember(T.V1, label1), 2:3));
    l2Cells = table2array(T(ismember(T.V1, label2), 2:3));
    adjL1Cells = false(size(l1Cells, 1), 1);
    
    for j=1:length(l1Cells)
        l2CellsA = l2Cells(abs(l2Cells(:, 1)-l1Cells(j, 1))<maxDist & abs(l2Cells(:, 2)-l1Cells(j, 2))<maxDist, :);
        D = sqrt((l2CellsA(:, 1)-l1Cells(j, 1)).^2 + (l2CellsA(:, 2)-l1Cells(j, 2)).^2);
        adjL1Cells(j) = (nnz(D<maxDist) >= numCells);
    end
    
    count = nnz(adjL1Cells);
end
