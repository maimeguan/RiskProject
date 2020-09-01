pu = NaN;

%  Risk,Consistency
w = { ...
    1   % OS alpha 1
    u   % OS alpha 2
    u   % OS alpha 3
    u   % OS alpha 4
    u   % OS beta 1
    u   % OS beta 2
    u   % OS beta 3
    u   % OS beta 4
    u   % OS gamma 1
    u   % OS gamma 2
    u   % OS gamma 3
    u   % OS gamma 4
    u   % Bandit gamma w 1
    u   % Bandit gamma w 2
    u   % Bandit gamma w 3
    u   % Bandit gamma w 4
    u   % Bandit gamma l 1
    u   % Bandit gamma l 2
    u   % Bandit gamma l 3
    u   % Bandit gamma l 4
    u   % Bart beta 1
    u   % Bart beta 2
    u   % Bart gamma 1
    u   % Bart gamma 2
    u   % Gamble phi
    u   % Gamble lambda
    u   % RTI
    u   % RPS
    u   % Dospert RT
    u   % Dospert RP
    };

modelinfo = struct( ...
    'short', 'One-factor', ...
    'long', 'has a single factor for everything');
