function pe = PeEn_Renyi(hist,alpha)
%% c: es la fdp generada por PeEn
%% alpha: orden de la entropia
for b = 1:size(hist,1)
    for cnl = 1:size(hist,2)
        clear c;
        c = squeeze(hist(b,cnl,:));
        c=c(find(c~=0));
        p = c/sum(c);
        if alpha == 1
            % shannon
            pe(b,cnl) = -sum(p .* log(p));
        else
            % Permutation entropy Renyi
            pe(b,cnl) = 1/(1-alpha)*log(sum(p.^alpha));
        end
    end
end