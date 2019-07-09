% This script makes the figures for the Gambling task for thesis

%% load data

load('/Users/Maime/Dropbox/RiskStudy/Gambling/Gambling.mat')

% load chains
load('/Users/Maime/Dropbox/RiskStudy/Gambling/Gamble_CPT.mat')

lambdaMeans = get_matrix_from_coda(chains, 'lambda', @mean);
phiMeans = get_matrix_from_coda(chains, 'phi', @mean);
alphaMeans = get_matrix_from_coda(chains, 'alpha', @mean);
gammaMeans = get_matrix_from_coda(chains, 'gamma', @mean);
deltaMeans = get_matrix_from_coda(chains, 'delta', @mean);

nsubj = numel(Gambling.participants);

%% contaminant partcipants BFs

load('/Users/Maime/Dropbox/RiskStudy/Gambling/Gamble_CPT_contam.mat')

% posterior means of z
z_means = 1 - (get_matrix_from_coda(chains, 'z', @mean) - 1);
logbf = log(z_means ./(1 - z_means));

% replace inf
logbf(isinf(logbf)) = 15;

figure(1); clf;
% color = [.3 .6 .9];
color = [.45 .75 .9];
set(gcf,'units','norm','pos',[.1 .1 .6*1 .3*1],'paperpositionmode','auto',...
    'color','w');
% plot log BFs
histogram(logbf, 20, 'FaceColor', color, 'edgecolor', [1 1 1])
hold on;
plot([0 0], [0 20], '--', 'color', [.3 .3 .3], 'linewidth', 4); hold on;
plot([-2 -2], [0 20], ':', 'color', [.6 .6 .6], 'linewidth', 2); hold on;
plot([-6 -6], [0 20], ':', 'color', [.6 .6 .6], 'linewidth', 2); hold on;
plot([-10 -10], [0 20], ':', 'color', [.6 .6 .6], 'linewidth', 2); hold on;
plot([2 2], [0 20], ':', 'color', [.6 .6 .6], 'linewidth', 2); hold on;
plot([6 6], [0 20], ':', 'color', [.6 .6 .6], 'linewidth', 2); hold on;
plot([10 10], [0 20], ':', 'color', [.6 .6 .6], 'linewidth', 2); hold on;
set(gca, 'box', 'off', 'fontsize', 18, 'color', 'none', 'xlim', [-15, 15], ...
    'ticklength', [0 0], ...
    'xticklabels', {'-15', '-10', '-5', '0', '5', '10', 'overwhelming \newlineevidence >15'});
xlabel('Log Bayes Factor', 'fontsize', 18)
title('Evidence of CPT over Guessing', 'fontsize', 18)

% save eps
% print -depsc Gamble_contamlogBFs.eps



%% representative participants

% high lambda, low alpha : 19 / 34
% high lambda, high alpha: 21 / 34
% low lambda, high alpha: 4 / 34

rep_participants = [19, 21, 4];

figure(2); clf;
set(gcf,'units','norm','pos',[.1 .1 .9*1 .6*1],'paperpositionmode','auto',...
    'color','w');

% subjective value function plot
ops = {':', '--', '-'};
alpha = alphaMeans(rep_participants);
lambda = lambdaMeans(rep_participants);
step = .1;
x_pos = 0:step:100;
x_neg = -100:step:0;
x = [x_neg, x_pos];

subplot(1, 2, 1)
plot(x, x, 'linewidth', 4, 'color', [0 0 0])
hold on;
for ctr = 1:length(alpha)
    value_pos = x_pos.^alpha(ctr);
    value_neg = -lambda(ctr)*((-x_neg).^alpha(ctr));
    value = [value_neg, value_pos];
    plot(x, value, ops{ctr}, 'linewidth', 2, 'color', [.45 .75 .9])
    hold on;
