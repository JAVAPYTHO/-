%在不确定情况 下多次运行求平均值
clc;clear;close all;
data=readtable("附件2_处理后.xlsx","Sheet","2023年统计的相关数据");
data1=readtable("附件2_处理后.xlsx","Sheet","2023年的农作物种植情况");
%%
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
%每亩地的产量 变化

chanliang_mei_mu=data_get_all(:,1);
% 每亩地产量变化
rand_mu_can=-0.1+0.2*rand(1);
chanliang_mei_mu=chanliang_mei_mu*(1+rand_mu_can);
chengben=data_get_all(:,2);
chengben=chengben*(1.02);

%蔬菜销售价格
%蔬菜类作物的销售价格有增长的趋势，平均每年增长5%左右。
price_mean1(17:37)=price_mean1(17:37)*(1.05);

price_mean1(38:41)=price_mean1(38:41)*(1-0.03);

shouyi_mean=chanliang_mei_mu.*price_mean1-chengben;

shouyi_high=chanliang_mei_mu.*data_get_all(:,4)-chengben;

shouyi_low=chanliang_mei_mu.*data_get_all(:,3)-chengben;
%
[sort_shouyi_mean_value,sort_shouyi_mean_index]=sort(shouyi_mean,'descend');

%% 单亩地的收益情况
figure('Position',[100,65,1200,700])
subplot(2,1,1)
data_plot_str=data_str2(sort_shouyi_mean_index);
bar(sort_shouyi_mean_value(1:65))
xticks(1:65)
xticklabels(data_plot_str(1:65))
ylim([0,max(sort_shouyi_mean_value)+100])
ylabel('收益')

subplot(2,1,2)
data_plot_str=data_str2(sort_shouyi_mean_index);
bar(sort_shouyi_mean_value(66:end))
xticks(1:(length(data_str3))-65)
xticklabels(data_plot_str(66:end))
ylim([0,max(sort_shouyi_mean_value)+100])
ylabel('收益')

%%  以结果导向
data_result=readtable('result1_1.xlsx','VariableNamingRule','preserve');
data_result(83:86,:)=[];
%% 总体种植利润计算每个植物在每亩的（平均利润）
data_price_result1_mat=[];
data_price_result1_mat_chengben=[];
chan_liang_mat=[];
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
              chanliang_mei_mu_mat(i,j)=chanliang_mei_mu(index(1));          %矩阵形式每亩的产量矩阵
              
              data_price_result1_mat(i,j)=shouyi_mean(index(1));                    %矩阵形式每亩的收益矩阵
              data_price_result1_mat_chengben(i,j)=chengben(index(1));  %矩阵形式每亩的成本矩阵
          else
               chanliang_mei_mu_mat(i,j)=0;
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
%%
xindex=table2array(data_result1(:,1));
yindex=data_result1.Properties.VariableNames(2:end);
%%
xindex1=[];
for i=1:length(xindex)
% xindex1=xindex;
if i>=55
              str4='2';
          else
              str4='1';
          end
          xindex1{1,i}=[xindex{i},'-',str4];
