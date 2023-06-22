function Mi = MiPeEn(x,y,order)

Pxy = zeros(factorial(order),factorial(order));
xy = [x y];
temp =[];
for i = 1:factorial(order)
    temp = [temp;repmat(i,factorial(order),1)];
end
PxySymbols = [repmat([1:factorial(order)]',factorial(order),1),temp];
for i = 1:size(PxySymbols,1)
    [x,y]=ind2sub(size(Pxy),i);
    Pxy(x,y) = sum(sum(PxySymbols(i,:) - xy == 0,2)==2);
end
%% Normalizar la fdp conjunta
Pxy = Pxy/sum(Pxy(:));
%% marginalizar Pxy
Px = sum(Pxy,2);
Py = sum(Pxy,1)';
PPxy = Px*Py';
%% Mutual information
Mi = sum(reshape(Pxy.*log(Pxy./((PPxy)+eps)+eps),[],1));
%%

