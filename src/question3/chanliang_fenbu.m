clc;
clear;
close all;

% 读取数据
data = xlsread('亩产表.xlsx');
load("popu_mode1.mat");

% 获取种群数据
set = popu{1,1};

% 定义作物标签
lables = {'黄豆','黑豆','红豆','绿豆','爬豆','小麦','玉米','谷子','高粱','黍子','荞麦','南瓜','红薯','莜麦','大麦','水稻','豇豆','刀豆','芸豆','土豆','西红柿','茄子','菠菜 ','青椒','菜花','包菜','油麦菜','小青菜','黄瓜','生菜 ','辣椒','空心菜','黄心菜','芹菜','大白菜','白萝卜','红萝卜','榆黄菇','香菇','白灵菇','羊肚菌'};

% 定义年份
YEAR = [2024,2025,2026,2027,2028,2029,2030];

% 创建一个新的图形窗口
figure; 

% 初始化每个作物的总产量矩阵
total_yield_per_crop = zeros(7, 41);

% 计算每年每个作物的产量
for year = 1:7 % 遍历每年
    for p = 1:41 % 遍历每种作物
        for L = 1:81 % 遍历每块地
            total_yield_per_crop(year, p) = total_yield_per_crop(year, p) + set{1, year}(L, p) * data(5, p);
        end
    end
end

% 找到非零值的索引
nonZeroIdx = any(total_yield_per_crop > 0, 1); % 任何年份产量大于0的作物

% 提取非零作物的标签
sorted_lables_nonzero = lables(nonZeroIdx);

% 提取非零作物的产量
sorted_yield_per_crop = total_yield_per_crop(:, nonZeroIdx);

% 绘制七个子图，每年一个子图
for year = 1:7
    subplot(3, 3, year); % 创建3x3的子图布局
    
    % 绘制当前年份的所有作物的产量变化
    plot(1:length(sorted_lables_nonzero), sorted_yield_per_crop(year, :), '-o', 'LineWidth', 1.5); 
    
    % 添加标题和轴标签
    title(sprintf('%d年作物产量变化', YEAR(year)));
    xlabel('作物', 'FontSize', 8); 
    ylabel('产量', 'FontSize', 12);
    
    % 设置x轴标签
    xticks(1:length(sorted_lables_nonzero));
    xticklabels(sorted_lables_nonzero);
    xtickangle(45); % 旋转x轴标签避免重叠
    
    hold off; % 结束当前子图的绘制
end

% 为整个图形窗口设置总标题（可选）
sgtitle('各年作物产量变化');
