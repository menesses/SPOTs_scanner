function [X_locs, Y_locs,overlap] = inputPointsOfInterest
% Prompt user for points of interest
answer = questdlg('Choose input for points of interest.','Input selection','CSV','Row/Column dimensions','Area Scan Helper (Beta)','Row/Column dimensions');
switch answer
    case 'CSV'
        questdlg('CSV file should contain have X and Y columns of N rows','OK','OK','OK');
        [filename,filepath] = uigetfile('*.csv','Select CSV list of coordinates');
        A = readmatrix([filepath,filename]);
        sz = size(A);
        if sz(2) ~= 2
            error('Incorrect formatting of CSV data!')
        else
            X_locs = A(:,1);
            Y_locs = A(:,2);
            overlap = NaN;
        end
    case 'Row/Column dimensions'
        prompt = {'Number of rows:','Number of columns:'};
        rows_cols = inputdlg(prompt);
        n_rows = str2double(rows_cols{1});
        n_cols = str2double(rows_cols{2});
        [X_locs,Y_locs] = meshgrid([1:n_cols],[1:n_rows]);
        overlap = NaN;
    case 'Area Scan Helper (Beta)'
        [X_locs,Y_locs,overlap] = areaScanSetup;
end
end
