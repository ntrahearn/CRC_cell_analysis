function HeatMap = MakeITFPlot(Cells, ImageSize, labels, TileSize, TileOverlap, MinCellCutoff)
    ChromTri = [0 sqrt(2/3); -sqrt(0.5) -sqrt(1/6); sqrt(0.5) -sqrt(1/6)];
    MaxwellMat = [(2.^-0.5) -(6.^-0.5); -(2.^-0.5) -(6.^-0.5); 0 ((2/3).^0.5)];
    
    if nargin < 3
        labels = {'lym', 'cep', 'fib'};
    end
    
    if nargin < 4
        TileSize = [200 200];
    end
    
    if nargin < 5
        TileOverlap = 0.1;
    end
    
    if nargin < 6
        MinCellCutoff = 10;
    end

    labelSet = {};
    
    for j=1:3
        if iscell(labels{j})
            labelSet = [labelSet, labels{j}{:}];
        else
            labelSet = [labelSet labels{j}];
        end
    end

    IPrc = @(x) cellCount(x(:, 1), labels{1})./size(x, 1);
    TPrc = @(x) cellCount(x(:, 1), labels{2})./size(x, 1);
    FPrc = @(x) cellCount(x(:, 1), labels{3})./size(x, 1);
    CTot = @(x) cellCount(x(:, 1), labelSet);

    HeatMapI = GenerateHeatmap(Cells, IPrc, TileSize, TileOverlap, ImageSize, 0, 1);
    HeatMapT = GenerateHeatmap(Cells, TPrc, TileSize, TileOverlap, ImageSize, 0, 1);
    HeatMapF = GenerateHeatmap(Cells, FPrc, TileSize, TileOverlap, ImageSize, 0, 1);
    CellTotals = GenerateHeatmap(Cells, CTot, TileSize, TileOverlap, ImageSize, 0, 1);

    HeatMap = reshape(cat(3, HeatMapF, HeatMapI, HeatMapT), [], 3);
    
    HeatMap = trilinear2Cartesian(HeatMap, 2*ChromTri);
    HeatMap = HeatMap/MaxwellMat;
    HeatMap = (HeatMap-min(HeatMap, [], 2));
    HeatMap = HeatMap./sqrt(sum(HeatMap, 2));
    HeatMap = HeatMap.*min(1, CellTotals(:)./MinCellCutoff);
    HeatMap(isnan(HeatMap)) = 0;
    HeatMap = reshape(HeatMap, [size(HeatMapI) 3]).^(2/3);
end
    
function count = cellCount(cellLabels, matchLabels) 
    if iscell(matchLabels)
        matchingCells = false(length(cellLabels), 1);

        for i=1:length(matchLabels)
            matchingCells = matchingCells | strcmp(cellLabels, matchLabels{i});
        end
    else
        matchingCells = strcmp(cellLabels, matchLabels);
    end

    count = nnz(matchingCells);
end

