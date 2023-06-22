% function [Ktr,Kts,sigma]=gaussKernel(Xtr,Xts)
function [Ktr,sigma]=gaussKernel(Xtr,Xts)
% Xtr data 1, Xts = data 2
sigma_  = median([Xtr Xts]);
Ktr     = exp(-((pdist2(Xtr,Xts)).^2)/(2*sigma_^2));
