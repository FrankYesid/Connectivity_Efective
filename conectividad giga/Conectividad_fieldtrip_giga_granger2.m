%% Main_cx_wpli:
% Compute cx base on wpli
% Based on vink 2011 - fieldtrip
% F. Zapata
% L. Velasquez

% clear; clc;
clc
clearvars -except data100
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
SUBJECTS_DIR    = 'F:\Giga_science\data\'; % Rereferenced EDF data (preprocessed by EEGLAB)
SUBJECTS_DIR_r =  'K:\Databases\Giga_science\data_ref\'; %'F:\Giga_science\data_ref\'; % Rereferenced EDF data (preprocessed by EEGLAB)
run('G:\Dropbox\ERD\results_ERDfc_subjects\Biosig_ERD\biosig_installer.m')
dir_electrodes = 'posiciones.mat';
warning off

%% Initial parameters
SS          = 14;%[14,43];%1:52;
t           =  [0,7];                   % time interval for analysis
% classes   = [1 2 3 4];                % Dataset clases
load(dir_electrodes)                    % loading ch labels
channels    = M1.lab;                   % Channels
fs          = 512;
Mode_analysis = 'no-all';
tstar       = 2;                        % time of star.
tend        = 4;                        % time of stop.
twin        = 0.0390625; % 0.15625;     % step of the time.
fmin        = 4;                              % Frequency min.
fsetp       = 2;                              % Step of frequency.
fmax        = 40;                           % Frequency of max.
Norder      = 5;                              % Cycles.

%%
%freq        = cell(size(52,2),2);

for s = SS                % By subject
    %tmp_freq = cell(2,1);
    tmp_granger = cell(2,1);
    granger        = cell(1,2);
    clear eeg
    if s < 10
        load([SUBJECTS_DIR 's0' num2str(s) '.mat'])
    else
        load([SUBJECTS_DIR 's' num2str(s) '.mat'])
    end
    for clas  = 1:2      % By class
        fprintf(['Loading subject...  ' num2str(s) '... of ' num2str(size(SS,2))  '\n '])
        %         if s  < 10
        %             [data_,h] = sload([SUBJECTS_DIR_r,'s0',num2str(s),'_cl',num2str(clas),'.gdf'],'OVERFLOWDETECTION:OFF');
        %         else
        %             [data_,h] = sload([SUBJECTS_DIR_r,'s',num2str(s),'_cl',num2str(clas),'.gdf'],'OVERFLOWDETECTION:OFF');
        %         end
        if clas == 1
            dat_ = eeg.imagery_left;
        else
            dat_ = eeg.imagery_right;
        end
        dat_(isnan(dat_)) = 0;
        % para aplicar filtro laplaciano a los datos referencia.
        montage = '64ch'; % montaje de los canales que se van a utilizar.
        channels_ = 1:64;   % número de canales que se van a utilizar.
        dat_        = dat_(channels_,:);
        [lap, ~, ~, ~] = getMontage(montage);
        %         data_     =  data_1*lap;
        data_       = (dat_(channels_,:)'*lap); clear dat_
        bad_trails   = eeg.bad_trial_indices.bad_trial_idx_mi{clas};
        h.Classlabel = ones(numel(find(eeg.imagery_event==1)),1)*clas;
        h.SampleRate = eeg.srate;
        h.TRIG            = find(eeg.imagery_event==1)';
        indd = h.Classlabel; indd(bad_trails) = 0;
        %         indx_ = zeros(numel(find(eeg.imagery_event==1)),1);
        %         indd        = h.ArtifactSelection==0 & ismember(h.Classlabel, classes);
        indx        = ones(1,numel(h.TRIG(logical(indd))))';
        h.Classlabel = h.Classlabel(logical(indd));
        h.TRIG    = h.TRIG(logical(indd));
        indx         = indx.*ismember(h.Classlabel,clas);
        fs            = h.SampleRate;
        triallen    = round((t(2) - t(1)) * fs) + 1;  % Trial length (in samples)
        tmp         = trigg(data_, h.TRIG(ismember(h.Classlabel, clas) & indx), round(t(1)*fs)-2*fs+1, round(t(2)*fs)+1-2*fs);
        tmp1       = reshape(tmp, size(tmp,1),triallen, length(tmp)/triallen);  %
        tmp1(isnan(tmp1))=0;
        data_trial = cell(1,size(tmp1,3));
        for trial  = 1:size(tmp1,3)
            data_trial{1,trial} = tmp1(:,1:triallen,trial);
        end
        %% data struct for fieldtrip
        % Load EEG
        clear data_
        data               = [];
        data.trial         = data_trial;
        time                = t(1):1/fs:t(2)-(1/fs)+1/fs;      % tiempo de la seï¿½al.
        data.time        = cellfun(@(X) time,data.trial,'UniformOutput',false);
        data.fsample   = fs;                    % frecuencia de muestreo.
        data.label        = channels;                 % canales seleccionados.
        data.trialinfo    = ones(size(data_trial,2),1)*clas; % class trial definition
        data.sampleinfo   =  [h.TRIG(logical(indx))+t(1)*fs,h.TRIG(logical(indx))+triallen+t(1)*fs-1];
        data.hdr.Fs      = fs;
        data.hdr.nChans  = numel(channels);
        data.hdr.Samples = triallen;
        data.hdr.nSamplesPre= 0;
        data.hdr.nTrials = size(tmp1,3);
        data.hdr.label    = channels;
        %% Time-freq descomposition
        fprintf(['Time-frequency subject...  ' num2str(s) '... of ' num2str(size(SS,2))  '\n '])
        cfg             = [];
        cfg.method ='mvar'; % modelos %'mtmfft';% 'wavelet'; %'mtmfft'; 'wavelet' mtmconvol
        cfg.output   = 'powandcsd';%'powandcsd'; %'powandcsd' %'fourier'; 'pow'
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
        %% Connectivity estimation
        method = 'granger';
        tem_ = fnc_Efective_granger(data,Norder,method,cfg,twin);
        granger{clas} = tem_;
    end
    %freq{s} = tmp_freq;
    %     granger{s} = tmp_granger;
%     Cx_all = cell(1,2);
    %     for fold = 1
    for cl = 1:2
        for fr = 1:numel(granger{cl}.freq)
            for v = 1:numel(granger{cl}.time)
                Cx_all{s}{cl}(:,:,fr,v)  = granger{cl}.grangerspctrm(:,:,fr,v);
            end
        end
    end
    data = [];
    data.labelcmb = granger{1}.label;
    data.time = granger{1}.time;
    data.freq = granger{1}.freq;
    %     end
    %      save(['F:\efectiva\Cx_granger_giga_all_time_sub',num2str(s),'.mat'],'Cx_all','data')
end

% %% Orden de datos para análisis de grupo.
% for s = SS                % By subject
%     Cx_all = cell(1,1);
%     for fold = 1
%         for cl = 1:2
%             for fr = 1:numel(granger{s}{cl}.freq)
%                 for v = 1:numel(granger{s}{cl}.time)
%                     Cx_all{fold}{cl}(:,:,fr,v)  = granger{s}{cl}.grangerspctrm(:,:,fr,v);
%                 end
%             end
%         end
%     end
%     save(['F:\Cx_granger_giga_all_time_sub',num2str(s),'.mat'],'Cx_all')
% end
% clear; clc