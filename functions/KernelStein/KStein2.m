function [S]=KStein2(X,beta,norm)
S = zeros(size(X,3),size(X,3));
if nargin == 2 
    for i=1:size(X,3)
        for j=i+1:size(X,3)
            S(i,j) = (det(X(:,:,i))^beta*det(X(:,:,j))^beta)/(det((X(:,:,i)+X(:,:,j))/2)^beta);
            S(j,i)=S(i,j);
        end
    end
elseif nargin == 3
    for i=1:size(X,3)
        for j=i+1:size(X,3)
            S(i,j) = (det(X(:,:,i))^beta/2*det(X(:,:,j))^beta/2)/(det((X(:,:,i)+X(:,:,j))/2)^beta);
            S(j,i)=S(i,j);
        end
    end
end
