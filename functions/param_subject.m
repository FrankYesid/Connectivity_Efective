function Param_Subject = param_subject(acc,threshold,param,al,al2)
if nargin ==  2
    [val,ind] = max(reshape(squeeze(nanmean(acc,1)),[],1));
    Param_Subject = [threshold(ind),val*100,nanstd(acc(:,ind))*100];
elseif nargin == 3
    [val,ind] = max(reshape(squeeze(nanmean(acc,1)),[],1));
    [G_thresh,G_lam]=ind2sub([size(acc,2),size(acc,3)],ind);
    Param_Subject = [threshold(G_thresh),param(G_lam),val*100,nanstd(acc(:,G_thresh,G_lam))*100];
elseif nargin == 4
    [val,ind] = max(reshape(squeeze(nanmean(acc,1)),[],1));
    [a,b,c]=ind2sub([size(acc,2),size(acc,3),size(acc,4)],ind);
    Param_Subject = [threshold(a),param(b),al(c),val*100,nanstd(acc(:,a,b,c))*100];    
elseif nargin == 5
    [val,ind] = max(reshape(squeeze(nanmean(acc,1)),[],1));
    [a,b,c,d]=ind2sub([size(acc,2),size(acc,3),size(acc,4),size(acc,5)],ind);
    Param_Subject = [threshold(a),param(b),al(c),al2(d),val*100,nanstd(acc(:,a,b,c,d))*100];  
end