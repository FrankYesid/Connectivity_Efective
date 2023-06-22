function [mu,Kt] = ckaweigthedK2(Kc,L,lambda)

Q = numel(Kc);
N = size(Kc{1},1);
U = eye(N)-(ones(N,1)*ones(1,N))*(1/N);
L = double(L);
L = U*L*U;
%compute kernels
for j = 1 : Q
    Kcc{j} = U*Kc{j}*U;
    a(j,1) = trace(Kcc{j}*L)/sqrt((trace(Kcc{j}*Kcc{j})*trace(L*L)));
end

for i = 1 : Q
    for j = 1 : Q
        if j >= i
           M(i,j) = trace(Kcc{i}*Kcc{j})/sqrt((trace(Kcc{j}*Kcc{j})*trace(Kcc{i}*Kcc{i})));
        else
            M(i,j) = M(j,i);
        end
    end
end

% sa = M\a;
% mua = sa/norm(sa);
%compute weights as QP for convex combination
H = M+lambda*eye(Q);
f = -2*a;
lb = zeros(size(f));
ub = ones(size(f));
Aeq = ones(1,Q);
%Aeq = [];
%beq = [];
beq = 1;
% x0 = a/sum(a);
mu = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],optimoptions('quadprog','Display','none'));

%mu = a;
%mu = [0,1,0],
% mu = abs(mu);
% mu = mu/norm(mu);
% mu = mu/sum(mu);
Kt = zeros(N);
for j = 1 : Q
   Kt =  Kt + mu(j)*Kc{j};
end



