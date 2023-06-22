function [ y ] = predict_SVM( lambda, D, Dtest, ytrain,  numsv, tr )
% lambda: se calcula con SVM_QP
% D: caracteristicas de train (trial x features)
% Dtest: caracteristicas de test (trial x features)
% numsv: SV o ALL
    switch nargin
        case 5
            tr = 1e-10;
    end
        
    switch numsv
        case 'All'
            
            b = mean(ytrain-((D*D')*((lambda.*ytrain))));
            y = sign((Dtest*D')*(lambda.*ytrain)+b);
            
        case 'SV'
            
            sv = D(lambda>tr,:);
            lam = lambda(lambda>tr);
            ytr = ytrain(lambda>tr);
            
            b = mean(ytr-((sv*sv')*((lam.*ytr))));
            y = sign((Dtest*sv')*(lam.*ytr)+b);
    end
    
end