end
index_get_mat=(data_price_result1_mat1~=0);
figure('Position',[100,100,1200,600])
heatmap(xindex1,yindex,double(data_price_result1_mat1'))
figure('Position',[100,100,1200,600])
heatmap(xindex1,yindex,double(index_get_mat)')

colormap([1,1,1;0,0,0])
%%
figure('Position',[100,100,1200,600])
imagesc(double(index_get_mat)');
colorbar; % 添加颜色条
% colormap('parula'); % 设置颜色映射，例如 'jet', 'hot', 'cool', 'gray' 等
colormap([1,1,1;0,0,0])
% 可选：调整坐标轴刻度
xticks([1:1:size(index_get_mat, 1)]);
yticks([1:1:size(index_get_mat, 2)]);

% 可选：设置坐标轴刻度标签
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
%% 还有就是 不能同茬  那先解决24年的不能和23种一块地的问题
% 
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
changliang_all=data_price_result1_mat1.*chanliang_mei_mu_mat';
%%
changliang_all1=sum(changliang_all')';
figure('Position',[100,100,1000,400])
bar(changliang_all1)
xticks(1:length(changliang_all1))
xticklabels(yindex)
ylabel('产量')
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

%% 应对变化的情况
%s首先是预期产量矩阵
% 拆解一下：小麦和玉米未来的预期销售量有增长的趋势，平均年增长率介于5%~10%
data_price_result1_mat1([6,7],:)=data_price_result1_mat1([6,7],:)*(1.75);  %取中间值
%其他农作物未来每年的预期销售量相对于2023年大约有±5%的变化
% 给定一个随机的变化 采用数值模拟的形式
rand_rate=-0.05+0.1*rand(1);
data_price_result1_mat1([1:7,8:end],:)=data_price_result1_mat1([1:7,8:end],:)*(1+rand_rate);  %取中间值

%% 面积矩阵
% mianji_zhongzhi_juzheng=
%%
%这个是被浪费的钱，多出来的就会被浪费，不多出来就是0
%langfeixishu  langfeixishu=1就是全浪费  langfeixishu=0.5  就是50%浪费  
% 浪费意味着不仅没有收益，还会浪费成本,所以浪费掉的钱是原本计算的收益+成本
waste_money=langfeixishu*sum(max(sum(p.*mianji_zhongzhi_juzheng-data_price_result1_mat1,2),0).*(data_price_result1_mat_mean'+data_price_result1_mat_chengben1'));
% waste_money=sum(max(sum(p.*mianji_zhongzhi_juzheng-data_price_result1_mat1.*(data_price_result1_mat+data_price_result1_mat_chengben),2),0));

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

heatmap(xindex1,yindex,double(P))

colormap([1,1,1;0.2,0.2,0.2])
%
zhomgmu=double(P).*mianji_zhongzhi_juzheng./sum(double(P));
figure('Position',[100,100,1200,600])
heatmap(xindex1,yindex,double(P))
index_get_mat1_result=double(P);
%%
P_result_data_all=[];
P_result_data_all(:,:,1)=double(index_get_mat');
P_result_data_all(:,:,2)=double(index_get_mat1_result);
%% 接下来第2年情况
Obj1(1)=Obj;
for  NN=1:6
    chanliang_mei_mu=data_get_all(:,1);
% 每亩地产量变化
rand_mu_can=-0.1+0.2*rand(1);
chanliang_mei_mu=chanliang_mei_mu*(1+rand_mu_can);
chengben=data_get_all(:,2);
chengben=chengben*(1.02);

%蔬菜销售价格
%蔬菜类作物的销售价格有增长的趋势，平均每年增长5%左右。
price_mean1(17:37)=price_mean1(17:37)*(1.05);

price_mean1(38:41)=price_mean1(38:41)*(1-0.03);

shouyi_mean=chanliang_mei_mu.*price_mean1-chengben;

shouyi_high=chanliang_mei_mu.*data_get_all(:,4)-chengben;

shouyi_low=chanliang_mei_mu.*data_get_all(:,3)-chengben;
%
[sort_shouyi_mean_value,sort_shouyi_mean_index]=sort(shouyi_mean,'descend');


 % 总体种植利润计算每个植物在每亩的（平均利润）
data_price_result1_mat=[];
data_price_result1_mat_chengben=[];
chan_liang_mat=[];
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
              chanliang_mei_mu_mat(i,j)=chanliang_mei_mu(index(1));          %矩阵形式每亩的产量矩阵
              
              data_price_result1_mat(i,j)=shouyi_mean(index(1));                    %矩阵形式每亩的收益矩阵
              data_price_result1_mat_chengben(i,j)=chengben(index(1));  %矩阵形式每亩的成本矩阵
          else
              chanliang_mei_mu_mat(i,j)=0;
              data_price_result1_mat(i,j)=0;      
              data_price_result1_mat_chengben(i,j)=0;
          end
    end
end

%

data_str23=table2array(data1(:,3));

data_str23_1=table2array(data1(:,1));

data_str23_1_2=table2array(data1(:,6)); %记录季节

canliang_mean1=table2array(data1(:,5));
%

data_result1=data_result;
data_price_result1_mat1=[];
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
    data_price_result1_mat_yueshu=data_price_result1_mat_yueshu1';
    data_price_result1_mat_yueshu(index_get_mat1_result==1)=0;


   data_price_result1_mat=data_price_result1_mat';
% data_price_result1_mat_yueshu=data_price_result1_mat_yueshu';
data_price_result1_mat1=data_price_result1_mat1';
data_price_result1_mat_chengben=data_price_result1_mat_chengben';
% 记录每块地的种植面积
mianji_zhongzhi_juzheng=repmat(mianji_zhongzhi',size(data_price_result1_mat,1),1);

% 2023年的产量 
%%
changliang_all=data_price_result1_mat1.*chanliang_mei_mu_mat';
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
        index_get_j=find(data_price_result1_mat(j,:)~=0);
        data_price_result1_mat_mean(j)=mean(data_price_result1_mat(j,index_get_j));
        data_price_result1_mat_chengben1(j)=mean(data_price_result1_mat_chengben(j,index_get_j));
    end
    %s首先是预期产量矩阵
    % 拆解一下：小麦和玉米未来的预期销售量有增长的趋势，平均年增长率介于5%~10%
    data_price_result1_mat1([6,7],:)=data_price_result1_mat1([6,7],:)*(1.75);  %取中间值
    %其他农作物未来每年的预期销售量相对于2023年大约有±5%的变化
    % 给定一个随机的变化 采用数值模拟的形式
    rand_rate=-0.05+0.1*rand(1);
    data_price_result1_mat1([1:7,8:end],:)=data_price_result1_mat1([1:7,8:end],:)*(1+rand_rate);  %取中间值

    %
    %这个是被浪费的钱，多出来的就会被浪费，不多出来就是0
    %langfeixishu  langfeixishu=1就是全浪费  langfeixishu=0.5  就是50%浪费
    % 浪费意味着不仅没有收益，还会浪费成本,所以浪费掉的钱是原本计算的收益+成本
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
for i=1:8
    figure('Position',[100,100,1200,600])
    heatmap(xindex1,yindex,P_result_data_all(:,:,i),"Title",['year',num2str(2022+i)])
    colormap([1,1,1;0.2,0.2,0.2])
    data_result=P_result_data_all(:,:,i).*mianji_zhongzhi_juzheng./sum(P_result_data_all(:,:,i));
    
end
%%
% result2 result2-1 result2-2 是运行出来得到的不同结果，考虑随机性影响
for i=1:7
    data_result=P_result_data_all(:,:,i+1).*mianji_zhongzhi_juzheng./sum(P_result_data_all(:,:,i+1));
    writematrix(data_result','result2.xlsx','Sheet',num2str(2023+i),'Range','C2:AQ83');
end
% index_get_mat1_result=double(P);
%%
figure
plot(Obj1,'--p','LineWidth',1.5)
xlabel('年')
ylabel('利润')
title(['七年利润总和 ： ' ,num2str(sum(Obj1))])