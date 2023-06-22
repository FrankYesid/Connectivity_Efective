clear; clc; close all;
% F. Zapata----------------------------------------------------------------
% addpath(genpath('G:\Dropbox\ERD\Codes\Topoplots\'));
addpath(genpath('F:\Toolbox\BCT'));
addpath(genpath('F:\Dropbox\ERD\Conectividad funcional\Conectividad Giga\'))
% run('D:\Toolbox\eeglab14_1_2b\eeglab.m')
close
%% Parameters
Nfreq   = 1:17;%[5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37];
SS      = 1:52;
SS([29,34]) = [];
channels_select = 1:64;%sort([1,33,34,7,5,38,40,42,15,13,48,50,52,23,21,31,58,60,27,29,64]);
chan_motor = [4,5,9:14,17:21,31,32,38:40,44:51,54:58];
t1      = 9;
t2      = 43;
um      = 0.3;
um2     = 0.2;
conect  = 'funcional'; % 'funcional' 'efectiva'
Method_ = {'clustering';'local_eff';'global_eff';'path_len';'degree';'strengths'};
meth = '_2';
for met = [1,3,4,5]
    for s = SS
        %  load(['G:\Cx_granger_giga_rest_sub',num2str(s),'.mat'])
        load(['E:\Cx_coh_giga_rest_sub',num2str(s),'.mat'])
        Cx = Cx_rest;
        Cx{1}(isnan(Cx{1})) = 0;
        %                 for c1 = 1:64
        %                     if isempty(find(chan_motor==c1, 1))
        %                         Cx{1}(c1,:,:,:) = 0;
        %                     else
        %                         chans = zeros(1,numel(channels_select));
        %                         chans(chan_motor) = 1;
        %                         Cx{1}(c1,~logical(chans),:,:) =0;
        %                     end
        %                 end
        %         clustering = cell(1,1);
        %         global_eff = cell(1,1);
        %         local_eff  = cell(1,1);
        %         path_len   = cell(1,1);
        %         Degre      = cell(1,1);
        %         Strengths  = cell(1,1);
        %         transitivity= cell(1,1);
        %         CCx_       = cell(1,1);
        %         Degre_     = zeros(numel(channels_select),17);
        %         Strengths_ = zeros(numel(channels_select),17);
        %         clustering_= zeros(numel(channels_select),17);
        %         global_eff_= zeros(1,17);
        %         local_eff_ = zeros(numel(channels_select),17);
        %         path_len_  = zeros(1, 17);
        Method = Method_{met};
        Cx_1 = zeros(64,64,52);
        for clas = 1
            tic
            cx_f = abs(Cx{clas});
            for freq = Nfreq
                tem = squeeze(abs(cx_f(:,:,freq:freq+2,t1:t2)));
                Cx_1= mean(tem,3);
                parfor v = 1:size(tem,4)
                    Cx_ = squeeze(Cx_1(channels_select,channels_select,v));
                    if strcmp(meth,'_2') % sin umbralizar
                        if strcmp(conect,'funcional')
                            if strcmp(Method,'degree')           % degree
                                Degre_(:,v)        = degrees_und(Cx_);
                            elseif strcmp(Method,'strengths')    % strengths
                                Strengths_(:,v)    = strengths_dir(Cx_);
                            elseif strcmp(Method,'clustering')   % clostering
                                tt_ =  weight_conversion(Cx_,'normalize');
                                clustering_(:,v)  = clustering_coef_wd(tt_);
                                %                         elseif strcmp(Method,'transitivity') % transitivity
                                %                             transitivity_(:,freq,v) = transitivity_wu(Cx_);
                            elseif strcmp(Method,'local_eff')    % local efficiency
                                local_eff_(:,v)    = efficiency_wei(Cx_,2);
                            elseif strcmp(Method,'global_eff')   % global efficiency
                                global_eff_(:,v)   = efficiency_wei(Cx_,0);
                            elseif strcmp(Method,'path_len')     % path length
                                [path_len_(:,v),~,~,~,~] = charpath(distance_wei(weight_conversion(Cx_,'lengths')));
                            end
                            %    elseif strcmp(conect,'efectiva')
                            %       if strcmp(Method,'degree')           % degree
                            %       [~,~,CCx_{freq}{v}] = degrees_dir(Cx_);
                            %    elseif strcmp(Method,'strengths')    % strengths
                            %     [~,CCx_{freq}{v},~] = strengths_dir(Cx_);
                            %    end
                        end
                    elseif strcmp(meth,'_2_') % con umbralización
                        if strcmp(conect,'funcional')
                            if strcmp(Method,'degree')           % degree
                                Degre_(:,v)        = degrees_und(threshold_proportional(Cx_,um));
                            elseif strcmp(Method,'strengths')    % strengths
                                Strengths_(:,v)    = strengths_dir(threshold_proportional(Cx_,um));
                            elseif strcmp(Method,'clustering')   % clostering
                                tt_ =  threshold_proportional(weight_conversion(Cx_,'normalize'),um);
                                clustering_(:,v)  = clustering_coef_wd(tt_);
                                %                         elseif strcmp(Method,'transitivity') % transitivity
                                %                             transitivity_(:,freq,v) = transitivity_wu(Cx_);
                            elseif strcmp(Method,'local_eff')    % local efficiency
                                local_eff_(:,v)    = efficiency_wei(threshold_proportional(Cx_,um),2);
                            elseif strcmp(Method,'global_eff')   % global efficiency
                                global_eff_(:,v)   = efficiency_wei(threshold_proportional(Cx_,um),0);
                            elseif strcmp(Method,'path_len')     % path length
                                [path_len_(:,v),~,~,~,~] = charpath(distance_wei(threshold_proportional(weight_conversion(Cx_,'lengths'),um)));
                            end
                            %    elseif strcmp(conect,'efectiva')
                            %       if strcmp(Method,'degree')           % degree
                            %       [~,~,CCx_{freq}{v}] = degrees_dir(Cx_);
                            %    elseif strcmp(Method,'strengths')    % strengths
                            %     [~,CCx_{freq}{v},~] = strengths_dir(Cx_);
                            %    end
                        end
                    end
                end % window
                %                 pos_f = pos_f+1;
                if met == 5
                    Degre{s}{clas}{freq}      = Degre_;
                    %             Strengths{s}{clas}  = Strengths_;
                elseif met == 1
                    clustering{s}{clas}{freq}   = clustering_;
                elseif met == 3
                    global_eff{s}{clas}{freq}   = global_eff_;
                    %             local_eff{s}{clas}  = local_eff_;
                elseif met == 4
                    path_len{s}{clas}{freq}     = path_len_;
                end
            end % freq
           
            toc
        end % class
    end
    if met == 1
        save(['G:\graph_s',num2str(s),'_clustering_norm_',meth,'.mat'],'clustering')
    elseif met == 2
        save(['G:\graph_s',num2str(s),'_local_eff_norm_',meth,'.mat'],'local_eff')
    elseif met == 3
        save(['G:\graph_s',num2str(s),'_global_eff_norm_',meth,'.mat'],'global_eff')
    elseif met == 4
        save(['G:\graph_s',num2str(s),'_path_len_norm_',meth,'.mat'],'path_len')
    elseif met == 5
        save(['G:\graph_s',num2str(s),'_Degre_norm_',meth,'.mat'],'Degre')
    elseif met == 6
        save(['G:\graph_s',num2str(s),'_Strengths_norm_',meth,'.mat'],'Strengths')
    end
    clc
end% subjects