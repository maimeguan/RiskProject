% This script makes the figures for the Gambling task for thesis

%% load data

load('/Users/Maime/Dropbox/RiskStudy/Bandit/Bandit.mat')
load('/Users/Maime/Dropbox/RiskStudy/Bandit/Bandit_WSLS.mat')

gammaWin = get_matrix_from_coda(chains, 'gammaWin', @mean);
gammaLose = get_matrix_from_coda(chains, 'gammaLose', @mean);

% decisions WSLS (1 = stay, 2 = shift)
decWSLS = Bandit.decWSLS(Bandit.participants, :, :, :);

%% number of switches following reward vs. failure for all participants

% number of rewards and how many switches per participant
num_switches = NaN(numel(Bandit.participants), Bandit.ncond);
num_rewards = NaN(numel(Bandit.participants), Bandit.ncond);
for i = 1:numel(Bandit.participants)
    for m = 1:Bandit.ncond
        num_rewards(i, m) = sum(nansum(Bandit.rewardChosen(i, :, m, :)));
        num_switches(i, m) = sum(nansum(decWSLS(i, :, m, :) == 2));
    end
end

% look at rate of switch after reward vs. switch after failure
reward_switch = zeros(1, 4);
failure_switch = zeros(1, 4);
for i = 1:numel(Bandit.participants)
    for j = 1:Bandit.nprob
        for m = 1:Bandit.ncond
            for k = 2:Bandit.ntrial(m)
                
                % check if reward or failure on previous chosen alternative
                if Bandit.rewardChosen(i, j, m, k-1) == 0 % prev failure
                    failure_switch(m) = failure_switch(m) + (decWSLS(i, j, m, k) - 1);
                elseif Bandit.rewardChosen(i, j, m, k-1) == 1 % prev reward
                    reward_switch(m) = reward_switch(m) + (decWSLS(i, j, m, k) - 1);
                end
            end
        end
    end
end

% bar plot
figure(1); clf;
set(gcf,'units','norm','pos',[.1 .1 .7*1 .4*1],'paperpositionmode','auto',...
    'color','w');
h = bar([reward_switch', failure_switch']);
h(1).FaceColor = [.5 1 .5];
h(1).EdgeColor = [1 1 1];
h(2).FaceColor = [1 .5 .5];
h(2).EdgeColor = [1 1 1];
% h.FaceAlpha = 0.5;
xticklabs = {'1: Neutral,\newlineLength 8', '2: Plentiful,\newlineLength 8', ...
    '3: Neutral,\newlineLength 16', 'Plentiful,\newlineLength 16'};
set(gca, 'ticklength', [0 0], 'box', 'off', 'fontsize', 18, ...
    'xticklabels', xticklabs);
xlabel('Condition', 'fontsize', 18)
ylabel('Number of Switches', 'fontsize', 18)
legend({'Following Reward', 'Following Failure'}, ...
    'location', 'northeastoutside', 'fontsize', 18)
title('Distribution of switches', 'fontsize', 18)


% save eps
% print -depsc Bandit_rewardsswitches.eps


%% plot switches across position in sequence

switch_positions = zeros(numel(Bandit.participants), Bandit.ncond, max(Bandit.ntrial));
for i = 1:numel(Bandit.participants)
    for j = 1:Bandit.nprob
        for m = 1:Bandit.ncond
            for k = 2:Bandit.ntrial(m)
                if decWSLS(i, j, m, k) == 2 % if shift
                    switch_positions(i, m, k) = switch_positions(i, m, k) + 1;
                end
            end
        end
    end
end

% make figure
figure(2); clf;
set(gcf,'units','norm','pos',[.1 .1 .6*1 1*1],'paperpositionmode','auto',...
    'color','w');

titlestr = {'1: Neutral, Length 8', '2: Plentiful, Length 8', ...
    '3: Neutral, Length 16', '4: Plentiful, Length 16'};
