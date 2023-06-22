function outdata = MSPE2_noFB(x,order,delay,scale)
outdata = cell(scale,1);
for ch = 1:size(x,2)
    [~,temp] = MSPeEn(x(:,ch)',order,delay,scale);
    for sc = 1:scale
        outdata{sc} = [outdata{sc} temp{sc}'];
    end
end
outdata = outdata';