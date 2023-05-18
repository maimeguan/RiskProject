u = NaN;

%  Risk,Consistency,Survey
w = { ...
    0 1 0  % OS alpha 1
    0 u 0  % OS alpha 2
    0 u 0  % OS alpha 3
    0 u 0  % OS alpha 4
    1 0 0  % OS beta 1
    u 0 0  % OS beta 2
    u 0 0  % OS beta 3
    u 0 0  % OS beta 4
    u 0 0  % OS gamma 1
    u 0 0  % OS gamma 2
    u 0 0  % OS gamma 3
    u 0 0  % OS gamma 4
    0 u 0  % Bandit gamma w 1
    0 u 0  % Bandit gamma w 2
    0 u 0  % Bandit gamma w 3
    0 u 0  % Bandit gamma w 4
    u 0 0  % Bandit gamma l 1
    u 0 0  % Bandit gamma l 2
    u 0 0  % Bandit gamma l 3
    u 0 0  % Bandit gamma l 4
    0 u 0  % Bart beta 1
    0 u 0  % Bart beta 2
    u 0 0  % Bart gamma 1
    u 0 0  % Bart gamma 2
    0 u 0  % Gamble phi
    u 0 0  % Gamble lambda
    0 0 1  % RTI
    0 0 u  % RPS
    0 0 u  % Dospert RT
    0 0 u  % Dospert RP
    };

modelinfo = struct( ...
    'short', 'Three-factor', ...
    'long', ['has a Risk task factor, a Consistency task factor, and a' ...
    ' Survey factor']);
