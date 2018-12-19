function [error,RS,RT] = fitness_F(dataS,dataT,P)
% Cost function J_1 in the paper
[nnS,~] = size(dataS);
[nnT,~] = size(dataT);
ps = P(1:nnS);pt = P(nnS+1:nnS+nnT);
[RS,~] = Fuzzy_Relate_Matrix(dataS,ps);
[RT,~] = Fuzzy_Relate_Matrix(dataT,pt);
for i = 1:ceil(log2(nnS))
    RS = fuzzy_matrix_times(RS,RS);
end
for i = 1:ceil(log2(nnT))
    RT = fuzzy_matrix_times(RT,RT);
end
Urs = unique(RS);
Urt = unique(RT);
nl = min([length(Urs) length(Urt)]);
error = sum(abs(Urs(1:nl-1) - Urt(1:nl-1)).^2);