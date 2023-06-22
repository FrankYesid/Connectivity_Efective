clear; clc; close all;
% F. Zapata----------------------------------------------------------------
% addpath(genpath('G:\Dropbox\ERD\Codes\Topoplots\'));
addpath(genpath('D:\Toolbox\BCT'));
addpath(genpath('D:\Dropbox\ERD\Conectividad funcional\Conectividad Giga\'))
% run('D:\Toolbox\eeglab14_1_2b\eeglab.m')
close
%% Parameters
Nfreq   = 1:17;
SS      = 1:52;
SS([29,34]) = [];
channels_select = 1:64; %sort([1,33,34,7,5,38,40,42,15,13,48,50,52,23,21,31,58,60,27,29,64]);
t1      = 9;
t2      = 43;
um      = 0.3;
um2     = 0.2;
conect  = 'funcional'; % 'funcional' 'efectiva'
Method_ = {'clustering';'local_eff';'global_eff';'path_len';'degree';'strengths'};
for met = [1,3,4,6]
    for s = SS
        load(['D:\Conectividad funcional\Cx_wpli_giga_rest_sub',num2str(s),'.mat'])
        Cx = Cx_rest{s};
        Cx{1}(isnan(Cx{1})) = 0;
        %         Cx{2}(isnan(Cx{2})) = 0;
        clustering = cell(1,1);
        global_eff = cell(1,1);
        local_eff  = cell(1,1);
        path_len   = cell(1,1);
        Degre      = cell(1,1);
        Strengths  = cell(1,1);
        transitivity= cell(1,1);
        CCx_       = cell(1,1);
        Degre_     = zeros(numel(channels_select), 52);
        Strengths_ = zeros(numel(channels_select), 52);
        clustering_= zeros(numel(channels_select), 52);
        global_eff_= zeros(1, 52);
        local_eff_ = zeros(numel(channels_select), 52);
        path_len_  = zeros(1, 52);
        Method = Method_{met};
        Cx_1 = NaN(64,64,52);
        for clas = 1
            tic
            cx_f = abs(Cx{clas});
            for freq = Nfreq
                    tem = squeeze(abs(cx_f(:,:,freq:freq+2,:)));
                    Cx_1= mean(tem,3);
                parfor v = 1:52
                    Cx_ = squeeze(Cx_1(channels_select,channels_select,v));
                    if strcmp(conect,'funcional')
                        if strcmp(Method,'degree')           % degree
                            Degre_(:,v)        = degrees_und(threshold_proportional(Cx_,um));
                        elseif strcmp(Method,'strengths')    % strengths
                            Strengths_(:,v)    = strengths_und(Cx_);
                        elseif strcmp(Method,'clustering')   % clostering
                            clustering_(:,v)  = clustering_coef_wu(weight_conversion(Cx_,'normalize')); 
                            %                         elseif strcmp(Method,'transitivity') % transitivity
                            %                             transitivity_(:,freq,v) = transitivity_wu(Cx_);
                        elseif strcmp(Method,'local_eff')    % local efficiency
                            local_eff_(:,v)    = efficiency_wei(Cx_,2);
                        elseif strcmp(Method,'global_eff')   % global efficiency
                            global_eff_(:,v)   = efficiency_wei(Cx_,0);
                        elseif strcmp(Method,'path_len')     % path length
                            [path_len_(:,v),~,~,~,~] = charpath(distance_wei(weight_conversion(Cx_,'lengths')));
                        end
                        %                     elseif strcmp(conect,'efectiva')
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
        if met == 1
            save(['D:\graph_s',num2str(s),'_4r_norm_sin.mat'],'clustering')
        elseif met == 2
            save(['D:\graph_s',num2str(s),'_5r_norm_sin.mat'],'local_eff')
        elseif met == 3
            save(['D:\graph_s',num2str(s),'_3r_norm_sin.mat'],'global_eff')
        elseif met == 4
            save(['D:\graph_s',num2str(s),'_2r_norm_sin.mat'],'path_len')
        elseif met == 5
            save(['D:\graph_s',num2str(s),'_6r_norm_sin.mat'],'Degre')
        elseif met == 6
            save(['D:\graph_s',num2str(s),'_7r_norm_sin.mat'],'Strengths')
        end
    end
    clc
end% subjects