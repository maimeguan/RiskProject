% This script makes the figures for the Optimal Stopping task for thesis

%% load data

load('/Users/Maime/Dropbox/RiskStudy/OptimalStopping/OptimalStopping.mat')
load('/Users/Maime/Dropbox/RiskStudy/OptimalStopping/OS_BFO.mat')

nsubj = numel(OptimalStopping.participants);

optimalthresholds = [[optimal_thresholds(4, [1, 1])*100, zeros(1, 4)];
    [optimal_thresholds(4, [4, 2])*100, zeros(1, 4)];
    optimal_thresholds(8, [1, 1])*100;
    optimal_thresholds(8, [4, 2])*100;];

t4 = linspace(0, 1, 4);
t8 = linspace(0, 1, 8);

%% get inferred thresholds tau means

alphaMeans = [get_matrix_from_coda(chains, 'alpha4', @mean), ...
    get_matrix_from_coda(chains, 'alpha8', @mean)];
betaMeans = [get_matrix_from_coda(chains, 'beta4', @mean), ...
    get_matrix_from_coda(chains, 'beta8', @mean)];
gammaMeans = [get_matrix_from_coda(chains, 'gamma4', @mean), ...
    get_matrix_from_coda(chains, 'gamma8', @mean)];
% get threshold means
tauMeans = NaN(nsubj, OptimalStopping.ncond, 8);
for m = 1:OptimalStopping.ncond
    if m == 1
        opt = optimalthresholds(1, 1:OptimalStopping.nstim(m));
        t = t4;
    elseif m == 2
        opt = optimalthresholds(2, 1:OptimalStopping.nstim(m));
        t = t4;
    elseif m == 3
        opt = optimalthresholds(3, 1:OptimalStopping.nstim(m));
        t = t8;
    elseif m == 4
        opt = optimalthresholds(4, 1:OptimalStopping.nstim(m));
        t = t8;
    end
    tauMeans(:, m, 1:OptimalStopping.nstim(m)-1) = normcdf(norminv(opt(1:end-1)/100) + ...
        betaMeans(:, m) + gammaMeans(:, m) .* t(1:end-1))*100;
    % set last one to zero
    tauMeans(:, m, OptimalStopping.nstim(m)) = 0;
    
end


%% make figure of all inferred thresholds

% sky blue: [.3 .6 1]
% tiffany green: [.4 .85 .7]

% plot inferred thresholds
nstim = [4, 4, 8, 8];

% add representative participants as dashed and dotted lines
rep_participants = [52, 53]; % 52 is risk seeking, 53 is risk averse

figure(1);clf;
set(gcf,'units','norm','pos',[.1 .1 .7*1 .7*1],'paperpositionmode','auto',...
    'color','w');

for i = 1:OptimalStopping.ncond
    subplot(2, 2, i)
    if mod(i, 2)
        environ = 'neutral';
        color = [.45 .75 .9];
    else
        environ = 'plentiful';
        color = [1 .5 .5];
    end
    
    % plot inferred thresholds for all participants
    for ctr = 1:nsubj
        if ~ismember(ctr, rep_participants)
            plot(1:nstim(i), squeeze(tauMeans(ctr, i, 1:OptimalStopping.nstim(i)))', ...
                '-o', 'linewidth', .5, 'color', color, 'markersize', 3, ...
                'markerfacecolor', [1 1 1], 'markeredgecolor', [.7 .7 .7]);
            hold on;
        end
    end
    
    % plot risk averse participant
    plot(1:nstim(i), squeeze(tauMeans(rep_participants(1), i, 1:OptimalStopping.nstim(i)))', ...
            ':k', 'linewidth', 3);
        hold on;
    
    % plot risk seeking participant
    plot(1:nstim(i), squeeze(tauMeans(rep_participants(2), i, 1:OptimalStopping.nstim(i)))', ...
            '--k', 'linewidth', 3);
        hold on;
    
    % plot optimal threshold
    plot(1:nstim(i), optimalthresholds(i, 1:OptimalStopping.nstim(i)), 'k-', 'linewidth', 3);
    hold on;
    
    set(gca, 'box', 'off', 'xlim', [.5, nstim(i)+.5], 'xtick', 1:nstim(i), 'fontsize', 18, ...
        'ticklength', [0 0])
    title(['Length ', num2str(OptimalStopping.nstim(i)), ': ', environ], ...
        'fontsize', 18)
    xlabel('Position', 'fontsize', 18)
    ylabel('Value', 'fontsize', 18)

end


% save eps
% print -depsc OS_allthresholds_pub.eps


