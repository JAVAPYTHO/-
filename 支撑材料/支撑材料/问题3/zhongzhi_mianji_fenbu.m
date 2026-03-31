clc;
clear;
close all;

load("popu_mode1.mat");
set = popu{1,1};

lables = {'A1','A2','A3','A4','A5','A6','B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','B11','B12','B13','B14','C1','C2','C3','C4','C5','C6','D1','D2','D3','D4','D5','D6','D7','D8','E1','E2','E3','E4','E5','E6','E7'};
YEAR = [2024,2025,2026,2027,2027,2029,2030];

figure; % 创建一个新图形窗口  
for year = 1:7 % 遍历每年  
    temp_V = sum(set{1, year},2);
    V =   temp_V(1:54,1);
    V = V(27:54,1)+temp_V(55:end,1);
    
    % 找到非零值的索引   
    nonZeroIdx = V > 0;  
    
    % 提取非零值用于绘制条形图  
    sorted_V_nonzero = sort(V(nonZeroIdx), 'descend');  
    sorted_V_indices = find(nonZeroIdx); % 获取非零值在原V中的索引
    
    % 使用subplot创建子图  
    subplot(3, 3, year);  
    
    % 绘制条形图
    b = bar(sorted_V_nonzero);  % 绘制非零值的条形图
    
    % 应用红色渐变
    numBars = length(sorted_V_nonzero);  % 获取条形图的条数
    cmap = [ones(numBars, 1), linspace(0.3, 0, numBars)', linspace(0.3, 0, numBars)']; % 渐变的红色从浅到深
    for k = 1:numBars
        b.FaceColor = 'flat';
        b.CData(k, :) = cmap(k, :);  % 设置每个条形的颜色为红色渐变
    end
    
    % 设置子图的标题和标签
    title(sprintf('%d年', YEAR(year)));  
    xlabel('土地编号', 'FontSize', 8);  
    ylabel('种植面积', 'FontSize', 15);  
    
    % 设置xticks和xticklabels  
    xticks(1:length(sorted_V_nonzero));  
    sorted_lables_nonzero = lables(nonZeroIdx);  
    sorted_lables_nonzero = sorted_lables_nonzero(1:length(sorted_V_nonzero));  
    xticklabels(sorted_lables_nonzero);  
    
    % 旋转x轴标签以避免重叠  
    xtickangle(45);  
end  

% 为整个图形窗口设置总标题（可选）
sgtitle('各年作物种植面积分布');
