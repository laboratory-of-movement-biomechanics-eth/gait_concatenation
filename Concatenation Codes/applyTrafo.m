% Function applyTrafo is called in from the concatprocess and the callTrafoandSS

% Purpose: Apply the transformation matrix

% [kinDataOut] = applyTrafo(kinData, x0, y0, phi)
% returns the transformed kinematic timeseries as output.

% the inputs include: kinData - C2 - 3D kinematics from all the markers of
%                                     the following (the one to concatenate) time series
%                     x0 and y0 are coordinates for translation
%                     phi is the angle to rotate in radians.

% Please refer to reference no 16 in the manuscript for details on
% estimating the transformation matrix that includes both the rotation and
% translation values.

function [kinDataOut] = applyTrafo(kinData, x0, y0, phi)
for frame = 1:size(kinData.RHEE, 1)
    
    % transformation matrix for translation in ML-AP, rotation around VT
    rt = [cos(phi(frame)), -sin(phi(frame)), 0, x0(frame);...
        sin(phi(frame)), cos(phi(frame)), 0, y0(frame);...
        0, 0, 1,0;
        0,0,0,1];
    % apply the transformation matrix for each marker
    % individually
    for Marker = fieldnames(kinData)'
        kinDataOut.(Marker{1})(frame, :) = rt*[kinData.(Marker{1})(frame,:), 1]'; %rotation & translation of traj2
    end
end
end
