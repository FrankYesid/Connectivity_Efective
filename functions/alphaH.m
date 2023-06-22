function Halpha =  alphaH(x,bins,alpha)
LimInf = -60;
LimSup = 60;
partition = linspace(LimInf,LimSup,bins);
codebook  = [1:1:length(partition)+1];

%Cuantizar X
for c =1:size(x,2)
    [~,quant] = quantiz(x(:,c),partition,codebook);
    Halpha(c) = RenyiMIToolbox('Entropy', alpha, quant'); %% Renyi's alpha entropy 
end



