clear; clc; close all;
% F. Zapata----------------------------------------------------------------
% addpath(genpath('G:\Dropbox\ERD\Codes\Topoplots\'));
addpath(genpath('F:\Toolbox\BCT'));
addpath(genpath('F:\Dropbox\ERD\Conectividad funcional\Conectividad Giga\'))
run('F:\Toolbox\EEGLAB\eeglab14_1_2b\eeglab14_1_2b\eeglab.m')
close
% load connectivity wPLI en BCICIV_2a
% load('F:\conectividad_funcional_Giga\wpli_giga.mat')

%% Parameters
Nfreq = 1:17;
SS = 1:28;
% SS([29,34]) = [];
um = 0.3;
conect = 'funcional'; % 'funcional' 'efectiva'
Method_ = {'clustering';'local_eff';'global_eff';'path_len'};
for met = 2
    for s = 43
        load(['L:\conectividad_funcional2020\Cx_wpli_giga_all_time_0_7_sub',num2str(s),'.mat'])
        Cx = ordena_nuevo_cx(Cx_all);
        Cx{1}(isnan(Cx{1})) = 0;
        Cx{2}(isnan(Cx{2})) = 0;
        clustering = cell(2,1);
        global_eff = cell(2,1);
        local_eff  = cell(2,1);
        path_len   = cell(2,1);
        transitivity= cell(2,1);
        CCx_       = cell(2,1);
         Degre_= zeros(64,size(Cx{1},4));
         Strengths_ = zeros(64,size(Cx{1},4));
        clustering_= zeros(64,size(Cx{1},4));
        global_eff_= zeros(1,size(Cx{1},4));
        local_eff_ = zeros(64,size(Cx{1},4));
        path_len_  = zeros(1,size(Cx{1},4));
        
        Method = Method_{met};
        for clas = 1:2
            tic
            cx_f = abs(Cx{clas});
            for freq = [3,5,7,9]
                Cx_1 = squeeze(mean(cx_f(:,:,freq:freq+2,:),3));
                parfor v =1:size(cx_f,4)
                    %                     tic
                    Cx_ =squeeze(Cx_1(:,:,v));
                    if strcmp(conect,'funcional')
                        if strcmp(Method,'degree')           % degree
                            Degre_(:,v)        = degrees_und(Cx_);
                        elseif strcmp(Method,'strengths')    % strengths
                            Strengths_(:,v)    = strengths_und(Cx_);
                        elseif strcmp(Method,'clustering')   % clostering
                            clustering_(:,v)  = clustering_coef_wu(Cx_);
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
        if met == 4
            save(['F:\graph_s',num2str(s),'_2.mat'],'path_len')
        elseif met == 3
            save(['F:\graph_s',num2str(s),'_3.mat'],'global_eff')
        elseif met == 1
            save(['F:\graph_s',num2str(s),'_4.mat'],'clustering')
        elseif met == 2
            save(['F:\graph_s',num2str(s),'_5_.mat'],'local_eff')
        end
    end
    clc
end% subjects