for m = 1:Bandit.ncond
    subplot(4, 1, m)
    
    % plot all switches for every participant
    tmpSwitches = squeeze(switch_positions(:, m, 1:Bandit.ntrial(m)));
    for i = 1:numel(Bandit.participants)
        plot(2:Bandit.ntrial(m), tmpSwitches(i, 2:Bandit.ntrial(m)), '-', ...
            'linewidth', .7, 'color', [.7 .7 .7]);
        hold on;
    end
    
    % plot mean
    plot(2:Bandit.ntrial(m), mean(tmpSwitches(:, 2:Bandit.ntrial(m))), '-', ...
        'linewidth', 4, 'color', [1 .5 .5])
    hold on;
    
    if m <= 2
        xlim = [1.5, Bandit.ntrial(m) + .5];
    else
        xlim = [1, Bandit.ntrial(m) + 1];
    end
    
    set(gca, 'ticklength', [0 0], 'box', 'off', 'fontsize', 18, ...
        'xlim', xlim, 'ylim', [-0.5 45]);
    xticks(1:Bandit.ntrial(m))
    title(titlestr{m}, 'fontsize', 18)
    
    if m == 4
        xlabel('Position', 'fontsize', 18)
        ylabel('Num switches', 'fontsize', 18)
    end
    
end


% save eps
% print -depsc Bandit_participantswitches.eps


%% four representative participants figure

% split switches into following reward vs. failure
reward_switch = zeros(numel(Bandit.participants), Bandit.ncond, max(Bandit.ntrial));
failure_switch = zeros(numel(Bandit.participants), Bandit.ncond, max(Bandit.ntrial));
for i = 1:numel(Bandit.participants)
    for j = 1:Bandit.nprob
        for m = 1:Bandit.ncond
            for k = 2:Bandit.ntrial(m)
                
                % check if reward or failure on previous chosen alternative
                if Bandit.rewardChosen(i, j, m, k-1) == 0 % prev failure
                    failure_switch(i, m, k) = failure_switch(i, m, k) + (decWSLS(i, j, m, k) - 1);
                elseif Bandit.rewardChosen(i, j, m, k-1) == 1 % prev reward
                    reward_switch(i, m, k) = reward_switch(i, m, k) + (decWSLS(i, j, m, k) - 1);
                end
                
            end
        end
    end
end

rep_participants = [42, 4, 8, 43];

% make figure
figure(3); clf;
set(gcf,'units','norm','pos',[.1 .1 .8*1 1*1],'paperpositionmode','auto',...
    'color','w');
plotnum = 1;
environcond = [1 2;
    3 4];
for i = 1:numel(rep_participants)
    for ctr = 1:2
        subplot(4, 2, plotnum)
        
        for environ = 1:2
            if environ == 1
                linetype = '-';
            else
                linetype = ':';
            end
            tmpCond = environcond(ctr, environ);
            % plot switches across position for current participant
            tmpRewardSwitch = squeeze(reward_switch(rep_participants(i), ...
                tmpCond, 2:Bandit.ntrial(tmpCond)));
            plot(2:Bandit.ntrial(tmpCond), tmpRewardSwitch', linetype, ...
                'linewidth', 3, 'color', [.5 1 .5]);
            hold on;
            tmpFailureSwitch = squeeze(failure_switch(rep_participants(i), ...
                tmpCond, 2:Bandit.ntrial(tmpCond)));
            plot(2:Bandit.ntrial(tmpCond), tmpFailureSwitch', linetype, ...
                'linewidth', 3, 'color', [1 .5 .5]);
            hold on;
            
        end
        
        set(gca, 'ticklength', [0 0], 'box', 'off', 'fontsize', 18, ...
            'xlim', [1, Bandit.ntrial(tmpCond)+1], 'ylim', [0 40]);
        xticks(1:max(Bandit.ntrial))
        
        % title
        if mod(plotnum, 2) % if left panel
            conds = [1, 2];
        else
            conds = [3, 4];
        end
        title(['\gamma^{win}=[', num2str(round(gammaWin(rep_participants(i), conds(1)), 2)), ', ', ...
            num2str(round(gammaWin(rep_participants(i), conds(2)), 2)), '] ', ...
            '\gamma^{lose}=[', num2str(round(gammaLose(rep_participants(i), conds(1)), 2)), ', ', ...
            num2str(round(gammaLose(rep_participants(i), conds(2)), 2)), ']'], 'fontsize', 18)
        if ctr == 1
            ylabel(['Participant ', num2str(i)])
        end
        
        if plotnum == 8
            legend({'Neutral, Follow Reward', 'Neutral, Follow Fail', 'Plentiful, Follow Reward', ...
                'Plentiful, Follow Fail'}, 'location', 'northeast', 'fontsize', 13)
        elseif plotnum == 8
            xlabel('Position', 'fontsize', 18)
            ylabel('Num switches', 'fontsize', 18)
        end
        
        % update plot number
        plotnum = plotnum + 1;
    end
    
