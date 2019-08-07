% This script draws the figures for the RISK correlation analyses in thesis

% This script also loads the chains of each pair of correlations, and gets:
% 1) the point estimate (mean) of pearson's correlation r
% 2) the std of pearson's correlation r
% 3) the samples of r from the chains (4 x 1000)

%%

n_samples = 4000;
n_params = 30;

% 435 pairs
pairs = nchoosek(1:n_params, 2);

% parameter names
param_strs = {'OSalpha1', 'OSalpha2', 'OSalpha3', 'OSalpha4', ...
    'OSbeta1', 'OSbeta2', 'OSbeta3', 'OSbeta4', ...
    'OSgamma1', 'OSgamma2', 'OSgamma3', 'OSgamma4', ...
    'BanditgammaW1', 'BanditgammaW2', 'BanditgammaW3', 'BanditgammaW4', ...
    'BanditgammaL1', 'BanditgammaL2', 'BanditgammaL3', 'BanditgammaL4', ...
    'Bartbeta1', 'Bartbeta2', 'BartgammaPlus1', 'BartgammaPlus2', ...
    'Gamblephi', 'Gamblelambda', ...
    'RTI', 'RPS', 'DospertTaking', 'DospertPerception'};
param_strs2 = {'OS \alpha 1', 'OS \alpha 2', 'OS \alpha 3', 'OS \alpha 4', ...
    'OS \beta 1', 'OS \beta 2', 'OS \beta 3', 'OS \beta 4', ...
    'OS \gamma 1', 'OS \gamma 2', 'OS \gamma 3', 'OS \gamma 4', ...
    'Bandit \gamma^w 1', 'Bandit \gamma^w 2', 'Bandit \gamma^w 3', 'Bandit \gamma^w 4', ...
    'Bandit \gamma^l 1', 'Bandit \gamma^l 2', 'Bandit \gamma^l 3', 'Bandit \gamma^l 4', ...
    'Bart \beta 1', 'Bart \beta 2', 'Bart \gamma^+ 1', 'Bart \gamma^+ 2', ...
    'Gamble \phi', 'Gamble \lambda', ...
    'RTI', 'RPS', 'Dospert RT', 'Dospert RP'};
risk_params = [5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20, 23, 24, 26, 27, 28, 29];
param_strs_risk = {'OS \beta 1', 'OS \beta 2', 'OS \beta 3', 'OS \beta 4', ...
    'OS \gamma 1', 'OS \gamma 2', 'OS \gamma 3', 'OS \gamma 4', ...
    'Bandit \gamma^l 1', 'Bandit \gamma^l 2', 'Bandit \gamma^l 3', 'Bandit \gamma^l 4', ...
    'Bart \gamma^+ 1', 'Bart \gamma^+ 2', 'Gamble \lambda', ...
    'RTI', 'RPS', 'Dospert RT', 'Dospert RP'};

% initialize point estimate mean of r
r_means = NaN(length(pairs), 1);
% initialize std of r
r_sds = NaN(length(pairs), 1);
% initialize samples of r
r_samples = NaN(length(pairs), n_samples);
for i = 1:length(pairs)
        
    % get current pair
    tmpPair = pairs(i, :);
    
    % load current pair's correlation .mat file
    filename = strcat('corr_', param_strs{tmpPair(1)}, '_', param_strs{tmpPair(2)});
    load(strcat('AllCorrChains/', filename))
    
    % fill in r means
    r_means(i) = get_matrix_from_coda(chains, 'r', @mean);
    
    % fill in r stds
    r_sds(i) = get_matrix_from_coda(chains, 'r', @std);
    
    % fill in r samples
    r_samples(i, :) = chains.r(:);
    
end


% reshape r means into a 30 x 30 matrix
r_matrix = NaN(n_params, n_params);
for i = 1:length(pairs)
    r_matrix(pairs(i, 1), pairs(i, 2)) = r_means(i);

end


% get log BFs of r against 0 for each pair
r_BFs = NaN(length(pairs), 3);
priordens = unifpdf(0, -1, 1);
for i = 1:length(pairs)
    
    % fill in pairs and name
    r_BFs(i, 1:2) = pairs(i, :);
    
    % compute log BF
    postdens = normpdf(0, r_means(i), r_sds(i));
    r_BFs(i, 3) = log(postdens/priordens);
    
end
r_BFs(isinf(r_BFs)) = 500;

