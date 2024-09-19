% Path to csv files.
CSVPath = './CSVs/';

% Path to output file.
OutPath = './CellCounts.csv';

% Cell type that you want to count.
% If you want to count many cell types together you can replace this with a cell array of types.
cellType = 'lym';

% Cell type that you want cells to co-localised be with.
% Only cells near to this cell type will be counted.
% If you want use many cell types here then you can replace this with a cell array of types.
adjacentType = 'cep';

% Maximum distance between two cell types for them to count as co-localised.
maxDist = 100;

% Minimum number of co-localising cells within maximum distance for a cell to be counted as co-localised.
numCells = 1;

files = dir(fullfile(CSVPath, '*.csv'));

[~, fNames, ~] = cellfun(@fileparts, {files(i).name}', 'UniformOutput', false);
counts = zeros(length(files), 1);

for i=1:length(files)
    filePath = fullfile(files(i).folder, files(i).name);
    counts(i) = countCellAdj(filePath, cellType, adjacentType, maxDist, numCells);
end

T = table();
T.('SampleID') = fNames;
T.([cellType 'Count']) = counts;
writetable(T, OutPath);
