% function findMinErrorPoints that is called by concatprocess

% Purpose: to evaluate the minimum of the mean squared distance vector
% [pks, locs] = findMinErrorPoints(error, fHS)
% returns the minimum value and the location of mean squared distance or error
% as output

% Inputs are error - Mean squared distance vector in mm^2
%            fHS - frequency of heel strikes

function [pks, locs] = findMinErrorPoints(error, fHS)

[pks, locs] = findpeaks(-error, 'MINPEAKDISTANCE', floor(fHS/1.2));
pks = -pks;

end