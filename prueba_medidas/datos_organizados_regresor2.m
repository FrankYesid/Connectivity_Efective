% Main figures, theory graphs
clear; clc
% Mean
% [0.0238,0.2925]
minn = 0.0238;
maxx = 0.2925;
time = 0:0.0385:2;
Nfreq= [3,5,7,9];
chan_select = 1:64;%[1,33,34,7,5,38,40,42,15,13,48,50,52,23,21,31,58,60,27,29,64];%[4,5,9:14,17:21,31,32,38:40,44:51,54:58];
SS   = 1:52;
% SS = [43,14,41,3,23,4,48,50,10,46,26,5,44,49,6,13,35,37,31,15,25,36,21,22,28,39,20,12,52,1,47,19,38,27,33,16,9,42,18,30,2,24,7,17,45,11,32,40,51,8];
SS ([29,34]) = [];
t1   = 9;
t2   = 44;
Clustering = zeros(numel(SS),17);
Path_Len   = zeros(numel(SS),17);
Global_Eff = zeros(numel(SS),17);
% Local_Eff  = zeros(numel(SS),17);
% Degree     = zeros(numel(SS),17);
Strendth   = zeros(numel(SS),17);
a = 1;
for s = SS
    load(['G:\graph_efectiva\graph_s',num2str(s),'_2r_norm_2.mat'],'path_len')%
    load(['G:\graph_efectiva\graph_s',num2str(s),'_3r_norm_2.mat'],'global_eff')%
    load(['G:\graph_efectiva\graph_s',num2str(s),'_4r_norm_2.mat'],'clustering')%
    %     load(['D:\graph_s',num2str(s),'_5r.mat'],'local_eff')
    %     load(['D:\graph_s',num2str(s),'_6r.mat'],'Degre')
    load(['G:\graph_efectiva\graph_s',num2str(s),'_7r_norm_2.mat'],'Strengths')%
    
    %Organizar datos de clustering
    for freq = 1:17
        t1_ = squeeze(clustering{1}(:,freq));
        t1_(isnan(t1_)) = 0;
        clust{freq}(a,:) = t1_;
    end
    clear tem
    for freq = 1:17
        ta = squeeze(clustering{1}(chan_select,freq));
        ta(isnan(ta)) = 0;
        %         b = 1;
        %         for v = t1:t2
        tem(freq,:) = mean(ta,1);
        %             b = b+1;
        %         end
    end
    Clustering(a,:) = tem;
    
    %Organizar datos de Path length
    for freq = 1:17
        t2_ = squeeze(path_len{1}(:,freq));
        t2_(isnan(t2_)) = 0;
        t2_(isinf(t2_)) = 0;
        path_{freq}(a,:) = t2_;
    end
    clear tem
    for freq = 1:17
        ts = squeeze(path_len{1}(1,freq));
        ts(isnan(ts)) = 0;
        tem(freq,:)  = ts;
    end
    tem(isinf(tem)) = 0;
    %     for fr = 1:17
    Path_Len(a,:)   = tem;%mean(tem(fr,[tem(fr,:)~=0]));
    %     end
    
    %Organizar datos de Global efficiency
    for freq = 1:17
        t3_ = squeeze(global_eff{1}(:,freq));
        t3_(isnan(t3_)) = 0;
        global_{freq}(a,:) = t3_;
    end
    clear tem
%     for freq = 1:17
%         t3 = 
%         t3(isnan(t3)) =0;
        tem  = squeeze(global_eff{1}(1,:));
%     end
    %     for fr = 1:17
    Global_Eff(a,:)   = tem;%mean(tem(fr,[tem(fr,:)~=0]));
    %     end
    
    %     %Organizar datos de Local efficiency
    %     clear tem
    %     for freq = 1:17
    %         tem(freq,:)  = mean(squeeze(local_eff{1}(:,freq,:)),1);
    %     end
    %     Local_Eff(a,:)  = mean(tem,2);
    
    %     %Organizar datos de Degree
    %     clear tem
    %     for freq = 1:17
    %         tem(freq,:)  = mean(squeeze(Degre{1}(:,freq,:)),2);
    %     end
    %     Degree(a,:)     = mean(tem,2);
    
    %Organizar datos de Strendth
    
    for freq = 1:17
        t4 = Strengths{1}(:,freq);
        t4(isnan(t4)) = 0;
        Stren{freq}(a,:) = t4;
    end
    clear tem
    for freq = 1:17
        da = squeeze(Strengths{1}(chan_select,freq));
        da(isnan(da)) = 0; 
        %         b = 1;
        %         for v = t1:t2
        tem(freq,:) = mean(da);
        %             b = b+1;
        %         end
    end
    Strendth(a,:)   = tem;
    a = a+1;
