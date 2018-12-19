function y0 = adaptiveP(Source_data,Target_data,dataS,dataT,ps,pt,mS,mT,ALPHA)
% Transfer knowledge from source data to target data using an easy way: zscore
[error1,RS,RT] = fitness_F(dataS,dataT,[ps pt]);
Urs = unique(RS);
Urt = unique(RT);
[error,ps,pt,ias,iat] = main_error(dataS,dataT,ALPHA,ps,pt);
if error ~= 0
    [~,mmi] = min(abs(Urt-ALPHA));
    ALPHA = max([Urs(mmi) Urt(mmi)])+0.00001;
    [error,ps,pt,ias,iat] = main_error(dataS,dataT,ALPHA,ps,pt);
end
N_c = max(ias);
for i = 1:N_c
    Fu_Fs(:,i) = sum(mS(:,ias==i),2);
    Fu_Ft(:,i) = sum(mT(:,iat==i),2);
end
Fu_Fs = zscore(Fu_Fs);Fu_Ft = zscore(Fu_Ft);
model0 = svmtrain(Source_data(:,end),Fu_Fs);
y0 = svmpredict(Target_data(:,end),Fu_Ft,model0);