end
xlabel('Objective value', 'fontsize', 18)
ylabel('Subjective value', 'fontsize', 18)
grid on;
legend({'\alpha = 1, lambda = 1', ...
    ['\alpha = ', num2str(alpha(1), 2), ', \lambda = ', num2str(lambda(1), 3)], ...
    ['\alpha = ', num2str(alpha(2), 2), ', \lambda = ', num2str(lambda(2), 3)], ...
    ['\alpha = ', num2str(alpha(3), 2), ', \lambda = ', num2str(lambda(3), 3)]}, ...
    'location', 'northwest', 'fontsize', 18)
set(gca, 'fontsize', 18, 'ticklength', [0 0], 'xlim', [-100, 100], 'ylim', [-100, 100]);
title('Subjective value functions', 'fontsize', 18)

% probability weighting function plot
rep_participants = [25, 2, 17];
subplot(1, 2, 2)
ops = {':', '--', '-'};
step = .01;
p = 0:step:1;
gamma = gammaMeans(rep_participants);
delta = deltaMeans(rep_participants);

plot(p, p, 'linewidth', 4, 'color', [0 0 0])
hold on;
for ctr = 1:length(gamma)
    % plot gamma (gains trials)
    subj_prob = (p.^gamma(ctr))./((p.^gamma(ctr) + (1-p).^gamma(ctr)).^(1/gamma(ctr)));
    plot(p, subj_prob, ops{ctr}, 'linewidth', 2, 'color', [.45 .75 .9])
    hold on;
    % plot delta (losses trials)
    subj_prob = (p.^delta(ctr))./((p.^delta(ctr) + (1-p).^delta(ctr)).^(1/delta(ctr)));
    plot(p, subj_prob, ops{ctr}, 'linewidth', 2, 'color', [1 .5 .5])
    hold on;
end
xlabel('Objective probability', 'fontsize', 18)
ylabel('Subjective probability', 'fontsize', 18)
grid on;
legend({'\gamma = \delta = 1', ...
    ['\gamma = ', num2str(gamma(1), 2)], ['\delta = ', num2str(delta(1), 2)], ...
    ['\gamma = ', num2str(gamma(2), 2)], ['\delta = ', num2str(delta(2), 2)], ...
    ['\gamma = ', num2str(gamma(3), 2)], ['\delta = ', num2str(delta(3), 2)]}, ...
    'location', 'northwest', 'fontsize', 18)
set(gca, 'fontsize', 18, 'ticklength', [0 0], 'xlim', [0, 1], 'ylim', [0, 1]);
title('Probability weighting functions', 'fontsize', 18)


% save eps
% print -depsc Gamble_inferredcurves.eps


%% make figure of scatterplot of lambda and phi with marginal histograms

% which participants
rep_participants = [19, 21, 4];

% scatterplot color
color = [.45 .75 .9];

figure(3); clf; hold on;
set(gcf,'units','norm','pos',[.1 .1 .4*1 .6*1],'paperpositionmode','auto',...
    'color','w');
H = scatterhist(lambdaMeans, phiMeans, 'Direction', 'Out',  ...
    'nbins', [20 20],'kernel','off');hold on;
set(H(1),'xlim',[0 3])
set(H(1),'ylim',[0 2])

H2 = get(H(1),'children');
set(H2(1),'markerfacecolor', color ,'markersize',8);
set(H2(1),'markeredgecolor',get(H2(1),'markerfacecolor'));
set(H2(1),'markeredgecolor','w');
% set(gcf, 'color', 'none',...
%     'inverthardcopy', 'off');

H3 = get(H(2),'children');

H4 = get(H(3),'children');

set(H3(1),'facecolor',.7*ones(1,3),'edgecolor','w')
set(H4(1),'facecolor',.7*ones(1,3),'edgecolor','w')

for i = 1:3
    T(i) = text(lambdaMeans(rep_participants(i)), phiMeans(rep_participants(i)), int2str(i));
end
set(T,'fontsize',18,'fontweight','bold', 'hor', 'cen', 'vert', 'mid');

set(gca,'ticklength', [0 0],'box','off','fontsize',16,'color','none');
xlabel('\lambda', 'fontsize', 18)
ylabel('\phi', 'fontsize', 18)
% set(gcf, 'color', 'none',...
%     'inverthardcopy', 'off');


% save eps
% print -depsc Gamble_lambdaphiscatter.eps


