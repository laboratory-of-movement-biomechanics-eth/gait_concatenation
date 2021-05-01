% Function/Routine concatTraj being called in from the Concatenation Main

% Purpose of this code is to load files from each participant within the
% data and feed them for the concatenating procedure.

%[con, error] = concatTraj_parallel(DIR, Windowlength, Weights, error);
% returns con - the concatenated time series each of the subject and all the subjects
% as a struct - as output to the concatenation main

% The inputs needed are DIR where the datasets are, windowlength n, weights wm and error.


function [con, error] = concatTraj_parallel(DIR, win, w, error)

DIR = strcat(DIR, filesep);
Files=dir(fullfile(DIR, '*.mat')); % Individual patients

tic
% use parfor for parallel processing
for i = 1:length(Files)
    
    file = load(strcat(DIR, Files(i).name));
    name = Files(i).name(1:7); % Name of the patient
    
    %% The Main concatenation process
    [consliced{i}, errorsliced{i}] = concatprocess(file, name, win, w, error);
    
end
toc

%writing back to structure
for x = 1:length(Files)
    name = Files(x).name(1:7);
    con.(name) = consliced{x};
    error.(name) = errorsliced{x};
end

end