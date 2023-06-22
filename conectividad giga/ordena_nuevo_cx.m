% Ordenar conectividad de los sujetos para todo el tiempo calculado.
% Para organizar la conectividad de los sujetos
function [Cx]=ordena_nuevo_cx(Cx_all)
Cx = cell(1,numel(Cx_all));
for cl = 1:numel(Cx_all)
    pos = 0;
    for time_ = 1:numel(Cx_all{cl})
        for fr = 1: size(Cx_all{cl}{time_},3)
            for v = 1: size(Cx_all{cl}{time_},4)
                if time_ == 1
                    Cx{cl}(:,:,fr,v) = Cx_all{cl}{time_}(:,:,fr,v);
                else
                    Cx{cl}(:,:,fr,pos+v) = Cx_all{cl}{time_}(:,:,fr,v);
                end
            end
        end
        pos = pos+v;
    end
end