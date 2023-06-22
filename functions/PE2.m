function outdata = PE2(x,order,delay,alpha)
outdata = zeros(size(x,2),size(x,3),factorial(order));
for b = 1:size(x,2)
    parfor ch = 1:size(x,3)
        outdata(b,ch,:) = pec(x(:,b,ch)',order,delay,alpha);
    end
end