%% make figure with the representative participants

% very positive beta and gamma: risk averse (subj 52 out of 53)

% plot the four thresholds for risk averse participant
tmpTau = squeeze(tauMeans(52, :, :));
figure(2);clf;
set(gcf,'units','norm','pos',[.1 .1 .7*1 .5*1],'paperpositionmode','auto',...
    'color','w');
linewidth = 2.5;
markersz = 8;

subplot(1, 2, 1)
for m = 1:OptimalStopping.ncond
    if mod(m, 2)
        color = [.3 .6 .9];
    else
        color = [1 .5 .5];
    end
    plot(1:OptimalStopping.nstim(m), tmpTau(m, 1:OptimalStopping.nstim(m)), ...
        '-o', 'linewidth', linewidth, 'color', color, 'markersize', 10, ... 
        'markerfacecolor', color, 'markeredgecolor', [1 1 1]);
%     'markerfacecolor', [1 1 1], 'markeredgecolor', [.7 .7 .7]);
    hold on;
    
    % plot optimal thresholds
    plot(1:nstim(m), optimalthresholds(m, 1:OptimalStopping.nstim(m)), ':', ...
        'color', [.7 .7 .7], 'linewidth', linewidth);
    hold on;
    
    set(gca, 'box', 'off', 'xlim', [.5, OptimalStopping.nstim(m)+.5], 'ylim', [0 100], ...
        'xtick', 1:OptimalStopping.nstim(m), 'fontsize', 18, 'ticklength', [0 0])
    title('Risk-seeking participant', 'fontsize', 18)
    xlabel('Position', 'fontsize', 18)
    ylabel('Value', 'fontsize', 18)
    
end

% plot the four thresholds for risk seeking participant
tmpTau = squeeze(tauMeans(53, :, :));
subplot(1, 2, 2)
for m = 1:OptimalStopping.ncond
    if mod(m, 2)
        color = [.3 .6 .9];
    else
        color = [1 .5 .5];
    end
    plot(1:OptimalStopping.nstim(m), tmpTau(m, 1:OptimalStopping.nstim(m)), ...
        '-o', 'linewidth', linewidth, 'color', color, 'markersize', 10, ... 
        'markerfacecolor', color, 'markeredgecolor', [1 1 1]);
%     'markerfacecolor', [1 1 1], 'markeredgecolor', [.7 .7 .7]);
    hold on;
    
    % plot optimal thresholds
    plot(1:nstim(m), optimalthresholds(m, 1:OptimalStopping.nstim(m)), ':', ...
        'color', [.7 .7 .7], 'linewidth', linewidth);
    hold on;
    
    set(gca, 'box', 'off', 'xlim', [.5, OptimalStopping.nstim(m)+.5], 'ylim', [0 100], ...
        'xtick', 1:OptimalStopping.nstim(m), 'fontsize', 18, 'ticklength', [0 0])
    title('Risk-averse participant', 'fontsize', 18)
    xlabel('Position', 'fontsize', 18)
    ylabel('Value', 'fontsize', 18)
    
end

% save eps
% print -depsc OS_twoparticipants.eps


%% make four beta gamma scatterhists

rep_participants = [52, 53];

shift = .12;
scale = .6;
linwidth = 2;
markersz = 50;
minx = -2;
maxx = 2;
miny = -2;
maxy = 2;
ftsz = 18;
color = [.45 .75 .9];
edges = -2:.2:2;
histops = {'facecolor', [.7 .7 .7], 'edgecolor', [1 1 1]};
title_strs = {'Neutral, Len 4', 'Plentiful, Len 4', 'Neutral, Len 8', 'Plentiful, Len 8'};


figure(3); clf;
set(gcf,'units','norm','pos',[.1 .1 .6*1 .8*1],'paperpositionmode','auto',...
    'color','w');

