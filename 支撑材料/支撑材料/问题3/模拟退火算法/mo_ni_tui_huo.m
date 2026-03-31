clc; clear; close all;

% 加载必要的数据
load('new_.mat');  % 加载必要的环境数据
load('obj_.mat');
load('orth.mat');
load('pop.mat');

% 参数设置
NIND = 100;  % 种群规模
T = 1000;  % 初始温度
T_min = 1;  % 最低温度
alpha = 0.95;  % 温度衰减系数
max_iter = 100;  % 每个温度的最大迭代次数
PM = 0.2;  % 变异概率
PC = 0.7;  % 交叉概率

% 初始化种群
popu = initialization(NIND, Area);  % 初始化种群

% 初始化最优解和最优目标值
best_solution = popu{1};
best_obj_value = -Inf;  % 初始最优目标值为负无穷大

%% 模拟退火主循环
while T > T_min
    for iter = 1:max_iter
        % 交叉和变异操作
        croed_popu = crossover(popu, PC, Area);  % 执行交叉操作
        mutated_popu = mutation(croed_popu, PM, Area);  % 执行变异操作
        
        % 适应度计算
        OBJ = fitness(mutated_popu, obj_record_mode1, 1);  % 使用模式1的适应度评估
        
        % 选择当前的最优个体
        [max_val, max_idx] = max(OBJ(:, 1));  % 寻找最大化的目标值个体
        current_solution = mutated_popu{max_idx};  % 当前最优解
        current_obj_value = max_val;  % 当前最优目标值
        
        % 模拟退火的接受准则
        if current_obj_value > best_obj_value || rand < exp((current_obj_value - best_obj_value) / T)
            best_solution = current_solution;  % 更新最优解
            best_obj_value = current_obj_value;  % 更新最优目标值
        end
        
        % 更新种群
        popu = mutated_popu;
    end
    
    % 降低温度
    T = T * alpha;
end

% 输出最终结果
fprintf('最佳解的目标值（利润）: %.2f\n', best_obj_value);
disp('最佳解:');
disp(best_solution);

%% 初始化函数
function [popu] = initialization(NIND, Area)
    popu = cell(1, NIND);
    for nind = 1:NIND
        indi = cell(1, 7);  % 初始化7年种植计划
        for j = 1:7
            indi{1, j} = zeros(82, 41);  % 82块地，41种作物
            for ii = 1:82
                if ii > 54
                    L = ii - 28;
                else
                    L = ii;
                end
                temp = randperm(41);  % 随机排列作物
                r = randi([1 5]);  % 随机选择作物数量
                p = temp(1:r);  % 选择种植作物
                x = rand(1, r);
                x = (x / sum(x)) * Area(L, 2);  % 按面积分配
                indi{1, j}(ii, p) = x;
            end
        end
        indi = myFix(indi, Area);  % 修复不可行解
        popu{1, nind} = indi;
    end
end

%% 交叉函数
function [croed_popu] = crossover(popu, PC, Area)
    new_popu = {};
    for nind = 1:floor(size(popu, 2) / 2)
        if rand < PC  % 满足交叉概率则交叉
            indi1 = popu{1, 2 * nind - 1};
            indi2 = popu{1, 2 * nind};
            r_d = randi([1 7]);  % 随机选择一年
            r_T = randi([1 82]);  % 随机选择一块地
            new_indi1 = indi1;
            new_indi2 = indi2;
            new_indi1{1, r_d}(r_T, :) = indi2{1, r_d}(r_T, :);
            new_indi2{1, r_d}(r_T, :) = indi1{1, r_d}(r_T, :);
            new_indi1 = myFix(new_indi1, Area);  % 修复不可行解
            new_indi2 = myFix(new_indi2, Area);
            new_popu{end + 1} = new_indi1;
            new_popu{end + 1} = new_indi2;
        end
    end
    croed_popu = [popu new_popu];
end

%% 变异函数
function [mued_popu] = mutation(popu, PM, Area)
    new_popu = {};
    for nind = 1:size(popu, 2)
        if rand < PM  % 满足变异概率则变异
            indi = popu{1, nind};
            r_d = randi([1 7]);  % 随机选择一年
            r_T = randi([1 82]);  % 随机选择一块地
            new_indi = indi;
            for i = 1:41
                if rand < 0.5
                    if r_T > 54
                        L = r_T - 28;
                    else
                        L = r_T;
                    end
                    new_indi{1, r_d}(r_T, i) = Area(L, 2) * rand();  % 随机变异
                elseif rand > 0.8
                    new_indi{1, r_d}(r_T, i) = 0;  % 清空某些作物
                end
            end
            new_indi = myFix(new_indi, Area);  % 修复变异后的个体
            new_popu{end + 1} = new_indi;
        end
    end
    mued_popu = [popu new_popu];
end

