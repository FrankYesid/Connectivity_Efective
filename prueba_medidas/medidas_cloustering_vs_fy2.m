clear; clc; close all;
% F. Zapata----------------------------------------------------------------
% addpath(genpath('G:\Dropbox\ERD\Codes\Topoplots\'));
addpath(genpath('D:\Toolbox\BCT'));
addpath(genpath('D:\Dropbox\ERD\Conectividad funcional\Conectividad Giga\'))
% run('D:\Toolbox\eeglab14_1_2b\eeglab.m')
close
% load connectivity wPLI en BCICIV_2a
% load('F:\conectividad_funcional_Giga\wpli_giga.mat')

%% Parameters
Nfreq = 1:17;
SS = 43:52;
% SS([29,34]) = [];
um = 0.3;
conect = 'funcional'; % 'funcional' 'efectiva'
Method_ = {'clustering';'local_eff';'global_eff';'path_len','degree','strengths'};
for s = SS
    load(['D:\Conectividad funcional\Cx_wpli_giga_all_time_0_7_sub',num2str(s),'.mat'])
    Cx = ordena_nuevo_cx(Cx_all);
    Cx{1}(isnan(Cx{1})) = 0;
    Cx{2}(isnan(Cx{2})) = 0;
    clustering = cell(2,1);
    global_eff = cell(2,1);
    local_eff  = cell(2,1);
    path_len   = cell(2,1);
    transitivity= cell(2,1);
    Degre      = cell(2,1);
    Strengths  = cell(2,1);
    CCx_       = cell(2,1);
    clustering_= zeros(64,size(Cx{1},4));
    global_eff_= zeros(1,size(Cx{1},4));
    local_eff_ = zeros(64,size(Cx{1},4));
    path_len_  = zeros(1,size(Cx{1},4));
    for met = [5,6]
        Method = Method_{met};
        for clas = 1:2
            tic
            cx_f = Cx{clas};
            for freq = Nfreq
                Cx_1 = squeeze(mean(abs(cx_f(:,:,freq:freq+2,:)),3));
                parfor v =1:size(cx_f,4)
                    %                     tic
                    Cx_ = squeeze(Cx_1(:,:,v));
                    if strcmp(conect,'funcional')
                        if strcmp(Method,'degree')           % degree
                            Degre_(:,v)        = degrees_und(Cx_);
                        elseif strcmp(Method,'strengths')    % strengths
                            Strengths_(:,v)    = strengths_und(Cx_);
                        elseif strcmp(Method,'clustering')   % clostering
                            clustering_(:,v)   = clustering_coef_wu(Cx_);
                            %                         elseif strcmp(Method,'transitivity') % transitivity
                            %                             transitivity_(:,freq,v) = transitivity_wu(Cx_);
                        elseif strcmp(Method,'local_eff')    % local efficiency
                            local_eff_(:,v)    = efficiency_wei(Cx_,2); 
                        elseif strcmp(Method,'global_eff')   % global efficiency
                            global_eff_(:,v)   = efficiency_wei(Cx_,0);
                        elseif strcmp(Method,'path_len')     % path length
                            [path_len_(:,v),~,~,~,~] = charpath(distance_wei(weight_conversion(Cx_,'lengths')));
                        end
                    elseif strcmp(conect,'efectiva')
                        %                         if strcmp(Method,'degree')           % degree
                        %                             [~,~,CCx_{freq}{v}] = degrees_dir(Cx_);
                        %                         elseif strcmp(Method,'strengths')    % strengths
                        %                             [~,CCx_{freq}{v},~] = strengths_dir(Cx_);
                        %                         end
                    end
                    %                     toc
                end % window
                Degre{clas}(:,freq,:)      = Degre_;
                Strengths{clas}(:,freq,:)  = Strengths_;
                clustering{clas}(:,freq,:) = clustering_; 
                global_eff{clas}(:,freq,:) = global_eff_;
                local_eff{clas}(:,freq,:)  = local_eff_;
                path_len{clas}(:,freq,:)   = path_len_;
            end % freq
            toc
        end % class
    end 
    save(['D:\Dropbox\graph_Giga_s',num2str(s),'_5.mat'],'local_eff')
end% subjects