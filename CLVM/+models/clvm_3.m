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
    u 0   % OS gamma 1
    u 0   % OS gamma 2
    u 0   % OS gamma 3
    u 0   % OS gamma 4
    0 u   % Bandit gamma w 1
    0 u   % Bandit gamma w 2
    0 u   % Bandit gamma w 3
    0 u   % Bandit gamma w 4
    u 0   % Bandit gamma l 1
    u 0   % Bandit gamma l 2
    u 0   % Bandit gamma l 3
    u 0   % Bandit gamma l 4
    0 u   % Bart beta 1
    0 u   % Bart beta 2
    u 0   % Bart gamma 1
    u 0   % Bart gamma 2
    0 u   % Gamble phi
    u 0   % Gamble lambda
    u 0   % RTI
    u 0   % RPS
    u 0   % Dospert RT
    u 0   % Dospert RP
    };

modelinfo = struct( ...
    'short', 'Two-factor', ...
    'long', 'has a Risk factor and a Consistency factor');
