function [Granger] = fnc_Efective_granger(data1,order,method,cfg1)
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

% The output is a data structure of datatype 'mvar' which contains the
% multivariate autoregressive coefficients in the field coeffs, and the
% covariance of the residuals in the field noisecov.
%%
warning off

%     data1.trial     = data.trial(tr);
%     data1.time      = data.time(tr);
%     data1.fsample   = data.fsample;
%     data1.label     = data.label;

%% MVAR - model
cfg                = [];
cfg.order       = order;
cfg.toi           = cfg1.toi;
cfg.foi           = cfg1.foi;
cfg.t_ftimwin =  0.5;  %5./cfg1.foi;
cfg.channel   = 'all';
cfg.toolbox    = 'biosig'; %'biosig'; 
mdata           = ft_mvaranalysis(cfg, data1);

%% transfer function
% cfg                = [];
% cfg.method    = 'mvar';
% cfg.taper      = 'dpss';
% cfg.tapsmofrq  = 2;
mfreq            = ft_freqanalysis(cfg1, mdata);

%% granger
cfg                = [];
cfg.method    = method;
Granger       = ft_connectivityanalysis(cfg, mfreq);


