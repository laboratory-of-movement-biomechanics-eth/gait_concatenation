% Function concatprocess is called in from the concatTraj_parallel

% Purpose: Code to setup the concatenation processing

% [cons, error] = concatprocess(file, name, win, w, error);
% returns cons - the concatenated 3D time series as output.
%         error - the corresponding Mean squared distances for cons

% the inputs include: data file from each participant,
%                     name of the participant,
%                     win and w are window n and weights for markers respectively in
%                     equation 1.



function [con, error] = concatprocess(file, name, win, w, error)

%% Looping through the different weight, cutting conditions

% use parfor for parallel processing
for trial = fieldnames(file.(name))' % Weight Conditions
    for x0 = fieldnames(file.(name).(trial{1}))' % Repetition conditions
        fHS = calcHSfreq(file.(name).(trial{1}).(x0{1})); % Frequency of HS in the entire trial
        for cutType = fieldnames(file.(name).(trial{1}).(x0{1}).cutKin)' % Cutting Conditions
            
            kinData1 = 0;
            
            % loop over the number of shortened or cut trials that need to
            % be concatenated.
            for cutNR = fieldnames(file.(name).(trial{1}).(x0{1}).cutKin.(cutType{1}))'
                NR = str2double(char(strrep(cutNR,'t',''))); % Extract cut trial no.
                kinData2 = file.(name).(trial{1}).(x0{1}).cutKin.(cutType{1}).(cutNR{1});
                
                % skip the first dataset (nothing to concatenate)
                % if condition fails in the case KinData1 = 0
                if isstruct(kinData1)
                    % identify last frame to concat in this case
                    % it should be a HS
                    lastFrame = length(kinData1.RHEE);
                    
                    % calculate the error over the whole frame to
                    % concatenate within the given window
                    error.(name).(trial{1}).(x0{1}).(cutType{1}).(cutNR{1}) = callTrafoandSS(kinData1, kinData2, lastFrame, win, w)';
                    tmp_error = error.(name).(trial{1}).(x0{1}).(cutType{1}).(cutNR{1});
                    % find possible points to concatenate
                    [~, locs] = findMinErrorPoints(tmp_error, fHS);
                    
                    % cut window size from first kinData to
                    % generate space for transition and cut second
                    % kinData till point of concatenation
                    
                    for Marker = fieldnames(kinData1)'
                        kinData1cut.(Marker{1}) = kinData1.(Marker{1})(lastFrame-win+1:lastFrame, :);
                        kinData2cut.(Marker{1}) = kinData2.(Marker{1})(locs(1):locs(1)+win-1,:);
                        kinData2.(Marker{1}) = kinData2.(Marker{1})(locs(1)+win:end,:);
                    end
                    
                    % if the data to concatenate is available
                    
                    if ~isempty(kinData2.RHEE(:,1))
                        
                        % Identifying the appropriate transformation
                        [x, y, phi] = calcTrafo(kinData1cut, kinData2cut, w);
                        % Applying the transformation
                        [kinData2Trans] = applyTrafo(kinData2cut, x, y, phi);
                        
                        % Doing the interpolation for smooth transition
                        kinDataInterp = createTransition(kinData1cut, kinData2Trans, win);
                        
                        % Reducing the data length of the calculated
                        % values
                        x = linspace(x(end), x(end), length(kinData2.RHEE(:,1)));
                        y = linspace(y(end), y(end), length(kinData2.RHEE(:,1)));
                        phi = linspace(phi(end), phi(end), length(kinData2.RHEE(:,1)));
                        
                        % Store the transformation parameters used in every
                        % concatenation
                        con.(trial{1}).(x0{1}).concat.(cutType{1}).Parameters.X_stored.(cutNR{1}) = x;
                        con.(trial{1}).(x0{1}).concat.(cutType{1}).Parameters.Y_stored.(cutNR{1}) = y;
                        con.(trial{1}).(x0{1}).concat.(cutType{1}).Parameters.PHI_stored.(cutNR{1}) = phi;
                        
                        kinData2 = applyTrafo(kinData2, x, y, phi);
                        
                    end
                    % concatenate Data1, interpolated window, Data2
                    for Marker = fieldnames(kinData1)'
                        kinData1.(Marker{1}) = [kinData1.(Marker{1})(1:lastFrame-win,:); ...
                            kinDataInterp.(Marker{1})(:,:); kinData2.(Marker{1})(:, 1:3)];
                    end
                else
                    kinData1 = kinData2;
                end
                
            end
            % generate concatenation struct
            con.(trial{1}).(x0{1}).concat.(cutType{1}).Data = kinData1;
            
        end
        
    end
end
end