%% Lists DIC and highest observed R-hat for all of the completed models
%

% -joachim vandekerckhove

%% Some preallocation
s = {};

%% Read model statistics files
fd = 'stats';
dc = dir([fd filesep 'clvm*_stats.mat']);
nf = numel(dc);

dic = zeros(1, nf);
mrh = zeros(1, nf);

%% Print something to the screen
fprintf('   Loading results... \n')
ln = fprintf('|%s| %d/%d  \n', repmat(' ', 1, nf), 0, nf);


%% Loop over model statistics files
for d = 1:nf
    s{d} = load([fd filesep dc(d).name]);  % load file
    dic(d) = [s{d}.dic];      % get dic
    mrh(d) = [s{d}.mrh];      % get mrh

    % Print progress to screen
    fprintf(repmat('\b', 1, ln));
    ln = fprintf('|%s%s|  %d/%d  \n', ...
        repmat('x', 1, d), repmat(' ', 1, nf-d), d, nf);
end
fprintf('\n');

%% Print line
line = [' ' repmat('-', 1, 80), '\n'];
fprintf(line)

%% Choose output format and print title row
formatt = ' %9s   %28s   %6s   %6s   %6s   %9s\n';
formatn = ' %9s   %28s   %6d   %6d   %6.4f   %9s\n';

fprintf(formatt, ...
    'Filename', ...
    'Model', ...
    'DIC', ...
    'dDIC', ...
    'Rhat', ...
    'Date')

%% Print line
fprintf(line)

%% Print line for each model
for d = 1:nf
    fprintf(formatn, ...
        dc(d).name(1:7), ...
        s{d}.modelinfo.short, ...
        dic(d), ...
        dic(d) - min(dic), ...
        mrh(d), ...
        datestr(dc(d).datenum,'dd/mm/yy'))
end

%% Print line
fprintf(line)
fprintf('   Note: These values are subject to MCMC error.  Be sure to check convergence!\n')
fprintf(line)
