function outdata = PerEnt(x, delay, order, windowSize )
for b = 1:size(x,2)
    for ch = 1:size(x,3)
        outdata(:,b,ch) = PE( x(:,b,ch), delay, order, windowSize );
    end
end