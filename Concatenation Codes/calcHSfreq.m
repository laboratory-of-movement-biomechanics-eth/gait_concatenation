% function calcHSfreq is called by concatprocess

% Purpose to evaluate the frequency of heelstrikes present
% HSf = calcHSfreq(trial)
% returns HSf - frequency of heelstrikes during a walking trial.

% Input is trial - containing information on gait events, i.e. heel strikes
% and the overall length of the trial in the number of frames

function HSf = calcHSfreq(trial)
nHS = trial.GaitEvents.nHSright;
nFrames = length(trial.KinematicData.RHEE(:,3));
HSf = nFrames/nHS;
end