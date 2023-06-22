% F. Zapata----------------------------------------------------------------
addpath(genpath('G:\Dropbox\ERD\Codes\Topoplots\'));
addpath(genpath('F:\Toolbox\BCT'));
addpath(genpath('F:\Toolbox\circularGraph\'));
% load connectivity wPLI en BCICIV_2a
% load('F:\conectividad_efectiva_BCICIV_2a\granger_2a.mat')

%% Initial parameters
SS = [3];
% umbral
um = 0.5;
% bands = [[1,3];[2,4];[3,5];[4,6];[5,7];[6,8];
%     [7,9];[8,10];[9,11];[10,12];[11,13];[12,14];...
%     [13,15];[14,16];[15,17];[16,18];[17,19]];
% bands = [[3,5];[5,8];[8,11];[5,11]];
database = 2;
type    = 4;
tex      = 0;                                         % 1- activate names of channels, 0- deactivate names of channels.
load('electrodesBCICIV2a.mat')         % loading ch labels.
load('HeadModel.mat')                       % model of the head.
t_e      = 1;                                        % size of electrodes.
M1.xy  = elec_pos(:,1:2); % position of electrodes.
M1.lab = Channels;       % name of labels.
sel       = 1:22;
% 'degree'
% 'distance'
% ''
Method= 'strengths';
% orden_ch = [5,19,6,15,4,16,14,17,11,13,10,9,12,8,21,18,7,2,20,3,1];
%% umbralización de la conectividad.
Cx = cell(9,1);
for s = SS
    for clas = 1:2
        %         [Ncx1,Ncx,Nfr,Nv] = size(granger{s}{clas}.grangerspctrm);
        %         grang = abs(granger{s}{clas}.grangerspctrm);
        %  mmax = max(grang);
        %  X        = zeros(Ncx,Nfr,Nv);
        %  Xa      = zeros(Ncx,size(bands,1),Nv);
        %  CX_   = zeros(21,size(bands,1),Nv);
        %         for band = 1:size(bands,1)
        %             Xa(:,:,band,:) = mean(grang(:,:,[bands(band,1):bands(band,2)],:),3);
        %         end
        %         for fr = 1:size(bands,1)
        for fr = 1:2
            if fr == 1
                f1 = 3; f2 = 5;
            elseif fr == 2
                f1 = 5; f2 = 7;
            elseif fr == 3
                f1 = 7; f2 = 9;
            elseif  fr == 4
                f1 = 9; f2 = 11;
            elseif fr == 5
                f1 = 11; f2 = 13;
            elseif fr == 6
                f1 = 13; f2 = 15;
            end
            for v = 1:size(Cx_all{s}{clas},4)
                Cx_ = squeeze(mean(abs(Cx_all{s}{clas}(:,:,f1:f2,:)),3));
                %                 [posi(:,fr,v),dat]   = reorder_mod(Xa(:,:,fr,v),sel);
                %                 CX_(:,:,fr,v) = threshold_proportional(Xa(:,:,fr,v),um);
                if strcmp(Method,'degree')           % degree
                    CCx_(:,fr,v) = degrees_dir(CX_(:,:,fr,v));
                elseif strcmp(Method,'strengths')                  % strengths
                    CCx_{clas}{fr}{v} = strengths_und(squeeze(Cx_(:,:,v)));
                elseif strcmp(Method,'distance')  % integration Distance and characteristic path length
                    CCx_(:,fr,v) = distance_bin(CX_(:,:,fr,v));
                elseif strcmp(Method,'tem')  %
                    CCx_(:,fr,v) = distance_bin(CX_(:,:,fr,v));
                end
            end
        end
%         Posicion{s}{clas} = posi;  % ch x fr x windows.
%         Cx_{s}{clas}=CX_;           % ch x ch x fr x windows.
%         Cx{s}{clas}=CCx_;           % ch x fr x windows.
    end
end
% end
%%
% posiciones= [5 6 10 11 12 16 17 20 1 4 15 19 21 2 3 7 8 9 13 14 18];
% for s = SS
%     mma = max([max(Cx_{s}{1}(:)),max(Cx_{s}{2}(:))]);
%     for clas = 1:2
%         %         figure;
%         %         pos = 1;
%         for fr =  1:size(bands,1)%[3,7,9,11]
%             vv = [5 7 9 11 13];
%             for v = vv%1:size(Cx{s}{clas},3)
%                 %                 subplot(size(bands,1),numel(vv),pos)
%                 %                 subplot(4,numel(vv),pos)
%                 %                 pos = pos +1;
%                 set(gcf,'position',[667   528   404   420])
%                 x1 = 0.067;     y1 = 0.06;     w = 0.91;      h = 0.92;
%                 subplot('position',[x1,y1,w,h]);
%                 dataa = squeeze(Cx_{s}{clas}(:,:,fr,v));
%                 dataa =  reorden_se_matr(dataa,posiciones);
%                 %                 for ch = 1:size(dataa,1); dat_(ch,:) = dataa(Posicion{s}{clas}(ch,3,9),:); end;
%                 fig = imagesc(dataa./mma); axis square
%                 %                 axis square
%                 fig.Parent.XTick = 1:21;
%                 fig.Parent.XTickLabel =  M1.lab(posiciones);%num2str(squeeze(Posicion{s}{clas}(:,fr,v)));
%                 fig.Parent.YTick = 1:21;
%                 fig.Parent.YTickLabel = M1.lab(posiciones);% num2str(squeeze(Posicion{s}{clas}(:,fr,v)));
%                 fig.Parent.XTickLabelRotation = 90;
%                 fig.Parent.FontSize = 6;
%                 saveas(gcf,['F:\' ...
%                     'Connec_S' num2str(s) '_c' num2str(clas) '_fr' num2str(fr)  '_v' num2str(v) ...
%                     '_w' num2str(2000) 'msec' ],'epsc')
%                 close
%             end
%         end
%         %         suptitle(['Subject ',num2str(s),'Class ',num2str(clas)])
%         %          saveas(gcf,['F:\Conectividad_funcional_sub_',num2str(s),'_cl',num2str(clas)],'fig')
%         %          close
%     end
% end

%% Gráfica de topoplots.
Cx__ = cellfun(@(y) cellfun(@(x) mean(cell2mat(x')),y,'UniformOutput',false),CCx_,'UniformOutput',false);
% max and min con ventana promediada
mma = max( cell2mat(cellfun(@(x) cell2mat(x), Cx__,'UniformOutput',false)));
mmi  = min( cell2mat(cellfun(@(x) cell2mat(x), Cx__,'UniformOutput',false)));

for s = SS
%     mma = max([max(Cx{s}{1}(:)),max(Cx{s}{2}(:))]);
    for clas = 1:2
        %         figure;
        %         pos = 1;
        for fr = 1:2%size(bands,1)% [3,7,9,11]
            figure
            %             vv = [5 7 9 11 13];
            %             for v = vv% 1:size(Cx{s}{clas},3)
            %                 subplot(4,size(Cx{s}{clas},3),pos)
            %                 pos = pos +1;
            set(gcf,'position',[667   528   404   420])
            x1 = 0.02;     y1 = 0.06;     w = 0.95;      h = 0.92;
            subplot('position',[x1,y1,w,h]);
            Con = (Cx__{clas}{fr}-mmi)./(mma-mmi);
            %                 [~,Pop] = sort(Posicion{s}{clas}(:,fr,v));
            %                 Connec=squeeze(Cx{s}{clas}(:,fr,v))./mma;
            %                 for ch = 1:numel(Connec)
            %                     Con(ch) = Connec(Pop(ch));
            %                 end
            fnc_MyTopo22(Con,sel,M1.xy,M1.lab,[0,1],0,0,t_e,database,HeadModel,type,tex,colormap('parula'));
            %                 saveas(gcf,['F:\' ...
            %                     'head_S' num2str(s) '_c' num2str(clas) '_fr' num2str(fr)  '_v' num2str(v) ...
            %                     '_w' num2str(2000) 'msec' ],'epsc')
            %                 close
            %             end
              if clas == 1
                if fr == 1
                    text(-0.55,-0.2,'8-12 Hz','Interpreter','latex','Rotation',90,'FontSize',20)
                    text(-0.15,-0.6,'Class 1','Interpreter','latex','FontSize',20)
                elseif fr ==2
                    text(-0.55,-0.2,'12-16 Hz','Interpreter','latex','Rotation',90,'FontSize',20)
                elseif fr == 3
                    text(-0.55,-0.2,'16-20 Hz','Interpreter','latex','Rotation',90,'FontSize',20)
                elseif fr == 4
                    text(-0.55,-0.2,'20-24 Hz','Interpreter','latex','Rotation',90,'FontSize',20)
                end
            else
                if fr == 1
                   text(-0.15,-0.6,'Class 2','Interpreter','latex','FontSize',20)
                end
            end
        end
        %          suptitle(['Subject ',num2str(s),'Class ',num2str(clas)])
        %          saveas(gcf,['F:\Conectividad_funcional_sub_',num2str(s),'_cl',num2str(clas)],'fig')
        %          close
    end
end
clc

%% Gráfica circular
% myColorMap = colormap('parula');
% for s = SS
%     mma = max([max(Cx{s}{1}(:)),max(Cx{s}{2}(:))]);
%     for clas = 1:2
%         figure;
%         pos = 1;
%         for fr = 1:size(bands,1)% [3,7,9,11]
%             vv = [5 7 9 11 13];
%             for v = vv% 1:size(Cx{s}{clas},3)
%                 subplot(4,numel(vv),pos)
%                 pos = pos +1;
%                 %                 set(gcf,'position',[667   528   404   420])
%                 %                 x1 = 0.02;     y1 = 0.06;     w = 0.95;      h = 0.92;
%                 %                 subplot('position',[x1,y1,w,h]);
%                 %                 [~,Pop] = sort(Posicion{s}{clas}(:,fr,v));
%                 %                 Connec=squeeze(Cx{s}{clas}(:,fr,v))./mma;
%                 %                 for ch = 1:numel(Connec)
%                 %                     Con(ch) = Connec(Pop(ch));
%                 %                 end
%                 myLabel = cell(21);
%                 for i = 1:length(1:21)
%                     myLabel{i} = num2str(M1.lab{i});
%                 end
%                 circularGraph(squeeze(Cx_{s}{clas}(:,:,fr,v)),'Colormap',myColorMap,'Label',myLabel);
%                 %                 saveas(gcf,['F:\' ...
%                 %                     'head_S' num2str(s) '_c' num2str(clas) '_fr' num2str(fr)  '_v' num2str(v) ...
%                 %                     '_w' num2str(2000) 'msec' ],'epsc')
%                 %                 close
%             end
%         end
%         %          suptitle(['Subject ',num2str(s),'Class ',num2str(clas)])
%         %          saveas(gcf,['F:\Conectividad_funcional_sub_',num2str(s),'_cl',num2str(clas)],'fig')
%         %          close
%     end
% end
% clc
