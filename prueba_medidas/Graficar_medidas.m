% Main figures, theory graphs
clear; clc
%
% [0.0238,0.2925]
minn = 0.0238;
maxx = 0.2925;
time = 0:0.0385:7;
Nfreq= [3,5,7,9];%1:17;

SS = 1:52;
SS ([29,34]) = [];
for s = 43
    load(['F:\graph_s',num2str(s),'_2.mat'],'path_len')
    load(['F:\graph_s',num2str(s),'_3.mat'],'global_eff')
    load(['F:\graph_s',num2str(s),'_4.mat'],'clustering')
    load(['F:\graph_s',num2str(s),'_5_.mat'])
    for cl = 1:2
        a = 1;
        b = 1;
        c = 1;
        d = 1;
%         for fr = [3,5,7,9]
%             % Medida
%             figure
%             imagesc(time(7:176),1:64,(squeeze(clustering{cl}(:,fr,7:176))-minn)/(maxx-minn))
%             %             leng{a} = ['fr',num2str(fr),'-cl',num2str(cl)];
%             %             a = a+1;
%             title(['Sub ',num2str(s),' Cl',num2str(cl),' fr',num2str(fr)])
%             saveas(gca,['F:\Dropbox\[4] Cx predictor\figure\graph\Graph_clus_s' num2str(s) '_cl' num2str(cl), '_fr' num2str(fr)],'png')
%             close
%         end
        figure
        for fr = Nfreq
            % Medida
            hold on
            plot(time(7:176),mean(squeeze(clustering{cl}(:,fr,7:176)),1))
%             ylim([0.02,0.14])
            ylim([0.02,0.20])
            leng{a} = ['fr',num2str(fr),'-cl',num2str(cl)];
            a = a+1;
        end
        hold off
        legend(leng,'Interpreter','latex','Location','southeastoutside') %'southeast')
        legend('boxoff')
        saveas(gca,['F:\Dropbox\[4] Cx predictor\figure\graph\Graph_clus_s' num2str(s) '_cl' num2str(cl) 'r'],'png')
        close
        
        
        
        % Medida
        figure
        for fr = Nfreq
            % Medida
            hold on
            plot(time(7:176),squeeze(global_eff{cl}(1,fr,7:176)))
            leng{b} = ['fr',num2str(fr),'-cl',num2str(cl)];
            b = b+1;
        end
        hold off
        legend(leng,'Interpreter','latex','Location','southeastoutside')
        legend('boxoff')
        saveas(gca,['F:\Dropbox\[4] Cx predictor\figure\graph\Graph_glo_ef_s' num2str(s) '_cl' num2str(cl) 'r'],'png')
        close
        
        % Medida
        figure
        for fr = Nfreq
            % Medida
            hold on
            plot(time(7:176),mean(squeeze(local_eff{cl}(:,fr,7:176)),1))
%             ylim([0.02,0.16])
            ylim([0.02,0.20])
            leng{c} = ['fr',num2str(fr),'-cl',num2str(cl)];
            c = c+1;
        end
        hold off
        legend(leng,'Interpreter','latex','Location','southeastoutside')
        legend('boxoff')
        saveas(gca,['F:\Dropbox\[4] Cx predictor\figure\graph\Graph_loc_ef_s' num2str(s) '_cl' num2str(cl) 'r'],'png')
        close
        
        % Medida
        figure 
        for fr = Nfreq
            % Medida
            hold on
            plot(time(7:176),squeeze(path_len{cl}(1,fr,7:176)))
            leng{d} = ['fr',num2str(fr),'-cl',num2str(cl)];
            d = d+1;
        end
        hold off
        legend(leng,'Interpreter','latex','Location','southeastoutside')
        legend('boxoff')
        saveas(gca,['F:\Dropbox\[4] Cx predictor\figure\graph\Graph_path_len_s' num2str(s) '_cl' num2str(cl) 'r'],'png')
        close
    end
end