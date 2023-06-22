% figura de regresion - mean
clear; clc
load('D:\Dropbox\ERD\Conectividad funcional\Resultados_grafos\Resultados_medidas_grafos_giga_norm.mat')
load('D:\Dropbox\ERD\Conectividad funcional\prueba_medidas\means_acc_daniel.mat')
SS = 1:52;
SS([29,34]) = [];
acc_ = Means_giga_(SS,1);
Nfreq = [3,5,7,9];
Method = {'Clustering_coeff','Global_Eff','Local_Eff','Path_Len','Degree','Strength'};
close; 
for met = 6
    for freq = Nfreq
        figure
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
        end
        X2 = [acc_,graph];
        plotregression(X2(:,2)',X2(:,1)','Regression');
        ylim([50 100])
%         xlim([min(X2(:,2))-0.1 max(X2(:,2))+0.1])
%         saveas(gca,['D:\Dropbox\[4] Cx predictor\figure\regress\',Method{met},'_acc_fr',num2str(freq)],'png')
        fig = gca; 
        rho1(freq,met) = str2num(fig.Title.String(15:end));        
        close
    end
end

%%
% figura de regresion - kurtosis
% clear; clc
load('D:\Dropbox\ERD\Conectividad funcional\Resultados_grafos\Resultados_medidas_grafos_giga_k_norm.mat')
load('D:\Dropbox\ERD\Conectividad funcional\prueba_medidas\means_acc_daniel.mat')
SS = 1:52;
SS([29,34]) = [];
acc_ = Means_giga_(SS,1);
Nfreq = [3,5,7,9]; 
Method = {'Clustering_coeff','Global_Eff','Local_Eff','Path_Len','Degree','Strength'};
close; 
for met = 6
    for freq = Nfreq
        figure
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
        end
        X2 = [acc_,graph];
        plotregression(X2(:,2)',X2(:,1)','Regression');
%         ylim([50 100])
%         xlim([min(X2(:,2))-0.1 max(X2(:,2))+0.1])
%         saveas(gca,['D:\Dropbox\[4] Cx predictor\figure\regress\',Method{met},'_acc_fr',num2str(freq)],'png')
        fig = gca; 
        rho2(freq,met) = str2num(fig.Title.String(15:end));        
        close
    end
end

open rho1 
open rho2