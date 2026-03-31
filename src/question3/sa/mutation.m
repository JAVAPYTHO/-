function [mued_popu]=mutation(popu,PM,Area)
new_popu={};
for nind=1:size(popu,2)
    if rand<PM %如果要变异
        indi = popu{1,nind};
        r_d=randi([1 7]); %随便选择一年
        r_T=randi([1 82]); %随便选择一个耕地
        new_indi = indi;
        for i=1:41
            r=rand;
            if r<0.5
                if r_T>54
                    L = r_T-28;
                else
                    L = r_T;
                end
                new_indi{1,r_d}(r_T,i)=Area(L,2)*rand(); %随机增加
            elseif r>0.8
                new_indi{1,r_d}(r_T,i)=0;%随机归0
            end
        end
        [fixed_new_indi]=myFix(new_indi,Area); %修复不可行解
        num=size(new_popu,2);
        new_popu{1,num+1} = fixed_new_indi;
    end
end
mued_popu=[popu new_popu];
end