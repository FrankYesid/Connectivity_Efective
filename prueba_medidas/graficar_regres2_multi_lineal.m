% figura de regresion - mean
clear; clc

% load('D:\Dropbox\ERD\Conectividad funcional\Resultados_grafos\Resultados_medidas_grafos_giga_norm_2_2.mat')
% load('Entropy_clus_2_2.mat')
load('F:\Dropbox\ERD\Conectividad funcional\prueba_medidas\means_acc_daniel.mat')
SS = 1:52;
SS([29,34]) = [];
acc_ = Means_giga_(SS,1);
Nfreq = [3,5,7,9];
Method = {'Clustering_coeff','Global_Eff','Local_Eff','Path_Len','Degree','Strength','Entropy'};


for freq = 1:17
    caract_ = [acc_];
    for met = [1,2,4,6]
        if met == 1
            load(['F:\Dropbox\ERD\Conectividad efectiva' filesep 'Resultados_medidas_grafos_giga_norm_2.mat'])
        elseif met ==2
            load(['F:\Dropbox\ERD\Conectividad efectiva' filesep 'Resultados_medidas_grafos_giga_norm_2_2.mat'])
        elseif met ==4
            load(['F:\Dropbox\ERD\Conectividad efectiva' filesep 'Resultados_medidas_grafos_giga_norm_2.mat'])
        elseif met ==6
            load(['F:\Dropbox\ERD\Conectividad efectiva' filesep 'Resultados_medidas_grafos_giga_norm_2_2.mat'])
        end        
        %         figure
        if met == 1
            graph = squeeze(Clustering(:,freq));
        elseif met == 2
            graph = squeeze(Global_Eff(:,freq));
        elseif met == 3
            graph = squeeze(Local_Eff(:,freq));
        elseif met == 4
            graph = squeeze(Path_Len(:,freq));
        elseif met == 5
            graph = squeeze(Degree(:,freq));
        elseif met == 6
            graph = squeeze(Strendth(:,freq));
        elseif met == 7
            if freq == 3
                fr = 1;
            elseif freq == 5
                fr = 2;
            elseif freq == 7
                fr = 3;
            elseif freq == 9
                fr = 4;
            end
            graph = squeeze(Entrpy(fr,:))';
        end
        
        caract_ = [caract_,graph];
        %         plotregression(X2(:,2)',X2(:,1)','Regression');
        %         ylim([50 100])
        %         xlim([min(X2(:,2))-0.1 max(X2(:,2))+0.1])
        %         saveas(gca,['D:\Dropbox\[4] Cx predictor\figure\regress\',Method{met},'_acc_fr',num2str(freq)],'png')
        %         fig = gca;
        %         rho1(freq,met) = str2num(fig.Title.String(15:end));
        %
        %         close
    end
    car{freq} = caract_;
    [RHO_spearman{freq},PVAL_spearman{freq}] = corr(caract_,'Type','Spearman');
    [RHO_pearson{freq},PVAL_pearson{freq}] = corr(caract_,'Type','Pearson');    
end

%%
clear b bint r rint stats
for fre = [3,5,7,9]
    y = car{fre}(:,1);       %Accidents per state
    X = [ones(50,1),car{fre}(:,[2,3,4,5])]; %Population of states
    [b{fre},bint{fre},r{fre},rint{fre},stats{fre}] = regress(y,X,0.01);
end

%%
clear b bint r rint stats
y = car{1}(:,1);       %Accidents per state
x_ = [];
for fre = [1,3,5,7,9,11,13,15,17]
    x_ = [x_, car{fre}(:,[2,3,4,5])];
end
X = [ones(50,1),x_]; %Population of states
[b,bint,r,rint,stats] = regress(y,X,0.01);


% for freq = Nfreq
%     figure
% %     set(gcf,'position',[667   528   404   420])
% %     x1 = 0.067;     y1 = 0.06;     w = 0.91;      h = 0.92;
% %     subplot('position',[x1,y1,w,h]);
%     imagesc(abs(RHO_spearman{freq}))
%     title(['RHO spearman freq',num2str(freq)])
%     colorbar()
%     set(gca,'TickLabelInterpreter','latex','FontSize',16,'XTick',1:5,'XTickLabel',{'acc','clustering','global eff', 'path len', 'strength'},...
%         'XTickLabelRotation',90,'YTick',1:5,'YTickLabel',{'acc','clustering','global eff', 'path len', 'strength'})
%     saveas(gca,['D:\Dropbox\[4] Cx predictor\figure\regress\Rho_spearman_freq',num2str(freq)],'png')
%     close
% end

% for freq = Nfreq
%     figure
% %     set(gcf,'position',[667   528   404   420])
% %     x1 = 0.067;     y1 = 0.06;     w = 0.91;      h = 0.92;
% %     subplot('position',[x1,y1,w,h]);
%     imagesc(abs(RHO_pearson{freq}))
%     title(['RHO pearson freq',num2str(freq)])
%     colorbar()
%     set(gca,'TickLabelInterpreter','latex','FontSize',16,'XTick',1:5,'XTickLabel',{'acc','clustering','global eff', 'path len', 'strength'},...
%         'XTickLabelRotation',90,'YTick',1:5,'YTickLabel',{'acc','clustering','global eff', 'path len', 'strength'})
%     saveas(gca,['D:\Dropbox\[4] Cx predictor\figure\regress\Rho_pearson_freq',num2str(freq)],'png')
%     close
% end