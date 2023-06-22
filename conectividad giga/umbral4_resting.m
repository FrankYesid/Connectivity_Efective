
clear; clc; close all;
% F. Zapata----------------------------------------------------------------
% addpath(genpath('G:\Dropbox\ERD\Codes\Topoplots\'));
addpath(genpath('D:\Toolbox\BCT'));
eeglab; close
addpath 'F:\Dropbox\ERD\Conectividad funcional\Conectividad Giga'
% load connectivity wPLI en BCICIV_2a
% load('F:\conectividad_funcional_Giga\wpli_giga.mat')

%% Initial parameters
% SS      = [43,14,50,3,41,23,4,35,48,1,6];
% umbral
um = 0.3;
% bands = [[1,3];[2,4];[3,5];[4,6];[5,7];[6,8];
%     [7,9];[8,10];S[9,11];[10,12];[11,13];[12,14];...
%     [13,15];[14,16];[15,17];[16,18];[17,19]];
% bands = [[3,4];[4,5];[5,6];[6,7];[7,8];[8,9]];
% bands = [[3,6];[6,9]];
% bands = [[3,5];[5,8];[8,11];[5,11]];

% Topoplot
% database = 3;
% type    = 4;
% tex      = 0;                                     % 1- activate names of channels, 0- deactivate names of channels.
% load('G:\Dropbox\ERD\Codes\Topoplots\Gigasc\pos_giga.mat')                    % loading ch labels.
% load('HeadModel.mat')                   % model of the head.
% t_e      = 15;                                  % size of electrodes.
% M1.xy = floor(M1.xyz(:,[1 2]).*100); % posicion de los canales.
% M1.xy(28,1) = -105;     % posicion de los canales.
% M1.xy(16,2) = M1.xy(53,2);
% M1.xy(28,1) = -10;
% M1.lab = M1.lab;        % nombre de los canales.
% Chan_centrals = [9,10,11,12,13,14,17,18,19,32,44,45,46,47,48,49,50,51,54,55,56];
% M1.xy = M1.xy(:,1:2); % position of electrodes.
% M1.lab= M1.lab;     % name of labels.
% sel       = 1:64;

% análisis de grafos.
% 'degree'
% 'strengths'
% 'distance'
% 'jdegree'
% clostering
Method= 'clostering';
load C_select_cx_motor.mat
% tipo de conectividad
% 'funtional'
% 'efective'
conect = 'efective';
channels_select = [9:14,17:19,32,44:51,54:56];
chan_ = zeros(64,1);
chan_(channels_select) = 1;
% umbralización de la conectividad.
% Cx = cell(52,1);
%  load('L:\results_2sec_5_8.mat')
% load('L:\results_2sec_4_13.mat')
% load('F:\funcional\results_2sec.mat')

% load('F:\funcional\results_2sec_64ch_bestsubj.mat')
% load('C:\Users\Lufe\Desktop\new_res\results_2sec_21ch_bestsubj_ranksum2.mat')
% load('C:\Users\Lufe\Desktop\new_res\results_2sec_64ch_bestsubj_ranksum2.mat')
% load('G:\Dropbox\ERD\Conectividad funcional\Conectividad Giga\Resultado_pru_gc\cx.mat')

% CCx_ = cell(1,2);
% for ve = 1:3
%     c1 = vent{ve}.c1;
%     c2 = vent{ve}.c2;
%     c3 = vent{ve}.c3;
%     c4 = vent{ve}.c4;
%
%     Cx_{1,1} = c1.cx; % alpha c1
%     Cx_{1,2} = c2.cx; % alpha c2
%     Cx_{2,1} = c3.cx; % betha c1
%     Cx_{2,2} = c4.cx; % betha c2
%
%     ind_{1,1} = c1.ind; % alpha c1
%     ind_{1,2} = c2.ind; % alpha c2
%     ind_{2,1} = c3.ind; % betha c1
%     ind_{2,2} = c4.ind; % betha c2
SS = [14,49,9];
% SS(29,34) = [];
v1 = 9; v2 = 44;
for s = SS
    % s = 3;
    %     load(['D:\Cx_wpli_giga_all_time_0_7_sub',num2str(s),'.mat'])
    load(['L:\conectividad_efectiva2020\Cx_granger_giga_rest_sub',num2str(s),'.mat'])
    Cx = Cx_all;
%     Cx = ordena_nuevo_cx(Cx_all);
    Cx{1}(isnan(Cx{1})) = 0;
%     Cx{2}(isnan(Cx{2})) = 0;
    for clas = 1
        %         X        = zeros(Ncx,Nfr,Nv);
        %         Xa      = zeros(Ncx,size(bands,1),Nv);
        %         CX_   = zeros(63,size(bands,1),Nv);
        %         for band = 1:size(bands,1)
        %             Xa(:,band,:) = mean(abs(wpli{s}{clas}.wplispctrm(:,[bands(band,1):bands(band,2)],:)),2);
        %         end
        %         for fr = 1:size(bands,1)
        %             for v = 1:Nv
        %     Xb = squareform(Xa(:,fr,v));
        %                 rele = Rel{s,clas}(1:6);
        %                 for ch1 = 1:21
        %                     for ch2 = 1:21
        %                         if ~isempty(find(rele == ch1))|| ~isempty(find(rele == ch2))
        %                             Xc(ch1,ch2) = Xb(ch1,ch2);
        %                         else
        %                             Xc(ch1,ch2) = 0;
        %                         end
        %                     end
        %                 end
        %             [posi(:,fr,v),dat]   = reorder_mod(Xb,sel);
        %             CX_(:,:,fr,v) = threshold_proportional(Xb,um);
        for freq = 1:2
            if freq == 1
                f1 = 3; f2 = 5;
            elseif freq == 2
                f1 = 5; f2 = 7;
            elseif freq == 3
                f1 = 7; f2 = 9;
            elseif  freq == 4
                f1 = 9; f2 = 11;
            elseif  freq == 5
                f1 = 11; f2 = 13;
            end
            Cx_1{clas}{freq} = squeeze(mean(mean(abs(Cx{clas}(:,:,f1:f2,:)),3),4));
%             for v =1:size(Cx{clas},4)% [1,4,8,11,14,17,20,24,27,30,33,36,40,43]%1:size(Cx_all{s}{clas},4)
                Cx_{clas}{freq} = threshold_proportional(squeeze(Cx_1{clas}{freq}),um);
                %         indd = zeros(size(Cx_,1),1)';
                %         indd(ind_{freq,clas}) = 1;
                %         CX_ = (Cx_{freq,clas}); %.*(indd');
                %         CX_ = squareform(Cx_);
                if strcmp(conect,'funtional')
                    if strcmp(Method,'degree')                            % degree
                        CCx_{clas}{freq}{v} = degrees_und(squeeze(Cx_{clas}{freq}(:,:,v)));
                    elseif strcmp(Method,'strengths')                  % strengths
                         tem__ = squeeze(Cx_{clas}{freq}(:,:,v));
                        tem__(logical(chan_),logical(chan_)) = 0;
                        CCx_{clas}{freq}{v} = strengths_und(tem__);
                        %                 elseif strcmp(Method,'distance')  % integration Distance and characteristic path length
                        %                     CCx_(:,fr,v) = distance_bin(CX_(:,:,fr,v));
                        %                 elseif strcmp(Method,'tem')  %
                        %                     CCx_(:,fr,v) = distance_bin(CX_(:,:,fr,v));
                    elseif strcmp(Method,'jdegree')
                        CCx_{clas}{freq}{v} = strengths_und(Cx_);
                    end
                elseif strcmp(conect,'efective')
                     if strcmp(Method,'degree')                            % degree
                    [~,~,CCx_{clas}{freq}{v}] = degrees_dir(CX_(:,:,v));
                elseif strcmp(Method,'strengths')                  % strengths
                    [~,CCx_{clas}{freq},~] = strengths_dir(Cx_{clas}{freq}.*C);
                elseif strcmp(Method,'clostering')                  % strengths
                    aa = clustering_coef_wd(Cx_{clas}{freq}.*C);
                    aa(isinf(aa))=0;
                    CCx_{clas}{freq} = aa;
                end
                end
%             end % window
            %   end % freqs
            %   Posicion{s}{clas} = posi;      % ch x fr x windows.
            %   Cx_{s}{clas}=CX_;               % ch x ch x fr x windows.
            %   Cx{clas}{freq}=CCx_;           % ch x fr x windows.
        end
    end % class
    % end
    % end
    
    %% load position
    load F:\Dropbox\ERD\Codes\Topoplots\Gigasc\pos_struct_giga.mat
    load F:\Dropbox\ERD\Codes\Topoplots\HeadModel.mat
    
    % parametros de  conectividad topoplot
    sel    = 1:64;
    t_e    = 20;
    lims   = [0,1];
    tex    = 0;
    cur    = 0;
    ticks  = 1;
    GS    = 500;
    type   = 0;
    Color = 'parula';
    
    % for vent = 53:5:103
%     Cx__ = cellfun(@(y) cellfun(@(x) mean(cell2mat(x')),y,'UniformOutput',false),CCx_,'UniformOutput',false);
    % Cx__ = cellfun(@(y) cellfun(@(x) mean(cell2mat(x(:,65:71)')),y,'UniformOutput',false),CCx_,'UniformOutput',false);
    
    %     % max and min con ventana promediada
    
    mma = max(max(cell2mat(cellfun(@(x) cell2mat(x), CCx_,'UniformOutput',false))));
    mmi = min(min(cell2mat(cellfun(@(x) cell2mat(x), CCx_,'UniformOutput',false))));
    
    % max and min con ventana independiente 67:71
    %         mma = max(cell2mat(cellfun(@(y) cell2mat(cellfun(@(x) cell2mat(x(60:80)), y,'UniformOutput',false)),CCx_,'UniformOutput',false)));
    %         mmi  = min (cell2mat(cellfun(@(y) cell2mat(cellfun(@(x) cell2mat(x(60:80)), y,'UniformOutput',false)),CCx_,'UniformOutput',false)));
    %     set(0,'DefaultFigureWindowStyle','docked')
    
    %% histogram
%     for clas = 1
%         for freq = 1:2
%             if freq == 1
%                 f1 = 3; f2 = 5;
%             elseif freq == 2
%                 f1 = 5; f2 = 7;
%             elseif freq == 3
%                 f1 = 7; f2 = 9;
%             elseif  freq == 4
%                 f1 = 9; f2 = 11;
%             elseif  freq == 5
%                 f1 = 11; f2 = 13;
%             end
%             figure;
%             set(gcf,'position',[667   528   404   420])
%             x1 = 0.065;     y1 = 0.05;     w = 0.9;      h = 0.92;
%             subplot('position',[x1,y1,w,h]);
%             %         Con = squeeze(mean(Cx{clas}(:,:,f1:f2,65:70),3));
%             %         for ven = 1:size(Con,3); Con_(:,ven) = squareform(Con(:,:,ven)); end;
%             histogram(abs(Cx__{clas}{freq}),8)
% %             xlim([6 13])
% %             ylim([0 33])
%             axis square
%             %         title(['Subject ' num2str(s) ' Class ' num2str(clas) ' Freq:8-12Hz'])
%             saveas(gca,['F:\Dropbox\[5] IOP DynamicGroupCx\figure\funcional_25_45\resting_histogram\Cx2_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(freq) '_V_' num2str(v)],'png')
%             close
%         end
%     end
    
    %% topoplots
    % set(0,'DefaultFigureWindowStyle','docked')
%     for clas = 1
%         for fr = 1:2
%             %         for v =  60:73%[1,4,8,11,14,17,20,24,27,30,33,36,40,43]
%             figure;
%             rel = (CCx_{clas}{fr}-mmi)./(mma-mmi);
%             %             rel = (CCx_{clas}{fr}{v}-mmi)./(mma-mmi);
%             rel(isnan(rel))=0;
%             fnc_MyTopo_giga(rel,sel,M1,lims,cur,ticks,t_e,HeadModel,type,tex,Color,GS)
%             %                           set(gcf,'position',[667   528   404   420])
%             %                         x1 = 0.02;     y1 = 0.06;     w = 0.95;      h = 0.92;
%             %                         subplot('position',[x1,y1,w,h]);
%             %             saveas(gca,['G:\Dropbox\ERD\Conectividad funcional\Conectividad Giga\Resultado_pru_gc\25_27\Cx_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(fr) '_V_' num2str(v)],'png')
%             %             close
%             %             saveas(gca,['F:\Dropbox\ERD\Conectividad funcional\Conectividad Giga\Resultado_pru_gc\25_45\head\Cx_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(fr) '_V_' num2str(v)],'png')
% %             saveas(gca,['F:\Dropbox\[5] IOP DynamicGroupCx\figure\funcional_25_45\resting_head\'...
% %                 'head2_Cx_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(fr) '_V_65_71' ...%num2str(v)...
% %                 ],'epsc')
%             saveas(gca,['F:\Dropbox\[5] IOP DynamicGroupCx\figure\funcional_25_45\resting_head_e\'...
%                 'head3_Cx_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(fr) '_V_65_71' ...% num2str(v)...
%                 ],'png')
%             close
%             %             end
%             % %         if clas == 1
%             % %             if fr == 1
%             % %                 text(-0.65,-0.2,'8-12 Hz','Interpreter','latex','Rotation',90,'FontSize',20)
%             % %             elseif fr ==2
%             % %                 text(-0.65,-0.2,'12-16 Hz','Interpreter','latex','Rotation',90,'FontSize',20)
%             % %             elseif fr == 3
%             % %                 text(-0.65,-0.2,'16-20 Hz','Interpreter','latex','Rotation',90,'FontSize',20)
%             % %             elseif fr == 4
%             % %                 text(-0.65,-0.2,'20-24 Hz','Interpreter','latex','Rotation',90,'FontSize',20)
%             % %             end
%             %         end
%         end
%     end
    % end
    % end
    
    %% Grafica de la matriz de conectividad-imag_fun_ult
%     
%     for clas = 1
%         for fr = 1:5
%             figure
%             set(gcf,'position',[567   328   404   420])
%             x1 = 0.06;     y1 = 0.06;     w = 0.92;      h = 0.92;
%             subplot('position',[x1,y1,w,h]);
%             imagesc(1:64,1:64,mean(Cx_1{clas}{freq}(:,:,v1:v2),3))
%             set(gca,'XTick',2:2:64,'XTickLabel',num2str([2:2:64]'),...
%                 'YTick',2:2:64,'YTickLabel',num2str([2:2:64]'),...
%                 'XTickLabelRotation',90,...
%                 'TickLabelInterpreter','latex','FontSize',8)
%             saveas(gca,['F:\Dropbox\[5] IOP DynamicGroupCx\figure\Imag_fun_ult\Cx_sin_umbral\'...
%                 'resting2_Cx_sin_thresholds_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(fr) '_V_65_71'...% num2str(v)...
%                 ],'epsc')
%             saveas(gca,['F:\Dropbox\[5] IOP DynamicGroupCx\figure\Imag_fun_ult\Cx_sin_umbral\'...
%                 'resting2_Cx_sin_thresholds_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(fr) '_V_65_71'...% num2str(v)...
%                 ],'png')
%             close
%             
%             figure
%             set(gcf,'position',[567   328   404   420])
%             x1 = 0.06;     y1 = 0.06;     w = 0.92;      h = 0.92;
%             subplot('position',[x1,y1,w,h]);
%             imagesc(1:64,1:64,mean(Cx_{clas}{freq}(:,:,v1:v2),3))
%             set(gca,'XTick',2:2:64,'XTickLabel',num2str([2:2:64]'),...
%                 'YTick',2:2:64,'YTickLabel',num2str([2:2:64]'),...
%                 'XTickLabelRotation',90,...
%                 'TickLabelInterpreter','latex','FontSize',8)
%             saveas(gca,['F:\Dropbox\[5] IOP DynamicGroupCx\figure\Imag_fun_ult\Cx_con_umbral\'...
%                 'resting2_Cx_con_thresholds_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(fr) '_V_65_71'...% num2str(v)...
%                 ],'epsc')
%             saveas(gca,['F:\Dropbox\[5] IOP DynamicGroupCx\figure\Imag_fun_ult\Cx_con_umbral\'...
%                 'resting2_Cx_con_thresholds_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(fr) '_V_65_71'...% num2str(v)...
%                 ],'png')
%             close
%             
%         end
%     end
    
    %% topoplot con los links
 pos_ = 1;
    for pos1 = 1:63
        for pos2 = pos1+1:64
            if pos1 ~= pos2
                chancmb(pos_,1) = pos2;
                chancmb(pos_,2) = pos1;
                pos_ = pos_ + 1;
            end
        end
    end
    %
    load F:\Dropbox\ERD\Codes\Topoplots\Gigasc\pos_struct_giga.mat
    %
    for clas = 1
        for freq = 1:2
            if freq == 1
                f1 = 3; f2 = 5;
            elseif freq == 2
                f1 = 5; f2 = 7;
            elseif freq == 3
                f1 = 7; f2 = 9;
            elseif  freq == 4
                f1 = 9; f2 = 11;
            elseif  freq == 5
                f1 = 11; f2 = 13;
            end
            Cx_l{clas}{freq} = squeeze(mean(mean(abs(Cx{clas}(:,:,f1:f2,v1:v2)),3),4));
        end
    end 
    v = 52;
    mma  = 28.9460;%max(max(cell2mat(cellfun(@(x) cell2mat(cellfun(@(y) y+y',x,'UniformOutput',false)),Cx_l,'UniformOutput',false)')))
    mmi  = min(min(cell2mat(cellfun(@(x) cell2mat(cellfun(@(y) y+y',x,'UniformOutput',false)),Cx_l,'UniformOutput',false)')));
    for clas = 1
        for freq = 1:2
            figure
            % Cx
             t_1 = (Cx_l{clas}{freq}+Cx_l{clas}{freq}'-mmi)./(mma-mmi);
            Cx_l2 = squareform(threshold_proportional(t_1,0.03));
            % Cx2
            %         Cx_l2 = squareform(threshold_absolute(squareform(Cx_l{clas}{freq}),0.03));
            C(1:size(C,1)+1:end)=0;
%             poss = Cx_l2.*squareform(C)>0; %sum(poss)
            poss = Cx_l2>0; sum(poss) 
            ds.connectStrength = (Cx_l2(poss)-mmi)./(mma-mmi);
            ds.connectStrengthLimits = [0 1];
            ds.chanPairs = chancmb(poss,:);
            set(gcf,'position',[660   528   415   418])
            x1 = 0.02;     y1 = 0.06;     w = 0.95;      h = 0.92;
            subplot('position',[x1,y1,w,h]);
            topoplot_connect(ds,M1)
            saveas(gca,['F:\Dropbox\[5] IOP DynamicGroupCx\figure'...
                '\funcional_25_45\resting_head_linked_e\Cx3_s_' num2str(s) '_cl_' num2str(clas) '_fr_' num2str(freq) '_V_' num2str(v)],'png')
            close
        end
    end
end
%
% clc

% 'F:\Dropbox\[5] IOP DynamicGroupCx\figure\Imag_fun_ult'