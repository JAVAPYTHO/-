function [croed_popu]=crossover(popu,PC,Area)
new_popu={};
for nind=1:size(popu,2)/2
    if rand<PC %如果要交叉
        indi1=popu{1,2*nind-1};
        indi2=popu{1,2*nind};
        r_d=randi([1 7]); %随便选择一年
        r_T=randi([1 82]); %随便选择一个耕地
        new_indi1=indi1;
        new_indi2=indi2;
        % 下面开始交换
        new_indi1{1,r_d}(r_T,:) = new_indi2{1,r_d}(r_T,:);
        new_indi2{1,r_d}(r_T,:) = indi1{1,r_d}(r_T,:);
        [fixed_new_indi1]=myFix(new_indi1,Area); %修复不可行解
        [fixed_new_indi2]=myFix(new_indi2,Area); %修复不可行解
        num=size(new_popu,2);
        new_popu{1,num+1} = fixed_new_indi1;
        new_popu{1,num+2} = fixed_new_indi2;
    end
end
croed_popu = [popu new_popu];
end