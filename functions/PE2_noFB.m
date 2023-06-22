function outdata = PE2_noFB(x,order,delay,alpha)
% outdata = zeros(size(x,2),factorial(order));
for ch = 1:size(x,2)
    [~,outdata(ch,:)] = pec(x(:,ch)',order,delay,alpha);
end
outdata = outdata';