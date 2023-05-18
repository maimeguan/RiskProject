%% Script for the latent variable cognitive model in Guan et al.
%

% -joachim vandekerckhove


%% Install Trinity if needed
% !git clone https://github.com/joachimvandekerckhove/trinity.git
% addpath trinity
% trinity install

%%
% Select a model
if ~exist('lvm', 'var')
    lvm = input('Which latent variable model? [0,1,2,...]: ');
end

%% Script controls
filename  = sprintf('clvm_%02i.mat', lvm);
force_run = false;
do_save   = true;

%% Only rerun if necessary or forced
if ~exist(filename, 'file') || force_run

    modeldef = sprintf('models.clvm_%i', lvm);   % model definition file

    %%
    % DATA

    [x, errorMat] = readData('rowwise');


    %%
    % -------------------------- MODEL --------------------------%

    eval(modeldef)  % read the model definition file
    fprintf('Model "%s" %s.\n', ...
        modelinfo.short, modelinfo.long)

    [T, F] = size(w);  % get number of tasks, factors

    P = size(x, 1);  % get number of participants

    weightMat = cell(T,F);

    nf = 0; % number of free parameters

    % Construct the LVM line by line

    for f = 1:F
        for t = 1:T
            if isnan( w{t,f} )  % weight matrix is built from auxiliary variable if NaN; value is given otherwise
                nf = nf + 1;
                weightMat{t,f} = sprintf('w[%i,%i] <- aux[%i]', f, t, nf);
            else
                weightMat{t,f} = sprintf('w[%i,%i] <- %g', f, t, w{t,f});
            end
        end
    end

    % aux has all the nondeterministic components of weightMat, gets MVN(0,I) prior
    if nf > 0
        auxline = '  aux[1:nf] ~ dmnorm(zeros[1:nf], eye[1:nf,1:nf])';
    else
        auxline = '';
    end

    % make data structure
    data = struct( ...
        'P', P, 'T', T, 'F', F, 'nf', nf, ...
        'x', x, ...
        'errorMat', errorMat, ...
        'zeros',    zeros(max([F,nf,P]),1), ...
        'eye',      eye(max([F,nf,P])));

    % Model file to use
    if F > 1
        model = { ...
            'model {'
            ''
            '  # Data'
            '  for (i in 1:P){'
            '    f[i, 1:F]  ~ dmnorm(zeros[1:F], eye[1:F,1:F]) #PxF'  % N(0,1) prior on factors
            '  }'
            '  for (i in 1:T){'
            '    x[1:P,i] ~ dmnorm(m[1:P,i], errorMat[1:P,1:P,i]) #PxT'  % N() likelihood
            '  }'
            ''
            '#PxT    PxF     FxT'
            '  m  <-  f  %*%  w'  % the latent variable model
            ''
            auxline
            ''
            sprintf('  %s\n', weightMat{:})
            ''
            '}'
            };
    else  % slightly different syntax if F = 1; JAGS doesn't like matrix multiplication with a column
        model = { ...
            'model {'
            ''
            '  # Data'
            '  f[1:P]  ~ dmnorm(zeros[1:P], eye[1:P,1:P]) #PxF'
            ''
            '  for (i in 1:T){'
            '    x[1:P,i] ~ dmnorm(m[1:P,i], errorMat[1:P,1:P,i]) #PxT'
            '  }'
            ''
            '#PxT    PxF     FxT'
            %         '  m  <-  f  %*%  w'
            '  for (p in 1:P){'
            '    for (t in 1:T){'
            '      m[p,t] <- f[p] * w[1,t] #PxT'
            '    }'
            '  }'
            ''
            auxline
            ''
            sprintf('  %s\n', weightMat{:})
            ''
            '}'
            };
    end
    %%
    % List all the parameters of interest (cell variable)
    parameters = {'f', 'w', 'aux'};

    % Initial values
    if exist(filename, 'file')
        fprintf('Save file found.  Getting initial values from %s...\n', filename)
        previous = load(filename);
        generator = @()trinity.coda2inits(previous.chains, 0.01, 'w');
        % trinity is here: https://github.com/joachimvandekerckhove/trinity
    else
        fprintf('No save file found.  Starting from scratch...\n')
        generator = @()struct(...
            'aux', ones(nf,1) + randn(nf,1)/5, ...
            'f', -1 + 2 * rand(P, F) );
    end

    % Tell Trinity which engine to use
    engine = 'jags';

    % Run Trinity with the CALLBAYES() function

    disp 'Launching jags...'

    tic
    [stats, chains, diagnostics, info] = callbayes(engine, ...
        'model'         ,         model , ...
        'outputname'    ,     'samples' , ...
        'data'          ,          data , ...
        'modules'       ,           'dic', ...
        'nchains'       ,             4 , ...
        'verbosity'     ,             0 , ...
        'nsamples'      ,         100 , ...
        'nburnin'       ,         100 , ...
        'thin'          ,            10 , ...
        'parallel'      ,             1 , ...
        'workingdir'    ,       ['/tmp/lvm/' filename] , ...
        'saveoutput'    ,          true , ...
        'monitorparams' ,    parameters , ...
        'init'          ,     generator );

    fprintf('%s took %f seconds!\n', upper(engine), toc)

    save(filename, 'stats', 'chains', 'diagnostics', 'info', 'modelinfo');

else
    fprintf('Save file found.  Loading %s...\n', filename)
    load(filename)

end

% Inspect convergence
if any(codatable(chains, @gelmanrubin) > 1.05)
    grtable(chains, 1.05)
    warning('Some chains were not converged!')
else
    disp('Convergence looks good.')
end


dic = round(getdic(chains));
mrh = max(codatable(chains, @gelmanrubin));

if do_save
    save(sprintf('clvm_%02i_stats.mat', lvm), 'dic', 'mrh', 'modelinfo');
end

fprintf('MRH:  %g\n', mrh)
fprintf('DIC:  %g\n', dic)


list_dic
