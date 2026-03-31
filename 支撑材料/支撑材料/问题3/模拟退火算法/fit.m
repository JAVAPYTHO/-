function [OBJ]=fitness(popu,E,mode)
OBJ=[];
for nind = 1:size(popu,2)
    set = popu{1,nind};
    obj = [];
    for e=1:size(E,2) %轮询实验方案
        data = E{1,e};

        % 计算收入
        income = 0;
        outcome = 0;
        for year = 1:size(set,2) %遍历所有年份
            for s=1:2 %遍历每个季度
                for p=1:41 %遍历每种作物
                    % 提售价
                    if s==1 %第一季度，只统计两季的
                        price = data{1,year}(2,p);
                        % 提产量
                        V = 0; %该产量
                        if p>=17 && p<=34
                            for L=1:82 %遍历每块地
                                outcome = outcome + set{1,year}(L,p)*data{1,year}(4,p);
                                V = V + set{1,year}(L,p)*data{1,year}(5,p);
                            end
                        else
                            continue
                        end

                    else
                        price = data{1,year}(6,p);
                        % 提产量
                        V = 0; %该产量
                        if p<17||p>34 %都是第二季收获的
                            for L=1:82 %遍历每块地
                                outcome = outcome + set{1,year}(L,p)*data{1,year}(4,p);
                                V = V + set{1,year}(L,p)*data{1,year}(5,p);
                            end
                        else %要去掉第一季的
                            for L=55:82 %遍历每块地
                                outcome = outcome + set{1,year}(L,p)*data{1,year}(4,p);
                                V = V + set{1,year}(L,p)*data{1,year}(5,p);
                            end
                        end

                    end
                    % 计算两种模式下的收入
                    Ee = V - data{1,year}(3,p); %供销差距
                    if Ee<=0 %如果能全卖
                        income = income +  V*price;
                    else
                        if mode==1 %如果种多了且是模式1
                            income = income + data{1,year}(3,p)*price;
                        else %模式2
                            income = income + data{1,year}(3,p)*data{1,year}(2,p) + 0.5*Ee*price; %多余的半价
                        end
                    end

                end
            end

        end
        obj(e,1) = income - outcome;
    end
    OBJ(nind,1) = mean(obj);
    OBJ(nind,2) = min(obj);
end
end