for m = 1:OptimalStopping.ncond
    
    % current condition means
    x = betaMeans(:, m);
    y = gammaMeans(:, m);
    
    subplot(2, 2, m)
    % scatterplot
    scatter(x, y, markersz, 'markerfacecolor', color, ...
        'markeredgecolor', [1 1 1]); hold on;
    set(gca, 'box', 'off', 'ticklength', [0 0], 'fontsize', ftsz, ...
        'xtick', -2:1:2, 'ytick', -2:1:2, 'xlim', [minx, maxx], 'ylim', [miny, maxy])
    ax1 = gca;
    % plot grid lines of y = 0 and x = 0
    plot([0 0],get(gca,'ylim'),':', 'color', [.7 .7 .7], 'linewidth', linwidth); hold on;
    plot(get(gca,'xlim'),[0 0 ],':', 'color', [.7 .7 .7], 'linewidth', linwidth); hold on;
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
    title(title_strs{m}, 'fontsize', ftsz);
    
    % set y axes and plot y
    ypos = scatterpos;
    ypos(1) = ypos(1) - 1.6*shift;
    ypos(3) = ypos(3)*scale;
    ax2 = axes('Position', ypos);
    histogram(y, edges,'Orientation','horizontal', histops{:}, 'parent', ax2);
    set(gca, 'XDir', 'reverse', 'box', 'off', 'fontsize', ftsz, ...
        'YAxisLocation', 'right', 'ytick', []);
    ax2.XAxis.Visible = 'off';
    ylabel('\gamma', 'fontsize', ftsz)
    
    % set x axes and plot x
    xpos = scatterpos;
    xpos(2) = xpos(2) - 1.8*shift;
    xpos(4) = xpos(4)*scale;
    ax3 = axes('Position', xpos);
    histogram(x, edges, histops{:}, 'parent', ax3);
    set(gca, 'YDir', 'reverse', 'box', 'off', 'fontsize', ftsz, ...
        'XAxisLocation', 'top', 'xtick', []);
    ax3.YAxis.Visible = 'off';
    xlabel('\beta', 'fontsize', ftsz)
    
end
clear T;

% save eps
% print -depsc OS_betagammascatterfull.eps


%% learning across 4 blocks (1-10, 11-20, 21-30, 31-40)

blocks = [1 10;
    11 20;
    21 30;
    31 40];
learning_perform = NaN(numel(OptimalStopping.participants), ...
    OptimalStopping.ncond, OptimalStopping.nprob);
for i = 1:numel(OptimalStopping.participants)
    for m = 1:OptimalStopping.ncond
        for j = 1:OptimalStopping.nprob
            tmpMax = max(OptimalStopping.stimuli(OptimalStopping.participants(i), j, m, :));
            indMax = find(OptimalStopping.stimuli(OptimalStopping.participants(i), j, m, :) == tmpMax);
            if OptimalStopping.decisions(OptimalStopping.participants(i), j, m) == indMax
                learning_perform(i, m, j) = 1;
            else
                learning_perform(i, m, j) = 0;
            end
        end
    end
end
% learning_perform = squeeze(mean(learning_perform, 3));

% separate into blocks
perform_blocks = NaN(numel(OptimalStopping.participants), OptimalStopping.ncond, 4);
for i = 1:numel(OptimalStopping.participants)
    for m = 1:OptimalStopping.ncond
        perform_blocks(i, m, 1) = mean(reshape(learning_perform(i, m, blocks(1, 1):blocks(1, 2)), 1, []));
        perform_blocks(i, m, 2) = mean(reshape(learning_perform(i, m, blocks(2, 1):blocks(2, 2)), 1, []));
        perform_blocks(i, m, 3) = mean(reshape(learning_perform(i, m, blocks(3, 1):blocks(3, 2)), 1, []));
        perform_blocks(i, m, 4) = mean(reshape(learning_perform(i, m, blocks(4, 1):blocks(4, 2)), 1, []));
    end
end
% aggregate across all participants
perform_blocks = squeeze(mean(perform_blocks, 1));

figure(4); clf;
set(gcf,'units','norm','pos',[.1 .1 .5*1 .5*1],'paperpositionmode','auto',...
    'color','w');

ops = {'k-o', 'k-o', 'k-s', 'k-s'};
color = [.45 .75 .9;
    1 .5 .5;
    .45 .75 .9;
    1 .5 .5];
for i = 1:OptimalStopping.ncond
    plot(1:4, perform_blocks(i, :), ops{i}, 'markerfacecolor', color(i, :), ...
        'markeredgecolor', [1 1 1], ...
        'linewidth', linewidth, 'markersize', markersz)
    hold on;
end
% plot performance when following optimal rule
% plot([0.5, 4.5], [.6392, .6392], '--', 'linewidth', linewidth + 1, 'color', [.7 .7 .7]); hold on;
% plot([0.5, 4.5], [.6392, .6392], '--', 'linewidth', linewidth + 1, 'color', [.7 .7 .7]);
set(gca,'ticklength', [0 0],'box','off','fontsize',18,'color','none', ...
    'xlim', [0.5, 4.5], 'ylim', [0, 1], 'xticklabels', {'1-10', '11-20', '21-30', '31-40'}, ...
    'XTick', 1:4);
