% This script makes the figures for the BART task for thesis

%% load data

load('/Users/Maime/Dropbox/RiskStudy/BART/Bart.mat')
load('/Users/Maime/Dropbox/RiskStudy/BART/Bart_censored_paramsonly.mat')

nsubj = numel(Bart.participants);
probPop = [.1, .2];

% posterior means for gamma, beta, omega
gammaMeans = get_matrix_from_coda(chains, 'gamma', @mean);
betaMeans = get_matrix_from_coda(chains, 'beta', @mean);
omegaMeans = get_matrix_from_coda(chains, 'omega', @mean);

% decisions on just those problems where banked
decBanked = NaN(numel(Bart.participants), Bart.nprob, Bart.ncond);
for i = 1:numel(Bart.participants)
    for j = 1:Bart.nprob
        for m = 1:Bart.ncond
            % if banked on this problem
            if Bart.decisions(Bart.participants(i), j, m, 1) == 0
                decBanked(i, j, m) = Bart.decisions(Bart.participants(i), j, m, 2);
            else
                decBanked(i, j, m) = NaN;
            end
        end
    end
end

%% 4 representative participants

% high gamma, high beta (risk seeking, consistent): 5 / 44
% high gamma, low beta (risk seeking, inconsistent: 43 / 44
% low gamma, high beta (risk averse, consistent): 33 / 44
% low gamma, low beta (risk averse, inconsistent: 20 / 44

rep_participants = [5, 43, 33, 20];
color = [.45 .75 .9];

figure(1); clf;
set(gcf,'units','norm','pos',[.1 .1 .6*1 .9*1],'paperpositionmode','auto',...
    'color','w');
plotnum = 1;
num = 1;
for i = rep_participants
    for cond = 1:Bart.ncond
        subplot(length(rep_participants), Bart.ncond, plotnum)
        % second column is frequency
        histogram(decBanked(i, :, cond), 1:20, ...
            'FaceColor', color, 'edgecolor', [1 1 1])
        ylim([0, 35])
        title(['\gamma^{+}=', num2str(round(gammaMeans(i, cond), 2)), ...
            ', \beta=', num2str(round(betaMeans(i, cond), 2)), ...
            ', \omega=', num2str(round(omegaMeans(i, cond), 2))], ...
            'fontsize', 20)
        plotnum = plotnum + 1;
        
        set(gca, 'box', 'off', 'fontsize', 18, 'color', 'none', ...
            'TitleFontSizeMultiplier', 1.2);
        xlabel('Number of Pumps', 'fontsize', 18)
        
        if cond == 1
            ylabel(['Participant ', num2str(num)])
        end
    end
    num = num + 1;
end

% save eps
% print -depsc Bart_fourparticipants.eps

%% make figure of scatterplot of beta and gammaplus with marginal histograms

rep_participants = [5, 43, 33, 20];

shift = .12;
scale = .6;
linwidth = 2;
markersz = 50;
minx = 0;
maxx = 3;
miny = 0;
maxy = 10;
y_ticks = 0:2:10;
x_ticks = 0:1:3;
yedges = 0:.5:10;
xedges = 0:.2:3;
ftsz = 18;
color = [.45 .75 .9];
histops = {'facecolor', [.7 .7 .7], 'edgecolor', [1 1 1]};
title_strs = {'p = 0.1', 'p = 0.2'};
    

figure(2); clf;
set(gcf,'units','norm','pos',[.1 .1 .8*1 .5*1],'paperpositionmode','auto',...
    'color','w');

for m = 1:Bart.ncond
    
    % current condition means
    x = gammaMeans(:, m);
    y = betaMeans(:, m);
    
    subplot(1, 2, m)
    % scatterplot
    ah1 = scatter(x, y, markersz, 'markerfacecolor', color, ...
        'markeredgecolor', [1 1 1]); hold on;
    set(gca, 'box', 'off', 'ticklength', [0 0], 'fontsize', ftsz, ...
        'xtick', x_ticks, 'ytick', y_ticks, 'xlim', [minx, maxx], 'ylim', [miny, maxy])
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
    scatterpos(2) = scatterpos(2) + 2.5*shift;
    scatterpos(3) = scatterpos(3)*scale;
    scatterpos(4) = scatterpos(4)*scale;
    set(ax1, 'Position', scatterpos)
    th = title(title_strs{m}, 'fontsize', ftsz);
    tpos = get( th , 'position');
    tpos(2) = tpos(2) + .05;
    set(th, 'Position', tpos);
    
    % set y axes and plot y
    ypos = scatterpos;
    ypos(1) = ypos(1) - 1.35*shift;
    ypos(3) = ypos(3)*scale*.8;
    ax2 = axes('Position', ypos);
    ah2 = histogram(y, yedges,'Orientation','horizontal', histops{:}, 'parent', ax2);
    set(gca, 'XDir', 'reverse', 'box', 'off', 'fontsize', ftsz, ...
        'YAxisLocation', 'right', 'ytick', []);
    ax2.XAxis.Visible = 'off';
    ylabel('\beta', 'fontsize', ftsz)
    
    % set x axes and plot x
    xpos = scatterpos;
    xpos(2) = xpos(2) - 3*shift;
    xpos(4) = xpos(4)*scale*.8;
    ax3 = axes('Position', xpos);
    ah3 = histogram(x, xedges, histops{:}, 'parent', ax3);
    set(gca, 'YDir', 'reverse', 'box', 'off', 'fontsize', ftsz, ...
        'XAxisLocation', 'top', 'xtick', []);
    ax3.YAxis.Visible = 'off';
    xlabel('\gamma^{+}', 'fontsize', ftsz)
    
    
end

% save eps
% print -depsc Bart_betagammaplusscatterfull.eps

%% posterior predictive using joint posterior samples of gamma and beta

% how many samples
nsamples = 1e3;
% how many games
nGames = 50;

maxOptions = 25;
subchains = codasubsample(chains, '.', nsamples);

% initialize gamma and beta samples
betaSamples = NaN(numel(Bart.participants), Bart.ncond, nsamples);
gammaSamples = NaN(numel(Bart.participants), Bart.ncond, nsamples);
theta = NaN(numel(Bart.participants), Bart.ncond, maxOptions, nsamples);
predy_pump = NaN(numel(Bart.participants), Bart.ncond, nsamples, nGames);
for i = 1:numel(Bart.participants)
    for m = 1:Bart.ncond
        % fill in beta and gamma samples
        betaSamples(i, m, :) = subchains.(sprintf('beta_%i_%i', i, m));
        gammaSamples(i, m, :) = subchains.(sprintf('gamma_%i_%i', i, m));
        
        % play the bart game 50 times
        tmpOmega = -squeeze(gammaSamples(i, m, :))./(log(1 - probPop(m))); % tmp optimal pumps
        for ctr = 1:nsamples
            for k = 1:maxOptions
                theta(i, m, k, ctr) = 1 / (1 + exp(betaSamples(i, m, ctr)*(k - tmpOmega(ctr))));
            end
            
            % predy
            tmpPredy = squeeze(binornd(1, theta(i, m, :, ctr)));
            
            % predy pumps
            if any(tmpPredy == 0)
                predy_pump(i, m, ctr) = find(tmpPredy == 0, 1);
            else
                predy_pump(i, m, ctr) = maxOptions;
            end
        end
        
    end
end



%% make plot of posterior predictives with actual decisions

% get 25% and 75% quantiles of decBanked and min/max
bounds_decBanked = NaN(numel(Bart.participants), Bart.ncond, 2);
means_decBanked  = NaN(numel(Bart.participants), Bart.ncond);
sds_decBanked = NaN(numel(Bart.participants), Bart.ncond);
min_decBanked = NaN(numel(Bart.participants), Bart.ncond);
max_decBanked = NaN(numel(Bart.participants), Bart.ncond);
for i = 1:numel(Bart.participants)
    for m = 1:Bart.ncond
        tmpDec = decBanked(i, :, m);
        tmpDec = tmpDec(~isnan(tmpDec));
        
        means_decBanked(i, m) = mean(tmpDec);
        median_decBanked(i, m) = median(tmpDec);
        sds_decBanked(i, m) = std(tmpDec);
        bounds_decBanked(i, m, 1) = quantile(tmpDec, .25);
        bounds_decBanked(i, m, 2) = quantile(tmpDec, .75);
        min_decBanked(i, m) = min(tmpDec);
        max_decBanked(i, m) = max(tmpDec);
        
    end
end

% sort everything by means_decBanked
[sortedMeans, ind] = sortrows(means_decBanked, 1, 'descend');
sortedMins = min_decBanked(ind, :);
sortedMaxs = max_decBanked(ind, :);
sortedSDs = sds_decBanked(ind, :);
sortedBounds = bounds_decBanked(ind, :, :);
sortedPredy = predy_pump(ind, :, :, :);

% make plot
shift = .25;
bigmarkersz = 7.5;
markersz = 3;
linewidth = 3;
scale = 8;
boxcolor = [.7 .7 .7];
figure(3); clf;
set(gcf,'units','norm','pos',[.1 .1 .9*1 .9*1],'paperpositionmode','auto',...
    'color','w');
for i = 1:numel(Bart.participants)
    for m = 1:Bart.ncond
        subplot(2, 1, m)
        
        if mod(m, 2)
            color = [.3 .6 .9];
        else
            color = [1 .5 .5];
        end
        % plot mean
        plot(i - shift, sortedMeans(i, m), 'o', 'markersize', bigmarkersz, ...
            'markerfacecolor', color, 'markeredgecolor', color); hold on;
%         % plot lower bound
%         plot(i - shift, bounds_decBanked(i, m, 1), 'o', 'markersize', markersz, ...
%             'markerfacecolor', color, 'markeredgecolor', color); hold on;
%         % plot upper bound
%         plot(i - shift, bounds_decBanked(i, m, 2), 'o', 'markersize', markersz, ...
%             'markerfacecolor', color, 'markeredgecolor', color); hold on;
        % plot line for confidence interval
        plot([i - shift, i - shift], [sortedBounds(i, m, 1), sortedBounds(i, m, 2)], ...
            'linewidth', linewidth, 'color', color); hold on;
        % plot line for min and max
        plot([i - shift, i - shift], [sortedMins(i, m), sortedMaxs(i, m)], ...
            'linewidth', .75, 'color', color); hold on;
        
        % plot posterior predictive with boxes
        [n, edges] = histcounts(squeeze(sortedPredy(i, m, :)), 1:squeeze(max(sortedPredy(i, m, :))));
        % normalize n to be between 0 and 1
        norm_n = (n - min(n)) ./ ( max(n) - min(n) );
        for ctr = 1:length(edges)-1
            if norm_n(ctr) > 0
                plot(i + shift, ctr, 's', 'color', boxcolor, 'markerfacecolor', boxcolor, ...
                    'markersize', norm_n(ctr) * scale);
                hold on;
            end
        end
        
        set(gca, 'box', 'off', 'fontsize', 18, 'xlim', [0, 45], 'ylim', [0 16], ...
            'ticklength', [0 0])
        yticks(0:2:16)
        xlabel('Participants', 'fontsize', 18)
        ylabel('Number of pumps', 'fontsize', 18)
        if mod(m, 2)
            title('Condition 1 (p = .1)', 'fontsize', 18)
        else
            title('Condition 2 (p = .2)', 'fontsize', 18)
        end
    end
end


% save eps
% print -depsc Bart_postpred.eps


