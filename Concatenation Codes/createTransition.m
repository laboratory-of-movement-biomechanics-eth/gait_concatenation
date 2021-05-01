% function createTransition is called by concatprocess

% Purpose: Is to create an interpolated (smooth) concatenated time series
% kinDataout = createTransition(kinData1cut, kinData2Trans, win)
% returns the interpolated timeseries as output

% The inputs are kinData1cut - final few (win) frames  of C1 the included time series
%                kinData2cut - beginning win number of frames of C2
%                win - the size of the window or n in equation 1.

function kinDataout = createTransition(kinData1cut, kinData2Trans, win)
k = win;
p = linspace(0, 1, k);
alpha = 2*(p+1./k).^3-3*(p+1./k).^2+1;    
    for frame = 1:k
        for Marker = fieldnames(kinData1cut)'
            kinDataout.(Marker{1})(frame, :) = alpha(frame)*kinData1cut.(Marker{1})(frame,:) + (1-alpha(frame))*kinData2Trans.(Marker{1})(frame, 1:3);
        end
    end
end
