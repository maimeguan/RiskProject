% This script makes the figures for the risk questionnaires for thesis

%% load data

load('/Users/Maime/Dropbox/RiskStudy/Questionnaires/RTI_scores.mat')
load('/Users/Maime/Dropbox/RiskStudy/Questionnaires/RPS_scores.mat')
load('/Users/Maime/Dropbox/RiskStudy/Questionnaires/DospertTaking_scores.mat')
load('/Users/Maime/Dropbox/RiskStudy/Questionnaires/DospertPerception_scores.mat')

%% RPS

figure(1); clf;
set(gcf,'units','norm','pos',[.1 .1 .6*1 .35*1],'paperpositionmode','auto',...
    'color','w');
% color = [.3 .6 .9];
color = [.45 .75 .9];

histogram(RPS_scores, 1:9, 'FaceColor', color, 'edgecolor', [1 1 1])

set(gca, 'box', 'off', 'fontsize', 18, 'color', 'none', 'xlim', [.5, 9.5], ...
    'ylim', [0 18], 'ticklength', [0 0]);
xlabel('RPS Score', 'fontsize', 18)
ylabel('Number of Participants', 'fontsize', 18)

% save eps
print -depsc Questionnaires_RPS.eps


%% RTI

figure(2); clf;
set(gcf,'units','norm','pos',[.1 .1 .6*1 .35*1],'paperpositionmode','auto',...
    'color','w');
% color = [.3 .6 .9];
color = [.45 .75 .9];

histogram(RTI_scores, 10:4:44, 'FaceColor', color, 'edgecolor', [1 1 1])

set(gca, 'box', 'off', 'fontsize', 18, 'color', 'none', 'xlim', [8, 44], ...
    'ylim', [0 18], 'ticklength', [0 0]);
xlabel('RTI Score', 'fontsize', 18)
ylabel('Number of Participants', 'fontsize', 18)

% save eps
print -depsc Questionnaires_RTI.eps


%% DOSPERT

% scatterplot color
color = [.45 .75 .9];
nbins = [10 10];

figure(3); clf; hold on;
set(gcf,'units','norm','pos',[.1 .1 .4*1 .6*1],'paperpositionmode','auto',...
    'color','w');
H = scatterhist(DospertTaking_scores, DospertPerception_scores, 'Direction', 'Out',  ...
    'nbins', nbins,'kernel','off');hold on;
set(H(1),'xlim',[6 42])
set(H(1),'ylim',[6 42])

H2 = get(H(1),'children');
set(H2(1),'markerfacecolor', color ,'markersize',8);
set(H2(1),'markeredgecolor',get(H2(1),'markerfacecolor'));
set(H2(1),'markeredgecolor','w');
% set(gcf, 'color', 'none',...
%     'inverthardcopy', 'off');

H3 = get(H(2),'children');

H4 = get(H(3),'children');

set(H3(1),'facecolor',.7*ones(1,3),'edgecolor',[1 1 1])
set(H4(1),'facecolor',.7*ones(1,3),'edgecolor',[1 1 1])

set(gca,'ticklength', [0 0],'box','off','fontsize',16,'color','none');
xlabel('Risk Taking', 'fontsize', 18)
ylabel('Risk Perception', 'fontsize', 18)
% set(gcf, 'color', 'none',...
%     'inverthardcopy', 'off');


% save eps
print -depsc Questionnaires_DOSPERT.eps






