clc
clear
% This file is the main code of SFER for heterogeneous unsupervised domain
% adaptation written by Feng Liu et al.. You could replace datasets with
% yours. If you use this code, please cite following paper:
% -------------------------------
% Liu, F., Lu, J. and Zhang, G., 2018. Unsupervised Heterogeneous Domain 
% Adaptation via Shared Fuzzy Equivalence Relations. IEEE Transactions on 
% Fuzzy Systems, 26(6), pp.3555-3568.
% -------------------------------
% If you have any questions, please contact with me: feng.liu.1990@ieee.org

load('german data.mat')
load('Cancer_dataset.mat')
load('Australian.mat')
rng(1)
is_auto_select_alpha = 1; % select alpha automatically (1) or manually (0)
AA = [0.1 0.3 0.5 0.7 0.9]; % cadidate alpha
Num = [20,50,100,150,200]; % number of instances in the target domain
for ii = 1:5
    % select alpha automatically (1) or manually (0)
    if is_auto_select_alpha==1
       len_iter = 1;
    else
       len_iter = length(AA);
    end
    for iter = 1:len_iter
        % Randomly generate data
        Source_data = RandomSelect(Cancer_O,2,200);%RandomSelect(AUS_data,2,200);%
        Target_data = RandomSelect(Cancer_D,2,Num(ii));%RandomSelect(G_data,2,Num(ii));%
        % Data pre-processing
        S = Source_data(:,1:end-1);
        T = Target_data(:,1:end-1);
        mS = mapminmax(S',0,1)';
        mT = mapminmax(T',0,1)';
        dataS = mapminmax(S,0,1)';
        dataT = mapminmax(T,0,1)';
        ns = size(Source_data,2)-1;
        nt = size(Target_data,2)-1;
        KK = min([ns nt])-1;
        % Get the best \rho_s and \rho_t using grad
        [ps,pt,Error] = GradDe(dataS,dataT,1000);
        % Check the results
        [error1(iter),RS,RT] = fitness_F(dataS,dataT,[ps pt]);
        % Automatically select alpha
        Urs = unique(RS);
        Urt = unique(RT);
        Int_l=[0;max([Urs(1:KK-1) Urt(1:KK-1)]')'];% min(Urs(1:KK-1))
        Int_u=[min([Urs(1:KK-1) Urt(1:KK-1)]')';1];
        Int_minus = Int_u-Int_l; [~,maxIndex] = max(Int_minus);
        if is_auto_select_alpha==1
            ALPHA(iter) = 0.5*(Int_u(maxIndex)+Int_l(maxIndex));
        else
            ALPHA(iter) = AA(ii);
        end
        % Transfer knowledge from source data to target data
        y0(:,iter) = adaptiveP(Source_data,Target_data,dataS,dataT,ps,pt,mS,mT,ALPHA(iter));
        y_True(:,iter) = Target_data(:,end);
        % Accuracy on the target domain
        acc(ii,iter) = sum(y0(:,iter)==y_True(:,iter))./length(y_True(:,iter));

    end
    y0_cell{ii} = y0; y0 = [];
    y_True_cell{ii} = y_True; y_True = [];
end
