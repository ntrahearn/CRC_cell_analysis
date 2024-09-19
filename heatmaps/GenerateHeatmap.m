function HeatMap = GenerateHeatmap(Cells, Function, TileSize, TileOverlap, ImageSize, NoDataValue, Mode)
    if nargin < 3 || isempty(TileSize)
        TileSize = [500 500];
    end
    
    if nargin < 4 || isempty(TileOverlap)
        TileOverlap = [0.5 0.5];
    end
    
    if nargin < 5 || isempty(ImageSize)
        ImageSize = max(Cells(:, 3:-1:2));
    end
    
    if nargin < 6 || isempty(NoDataValue)
        NoDataValue = 0;
    end
    
    if nargin < 7 || isempty(Mode)
        Mode = 0;
    end
    
    if length(TileOverlap) == 1
        TileOverlap = [TileOverlap TileOverlap];
    end
    
    if Mode == 0
        HeatMapSize = ceil(ImageSize./TileSize);
    elseif Mode == 1
        HeatMapSize = ceil(ImageSize./(TileSize.*TileOverlap));
    else
        error('Unknown Mode');
    end
    
    CellPositions = cell2mat(Cells(:, 2:3));
    
    HeatMap = zeros(HeatMapSize(2:-1:1));
    HMCount = zeros(HeatMapSize(2:-1:1));
    
    if ~isempty(CellPositions)
        if Mode == 0
            for i=0:TileOverlap(1):HeatMapSize(1)-1
                columnCells = Cells(CellPositions(:, 1) >= (i*TileSize(1)) & CellPositions(:, 1) < ((i+1)*TileSize(1)), :);

                if ~isempty(columnCells)
                    columnCellPositions = cell2mat(columnCells(:, 2:3));

                    for j=0:TileOverlap(2):HeatMapSize(2)-1
                        tileCells = columnCells(columnCellPositions(:, 2) >= (j*TileSize(2)) & columnCellPositions(:, 2) < ((j+1)*TileSize(2)), :);

                        if ~isempty(tileCells)
                            value = Function(tileCells);

                            HeatMap(floor(j)+1, floor(i)+1) = HeatMap(floor(j)+1, floor(i)+1) + value*(1-j+floor(j))*(1-i+floor(i));
                            HMCount(floor(j)+1, floor(i)+1) = HMCount(floor(j)+1, floor(i)+1) + (1-j+floor(j))*(1-i+floor(i));

                            if j<HeatMapSize(2)-1
                                HeatMap(floor(j)+2, floor(i)+1) = HeatMap(floor(j)+2, floor(i)+1) + value*(j-floor(j))*(1-i+floor(i));
                                HMCount(floor(j)+2, floor(i)+1) = HMCount(floor(j)+2, floor(i)+1) + (j-floor(j))*(1-i+floor(i));
                            end

                            if i<HeatMapSize(1)-1
                                HeatMap(floor(j)+1, floor(i)+2) = HeatMap(floor(j)+1, floor(i)+2) + value*(1-j+floor(j))*(i-floor(i));
                                HMCount(floor(j)+1, floor(i)+2) = HMCount(floor(j)+1, floor(i)+2) + (1-j+floor(j))*(i-floor(i));
                            end

                            if i<HeatMapSize(1)-1 && j<HeatMapSize(2)-1
                                HeatMap(floor(j)+2, floor(i)+2) = HeatMap(floor(j)+2, floor(i)+2) + value*(j-floor(j))*(i-floor(i));
                                HMCount(floor(j)+2, floor(i)+2) = HMCount(floor(j)+2, floor(i)+2) + (j-floor(j))*(i-floor(i));
                            end
                        end
                    end
                end
            end

            HeatMap = HeatMap./HMCount;
        elseif Mode == 1
            for i=0:HeatMapSize(1)-1
                columnCells = Cells(CellPositions(:, 1) >= (i*TileSize(1)*TileOverlap(1)) & CellPositions(:, 1) < (i*TileSize(1)*TileOverlap(1))+TileSize(1), :);

                if ~isempty(columnCells)
                    columnCellPositions = cell2mat(columnCells(:, 2:3));

                    for j=0:HeatMapSize(2)-2
                        tileCells = columnCells(columnCellPositions(:, 2) >= (j*TileSize(2)*TileOverlap(1)) & columnCellPositions(:, 2) < (j*TileSize(2)*TileOverlap(1))+TileSize(2), :);

                        if ~isempty(tileCells)
                            HeatMap(j+1, i+1) = Function(tileCells);
                            HMCount(j+1, i+1) = 1;
                        end
                    end
                end
            end
        end
    end
    
    HeatMap(HMCount == 0) = NoDataValue;
end

