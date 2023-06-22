rng default
rng(50)

cfg1             = [];
cfg1.ntrials     = 500;
cfg1.triallength = 1;
cfg1.fsample     = 200;
cfg1.nsignal     = 3;
cfg1.method      = 'ar';

cfg1.params(:,:,1) = [ 0.8    0    0 ;
                        0  0.9  0.5 ;
                      0.4    0  0.5];

cfg1.params(:,:,2) = [-0.5    0    0 ;
                        0 -0.8    0 ;
                        0    0 -0.2];

cfg1.noisecov      = [ 0.3    0    0 ;
                        0    1    0 ;
                        0    0  0.2];

data121              = ft_connectivitysimulation(cfg1);

cfg1           = [];
cfg1.order     = 5;
cfg1.t_ftimwin = 0.1;
cfg1.toolbox   = 'bsmart';
cfg1.toi       = cfg.toi;
cfg1.foi       = cfg.foi;
cfg1.channel   = 'all';
cfg1.demean    = 'yes';
mdata          = ft_mvaranalysis(cfg1, data);
mdata.dof      = ones(64,64,19,26).*100;

cfg1        = [];
cfg1.method = 'mvar';
cfg1.foi    = cfg.foi;
cfg1.toi    = cfg.toi;
cfg1.output = 'powandcsd';
cfg1.t_ftimwin = 0.1;
mfreq       = ft_freqanalysis(cfg1, mdata);

cfg1        = [];
cfg1.method = 'granger';
granger     = ft_connectivityanalysis(cfg1, mfreq);

% cfg1           = [];
% cfg1.parameter = 'grangerspctrm';
% cfg1.zlim      = [0 1];
% ft_connectivityplot(cfg1, granger.grangerspctrm(:,:,9,26));