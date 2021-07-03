function [x, lambdaerror] = readData(mode)
%% Read in the data
%

% -joachim vandekerckhove


%% Pick a read mode
if nargin < 1
    mode = 'rowwise';
end

switch mode
    case 'rowwise'
        [x, lambdaerror] = readData_rowwise();
    case 'full'
        [x, lambdaerror] = readData_full();
end

end


%% Rowwise data reading

function [x, lambdaerror] = readData_rowwise()

%% Fetch all the data from storage
load ../Data/OptimalStopping.mat
load ../Data/Bandit.mat
load ../Data/Bart.mat
load ../Data/Gambling.mat
load estimates_mat.mat
load ../Data/RTI_scores.mat
load ../Data/RPS_scores.mat
load ../Data/DospertTaking_scores.mat
load ../Data/DospertPerception_scores.mat

% List parameter names
param_strs = {'OSalpha1', 'OSalpha2', 'OSalpha3', 'OSalpha4', ...
    'OSbeta1', 'OSbeta2', 'OSbeta3', 'OSbeta4', ...
    'OSgamma1', 'OSgamma2', 'OSgamma3', 'OSgamma4', ...
    'BanditgammaW1', 'BanditgammaW2', 'BanditgammaW3', 'BanditgammaW4', ...
    'BanditgammaL1', 'BanditgammaL2', 'BanditgammaL3', 'BanditgammaL4', ...
    'Bartbeta1', 'Bartbeta2', 'BartgammaPlus1', 'BartgammaPlus2', ...
    'Gamblephi', 'Gamblelambda', ...
    'RTI', 'RPS', 'DospertTaking', 'DospertPerception'};

% PARAMETERS ORDER IN ESTIMATES MATRIX
% 1: alpha4 cond 1 (neutral) -- T(0, 1)        % 12 OS
% 2: alpha4 cond 2 (plentiful)-- T(0, 1)
% 3: alpha8 cond 1 (neutral) -- T(0, 1)
% 4: alpha8 cond 2 (plentiful) -- T(0, 1)
% 5: beta4 cond 1 (neutral)
% 6: beta4 cond 2 (plentiful)
% 7: beta8 cond 1 (neutral)
% 8: beta8 cond 2 (plentiful)
% 9: gamma4 cond 1 (neutral)
% 10: gamma4 cond 2 (plentiful)
% 11: gamma8 cond 1 (neutral)
% 12: gamma8 cond 2 (plentiful)
% 13: gammaWin cond 1 (len 8 neutral) -- T(0, 1)    % 8 Bandit
% 14: gammaWin cond 2 (len 8 plentiful) -- T(0, 1)
% 15: gammaWin cond 3 (len 16 neutral) -- T(0, 1)
% 16: gammaWin cond 4 (len 16 plentiful) -- T(0, 1)
% 17: gammaLose cond 1 (len 8 neutral) -- T(0, 1)
% 18: gammaLose cond 2 (len 8 plentiful) -- T(0, 1)
% 19: gammaLose cond 3 (len 16 neutral) -- T(0, 1)
% 20: gammaLose cond 4 (len 16 plentiful) -- T(0, 1)
% 21: beta cond 1 (p = .1) -- T(0, 10)          % 4 BART
% 22: beta cond 2 (p = .2) -- T(0, 10)
% 23: gammaplus cond 1 (p = .1) -- T(0, 10)
% 24: gammaplus cond 2 (p = .2) -- T(0, 10)
% 25: phi (gains and losses) -- T(0, 10)            % 3 Gamble
% 26: lambda (losses) -- T(0, 10)
% 27: RTI scores (SD = 7.65) -- T(0, 35)
% 28: RPS scores (SD = 1.0) -- T(0, 35)
% 29: Dospert Taking scores (SD = 7.87) -- T(0, 35)
% 30: Dospert Perception scores (SD = 6.80) -- T(0, 35)

T = numel(param_strs);

%% Loop through all combinations of correlation pairs

ppx = cell(size(param_strs));

for i = 1:T
    if i <= 12
        ppx{i} = OptimalStopping.participants;
    elseif i <= 20
        ppx{i} = Bandit.participants;
    elseif i <= 24
        ppx{i} = Bart.participants;
    elseif i <= 26
        ppx{i} = Gambling.participants;
    else
        ppx{i} = Bandit.participants;    % all survey participants are same as Bandit
    end
    
    % Keep only participants that have a complete set
    if i==1
        participantsCommon = ppx{i};
    else
        participantsCommon = intersect(participantsCommon, ppx{i});
    end
end

ind = cell(1,T);
for i = 1:numel(param_strs)
    [~, ind{i}] = ismember(participantsCommon, ppx{i});
end

P = numel(participantsCommon);

tmpMeans = cell(size(param_strs));
tmpPrecs = cell(size(param_strs));
x = zeros(P, T);
lambdaerror = zeros(P, P, T);

%% Get mean and precision for each parameter

for i = 1:T
    
    % first parameter's MEANS and PRECISIONS
    if i <= 26
        % first parameter's MEANS
        tmpMeans{i} = estimates_mat(estimates_mat(:, 1) == i & estimates_mat(:, 2) == 1, 4); %#ok<NODEF>
        % first parameter's PRECISIONS
        tmpPrecs{i} = estimates_mat(estimates_mat(:, 1) == i & estimates_mat(:, 2) == 2, 4);
    elseif i == 27
        tmpMeans{i} = RTI_scores;
        tmpPrecs{i} = repmat(1/(1.8072^2), [numel(RTI_scores), 1]);
    elseif i == 28
        tmpMeans{i} = RPS_scores;
        tmpPrecs{i} = repmat(1/(0.9465^2), [numel(RTI_scores), 1]);
    elseif i == 29
        tmpMeans{i} = DospertTaking_scores;
        tmpPrecs{i} = repmat(1/(1.776^2), [numel(RTI_scores), 1]);
    elseif i == 30
        tmpMeans{i} = DospertPerception_scores;
        tmpPrecs{i} = repmat(1/(1.4174^2), [numel(RTI_scores), 1]);
    end
    x(:,i) = tmpMeans{i}(ind{i});
    lambdaerror(:,:,i) = diag(tmpPrecs{i}(ind{i}));
end

%% Standardize parameters
x = (x - ones(P,1) * mean(x)) ./ ( ones(P,1) * std(x) );

for i = 1:numel(param_strs)
    lambdaerror(:,:,i) = lambdaerror(:,:,i) .* var(x(:,i));
end

end


function [x, lambdaerror] = readData_full()

error(126)

end