%% 适应度计算函数
function [OBJ] = fitness(popu, E, mode)
    OBJ = [];
    for nind = 1:size(popu, 2)
        set = popu{1, nind};
        obj = [];
        for e = 1:size(E, 2)  % 轮询实验方案
            data = E{1, e};
            income = 0;
            outcome = 0;
            for year = 1:size(set, 2)  % 遍历年份
                for s = 1:2  % 遍历季节
                    for p = 1:41  % 遍历作物
                        if s == 1  % 第一季作物
                            price = data{1, year}(2, p);
                            V = sum(set{1, year}(:, p)) * data{1, year}(5, p);
                        else  % 第二季作物
                            price = data{1, year}(6, p);
                            V = sum(set{1, year}(55:82, p)) * data{1, year}(5, p);
                        end
                        Ee = V - data{1, year}(3, p);  % 供需差距
                        if Ee <= 0
                            income = income + V * price;  % 全部售出
                        else
                            if mode == 1
                                income = income + data{1, year}(3, p) * price;
                            else
                                income = income + data{1, year}(3, p) * price + 0.5 * Ee * price;  % 供过于求部分半价处理
                            end
                        end
                    end
                end
            end
            obj(e, 1) = income - outcome;  % 计算净利润
        end
        OBJ(nind, 1) = mean(obj);  % 取平均净利润
        OBJ(nind, 2) = min(obj);  % 记录最小净利润
    end
end

%% 约束修复函数
function [indi] = myFix(indi, Area)
    indi = fix4(indi);  % 作物分散限制
    indi = fix3(indi);  % 三年豆类修复
    indi = fix1(indi);  % 修复作物种植限制
    indi = fix2(indi);  % 重茬修复
    indi = fix5(indi, Area);  % 最小面积限制
    indi = fix6(indi, Area);  % 最大面积限制
end

%% 最小面积限制修复函数
function indi = fix5(indi, Area)
    for year = 1:size(indi, 2)
        for ii = 1:82
            if ii > 54
                L = ii - 28;
            else
                L = ii;
            end
            % 获取每块地的非零作物面积
            nonZeroCount = nnz(indi{1, year}(ii, :));
            if nonZeroCount > 5  % 如果种植作物的种类超过5种
                nonZeroIndices = find(indi{1, year}(ii, :) ~= 0);
                indicesToConvert = randsample(nonZeroIndices, nonZeroCount - 5);
                indi{1, year}(ii, indicesToConvert) = 0;  % 将多余作物设为0
            end
            for p = 1:41
                if indi{1, year}(ii, p) ~= 0 && indi{1, year}(ii, p) < Area(L, 2) * 0.2
                    indi{1, year}(ii, p) = Area(L, 2) * 0.2;  % 保证作物面积不小于20%
                end
            end
        end
    end
end

%% 最大面积限制修复函数
function indi = fix6(indi, Area)
    for year = 1:size(indi, 2)
        for ii = 1:82
            if ii > 54
                L = ii - 28;
            else
                L = ii;
            end
            SS = sum(indi{1, year}(ii, :));  % 计算总面积
            if SS > Area(L, 2)  % 如果种植面积超过可用面积
                E = SS - Area(L, 2);
                nonZeroIndices = find(indi{1, year}(ii, :) ~= 0);  % 找到所有非零作物
                nonZeroValues = indi{1, year}(ii, nonZeroIndices);
                scalingFactor = nonZeroValues / sum(nonZeroValues);  % 计算比例因子
                indi{1, year}(ii, nonZeroIndices) = indi{1, year}(ii, nonZeroIndices) - E * scalingFactor;  % 按比例调整
            end
        end
    end
end

%% 三年豆类作物修复函数
function indi = fix3(indi)
    set = [1 2 3 4 5 17 18 19];  % 豆类作物集合
    for L = 1:82
        con = 0;
        for year = 1:size(indi, 2)
            flag = 0;
            for j = 1:numel(set)
                p = set(j);
                if indi{1, year}(L, p) ~= 0
                    con = 0;
                    flag = 1;
                    break;
                end
            end
            if flag == 1  % 如果找到豆类作物，跳过这块地
                break;
            else
                con = con + 1;
                if con == 3  % 如果连续3年没有种植豆类
                    indi{1, year}(L, randi([1, 5])) = 10;  % 强制种植豆类
                    con = 0;
                end
            end
        end
    end
end

%% 作物分散限制修复函数
function indi = fix4(indi)
    for year = 1:size(indi, 2)
        for p = 1:41
            nonZeroCount = sum(indi{1, year}(:, p) ~= 0);  % 非零作物数量
            if nonZeroCount > 5  % 如果种植超过5块地
                nonZeroIndices = find(indi{1, year}(:, p));  % 找到非零作物索引
                indicesToConvert = randsample(nonZeroIndices, nonZeroCount - 5);
                indi{1, year}(indicesToConvert, p) = 0;  % 将多余作物的种植面积设为0
            end
        end
    end
end

%% 重茬修复函数
function indi = fix2(indi)
    for l = 1:82
        for p = 1:41
            temp = indi{1, 1}(l, p);
            for year = 2:size(indi, 2)
                if indi{1, year}(l, p) ~= 0 && indi{1, year}(l, p) == temp
                    indi{1, year}(l, p) = 0;  % 防止连续种植同一种作物
                end
            end
        end
    end
end

%% 水稻和特殊地块的修复函数
function indi = fix1(indi)
    for year = 1:size(indi, 2)
        set = indi{1, year};
        % 水稻特殊修复
        for i = 27:34
            if set(i, 16) ~= 0  % 如果种了水稻
                set(i + 28, 16) = 0;  % 第二季强制设置为0
            end
        end
        % 非法作物修复
        for i = 1:26
            for j = 16:41
                set(i, j) = 0;  % 非法作物设置为0
            end
        end
        % 检查其他地块的合法性
        % （可以添加其他作物和地块的限制规则）
        indi{1, year} = set;
    end
end
