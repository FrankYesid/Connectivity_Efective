function S=KSteinCoeff(X,alpha)

X=alpha*X;
S = zeros(size(X,3));
for i=1:size(X,3)    
    for j=i+1:size(X,3)
        S(i,j) = log(det((X(:,:,i)+X(:,:,j))/2))-0.5*log(det(X(:,:,i)*X(:,:,j)));
        S(j,i)=S(i,j);
    end
end