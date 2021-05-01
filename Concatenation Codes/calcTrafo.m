% Function calcTrafo is called in from the concatprocess and the callTrafoandSS

% Purpose: Evaluate coordinates for translation and angle for rotation of
% the following shorter time series

% [x0, y0, phi] = calcTrafo(kinData1, kinData2, w)

% returns x0 and y0 are coordinates to translate, while phi is the angle to rotate 
% the concatenated timeseries kinData2 in radians as outputs

% the inputs include: kinData1 - C1 - 3D kinematics from all markers of the
%                                     included time series
%                     kinData2 - C2 - 3D kinematics from all the markers of
%                                     the following (the one to concatenate) time series 
%                     w - weights for each marker

% Please refer to reference no 16 in the manuscript for details on
% estimating the transformation matrix that includes both the rotation and
% translation values.

% Here we are intended to translate in ML-AP plane and rotation around
% VT

function [x0, y0, phi] = calcTrafo(kinData1, kinData2, w)

% initializing the parameters
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    x1bar = 0;
    x2bar = 0;
    y1bar = 0;
    y2bar = 0;
    sumw = 0;
    
    for Marker = fieldnames(kinData1)' %loop over all markers to calculate means and cut traj to window size
        %% mean over all frames for each marker
        x1bar = x1bar +  w.(Marker{1})*kinData1.(Marker{1})(:,1);
        y1bar = y1bar +  w.(Marker{1})*kinData1.(Marker{1})(:,2);
        x2bar = x2bar + w.(Marker{1})*kinData2.(Marker{1})(:,1);
        y2bar = y2bar + w.(Marker{1})*kinData2.(Marker{1})(:,2); 
        sumw = sumw + w.(Marker{1});
    end
    
    for Marker = fieldnames(kinData1)' %loop over all markers to calculate phi, x0, y0 for all frames
        x1 = kinData1.(Marker{1})(:,1);
        y1 = kinData1.(Marker{1})(:,2);
        x2 = kinData2.(Marker{1})(:,1);
        y2 = kinData2.(Marker{1})(:,2);
        wdef = w.(Marker{1});
        a = a + wdef .* (y1.*x2 - y2.*x1);
        c = c + wdef .* (y1.*y2 + x1.*x2);
    end
    b = b + 1/sumw .* (y1bar.*x2bar - y2bar.*x1bar);
    d = d + 1/sumw .* (y1bar.*y2bar + x1bar.*x2bar);
    
    % rotation parameter
    phi = atan((a-b)./(c-d));
    
    % translation parameter
    y0= 1/sumw.*(y1bar - y2bar.*cos(phi)- x2bar.*sin(phi));
    x0 = 1/sumw.*(x1bar+y2bar.*sin(phi)-x2bar.*cos(phi));
end