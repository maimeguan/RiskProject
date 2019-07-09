function thresholds = optimal_thresholds(nvalues,distribution)

% thresholds = optimal_thresholds(nvalues,distribution)
% Find optimal stopping thresholds for problem of given length
% with values sampled from a Beta(alpha,beta) distribution
%
% threshold is set nevalues vector of optimal thresholds
% nvalues is number of values in problem (maximum is 50)
% distribution is 2-vector [alpha,beta] giving Beta distribution parameters
% [requires betaincinv.m, which I think is standard now]


alpha = distribution(1);
beta = distribution(2);
% optimal decision rule for uniform, from Gilbert and Mosteller
v = [.98377582, .98344183, .98309382, .98273085, .98235197, ...    %50 - 46
    .98195608, .98154201, .98110851, .98065414, .98017740, ...    %45 - 41
    .97967655, .97914975, .97859490, .97800972, .97739165, ...    %40 - 36
    .97673783, .97604506, .97530977, .97452791, .97369491, ...    %35 - 31
    .97280561, .97185407, .97083353, .96973619, .96855307, ...    %30 - 26
    .96727367, .96588577, .96437496, .96272413, .96091288, ...    %25 - 21
    .95891663, .95670555, .95424297, .95148338, .94836963, ...    %20 - 16
    .94482887, .94076683, .93605929, .93053912, .92397614, ...    %15 - 11
    .91604417, .90626530, .89391004, .87780702, .85594922, ...    %10 - 6
    .82458958, .77584508, .68989795, .50000000, .0000000];         %5 - 1
% just the last 5 points
vprime = v(end-nvalues+1:end);
% now find how far along cdf until get drt5 proportion
thresholds = betaincinv(vprime,alpha*ones(1,nvalues),beta*ones(1,nvalues));