%% make heatmap
% 
% % heatmap
% xnames = {'OSalpha1', 'OSalpha2', 'OSalpha3', 'OSalpha4', ...
%     'OSbeta1', 'OSbeta2', 'OSbeta3', 'OSbeta4', ...
%     'OSgamma1', 'OSgamma2', 'OSgamma3', 'OSgamma4', ...
%     'BanditgammaW1', 'BanditgammaW2', 'BanditgammaW3', 'BanditgammaW4', ...
%     'BanditgammaL1', 'BanditgammaL2', 'BanditgammaL3', 'BanditgammaL4', ...
%     'Bartbeta1', 'Bartbeta2', 'BartgammaPlus1', 'BartgammaPlus2', ...
%     'Gamblephi', 'Gamblelambda', ...
%     'RTI', 'RPS', 'DospertTaking', 'DospertPerception'};
% ynames = {'OSalpha1', 'OSalpha2', 'OSalpha3', 'OSalpha4', ...
%     'OSbeta1', 'OSbeta2', 'OSbeta3', 'OSbeta4', ...
%     'OSgamma1', 'OSgamma2', 'OSgamma3', 'OSgamma4', ...
%     'BanditgammaW1', 'BanditgammaW2', 'BanditgammaW3', 'BanditgammaW4', ...
%     'BanditgammaL1', 'BanditgammaL2', 'BanditgammaL3', 'BanditgammaL4', ...
%     'Bartbeta1', 'Bartbeta2', 'BartgammaPlus1', 'BartgammaPlus2', ...
%     'Gamblephi', 'Gamblelambda', ...
%     'RTI', 'RPS', 'DospertTaking', 'DospertPerception'};
% 
% % custom heatmap using blue (+) - white (0) - red (-)
% 
% america_map = redblue(64);
% 
% figure(1); clf;
% heatmap(xnames, ynames, r_matrix, 'Colormap', america_map)
% ax = gca;
% axp = struct(ax);       % you will get a warning
% axp.Axes.XAxisLocation = 'top';


%% heatmap with circles that correspond to log BFs ** ONLY RELEVANT RISK PARAMS

pairs_risk = nchoosek(risk_params, 2);
pairs_BF = nchoosek(1:length(risk_params), 2);

scale = 250;
color = [.6 .6 .6];
alpha = .8;

figure(2); clf;
set(gcf,'units','norm','pos',[.1 .1 .65*1 .9*1],'paperpositionmode','auto',...
    'color','w');
for i = 1:length(pairs_risk)

    % current BF and marker properties
    tmpBF = r_BFs(r_BFs(:, 1) == pairs_risk(i, 1) & r_BFs(:, 2) == pairs_risk(i, 2), 3);
    if tmpBF < -1 % evidence for nonzero correlation
        markersz = scale;
        facecolor = color;
        edgecolor = [1 1 1];
    elseif tmpBF > 1 % evidence for zero correlation
        markersz = scale;
        facecolor = [1 1 1];
        edgecolor = color;
    elseif tmpBF > -1 && tmpBF < 1 % inconclusive
        markersz = 1;
        facecolor = [1 1 1];
        edgecolor = [1 1 1];
    end
    
    % plot circle representing size and color
    scatter(pairs_BF(i, 1), pairs_BF(i, 2), markersz, 'o', 'markerfacecolor', facecolor, ...
        'markeredgecolor', edgecolor, 'markerfacealpha', alpha)
    hold on;
    
end
set(gca, 'xlim', [.5, length(risk_params) + .5], 'ylim', [.5, length(risk_params) + .5], ...
    'fontsize', 18, 'ticklength', [0 0], 'xaxisLocation', 'top')
xticks(1:length(risk_params))
xticklabels(param_strs_risk)
xtickangle(90)
yticks(1:length(risk_params))
yticklabels(param_strs_risk)
% plot grid lines
g_lines = 0.5:1:(length(risk_params)+.5); % user defined grid
for i=1:length(g_lines)
   plot([g_lines(i) g_lines(i)], [g_lines(1) g_lines(end)], ':', 'color', [.6 .6 .6]) %y grid lines
   hold on;
   plot([g_lines(1) g_lines(end)], [g_lines(i) g_lines(i)], ':', 'color', [.6 .6 .6]) %x grid lines
   hold on    
end

