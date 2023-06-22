function [K,S,dx_dalpha]=KStein(X,alpha,theta,T)
Xm = zeros(size(X));
%dx_dalpha = zeros(size(X,3),size(X,1),size(X,1),size(X,1));
switch T
    case 'c'
        for Trial=1:size(X,3)
            [Vec,Val] = eig(X(:,:,Trial));
            Xm(:,:,Trial) = Vec*diag(alpha.*diag(Val))*Vec';
%             for c=1:size(X,1)
%                 dx_dalpha(Trial,c,:,:) = Vec(:,c)*alpha(c)*Val(c,c).^(alpha(c)-1)*Vec(:,c)';
%             end
        end
    case 'p'
        for Trial=1:size(X,3)
            [Vec,Val] = eig(X(:,:,Trial));
            Xm(:,:,Trial) = Vec*diag(diag(Val).^alpha)*Vec';
%             for c=1:size(X,1)
%                 dx_dalpha(Trial,c,:,:) = Vec(:,c)*alpha(c)*Val(c,c).^(alpha(c)-1)*Vec(:,c)';
%             end
        end
    otherwise
        
end
S = zeros(size(X,3));
for i=1:size(X,3)
    for j=i+1:size(X,3)
        S(i,j) = log(det((Xm(:,:,i)+Xm(:,:,j))/2))-0.5*log(det(Xm(:,:,i)*Xm(:,:,j)));
        S(j,i)=S(i,j);
    end
end
K = exp(-theta*S);
end