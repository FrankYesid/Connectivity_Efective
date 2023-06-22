load means_acc_daniel.mat
S1 = 1:52;
S1([29,34]) = [];
means_ = Means_giga_(S1,1);
[~,pos_] = sort(means_,'descend');
stds  = Means_giga_(S1,2);
labelx = 'Subjtecs';
labely = 'Accuracy [$\%$]';
leg = [{'$\tau=2$'}];%,'$\tau=1.5$','$\tau = 1$','$\tau = 0.5$'}];
pos = S1(pos_);%SS(pos);
% errorbar_f_giga(means_(pos_),stds,pos, labelx, labely, leg)
for su = 1:numel(S1)
    label_{su} = ['S',num2str(S1(su))];
end
boxplot([means_'],'Notch','on','Labels',labely)%,'Labels',label_)

% x_ = xlabel (labelx,'Interpreter','latex','FontSize',15);
% set(gcf,'position',[50   528   1604   400])
fig = gca; fig.FontSize = 13; fig.TickLabelInterpreter = 'latex';

saveas(gca,['D:\Dropbox\[4] Cx predictor\figure' filesep 'Acc_giga2'],'png')
close


%%
clear;
SUBJECTS_DIR = 'C:\Users\frany\Desktop\acc_\';
COHORT = 'Data_acc_S';
SUBJECTS = dir([SUBJECTS_DIR filesep COHORT '*']);
SUBJECTS = struct2cell(SUBJECTS);
SUBJECTS = SUBJECTS(1,1:end-1)';
SS       = 1:numel(SUBJECTS);

for s = SS
    load(['C:\Users\frany\Desktop\acc_\',SUBJECTS{s}])
    a = str2num(SUBJECTS{s}(11:end-4));
    means(s,:) = Acc_;
%     means(a,1) = mean(Std_);
    S1(s) = a;
end
[S1_,pos_] = sort(S1);
boxplot(means(pos_,:)')%,'Labels',label_)
set(gca,'XTickLabel',num2str(S1_'),'TickLabelInterpreter','latex')
saveas(gca,['D:\Dropbox\[4] Cx predictor\figure' filesep 'Acc_giga3'],'png')
% means_ = means(:,1);
% [~,pos_] = sort(means_,'descend');
% stds  = means(:,2);
% labelx = 'Subjtecs';
% labely = 'Accuracy [$\%$]';
% 
% errorbar_f_giga(means_(pos_),stds,pos, labelx, labely, leg)