function Dl = DJPeEn(x,y,order)
Px = zeros(factorial(order),1);
Py = zeros(factorial(order),1);
for i = 1:factorial(order)
    Px(i) = sum(x == i);
    Py(i) = sum(y == i);
end
Px = Px/sum(Px);
Py = Py/sum(Py);

%% Jeffreys divergence: (KL simetrica)
Dl = sum((Px-Py).*(log(Px+eps)-log(Py+eps)));