legend({'Neutral, Len 4', 'Plentiful, Len 4', 'Neutral, Len 8', ...
    'Plentiful, Len 8'}, 'location', 'northeast', 'fontsize', 18)
xlabel('Problems', 'fontsize', 18)
ylabel('Proportion Correct', 'fontsize', 18)

% save eps
% print -depsc OS_performance.eps


%% PRESENTATION: optimal thresholds

figure(5); clf;
set(gcf,'units','norm','pos',[.1 .1 .8*1 .5*1],'paperpositionmode','auto',...
    'color','w');
color = [.45 .75 .9;
    1 .5 .5;
    .45 .75 .9;
    1 .5 .5];
linwidth = 2;
markersz = 10;
ftsz = 18;
for m = 1:OptimalStopping.ncond
    
    plot(1:OptimalStopping.nstim(m), optimalthresholds(m, 1:OptimalStopping.nstim(m)), ...
        '-o', 'color', color(m, :), 'linewidth', linwidth, 'markersize', markersz, ...
        'markeredgecolor', [1 1 1], 'markerfacecolor', color(m, :));
    hold on;
end
set(gca, 'box', 'off', 'ticklength', [0 0], 'fontsize', ftsz, ...
    'xtick', 1:1:8, 'ytick', 0:20:100, 'xlim', [0, 9], 'ylim', [0, 100])
xlabel('Position')
ylabel('Value')
legend({'Neutral, Len 4', 'Plentiful, Len 4', 'Neutral, Len 8', ...
    'Plentiful, Len 8'}, 'location', 'northeastoutside', 'fontsize', ftsz)
grid on

%% PRESENTATION: BFO parameterizations

nPositions = 4;

ops = {'linewidth', 4, 'markersize', 10};
t = linspace(0, 1, nPositions);

figure(6); clf;
set(gcf,'units','norm','pos',[.1 .1 .7*1 .5*1],'paperpositionmode','auto',...
    'color','w');

% different parameter values for beta
beta = [1, -1, -.5, 0];
% different parameter values for gamma
gamma = [0, 0, .5, -1];
% different line shapes for each example threshold
colors = [.45 .75 .9;
    1 .5 .5;
    1 .5 1;
    .3 1 .3];

% plot optimal
optthresh = optimal_thresholds(nPositions, [1, 1])*100;
plot(1:nPositions, optthresh, 'k', 'linewidth', 6)
hold on;

% plot other example values for beta and gamma
for i = 1:length(beta)
   mu =  norminv(optthresh/100, 0, 1);
   muPrime = mu + beta(i) + gamma(i).*t;
   tau = normcdf(muPrime)*100;
   plot(1:nPositions, tau, '-', 'color', colors(i, :), ops{:});
   hold on;
end
set(gca, 'box', 'off', 'ticklength', [0 0], 'fontsize', ftsz, ...
    'xtick', 1:1:4, 'ytick', 0:20:100, 'xlim', [.5, 4.5], 'ylim', [0, 100])
grid on
xlabel('Position')
ylabel('Value')
legend({'\beta = \gamma = 0', '\beta = 1, \gamma = 0', '\beta = -1, \gamma = 0', ...
    '\beta = -0.5, \gamma = 0.5', '\beta = 0, \gamma = -1'}, ...
    'location', 'northeastoutside', 'fontsize', 18)


%% posterior predictives

load('/Users/Maime/Dropbox/RiskStudy/Analysis/OS_BFO_full.mat')

% actual decisions
decisions = OptimalStopping.decisions(OptimalStopping.participants, :, :);
% predicted decisions
predyOS = NaN(length(OptimalStopping.participants), OptimalStopping.nprob, OptimalStopping.ncond);
% predy4
predy4OS = get_matrix_from_coda(chains, 'predy4', @mode);
predy4OS([32, 44, 46], :, :) = [];
predyOS(:, :, 1:2) = predy4OS;
% predy8
predy8OS = get_matrix_from_coda(chains, 'predy8', @mode);
predy8OS([32, 44, 46], :, :) = [];
predyOS(:, :, 3:4) = predy8OS;

% posterior predictive agreement
agreeOS = predyOS == decisions;
agreeOS_participants = NaN(OptimalStopping.nsubj, OptimalStopping.ncond);
for i = 1:length(OptimalStopping.participants)
    for m = 1:OptimalStopping.ncond
        agreeOS_participants(i, m) = mean(nanmean(agreeOS(i, :, m)));
    end
end
figure(7); clf;
hist(agreeOS_participants(:))
title('OS posterior predictive')


