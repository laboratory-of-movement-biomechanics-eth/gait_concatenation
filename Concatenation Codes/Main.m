%% A method to concatenate multiple short time series for evaluating dynamic behaviour during walking
% Orter et al. 2019
% Main Script to Perform Concatenation
% For details on the procedure read the manuscript and
% see equations 1 through 3.

%% Description of the included dataset

%%%%% Data %%%%%

% The dataset is organized as a structure.
% It contains sample data from one subject (ORTE_07) walking
% under one weight condition (normg - see methods section of the manuscript)
% and a single repetition (x01).

% It provides information on gait events, kinematics from complete 5-minute time
% series (fullTS) and kinematics from one short time series (cutO605):

% a) GaitEvents: Events such as (Heel strikes and toe offs) for the entire
% trial.

% b) KinematicData: Includes 3D kinematics (trajectories) from all the
% markers attached during the entire trial (5 min of walking). The 3D are:
% 1) Mediolateral, 2) Anteroposterior and 3) Longitudinal or vertical. All
% kinematics are in mm.

% See marker attachments file for details.

% c) cutKin: 3D kinematics from all markers attached, but shorter series in
% line with the cut0605 rule. Each of the shorter series (txx) represents
% a cut section of the original and complete Kinematic Data.
% See methods in the manuscript for details on the rule for creating
% shorter series.

%% Description of the code.

%%%%% Input %%%%%
% File organization of the input data

% The datasets should be organized in struct format. In order to concatenate
% the time series the input data should contain the
% above-mentioned information on gait events, original 3D kinematic time
% series from the entire trial and shortened time series.

% DIR  : Directory to the Data
% Windowlength : Window length is chosen as one third of the Sampling Frequency, Mizuguchi 2001
%                assigned as n in equation 1
% Weights : Weights assigned to individual markers
%           wm in equation 1
% error : Initialize an empty structure to store the error from the concatentaion procedure

%%%%% Output %%%%%

% con : Concatenated gait trails
% error : Mean squared distance in mm^2 from the concatenation procedure
% see equations 1 through 3 for details

%%
close all;
clear all;
clc;

%% Initialzation

% Include the Directory to the Data
DIR = 'Data';

Windowlength = 33; % n in equation 1
Weights = load('weightsNiklas.mat');
Weights = Weights.w;% weighting assigned to each marker wm in equation 1
error =[];

[con, error] = concatTraj_parallel(DIR, Windowlength, Weights, error);

%% Concatenated data output figure

figure
plot(con.ORTE_07.normg.x01.concat.cut0605.Data.RHEE(:,:))


