% Limpiar lo almacenado y la ventana de comandos.
clear; close all; clc

%% Dirección de la base de datos
% SUBJECTS_DIR = 'D:\BCI';

% ---------------------------- LF ----------------------------
% SUBJECTS_DIR = 'D:\BCI';                                  % Base de datos
% SUBJECTS_DIR2 = 'D:\Luisa\Dropbox\ERD\results_ERDfc_subjects\BCI'; Almacena resultados de acc en dropbox.
% SUBJECTS_DIR3 = 'D:\Luisa\Dropbox\ERD\ERD_2019\BCI';      % Almacena graficas de ERD en Dropbox.
% SUBJECTS_DIR4 = 'D:\Luisa\Dropbox\ERD\Codigos Corriendo'; % Almacena las los reportes.
% % SUBJECTS_DIR4 = 'D:\BCI';                                 % particiones se encuentran en la misma carpte de BCI.
% SUBJECTS_DIR5 = 'Particiones';                            % particiones - se encuentra en Dropbox.
% SUBJECTS_DIR6 = 'Graficas';                                 % Guardar Graficas de acc u otras.

% ---------------------------- fy1 ---------------------------
SUBJECTS_DIR = 'F:\BCI';                                                            % Carga de Base de datos.
SUBJECTS_DIR2 = 'G:\Dropbox\ERD\results_ERDfc_subjects\BCI';    % Almacena resultados de acc en dropbox.
% SUBJECTS_DIR3 = 'G:\Dropbox\ERD\ERD_2019\BCI';              % Almacena graficas de ERD en Dropbox.
SUBJECTS_DIR4 = 'Codigos corriendo';                                        % Almacena las los reportes.
SUBJECTS_DIR5 = 'Particiones';                                                      % ubicación de las particiones
SUBJECTS_DIR6 = 'Graficas';                                                         % Guardar Graficas de acc u otras.

%% Direccion del fold de las funciones
% ---------------------------- LF ----------------------------
% addpath(genpath('D:\Luisa\Dropbox\ERD\Codes\TP\Matlab_wang\csp\CSP_fun\functions'))
% addpath(genpath('D:\Luisa\Dropbox\ERD\results_ERDfc_subjects'))
% ---------------------------- LF-pc -------------------------
% addpath(genpath('C:\Users\lfvelasquezm\Dropbox\ERD\Codes\TP\Matlab_wang\csp\CSP_fun\functions'))
% addpath(genpath('C:\Users\lfvelasquezm\Desktop\frank\functions'))

% ---------------------------- fy1 ---------------------------
addpath(genpath('G:\Dropbox\ERD\Conectividad efectiva\functions'))
addpath(genpath('F:\Toolbox\fieldtrip-master'))
% ---------------------------- fy2 ---------------------------
% addpath(genpath('C:\Users\frany\Dropbox\Event-related\Codes\TP\Matlab_wang\csp\CSP_fun\functions'));
% addpath(genpath('C:\Users\frany\Dropbox\Event-related\results_ERDfc_subjects'))

%% DataBase
%  BCIIII_4a_
%  BCICIV_2a_
%  GIGASCIENCE_

COHORT    = 'BCICIV_2a_';
SUBJECTS = dir([SUBJECTS_DIR filesep '*' COHORT '*']);
SUBJECTS = struct2cell(SUBJECTS);
SUBJECTS = SUBJECTS(1,:)';
% nombre del experimento.
experiment_name = mfilename;

% Sujetos de BCICIV_2a
SS = 1:9;

% Sujetos de Giga
% SS = [37 32 12 18 42 34 3 7 35 33 21 2 4 39 29 43 28]; % UNO BUENO Y UNO MALO%%%% INDEXACDOS DE ACIERDO A CSP
% SS = [37 32 12 18 42 34 3 7];
% [37,15,7,1:6]; %6,14 [18:41]

% if strcmp(COHORT,'GIGASCIENCE_')   -   Mirar que sujetos no se utilizan.
%     SubInd = [50,14];
%     SS(SubInd) = [];
% end

%% paramaters definition
% Tiempo de referencia - solo si se calcula el ERD
tstart = 0.5;
tend = 1.5;
% definir parametros de filter bank
f_low  = 4;              % Frecuencia mínima de análisis.
f_high = 40;            % Frecuencia máxima de análisis.
Window = 4;           % Tamaño de la banda de filtrado.
Ovrlap = 2;             % Traslape de frecuencia.
filter_bank = [f_low:Ovrlap:f_high-Window;...
    f_low+Window:Ovrlap:f_high]';
orden_filter = 5;       % orden del filtro.
labels_ = [1 2];         % labels utilizados.
Nfolds = 10;             % Numero de folds
% Carga de las particiones
load([SUBJECTS_DIR5 filesep 'cvNEW.mat'])
warning off
load labels              % Nombre de los canales.
for s = SS
    reporte = [SUBJECTS_DIR4 filesep SUBJECTS{s} '_Cx.txt'];
    diary('on')
    diary(reporte)
    load([SUBJECTS_DIR filesep SUBJECTS{s} filesep 'eeg' filesep 'raw.mat'])
    y1 = y(:);
    X1 = X;
    granger = cell(1,numel(Nfolds));
    for fold = 1:Nfolds
        indx = c{s,fold}.training; %ismember(y,labels);
        indd = ismember(y1,labels_);
        ind = logical(indx.*indd);
        clear indx indd
        y = y1(ind);
        X = X1(ind);
        X = cellfun(@(x) double(x) ,X,'UniformOutput',false);
        
        tic
        for tr = 1:numel(y)
            tem = X{tr}';
            data1.trial     = {tem};
            data1.time      = {(0:1/250:7-1/250)};
            data1.fsample   = fs;
            data1.label     = labels;
            order = 5; method = 'granger';
            tem_ = fnc_Efective_granger(data1,order,method);
            granger{fold}{tr} = abs(tem_.grangerspctrm)./max(abs(tem_.grangerspctrm));
            fprintf(['tr: ' num2str(tr)])
        end
        y_{fold} = y;
    end
    freq = tem_.freq;    
    toc
    save(['H:\Cx_sub_' num2str(s) ' .mat'],'granger','freq','y_')
end