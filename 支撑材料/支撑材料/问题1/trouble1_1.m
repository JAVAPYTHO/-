clc;clear;close all;
data=readtable("附件2_处理后.xlsx","Sheet","2023年统计的相关数据");
data1=readtable("附件2_处理后.xlsx","Sheet","2023年的农作物种植情况");
data_get_all=(table2array(data(:,6:9)));
data_get_all(end-2:end,:)=[];
%% 计算每种农作物种植一亩地可能会带来的收益
price_mean1=mean(data_get_all(:,3:4),2);
data_str=table2array(data(1:125,3));
data_str1=table2array(data(1:125,4));
data_str1_2=table2array(data(1:125,5)); %记录季节

for i=1:length(data_str1)
    data_str2{i,1}=[data_str{i,1},'-',data_str1{i,1}];
        if strcmp(data_str1_2{i,1},'第二季')
          str_get1='2';
        else
          str_get1='1';  
        end
    if strcmp(data_str1{i,1},'平旱地')
        str_get='A';
    elseif strcmp(data_str1{i,1},'梯田')==1
        str_get='B';
    elseif strcmp(data_str1{i,1},'山坡地')==1
        str_get='C';    
    elseif strcmp(data_str1{i,1},'水浇地')==1
        str_get='D';  
    elseif strcmp(data_str1{i,1},'普通大棚')==1   
        str_get='E';  
     elseif strcmp(data_str1{i,1},'智慧大棚')==1   
        str_get='F';  
    end

    data_str3{i,1}=[data_str{i,1},'-',str_get,str_get1];
end
%%

shouyi_mean=data_get_all(:,1).*price_mean1-data_get_all(:,2);

shouyi_high=data_get_all(:,1).*data_get_all(:,4)-data_get_all(:,2);

shouyi_low=data_get_all(:,1).*data_get_all(:,3)-data_get_all(:,2);
%%
[sort_shouyi_mean_value,sort_shouyi_mean_index]=sort(shouyi_mean,'descend');

%%  以结果导向
data_result=readtable('result1_1.xlsx','VariableNamingRule','preserve');

data_result(83:86,:)=[];
%% 总体种植利润计算每个植物在每亩的（平均利润）
data_price_result1_mat=[];
data_price_result1_mat_chengben=[];
data_result1=data_result;
data_result1(:,1)=[];
for i=1:size(data_result1,1)
    for j=1:size(data_result1,2)-1
% for i=1
%     for j=1
          str_get1=table2array(data_result1(i,1));
          str_get2=str_get1{1,1}(1);
          str_get3=data_result1.Properties.VariableNames(j+1);
          if i>=55
              str4='2';
          else
              str4='1';
          end
          str_get=[str_get3{1},'-',str_get2,str4];
          index=find(ismember(data_str3,str_get)==1);
          if ~isempty(index)
              data_price_result1_mat(i,j)=shouyi_mean(index(1));
              data_price_result1_mat_chengben(i,j)=data_get_all(index(1),2);
          else
              data_price_result1_mat(i,j)=0;      
              data_price_result1_mat_chengben(i,j)=0;
          end
    end
end

%%

data_str23=table2array(data1(:,3));

data_str23_1=table2array(data1(:,1));

data_str23_1_2=table2array(data1(:,6)); %记录季节

canliang_mean1=table2array(data1(:,5));
%%
for i=1:length(data_str23_1)

        if strcmp(data_str23_1_2{i,1},'第二季')
          str_get1='2';
        else
          str_get1='1';  
        end
        if length(data_str23_1{i,1})~=0
            str_get=data_str23_1{i,1};
        elseif length(data_str23_1{i-1,1})~=0
            str_get=data_str23_1{i-1,1};
        elseif length(data_str23_1{i-2,1})~=0
            str_get=data_str23_1{i-2,1};           
        elseif length(data_str23_1{i-3,1})~=0
            str_get=data_str23_1{i-3,1};       
        elseif length(data_str23_1{i-4,1})~=0
            str_get=data_str23_1{i-4,1};                 
        end

    data_str23_3{i,1}=[data_str23{i,1},'-',str_get,str_get1];
end
%% 2023年种植情况统计
data_result1=data_result;
data_result1(:,1)=[];
for i=1:size(data_result1,1)
    for j=1:size(data_result1,2)-1
