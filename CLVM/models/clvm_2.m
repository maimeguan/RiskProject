u = NaN;


w = { ...
    u 1 0 0 0 0 0 0 0 0  % OS alpha 1
    u u 0 0 0 0 0 0 0 0  % OS alpha 2
    u u 0 0 0 0 0 0 0 0  % OS alpha 3
    u u 0 0 0 0 0 0 0 0  % OS alpha 4
    u 0 1 0 0 0 0 0 0 0  % OS beta 1
    u 0 u 0 0 0 0 0 0 0  % OS beta 2
    u 0 u 0 0 0 0 0 0 0  % OS beta 3
    u 0 u 0 0 0 0 0 0 0  % OS beta 4
    u 0 0 1 0 0 0 0 0 0  % OS gamma 1
    u 0 0 u 0 0 0 0 0 0  % OS gamma 2
    u 0 0 u 0 0 0 0 0 0  % OS gamma 3
    u 0 0 u 0 0 0 0 0 0  % OS gamma 4
    u 0 0 0 1 0 0 0 0 0  % Bandit gamma w 1
    u 0 0 0 u 0 0 0 0 0  % Bandit gamma w 2
    u 0 0 0 u 0 0 0 0 0  % Bandit gamma w 3
    u 0 0 0 u 0 0 0 0 0  % Bandit gamma w 4
    u 0 0 0 0 1 0 0 0 0  % Bandit gamma l 1
    u 0 0 0 0 u 0 0 0 0  % Bandit gamma l 2
    u 0 0 0 0 u 0 0 0 0  % Bandit gamma l 3
    u 0 0 0 0 u 0 0 0 0  % Bandit gamma l 4
    u 0 0 0 0 0 1 0 0 0  % Bart beta 1
    u 0 0 0 0 0 u 0 0 0  % Bart beta 2
    u 0 0 0 0 0 0 1 0 0  % Bart gamma 1
    u 0 0 0 0 0 0 u 0 0  % Bart gamma 2
    u 0 0 0 0 0 0 0 1 0  % Gamble phi
    u 0 0 0 0 0 0 0 0 1  % Gamble lambda
    1 0 0 0 0 0 0 0 0 0  % RTI
    1 0 0 0 0 0 0 0 0 0  % RPS
    1 0 0 0 0 0 0 0 0 0  % Dospert RT
    1 0 0 0 0 0 0 0 0 0  % Dospert RP
    };

modelinfo = struct( ...
    'short', 'General Risk', ...
    'long', ['has a factor for each task-parameter combination and a ' ...
    'general risk factor defined by the mean of the surveys']);