end


% save eps
% print -depsc Bandit_fourparticipants_rewardfail.eps


%% gammaWin gammaLose scatterhist 4 panels

rep_participants = [42, 4, 8, 43];

shift = .12;
scale = .6;
linwidth = 2;
markersz = 50;
minx = .6;
maxx = 1;
miny = 0;
maxy = .6;
xtickmarks = .6:.2:1;
ytickmarks = 0:.2:.6;
xedges = .6:.05:1;
yedges = 0:.05:.6;
ftsz = 18;
color = [.45 .75 .9];
histops = {'facecolor', [.7 .7 .7], 'edgecolor', [1 1 1]};
title_strs = {'Neutral, Len 8', 'Plentiful, Len 8', 'Neutral, Len 16', 'Plentiful, Len 16'};
    

figure(4); clf;
set(gcf,'units','norm','pos',[.1 .1 .6*1 .8*1],'paperpositionmode','auto',...
    'color','w');

for m = 1:Bandit.ncond
    
    % current condition means
    x = gammaWin(:, m);
    y = gammaLose(:, m);
    
    subplot(2, 2, m)
    % scatterplot
    ah1 = scatter(x, y, markersz, 'markerfacecolor', color, ...
        'markeredgecolor', [1 1 1]); hold on;
    set(gca, 'box', 'off', 'ticklength', [0 0], 'fontsize', ftsz, ...
        'xtick', xtickmarks, 'ytick', ytickmarks, 'xlim', [minx, maxx], 'ylim', [miny, maxy])
    ax1 = gca;
    % label participants
    for i = 1:length(rep_participants)
        T(i) = text(x(rep_participants(i)), ...
            y(rep_participants(i)), int2str(i));
    end
    set(T,'fontsize',ftsz,'fontweight','bold', 'hor', 'cen', 'vert', 'mid');
    % change scatterplot axes
    scatterpos = ax1.Position;
    scatterpos(1) = scatterpos(1) + .8*shift;
    scatterpos(2) = scatterpos(2) + 1*shift;
    scatterpos(3) = scatterpos(3)*scale;
    scatterpos(4) = scatterpos(4)*scale;
    set(ax1, 'Position', scatterpos)
    th = title(title_strs{m}, 'fontsize', ftsz);
    tpos = get( th , 'position');
    tpos(2) = tpos(2) + .05;
    set(th, 'Position', tpos);
    
    % set y axes and plot y
    ypos = scatterpos;
    ypos(1) = ypos(1) - 1.8*shift;
    ypos(3) = ypos(3)*scale;
    ax2 = axes('Position', ypos);
    ah2 = histogram(y, yedges,'Orientation','horizontal', histops{:}, 'parent', ax2);
    set(gca, 'XDir', 'reverse', 'box', 'off', 'fontsize', ftsz, ...
        'YAxisLocation', 'right', 'ytick', []);
    ax2.XAxis.Visible = 'off';
    ylabel('\gamma^{lose}', 'fontsize', ftsz)
    
    % set x axes and plot x
    xpos = scatterpos;
    xpos(2) = xpos(2) - 1.8*shift;
    xpos(4) = xpos(4)*scale;
    ax3 = axes('Position', xpos);
    ah3 = histogram(x, xedges, histops{:}, 'parent', ax3);
    set(gca, 'YDir', 'reverse', 'box', 'off', 'fontsize', ftsz, ...
        'XAxisLocation', 'top', 'xtick', []);
    ax3.YAxis.Visible = 'off';
    xlabel('\gamma^{win}', 'fontsize', ftsz)
    
    
end

% save eps
% print -depsc Bandit_gammaWinLosescatterfull.eps

