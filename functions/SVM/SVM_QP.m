function [ lambda ] = SVM_QP( X, y , C )
% y(y==0)=-1;

labels = unique(y);
y2 = ones(size(y));
y2(y==labels(2))=-1;
y=y2;
H = (y*y').*(X*X');
f = -ones(size(y,1),1);
Aeq = y';
beq= 0;
lb = zeros(size(y,1),1);
ub = C*ones(size(y,1),1);

options = optimoptions(@quadprog,'Display','off');

lambda = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],options);

% 
% H = (y*y').*(X*X');
% f = -ones(size(y,1),1);
% Aeq = y';
% beq= 0;
% lb = zeros(size(y,1),1);
% 
% ub = C*ones(size(y,1),1);
% 
% lambda = quadprog(H,f,[],[],Aeq,beq,lb,ub);




end

