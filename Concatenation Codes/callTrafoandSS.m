% function callTrafoandSS called by function concatprocess

%Purpose: to evaluate the mean squared distance between the included and
%the following time series for concatenation.

% [error] = callTrafoandSS(kinData1, kinData2, HS, window, w)
% returns error - the Mean squared distance between the two time series 
% kinData1 (C1 in the manuscript) and kinData2 (C2) in mm^2 - as output

% the inputs include: kinData1 - C1 - 3D kinematics from all markers of the
%                                     included time series
%                     kinData2 - C2 - 3D kinematics from all the markers of
%                                     the following (the one to concatenate) time series 
%                     HS: final frame number to concatenate to.
%                     window and w are n and weights respectively in equation 1


function [error] = callTrafoandSS(kinData1, kinData2, HS, window, w)

lastHS = HS(end);
kinData2len = size(kinData2.RHEE, 1);

    %% Extracting the last n frames from the preceding cut trial 
    for Marker = fieldnames(kinData1)'
        if isfield(kinData2, (Marker{1}))
            kinData1cut.(Marker{1}) = kinData1.(Marker{1})(lastHS-window+1:lastHS, :);
        end
    end
    
    % Possible concatenating points in the succeeding trial 
    error(1:kinData2len-window+1) = 0;
    
    %% cut second traj, rotate and calc error while shifting over the whole traj
    % creating a sliding window in the succeeding trial of size n 
    for shiftWindow = 1:kinData2len-window+1 % no of possible sliding windows
        for Marker = fieldnames(kinData1cut)'
            kinData2cut.(Marker{1}) = kinData2.(Marker{1})(shiftWindow:shiftWindow+window-1, :);
        end
        
        [x, y, phi] = calcTrafo(kinData1cut, kinData2cut, w); % calculate transformation
        [kinData2Trans] = applyTrafo(kinData2cut, x, y, phi); % apply transformation
        [error(shiftWindow)] = calcAvgSS(kinData1cut, kinData2Trans, w); % find error after transformation
    end
end