% make boxes around meaningful parameters
linewidth = 1.5;
lincol = [.7 .7 .7];
lintype = '--';
% make full size circle of r = 1 on diagonal
scatter(1:length(risk_params), 1:length(risk_params), scale, 'o', 'markerfacecolor', color, ...
    'markeredgecolor', edgecolor, 'markerfacealpha', alpha)
hold on;
% OS lines
plot([0, 8.5], [8.5, 8.5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
plot([8.5, 8.5], [8.5, length(risk_params) + .5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
% Bandit lines
plot([0 12.5], [12.5, 12.5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
plot([12.5, 12.5], [12.5, length(risk_params) + .5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
% BART lines
plot([0, 14.5], [14.5, 14.5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
plot([14.5, 14.5], [14.5, length(risk_params) + .5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
% Gambling lines
plot([0, 15.5], [15.5, 15.5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
plot([15.5, 15.5], [15.5, length(risk_params) + .5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;

% make legend
legend_str = {'log BF $>$ 1', 'log BF $<$ -1'};
legend_sz = 1*scale;
facecolor = [color;
    1 1 1];
edgecolor = [1 1 1;
    color];
legend_loc = [12, 7;
    12, 5];
for i = 1:length(legend_str)
    scatter(legend_loc(i, 1), legend_loc(i, 2), legend_sz, 'o', ...
        'markerfacecolor', facecolor(i, :), ...
        'markeredgecolor', edgecolor(i, :), 'markerfacealpha', alpha)
    hold on;
    text(legend_loc(i, 1) + 1.5, legend_loc(i, 2), legend_str{i}, ...
        'Interpreter', 'LaTeX', 'fontsize', 18);
    hold on;
end

xlabel('Parameter', 'fontsize', 18)
ylabel('Parameter', 'fontsize', 18)

pbaspect([1 1 1])

% save eps
% print -depsc corr_corrmatBFs.eps


%% heatmap with areas of circles that correspond to posterior means of |r|

scale = 250;
alpha = .8;
edgecolor = [1 1 1];

figure(3); clf;
set(gcf,'units','norm','pos',[.1 .1 .65*1 .9*1],'paperpositionmode','auto',...
    'color','w');
for i = 1:length(pairs)
    
    % only plot point in scatterplot if log BF > 0
    tmpBF = r_BFs(i, 3);
    if tmpBF < 0 % if evidence for nonzero correlation
        
        % current r mean and marker size
        tmpMean = r_means(i);
        tmpSz = abs(tmpMean)*scale;
        if tmpMean > 0
%             color = [.3 .6 .9];
            color = [.45 .75 .9];
        elseif tmpMean < 0
            color = [1 .5 .5];
        end
        
        % plot circle representing size and color
        scatter(pairs(i, 1), pairs(i, 2), tmpSz, 'o', 'markerfacecolor', color, ...
            'markeredgecolor', edgecolor, 'markerfacealpha', alpha)
        hold on;
        
%     elseif tmpBF > 1 % if evidence for zero correlation
%         
%         % plot empty gray circle
%         scatter(pairs(i, 1), pairs(i, 2), scale*.7, 'o', 'markeredgecolor', [.7 .7 .7], ...
%             'linewidth', 1);
%         hold on;
        
    end
end
set(gca, 'xlim', [.5, n_params + .5], 'ylim', [.5, n_params + .5], ...
    'fontsize', 18, 'ticklength', [0 0], 'xaxisLocation', 'top')
xticks(1:n_params)
xticklabels(param_strs2)
xtickangle(90)
yticks(1:n_params)
yticklabels(param_strs2)
% plot grid lines
g_lines = 0.5:1:(n_params + .5); % user defined grid
for i=1:length(g_lines)
   plot([g_lines(i) g_lines(i)], [g_lines(1) g_lines(end)], ':', 'color', [.6 .6 .6]) %y grid lines
   hold on;
   plot([g_lines(1) g_lines(end)], [g_lines(i) g_lines(i)], ':', 'color', [.6 .6 .6]) %x grid lines
   hold on    
end


% make boxes around meaningful parameters
linewidth = 1.5;
lincol = [.7 .7 .7];
lintype = '--';
% make full size circle of r = 1 on diagonal
scatter(1:n_params, 1:n_params, scale, 'o', 'markerfacecolor', [.45 .75 .9], ...
    'markeredgecolor', edgecolor, 'markerfacealpha', alpha)
hold on;
% OS lines
plot([0, 12.5], [12.5, 12.5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
plot([12.5, 12.5], [12.5, n_params + .5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
% Bandit lines
plot([0 20.5], [20.5, 20.5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
plot([20.5, 20.5], [20.5, n_params + .5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
% BART lines
plot([0, 24.5], [24.5, 24.5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
plot([24.5, 24.5], [24.5, n_params + .5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
% Gambling lines
plot([0, 26.5], [26.5, 26.5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;
plot([26.5, 26.5], [26.5, n_params + .5], lintype, 'linewidth', linewidth, 'color', lincol); hold on;

% make legend
legend_str = {'$|r|$ = 1', '$|r|$ = .75', '$|r|$ = .5', '$|r|$ = .25'};
legend_sz = [1 .75 .5 .25]*scale;
legend_loc = [20, 14;
    20, 12;
    20, 10
    20, 8];
for i = 1:length(legend_sz)
    scatter(legend_loc(i, 1), legend_loc(i, 2), legend_sz(i), 'o', 'markerfacecolor', lincol, ...
        'markeredgecolor', edgecolor, 'markerfacealpha', alpha)
    hold on;
    text(legend_loc(i, 1) + 1.5, legend_loc(i, 2), legend_str{i}, ...
        'Interpreter', 'LaTeX', 'fontsize', 18);
    hold on;
end

xlabel('Parameter', 'fontsize', 18)
ylabel('Parameter', 'fontsize', 18)

pbaspect([1 1 1])

% save eps
% print -depsc corr_corrmatRmeans.eps


%% make 2 panel plot with 95% credible intervals on left and log BFs on right

% need: r_means, r_sds, r_samples

% initialize 95% credible interval bounds (lower, median, upper)
r_credintervals = NaN(length(pairs), 5);
% initialize log BFs matrix
r_BFs = NaN(length(pairs), 3);
% get BFs of r against 0 for each pair
priordens = unifpdf(0, -1, 1);
for i = 1:length(pairs)
    
    % fill in pairs and name
    r_BFs(i, 1:2) = pairs(i, :);
    r_credintervals(i, 1:2) = pairs(i, :);
    
    % compute log BF
    postdens = normpdf(0, r_means(i), r_sds(i));
    r_BFs(i, 3) = log(postdens/priordens);
    
    % 95% bayesian credible interval
    r_credintervals(i, 3:5) = quantile(r_samples(i, :), [.025, .5, .975]);
    
end

% which ones have more than moderate evidence? only keep those
evidence_strength = 6;
ind = find(r_BFs(:, 3) < -evidence_strength);
r_strong = [r_BFs(ind, :), r_credintervals(ind, 3:5)];

% order by log BFs (but take negative)
r_strong(:, 3) = -r_strong(:, 3);
r_strong = sortrows(r_strong, 3);
r_strong(isinf(r_strong)) = 600;

% make plot
figure(4); clf;
set(gcf,'units','norm','pos',[.1 .1 .9*1 1*1],'paperpositionmode','auto',...
    'color','w');
markersz = 4.5;
poscolor = [.3 .6 .9];
negcolor = [1 .5 .5];
lincolor = [.7 .7 .7];

% left panel of 95% credible intervals
h1 = subplot(1, 2, 1);
get(h1, 'position')
% set(h1, 'position', [0.1800 0.1100 0.3347 0.8050]);
set(h1, 'position', [0.1850 0.1100 0.3847 0.8550]);
yticklabs = cell(1, length(r_strong));
for i = 1:length(r_strong)
    
    % color according to positive or negative corr
    if r_strong(i, 5) > 0
        color = poscolor;
    else
        color = negcolor;
    end
    
    % plot line for CI
    plot([r_strong(i, 4), r_strong(i, 6)], [i, i], 'linewidth', 1.5, ...
        'color', lincolor); hold on;
    % plot lower bound
    plot(r_strong(i, 4), i, 'o', 'markersize', markersz, ...
        'markerfacecolor', color, 'markeredgecolor', color); hold on;
    % plot median
    plot(r_strong(i, 5), i, 'o', 'markersize', markersz, ...
        'markerfacecolor', color, 'markeredgecolor', color); hold on;
    % plot upper bound
    plot(r_strong(i, 6), i, 'o', 'markersize', markersz, ...
        'markerfacecolor', color, 'markeredgecolor', color); hold on;
    yticklabs{i} = [param_strs2{r_strong(i, 1)}, '-',param_strs2{r_strong(i, 2)}];
    
end
plot([0, 0], [0, length(r_strong)+.5], ':', 'linewidth', 3, 'color', lincolor)
set(gca, 'box', 'off', 'fontsize', 15, 'ticklength', [0 0], ...
    'YGrid', 'on', 'XGrid', 'off', 'ylim', [0, length(r_strong)])
yticks(1:length(r_strong))
yticklabels(yticklabs);
xlabel('95% Bayesian Credible Interval', 'fontsize', 18)


% right panel with BFs
cutoff = 20; % cut off in right panel showing log BFs greater than ____
r_strongcut = r_strong;
r_strongcut(r_strongcut(:, 3) > cutoff, 3) = cutoff;
h2 = subplot(1, 2, 2);
get(h2, 'position')
% set(h2, 'Position', [0.5303 0.1100 0.3347 0.8250]);
set(h2, 'Position', [0.6003 0.1100 0.3047 0.8850]);
barh(r_strongcut(:, 3), 'facecolor', lincolor, 'edgecolor', [1 1 1])
set(gca, 'box', 'off', 'fontsize', 15, 'ticklength', [0 0], ...
    'yticklabel', [], 'YGrid', 'on', 'XGrid', 'off')
xticklabels({'0', '5', '10', '15', '>20'})
yticks(1:length(r_strongcut))
xlabel('Log Bayes Factors', 'fontsize', 18)

% save eps
% print -depsc corr_CIsandBFs.eps


%% scatterplot matrix of handpicked parameters

% 1: OS beta 1 (5)
% 2: Bandit gammaLose 1 (17)
% 3: Bart gammaplus 1 (23)
% 4: Gamble lambda (26)

picked_params = {'OS \beta', 'Bandit \gamma^{lose}', 'Bart \gamma^+', 'Gamble \lambda'};

% load data
oschains = load('OS_chains.mat');
banditchains = load('Bandit_chains.mat');
bartchains = load('Bart_chains.mat');
gamblechains = load('Gambling_chains.mat');

beta_means = get_matrix_from_coda(oschains.chains, 'beta4', @mean);
gammaLose_means = get_matrix_from_coda(banditchains.chains, 'gammaLose', @mean);
gammaplus_means = get_matrix_from_coda(bartchains.chains, 'gamma', @mean);
lambda_means = get_matrix_from_coda(gamblechains.chains, 'lambda', @mean);

n_params = 4;
pairs = nchoosek(1:n_params, 2);
picked_pairs = [5, 17;
    5, 23;
    5, 26
    17, 23;
    17, 26;
    23, 26];


% make plot
color = [.45 .75 .9];
markersz = 70;
figure(5); clf;
set(gcf,'units','norm','pos',[.1 .1 .8*1 .9*1],'paperpositionmode','auto',...
    'color','w');
for i = 1:length(pairs)
    
    % get current pair
    tmpPair = pairs(i, :);
    
    % common participants between the pair of tasks
    if tmpPair(1) == 1 % first param
        participants1 = OptimalStopping.participants;
        tmpParam1_means = beta_means(:, 1);
    elseif tmpPair(1) == 2
        participants1 = Bandit.participants;
        tmpParam1_means = gammaLose_means(:, 1);
    elseif tmpPair(1) == 3
        participants1 = Bart.participants;
        tmpParam1_means = gammaplus_means(:, 1);
    else
        participants1 = Gambling.participants;
        tmpParam1_means = lambda_means;
    end
    
    if tmpPair(2) ==1 % second param
        participants2 = OptimalStopping.participants;
        tmpParam2_means = beta_means(:, 1);
    elseif tmpPair(2) == 2
        participants2 = Bandit.participants;
        tmpParam2_means = gammaLose_means(:, 1);
    elseif tmpPair(2) == 3
        participants2 = Bart.participants;
        tmpParam2_means = gammaplus_means(:, 1);
    else
        participants2 = Gambling.participants;
        tmpParam2_means = lambda_means;
    end
    participantsCommon = intersect(participants1, participants2);
    % index of both task parameter means of relevant participants
    [~, ind1] = ismember(participantsCommon, participants1);
    [~, ind2] = ismember(participantsCommon, participants2);
    
    tmpParam1_means = tmpParam1_means(ind1);
    tmpParam2_means = tmpParam2_means(ind2);
    
    % plot scatterplots in subplots
    subplotInd = sub2ind([n_params, n_params], tmpPair(1), tmpPair(2));
    subplot(n_params, n_params, subplotInd)
    scatter(tmpParam1_means, tmpParam2_means, markersz, 'markerfacecolor', color, ....
        'markeredgecolor', [1 1 1])
    hold on;
    
    set(gca,'ticklength', [0 0],'box','off','fontsize', 18,'color','none');
    % only put axis labels where needed
    if subplotInd == 5
        ylabel(picked_params{tmpPair(2)}, 'fontsize', 18)
    elseif subplotInd == 9
        ylabel(picked_params{tmpPair(2)}, 'fontsize', 18)
    elseif subplotInd == 13
        xlabel(picked_params{tmpPair(1)}, 'fontsize', 18)
        ylabel(picked_params{tmpPair(2)}, 'fontsize', 18)
    elseif subplotInd == 14
        xlabel(picked_params{tmpPair(1)}, 'fontsize', 18)
    elseif subplotInd == 15
        xlabel(picked_params{tmpPair(1)}, 'fontsize', 18)
        xlim([0 2])
        xticklabels({'0', '1', '2'})
        xticks([0, 1, 2])
    end
    
%     % print correlations in subplots
%     subplotInd = sub2ind([n_params, n_params], tmpPair(2), tmpPair(1));
%     subplot(n_params, n_params, subplotInd)
%     
%     text(0.5, 0.5, ['{\it r} = ', num2str(round(corr(tmpParam1_means, tmpParam2_means), 2))], ...
%         'FontSize', 30, 'Color','k', 'HorizontalAlignment','Center', ...
%         'VerticalAlignment','Middle', 'Interpreter', 'tex'); hold on;
%     axis off
    
end

% plot histograms along axis
histInds = [1, 6, 11, 16];
for i = histInds
    
    subplot(n_params, n_params, i)
    if i == 1
        tmpParam_means = beta_means(:, 1);
        xtickmarks = [-2, 0, 2];
        xticklabs = {'-2', '0', '2'};
        xlimits = [-2, 2];
    elseif i == 6
        tmpParam_means = gammaLose_means(:, 1);
        xtickmarks = [0, .5, 1];
        xticklabs = {'0', '0.5', '1'};
        xlimits = [0, 1];
    elseif i == 11
        tmpParam_means = gammaplus_means(:, 1);
        xtickmarks = [0, 1, 2];
        xticklabs = {'0', '1', '2'};
        xlimits = [0, 2];
    else
        tmpParam_means = lambda_means(:, 1);
        xtickmarks = [0, 1, 2, 3];
        xticklabs = {'0', '1', '2', '3'};
        xlimits = [0, 3];
    end
    
    histogram(tmpParam_means, 10, 'FaceColor', [.7 .7 .7], 'edgecolor', [1 1 1])
    set(gca,'ticklength', [0 0],'box','off','fontsize',18,'color','none', ...
        'xticklabels', xticklabs, 'xlim', xlimits);
    xticks(xtickmarks)
    if i == 1
        ylabel('OS \beta', 'fontsize', 18)
    elseif i == 16
        xlabel('Gamble \lambda', 'fontsize', 18)
    end
end

% % plot posteriors of r
for i = 1:length(pairs)
    
    % get current pair
    tmpPair = pairs(i, :);
    tmpPairpicked = picked_pairs(i, :);
    
    % get r samples of this pair
    % load current pair's correlation .mat file
    filename = strcat('corr_', param_strs{tmpPairpicked(1)}, '_', param_strs{tmpPairpicked(2)});
    load(strcat('AllCorrChains/', filename))
    tmpRsamples = chains.r(:);
    
    % plot posterior density of r
    subplotInd = sub2ind([n_params, n_params], tmpPair(2), tmpPair(1));
    subplot(n_params, n_params, subplotInd)
    h = histfit(tmpRsamples, 10, 'kernel');
    h(1).FaceColor = [1 1 1];
    h(1).EdgeColor = [1 1 1];
    h(2).Color = [.3 .3 .3];
    set(gca,'ticklength', [0 0],'box','off','fontsize',18,'color','none', ...
        'xticklabels', {'-1', '0', '1'}, 'xlim', [-1 1], 'yticklabels', {});
    xlabel('$r$', 'Interpreter', 'Latex', 'fontsize', 18)

end

% save eps
% print -depsc corr_exampleparams.eps

