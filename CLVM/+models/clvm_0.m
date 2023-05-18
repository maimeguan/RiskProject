


w = { ...
    0 1 0 0 0 0 0 0 0 0  % OS alpha 1
    0 1 0 0 0 0 0 0 0 0  % OS alpha 2
    0 1 0 0 0 0 0 0 0 0  % OS alpha 3
    0 1 0 0 0 0 0 0 0 0  % OS alpha 4
    0 0 1 0 0 0 0 0 0 0  % OS beta 1
    0 0 1 0 0 0 0 0 0 0  % OS beta 2
    0 0 1 0 0 0 0 0 0 0  % OS beta 3
    0 0 1 0 0 0 0 0 0 0  % OS beta 4
    0 0 0 1 0 0 0 0 0 0  % OS gamma 1
    0 0 0 1 0 0 0 0 0 0  % OS gamma 2
    0 0 0 1 0 0 0 0 0 0  % OS gamma 3
    0 0 0 1 0 0 0 0 0 0  % OS gamma 4
    0 0 0 0 1 0 0 0 0 0  % Bandit gxamma w 1
    0 0 0 0 1 0 0 0 0 0  % Bandit gamma w 2
    0 0 0 0 1 0 0 0 0 0  % Bandit gamma w 3
    0 0 0 0 1 0 0 0 0 0  % Bandit gamma w 4
    0 0 0 0 0 1 0 0 0 0  % Bandit gamma l 1
    0 0 0 0 0 1 0 0 0 0  % Bandit gamma l 2
    0 0 0 0 0 1 0 0 0 0  % Bandit gamma l 3
    0 0 0 0 0 1 0 0 0 0  % Bandit gamma l 4
    0 0 0 0 0 0 1 0 0 0  % Bart beta 1
    0 0 0 0 0 0 1 0 0 0  % Bart beta 2
    0 0 0 0 0 0 0 1 0 0  % Bart gamma 1
    0 0 0 0 0 0 0 1 0 0  % Bart gamma 2
    0 0 0 0 0 0 0 0 1 0  % Gamble phi
    0 0 0 0 0 0 0 0 0 1  % Gamble lambda
    1 0 0 0 0 0 0 0 0 0  % RTI
    1 0 0 0 0 0 0 0 0 0  % RPS
    1 0 0 0 0 0 0 0 0 0  % Dospert RT
    1 0 0 0 0 0 0 0 0 0  % Dospert RP
    };

modelinfo = struct( ...
    'short', 'Fixed task effect', ...
    'long', ['has one factor per task-parameter combination and equal ' ...
    'weight for each parameter']);