% for i=1
%     for j=1
          str_get1=table2array(data_result1(i,1));
          str_get2=str_get1{1,1};
          str_get3=data_result1.Properties.VariableNames(j+1);
          if i>=55
              str4='2';
          else
              str4='1';
          end
          str_get=[str_get3{1},'-',str_get2,str4];
          index=find(ismember(data_str23_3,str_get)==1);
          if ~isempty(index)
              data_price_result1_mat1(i,j)=canliang_mean1(index(1));
          else
              data_price_result1_mat1(i,j)=0;      
          end
    end
end
%%将result1表中的第一列数据转换为数组
xindex = table2array(data_result1(:, 1));

% 获取result1表中从第二列开始的所有列名
yindex = data_result1.Properties.VariableNames(2:end);

% 初始化xindex1为空数组
xindex1 = [];

% 遍历xindex数组，生成新的索引标签
for i = 1:length(xindex)
    % 如果索引i大于等于55，则str4为'2'，否则为'1'
    if i >= 55
        str4 = '2';
    else
        str4 = '1';
    end
    
    % 将xindex中的元素与str4连接，并存储在xindex1中
    xindex1{1, i} = [xindex{i}, '-', str4];
end

% 生成一个逻辑矩阵，其中data_price_result1_mat1非零元素位置为真（true）
index_get_mat = (data_price_result1_mat1 ~= 0);

% 创建一个图形窗口，并设置大小和位置
figure('Position', [100, 100, 1200, 600])

