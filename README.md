# 农作物种植决策优化 | Crop Planting Decision Optimization

> 基于多因素线性规划与启发式算法的 2024-2030 年种植策略优化  
> Multi-factor planning and heuristic optimization for 2024-2030 crop allocation.

---

## 中文说明

### 1. 项目简介

本项目围绕某乡村耕地资源配置问题，综合考虑地块类型、作物适配关系、产量、成本、价格与市场风险，构建 2024-2030 年农作物种植优化模型，目标是**提高总收益并增强方案稳定性**。

### 2. 三个子问题做了什么

#### 问题一（确定性优化）
- 基于附件数据建立利润最大化模型。
- 设置两种销售情景：超产滞销 / 超产折价（50%）。
- 在地块适配、面积、轮作等约束下，使用遗传算法求解最优种植方案。

#### 问题二（不确定性与风险）
- 在问题一基础上引入销量、产量、成本、价格波动。
- 采用蒙特卡洛模拟进行多场景求解。
- 统计收益均值与波动区间，得到更稳健方案（见 `results/result2.xlsx`）。

#### 问题三（相关性+替代/互补）
- 分析销量-价格-成本相关性（含斯皮尔曼相关）。
- 通过 KMeans + 协方差矩阵刻画作物替代性与互补性。
- 用模拟退火算法优化修正后的目标函数，输出综合约束下方案（见 `results/solve3.xlsx`）。

### 3. 方法关键词

- 线性规划
- 遗传算法（GA）
- 蒙特卡洛模拟
- KMeans 聚类
- 斯皮尔曼相关分析
- 协方差矩阵
- 模拟退火算法（SA）
- 灵敏度分析

### 4. 目录结构（已规范化）

```text
.
├─ src/                # 源代码（MATLAB）
│  ├─ question1/
│  ├─ question2/
│  └─ question3/
│     └─ sa/           # 模拟退火相关实现
├─ data/               # 输入数据（xlsx/mat）
├─ results/            # 输出结果（xlsx）
├─ docs/               # 文档（PDF）
├─ README.md
└─ .gitignore
```

### 5. 运行方式

建议 MATLAB R2021a 及以上：

1. 运行 `src/question1/trouble1_1.m`、`src/question1/trouble1_2.m`
2. 运行 `src/question2/mengtekaluo2.m`
3. 运行 `src/question3/sa/mo_ni_tui_huo.m`
4. 按需运行 `src/question3/` 下分析脚本

> 提示：运行前请确认 MATLAB 当前工作路径及 `data/` 文件可访问。

### 6. 结果展示（Result Highlights）

- 问题一结果：`results/result1_1.xlsx`, `results/result1_2.xlsx`
- 问题二结果：`results/result2.xlsx`
- 问题三结果：`results/solve3.xlsx`
- 附加统计与分析：`results/多次总收益数据表.xlsx` 等

可在后续补充图表：
- 年度收益折线图
- 地块-作物分配热力图
- 风险区间误差图

### 7. 数据与论文来源

- 论文文档：`docs/C2024021001076.pdf`
- 项目结论与方法说明主要依据该文档提炼。

---

## English Overview

### 1. Project Summary

This project optimizes crop planting strategies (2024-2030) for a village under land-type constraints, crop suitability, yield/cost/price factors, and market uncertainty, aiming to maximize long-term profit with better robustness.

### 2. What has been done

- **Q1:** Deterministic optimization with two overproduction scenarios (waste vs. 50% discount), solved by GA.
- **Q2:** Uncertainty-aware optimization via Monte Carlo simulation, producing robust profit distributions and plans.
- **Q3:** Correlation-aware optimization with substitution/complementarity (Spearman, KMeans, covariance), solved by simulated annealing.

### 3. Tech Stack

- MATLAB
- Linear programming + heuristic algorithms (GA / SA)
- Statistical analysis and simulation

### 4. Outputs

Main output files are stored in `results/`, and documentation is in `docs/`.

---

## GitHub

Remote repository: `https://github.com/JAVAPYTHO/-.git`

```bash
git add .
git commit -m "refactor: normalize structure and improve bilingual README"
git push -u origin main
```
