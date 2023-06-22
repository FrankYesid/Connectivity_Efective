function y = predict_KSVM( lambda, KD, KDtest, ytrain,  numsv, tr )
    
    switch nargin
        case 5
            tr = 1e-10;
    end
    
    switch numsv
        case 'SV'
            lam = lambda(lambda>tr);
            ytr = ytrain(lambda>tr);
            
            b = mean(ytr-((KD(lambda>tr,lambda>tr))*((lam.*ytr))));
            y = sign((KDtest(:,lambda>tr))*(lam.*ytr)+b);
            
        case 'All'
            b = mean(ytrain-((KD)*((lambda.*ytrain))));
            y = sign((KDtest)*(lambda.*ytrain)+b);
            
    end
            

end

