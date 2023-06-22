%% Main_cx_wpli:
% Compute cx base on wpli
% Based on fieldtrip
% F. Zapata
% L. Velasquez
clear; clc;

%% paths
% Fieldtrip toolbox path
% L. Velasquez-------------------------------------------------------------
% restoredefaultpath
% addpath D:\BCI\Toolbox\fieldtrip
% ft_defaults
% F. Zapata----------------------------------------------------------------
% restoredefaultpath
%  addpath 'F:\Toolbox\fieldtrip-master\'
% % addpath(genpath('F:\Toolbox\fieldtrip-master\'));
%  ft_defaults
% % Database
% L. Velasquez-------------------------------------------------------------
% dir = 'D:\BCI\BCICIV_2a\Training_ref\';                               % Rereferenced EDF data (preprocessed by EEGLAB)
% run('D:\Luisa\Dropbox\ERD\results_ERDfc_subjects\Biosig_ERD\biosig_installer.m')
% dir_electrodes = 'D:\BCI\BCICIV_2a_08\eeg\raw.mat';
% F. Zapata----------------------------------------------------------------
dir = 'K:\Databases\Datasets\BCI Competition\BCIcompetitionIV\BCICIV_2a\Training\'; % Rereferenced EDF data (preprocessed by EEGLAB)
run('G:\Dropbox\ERD\results_ERDfc_subjects\Biosig_ERD\biosig_installer.m')
dir_electrodes = 'F:\BCI\BCICIV_2a_08\eeg\raw.mat';
warning off

%% Initial parameters
SS         = 3;                           % Subjects.
t             = [0,7];                     % time interval for analysis.
classes  = [1 2 3 4];                    % Dataset clases.
load(dir_electrodes,'channels','fs');   % loading ch labels.
channels= channels;% Channels.
Mode_analysis = 'no-all';                  % 'all' in all time, 'not-all' in windows.
tstar       = 2.5;                       % time of star.
tend        = 4.5;                       % time of end.
twin        = 0.04;                           % step of window.
fmin        = 4;                              % Minimal Frequency of analysis.
fsetp       = 2;                              % Step of Frequency.
fmax       = 40;                            % Maximal Frequency of analysis.
Norder    = 5;                              % Order.

% freq        = cell(size(9,2),2);
granger       = cell(size(9,2),2);
for s = SS
    tmp_freq       = cell(2,1);
    tmp_granger = cell(2,1);
    for clas = 1:2
        fprintf(['Loading subject...  ' num2str(s) '... of ' num2str(size(SS,2))  '\n '])
        [data_,h] = sload([dir 'A0',num2str(s),'T.gdf'],'OVERFLOWDETECTION:OFF');
        data_(isnan(data_)) = 0;
        % para aplicar filtro laplaciano a los datos sin cambio de referencia.
        % Referenciation
        montage = '22ch'; % montaje de los canales que se van a utilizar.
        [lap, ~, ~, ~] = getMontage(montage);
        data_     =  data_(:,1:22)*lap;
        indd        = h.ArtifactSelection==0 & ismember(h.Classlabel, classes);
        indx        = ones(1,numel(h.TRIG(indd)))';
        h.Classlabel = h.Classlabel(indd);
        h.TRIG    = h.TRIG(indd);
        indx         = indx.*ismember(h.Classlabel,clas);
        fs            = h.SampleRate;
        triallen     = round((t(2) - t(1)) * fs) + 1;  % Trial length (in samples)
        tmp          = trigg(data_, h.TRIG(ismember(h.Classlabel, classes) & indx), round(t(1)*fs), round(t(2)*fs));
        tmp1        = reshape(tmp, size(tmp,1),triallen, length(tmp)/triallen);  %
        data_trial = cell(1,size(tmp1,3));
        for trial = 1:size(tmp1,3)
            data_trial{1,trial} = tmp1(:,1:round(t(2)*fs) - round(t(1)*fs),trial);
        end
        %% data struct for fieldtrip
        % Load EEG
        data                 = [];
        data.trial          = data_trial;
        time                 = t(1):1/fs:t(2)-(1/fs);      % tiempo de la señal.
        data.time         = cellfun(@(X) time,data.trial,'UniformOutput',false);
        data.fsample   = fs;                    % frecuencia de muestreo.
        data.label        = channels;                 % canales seleccionados.
        data.trialinfo    = ones(size(data_trial,2),1)*clas; % class trial definition
        data.sampleinfo = [h.TRIG(logical(indx)),h.TRIG(logical(indx))+round(t(2)*fs) - round(t(1)*fs)-1];
        data.hdr.Fs        = fs;
        data.hdr.nChans= 22;
        data.hdr.Samples = round(t(2)*fs) - round(t(1)*fs);
        data.hdr.nSamplesPre = 0;
        data.hdr.nTrials    = size(tmp1,3);
        data.hdr.label       = channels;
        %% Time-freq descomposition
        fprintf(['Time-frequency subject...  ' num2str(s) '... of ' num2str(size(SS,2))  '\n '])
        cfg             = [];
        cfg.method ='mvar'; % modelos %'mtmfft';% 'wavelet'; %'mtmfft'; 'wavelet' mtmconvol
        cfg.output   = 'fourier';%'powandcsd'; %'powandcsd' %'fourier'; 'pow'
        cfg.channel= 'all';
        cfg.taper      ='hanning';
        cfg.keeptrials  = 'yes';
        cfg.foi        = fmin:fsetp:fmax; % analysis f1 to fn Hz in steps of 2 Hz
        if strcmp(Mode_analysis,'all')
            cfg.toi    = 'all';
        else
            cfg.toi    = tstar:twin:tend; % para% el tiempo
        end
        cfg.pad      = 'nextpow2';
        %         tmp_freq{clas}= ft_freqanalysis(cfg, data);
        %% Connectivity estimation
        method = 'granger';
        tem_ = fnc_Efective_granger(data,Norder,method,cfg);
        tmp_granger{clas} = tem_;%abs(tem_.grangerspctrm)./max(abs(tem_.grangerspctrm));
    end
    %        freq{s} = tmp_freq;
    granger{s} = tmp_granger;
    for cl = 1:2
        for fr = 1:numel(granger{s}{cl}.freq)
            for v = 1:numel(granger{s}{cl}.time)
                Cx_all{s}{cl}(:,:,fr,v)  = granger{s}{cl}.grangerspctrm(:,:,fr,v);
            end
        end
    end
    data = [];
    data.label =granger{s}{1}.label;
    data.time = granger{s}{1}.time;
    data.freq = granger{s}{1}.freq;
end
