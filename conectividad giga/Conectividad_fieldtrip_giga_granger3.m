%% Main_conectividad_efectiva.
% Connectivity efective - granger.
% Spectral - Wavelet Morlet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute cx base on granger
% Based on vink 2011 - fieldtrip
% F. Zapata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;
% codigo organizado para cada instante de tiempo analizado, es importante
% el filtrado realizado ppor medio de la wavelet.

%% paths Toolbox
% Fieldtrip toolbox path
%% L. Velasquez-------------------------------------------------------------
% restoredefaultpath
% addpath D:\BCI\Toolbox\fieldtrip
% ft_defaults
% Biosig
% run('D:\Luisa\Dropbox\ERD\results_ERDfc_subjects\Biosig_ERD\biosig_installer.m')
%% F. Zapata----------------------------------------------------------------
% restoredefaultpath
% addpath 'F:\Toolbox\fieldtrip-master\'
% addpath(genpath('F:\Toolbox\fieldtrip-master\'));
% ft_defaults
% Biosig
% run('F:\Dropbox\ERD\Toolbox\Biosig_ERD\biosig_installer.m')

%% Database
%% L. Velasquez-------------------------------------------------------------
% dir = 'D:\BCI\BCICIV_2a\Training_ref\';                 % Rereferenced EDF data (preprocessed by EEGLAB)
% SUBJECTS_DIR    = 'D:\Gigascience\data\';               % Database

%% F. Zapata----------------------------------------------------------------
% SUBJECTS_DIR    = 'D:\Giga_science\data\';              % Rereferenced EDF data (preprocessed by EEGLAB)
SUBJECTS_DIR    = 'F:\Gigascience\data\';                 % Database
%SUBJECTS_DIR_r = 'I:\Databases\Giga_science\data_ref2\'; % Rereferenced EDF data (preprocessed by EEGLAB)

%% Position Electrodes.
dir_electrodes = 'posiciones.mat';
% dir_electrodes = 'H:\Dropbox\ERD\Codes\Topoplots\Gigasc\pos_struct_giga.mat';

%% Partition
% load H:\Dropbox\ERD\results_ERDfc_subjects\cv_new_giga.mat

warning off  % apagar advertencias que aparescan en el toolbox.

%% Initial
% g1 - 14,50,3,41,23,4,35,34,1,6,43
% g2 - 48,15,10,5,44,36,26,12,47,37,13,21,31,20
% g3 -
% Sujetos en orden según la base de datos
SS = [42:52];
%% parameters
t        = [0,7];          % time interval for analysis.
% classes = [1 2 3 4];     % Dataset classes.
load(dir_electrodes);      % loading ch labels.
channels = M1.lab;         % Channels of database.
fs       = 512;            % Frecuencia de muestreo.
Mode_    = 'no-all';       % Si utilizamos todo el tiempo o manejamos la posición de las ventanas centrales.
t_v      = 0:1:7-1;        % vector de posiciones en el tiempo.
tam      = 1;              % tamaño de la ventana para calculo de la conectividad.
twin     = 0.0385;         % step of the time. opcionales: %0.0390625; %0.078125;%0.0390625;
fmin     = 4;              % Frequency min.
fsetp    = 2;              % Step of frequency.
fmax     = 40;             % Frequency of max.
Ncycles  = 5;              % Cycles (Wavelet Morlet).
% channel Cent.
% Chan_centrals = [9,10,11,12,13,14,17,18,19,32,44,45,46,47,48,49,50,51,54,55,56];
Chan_select = 1:64;        % canales seleccionados.
load('trial_sub_giga.mat') % trials of each subjects in class.
Nfolds   = 1;             % Numers of folds.
Norder   = 5;              % Orden del modelo mvar.

%% Connectivity WPLI
for s = SS                % By subject
    %     tmp_freq = cell(2,1);
    wpli = cell(numel(t_v),1);
    clear eeg
    if s < 10
        load([SUBJECTS_DIR 's0' num2str(s) '.mat'])
    else
        load([SUBJECTS_DIR 's' num2str(s) '.mat'])
    end
    if Nfolds == 1
        date = struct;
        Cx = 0;
    else
        dates = cell(1,Nfolds);
        Cxf = cell(1,Nfolds);
    end
    for fold = 1:Nfolds
        granger_ = cell(1,2);
        tim_  = cell(1,2);
        for clas  = 1:2      % By class
            fprintf(['Loading subject...  ' num2str(s) '... of ' num2str(size(SS,2))  '\n '])
            if clas == 1
                dat_ = eeg.imagery_left;
            else
                dat_ = eeg.imagery_right;
            end
            % Filter Laplacian
            montage   = '64ch'; % montaje de los canales que se van a utilizar.
            channels_ = 1:64;   % número de canales que se van a utilizar.
            dat_      = dat_(channels_,:);
            % Output parameters:
            %   lap            ... Laplacian filter matrix.
            %   plot_index ... Indices for plotting the montage.
            %   n_rows     ... Number of rows of the montage.
            %   n_cols      ... Number of columns of the montage.
            [lap, ~, ~, ~] = getMontage(montage);
            % para aplicar filtro laplaciano a los datos referencia.
            % Multiplicamos la señal por la matriz de filtrado laplaciano.
            data_  = (dat_(channels_,:)'*lap); clear dat_
            % channel selection ROI - center.
            data_  = data_(:,Chan_select);
            data_(isnan(data_)) = 0;
            % Repeticiones para eliminar.
            bad_trails   = eeg.bad_trial_indices.bad_trial_idx_mi{clas};
            % Vector que contiene a que clase pertenece cafa repetición.
            h.Classlabel = ones(numel(find(eeg.imagery_event==1)),1)*clas;
            % frecuencia de muestreo.
            h.SampleRate = eeg.srate;
            % Ubicación del evento dentro del registro.
            h.TRIG       = find(eeg.imagery_event==1)';
            % indices de las repeticiones malos.
            indd = h.Classlabel; indd(bad_trails) = 0;
            %  indx_ = zeros(numel(find(eeg.imagery_event==1)),1);
            %  indd        = h.ArtifactSelection==0 & ismember(h.Classlabel, classes);
            indx         = ones(1,numel(h.TRIG(logical(indd))))';
            h.Classlabel = h.Classlabel(logical(indd));
            h.TRIG       = h.TRIG(logical(indd));
            %% si utiliza particion se aplica en el vector de los indices.
            %             cv_ = c{s}.training(fold);
            if clas ==1
                indx  = indx.*ismember(h.Classlabel,clas);%.*cv_(1:in(s,clas));
            else
                indx  = indx.*ismember(h.Classlabel,clas);%.*cv_(in(s,1)+1:end);
            end
            %  ind_(s,clas) = sum(indx);
            fs        = h.SampleRate;
            triallen  = round((t(2) - t(1)) * fs) + 1;  % Trial length (in samples)
            tmp       = trigg(data_, h.TRIG(ismember(h.Classlabel, clas) & indx), round(t(1)*fs)-2*fs+1, round(t(2)*fs)+1-2*fs);
            tmp1      = reshape(tmp, size(tmp,1),triallen, floor(length(tmp)/triallen));  %
            tmp1(isnan(tmp1))=0;
            data_trial= cell(1,size(tmp1,3));
            for trial = 1:size(tmp1,3)
                data_trial{1,trial} = tmp1(:,1:triallen,trial);
            end
            %% data struct for fieldtrip
            % Load EEG
            channels2 = channels(Chan_select);
            data      = [];
            data.trial= data_trial;
            time      = t(1):1/fs:t(2)-(1/fs)+1/fs;% tiempo de la señal.
            data.time = cellfun(@(X) time,data.trial,'UniformOutput',false);
            data.fsample   = fs;                   % frecuencia de muestreo.
            data.label= channels2;                 % canales seleccionados.
            data.trialinfo = ones(size(data_trial,2),1)*clas; % class trial definition
            data.sampleinfo= [h.TRIG(logical(indx))+t(1)*fs,h.TRIG(logical(indx))+triallen+t(1)*fs-1];
            data.hdr.Fs    = fs;
            data.hdr.nChans= numel(channels2);
            data.hdr.Samples = triallen;
            data.hdr.nSamplesPre = 0;
            data.hdr.nTrials     = size(tmp1,3);
            data.hdr.label       = channels2;
            %% Time-freq descomposition
            fprintf(['Time-frequency subject...  ' num2str(s) '..No. ' num2str(find(SS==s)) ...
                '... of ' num2str(size(SS,2))  '\n '])
            timer_ = cell(numel(t_v),1);
            granger = cell(numel(t_v),1);
            for time_ = 1:numel(t_v)
                %                 if time_ == 1
                tstar    = t_v(time_);         % time of star.
                tend     = t_v(time_)+tam;     % time of stop.
                %                 else
                %                     tstar    = t_v(time_);         % time of star.
                %                     tend     = t_v(time_)+tam;% time of stop.
                %                 end
                %% Estructura de los datos.%'mtmfft'; 'wavelet' mtmconvol
                cfg             = [];
                cfg.method   = 'mvar';
                %                 cfg.output   = 'powandcsd';       %'powandcsd' %'fourier'; 'pow'
                %                 cfg.channel= 'all';
                %                 cfg.keeptrials  = 'yes';
                %                 cfg.width    = Ncycles;
                cfg.foi        = fmin:fsetp:fmax; % analysis 6 to 30 Hz in steps of 2 Hz.
                if strcmp(Mode_,'all')
                    cfg.toi    = 'all';           % el tiempo.
                else
                    cfg.toi    = tstar:twin:tend; % para% el tiempo.
                end
                timer_{time_} = tstar:twin:tend;
                %                 cfg.pad       = 'nextpow2';
                fprintf(['Causality Granger Connectivity subject...  ' num2str(s) '... of ' num2str(size(SS,2))  '\n '])
                %% Connectivity estimation
                method = 'granger';
                granger{time_} = fnc_Efective_granger(data,Norder,method,cfg,twin);
            end
            granger_{clas} = granger;
            tim_{clas}  = timer_;
            fprintf(['Connectivity subject...  ' num2str(s) '..No. ' num2str(find(SS,s)) ...
                '... of ' num2str(size(SS,2))  ' in class ' num2str(clas) '\n '])
        end
        %% Orden de datos para análisis.
        if Nfolds == 1
            Cx_all = cell(1,2);
            for cl = 1:2
                for time_1 = 1:numel(t_v)
                    for fr = 1:numel(granger_{cl}{time_1}.freq)
                        for v = 1:numel(granger_{cl}{time_1}.time)
                            Cx_all{cl}{time_1}(:,:,fr,v)  = granger_{cl}{time_1}.grangerspctrm(:,:,fr,v);
                        end
                    end
                end
            end
            % ordena la conectividad {fold}{cl}(cx,frequency,time)
            [Cx]=ordena_nuevo_cx(Cx_all);
            % almacena la información
            date.labelcmb = granger_{cl}{time_1}.label;
            date.time = tim_;
            date.freq = granger_{cl}{time_1}.freq;
        else
            Cx_all = cell(1,2);
            for cl = 1:2
                for time_1 = 1:numel(t_v)
                    for fr = 1:numel(granger_{cl}{time_1}.freq)
                        for v = 1:numel(granger_{cl}{time_1}.time)
                            Cx_all{cl}{time_1}(:,:,fr,v)  = granger_{cl}{time_1}.grangerspctrm(:,:,fr,v);
                        end
                    end
                end
            end
            % ordena la conectividad {fold}{cl}(cx,frequency,time)
            Cxf{fold} = ordena_nuevo_cx(Cx_all);
            % almacena la información
            dates{fold}.labelcmb = granger_{cl}{time_1}.label;
            dates{fold}.time = tim_;
            dates{fold}.freq = granger_{cl}{time_1}.freq;
        end
    end
    if Nfolds == 1
        save(['G:\Cx_granger_giga_all_time_0_7_sub',num2str(s),'.mat'],'Cx','data','date')
    else
        save(['G:\Cx_granger_giga_all_time_0_7_sub',num2str(s),'_folds_',num2str(Nfolds),'.mat'],'Cxf','date')
    end
    clc; clear eeg
end

%% seg - Group
% con esta función organiza la conectividad, la concatena para tener
% completa la dimensión del tiempo.
% ordena_nuevo_cx(Cx_all)

%% Orden de datos para análisis de grupo.
% for s = SS                % By subject
%     Cx_all = cell(1,1);
%     for fold = 1
%         for cl = 1:2
%             for fr = 1:numel(wpli{s}{cl}.freq)
%                 for v = 1:numel(wpli{s}{cl}.time)
%                     Cx_all{fold}{cl}(:,:,fr,v)  = squareform(wpli{s}{cl}.wplispctrm(:,fr,v));
%                 end
%             end
%         end
%     end
% %     wpli_dat = wpli
%     save(['F:\Cx_wpli_giga_all_time_sub',num2str(s),'.mat'],'Cx_all')
% end