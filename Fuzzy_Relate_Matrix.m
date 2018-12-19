function [R,p] = Fuzzy_Relate_Matrix(data,p)
% Generate fuzzy relation matrix from data
sigma = 16;
pp = pdist(data,'cityblock')./length(p);
R = exp(-((squareform(pp)+0.5*abs(p'*ones(1,length(p)) - ones(length(p),1)*p)))./(2*sigma));