end 

save('Strength_2.mat','Stren')
save('Global_Eff_2.mat','global_')
save('path_len_2.mat','path_')
save('clustering_2.mat','clust')

% s = 8; fre = 3;
% mean_ = mean(Stren{fre}(s,:,:),3);
% var_  = var(Stren{fre}(s,:,:),0,3);
% figure; errorbar(mean_,var_)
% ylim([-80 120])
% title(['Sub ',num2str(s) ' freq ' num2str(fre)])

save(['F:\Dropbox\ERD\Conectividad efectiva' filesep 'Resultados_medidas_grafos_giga_norm_2.mat'],...
    'Clustering','Path_Len','Global_Eff','Strendth','SS')
%
% %%
% % kurtosis
% % Main figures, theory graphs
% clear; clc
% %
% % [0.0238,0.2925]
% minn = 0.0238;
% maxx = 0.2925;
% time = 0:0.0385:2;
% Nfreq= [3,5,7,9];
% chan_select = [34,7,5,38,40,42,15,13,48,50,52,23,21,31,58,60,27,29,64];%[4,5,9:14,17:21,31,32,38:40,44:51,54:58];
% SS = 1:52;
% SS ([29,34]) = [];
% t1 = 9;
% t2 = 43;
%
% Clustering = zeros(numel(SS),17);
% Path_Len   = zeros(numel(SS),17);
% Global_Eff = zeros(numel(SS),17);
% Local_Eff  = zeros(numel(SS),17);
% Degree     = zeros(numel(SS),17);
% Strendth   = zeros(numel(SS),17);
% a = 1;
% for s =SS
%     load(['D:\graph_s',num2str(s),'_2r_norm.mat'],'path_len')%
%     load(['D:\graph_s',num2str(s),'_3r_norm.mat'],'global_eff')%
%     load(['D:\graph_s',num2str(s),'_4r_norm.mat'],'clustering')%
%     load(['D:\graph_s',num2str(s),'_5r.mat'],'local_eff')
%     load(['D:\graph_s',num2str(s),'_6r.mat'],'Degre')
%     load(['D:\graph_s',num2str(s),'_7r_norm.mat'],'Strengths')%
%
%     %Organizar datos de clustering
% %     clear tem
% %     for freq = 1:17
% %         for v = 1:size(clustering{1},3)
% %             tem(freq,v)  =kurtosis(squeeze(clustering{1}(chan_select,freq,v)));
% %         end
% %         Clustering(a,freq) = kurtosis(squeeze(tem(freq,:)));
% %     end
% %
% %
% %     %Organizar datos de Path length
% %     clear tem
% %     for freq = 1:17
% %         for v = 1:size(clustering{1},3)
% %             tem(freq,v)  = squeeze(path_len{1}(1,freq,v));
% %         end
% %         tem(isinf(tem)) = 0;
% %         Path_Len(a,freq)   = kurtosis(squeeze(tem(freq,:)));
% %     end
% %
% %
% %     %Organizar datos de Global efficiency
% %     clear tem
% %     for freq = 1:17
% %         for v = 1:size(clustering{1},3)
% %             tem(freq,v)  = squeeze(global_eff{1}(1,freq,v));
% %         end
% %         Global_Eff(a,freq) = kurtosis(squeeze(tem(freq,:)));
% %     end
%
% %     %Organizar datos de Local efficiency
% %     clear tem
% %     for freq = 1:17
% %         tem(freq,:)  = mean(squeeze(local_eff{1}(:,freq,:)),1);
% %     end
% %     Local_Eff(a,:)  = mean(tem,2);
%
% %     %Organizar datos de Degree
% %     clear tem
% %     for freq = 1:17
% %         tem(freq,:)  = mean(squeeze(Degre{1}(:,freq,:)),2);
% %     end
% %     Degree(a,:)     = mean(tem,2);
%
%     %Organizar datos de Strendth
%     clear tem
%     for freq = 1:17
%         for v = 1:size(clustering{1},3)
%             tem(freq,v)  = kurtosis(squeeze(Strengths{1}(chan_select,freq,v)));
%         end
%         Strendth(a,freq)   = kurtosis(squeeze(tem(freq,:)));
%     end
%     a = a+1;
% end
%
% save(['D:\Dropbox\ERD\Conectividad funcional\Resultados_grafos' filesep 'Resultados_medidas_grafos_giga_K_norm_2.mat'],...
%     'Clustering','Path_Len','Global_Eff','Strendth','SS')