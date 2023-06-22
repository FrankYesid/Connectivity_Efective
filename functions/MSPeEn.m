function [MPE,CODE] = MSPeEn(X,m,t,Scale)

%  Calculate the Multiscale Permutation Entropy (MPE)

%  Input:   X: time series;
%           m: order of permuation entropy
%           t: delay time of permuation entropy,
%           Scale: the scale factor

% Output:
%           MPE: multiscale permuation entropy
%           CODE: señal codificada
%Ref: G Ouyang, J Li, X Liu, X Li, Dynamic Characteristics of Absence EEG Recordings with Multiscale Permutation %     %                             Entropy Analysis, Epilepsy Research, doi: 10.1016/j.eplepsyres.2012.11.003
%     G Ouyang, C Dang, X Li, Complexity Analysis of EEG Data with Multiscale Permutation Entropy, Advances in %       %                      Cognitive Neurodynamics (II), 2011, pp 741-745


MPE=zeros(Scale,factorial(m));
CODE = cell(Scale,1);
for j=1:Scale
    Xs = Multi(X,j);
    [MPE(j,:),CODE{j}]= pec(Xs,m,t);
end
end
function M_Data = Multi(Data,S)
L = length(Data);
J = fix(L/S);
for i=1:J
    M_Data(i) = mean(Data((i-1)*S+1:i*S));
end
end
%% PeEn
function [hist,code] = pec(y,m,t)
%  Calculate the permutation entropy
%  Input:   y: time series;
%           m: order of permuation entropy
%           t: delay time of permuation entropy,
% Output:
%           hist:  the histogram for the order distribution
ly = length(y);
permlist = perms(1:m);
c(1:length(permlist))=0;
for j=1:ly-t*(m-1)
    [~,iv]=sort(y(j:t:j+t*(m-1)));
    for jj=1:length(permlist)
        if (abs(permlist(jj,:)-iv))==0
            c(jj) = c(jj) + 1 ;
            code(j) = jj;
        end
    end
end
hist = c;
end

