function data_S = RandomSelect(data,n,ns)
% Radomly select data
% n is the number of classifications
% ns is the numbers needed to select
data_S = [];
for  i = 1:n
    if min(data(:,end)) == 0
        len = sum(data(:,end) == i-1);
        if ns > len
            error(['The number of selected samples must be less than that of classification ',num2str(i-1)])
        end
        datai = data(data(:,end) == i-1,:);
        iiRand = randperm(len);
        data_S = [data_S;datai(iiRand(1:ns),:)];
    else
        len = sum(data(:,end) == i);
        if ns > len
            error(['The number of selected samples must be less than that of classification ',num2str(i)])
        end
        datai = data(data(:,end) == i,:);
        iiRand = randperm(len);
        data_S = [data_S;datai(iiRand(1:ns),:)];
    end
end
data_S = data_S(randperm(size(data_S,1)),:);
