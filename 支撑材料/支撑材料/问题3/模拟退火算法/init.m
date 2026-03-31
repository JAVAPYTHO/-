function [popu]=initialization(NIND,Area)
popu = cell(1,NIND);
for nind=1:NIND
    indi = cell(1,7); % 建立一个空解,7年
    for j=1:size(indi,2) %为每年生成解
        indi{1,j} = zeros(82,41);
        for ii=1:82 %为每个耕地，82个耕地
            if ii>54
                L = ii-28;
            else
                L = ii;
            end
            temp = randperm(41); %41种作物
            r = randi([1 5]); %要种植的作物数
            p = temp(1:r); %要种植的作物
            x = rand(1, r);
            x = (x / sum(x))*Area(L,2);
            indi{1,j}(ii,p)=x;
        end
    end
    [fixed_indi]=myFix(indi,Area); %修复不可行解
    popu{1,nind}=fixed_indi;
end
end