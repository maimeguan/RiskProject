% This script makes the overall performance figure comparing the 4 tasks

%% load data

load('/Users/Maime/Dropbox/RiskStudy/OptimalStopping/OptimalStopping.mat')
load('/Users/Maime/Dropbox/RiskStudy/BART/Bart.mat')
load('/Users/Maime/Dropbox/RiskStudy/Bandit/Bandit.mat')
load('/Users/Maime/Dropbox/RiskStudy/Gambling/Gambling.mat')


%% Optimal Stopping: proportion of chose max per condition

perform_OS = NaN(numel(OptimalStopping.participants), OptimalStopping.ncond);
for i = 1:numel(OptimalStopping.participants)
    for m = 1:OptimalStopping.ncond
        tmpCorrect = 0;
        for j = 1:OptimalStopping.nprob
            
            % max of current problem
            tmpMax = max(OptimalStopping.stimuli(OptimalStopping.participants(i), j, m, :));
            indMax = find(OptimalStopping.stimuli(OptimalStopping.participants(i), j, m, :) == tmpMax);
            if OptimalStopping.decisions(OptimalStopping.participants(i), j, m) == indMax
                tmpCorrect = tmpCorrect + 1;
            end
        end
        perform_OS(i, m) = tmpCorrect/OptimalStopping.nprob;
        
    end
end


%% Bandit: avg number of rewards per problem

% (rewardChosen already filtered out participants 1, 3)
perform_bandit = NaN(numel(Bandit.participants), Bandit.ncond);
for i = 1:numel(Bandit.participants)
    for m = 1:Bandit.ncond
        tmpRewards = squeeze(Bandit.rewardChosen(i, :, m, :));
        perform_bandit(i, m) = nansum(tmpRewards(:))/(Bandit.nprob*Bandit.ntrial(m));
    end
end


%% BART performance: avg dollar amount made per problem

% BART: avg dollar amount made per problem
perform_bart = NaN(numel(Bart.participants), Bart.ncond);
for i = 1:numel(Bart.participants)
    for m = 1:Bart.ncond
        tmpCorrect = 0;
        for j = 1:Bart.nprob
            % if did not pop
            if Bart.decisions(Bart.participants(i), j, m, 1) == 0
                tmpCorrect = tmpCorrect + Bart.decisions(Bart.participants(i), j, m, 2);
            end       
        end
        perform_bart(i, m) = tmpCorrect/Bart.nprob;
        
    end
    
end


%% Gambling: proportion of chose better per condition

perform_gamble = NaN(numel(Gambling.participants), Gambling.ncond);
for i = 1:numel(Gambling.participants)
    for m = 1:Gambling.ncond
        tmpChoseBetter = squeeze(Gambling.decBetter(Gambling.participants(i), :, m));
        perform_gamble(i, m) = sum(tmpChoseBetter)/Gambling.nprob;
    end
end


%% get pairwise correlations

% 1: OS neutral, len 4
% 2: OS plentiful, len 4
% 3: OS neutral, len 8
% 4: OS plentiful, len 8
% 5: Bandit neutral, len 8
% 6: Bandit plentiful, len 8
% 7: Bandit neutral, len 16
% 8: Bandit plentiful, len 16
% 9: BART p = .1
% 10: BART p = .2
% 11: Gambling gains
% 12: Gambling losses

perform_overall = [1*ones(numel(OptimalStopping.participants), 1), perform_OS(:, 1);
    2*ones(numel(OptimalStopping.participants), 1), perform_OS(:, 2);
    3*ones(numel(OptimalStopping.participants), 1), perform_OS(:, 3);
    4*ones(numel(OptimalStopping.participants), 1), perform_OS(:, 4);
    5*ones(numel(Bandit.participants), 1), perform_bandit(:, 1);
    6*ones(numel(Bandit.participants), 1), perform_bandit(:, 2);
    7*ones(numel(Bandit.participants), 1), perform_bandit(:, 3);
    8*ones(numel(Bandit.participants), 1), perform_bandit(:, 4);
    9*ones(numel(Bart.participants), 1), perform_bart(:, 1);
    10*ones(numel(Bart.participants), 1), perform_bart(:, 2);
    11*ones(numel(Gambling.participants), 1), perform_gamble(:, 1);
    12*ones(numel(Gambling.participants), 1), perform_gamble(:, 2);];

n_conds = 12;

cond_strs = {'OS neutral-short', 'OS plentiful-short', 'OS neutral-long', 'OS plentiful-long', ...
    'Bandit neutral-short', 'Bandit plentiful-short', 'Bandit neutral-long', 'Bandit plentiful-long', ...
    'BART low', 'BART high', 'Gamble gains', 'Gamble losses'};
cond_strs2 = {'OS 1', 'OS 2', 'OS 3', 'OS 4', ...
    'Bandit 1', 'Bandit 2', 'Bandit 3', 'Bandit 4', ...
    'BART 1', 'BART 2', 'Gamble 1', 'Gamble 2'};

% 66 pairs
pairs = nchoosek(1:n_conds, 2);

