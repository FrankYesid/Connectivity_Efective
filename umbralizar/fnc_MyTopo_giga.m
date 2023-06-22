% %% Function to graph the different topoplots of the database. %%
% MyTopo_fun(Y,sel,pos,label,lims,cur,ticks,t_e,database,HeadModel)
% rel       -   Vector of weights 1xN.
% pos       -   Positions vector Nx2.
% label     -   tag cell Nx1.
% lims      -   vector colorbar limits [min max].
% cur       -   boolean enables contour lines 1,0.
% ticks     -   ability to plot Boolean labels 1,0.
% t_e       -   size of the electrodes.
% database  -   selected database.
% HeadModel -   model of the human head.
% type      -   type of topoplot.
% tex       -   ability to plot labels of channels 1,0.
% Example:
%       database = 3;  Database of GigaScience.
%       database = 2;  Database of BCICIV_1.
%       load('BCICIV_1\electrodesBCICIV1.mat') % se encuentra la ubicacion de los electrodos y sus nombres.
%       load('HeadModel.mat')   % model of the head.
%       M1.xy = pos(:,1:2);     % posicion de los canales.
%       M1.lab = electrodes;    % nombre de los canales.
%       t_e = 200;
%       type = 1;
%       tex = 0;
%       MyTopo_fun(rel,sel,M1.xy,M1.lab,[min(rel) max(rel)],0,0,t_e,database,HeadModel,type,tex)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fnc_MyTopo_giga(rel,sel,M1,lims,cur,ticks,t_e,HeadModel,type,tex,Color,GS)
figure
[handle,Zi,grid,Xi,Yi] = topoplot(rel,M1,'maplimits','absmax','style','map','electrodes' ,'labels',    'headrad' ,0.65, 'plotrad',0.65,'gridscale',GS);
close;

xc = HeadModel(1,:);
yc = HeadModel(2,:);

 set(gcf,'position',[667   528   404   420])
 x1 = 0.02;     y1 = 0.06;     w = 0.95;      h = 0.92;
 subplot('position',[x1,y1,w,h]);
surf(Xi, Yi, zeros(size(Zi)), Zi,'EdgeColor', 'none', 'FaceColor', 'flat');hold on
view([-90 90])
plot(0.999.*xc'+0.0045,0.999'.*yc+0.005,'Color',[130,130,130]/255,'LineWidth',3) % cambié el tamaño del contorno
view([0 90])
axis square off
[tmpeloc labels Th Rd indices] = readlocs( M1);
[x,y]     = pol2cart(Th,Rd);

ELECTRODE_HEIGHT = 2.1;
% scatter(0.999.*x,0.999.*y,30,'b','filled')
% if ticks == 1
%     plot3(y,x,ones(size(x))*ELECTRODE_HEIGHT,...
%         '.','Color',[0,0,0],'markersize',t_e,'linewidth',1);
% end
% caxis([lims(1) lims(2)])
colormap(Color)
% if tex == 1
%     for i = 1:size(labels,1)
%         text(double(y(i)),double(x(i)),...
%             ELECTRODE_HEIGHT,labels(i,:),'HorizontalAlignment','center',...
%             'VerticalAlignment','middle','Color',[0,0,0],...
%             'FontSize',t_e)
%     end
% elseif tex == 2
%     for i = 1:size(labels,1)
%         text(double(y(i)),double(x(i)),...
%             ELECTRODE_HEIGHT,int2str(sel(i)),'HorizontalAlignment','center',...
%             'VerticalAlignment','middle','Color',[0,0,0],...
%             'FontSize',9)
%     end
% end