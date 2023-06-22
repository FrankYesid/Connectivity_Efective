%% BASELINE CSP
%
%    El presente script pretende clasificar un problema de BCI por medio
%    del método CSP, el cual calcula la matriz de covariancia por
%    trials y con esta matriz se calcula la matriz de rotación de CSP y
%    se rotan los datos de train y test, luego se calcula el kernel de train y
%    test para el caso de kernel knn o se realiza LDA para la matriz de
%    datos de test rotada respecto al la matriz de rotación de CSP.
%    Se encuentra el acierto por cada sujeto.  

%Cantidad de vecinos.
nn = 3;

%Inicio y fin de los segundos de interes 3 al 6
%seg_start = 3*fs+1;
%seg_end   = 6*fs;

%Hz  inicio y fin de las frecuencias de interes
%f_low  = 4;
%f_high = 40;
f_low  = 8;
f_high = 30;
%Métodos de clasificación
clasificador = {'lda','kknn'};

% Crear matriz de aciertos donde se guardaran todos los resultados por
% fold, por sujeto y por tipo de clasificador
acc = zeros(cv{1}.NumTestSets,numel(X),numel(clasificador)); 

for s=1:numel(X)
    %Indices de las etiquetas de interes
    ind = ismember(y{s},labels);
    %Tomar solo las etiquetas de interes
    ys = y{s}(ind);
    fprintf('Subject %d... ',s)
    tic
    %Se crean celdas donde guardar las escalas y los kernels de train y test,
    % la forma es de cantidad de folds
    Ktr = cell(1,cv{1}.NumTestSets);
    Kts = cell(1,cv{1}.NumTestSets);
    sigma = zeros(1,cv{1}.NumTestSets);
    % Se realiza un filtro pasabanda según indiquen f_low y f_high
    Xs = fcnfiltband(X{s}(ind),double(fs),[f_low f_high],5);
    % Se crea una matrix donde se guardara la matrix de
    % covariancia de cada filtro
    C = cell(1,1,numel(Xs));
    for trial = 1:numel(Xs)        
        % Se computa la covariancia por cada trial.
        C{trial}=cov(Xs{trial}(seg_start:seg_end,:));
%         C{trial}=Xs{trial}(seg_start:seg_end,:)'*Xs{trial}(seg_start:seg_end,:);
        % Se normaliza la covariancia
        C{trial}=C{trial}/trace(C{trial});
    end
    C  = cell2mat(C);
    
    for f = 1:cv{s}.NumTestSets
        %             Se calculan los indices de los datos de train y test
        %             que cumplen con las etiquetas requeridas
        tr_ind   = cv{s}.training(f); tr_ind = tr_ind(ind);
        ts_ind   = cv{s}.test(f); ts_ind = ts_ind(ind);
        %             Se calcula la matriz de rotación por medio de CSP
        W        = csp_feats(C(:,:,tr_ind),ys(tr_ind),'train');
        %             Se rotan los datos dependiendo de la matriz de rotación
        %             de CSP.
        %             Xc contiene las características de CSP. Xc es una matríz del
        %             número de trial por el número de canales.
        Xc       = csp_feats(C,W,'test');
        Xc_test = Xc(ts_ind,:);
        ys_test = ys(ts_ind);
%         save(['csp_feats_' num2str(s) '_' num2str(f) '.mat'],'Xc_test','ys_test')
        % Se clasifica de dos maneras con un LDA y un kernel knn por lo
        % tanto se itera por el clasificador y segun sea el tipo se
        % clasifica y se hallan los aciertos.
        for c=1:numel(clasificador)
            switch clasificador{c}
                case 'lda'
                    % Entrenar modelo de clasificación usando muestras de
                    % entrenamiento.
                    mdl = fitcdiscr(Xc(tr_ind,:),ys(tr_ind));
                    % Clasificar muestras de test usando modelo entrenado.
                    acc(f,s,c) = mean(mdl.predict(Xc(ts_ind,:))==reshape(ys(ts_ind),[sum(ts_ind) 1]));                    
                case 'kknn'
                    % Se calculan los parámetros sigma y kernels de train y test
                    [Ktr{f},Kts{f},sigma(f)]=...
                        gaussKernel(Xc(tr_ind,:),Xc(ts_ind,:));
                    % Se calcula el acierto por cada fold, cada sujeto
                    acc(f,s,c) = kknn([],ys(tr_ind),Kts{f},reshape(ys(ts_ind),[sum(ts_ind) 1]),nn,'kernels');
            end
        end
    end
    t = toc;
    fprintf('Acc: %2.1f. Time: %f seconds\n',mean(acc(:,s,1))*100, t)
end
%Guardar los aciertos por sujetos y del clasificador de interés.
save CSP14 acc clasificador

macc=mean(acc);
sacc=std(acc);
mmacc = zeros(numel(X),1);
for s=1:numel(X); mmacc(s) = macc(1,s,1); end
msacc = zeros(numel(X),1);
for s=1:numel(X); msacc(s) = sacc(1,s,1); end
[mmacc*100 msacc*100]