% initialize correlations r
r_perform = NaN(length(pairs), 1);
for i = 1:length(pairs)
    
    % get current pair
    tmpPair = pairs(i, :);
    
    % common participants between the pair of tasks
    if tmpPair(1) <= 4 % first param
        participants1 = OptimalStopping.participants;
        tmpPerformance = perform_OS;
    elseif tmpPair(1) <= 8
        participants1 = Bandit.participants;
        tmpPerformance = perform_bandit;
    elseif tmpPair(1) <= 10
        participants1 = Bart.participants;
        tmpPerformance = perform_bart;
    else
        participants1 = Gambling.participants;
        tmpPerformance = perform_gamble;
    end
    
    if tmpPair(2) <= 4 % second param
        participants2 = OptimalStopping.participants;
        tmpPerformance = perform_OS;
    elseif tmpPair(2) <= 8
        participants2 = Bandit.participants;
        tmpPerformance = perform_bandit;
    elseif tmpPair(2) <= 10
        participants2 = Bart.participants;
        tmpPerformance = perform_bart;
    else
        participants2 = Gambling.participants;
        tmpPerformance = perform_gamble;
    end
    participantsCommon = intersect(participants1, participants2);
    nsubj = numel(participantsCommon);
    % index of both task parameter means of relevant participants
    [~, ind1] = ismember(participantsCommon, participants1);
    [~, ind2] = ismember(participantsCommon, participants2);
    
    % performance of 1st param
    tmpPerform1 = perform_overall(perform_overall(:, 1) == tmpPair(1), 2);
    tmpPerform1 = tmpPerform1(ind1);
    
    % performance of 2nd param
    tmpPerform2 = perform_overall(perform_overall(:, 1) == tmpPair(2), 2);
    tmpPerform2 = tmpPerform2(ind2);
    
    % update r means
    r_perform(i) = corr(tmpPerform1, tmpPerform2);
    
end

% reshape r means into a 12 x 12 matrix
r_matrix = NaN(n_conds, n_conds);
for i = 1:length(pairs)
    r_matrix(pairs(i, 1), pairs(i, 2)) = r_perform(i);

end

%% make figure

scale = 700;
alpha = .8;
edgecolor = [1 1 1];
lincol = [.7 .7 .7];

figure(1); clf;
set(gcf,'units','norm','pos',[.1 .1 .7*1 .8*1],'paperpositionmode','auto',...
    'color','w');
for i = 1:length(pairs)
    
    % current r mean and marker size
    tmpR = r_perform(i);
    tmpSz = abs(tmpR)*scale;
    if tmpR > 0
%         color = [.3 .6 .9];
        color = [.45 .75 .9];
    elseif tmpR < 0
        color = [1 .5 .5];
    end
    
    % plot circle representing size and color
    scatter(pairs(i, 1), pairs(i, 2), tmpSz, 'o', 'markerfacecolor', color, ...
        'markeredgecolor', edgecolor, 'markerfacealpha', alpha)
    hold on;
    
%     % give correlation as text
%     txt = num2str(round(r_perform(i), 2));
%     text(pairs(i, 1), pairs(i, 2), txt, 'fontsize', 14);
    
end
% make full size circle of r = 1 on diagonal
scatter(1:12, 1:12, scale, 'o', 'markerfacecolor', color, ...
    'markeredgecolor', edgecolor, 'markerfacealpha', alpha)
hold on;


set(gca, 'xlim', [.5, n_conds + .5], 'ylim', [.5, n_conds + .5], ...
    'fontsize', 18, 'ticklength', [0 0], 'xaxisLocation', 'top')
xticks(1:n_conds)
xticklabels(cond_strs2)
xtickangle(90)
yticks(1:n_conds)
yticklabels(cond_strs2)
% plot grid lines
g_lines = 0.5:1:(n_conds + .5); % user defined grid
for i=1:length(g_lines)
   plot([g_lines(i) g_lines(i)], [g_lines(1) g_lines(end)], ':', 'color', [.6 .6 .6]) %y grid lines
   hold on;
   plot([g_lines(1) g_lines(end)], [g_lines(i) g_lines(i)], ':', 'color', [.6 .6 .6]) %x grid lines
   hold on    
end

% make legend
legend_str = {'$|r|$ = 1', '$|r|$ = .75', '$|r|$ = .5', '$|r|$ = .25'};
legend_sz = [1 .75 .5 .25]*scale;
legend_loc = [8, 5;
    8, 4;
    8, 3;
    8, 2];
for i = 1:length(legend_sz)
    scatter(legend_loc(i, 1), legend_loc(i, 2), legend_sz(i), 'o', 'markerfacecolor', lincol, ...
        'markeredgecolor', edgecolor, 'markerfacealpha', alpha)
    hold on;
    text(legend_loc(i, 1) + 1.5, legend_loc(i, 2), legend_str{i}, ...
        'Interpreter', 'LaTeX', 'fontsize', 18);
    hold on;
end

xlabel('Task and Condition', 'fontsize', 18)
ylabel('Task and Condition', 'fontsize', 18)

pbaspect([1 1 1])

% save eps
% print -depsc performance_corr.eps

