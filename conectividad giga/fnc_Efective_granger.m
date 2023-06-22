function [Granger] = fnc_Efective_granger(data1,order,method,cfg2,twin2)
%%
%   cfg.order      = scalar, order of the autoregressive model (default=10)
%   cfg.method     = the name of the toolbox containing the function for the
%                     actual computation of the ar-coefficients
%                     this can be 'biosig' (default) or 'bsmart'
%                     you should have a copy of the specified toolbox in order
%                     to use mvaranalysis (both can be downloaded directly).
%                     'mvar', does a fourier transform on the coefficients
%                       of an estimated multivariate autoregressive model,
%                       obtained with FT_MVARANALYSIS. In this case, the
%                       output will contain a spectral transfer matrix,
%                       the cross-spectral density matrix, and the
%                       covariance matrix of the innovatio noise.
%   cfg.taper      = 'dpss', 'hanning' or many others, see WINDOW (default = 'dpss')
%                     For cfg.output='powandcsd', you should specify the channel combinations
%                     between which to compute the cross-spectra as cfg.channelcmb. Otherwise
%                     you should specify only the channels in cfg.channel.
%   cfg.tapsmofrq  = number, the amount of spectral smoothing through
%                    multi-tapering. Note that 4 Hz smoothing means
%                    plus-minus 4 Hz, i.e. a 8 Hz smoothing box.
% 
% The output is a data structure of datatype 'mvar' which contains the
% multivariate autoregressive coefficients in the field coeffs, and the
% covariance of the residuals in the field noisecov.
%%
warning off

%% MVAR - model
% cfg           = [];
% cfg.order     = order;
% cfg.toi       = cfg1.toi;
% cfg.foi       = cfg1.foi;
% cfg.t_ftimwin = twin/2;  %5./cfg1.foi;
% cfg.channel   = 'all';
% % cfg.toolbox   = 'biosig'; %'biosig'; 
% cfg.method    = 'biosig'; 
% cfg.keeptrials= 'no';
% cfg.jackknife = 'no';
% mdata         = ft_mvaranalysis(cfg, data1);
cfg1           = [];
cfg1.order     = order;
cfg1.t_ftimwin = twin2;
cfg1.method    = 'bsmart';
cfg1.toi       = cfg2.toi;
cfg1.foi       = cfg2.foi;
cfg1.channel   = 'all';
cfg1.demean    = 'yes';
mdata          = ft_mvaranalysis(cfg1, data1);
% mdata.dof      = squeeze(mdata.dof);
%% Estimación del tiempo-frecuencia.
% warning off
% cfg           = [];
% cfg.method    = cfg1.method;
% mfreq         = ft_freqanalysis(cfg1, mdata);
cfg1        = [];
cfg1.method = 'mvar';
cfg1.foi    = cfg2.foi;
cfg1.toi    = cfg2.toi;
cfg1.output = 'powandcsd';
cfg1.t_ftimwin = 0.1;
mfreq       = ft_freqanalysis(cfg1, mdata);
% mfreq.dof   = squeeze(mfreq.dof);
%% granger
cfg           = [];
cfg.method    = method;
Granger       = ft_connectivityanalysis(cfg, mfreq);
