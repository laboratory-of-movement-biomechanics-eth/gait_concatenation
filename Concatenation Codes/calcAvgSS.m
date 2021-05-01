% function calAvgSS is called by callTrafoandSS

% Purpose: to evaluate the mean squared error using  equation 1 in the
% manuscript.

% [error] = calcAvgSS(kinData1, kinData2, w)
% returns error - mean square distance - between any two time series in mm^2.

% Inputs include: kinData1 - C1
%                 kinData2 - C2
%                 w - window or n in equation 1

function [error] = calcAvgSS(kinData1, kinData2, w)

error = 0;

    for Marker = fieldnames(kinData1)'
        error = error + w.(Marker{1}) * norm(kinData1.(Marker{1})(:,:) - kinData2.(Marker{1})(:,1:3)).^2;
    end

end