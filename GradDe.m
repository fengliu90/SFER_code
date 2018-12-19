function [ps,pt,Error] = GradDe(dataS,dataT,maxN)
[nnS,~] = size(dataS);
[nnT,~] = size(dataT);
ppS = pdist(dataS,'cityblock');
ppT = pdist(dataT,'cityblock');
sigma = 16;
nl = min([nnS nnT]);
ps = unifrnd(min(ppS),median(ppS),1,nnS);pt = unifrnd(min(ppT),median(ppT),1,nnT);
ita = 0.5;
for k = 1:maxN
    fprintf('Completed  %d  %% ...', uint8(k*100/maxN ))
    [RS0,~] = Fuzzy_Relate_Matrix(dataS,ps);
    [RT0,~] = Fuzzy_Relate_Matrix(dataT,pt);
    [Error(k),RS,RT] = fitness_F(dataS,dataT,[ps pt]);
    Urs = unique(RS);
    Urt = unique(RT);
    for m = 1:nl-1
        is(m) = floor(find(Urs(m)==RS0,1)/nnS)+1;
        js(m) = mod(find(Urs(m)==RS0,1),nnS);
        if js(m)==0
            is(m) = is(m) - 1;
            js(m) = nnS;
        end
        ps(is(m)) = ps(is(m)) - ita * 2*(Urs(m)-Urt(m))*-1*(abs(ps(is(m))-ps(js(m)))/(2*sigma))*Urs(m)*sign(ps(is(m))-ps(js(m)));
        ps(js(m)) = ps(js(m)) - ita * 2*(Urs(m)-Urt(m))*-1*(abs(ps(is(m))-ps(js(m)))/(2*sigma))*Urs(m)*(-1)*sign(ps(is(m))-ps(js(m)));
        it(m) = floor(find(Urt(m)==RT0,1)/nnT)+1;
        jt(m) = mod(find(Urt(m)==RT0,1),nnT);
        if jt(m)==0
            it(m) = it(m) - 1;
            jt(m) = nnT;
        end
        pt(it(m)) = pt(it(m)) - ita *(-2)*(Urs(m)-Urt(m))*-1*(abs(pt(it(m))-pt(jt(m)))/(2*sigma))*Urt(m)*sign(pt(it(m))-pt(jt(m)));
        pt(jt(m)) = pt(jt(m)) - ita *(-2)*(Urs(m)-Urt(m))*-1*(abs(pt(it(m))-pt(jt(m)))/(2*sigma))*Urt(m)*(-1)*sign(pt(it(m))-pt(jt(m)));
    end
    clc
end
