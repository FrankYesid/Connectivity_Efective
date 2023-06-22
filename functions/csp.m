function [W,eigenvalues] = csp(Ca,Cb,cumvar,mode,K,Q)

if nargin<3
    cumvar=1;
end

if nargin<4
    mode=1;
end

if nargin<5
    K=zeros(size(Ca));
end

if nargin<6
    Q = 3;
end

switch mode    
    case 1        
        [V,~] = eig(Ca,Ca+Cb);
        W=V';
    case 2
        [V,~] = eig(Ca-Cb,Ca+Cb);
        W=V';
    case 3
        [V,~] = eig(Ca,Cb);
        W=V';
    case 4 %Implemented by Fabien Lotte
        %whitening transform of total covariance matrix
        covTotal = Ca + Cb + K;
        
        [Ut,Dt] = eig(covTotal); %caution: the eigenvalues are initially in increasing order
        eigenvalues = diag(Dt);
        [eigenvalues,egIndex] = sort(eigenvalues, 'descend');
        Ut = Ut(:,egIndex);
        P = diag(sqrt(1./eigenvalues)) * Ut';
        
        %transforming covariance matrix of first class using P
        transformedCov1 =  P * Ca * P';
        
        %EVD of the transformed covariance matrix
        [U1,D1] = eig(transformedCov1);
        eigenvalues = diag(D1);
        [eigenvalues,egIndex] = sort(eigenvalues, 'descend');
        U1 = U1(:, egIndex);
        W = U1' * P;
        W = W([1:Q end-Q+1:end],:);
        
    otherwise %includes 0
        Cc = Ca+Cb;
        [Uc,Dc] = eig(Cc);
        [p,ind] = sort(diag(Dc),'descend');
        Dc = p;
        Uc = Uc(:,ind);
        p = cumsum(p)/sum(p);
        ind = p<=cumvar;
        Wc = diag(Dc(ind).^(-1/2))*Uc(:,ind)';
        Sa = Wc*Ca*Wc';
        Sb = Wc*Cb*Wc';
        [Ua,Da] = eig(Sa-Sb);
        W = Ua'*Wc;
        [Da,ind] = sort(diag(Da));
        Da = diag(Da);
        W = W(ind,:);
        Db = W*Cb*W';
end
    

