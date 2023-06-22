function [ lambda ] = KSVM_QP( K, y , C )

%     labels = unique(y);
%     y2 = ones(size(y));
%     y2(y==labels(2))=-1;
%     y=y2;
    H = (y*y').*K;
    f = -ones(size(y,1),1);
    Aeq = y';
    beq= 0;
    lb = zeros(size(y,1),1);
    ub = C*ones(size(y,1),1);

    options = optimoptions(@quadprog,'Display','off');

    lambda = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],options);



end

