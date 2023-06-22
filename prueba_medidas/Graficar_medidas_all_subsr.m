% Main figures, theory graphs
clear; clc
%
% [0.0238,0.2925]
minn = 0.0238;
maxx = 0.2925;
time = 0:0.0385:2;%0:0.0385:7;
t1 = 14;
t2 = 40;
Nfreq= 1:17;

SS = 1:52;
SS ([29,34]) = [];
a = 1;
for s = SS
    load(['D:\graph_s',num2str(s),'_2r.mat'])
    load(['D:\graph_s',num2str(s),'_3r.mat'])
    load(['D:\graph_s',num2str(s),'_4r.mat'])
    %     load('F:\Dropbox\graph_Giga_s43_5.mat')
    for cl = 1
        %         a = 1;
        %         b = 1;
        %         c = 1;
        %         d = 1;
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
        %         figure
        for fr = Nfreq
            % Medida
            %             hold on
            cluste{cl}{fr}(a,:) = mean(squeeze(clustering{cl}(:,fr,t1:t2)),1);
            %             ylim([0.02,0.14])
            %             ylim([0.02,0.20])
            %             leng{a} = ['fr',num2str(fr),'-cl',num2str(cl)];
            %             a = a+1;
        end
        
        %         hold off
        %         legend(leng,'Interpreter','latex','Location','southeastoutside') %'southeast')
        %         legend('boxoff')
        %         saveas(gca,['F:\Dropbox\[4] Cx predictor\figure\graph\Graph_clus_s' num2str(s) '_cl' num2str(cl) '_all'],'png')
        %         close
        
        
        
        
        % Medida
        %         figure
        for fr = Nfreq
            %             % Medida
            %             hold on
            glob{cl}{fr}(a,:) = squeeze(global_eff{cl}(1,fr,t1:t2));
            %             leng{b} = ['fr',num2str(fr),'-cl',num2str(cl)];
            %             b = b+1;
        end
        %         hold off
        %         legend(leng,'Interpreter','latex','Location','southeastoutside')
        %         legend('boxoff')
        %         saveas(gca,['F:\Dropbox\[4] Cx predictor\figure\graph\Graph_glo_ef_s' num2str(s) '_cl' num2str(cl) '_all'],'png')
        %         close
        
        % Medida
        %         figure
        %         for fr = Nfreq
        %             % Medida
        %             hold on
        %             plot(time(7:176),mean(squeeze(local_eff{cl}(:,fr,7:176)),1))
        % %             ylim([0.02,0.16])
        %             ylim([0.02,0.20])
        %             leng{c} = ['fr',num2str(fr),'-cl',num2str(cl)];
        %             c = c+1;
        %         end
        %         hold off
        %         legend(leng,'Interpreter','latex','Location','southeastoutside')
        %         legend('boxoff')
        %         saveas(gca,['F:\Dropbox\[4] Cx predictor\figure\graph\Graph_loc_ef_s' num2str(s) '_cl' num2str(cl) '_all'],'png')
        %         close
        
        % Medida
        %         figure
        for fr = Nfreq
            %             % Medida
            %             hold on
            pat{cl}{fr}(a,:) = squeeze(path_len{cl}(1,fr,t1:t2));
            %             leng{d} = ['fr',num2str(fr),'-cl',num2str(cl)];
            %             d = d+1;
        end
        %         hold off
        %         legend(leng,'Interpreter','latex','Location','southeastoutside')
        %         legend('boxoff')
        %         saveas(gca,['F:\Dropbox\[4] Cx predictor\figure\graph\Graph_path_len_s' num2str(s) '_cl' num2str(cl) '_all'],'png')
        %         close
    end
    a = a+1;
end
maxx = max(cell2mat(cellfun(@(x) max(max(cell2mat(x(:)))),cluste,'UniformOutput',false)));
minn = max(cell2mat(cellfun(@(x) min(min(cell2mat(x(:)))),cluste,'UniformOutput',false)));
for cl = 1
    for freq = Nfreq
        figure
        imagesc(time(t1:t2),SS,(cluste{cl}{freq}-minn)/(maxx-minn))
        saveas(gca,['D:\Dropbox\[4] Cx predictor\figure\graph\Graph_clus_s' num2str(cl) '_fr' num2str(freq) '_all_subs_R'],'png')
        close
    end
end

maxx = max(cell2mat(cellfun(@(x) max(max(cell2mat(x(:)))),glob,'UniformOutput',false)));
minn = max(cell2mat(cellfun(@(x) min(min(cell2mat(x(:)))),glob,'UniformOutput',false)));
for cl = 1
    for freq = Nfreq
        figure
        imagesc(time(t1:t2),SS,(glob{cl}{freq}-minn)/(maxx-minn))
        saveas(gca,['D:\Dropbox\[4] Cx predictor\figure\graph\Graph_glo_ef_s' num2str(cl) '_fr' num2str(freq) '_all_subs_R'],'png')
        close
    end
end

maxx = max(cell2mat(cellfun(@(x) max(max(cell2mat(x(:)))),pat,'UniformOutput',false)));
minn = max(cell2mat(cellfun(@(x) min(min(cell2mat(x(:)))),pat,'UniformOutput',false)));
for cl = 1
    for freq = Nfreq
        figure
        imagesc(time(t1:t2),SS,(pat{cl}{freq}-minn)/(maxx-minn))
        saveas(gca,['D:\Dropbox\[4] Cx predictor\figure\graph\Graph_path_len_cl' num2str(cl) '_fr' num2str(freq) '_all_subs_R'],'png')
        close
    end
end