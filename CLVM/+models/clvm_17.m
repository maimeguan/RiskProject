u = NaN;

%  Risk,Consistency
w = { ...
    0 1   % OS alpha 1
    0 u   % OS alpha 2
    0 u   % OS alpha 3
    0 u   % OS alpha 4
    1 0   % OS beta 1
    u 0   % OS beta 2
    u 0   % OS beta 3
    u 0   % OS beta 4
    u u   % OS gamma 1
    u u   % OS gamma 2
    u u   % OS gamma 3
    u u   % OS gamma 4
    u u   % Bandit gamma w 1
    u u   % Bandit gamma w 2
    u u   % Bandit gamma w 3
    u u   % Bandit gamma w 4
    u u   % Bandit gamma l 1
    u u   % Bandit gamma l 2
    u u   % Bandit gamma l 3
    u u   % Bandit gamma l 4
    u u   % Bart beta 1
    u u   % Bart beta 2
    u u   % Bart gamma 1
    u u   % Bart gamma 2
    u u   % Gamble phi
    u u   % Gamble lambda
    u u   % RTI
    u u   % RPS
    u u   % Dospert RT
    u u   % Dospert RP
    };

modelinfo = struct( ...
    'short', 'Exploratory two-factor', ...
    'long', 'has two free factors');
