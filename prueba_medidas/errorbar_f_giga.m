%% error-bar
% Data to be plotted as a bar graph - Means
% model_series = [10 40 50 60; 20 50 60 70; 30 60 80 90];
% Data to be plotted as the error bars - Standar
% model_error = [1 4 8 6; 2 5 9 12; 3 6 10 13];
% Naming each of the bar groups
% Index = [1,2,3];
% Namer of the label y
% labelx = 'Accuracy';
% Namer of the label x
% labelx = 'Subjects';
% Legend of each group.
% leg = ['a','b','c'];
function errorbar_f_giga(model_series, model_error, index, labelx, labely, leg)
% Creating axes and the bar graph
figure
% conectividad
% set(gcf,'position',[10   528   1600   400])
% set(gcf,'position',[10   70   200   400]) 
% x1 = 0.095;     y1 = 0.15;     w = 0.9;      h = 0.75;
% x1 = 0.05;     y1 = 0.125;     w = 0.93;      h = 0.85;

% Frontiers
% set(gcf,'position',[667   528   404   310])
set(gcf,'position',[10   528   1700   400]) %frontiers
% x1 = 0.095;     y1 = 0.15;     w = 0.9;      h = 0.75; %frontiers 1
x1 = 0.04;     y1 = 0.14;     w = 0.94;      h = 0.75; %frontiers 2  %0.025
%x1 = 0.08;     y1 = 0.12;     w = 0.88;      h = 0.85;
subplot('position',[x1,y1,w,h]);
ax = gca;
h = bar(model_series,'BarWidth',0.5);
hold on
% line([23.5,23.5],[0,100],'Color','k','LineStyle','--')
col = [[0, 0.4470, 0.7410];[0.6350, 0.0780, 0.1840];[0.3010, 0.7450, 0.9330];[0.8500, 0.3250, 0.0980]];

% col = [[ 51 255 255];[102 178 255];[ 59 131 189];[  0  76 153]]./255;
% col = [[150 53 142];[109 169 200];[236 186 85];[174 195  73]]./255;
%col = [[150 53 142];[109 169 200];[236 186 85];[174 195  73]]./255;
% col = [[0.4660 0.6740 0.1880]; [ 0    0.4078    0.3412]; [0.3010 0.7450 0.9330];  [0 0.4470 0.7410]];
% col = [[36,48,94]./255;[0,0.4470,0.7410];[0.9290,0.6940,0.1250];[168,208,230]./255];
% col = [[36,48,94]./255;[168,208,230]./255;[244,151,108]./255;[251,232,166]./255];
for c = 1:size(model_series,2)
    h(c).FaceColor = col(c,:);
    h(c).EdgeColor = col(c,:);
end
 fig.YScale = 'log';
% h(4).FaceColor = [0/255,76/255,153/255];
% h(3).FaceColor = [0.54118,0.58431,0.59216];
% h(2).FaceColor = [0.02350,0.22350,0.44310];
% h(1).FaceColor = [0.52940,0.81180,0.92160];
% h(1).EdgeColor = [027/255,085/255,131/255];
% 
% h(4).EdgeColor = [0/255,76/255,153/255];
% h(3).EdgeColor = [0.54118,0.58431,0.59216];
% h(2).EdgeColor = [0.02350,0.22350,0.44310];
% h(1).EdgeColor = [0.52940,0.81180,0.92160];
% Set color for each bar face
% h(1).FaceColor = 'blue';
% h(2).FaceColor = 'yellow';
% Properties of the bar graph as required
ax.YGrid = 'off';
ax.GridLineStyle = '-';
xticks(ax,1:size(model_series,1));
% Naming each of the bar groups
index_ = num2cell(index);
% index_{size(model_series,1)}(1,:) = 'Mean';
clear  label_;
for su = 1:numel(index)
    if su < numel(index)+1
        label_{su} = ['S',num2str(index(su))];
    else
%         label_{su} = ['Mean'];
    end
end
xticklabels(ax, label_);
set(gca,'FontSize',12)

% Creating a legend and placing it outside the bar plot
lg = legend(leg,'AutoUpdate','off','Interpreter','latex');
lg.Location = 'northeast'; % 'BestOutside';
lg.Orientation = 'Horizontal';%
lg.Box = 'on';
lg.FontName = 'Latex';
lg.Position(2) = lg.Position(2)+0.09;
hold on;
% Finding the number of groups and the number of bars in each group
ngroups = size(model_series, 1);
nbars = size(model_series, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
Color = [0.54118,0.58431,0.59216];
% for i = 1:nbars
%     % Calculate center of each bar
%     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     errorbar(x, model_series(:,i), model_error(:,i), 'Color',Color, 'linestyle', 'none');
% end
ylim([50 100])
xlim([0.5 size(model_series,1)+0.5])
legend('boxoff')
ax.Box = 'off';
ax.TickLabelInterpreter = 'latex';
% X and Y labels
ylim([45 100]); %set(gca,'TickLength',[0.00, 0.0250],'YScale','log');
x_ = xlabel (labelx,'Interpreter','latex','FontSize',13);
y_ = ylabel (labely,'Interpreter','latex','FontSize',13);
%y_.Position(1) = y_.Position(1)+0.5;
%x_.Position(2) = x_.Position(2)+0.5;
end