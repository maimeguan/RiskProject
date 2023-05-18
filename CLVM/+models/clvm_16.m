u = NaN;
%  OSRisk, OSCon, BanditRisk, BanditCon,...
%    BartRisk, BartCon, GambleRisk, GambleCon, Survey
w = { ...
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS alpha 1
    0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS alpha 2
    0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS alpha 3
    0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS alpha 4
    0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS beta 1
    0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS beta 2
    0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS beta 3
    0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS beta 4
    0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS gamma 1
    0 0 0 0 0 0 0 0 u 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS gamma 2
    0 0 0 0 0 0 0 0 u 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS gamma 3
    0 0 0 0 0 0 0 0 u 0 0 0 0 0 0 0 0 0 0 0 0 0 0   % OS gamma 4
    0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0   % Bandit gamma w 1
    0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0   % Bandit gamma w 2
    0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0   % Bandit gamma w 3
    0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0   % Bandit gamma w 4
    0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0   % Bandit gamma l 1
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0   % Bandit gamma l 2
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0   % Bandit gamma l 3
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0   % Bandit gamma l 4
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0   % Bart beta 1
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 u 0 0 0 0 0   % Bart beta 2
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0   % Bart gamma 1
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0   % Bart gamma 2
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0   % Gamble phi
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0   % Gamble lambda
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1   % RTI
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 u   % RPS
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 u   % Dospert RT
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 u   % Dospert RP
    };

modelinfo = struct( ...
    'short', 'Surveys, OS gamma, Bart beta', ...
    'long', ['has a factor for each task-parameter combination and ' ... 
    'one shared factor for all of the surveys, one for OS gamma, and ' ...
    'one for Bart beta']);
