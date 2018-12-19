function [error,ps,pt,ias,iat] = main_error(dataS,dataT,ALPHA,ps,pt)
% Check whether ALPHA will make dataS and dataT be clustered as different
% categories (see Fig. 2 in the paper)
[RS,ps] = Fuzzy_Relate_Matrix(dataS,ps);
[nnS,~] = size(dataS);
[nnT,~] = size(dataT);
for i = 1:ceil(log2(nnS))
    RS = fuzzy_matrix_times(RS,RS);
end
[RT,pt] = Fuzzy_Relate_Matrix(dataT,pt);
for i = 1:ceil(log2(nnT))
    RT = fuzzy_matrix_times(RT,RT);
end
AS = RS>ALPHA;[as,~,ias] = unique(AS,'rows');ys = size(as,1);
AT = RT>ALPHA;[at,~,iat] = unique(AT,'rows');yt = size(at,1);
error = abs(ys-yt);