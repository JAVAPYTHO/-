function [indi]=myFix(indi,Area)
indi = fix4(indi); %作物分散限制
indi = fix3(indi); %三年豆类修复
indi = fix1(indi);
%若某块水浇地在某一年中种植了水稻，则将第一季设为种植的数量，第二季设置为0
%若不满足种植地限制约束，则将不满足约束的删去
indi = fix2(indi); %重茬修复
indi = fix5(indi,Area); %最小面积限制
indi = fix6(indi,Area); %最大面积限制

end

%% 三年豆类修复
function indi = fix3(indi)
set = [1 2 3 4 5 17 18 19]; %豆类集合

for L=1:82 % 遍历每块地
    con = 0;
    for year = 1:size(indi,2)
        flag = 0;
        for j=1:size(set,2) % 遍历每个豆
            p=set(j);
            if indi{1,year}(L,p)~=0
                con = 0;
                flag = 1;
                break % 找到了就听
            end
        end
        if flag ==1 %找到了就跳过这块地
            break
        else %没找到
            con = con +1;
            if con==3
                indi{1,year}(L,randi([1,5])) = 10;
                con=0;
            end
        end
    end

end

end
%% 修复1~6
function indi = fix1(indi)
for year = 1:size(indi,2)
    set = indi{1,year};
    for i=27:34 %若某块水浇地在某一年中种植了水稻，则将第一季设为种植的数量，第二季设置为0
        if set(i,16)~=0 %如果种了水稻
            set(i+28,16) = 0; %第二季强制赋0
        end
    end
    for i=1:26 %若不满足平旱地、梯田和山坡地种植地限制约束，则将不满足约束的删去
        for j=16:41 %遍历所有非法植物
            set(i,j) = 0; %强制赋0
        end
    end
    % 判断水浇地第一季是否合法
    for i=27:34
        for j=1:15
            set(i,j) = 0; %强制赋0
        end
        for j=35:41
            set(i,j) = 0; %强制赋0
        end
    end
    % 判断普通大棚第一季是否合法
    for i=35:50
        for j=1:15
            set(i,j) = 0; %强制赋0
        end
        for j=35:41
            set(i,j) = 0; %强制赋0
        end
    end
    % 判断智慧大棚第一第二季是否合法
    for i=51:54
        for j=1:15
            set(i,j) = 0; %强制赋0
        end
        for j=35:41
            set(i,j) = 0; %强制赋0
        end
    end
    for i=79:82
        for j=1:15
            set(i,j) = 0; %强制赋0
        end
        for j=35:41
            set(i,j) = 0; %强制赋0
        end
    end
    % 判断水浇地第二季是否合法
    for i=55:62
        for j=1:34
            set(i,j) = 0; %强制赋0
        end
        for j=38:41
            set(i,j) = 0; %强制赋0
        end
    end
    % 判断普通大鹏第二季是否合法
    for i=63:37
        for j=1:34
            set(i,j) = 0; %强制赋0
        end
    end
    indi{1,year} = set;
end
end
%% 重茬修复
function indi = fix2(indi)
for l=1:82
    for p=1:41
        temp = indi{1,1}(l,p);
        for year = 2:size(indi,2)
            if indi{1,year}(l,p)~=0 && indi{1,year}(l,p)==temp
                indi{1,year}(l,p) = 0;
            end
        end
    end

end

end
%% 作物分散限制
function indi = fix4(indi)
for year = 1:size(indi,2)
    for p = 1:41
        nonZeroCount = sum(indi{1,year}(:,p) ~= 0);
        if nonZeroCount>5
            nonZeroIndices = find(indi{1,year}(:,p));  % 找到所有非零元素的索引
            indicesToConvert = randsample(nonZeroIndices, nonZeroCount-5);  % 从非零元素中随机选择n个索引
            indi{1,year}(indicesToConvert,p) = 0;  % 将选定的非零元素变成0
        end
    end
end
end
%% 最小面积限制
function indi = fix5(indi,Area)
for year = 1:size(indi,2)
    for ii=1:82
        if ii>54
            L = ii-28;
        else
            L = ii;
        end
        % 假设要操作的元胞数组为 indi，year 为年份，ii 为索引
        threshold = 5;  % 设定非零值的阈值

        % 获取当前元胞的非零值个数
        nonZeroCount = nnz(indi{1,year}(ii,:));

        if nonZeroCount > threshold
            nonZeroIndices = find(indi{1,year}(ii,:));  % 找到所有非零元素的索引
            numNonZero = nonZeroCount - threshold;  % 需要将多余的非零值变为0的个数

            indicesToConvert = randsample(nonZeroIndices, numNonZero);  % 从非零元素中随机选择需要变为0的索引
            indi{1,year}(ii,indicesToConvert) = 0;  % 将选定的非零元素变为0
        end
        for p=1:41
            if indi{1,year}(ii,p)~=0 && indi{1,year}(ii,p)<Area(L,2)*0.2
                indi{1,year}(ii,p) = Area(L,2)*0.2;
            end
        end
    end
end

end
%% 最大面积限制
function indi = fix6(indi,Area)
for year = 1:size(indi,2)
    for ii=1:82
        if ii>54
            L = ii-28;
        else
            L = ii;
        end
        SS = sum(indi{1,year}(ii,:));
        if SS>Area(L,2) %超出最大限制了
            E = SS-Area(L,2);
            nonZeroIndices = indi{1,year}(ii,:) ~= 0;  % 找到所有非零元素的索引
            nonZeroValues = indi{1,year}(ii,nonZeroIndices);  % 获取所有非零值
            scalingFactor = nonZeroValues / sum(nonZeroValues);  % 计算每个非零值在总和中的比例
            indi{1,year}(ii,nonZeroIndices) = indi{1,year}(ii,nonZeroIndices) - E * scalingFactor;  % 对非零值进行按比例
        end
    end
end
end

