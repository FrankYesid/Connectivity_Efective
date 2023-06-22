SS = 1:52;
SS([29,34]) = [];
for s = SS
    
    load(['F:\graph\graph_s',num2str(s),'_2.mat'])
    load(['F:\graph\graph_s',num2str(s),'.mat'],'clustering','global_eff','path_len')
    clustering2 = clustering; clear clustering
    clustering = cell(2,1);
    for cl = 1:numel(clustering2)
        for freq = 1:size(clustering2{1},2)
            for v = 1:size(clustering2{1},3)
                clustering{cl}(freq,v) = mean(clustering2{cl}(:,freq,v));
            end
        end
    end
    clear clustering2
    
    local_eff2 = local_eff; clear local_eff
    local_eff = cell(2,1);
    for cl = 1:numel(local_eff2)
        for freq = 1:size(local_eff2{1},2)
            for v = 1:size(local_eff2{1},3)
                local_eff{cl}(freq,v) = mean(local_eff2{cl}(:,freq,v));
            end
        end
    end
    clear local_eff2
    
    global_eff2 = global_eff; clear global_eff
    global_eff = cell(2,1);
    for cl = 1:numel(global_eff2)
        for freq = 1:size(global_eff2{1},2)
            for v = 1:size(global_eff2{1},3)
                global_eff{cl}(freq,v) = global_eff2{cl}(:,freq,v);
            end
        end
    end
    clear local_eff2
    
    path_len2 = path_len; clear path_len
    path_len = cell(2,1);
    for cl = 1:numel(path_len2)
        for freq = 1:size(path_len2{1},2)
            for v = 1:size(path_len2{1},3)
                path_len{cl}(freq,v) = path_len2{cl}(:,freq,v);
            end
        end
    end
    clear local_eff2
    
    save(['F:\graph_Giga_s',num2str(s),'.mat'],'clustering','global_eff','local_eff','path_len')
end