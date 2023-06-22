function KL = KLPeEn(x,y,order)
Px = zeros(factorial(order),1);
Py = zeros(factorial(order),1);
for i = 1:factorial(order)
    Px(i) = sum(x == i);
    Py(i) = sum(y == i);
end
Px = Px/sum(Px);
Py = Py/sum(Py);
KL = -sum(Px.*log((Py./(Px+eps))+eps));

%% Jeffreys divergence: (KL simetrica)
Dl = (Px-Py).*(log(Px+eps)-log(Py+eps));