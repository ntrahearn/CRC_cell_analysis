% Path to csv files.
CSVPath = './CSVs/';

% Path to heatmap files.
OutPath = './Heatmaps/';

% The labels of the cells you want in the heatmap.
% The first label will be green, the second red, and the third blue.
% If you want to group multiple cell types together under a single colour then you can also use a cell array of types instead of a single string.
labels = {'lym', 'cep', 'fib'};

% Size of each tile to test in pixels.
TileSize = [200 200];

% Distance between adjacent tiles, as a proportion of the tile size.
% For example: 1 is no overlap, 0.5 is tiles overlapping by half, 0.1 is 90% overlap, and so on.
% Can be a vector if you want different overlaps in X and Y dimensions.
TileOverlap = 0.1;

% Minimum number of cells in a tile for it to be counted.
% Tiles with less than this number will be set to black in the heatmap.
MinCellCutoff = 10;

files = dir(fullfile(CSVPath, '*.csv'));

if ~isfolder(OutPath)
    mkdir(OutPath);
end

for i=1:length(files)
    [~, fName, ~] = fileparts(fullfile(files(i).name));
    T = readtable(fullfile(files(i).folder, files(i).name));
    im_size = [max(T.V2), max(T.V3)];
    Heatmap = MakeITFPlot(table2cell(T), im_size, labels, TileSize, TileOverlap, MinCellCutoff);
    imwrite(Heatmap, fullfile(OutPath, [fName '_TFL.png']));
end
