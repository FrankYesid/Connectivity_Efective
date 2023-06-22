clear; clc; close all
% función para graficar la conectividad por medio de los sujetos
% SS = [3,14,43,50,48,15,10,5,19,28,27,18];
% Sujetos seleccionados.
SS = [14,49,9];
load F:\Dropbox\ERD\Codes\Topoplots\Gigasc\pos_struct_giga.mat
load F:\Dropbox\ERD\Codes\Topoplots\HeadModel.mat
% SS([29,34]) = [];
% ma_ = max(cell2mat(cellfun(@(y) cell2mat(cellfun(@(x) cell2mat(x),y,'UniformOutput',false)),mma,'UniformOutput',false)));
% mi_ = min(cell2mat(cellfun(@(y) cell2mat(cellfun(@(x) cell2mat(x),y,'UniformOutput',false)),mmi,'UniformOutput',false)));
vt = [{15:28},{46:58},{67:71},{94:105},{118:131}];
mi_ = 10.0447;%47.8857;
ma_ = 765.1821;%4.4407;%113.880;
va = [67:71];
um = 0.3;
a= 1;
for s = SS
    for clas = 1:2
        %% Alpha 8-12 and beta 12-16
        for freq = 1:2
            if freq == 1
                f1 = 3; f2 = 5;
            elseif freq == 2
                f1 = 5; f2 = 7;
            end
            % ventanas que corresponden a la actividad neuronal.
            v1 = 67; v2 = 117;            
            % load conectividad funcional.
            load(['L:\conectividad_efectiva2020\Cx_granger_giga_all_time_0_7_sub',num2str(s),'.mat'])
            % Ordeno la conectividad del sujeto.
            %             [Cx]=ordena_nuevo_cx(Cx_all);
            % calculo la mascara de los sujetos
            %             [mk1,mk2,mk3,mk4] = mask_frank(Cx);
            b = 1;
            for v = 1:numel(vt)%v1:11:v2
                % promedio la conectividad en las frecuencias que corresponde la
                % banda de interes.
                Cx_ = squeeze(mean(abs(Cx{clas}(:,:,f1:f2,:)),3));
                % promedio las ventanas en la imaginación motora.
                tem = mean(squeeze(Cx_(:,:,vt{v})),3);
                Cx_1 = threshold_proportional(tem,um);
                %             if clas == 1
                %                 if freq == 1
                %                     mk = mk1;
                %                 else
                %                     mk = mk3;
                %                 end
                %             elseif clas == 2
                %                 if freq == 1
                %                     mk = mk2;
                %                 else
                %                     mk = mk4;
                %                 end
                %             end
                %             % Aplicar la mascara.                
                rel = strengths_dir(Cx_1);%sum(squareform(Cx_1.*mk));
                % Carga la posición de los canales de giga.
                 
                rel = ((rel-mi_)/(ma_-mi_));%.*0.4;
%                 mma{a}{clas}{freq}(v) = max(rel); 
%                 mmi{a}{clas}{freq}(v) = min(rel(rel~=0));
                %% parametros de conectividad topoplot
                sel    = 1:64;
                t_e    = 20;
                lims   = [0,1]; 
                tex    = 0;                
                cur    = 0;
                ticks  = 1;
                GS     = 500;
                type   = 0;
                Color  = 'parula';
%                                 figure;
                fnc_MyTopo_giga(rel,sel,M1,lims,cur,ticks,t_e,HeadModel,type,tex,Color,GS)
%                 %                 saveas(gca,['D:\Dropbox\ERD\Conectividad funcional\Conectividad Giga\Resultado_pru_gc\Cx_ventana\eps\Cx_s_',num2str(s),'_cl_',num2str(clas),'_fr_',num2str(freq),'_V_',num2str(v)],'eps')
                saveas(gca,['F:\Dropbox\[5] IOP DynamicGroupCx\figure\funcional_e\5Cx_sub_',num2str(s),'_cl_',num2str(clas),'_fr_',num2str(freq),'_V_',num2str(va(b))],'png')
                b = b+1;
%                 % matlab2tikz(['G:\Dropbox\ERD\Conectividad funcional\Conectividad Giga\Resultado_pru_gc\mask\tex\Cx_sub_',num2str(s),'_cl_',num2str(clas),'_fr_',num2str(freq),'tikz'])
                close
            end
        end
    end
    a = a+1;
end