% 使用heatmap函数绘制data_price_result1_mat1的热力图，xindex1和yindex作为x轴和y轴标签
heatmap(xindex1, yindex, double(data_price_result1_mat1'))

% 再次创建一个图形窗口，并设置大小和位置
figure('Position', [100, 100, 1200, 600])

% 使用heatmap函数绘制逻辑矩阵index_get_mat的热力图，xindex1和yindex作为x轴和y轴标签
heatmap(xindex1, yindex, double(index_get_mat)')

% 设置热力图的颜色映射，这里使用黑白两色
colormap([1, 1, 1; 0, 0, 0])
%%
figure('Position',[100,100,1200,600])
imagesc(double(index_get_mat)');
colorbar; % 添加颜色条

% 自定义红-绿颜色映射
cmap = [1, 0, 0;  % 红色
        0, 1, 0]; % 绿色
colormap(cmap);

% 可选：调整坐标轴刻度
xticks([1:1:size(index_get_mat, 1)]);
yticks([1:1:size(index_get_mat, 2)]);

% 设置坐标轴刻度标签
xticklabels(xindex);
yticklabels(yindex);
grid on


%% 约束条件
data_price_result1_mat_yueshu=zeros(size(data_price_result1_mat,1),size(data_price_result1_mat,2));

%首先来看附件1的约束条件

data_price_result1_mat_yueshu(1:26,1:15)=1;  % 第1个约束平旱地、梯田、山坡地适合种的植物

data_price_result1_mat_yueshu([27:34],16)=1;  %第2个约束（水稻可以种第一季或第二季水浇）

% data_price_result1_mat_yueshu([27:34,55:62],16)=1;  %第2个约束（水稻可以种第一季或第二季水浇）

data_price_result1_mat_yueshu([27:54,79:82],17:34)=1;  %第3个约束 (豇豆到芹菜需要满足的)

data_price_result1_mat_yueshu([55:62],[35:37])=1;  %第4个约束（萝卜需要满足的第二季水浇）

data_price_result1_mat_yueshu([63:78],[38:41])=1;  %第5个约束（菌类需要满足的普通大棚第二季）

% 简化成一个0-1变量的问题
data_price_result1_mat_yueshu1=data_price_result1_mat_yueshu;
data_price_result1_mat_yueshu(index_get_mat==1)=0;
%%
load('地的种植面积.mat')
% 加如全部能够卖出去整体的收益情况
%sdpvar实型变量   intvar 整形变量   binvar 0-1型变量
data_price_result1_mat=data_price_result1_mat';
data_price_result1_mat_yueshu=data_price_result1_mat_yueshu';
data_price_result1_mat1=data_price_result1_mat1';
data_price_result1_mat_chengben=data_price_result1_mat_chengben';
% 记录每块地的种植面积
mianji_zhongzhi_juzheng=repmat(mianji_zhongzhi',size(data_price_result1_mat,1),1);

% 2023年的产量 
%%
changliang_all=mianji_zhongzhi_juzheng.*data_price_result1_mat1;
%% 能种植的约束
data_can=data_price_result1_mat.*data_price_result1_mat_yueshu; 
%%
p=binvar(size(data_price_result1_mat,1),size(data_price_result1_mat,2));   %定义变量
%目标函数  要把求最大值转化为最小值


%%
sump=repmat(sum(p),size(data_price_result1_mat,1),1);
% 所有的收益情况 假设 一块地最多两种作物，而且会各个作物平分
%销售不掉的情况全部浪费
langfeixishu=1;
%植物价格
data_price_result1_mat_mean=[];
for j=1:41
    index_get_j=data_price_result1_mat(j,:)~=0;
    data_price_result1_mat_mean(j)=mean(data_price_result1_mat(j,index_get_j));
    data_price_result1_mat_chengben1(j)=mean(data_price_result1_mat_chengben(j,index_get_j));
end

%%
%滞销的浪费了
waste_money=langfeixishu*sum(max(sum(p.*mianji_zhongzhi_juzheng-data_price_result1_mat1,2),0).*(data_price_result1_mat_mean'+data_price_result1_mat_chengben1'));
%目标函数的求解
Objective=-sum(sum(p.*data_price_result1_mat.*data_price_result1_mat_yueshu.*mianji_zhongzhi_juzheng))+waste_money;

%% 约束条件
% data_get1_get=data_price_result1_mat1.*data_price_result1_mat_yueshu.*mianji_zhongzhi_juzheng;
%
%% 循环写进变量
constr=[];
%对于很多块地一年只会种植一种作物，按照2023年的情况
for i = 1:68
   constr=[constr,sum(p(:,i))==1];
end

for i = 69:size(data_price_result1_mat1,2)
   constr=[constr,sum(p(:,i))<=2,sum(p(:,i))>=1];
end

for j=1:41
    constr=[constr,sum(p(j,:))<=6,sum(p(j,:))>=1];
end

%
for j=1:82
    for i=1:41
       if data_price_result1_mat_yueshu(i,j)==0
          constr=[constr,p(i,j)==0];
       end
    end
end
% 保险起见 约束为0的地方都赋值为0
% 对于每一列来说
% constr=[];
% for i = 1:size(data_price_result1_mat1,2)
%    constr=[constr,sum(p(:,i))<=2,sum(p(:,i))>=1];
% end
Constraints=constr;

%优化求解
optimize(Constraints,Objective)

P=double(p);
Obj=double(-Objective);
objstr=['目标函数最优值：',num2str(Obj)];
disp(objstr)
for i=1:length(P)
    xstr=['x',num2str(i),'的值为：',num2str(P(i))];
    disp(xstr)
end

%
figure('Position',[100,100,1200,600])

% 绘制 heatmap，使用从白色到红色的渐变
heatmap(xindex1, yindex, double(P))

% 自定义颜色映射，从白色渐变到红色
cmap = [linspace(1, 1, 256)', linspace(1, 0, 256)', linspace(1, 0, 256)'];  % 生成256级的白到红渐变
colormap(cmap);

% 计算 zhomgmu
zhomgmu = double(P) .* mianji_zhongzhi_juzheng ./ sum(double(P));

% 第二个 heatmap 使用相同的颜色映射
figure('Position',[100,100,1200,600])
heatmap(xindex1, yindex, double(P))

% 使用同样的红色渐变 colormap
colormap(cmap);

% 将 index_get_mat1_result 赋值为 P 的 double 形式
index_get_mat1_result = double(P);

%%
P_result_data_all=[];
P_result_data_all(:,:,1)=double(index_get_mat');
P_result_data_all(:,:,2)=double(index_get_mat1_result);
%% 接下来第2年情况
Obj1(1)=Obj;
for  NN=1:6
    data_price_result1_mat_yueshu=data_price_result1_mat_yueshu1';
    data_price_result1_mat_yueshu(index_get_mat1_result==1)=0;
    changliang_all=mianji_zhongzhi_juzheng.*data_price_result1_mat1;
    %
    % 能种植的约束
    data_can=data_price_result1_mat.*data_price_result1_mat_yueshu;
    %
    p=binvar(size(data_price_result1_mat,1),size(data_price_result1_mat,2));   %定义变量
    %目标函数  要把求最大值转化为最小值

    %
    sump=repmat(sum(p),size(data_price_result1_mat,1),1);
    % 所有的收益情况 假设 一块地最多两种作物，而且会各个作物平分
    %销售不掉的情况全部浪费

    %植物价格
    data_price_result1_mat_mean=[];
    for j=1:41
        index_get_j=data_price_result1_mat(j,:)~=0;
        data_price_result1_mat_mean(j)=mean(data_price_result1_mat(j,index_get_j));
        data_price_result1_mat_chengben1(j)=mean(data_price_result1_mat_chengben(j,index_get_j));
    end
    waste_money=langfeixishu*sum(max(sum(p.*mianji_zhongzhi_juzheng-data_price_result1_mat1,2),0).*(data_price_result1_mat_mean'+data_price_result1_mat_chengben1'));

    Objective=-sum(sum(p.*data_price_result1_mat.*data_price_result1_mat_yueshu.*mianji_zhongzhi_juzheng))+waste_money;

    % 约束条件
    % data_get1_get=data_price_result1_mat1.*data_price_result1_mat_yueshu.*mianji_zhongzhi_juzheng;
    %
    %循环写进变量
    constr=[];
    %对于很多块地一年只会种植一种作物，按照2023年的情况
    for i = 1:68
        constr=[constr,sum(p(:,i))==1];
    end

    for i = 69:size(data_price_result1_mat1,2)
        constr=[constr,sum(p(:,i))<=2,sum(p(:,i))>=1];
    end

    for j=1:41
        constr=[constr,sum(p(j,:))<=6,sum(p(j,:))>=1];
    end

    %
    for j=1:82
        for i=1:41
            if data_price_result1_mat_yueshu(i,j)==0
                constr=[constr,p(i,j)==0];
            end
        end
    end

    % 每3年至少种一次豆子
 % dou_list=[1:5,17:19];
% % 保证在连续3年内至少有豆子
    index_get_mat_3_year=p+P_result_data_all(:,:,NN)+P_result_data_all(:,:,NN+1);  %统计3年优化情况
    dou_list=[1:5,17:19];
    for j=1:26
        % for i=dou_list
            constr=[constr,sum(index_get_mat_3_year(dou_list,j))>=1];
        % end
    end
    for j=27:54
        % for i=dou_list
            constr=[constr,sum(index_get_mat_3_year(dou_list,j)+index_get_mat_3_year(dou_list,j+28))>=1];
        % end
    end

    % 保险起见 约束为0的地方都赋值为0
    % 对于每一列来说
    % constr=[];
    % for i = 1:size(data_price_result1_mat1,2)
    %    constr=[constr,sum(p(:,i))<=2,sum(p(:,i))>=1];
    % end
    Constraints=constr;

    %优化求解
    optimize(Constraints,Objective)

    P=double(p);
    obj=double(-Objective);
    Obj1(NN+1)=obj;
    index_get_mat1_result=P;

    P_result_data_all(:,:,NN+2)=index_get_mat1_result;
end

% objstr=['目标函数最优值：',num2str(Obj)];
% disp(objstr)
% for i=1:length(P)
%     xstr=['x',num2str(i),'的值为：',num2str(P(i))];
%     disp(xstr)
% end
%%
for i = 1:8
    figure('Position', [100,100,1200,600])
    
    % 绘制 heatmap，显示指定年份的数据
    heatmap(xindex1, yindex, P_result_data_all(:,:,i), "Title", ['year', num2str(2022 + i)])
    
    % 自定义红绿颜色映射，从红色 (1, 0, 0) 到绿色 (0, 1, 0)
    cmap = [linspace(1, 0, 256)', linspace(0, 1, 256)', zeros(256, 1)];  % 红到绿渐变
    colormap(cmap);  % 应用颜色映射
    
    % 可以在这里取消注释并使用该行进行其他计算
    % data_result = P_result_data_all(:,:,i) .* mianji_zhongzhi_juzheng ./ sum(P_result_data_all(:,:,i));
end

%%
for i=1:7
    data_result=P_result_data_all(:,:,i+1).*mianji_zhongzhi_juzheng./sum(P_result_data_all(:,:,i+1));
    writematrix(data_result','result1_1.xlsx','Sheet',num2str(2023+i),'Range','C2:AQ83');
end
% index_get_mat1_result=double(P);
figure
hold on
plot(Obj1, '--', 'Color', 'r', 'LineWidth', 1.5)  % 绘制红色折线

% 使用 text 函数在每个点上绘制红色爱心符号
for i = 1:length(Obj1)
    text(i, Obj1(i), '❤', 'FontSize', 14, 'HorizontalAlignment', 'center', 'Color', 'r')  % 在每个点绘制红色爱心
end

xlabel('年')
ylabel('利润')
title(['七年利润总和 ： ' , num2str(sum(Obj1))])
hold off
