% F. Zapata----------------------------------------------------------------
addpath(genpath('G:\Dropbox\ERD\Codes\Topoplots\'));
clear ; clc
% load connectivity wPLI en BCICIV_2a
load('F:\conectividad_efectiva_Giga\granger_giga.mat')

%% Initial parameters
SS = [43,17];
% umbral
um = 0.5;
% bands = [[1,3];[2,4];[3,5];[4,6];[5,7];[6,8];
%     [7,9];[8,10];[9,11];[10,12];[11,13];[12,14];...
%     [13,15];[14,16];[15,17];[16,18];[17,19]];
bands = [[3,5];[5,8];[8,11];[5,11]];
% umbral
um = 0.5;
database = 2;
type    = 4;
tex      = 0;                                     % 1- activate names of channels, 0- deactivate names of channels.
load('posiciones.mat')                    % loading ch labels.
load('HeadModel.mat')                   % model of the head.
t_e      = 15;                                  % size of electrodes.
M1.xy = M1.xy([1:47,49:end],1:2); % position of electrodes.
M1.lab= M1.lab([1:47,49:end]);     % name of labels.
sel       = 1:63;
% 'degree'
% 'distance'
% ''
Method= 'degree';

% umbralización de la conectividad.
Cx = cell(52,1);
for s = SS
    for clas = 1:2
        [Ncx,Ncx2,Nfr,Nv] = size(granger{s}{clas}.grangerspctrm);
        grang = abs(granger{s}{clas}.grangerspctrm);
%         mmax = max(abs(granger{s}{clas}.grangerspctrm(:)));
           %         X        = zeros(Ncx,Nfr,Nv);
        %         Xa      = zeros(Ncx,size(bands,1),Nv);
        %         CX_   = zeros(63,size(bands,1),Nv);
        for band = 1:size(bands,1)
            Xa(:,:,band,:) = mean(grang(:,:,[bands(band,1):bands(band,2)],:),3);
        end
        for fr = 1:size(bands,1)
            for v = 1:Nv
                [posi(:,fr,v),dat]   = reorder_mod(Xa(:,:,fr,v),sel);
                CX_(:,:,fr,v) = threshold_proportional(Xa(:,:,fr,v),um);
                if strcmp(Method,'degree')           % degree
                    CCx_(:,fr,v) = degrees_dir(CX_(:,:,fr,v));
                elseif strcmp(Method,'distance')  % integration Distance and characteristic path length
                    CCx_(:,fr,v) = distance_bin(CX_(:,:,fr,v));
                elseif strcmp(Method,'tem')  %
                    CCx_(:,fr,v) = distance_bin(CX_(:,:,fr,v));
                end
            end
        end
        Posicion{s}{clas} = posi;  % ch x fr x windows.
        Cx_{s}{clas}=CX_;           % ch x ch x fr x windows.
        Cx{s}{clas}=CCx_;           % ch x fr x windows.
    end
end

%% 
posiciones= [34 36 55 39 40 41 42 46 45 44 43 49 50 51 52 ...
                     56 55 54 53 57 58 59 60 61 63 62 64 33 37 38 ...
                     47 32 31 30 29 28  1   2   3   7   6   5   4   8  ...
                      9  10 11 15 14 13 12 16 17 18 19 24 23 22 21 ...
                     20 25 26 27];
 for posii = 1:numel(posiciones)
     if posiciones(posii) > 48
         posiciones(posii) = posiciones(posii)-1;
     end
 end
for s = SS
    mma = max([max(Cx_{s}{1}(:)),max(Cx_{s}{2}(:))]);
    for clas = 1:2
        %         figure;
        %         pos = 1;
        for  fr = 1:size(bands,1)%fr = [3,7,9,11]
            vv = [5 7 9 11 13];
            for v = vv%1:size(Cx{s}{clas},3)
                %  subplot(4,numel(vv),pos) %subplot(4,size(Cx{s}{clas},3),pos)
                %  pos = pos +1;
                set(gcf,'position',[667   528   404   420])
                x1 = 0.067;     y1 = 0.06;     w = 0.91;      h = 0.92;
                subplot('position',[x1,y1,w,h]);
                dataa = squeeze(Cx_{s}{clas}(:,:,fr,v));
                dataa =  reorden_se_matr(dataa,posiciones);
                fig = imagesc(dataa./mma);
                %  axis square
                fig.Parent.XTick = 1:63;
                fig.Parent.XTickLabel = M1.lab(posiciones);%num2str(squeeze(Posicion{s}{clas}(:,fr,v)));
                fig.Parent.YTick = 1:63;
                fig.Parent.YTickLabel = M1.lab(posiciones);%num2str(squeeze(Posicion{s}{clas}(:,fr,v)));
                fig.Parent.FontSize = 5;
                fig.Parent.XTickLabelRotation = 90;
                saveas(gcf,['F:\' ...
                    'Connec_S' num2str(s) '_c' num2str(clas) '_fr' num2str(fr)  '_v' num2str(v) ...
                    '_w' num2str(2000) 'msec' ],'epsc')
                close
            end
        end
        %  suptitle(['Subject ',num2str(s),'Class ',num2str(clas)])
        %  saveas(gcf,['F:\Conectividad_funcional_sub_',num2str(s),'_cl',num2str(clas)],'fig')
        %  close
    end
end
clc

%% Grafica de topoplots.
for s = SS
    mma = max([max(Cx{s}{1}(:)),max(Cx{s}{2}(:))]);
    for clas = 1:2
        figure;
        pos = 1;
        for fr = [3,7,9,11]
            for v = 1:size(Cx{s}{clas},3)
                subplot(4,size(Cx{s}{clas},3),pos)
                pos = pos +1;                
                %    set(gcf,'position',[667   528   404   420])
                %    x1 = 0.02;     y1 = 0.06;     w = 0.95;      h = 0.92;
                %    subplot('position',[x1,y1,w,h]);
                fnc_MyTopo22(squeeze(Cx{s}{clas}(:,fr,v))./mma,sel,M1.xy,M1.lab,[0,1],0,0,t_e,database,HeadModel,type,tex,colormap('parula'));
                %    saveas(gcf,['F:\' ...
                %                'head_S' num2str(s) '_c' num2str(cl) '_fr' num2str(fr)  '_v' num2str(v) ...
                %                '_w' num2str(2000) 'msec' ],'epsc')
                %                 close
            end
        end
    end
end