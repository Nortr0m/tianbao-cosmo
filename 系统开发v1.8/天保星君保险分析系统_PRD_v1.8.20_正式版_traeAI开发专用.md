# 天保星君保险分析系统
## PRD 产品需求文档 v1.8.20 正式版

---

## AI驱动开发模式说明

本PRD为**AI驱动开发模式**，所有代码由trae AI自动生成，所有测试由AI自动化执行，无需人工开发介入。

文档规格定义完整、精确、可执行，trae AI可直接基于此文档生成：
- 全部前端代码（Vue3 + TypeScript + Vite）
- 全部后端代码（Java + Spring Boot + MyBatis）
- 全部数据库脚本（MySQL表结构、索引、初始化数据）
- 全部配置文件、部署脚本

---

## 目录

1. 项目概述
2. 用户画像与使用场景
3. 产品核心功能
4. 产品详情页设计
5. 产品对比页设计
6. 产品卡片导出功能
7. 后台管理系统
8. 数据模型设计（继承架构）
9. 技术架构完整设计
10. API 接口规范
11. VIP 会员体系
12. 非功能需求
13. 自动化测试方案
14. 附录 A - 法定疾病清单
15. 附录 B - 卡片背景图库
16. 版本历史

---

## 1. 项目概述

### 1.1 项目定位
从0到1全新开发的专业保险产品分析与对比平台，面向保险经纪人、个人消费者、行业研究者提供专业的产品数据分析能力。

### 1.2 核心价值
- 产品数据100%对齐明亚保险系统真实字段
- 三大险种灵活配置机制，支持所有市场产品
- 专业的利益演算与对比分析
- 保险经纪人展业神器：一键生成精美卡片

### 1.3 支持险种（四大险种）
1. **重疾险**：动态责任配置、费率精确计算
2. **增额终身寿险**：分红型/固收型、减保领取计划
3. **年金险**：分红型/固收型、灵活祝寿金配置

### 1.4 账号体系

#### 1.4.1 管理侧账号体系
- 仅PC网页端访问
- 账号密码登录
- 不可自主注册，仅超级管理员创建分配
- 4级角色权限：超级管理员 / 产品管理员 / 数据管理员 / 运营管理员

#### 1.4.2 客户侧账号体系
- PC网页 + 微信小程序 数据完全互通
- **账号密码注册必须绑定微信**：未绑定微信仅可浏览产品，不可生成/保存/分享卡片
- 登录矩阵：
  - PC端：账号密码登录 + 微信扫码登录
  - 小程序端：仅微信一键登录

---

## 2. 用户画像与使用场景

### 2.1 重疾险使用场景

#### 场景1：家庭支柱重疾保障规划
- **用户角色**：30-40岁家庭经济支柱
- **触发条件**：家庭责任重，担心重疾导致收入中断
- **操作路径**：进入重疾险对比 → 筛选消费型/储蓄型 → 对比保费、保障责任、理赔宽松度
- **成功标准**：找到性价比最高的重疾险产品
- **核心关注点**：保费、重疾/中症/轻症次数、理赔宽松度、公司偿付能力

#### 场景2：少儿重疾险规划
- **用户角色**：0-10岁孩子的父母
- **触发条件**：为孩子配置终身重疾保障
- **操作路径**：筛选少儿专属产品 → 对比少儿特定疾病、保费、保障期限
- **成功标准**：配置孩子的终身重疾保障
- **核心关注点**：少儿特定疾病、白血病等高发重疾、保费杠杆

#### 场景3：女性特定重疾保障
- **用户角色**：25-45岁女性
- **触发条件**：关注乳腺癌、宫颈癌等女性高发重疾
- **操作路径**：对比女性特定疾病额外赔付、保费、核保宽松度
- **成功标准**：找到适合女性的高性价比产品
- **核心关注点**：女性特定疾病、乳腺/甲状腺核保、保费

### 2.2 增额终身寿险使用场景（分红型 + 固收型）

#### 场景1：家庭资产配置与财富传承
- **用户角色**：35-50岁中产家庭
- **触发条件**：家庭有闲置资金，需要资产保值、隔离债务、定向传承给子女
- **操作路径**：进入增额寿对比页面 → 筛选分红型/固收型 → 对比多款产品的现金价值增长曲线、IRR、加减保规则
- **成功标准**：找到符合家庭财务规划的最优产品
- **核心关注点**：回本年度、第20/30年IRR、保单贷款比例、减保灵活性
- **类型侧重**：固收型侧重确定性收益；分红型侧重长期潜在收益

#### 场景2：养老金补充规划
- **用户角色**：40-55岁临近退休人群
- **触发条件**：社保养老金不足，需要补充以保证退休后生活品质
- **操作路径**：设置60岁开始减保领取 → 对比不同产品的领取金额和现金价值
- **成功标准**：计算出退休后每年可补充的养老金金额
- **核心关注点**：60岁时现金价值、每年可领取金额、身故赔付
- **类型侧重**：固收型侧重确定的领取金额；分红型侧重领取+分红双重收益

#### 场景3：子女教育金规划
- **用户角色**：30-40岁年轻父母
- **触发条件**：为孩子储备大学/留学教育金
- **操作路径**：孩子0岁投保 → 对比18-22岁教育金领取期的现金价值
- **成功标准**：规划出覆盖孩子教育费用的方案
- **核心关注点**：回本速度、教育金领取期的现金价值、资金灵活性
- **类型侧重**：固收型侧重确定的教育金；分红型侧重教育金+增值潜力

### 2.3 年金险使用场景（分红型 + 固收型）

#### 场景1：专属养老规划
- **用户角色**：35-50岁关注养老人群
- **触发条件**：需要与生命等长的、确定的终身现金流
- **操作路径**：对比不同产品的领取起始年龄、年领/月领金额、保证领取期
- **成功标准**：选择满足养老品质需求的年金产品
- **核心关注点**：每年领取金额、保证领取总额、现金价值、身故赔付
- **类型侧重**：固收型侧重100%确定的终身领取；分红型侧重基础领取+分红

#### 场景2：孩子压岁钱理财
- **用户角色**：0-10岁孩子的父母
- **触发条件**：利用压岁钱强制储蓄，培养孩子财商，长期复利增值
- **操作路径**：孩子0岁投保 → 对比30岁/40岁时的累计领取总额
- **成功标准**：建立孩子的长期理财账户
- **核心关注点**：长期收益、强制储蓄属性、资金安全性
- **类型侧重**：固收型侧重稳健增值；分红型侧重长期复利效果

#### 场景3：企业主资产隔离
- **用户角色**：40-60岁企业主
- **触发条件**：需要隔离企业经营风险与家庭资产
- **操作路径**：对比现金价值增长、保单贷款功能、法律属性
- **成功标准**：建立风险隔离的家庭资产防火墙
- **核心关注点**：现金价值增长、投保人控制权、债务隔离功能
- **类型侧重**：固收型侧重确定的资产保全；分红型侧重资产保全+增值

---

## 3. 产品核心功能

### 3.1 重疾险责任动态配置系统（v1.6.0）

#### 3.1.1 二级目录结构
**一级分类（7大类）**：BASE基础保障、DEATH身故责任、WAIVER豁免责任、MULTI_PAY多次赔付、BONUS额外赔付、ALLOWANCE津贴责任、SPECIAL特色责任

**二级责任项**：每个分类下N个具体责任项，每个责任项独立配置选项

#### 3.1.2 前端动态渲染
- 按一级分类分组展示
- 不支持的责任完全不显示
- 每个责任默认选中default_option
- 选择后保费实时重算

#### 3.1.3 对比页自动对齐
- 按一级分类横向对齐
- 产品不支持 → 显示「不支持」红色标记
- 支持但未选择 → 显示「未选择」黄色标记

### 3.2 分红实现率选择器（v1.5.4）

#### 3.2.1 5档预设+自定义输入
- 预设选项：50%/80%/100%/120%/150%
- 自定义输入：0%-200%任意整数
- 默认值：100%（中性预期）

#### 3.2.2 核心计算公式
```
实际分红金额 = 条款中档演示分红金额 × (分红实现率 ÷ 100)
```

#### 3.2.3 全链路数据联动
- 分红演示表格实时重算
- 现金价值图表动态更新
- IRR、累计领取总额重新计算

### 3.3 利益演示自定义列（v1.5.5）

#### 3.3.1 三大分类15个字段
**【基本利益】（默认全选）**：年度保费、累计保费、身故或全残保险金、意外身故保险金、身故保险金、现金价值、内部收益率（IRR）

**【保证利益】（默认全不选）**：当年度红利（保证部分）、累积红利（保证部分）、总现金价值（保证部分）、内部收益率（保证部分）

**【红利利益】（默认勾选前3个）**：当年度红利、累积红利、总现金价值、内部收益率（分红部分）

#### 3.3.2 交互规格
- 「自定义列」弹窗
- localStorage持久化保存
- 「恢复默认」按钮
- 导出Excel仅导出勾选列

### 3.4 缴费周期灵活配置（v1.8.10）

#### 3.4.1 支持周期
- 年缴（100%支持）
- 半年缴（约60%产品支持）
- 季缴（约40%产品支持）
- 月缴（约50%产品支持）

#### 3.4.2 保费换算公式
- 月交保费 = 年交保费 × monthly_ratio
- 季交保费 = 年交保费 × quarterly_ratio
- 半年交保费 = 年交保费 × half_yearly_ratio

### 3.5 对比页智能隐藏（v1.8.10）

#### 3.5.1 隐藏规则
```
IF 所有对比产品都不支持此项 / 都无此项配置
   → 自动隐藏该对比行
ELSE
   → 正常显示对比行
```

#### 3.5.2 用户控制开关
- 「显示全部对比项」开关
- 默认开启智能隐藏
- localStorage持久化保存

### 3.6 疾病定义悬停条件显示（v1.5.3）

#### 3.6.1 条件渲染逻辑
```javascript
if (disease.disease_definition && 
    disease.disease_definition.trim() !== '' && 
    disease.disease_definition.length > 0) {
  renderHelpIcon = true
  enableTooltip = true
} else {
  renderHelpIcon = false
  enableTooltip = false
}
```

#### 3.6.2 Tooltip内容
- 疾病官方定义（加粗标题）
- 赔付条件
- 注意事项/理赔要点

---

## 4. 产品详情页设计

### 4.1 重疾险详情页

#### 4.1.1 页面结构
1. 产品基本信息区（名称、公司、标签、状态）
2. 方案选择区（责任组合动态渲染）
3. 保费计算区（年龄、性别、保额、缴费年限、缴费周期）
4. Tab切换区
   - 保障责任Tab
   - 疾病清单Tab（重疾/中症/轻症）
   - 利益演示Tab
   - 保险公司Tab

#### 4.1.2 疾病清单Tab
- 按重疾/中症/轻症分Tab
- 高发疾病红色标记
- 支持搜索
- 有定义的疾病显示「?」帮助图标，悬停显示Tooltip

### 4.2 增额终身寿险详情页

#### 4.2.1 页面结构
1. 产品基本信息区
2. 减保领取计划选择区
   - 减保起始年龄：50/55/60/65/70岁
   - 减保方式：固定金额/固定比例/自定义
   - 减保期限：至80岁/至终身/至现金价值为0
3. 分红实现率选择器（分红型产品）
4. 利益演示Tab（自定义列选择）
5. 减保规则说明

### 4.3 年金险详情页

#### 4.3.1 页面结构
1. 产品基本信息区
2. 领取计划选择区
   - 领取起始年龄（按产品配置动态显示）
   - 领取方式：年领/月领
   - 保证领取期（按产品配置动态显示）
   - 领取递增规则（按产品配置动态显示）
3. 祝寿金配置（按产品配置动态渲染）
4. 分红实现率选择器（分红型产品）
5. 利益演示Tab（自定义列选择）

---

## 5. 产品对比页设计

### 5.1 通用对比功能
- 同时对比最多3/5/8款（按会员等级）
- 横向并排对比布局
- 智能隐藏无差异行
- 最优值绿色高亮，最差值黄色标记
- 支持导出对比卡片

### 5.2 重疾险对比
- 按责任分类横向对齐
- 保费精细化拆解（基础+各责任增量）
- 疾病覆盖对比弹窗
- 公司偿付能力对比

### 5.3 增额终身寿险对比
- 现金价值增长曲线对比图
- 核心指标对齐：回本年度、IRR、减保规则
- 各年度现金价值表格对比
- 分红实现率多曲线对比

### 5.4 年金险对比
- 领取金额对比
- 保证领取总额对比
- 祝寿金按年龄对齐
- 现金价值变化曲线对比

---

## 6. 产品卡片导出功能（v1.7.0/v1.7.1/v1.8.13/v1.8.14）

### 6.1 卡片整体结构（竖向长图，宽度固定1080px）
```
┌─────────────────────────────────┐
│  【顶部宽型背景图区域】          │
│  - 背景图（10大分类500个预设）   │
│  - 主标题（可编辑）              │
│  - 副标题（可编辑）              │
│  - 保险公司Logo（可选）          │
├─────────────────────────────────┤
│  【方案详情头部区域】            │
│  白色圆角卡片，阴影效果          │
│  - 被保人信息：年龄、性别        │
│  - 缴费信息：期缴保费、缴费年限  │
├─────────────────────────────────┤
│  【利益演示表格区域】            │
│  纯白色背景                      │
│  - 完整利益演示表格              │
│  - 与自定义列选择100%同步        │
├─────────────────────────────────┤
│  【扩展填充区域】                │
│  自动取顶部背景图底部主色调      │
├─────────────────────────────────┤
│  【底部信息区】                  │
│  - 免责声明（固定小字）          │
│  - 经纪人二维码（小程序端可选）  │
│  - 全屏自定义水印（蜂窝状平铺）  │
└─────────────────────────────────┘
```

### 6.2 自定义水印功能（v1.8.14完整修正）

#### 6.2.1 覆盖范围（强制全屏）
**整个卡片1080px×任意高度全部覆盖水印**，包括：
- 顶部背景图区域
- 方案详情头部区域
- 利益演示表格区域
- 扩展填充区域
- 底部信息区

**永久取消：分区域控制、部分区域覆盖等设计**

#### 6.2.2 6项完整配置参数
|配置项|可选范围|默认值|说明|
|-|-|-|-|
|**水印文字**|自定义输入，最多20个汉字|当前登录用户名|示例："张某某 保险顾问"|
|**透明度**|10% - 50% 连续可调|20%|推荐值15%-25%|
|**水印密度**|稀疏 / 适中 / 密集|适中|控制水印重复间隔距离|
|**旋转角度**|30° / 45° / 60°|45°|推荐45度斜向平铺|
|**字体大小**|12px - 36px|24px|根据卡片宽度自动适配|
|**文字颜色**|黑色 / 深灰色 / 白色|深灰色|根据背景图自动适配|

#### 6.2.3 蜂窝状平铺算法
```
1. 计算卡片总高度（动态生成）
2. 从左上角(-50%, -50%)开始，超出边界也渲染
3. 横向间隔 = 卡片宽度 ÷ 密度系数（稀疏=6，适中=4，密集=3）
4. 纵向间隔 = 横向间隔 × 0.866（正三角形高度比例）
5. 奇数行横向偏移半个间隔，形成蜂窝状排列
6. 覆盖整个矩形区域，不留任何空白边角
7. 整体旋转-45度
```

#### 6.2.4 会员权限控制
|用户等级|水印功能权限|
|-|-|
|免费用户|❌ 无水印功能，生成卡片无水印|
|VIP会员（19.9元/30天）|✅ 固定水印：显示用户名，不可修改文字，其他参数固定默认值|
|SVIP会员（29.9元/30天）|✅ 完整权限：自定义水印文字 + 全部6项参数自由调整|

#### 6.2.5 前端技术实现规格
**渲染层级顺序（从下到上）：**
```
第1层：卡片背景图
第2层：方案详情内容
第3层：利益演示表格
第4层：底部信息文字
第5层：全屏水印层（最顶层，z-index: 9999）
```

**水印层CSS规范：**
```css
.card-watermark-layer {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  pointer-events: none;
  z-index: 9999;
  background-image: url('data:image/svg+xml;base64,......');
  background-repeat: repeat;
  opacity: 0.2;
  transform: rotate(-45deg);
  transform-origin: center center;
}
```

### 6.3 微信小程序端卡片背景选择界面（v1.8.13）

#### 6.3.1 界面布局
```
┌─────────────────────────────────────────┐
│  🖼️ 【顶部背景预览区】                  │
│  （当前选中背景实时预览）                │
│                                         │
│  少儿教育金专属背景                     │
│  温馨亲子风格                           │
├─────────────────────────────────────────┤
│  📂 【分类选择区】（横向滚动）          │
│  [全部] [少儿教育金] [养老规划] [财富传承] │
│  [重疾保障] [少儿专属] [家庭守护]       │
│  [企业主专属] [节日营销] [开门红]       │
├─────────────────────────────────────────┤
│  🔍 搜索背景名称/标签...                │
├─────────────────────────────────────────┤
│  🖼️ 🖼️ 🖼️ 🖼️ 🖼️ 🖼️          │
│  背景网格列表（每行3个）                 │
│  带热度标签 🔥热门 ⭐推荐 🆕新品        │
└─────────────────────────────────────────┘
```

#### 6.3.2 10大分类体系
|分类编码|分类名称|适用产品|典型场景|
|-|-|-|-|
|EDUCATION|少儿教育金|年金险/增额寿|0岁宝宝、压岁钱、教育规划|
|PENSION|养老规划|年金险/增额寿|退休养老、品质养老|
|WEALTH|财富传承|增额寿|家庭资产、财富传承、债务隔离|
|HEALTH|重疾保障|重疾险|健康保障、医疗、家庭支柱|
|CHILDREN|少儿专属|少儿重疾/年金|宝宝保障、少儿专属|
|FAMILY|家庭守护|全险种|全家保障、夫妻互保、家庭责任|
|BUSINESS|企业主专属|增额寿/年金|资产隔离、企业主养老|
|FESTIVAL|节日营销|全险种|春节、中秋、618、双11|
|KAI_MEN_HONG|开门红专属|全险种|每年1月开门红营销|
|MINIMALIST|极简通用|全险种|简约风格、通用背景|

### 6.4 导出操作流程
1. 点击「生成展业卡片」按钮
2. 弹出配置弹窗：选择背景图、编辑文案、水印配置（按会员权限）
3. 预览 → 生成并保存
4. PNG格式下载，1080px宽度，2倍高清

---

## 7. 后台管理系统

### 7.1 后台管理菜单结构（v1.8.12重构）
```
后台管理系统
├── 🏠 数据看板
├── 📦 产品管理
│   ├── 重疾险管理
│   │   ├── 产品列表管理
│   │   ├── 责任模板管理
│   │   ├── 特色责任配置
│   │   ├── 费率管理
│   │   └── 疾病库管理
│   ├── 增额终身寿险管理
│   │   ├── 产品列表管理
│   │   ├── 减保规则配置
│   │   ├── 加减保规则配置
│   │   ├── 贷款规则配置
│   │   └── 费率管理
│   └── 年金险管理
│       ├── 产品列表管理
│       ├── 领取规则配置
│       ├── 祝寿金配置
│       └── 费率管理
├── 🏢 保险公司管理
│   ├── 保司列表
│   ├── 保司数据看板
│   └── 风险评级历史
├── 🎴 卡片模板管理（v1.8.13升级）
│   ├── 背景图库管理
│   ├── 分类管理
│   └── 使用数据统计
├── 👥 VIP会员管理
├── 🎫 兑换码管理
└── ⚙️ 系统设置
```

### 7.2 产品双状态管理（v1.8.12新增）
**状态字段拆分：**
- `sale_status`（销售状态）：0=已停售 1=正常在售 2=预售中
- `system_status`（系统状态）：0=未上架 1=已上架

**客户端可见条件：**
```sql
WHERE system_status = 1
  AND sale_status IN (1, 2)
  AND is_deleted = 0
```

### 7.3 保险公司管理（v1.8.12升级）

#### 7.3.1 保司数据看板
- 核心指标概览：保司总数、合作中、AAA评级、偿付>150%、本月新增
- 保险公司综合排行榜（多维度排序+筛选）
- 偿付能力分布图（柱状图）
- 风险评级分布图（饼图）

#### 7.3.2 风险评级历史
- 季度评级历史记录
- 评级趋势图（近8个季度）
- 历史评级明细表格

### 7.4 卡片模板管理（v1.8.13升级）

#### 7.4.1 背景图库管理
- 模板缩略图预览
- 10大分类筛选
- 按热度排序（7天/30天/累计）
- 启用/禁用状态管理
- 热度标签：🔥热门 ⭐推荐 🆕新品

#### 7.4.2 使用数据统计
- 今日/本周/本月/累计生成卡片数
- 热度TOP10模板排行榜
- 分类使用占比饼图
- 每日生成趋势折线图

---

## 8. 数据模型设计（继承架构）

### 8.1 继承架构说明
**父类表 + 子类表设计模式**：
- `product_base`（父类表）：所有产品通用字段
- 各子类表通过 `product_id` 外键关联父类表

### 8.2 product_base（父类表 - v1.8.12 更新：双状态字段拆分）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**product_id**|bigint||PK|主键|PRIMARY|
|**product_name**|varchar|200||NOT NULL|产品全称||
|**product_code**|varchar|50||UNIQUE|产品编码|UNIQUE|
|**company_id**|bigint||FK|关联保险公司ID|INDEX|
|**product_type**|tinyint||NOT NULL|1=重疾险 2=增额终身寿险 3=年金险|INDEX|
|**sub_type**|tinyint|||增额寿/年金险子类型：1=分红型 2=固收型||
|**min_age**|int||NOT NULL|最小投保年龄（v1.8.9新增灵活配置）||
|**max_age**|int||NOT NULL|最大投保年龄（v1.8.9新增灵活配置）||
|**payment_years**|json||NOT NULL|支持的缴费年限数组（v1.8.9新增灵活配置）||
|**occupation_class**|tinyint||NOT NULL|支持的最高职业类别：2/4/6（v1.8.9新增灵活配置）||
|**payment_periods**|json||NOT NULL|支持的缴费周期数组（v1.8.10新增）：["yearly", "half_yearly", "quarterly", "monthly"]||
|**monthly_ratio**|decimal|6,4||月缴系数（v1.8.10新增）||
|**quarterly_ratio**|decimal|6,4||季缴系数（v1.8.10新增）||
|**half_yearly_ratio**|decimal|6,4||半年缴系数（v1.8.10新增）||
|**sale_status**|tinyint||DEFAULT 1|**销售状态（v1.8.12新增）**：0=已停售 1=正常在售 2=预售中|INDEX|
|**system_status**|tinyint||DEFAULT 0|**系统状态（v1.8.12新增）**：0=未上架 1=已上架|INDEX|
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||

### 8.3 insurance_company（保险公司表 - v1.8.12 保留）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**company_id**|bigint||PK|主键ID|PRIMARY|
|**company_name**|varchar|200||NOT NULL|保险公司全称||
|**company_short_name**|varchar|50||NOT NULL|简称（如：复星联合、光大永明）||
|**company_code**|varchar|50||UNIQUE|保险公司唯一编码|UNIQUE|
|**logo_url**|varchar|500||Logo图片URL||
|**official_website**|varchar|200||官方网站地址||
|**service_phone**|varchar|20||客服热线电话||
|**established_year**|int||成立年份||
|**registered_capital**|decimal|15,2||注册资本（单位：亿元）||
|**headquarters**|varchar|100||总部所在城市||
|**company_type**|tinyint||NOT NULL|公司类型：1=中资 2=合资 3=外资||
|**credit_rating**|varchar|20||风险综合评级（AAA/AA/A/BBB）||
|**solvency_ratio**|decimal|5,2||综合偿付能力充足率（%）||
|**introduction**|text||公司详细简介||
|**feature_tags**|json||特色标签数组：["理赔快", "核保宽松", "服务好"]||
|**cooperation_status**|tinyint||DEFAULT 1|合作状态：0=已终止 1=合作中 2=待接入|INDEX|
|**cooperation_start_date**|date||正式合作开始日期||
|**sort_order**|int||DEFAULT 0|显示排序权重||
|**is_hot**|tinyint||DEFAULT 0|是否热门推荐：0=否 1=是|INDEX|
|**remark**|varchar|500||内部备注说明||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||

### 8.4 company_rating_history（风险评级历史表 - v1.8.12 新增）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**history_id**|bigint||PK|主键ID|PRIMARY|
|**company_id**|bigint||FK NOT NULL|关联保险公司ID|INDEX|
|**rating_quarter**|varchar|10||NOT NULL|评级季度，格式："2026Q1"||
|**credit_rating**|varchar|20||NOT NULL|风险综合评级：AAA/AA/A/BBB/BB/B/C||
|**solvency_ratio**|decimal|8,2||NOT NULL|综合偿付能力充足率（%）||
|**core_solvency_ratio**|decimal|8,2||核心偿付能力充足率（%）||
|**net_profit**|decimal|15,2||季度净利润（单位：亿元）||
|**premium_income**|decimal|15,2||季度保费收入（单位：亿元）||
|**publish_date**|date||官方数据发布日期||
|**remark**|varchar|500||备注说明||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
**唯一索引**：(company_id, rating_quarter)

### 8.5 card_template（卡片模板表 - v1.8.13 升级）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**template_id**|bigint||PK|主键|PRIMARY|
|**template_name**|varchar|100||NOT NULL|模板名称||
|**category_code**|varchar|50||NOT NULL|分类编码（10大分类，v1.8.13新增）|INDEX|
|**tags**|json|||标签数组，如["亲子","存钱罐","温馨"]（v1.8.13新增）||
|**ai_prompt**|text|||AI生图提示词（v1.8.13新增）||
|**search_keywords**|varchar|500|||搜索关键词（名称+标签合并，v1.8.13新增）||
|**background_url**|varchar|500||NOT NULL|背景图URL||
|**default_title**|varchar|200|||默认标题||
|**default_subtitle**|varchar|200|||默认副标题||
|**is_system**|tinyint||DEFAULT 1|是否系统预设||
|**is_recommended**|tinyint||DEFAULT 0|是否推荐（⭐标记）||
|**use_count_7d**|int||DEFAULT 0|近7天使用次数||
|**use_count_30d**|int||DEFAULT 0|近30天使用次数||
|**use_count_total**|int||DEFAULT 0|累计总使用次数||
|**last_used_time**|datetime|||最后使用时间||
|**sort_order**|int||DEFAULT 0|排序||
|**is_active**|tinyint||DEFAULT 1|是否启用||

### 8.6 critical_illness_product（重疾险子类表 - v1.8.9 更新）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK|关联product_base|UNIQUE|
|**waiting_period**|int||NOT NULL|等待期天数：30/60/90/180/360（v1.8.9新增灵活配置）||
|**waiting_period_rule**|tinyint||NOT NULL|等待期规则：1=返还保费 2=不承担责任||
|**critical_count**|int||NOT NULL|重疾赔付次数（v1.8.9新增灵活配置）||
|**critical_ratio**|int||NOT NULL|重疾赔付比例（%）||
|**medium_count**|int||NOT NULL|中症赔付次数（v1.8.9新增灵活配置）||
|**medium_ratio**|int||NOT NULL|中症赔付比例（%）||
|**light_count**|int||NOT NULL|轻症赔付次数（v1.8.9新增灵活配置）||
|**light_ratio**|int||NOT NULL|轻症赔付比例（%）||
|**critical_multi_interval**|int|||重疾多次间隔期天数（v1.8.9新增灵活配置）||
|**cancer_multi_interval**|int|||癌症二次间隔期天数（v1.8.9新增灵活配置）||
|**cvd_multi_interval**|int|||心脑血管二次间隔期天数（v1.8.9新增灵活配置）||
|**disease_care_age**|int|||疾病关爱金年龄节点（v1.8.9新增灵活配置）||
|**disease_care_critical_ratio**|int|||重疾额外赔付比例（%）（v1.8.9新增灵活配置）||
|**disease_care_medium_ratio**|int|||中症额外赔付比例（%）（v1.8.9新增灵活配置）||
|**disease_care_light_ratio**|int|||轻症额外赔付比例（%）（v1.8.9新增灵活配置）||

### 8.7 whole_life_product（增额终身寿险子类表 - v1.8.9 更新）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK|关联product_base|UNIQUE|
|**reduction_rule_type**|tinyint||NOT NULL|减保规则：1=20%保额 2=20%已交保费 3=无限制（v1.8.9新增）||
|**reduction_start_year**|int|||减保起始年限（v1.8.9新增灵活配置）||
|**reduction_times_limit**|int|||每年减保次数限制（v1.8.9新增灵活配置）||
|**max_add_age**|int||NOT NULL|最高加保年龄（v1.8.9新增灵活配置）||
|**add_premium_rule**|tinyint||NOT NULL|加保费率规则：1=投保时年龄 2=加保时年龄||
|**add_times_limit**|int|||每年加保次数限制（v1.8.9新增灵活配置）||
|**add_ratio_limit**|int|||每次加保比例限制（%）（v1.8.9新增灵活配置）||
|**loan_ratio**|decimal(5,2)||NOT NULL|保单贷款比例（%）（v1.8.9新增灵活配置）||
|**loan_rate**|decimal(5,2)||NOT NULL|保单贷款利率（%）（v1.8.9新增灵活配置）||
|**increase_rate**|decimal(5,2)||NOT NULL|保额年递增比例（%）（v1.8.9新增灵活配置）||
|**increase_end_age**|int|||递增终止年龄（v1.8.9新增灵活配置）||
|**support_age_list**|json||NOT NULL|支持的减保起始年龄数组||

### 8.8 annuity_product（年金险子类表 - v1.8.9 更新）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK|关联product_base|UNIQUE|
|**start_age_female**|json||NOT NULL|女性支持的起始年龄数组（v1.8.9新增灵活配置）||
|**start_age_male**|json||NOT NULL|男性支持的起始年龄数组（v1.8.9新增灵活配置）||
|**support_monthly**|tinyint||DEFAULT 1|是否支持月领||
|**monthly_coefficient**|decimal(5,3)||NOT NULL|月领系数（v1.8.9新增灵活配置）||
|**guarantee_options**|json||NOT NULL|保证领取期选项数组（v1.8.9新增灵活配置）||
|**support_increase**|tinyint||DEFAULT 0|是否支持递增领取||
|**increase_rate_options**|json|||递增比例选项数组（v1.8.9新增灵活配置）||
|**increase_end_year**|int|||递增终止年限（v1.8.9新增灵活配置）||

### 8.9 annuity_birthday_bonus（祝寿金配置表 - v1.8.8 新增）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**bonus_id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK NOT NULL|关联年金险产品ID|INDEX|
|**bonus_age**|int||NOT NULL|祝寿金领取年龄（如：80、66、77、88等）||
|**bonus_type**|tinyint||NOT NULL|1=按已交保费比例 2=按保额比例 3=固定金额||
|**bonus_value**|decimal(10,2)||NOT NULL|比例值或固定金额值||
|**bonus_desc**|varchar|200||显示描述||
|**is_active**|tinyint||DEFAULT 1|是否启用||
|**sort_order**|int||DEFAULT 0|显示排序||
|**create_time**|datetime|||创建时间||
|**update_time**|datetime|||更新时间||
**唯一索引**：(product_id, bonus_age)

**⚠️ 字段命名不一致（v1.8.18发现）**：本表使用 `create_time`/`update_time`，而其他表使用 `created_at`/`updated_at`。建议统一为 `created_at`/`updated_at`。

### 8.10 user_info（用户信息表）【v1.8.18新增 - 代码已实现】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**user_id**|bigint||PK|主键ID，ASSIGN_ID策略|PRIMARY|
|**username**|varchar|50||NOT NULL|用户名|UNIQUE|
|**password**|varchar|100||NOT NULL|BCrypt加密后的密码||
|**nickname**|varchar|50|||用户昵称||
|**avatar_url**|varchar|500|||头像URL||
|**phone**|varchar|20|||手机号||
|**email**|varchar|100|||邮箱||
|**gender**|tinyint||DEFAULT 0|性别：0-未知 1-男 2-女||
|**birthday**|date|||出生日期||
|**wechat_openid**|varchar|50|||微信OpenID|INDEX|
|**wechat_unionid**|varchar|50|||微信UnionID|INDEX|
|**wechat_nickname**|varchar|50|||微信昵称||
|**wechat_avatar**|varchar|500|||微信头像URL||
|**wechat_bound**|tinyint||DEFAULT 0|是否绑定微信：0-未绑定 1-已绑定|INDEX|
|**member_level**|tinyint||DEFAULT 0|会员等级：0-普通 1-VIP 2-SVIP|INDEX|
|**member_expire_time**|datetime|||会员过期时间||
|**status**|tinyint||DEFAULT 1|账号状态：0-禁用 1-正常|INDEX|
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||

### 8.11 user_vip_record（VIP购买记录表）【v1.8.18新增 - 代码已实现】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**record_id**|bigint||PK|主键ID，ASSIGN_ID策略|PRIMARY|
|**user_id**|bigint||FK NOT NULL|关联用户ID|INDEX|
|**member_level**|tinyint||NOT NULL|购买等级：1-VIP 2-SVIP||
|**purchase_amount**|decimal|10,2||NOT NULL|购买金额（元）||
|**expire_time**|datetime||NOT NULL|过期时间||
|**purchase_time**|datetime||NOT NULL|购买时间||
|**order_no**|varchar|64|||订单编号|UNIQUE|
|**pay_type**|tinyint||DEFAULT 1|支付方式：1-微信 2-支付宝||
|**status**|tinyint||DEFAULT 0|订单状态：0-未支付 1-已支付 2-已退款|INDEX|
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||

### 8.12 admin_user（管理员表）【v1.8.18新增 - 代码已实现】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**admin_id**|bigint||PK|主键ID|PRIMARY|
|**username**|varchar|50||NOT NULL|管理员用户名|UNIQUE|
|**password**|varchar|100||NOT NULL|BCrypt加密后的密码||
|**real_name**|varchar|50|||真实姓名||
|**phone**|varchar|20|||手机号||
|**email**|varchar|100|||邮箱||
|**avatar_url**|varchar|500|||头像URL||
|**role_id**|bigint||FK|关联角色ID|INDEX|
|**status**|tinyint||DEFAULT 1|状态：0-禁用 1-正常|INDEX|
|**last_login_time**|datetime|||最后登录时间||
|**last_login_ip**|varchar|50|||最后登录IP||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||

### 8.13 admin_role（管理员角色表）【v1.8.18新增 - 代码已实现】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**role_id**|bigint||PK|主键ID|PRIMARY|
|**role_code**|varchar|50||NOT NULL|角色编码|UNIQUE|
|**role_name**|varchar|50||NOT NULL|角色名称||
|**description**|varchar|200|||角色描述||
|**status**|tinyint||DEFAULT 1|状态：0-禁用 1-正常||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||

### 8.14 admin_permission（管理员权限表）【v1.8.18新增 - 代码已实现】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**permission_id**|bigint||PK|主键ID|PRIMARY|
|**permission_code**|varchar|100||NOT NULL|权限编码|UNIQUE|
|**permission_name**|varchar|50||NOT NULL|权限名称||
|**parent_id**|bigint||DEFAULT 0|父权限ID||
|**permission_type**|tinyint||NOT NULL|权限类型：1-菜单 2-按钮 3-接口||
|**path**|varchar|200|||权限路径（菜单URL或接口路径）||
|**sort_order**|int||DEFAULT 0|排序||
|**status**|tinyint||DEFAULT 1|状态：0-禁用 1-正常||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||

### 8.15 admin_role_permission（角色权限关联表）【v1.8.18新增 - 代码已实现】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**id**|bigint||PK|主键ID|PRIMARY|
|**role_id**|bigint||FK NOT NULL|角色ID|INDEX|
|**permission_id**|bigint||FK NOT NULL|权限ID|INDEX|
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||

### 8.16 premium_rate（重疾险费率表）【v1.8.18更新 - 代码已实现】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**rate_id**|bigint||PK|主键ID|PRIMARY|
|**product_id**|bigint||FK NOT NULL|关联产品ID|INDEX|
|**combo_code**|varchar|50|||组合编码||
|**gender**|tinyint||NOT NULL|性别：0-女 1-男|INDEX|
|**age**|int||NOT NULL|投保年龄|INDEX|
|**payment_year**|int||NOT NULL|缴费年限|INDEX|
|**premium_per_k**|decimal|10,4||NOT NULL|每千元保额保费||
|**health_status**|tinyint||DEFAULT 0|健康状态：0-标准体 1-非标体||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||
**唯一索引**：(product_id, combo_code, gender, age, payment_year)

### 8.17 whole_life_rate（增额终身寿险费率表）【v1.8.18新增 - 代码已实现】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**rate_id**|bigint||PK|主键ID|PRIMARY|
|**product_id**|bigint||FK NOT NULL|关联产品ID|INDEX|
|**gender**|tinyint||NOT NULL|性别：0-女 1-男|INDEX|
|**age**|int||NOT NULL|投保年龄|INDEX|
|**payment_year**|int||NOT NULL|缴费年限|INDEX|
|**policy_year**|int||NOT NULL|保单年度|INDEX|
|**cash_value**|decimal|15,2|||现金价值||
|**death_benefit**|decimal|15,2|||身故保险金||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||

### 8.18 annuity_rate（年金险费率表）【v1.8.18新增 - 代码已实现 · v1.8.20扩展字段】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**rate_id**|bigint||PK|主键ID|PRIMARY|
|**product_id**|bigint||FK NOT NULL|关联产品ID|INDEX|
|**gender**|tinyint||NOT NULL|性别：0-女 1-男|INDEX|
|**age**|int||NOT NULL|投保年龄|INDEX|
|**payment_year**|int||NOT NULL|缴费年限|INDEX|
|**start_age**|int||NULL|领取年龄（养老年金使用）|INDEX【v1.8.20新增】|
|**plan_id**|varchar|50||NULL|产品计划（分红年金多计划使用）|INDEX【v1.8.20新增】|
|**policy_year**|int||NOT NULL|保单年度|INDEX|
|**annual_payout**|decimal|15,2|||年度领取金额（每千元保费）||
|**cash_value**|decimal|15,2|||现金价值（每千元保费）||
|**death_benefit**|decimal|15,2|||身故保险金（每千元保费）||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||

> **唯一索引**：`(product_id, gender, age, payment_year, start_age, plan_id, policy_year)`

### 8.19 重疾险责任配置相关表

#### 8.10.1 responsibility_category（一级分类表）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**category_id**|bigint||PK|主键|PRIMARY|
|**category_code**|varchar|50||UNIQUE|分类编码|UNIQUE|
|**category_name**|varchar|100||NOT NULL|分类名称||
|**sort_order**|int||DEFAULT 0|显示排序||
|**is_active**|tinyint||DEFAULT 1|是否启用||

#### 8.10.2 responsibility_item（二级责任项表）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**item_id**|bigint||PK|主键|PRIMARY|
|**category_id**|bigint||FK|关联一级分类ID|INDEX|
|**item_code**|varchar|50||UNIQUE|责任项编码|UNIQUE|
|**item_name**|varchar|100||NOT NULL|责任项名称||
|**options**|json||NOT NULL|选项列表||
|**sort_order**|int||DEFAULT 0|分类内排序||
|**is_system**|tinyint||DEFAULT 1|是否系统预设||
|**is_active**|tinyint||DEFAULT 1|是否启用||

#### 8.10.3 product_responsibility（产品-责任关联表）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK|产品ID|INDEX|
|**item_id**|bigint||FK|关联责任项ID|INDEX|
|**is_supported**|tinyint||DEFAULT 1|产品是否支持此责任||
|**supported_options**|json||NOT NULL|产品支持的选项子集||
|**default_option**|varchar|50||NOT NULL|默认选项||
|**premium_coefficient**|json||NOT NULL|各选项保费系数||
|**sort_order**|int||DEFAULT 0|产品内排序||

#### 8.10.4 product_encoding_map（产品编码映射表）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**map_id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK|关联产品ID|INDEX|
|**resp_category**|varchar|20||NOT NULL|STANDARD/SPECIAL||
|**resp_code**|varchar|50||NOT NULL|责任编码|INDEX|
|**resp_name**|varchar|100||NOT NULL|责任显示名称||
|**bit_position**|int||NOT NULL|分配的位位置（0-31）||
|**bit_mask**|int||NOT NULL|位掩码||
|**options**|json||NOT NULL|该责任的选项列表||
|**is_active**|tinyint||DEFAULT 1|是否启用||
**唯一索引**：(product_id, resp_code)

### 8.11 费率计算相关表

#### 8.11.1 premium_rate（重疾险费率主表）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**rate_id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK|关联重疾险产品ID|INDEX|
|**combo_code**|int||NOT NULL|责任组合编码|INDEX|
|**gender**|tinyint||NOT NULL|1=男，2=女|INDEX|
|**age**|int||NOT NULL|投保年龄（0-70）|INDEX|
|**payment_year**|int||NOT NULL|缴费年限|INDEX|
|**premium_per_k**|decimal(10,2)||NOT NULL|每千元保额年交保费||
|**health_status**|tinyint||DEFAULT 1|健康体况等级（1-7）||
**唯一索引**：(product_id, combo_code, gender, age, payment_year, health_status)

#### 8.11.2 whole_life_rate（增额终身寿险费率表）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**rate_id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK|关联增额终身寿险产品ID|INDEX|
|**gender**|tinyint||NOT NULL|1=男，2=女|INDEX|
|**age**|int||NOT NULL|投保年龄（0-70）|INDEX|
|**payment_year**|int||NOT NULL|缴费年限|INDEX|
|**policy_year**|int||NOT NULL|保单年度|INDEX|
|**cash_value**|decimal(15,2)||NOT NULL|每万元保费对应现金价值||
|**death_benefit**|decimal(15,2)|||身故保险金||
**唯一索引**：(product_id, gender, age, payment_year, policy_year)

#### 8.11.3 annuity_rate（年金险费率表）
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**rate_id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK|关联年金险产品ID|INDEX|
|**gender**|tinyint||NOT NULL|1=男，2=女|INDEX|
|**age**|int||NOT NULL|投保年龄（0-70）|INDEX|
|**payment_year**|int||NOT NULL|缴费年限|INDEX|
|**policy_year**|int||NOT NULL|保单年度|INDEX|
|**annual_payout**|decimal(15,2)|||年领取金额||
|**cash_value**|decimal(15,2)|||现金价值||
|**death_benefit**|decimal(15,2)|||身故保险金||
**唯一索引**：(product_id, gender, age, payment_year, policy_year)

#### 8.11.4 product_dividend_config（产品分红配置表）【v1.8.19新增】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**config_id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK NOT NULL|关联产品ID|UNIQUE|
|**scheduled_rate**|decimal|5,4||预定利率（如0.0250=2.5%）||
|**guaranteed_rate**|decimal|5,4||保证利率||
|**min_guaranteed_rate**|decimal|5,4||最低保证利率||
|**increase_rate**|decimal|5,4||增额比例（如0.0350=3.5%）||
|**dividend_low_rate**|decimal|5,4||分红演示-低档利率||
|**dividend_mid_rate**|decimal|5,4||分红演示-中档利率||
|**dividend_high_rate**|decimal|5,4||分红演示-高档利率||
|**dividend_assumed_rate**|decimal|5,4||假定分红利率||
|**universal_settle_rate**|decimal|5,4||万能结算利率||
|**min_settle_rate**|decimal|5,4||最低结算利率||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||
**唯一索引**：(product_id)

#### 8.11.5 whole_life_dividend_rate（增额终身寿险分红演示表）【v1.8.19新增】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**rate_id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK NOT NULL|关联增额终身寿险产品ID|INDEX|
|**gender**|tinyint||NOT NULL|0=女，1=男|INDEX|
|**age**|int||NOT NULL|投保年龄|INDEX|
|**payment_year**|int||NOT NULL|缴费年限|INDEX|
|**policy_year**|int||NOT NULL|保单年度|INDEX|
|**cash_value_guaranteed**|decimal|15,2||保证部分现金价值||
|**cash_value_mid_dividend**|decimal|15,2||含中档分红现金价值||
|**cash_value_high_dividend**|decimal|15,2||含高档分红现金价值||
|**death_benefit_guaranteed**|decimal|15,2||保证部分身故保险金||
|**death_benefit_mid_dividend**|decimal|15,2||含中档分红身故保险金||
|**death_benefit_high_dividend**|decimal|15,2||含高档分红身故保险金||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||
**唯一索引**：(product_id, gender, age, payment_year, policy_year)

#### 8.11.6 annuity_dividend_rate（年金险分红演示表）【v1.8.19新增】
|字段名|数据类型|长度|约束|说明|索引|
|---|---|---|---|---|---|
|**rate_id**|bigint||PK|主键|PRIMARY|
|**product_id**|bigint||FK NOT NULL|关联年金险产品ID|INDEX|
|**gender**|tinyint||NOT NULL|0=女，1=男|INDEX|
|**age**|int||NOT NULL|投保年龄|INDEX|
|**payment_year**|int||NOT NULL|缴费年限|INDEX|
|**policy_year**|int||NOT NULL|保单年度|INDEX|
|**annual_payout_guaranteed**|decimal|15,2||保证部分年领取金额||
|**annual_payout_mid_dividend**|decimal|15,2||含中档分红年领取金额||
|**annual_payout_high_dividend**|decimal|15,2||含高档分红年领取金额||
|**cash_value_guaranteed**|decimal|15,2||保证部分现金价值||
|**cash_value_mid_dividend**|decimal|15,2||含中档分红现金价值||
|**cash_value_high_dividend**|decimal|15,2||含高档分红现金价值||
|**death_benefit_guaranteed**|decimal|15,2||保证部分身故保险金||
|**death_benefit_mid_dividend**|decimal|15,2||含中档分红身故保险金||
|**death_benefit_high_dividend**|decimal|15,2||含高档分红身故保险金||
|**created_at**|datetime||DEFAULT CURRENT_TIMESTAMP|创建时间||
|**updated_at**|datetime||DEFAULT CURRENT_TIMESTAMP ON UPDATE|更新时间||
**唯一索引**：(product_id, gender, age, payment_year, policy_year)

---

## 9. 技术架构完整设计

### 9.1 系统整体架构设计

#### 9.1.1 分层架构图
```
┌─────────────────────────────────────────────────────────┐
│                    客户端层                              │
│  PC Web (Vue3)  │  微信小程序  │  管理后台 (Vue3)       │
└───────────────────┬─────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────┐
│                    网关层 (Nginx)                        │
│  反向代理  │  负载均衡  │  静态资源  │  SSL终止         │
└───────────────────┬─────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────┐
│                  应用服务层 (Spring Boot 3.3)            │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐        │
│  │ 产品服务   │  │ 用户服务   │  │ 卡片服务   │        │
│  └────────────┘  └────────────┘  └────────────┘        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐        │
│  │ 对比服务   │  │ 保司服务   │  │ VIP服务    │        │
│  └────────────┘  └────────────┘  └────────────┘        │
└───────────────────┬─────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────┐
│                  数据存储层                              │
│  MySQL 8.0  │  Redis 7.x  │  本地文件存储               │
└─────────────────────────────────────────────────────────┘
```

#### 9.1.2 技术栈完整清单

**前端技术栈（PC Web + 管理后台）：**
|技术|版本|用途|
|-|-|-|
|Vue|3.4.x|前端框架|
|TypeScript|5.4.x|类型系统|
|Vite|5.x|构建工具|
|Element Plus|2.7.x|UI组件库|
|ECharts|5.5.x|图表库|
|Pinia|2.x|状态管理|
|Vue Router|4.x|路由管理|
|Axios|1.7.x|HTTP请求|
|html2canvas|1.4.1|卡片生成|
|dayjs|1.x|日期处理|

**前端技术栈（微信小程序）：**
|技术|版本|用途|
|-|-|-|
|微信原生小程序|最新|小程序框架|
|Vant Weapp|1.x|UI组件库|
|wx-charts|最新|图表库|

**后端技术栈：**
|技术|版本|用途|
|-|-|-|
|JDK|21 LTS|Java运行环境|
|Spring Boot|3.3.x|后端框架|
|Spring Security|6.x|安全框架|
|MyBatis Plus|3.5.x|ORM框架|
|MySQL|8.0|关系型数据库|
|Redis|7.x|缓存+会话|
|Knife4j|4.x|API文档|
|Hutool|5.x|工具类库|
|EasyExcel|3.x|Excel导入导出|
|Apache PDFBox|2.x|PDF解析|

#### 9.1.3 项目目录结构【v1.8.18更新 - 与实际代码同步】

**后端项目结构（Maven多模块）：**
```
insurance-backend/
├── insurance-common/              # 公共模块（枚举/异常/工具类/Result封装）
│   ├── src/main/java/com/insurance/common/
│   │   ├── constant/              # 常量定义
│   │   ├── enums/                 # 枚举定义
│   │   ├── exception/             # 异常定义
│   │   ├── result/                # 统一返回结果
│   │   └── utils/                 # 工具类
│
├── insurance-admin/               # 管理后台API（端口8081）
│   ├── src/main/java/com/insurance/admin/
│   │   ├── auth/                  # 管理端认证
│   │   ├── controller/            # Controller层
│   │   ├── service/               # Service层
│   │   ├── mapper/                # Mapper层
│   │   └── entity/                # 实体类
│
├── insurance-api/                 # 客户端API（端口8080）
│   ├── src/main/java/com/insurance/api/
│   │   ├── auth/                  # 用户认证
│   │   ├── calculate/             # 费率计算
│   │   ├── card/                  # 卡片模板
│   │   ├── company/               # 保险公司
│   │   ├── compare/               # 产品对比
│   │   ├── product/               # 产品管理
│   │   ├── user/                  # 用户中心
│   │   ├── vip/                   # VIP会员
│   │   ├── wechat/                # 微信登录
│   │   ├── entity/                # 实体类
│   │   └── mapper/                # Mapper层
│
├── insurance-framework/           # 框架配置
│   ├── src/main/java/com/insurance/framework/
│   │   ├── config/                # 配置类（CORS/MyBatis-Plus/Knife4j）
│   │   ├── security/              # 安全配置（JWT/SecurityConfig）
│   │   ├── interceptor/           # 拦截器
│   │   └── aspect/                # AOP切面
│
└── insurance-deploy/              # 部署配置【v1.8.18新增】
    ├── docker-compose.yml         # Docker编排
    ├── Dockerfile-api             # API服务镜像
    ├── Dockerfile-admin           # Admin服务镜像
    └── init-sql/                  # 数据库初始化脚本
        ├── 01_create_database.sql
        ├── 02_create_tables.sql
        ├── 03_init_data.sql
        ├── 04_import_companies.sql
        ├── 05_import_products.sql
        ├── 06_wechat_fields.sql
        └── 07_card_background_import.sql
```

**前端项目结构（insurance-web）：**
```
insurance-web/
├── src/
│   ├── api/                       # API接口定义
│   │   ├── auth.ts                # 认证相关
│   │   ├── card.ts                # 卡片模板
│   │   ├── company.ts             # 保险公司
│   │   ├── compare.ts             # 产品对比
│   │   ├── calculate.ts           # 费率计算
│   │   ├── product.ts             # 产品管理
│   │   ├── vip.ts                 # VIP会员
│   │   └── request.ts             # Axios封装
│   ├── assets/                    # 静态资源
│   ├── components/                # 公共组件
│   │   └── business/              # 业务组件【v1.8.18新增】
│   │       ├── BackgroundSelector.vue    # 背景图选择器
│   │       ├── BenefitTable.vue          # 利益演示表
│   │       ├── BirthdayBonus.vue         # 祝寿金
│   │       ├── CardGenerator.vue         # 卡片生成器
│   │       ├── CompareTable.vue          # 对比表格
│   │       ├── DiseaseList.vue           # 疾病列表
│   │       ├── DividendSelector.vue      # 分红选择器
│   │       ├── PayoutPlan.vue            # 领取计划
│   │       ├── PremiumCalculator.vue     # 保费计算器
│   │       ├── ProductCard.vue           # 产品卡片
│   │       ├── ResponsibilityConfig.vue  # 责任配置
│   │       └── WithdrawalPlan.vue        # 减保计划
│   ├── layouts/                   # 布局组件
│   │   ├── MainLayout.vue         # 主布局（含导航）
│   │   └── AuthLayout.vue         # 认证布局
│   ├── router/                    # 路由配置
│   ├── store/                     # Pinia状态管理
│   │   ├── userStore.ts           # 用户状态
│   │   ├── productStore.ts        # 产品状态
│   │   └── compareStore.ts        # 对比状态
│   ├── utils/                     # 工具函数
│   ├── views/                     # 页面组件
│   │   ├── home/                  # 首页
│   │   ├── product/               # 产品模块
│   │   ├── compare/               # 对比模块
│   │   ├── card/                  # 卡片生成模块
│   │   ├── user/                  # 用户中心
│   │   └── vip/                   # VIP会员
│   ├── composables/               # 组合式函数【v1.8.18新增】
│   │   ├── useAuth.ts             # 认证逻辑
│   │   ├── useCardExport.ts       # 卡片导出（html2canvas）
│   │   ├── usePermission.ts       # VIP权限判断
│   │   └── useProduct.ts          # 产品相关逻辑
│   └── App.vue
```

### 9.2 数据库设计规范

#### 9.2.1 命名规范
**表命名规则：**
- 全部小写，下划线分隔
- 业务前缀：`product_` / `user_` / `card_` / `company_`
- 示例：`product_base`、`user_info`、`card_template`、`insurance_company`

**字段命名规则：**
- 全部小写，下划线分隔
- 主键：`表名_id`（如：`product_id`、`company_id`）
- 布尔型：`is_`前缀（如：`is_active`、`is_hot`、`is_deleted`）
- 时间字段：`_at`后缀（如：`created_at`、`updated_at`、`publish_at`）
- 状态字段：`_status`后缀（如：`sale_status`、`system_status`）
- 外键字段：关联表名 + `_id`（如：`company_id`、`product_id`）

#### 9.2.2 索引设计规范
**必建索引规则：**
1. 主键索引：PRIMARY KEY
2. 外键索引：所有外键字段必须建立普通索引
3. 唯一索引：编码类字段建立UNIQUE索引（如：`product_code`、`company_code`）
4. 常用查询字段：`status`、`type`、`category`等筛选字段
5. 排序字段：`sort_order`、`created_at`等排序字段

**索引示例（product_base表）：**
```sql
PRIMARY KEY (product_id)
UNIQUE KEY uk_product_code (product_code)
INDEX idx_company_id (company_id)
INDEX idx_product_type (product_type)
INDEX idx_sale_status (sale_status)
INDEX idx_system_status (system_status)
INDEX idx_created_at (created_at DESC)
```

#### 9.2.3 字段设计规范
**通用字段（所有业务表必备）：**
```sql
created_at  datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
updated_at  datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
created_by  bigint       DEFAULT NULL COMMENT '创建人ID'
updated_by  bigint       DEFAULT NULL COMMENT '更新人ID'
is_deleted  tinyint(1)   DEFAULT 0 COMMENT '是否删除 0否 1是'
```

**状态字段统一设计：**
```sql
*_status   tinyint(1)   NOT NULL DEFAULT 1 COMMENT '状态 0禁用 1启用'
```

#### 9.2.4 完整SQL建表规范
**建表标准模板：**
```sql
CREATE TABLE `table_name` (
  `xxx_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  -- 业务字段定义...
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `updated_by` bigint DEFAULT NULL COMMENT '更新人ID',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除 0否 1是',
  PRIMARY KEY (`xxx_id`),
  UNIQUE KEY `uk_xxx_code` (`xxx_code`),
  KEY `idx_xxx_field` (`xxx_field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='表注释';
```

### 9.3 API接口设计规范

#### 9.3.1 统一返回格式
```json
{
  "code": 200,
  "message": "操作成功",
  "data": {},
  "timestamp": 1718000000000
}
```

**状态码规范：**
|code|说明|
|-|-|
|200|请求成功|
|400|请求参数错误|
|401|未登录/Token失效|
|403|无权限访问|
|404|资源不存在|
|500|服务器内部错误|

#### 9.3.2 RESTful API规范
**URL命名规则：**
- 全部小写，kebab-case命名风格
- 版本前缀：`/api/v1/`
- 管理端接口前缀：`/api/v1/admin/`
- 客户端接口前缀：`/api/v1/`

**HTTP方法规范：**
|方法|用途|示例|
|-|-|-|
|GET|查询资源|GET /api/v1/products|
|POST|新增资源|POST /api/v1/products|
|PUT|修改资源|PUT /api/v1/products/{id}|
|DELETE|删除资源|DELETE /api/v1/products/{id}|

#### 9.3.3 分页查询规范
**请求参数：**
```
GET /api/v1/products?pageNum=1&pageSize=20&keyword=xxx&status=1
```

**返回格式：**
```json
{
  "code": 200,
  "data": {
    "list": [],
    "total": 100,
    "pageNum": 1,
    "pageSize": 20,
    "pages": 5
  }
}
```

#### 9.3.4 接口权限控制
**注解式权限控制：**
```java
// 管理员权限接口
@RequiresPermissions("product:list")
@GetMapping("/admin/products")

// 需登录接口
@RequiresLogin
@GetMapping("/user/info")

// 公开接口（无需登录）
@Anonymous
@GetMapping("/products/list")
```

### 9.4 安全设计规范【v1.8.18更新 - 补充安全问题修正】

#### 9.4.1 认证与授权
**JWT Token认证机制：**
- Access Token：有效期2小时
- Refresh Token：有效期7天
- Token存储：Redis白名单机制
- 强制下线：删除Redis中对应Token实现

**密码加密规范：**
- BCrypt加密，强度系数12
- 禁止明文存储密码
- 密码错误5次自动锁定30分钟

**⚠️ 已知安全问题（需修复）：**
1. **SecurityConfig白名单过大**：当前几乎所有业务接口都在permitAll白名单中，包括 `/api/v1/product/**`、`/api/v1/company/**`、`/api/v1/card-template/**`、`/api/v1/vip/**`、`/api/v1/compare/**`、`/api/v1/calculate/**`。这意味着这些接口实际不强制JWT认证即可访问。
   - **修复方案**：将需要认证的接口从permitAll中移除，改为在Controller方法上使用 `@PreAuthorize("isAuthenticated()")` 注解

2. **JWT密钥硬编码**：密钥 `"insurance-backend-jwt-secret-key-2024-very-long-key"` 直接写在 JwtUtil.java 代码中
   - **修复方案**：将密钥移至 `application.yml` 配置文件中，通过 `${jwt.secret}` 注入，生产环境通过环境变量覆盖

3. **admin模块逻辑删除字段不一致**：admin模块使用 `deleted` 字段，api模块使用 `isDeleted` 字段
   - **修复方案**：统一为 `is_deleted`（数据库层面），实体类统一为 `isDeleted`（Java层面），MyBatis-Plus逻辑删除配置统一

#### 9.4.2 接口限流设计【v1.8.18新增】
**限流规则：**
| 接口类型 | 限流阈值 | 时间窗口 | 触发后行为 |
|---------|---------|---------|-----------|
| 登录接口 | 5次 | 1分钟/IP | 返回429，锁定30分钟 |
| 注册接口 | 3次 | 1分钟/IP | 返回429，需验证码 |
| 费率计算 | 30次 | 1分钟/用户 | 返回429，提示稍后再试 |
| 卡片生成 | 10次 | 1分钟/用户 | 返回429，VIP提升限额 |
| 产品列表 | 100次 | 1分钟/IP | 返回429 |
| 通用接口 | 1000次 | 1分钟/IP | 返回429 |

**实现方案：** 使用 Redis + 滑动窗口算法，Key格式：`rate_limit:{type}:{identifier}`

#### 9.4.3 参数校验
**后端双重校验：**
```java
// 长度校验
@Size(max = 200, message = "名称长度不能超过200字符")
// 非空校验
@NotBlank(message = "名称不能为空")
// 数值范围校验
@Range(min = 0, max = 100, message = "比例范围必须在0-100之间")
// 正则校验
@Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式错误")
```

**XSS防护：**
- 所有输入参数自动HTML转义
- 富文本内容采用白名单过滤
- 响应头设置X-XSS-Protection: 1; mode=block

**SQL注入防护：**
- 全部使用MyBatis Plus预编译机制
- 禁止字符串拼接SQL
- 模糊查询特殊字符自动转义

#### 9.4.4 文件上传安全（仅管理员可用）
**上传限制规则：**
- 仅允许管理员角色上传
- 文件类型白名单：jpg/png/gif/pdf/xlsx
- 文件大小限制：单文件最大10MB
- 文件名随机重命名，禁止使用原文件名
- 图片文件二次压缩，清除EXIF信息

**客户端上传限制：**
- 客户端所有上传入口永久关闭
- 客户仅可使用系统预设资源，不可上传任何文件

### 9.5 性能优化设计

#### 9.5.1 缓存策略
**Redis缓存层级设计：**
```
1. 产品详情缓存       →  过期时间1小时
2. 产品列表缓存       →  过期时间30分钟
3. 保险公司信息缓存   →  过期时间24小时
4. 卡片模板缓存       →  过期时间1小时
5. 用户会话缓存       →  过期时间2小时
6. 字典数据缓存       →  永久有效，更新时主动清除
```

**缓存更新机制：**
- 更新数据时主动删除对应缓存
- 采用Cache-Aside模式
- 缓存穿透防护：空值缓存5分钟

#### 9.5.2 数据库优化
**查询优化规则：**
- 禁止SELECT *，只查询需要字段
- 大表分页优化：采用id游标分页
- JOIN关联不超过3张表
- 复杂查询使用覆盖索引

**慢查询监控：**
- 超过500ms的SQL自动告警
- 定期EXPLAIN分析慢SQL并优化

#### 9.5.3 前端性能优化
**资源优化：**
- 路由懒加载
- 组件按需引入
- 图片WebP格式 + 懒加载
- Gzip压缩
- CDN加速静态资源

**首屏优化：**
- 首屏加载时间 < 1.5s
- 骨架屏占位
- 关键CSS内联

### 9.6 部署与运维

#### 9.6.1 Docker Compose部署配置
```yaml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_PASSWORD}
      TZ: Asia/Shanghai
    volumes:
      - ./mysql:/var/lib/mysql
    ports:
      - "3306:3306"
    restart: always
      
  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - ./redis:/data
    ports:
      - "6379:6379"
    restart: always
      
  backend:
    build: ./backend
    environment:
      SPRING_PROFILES_ACTIVE: prod
    ports:
      - "8080:8080"
    depends_on:
      - mysql
      - redis
    restart: always
      
  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./dist:/usr/share/nginx/html
      - ./ssl:/etc/nginx/ssl
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - backend
    restart: always
```

#### 9.6.2 日志规范
**日志分级：**
- ERROR：错误异常，需要立即告警处理
- WARN：警告信息，关注即可
- INFO：关键业务节点记录
- DEBUG：调试信息（生产环境关闭）

**日志格式：**
```
[%d{yyyy-MM-dd HH:mm:ss.SSS}] [%thread] [%-5level] %logger{50} - %msg%n
```

**日志归档策略：**
- 按天切割日志文件
- 保留最近30天日志
- 超过100M自动压缩

#### 9.6.3 监控告警
**核心监控指标：**
- 服务器：CPU/内存/磁盘使用率
- JVM：堆内存/GC次数/GC耗时
- MySQL：连接数/慢查询/QPS
- Redis：命中率/内存使用/连接数
- 应用：API响应时间/QPS/错误率

**告警机制：**
- 邮件告警通知
- 企业微信/钉钉群告警
- 三级告警阈值配置

### 9.7 前端与小程序兼容说明

#### 9.7.1 PC Web浏览器兼容
- Chrome >= 90
- Firefox >= 88
- Safari >= 14
- Edge >= 90
- 不支持IE系列浏览器

#### 9.7.2 微信小程序兼容
- 微信基础库版本 >= 2.20.0
- 微信客户端版本 >= 8.0
- iOS/Android全平台兼容

### 9.8 Docker部署方案【v1.8.18新增 - 与实际代码同步】

#### 9.8.1 docker-compose.yml配置
```yaml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    container_name: insurance-mysql
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: 1234
      MYSQL_DATABASE: tianbao_insurance
    volumes:
      - mysql_data:/var/lib/mysql
      - ./init-sql:/docker-entrypoint-initdb.d
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

  redis:
    image: redis:7-alpine
    container_name: insurance-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes

  api:
    build:
      context: ../insurance-backend
      dockerfile: ../insurance-deploy/Dockerfile-api
    container_name: insurance-api
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_NAME=tianbao_insurance
      - DB_USERNAME=root
      - DB_PASSWORD=1234
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - WECHAT_OPEN_APP_ID=${WECHAT_OPEN_APP_ID}
      - WECHAT_OPEN_APP_SECRET=${WECHAT_OPEN_APP_SECRET}
      - WECHAT_MP_APP_ID=${WECHAT_MP_APP_ID}
      - WECHAT_MP_APP_SECRET=${WECHAT_MP_APP_SECRET}
      - JWT_SECRET=${JWT_SECRET}
    depends_on:
      - mysql
      - redis

  admin:
    build:
      context: ../insurance-backend
      dockerfile: ../insurance-deploy/Dockerfile-admin
    container_name: insurance-admin
    ports:
      - "8081:8081"
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - DB_HOST=mysql
      - REDIS_HOST=redis
      - JWT_SECRET=${JWT_SECRET}
    depends_on:
      - mysql
      - redis

  nginx:
    image: nginx:alpine
    container_name: insurance-nginx
    ports:
      - "80:80"
    volumes:
      - ../insurance-web/dist:/usr/share/nginx/html/web
      - ../insurance-admin-web/dist:/usr/share/nginx/html/admin
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - api
      - admin

volumes:
  mysql_data:
  redis_data:
```

#### 9.8.2 数据库初始化脚本执行顺序
| 顺序 | 脚本文件 | 说明 |
|-----|---------|------|
| 1 | `01_create_database.sql` | 创建数据库 `tianbao_insurance` (utf8mb4) |
| 2 | `02_create_tables.sql` | 创建21张业务表 |
| 3 | `03_init_data.sql` | 初始化基础数据（责任分类、责任项等） |
| 4 | `04_import_companies.sql` | 导入保险公司数据 |
| 5 | `05_import_products.sql` | 导入产品基础数据 |
| 6 | `06_wechat_fields.sql` | 添加微信相关字段 |
| 7 | `07_card_background_import.sql` | 导入卡片背景数据 |

#### 9.8.3 环境变量配置
**生产环境必须通过环境变量注入的敏感配置：**
| 环境变量 | 说明 | 示例 |
|---------|------|------|
| `WECHAT_OPEN_APP_ID` | 微信开放平台AppID | wx_xxx |
| `WECHAT_OPEN_APP_SECRET` | 微信开放平台AppSecret | xxx |
| `WECHAT_MP_APP_ID` | 微信小程序AppID | wx_xxx |
| `WECHAT_MP_APP_SECRET` | 微信小程序AppSecret | xxx |
| `JWT_SECRET` | JWT签名密钥 | 随机生成的256位字符串 |
| `DB_PASSWORD` | 数据库密码 | 强密码 |
| `REDIS_PASSWORD` | Redis密码（如启用） | 强密码 |

---

## 10. API 接口规范

### 10.1 产品相关接口

#### 10.1.1 获取产品详情
```
GET /api/v1/product/{productId}
返回：ProductVO（产品完整信息，包含各险种专属字段、所有灵活配置项、缴费周期配置、双状态字段）
```

#### 10.1.2 产品列表查询（客户端 - 自动过滤状态）【已实现】
```
GET /api/v1/product/list?pageNum=1&pageSize=20&productName=&companyId=&productType=
WHERE条件：system_status = 1 AND sale_status IN (1, 2)
请求参数：
  - pageNum: 页码，默认1
  - pageSize: 每页条数，默认20
  - productName: 产品名称模糊搜索（可选）
  - companyId: 保险公司ID筛选（可选）
  - productType: 产品类型筛选 1-重疾/2-终身寿/3-年金（可选）
返回：PageResult<ProductVO>（分页产品列表，仅已上架且在售/预售产品）
```

#### 10.1.3 产品搜索【已实现】
```
GET /api/v1/product/search?keyword=xxx
请求参数：
  - keyword: 搜索关键词（产品名称/保险公司名称）
返回：List<ProductVO>
```

#### 10.1.4 获取热门产品【已实现】
```
GET /api/v1/product/hot?limit=8
请求参数：
  - limit: 返回数量，默认8
返回：List<ProductVO>
```

#### 10.1.5 获取产品类型列表【已实现】
```
GET /api/v1/product/types
返回：List<Map<String,Object>> [{"value":1,"label":"重疾险"},{"value":2,"label":"增额终身寿险"},{"value":3,"label":"年金险"}]
```

#### 10.1.6 获取产品责任配置【已实现】
```
GET /api/v1/product/{productId}/responsibilities
返回：ProductResponsibilityVO（产品责任配置，包含一级分类和二级责任项）
```

#### 10.1.7 产品列表查询（管理端 - 全量查询）
```
GET /api/v1/admin/product/list?productType=1&saleStatus=1&systemStatus=1&pageNum=1&pageSize=20
返回：全量产品列表，支持按双状态筛选
```

### 10.2 产品状态管理接口

#### 10.2.1 更新产品系统状态（上架/下架）
```
PUT /api/v1/admin/product/{productId}/system-status
{
  "systemStatus": 1  // 0=下架 1=上架
}
```

#### 10.2.2 更新产品销售状态
```
PUT /api/v1/admin/product/{productId}/sale-status
{
  "saleStatus": 1  // 0=停售 1=在售 2=预售
}
```

### 10.3 保险公司相关接口【已实现】

#### 10.3.1 获取保险公司列表
```
GET /api/v1/company/list?pageNum=1&pageSize=20&companyName=&companyType=
请求参数：
  - pageNum, pageSize: 分页
  - companyName: 公司名称模糊搜索（可选）
  - companyType: 公司类型 1-国企/2-民营/3-外资/4-合资（可选）
返回：PageResult<CompanyVO>
```

#### 10.3.2 获取保险公司详情
```
GET /api/v1/company/{companyId}
返回：CompanyVO（含公司基本信息、评级、偿付能力等）
```

#### 10.3.3 获取所有合作保险公司
```
GET /api/v1/company/all
返回：List<CompanyVO>
```

#### 10.3.4 获取保险公司最新评级
```
GET /api/v1/company/{companyId}/rating
返回：CompanyRatingVO
```

#### 10.3.5 获取保司数据看板统计（管理端）
```
GET /api/v1/admin/company/dashboard-stats
返回：核心指标概览数据
```

#### 10.3.6 保险公司综合排行榜（管理端）
```
GET /api/v1/admin/company/ranking?sortBy=rating&ratingFilter=AAA&pageNum=1&pageSize=20
返回：带颜色标记的排行榜数据
```

#### 10.3.7 获取保司风险评级历史（管理端）
```
GET /api/v1/admin/company/{companyId}/rating-history
返回：按季度倒序的评级历史列表
```

### 10.4 卡片模板相关接口（v1.8.13新增）【已实现】

#### 10.4.1 获取背景图库列表
```
GET /api/v1/card-template/list?categoryCode=EDUCATION&keyword=亲子&sortBy=hot&pageNum=1&pageSize=20
请求参数：
  - categoryCode: 分类编码（可选）
  - keyword: 搜索关键词（可选）
  - sortBy: 排序方式 hot-热度/new-最新（可选）
  - pageNum, pageSize: 分页
返回：PageResult<CardTemplateVO>
```

#### 10.4.2 获取背景模板详情
```
GET /api/v1/card-template/{templateId}
返回：CardTemplateVO（模板完整信息）
```

#### 10.4.3 记录模板使用
```
POST /api/v1/card-template/{templateId}/use
返回：CardTemplateUseVO { templateId, templateName, success, useCountTotal, usedTime }
说明：记录使用次数，更新热度统计
```

#### 10.4.4 生成展业卡片【待实现】
```
POST /api/v1/card/generate
请求体：
{
  "productIds": [1001],
  "templateId": 1,
  "watermarkConfig": {
    "enabled": true,
    "content": "张三",
    "opacity": 0.2,
    "density": "medium",
    "angle": 45,
    "fontSize": 16,
    "color": "black"
  },
  "minicodeConfig": {
    "enabled": true,
    "targetType": "profile",
    "customPath": "",
    "style": "rounded_white"
  },
  "resolution": "2x"
}
返回：{ cardId, downloadUrl, previewUrl, fileSize, width, height, generatedAt }
说明：前端已定义但后端尚未实现，卡片生成目前为纯前端实现（html2canvas）
```

#### 10.4.5 获取卡片生成历史【待实现】
```
GET /api/v1/card/history?pageNum=1&pageSize=10
返回：PageResult<CardHistoryVO>
说明：前端已定义但后端尚未实现
```

#### 10.4.6 删除卡片记录【待实现】
```
POST /api/v1/card/{cardId}/delete
返回：Boolean
说明：前端已定义但后端尚未实现
```

### 10.9 管理后台接口【v1.8.18新增 - 代码已实现】

#### 10.9.1 管理端登录
```
POST /api/v1/admin/auth/login
请求体：{ "username": "admin", "password": "xxx" }
返回：AdminLoginVO（含accessToken、adminInfo）
```

#### 10.9.2 获取管理端用户信息
```
GET /api/v1/admin/auth/info
认证：需管理员登录
返回：AdminInfoVO
```

#### 10.9.3 数据看板统计
```
GET /api/v1/admin/dashboard/stats
认证：需管理员登录
返回：DashboardStatsVO（核心指标概览：产品数、用户数、VIP数、卡片生成数等）
```

#### 10.9.4 VIP用户管理
```
GET /api/v1/admin/vip/users?pageNum=1&pageSize=20&username=&memberLevel=
认证：需管理员登录
返回：PageResult<AdminVipUserVO>
```

#### 10.9.5 VIP记录查询
```
GET /api/v1/admin/vip/records?pageNum=1&pageSize=20&userId=&orderNo=
认证：需管理员登录
返回：PageResult<AdminVipRecordVO>
```

#### 10.9.6 卡片模板管理（CRUD）
```
GET    /api/v1/admin/card-template/list?pageNum=1&pageSize=20
POST   /api/v1/admin/card-template              // 创建模板
PUT    /api/v1/admin/card-template/{templateId} // 更新模板
GET    /api/v1/admin/card-template/stats        // 模板统计
认证：需管理员登录
```

#### 10.9.7 增额终身寿险费率/现金价值导入【v1.8.20新增 - 支持PDF+Excel双格式】
```
POST /api/v1/admin/product/{productId}/import-rates
Content-Type: multipart/form-data
请求参数：
  - file: MultipartFile（支持 .xlsx / .xls / .pdf）
  - productId: Long（路径参数，产品ID）

支持两种数据格式：
  1. 长表格式：性别/投保年龄/缴费年限/保单年度/现金价值/身故保险金
  2. 宽表格式：交费期间/性别/年龄/保单年度1/保单年度2/...（系统自动宽转长）

校验：产品类型必须为增额终身寿险（productType=2）
返回：WholeLifeRateImportResultVO
  - totalCount: 总行数
  - successCount: 成功导入数
  - failCount: 失败数
  - message: 导入结果描述
```

#### 10.9.8 年金险费率/现金价值导入【v1.8.20新增 - 支持PDF+Excel双格式】
```
POST /api/v1/admin/product/{productId}/import-annuity-rates
Content-Type: multipart/form-data
请求参数：
  - file: MultipartFile（支持 .xlsx / .xls / .pdf）
  - productId: Long（路径参数，产品ID）

支持两种数据格式：
  1. 长表格式：性别/投保年龄/缴费年限/[起领年龄]/[产品计划]/保单年度/年领取金额/现金价值/身故保险金
  2. 宽表格式：交费期间/性别/年龄/[起领年龄]/[产品计划]/保单年度1/保单年度2/...（系统自动宽转长）

校验：产品类型必须为年金险（productType=3）
返回：AnnuityRateImportResultVO
  - totalCount: 总行数
  - successCount: 成功导入数
  - failCount: 失败数
  - message: 导入结果描述
```

### 10.5 用户认证接口【v1.8.18新增 - 代码已实现】

#### 10.5.1 用户注册
```
POST /api/v1/auth/register
请求体：RegisterDTO
{
  "username": "zhangsan",     // @NotBlank, @Size(3-20)
  "password": "password123"   // @NotBlank, @Size(8-32)
}
返回：LoginVO（注册成功后自动登录，返回Token和用户信息）
```

#### 10.5.2 用户登录（账号密码）
```
POST /api/v1/auth/login
请求体：LoginDTO
{
  "username": "zhangsan",   // @NotBlank
  "password": "password123" // @NotBlank
}
返回：LoginVO
  - accessToken: JWT访问令牌
  - refreshToken: 刷新令牌
  - tokenType: "Bearer"
  - expiresIn: 过期时间（秒）
  - userInfo: UserInfoVO
```

#### 10.5.3 刷新Token
```
POST /api/v1/auth/refresh
请求体：RefreshTokenDTO
{
  "refreshToken": "xxx"
}
返回：LoginVO（新的Token对）
```

#### 10.5.4 检查用户名是否存在
```
GET /api/v1/auth/check-username?username=zhangsan
返回：Boolean（true-已存在, false-可用）
```

#### 10.5.5 获取当前用户信息【已实现】
```
GET /api/v1/user/info
认证：需登录（从SecurityUtils取userId）
返回：UserInfoVO
  - userId, username, nickname, avatarUrl, phone, email, gender(0-未知/1-男/2-女)
  - birthday, memberLevel(0-普通/1-VIP/2-SVIP), memberExpireTime
  - status(0-禁用/1-正常)
  - wechatOpenid, wechatUnionid, wechatNickname, wechatAvatar, wechatBound(0/1)
```

### 10.6 微信登录接口【v1.8.18新增 - 代码已实现】

#### 10.6.1 获取PC微信扫码二维码
```
GET /api/wechat/qrcode
返回：Map<String,String>
  - sessionId: 会话ID
  - qrCodeUrl: 微信二维码URL
  - expireIn: 过期时间（秒）
  - pollInterval: 轮询间隔（毫秒）
```

#### 10.6.2 轮询扫码状态
```
GET /api/wechat/qrcode/check?sessionId=xxx
返回：Map<String,Object>
  - status: WAITING（等待扫码）/ SCANNED（已扫码）/ CONFIRMED（已确认）/ EXPIRED（已过期）
  - 当status=CONFIRMED时，返回LoginVO
```

#### 10.6.3 微信开放平台回调
```
GET /api/wechat/callback?code=xxx&state=xxx
返回：HTML页面（window.close，用于关闭扫码窗口）
说明：微信扫码后自动回调此接口，后端用code换取openid
```

#### 10.6.4 微信小程序登录
```
POST /api/wechat/mp/login
请求体：WechatMpLoginDTO
{
  "code": "wx_login_code",      // @NotBlank，wx.login()获取的临时code
  "nickname": "微信用户",        // 可选
  "avatarUrl": "https://..."    // 可选
}
返回：LoginVO
```

#### 10.6.5 绑定微信
```
POST /api/wechat/bind
认证：需登录
请求体：WechatBindDTO
{
  "code": "wx_login_code",
  "nickname": "微信用户",
  "avatarUrl": "https://..."
}
返回：Void
```

#### 10.6.6 解绑微信
```
POST /api/wechat/unbind
认证：需登录
返回：Void
```

### 10.7 VIP会员接口【v1.8.18新增 - 部分已实现】

#### 10.7.1 获取VIP状态【已实现】
```
GET /api/v1/vip/status
认证：需登录
返回：VipStatusVO
  - userId, username, memberLevel(0/1/2), memberLevelDesc
  - isVip: Boolean, memberExpireTime, isExpired: Boolean
```

#### 10.7.2 获取VIP权限【已实现】
```
GET /api/v1/vip/permissions
认证：需登录
返回：VipPermissionVO
  - userId, memberLevel
  - permissions: List<String>（权限码列表）
  - features: List<String>（功能特性列表）
```

#### 10.7.3 获取VIP套餐列表【待实现】
```
GET /api/v1/vip/plans
返回：List<VipPlanVO>
说明：前端已定义但后端尚未实现
```

#### 10.7.4 创建VIP订单【待实现】
```
POST /api/v1/vip/orders
请求体：{ "planId": 1, "paymentMethod": "wechat" }
返回：OrderVO（包含支付参数）
说明：前端已定义但后端尚未实现，需对接微信支付
```

#### 10.7.5 查询订单状态【待实现】
```
GET /api/v1/vip/orders/{orderId}/status
返回：OrderStatusVO
说明：前端已定义但后端尚未实现
```

#### 10.7.6 获取订单历史【待实现】
```
GET /api/v1/vip/orders?pageNum=1&pageSize=10
返回：PageResult<OrderVO>
说明：前端已定义但后端尚未实现
```

### 10.8 费率计算接口

#### 10.8.1 重疾险保费计算【已实现】
```
POST /api/v1/calculate/critical-premium
请求体：CriticalPremiumDTO
{
  "productId": 1001,
  "gender": 1,              // 0-女/1-男
  "age": 30,
  "paymentYear": 20,        // 缴费年限
  "coverage": 50.00         // 保额（万元）
}
返回：CriticalPremiumVO
```

#### 10.8.2 增额终身寿险利益演算【已实现 · v1.8.19公式补全】

**数据表结构说明（基于中意人寿实际产品数据）：**

| 数据表 | 维度结构 | 值单位 | 说明 |
|--------|---------|--------|------|
| `whole_life_rate`（现金价值表） | 缴费期间 × 性别 × 投保年龄 → 保单年度1-105 | 元/每千元保费 | 现金价值系数，需乘以年缴保费换算 |
| `premium_rate`（费率表） | 投保年龄 × 缴费期间（男女分栏） | 元/每千元保额 | 年缴保费系数，需乘以保额换算 |

> **关键区分**：现金价值表按"每千元保费"存储，费率表按"每千元保额"存储。用户输入保额时需先换算为年缴保费，再用于现金价值计算。

**固收型增额终身寿险收益演示公式：**

```
POST /api/v1/calculate/whole-life-projection
请求体：WholeLifeProjectionDTO
{
  "productId": 2001,
  "gender": 1,            // 0-女/1-男
  "age": 30,              // 投保年龄
  "paymentYear": 10,      // 缴费年限
  "annualPremium": 100000 // 年缴保费（元）【或传入保额，由系统换算】
}
```

**返回：WholeLifeProjectionVO**

**输入参数换算逻辑：**
```java
// 若用户输入的是保额（coverage），需先换算为年缴保费
// 步骤：查询费率表 → 年缴保费 = 保额 × 费率 ÷ 1000
BigDecimal annualPremium;
if (dto.getCoverage() != null) {
    // 查询费率表（每千元保额对应的保费）
    BigDecimal ratePerThousand = premiumRateMapper.selectRate(productId, gender, age, paymentYear);
    // 年缴保费 = 保额 × 费率 ÷ 1000
    annualPremium = dto.getCoverage().multiply(ratePerThousand).divide(new BigDecimal("1000"), 2, RoundingMode.HALF_UP);
} else {
    annualPremium = dto.getAnnualPremium();
}
```

**年度收益列表生成逻辑（伪代码）：**
```java
// 步骤1：查询产品信息，判断是否为分红型
ProductBase product = productService.getById(productId);
boolean isDividend = product.getSubType().equals("DIVIDEND"); // 或根据产品细类判断

// 步骤2：确定最大保单年度（通常到105岁或产品定义的最大年龄）
int maxPolicyYear = product.getMaxInsuranceYear(); // 如105 - age + 1

// 步骤3：遍历每个保单年度生成收益数据
List<YearlyProjectionVO> projections = new ArrayList<>();
for (int policyYear = 1; policyYear <= maxPolicyYear; policyYear++) {
    int currentAge = age + policyYear - 1;

    // 3.1 查询现金价值（现金价值表中存储的是每1000元保费对应的现金价值）
    WholeLifeRate rate = wholeLifeRateMapper.selectOne(
        productId, gender, age, paymentYear, policyYear
    );

    // 3.2 计算实际现金价值 = 表中现金价值 × (年缴保费 ÷ 1000)
    BigDecimal actualCashValue = rate.getCashValue()
        .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));

    // 3.3 计算累计保费 = 年缴保费 × min(保单年度, 缴费年限)
    BigDecimal totalPremium = annualPremium.multiply(
        new BigDecimal(Math.min(policyYear, paymentYear))
    );

    // 3.4 计算收益率 = (现金价值 - 累计保费) ÷ 累计保费
    BigDecimal returnRate = BigDecimal.ZERO;
    if (totalPremium.compareTo(BigDecimal.ZERO) > 0) {
        returnRate = actualCashValue.subtract(totalPremium)
            .divide(totalPremium, 4, RoundingMode.HALF_UP);
    }

    // 3.5 计算身故保险金
    // 增额终身寿险身故保险金通常取三者最大值：
    // ① 累计保费 × 给付比例（18-40岁160%，41-60岁140%，61岁以上120%）
    // ② 现金价值 ③ 有效保额（保额按增额比例逐年增长）
    BigDecimal payoutRatio;
    if (currentAge < 41) payoutRatio = new BigDecimal("1.6");
    else if (currentAge < 61) payoutRatio = new BigDecimal("1.4");
    else payoutRatio = new BigDecimal("1.2");

    BigDecimal deathBenefitByPremium = totalPremium.multiply(payoutRatio);
    BigDecimal deathBenefitByTable = rate.getDeathBenefit()
        .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
    BigDecimal actualDeathBenefit = deathBenefitByPremium.max(actualCashValue).max(deathBenefitByTable);

    // 3.6 组装年度数据
    YearlyProjectionVO vo = new YearlyProjectionVO();
    vo.setPolicyYear(policyYear);
    vo.setAge(currentAge);
    vo.setCashValue(actualCashValue);
    vo.setDeathBenefit(actualDeathBenefit);
    vo.setTotalPremium(totalPremium);
    vo.setReturnRate(returnRate);
    projections.add(vo);
}
```

---

**分红型增额终身寿险收益演示公式：**

分红型产品收益演示包含**保证部分**（与固收型一致）和**分红演示部分**（按分红实现率调整）。

**分红演示数据来源（两种模式）：**

| 模式 | 数据表 | 适用场景 | 说明 |
|------|--------|---------|------|
| 直接查表 | `whole_life_dividend_rate` | 产品说明书提供完整分红演示表 | 直接查询保证/中档分红现金价值 |
| 公式估算 | `product_dividend_config` + `whole_life_rate` | 仅提供保证现金价值表和分红利率 | 按分红利率估算累积红利 |

**模式一：直接查表（产品说明书含分红演示表）**

```java
// 步骤1：查询产品分红配置
ProductDividendConfig dividendConfig = productDividendConfigMapper.selectByProductId(productId);

// 步骤2：获取用户选择的分红实现率（默认100%，范围0%-200%）
BigDecimal dividendRealizationRate = userSelectedRate != null
    ? userSelectedRate : new BigDecimal("100");

// 步骤3：遍历每个保单年度
for (int policyYear = 1; policyYear <= maxPolicyYear; policyYear++) {
    int currentAge = age + policyYear - 1;

    // 3.1 查询分红演示数据（保证部分 + 含分红演示部分）
    WholeLifeDividendRate divRate = wholeLifeDividendRateMapper.selectOne(
        productId, gender, age, paymentYear, policyYear
    );

    // 3.2 保证部分（与固收型计算方式相同）
    BigDecimal guaranteedCashValue = divRate.getCashValueGuaranteed()
        .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));

    // 3.3 分红演示部分计算
    // 公式：含分红现金价值 = 保证部分 + (含中档分红部分 - 保证部分) × (分红实现率 ÷ 100)
    BigDecimal midDividendCashValue = divRate.getCashValueMidDividend()
        .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));

    BigDecimal dividendPortion = midDividendCashValue.subtract(guaranteedCashValue)
        .multiply(dividendRealizationRate.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP));

    BigDecimal projectedCashValue = guaranteedCashValue.add(dividendPortion);

    // 3.4 身故保险金同理计算（取三者最大值）
    BigDecimal guaranteedDeathBenefit = divRate.getDeathBenefitGuaranteed()
        .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
    BigDecimal midDividendDeathBenefit = divRate.getDeathBenefitMidDividend()
        .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
    BigDecimal projectedDeathBenefit = guaranteedDeathBenefit.add(
        midDividendDeathBenefit.subtract(guaranteedDeathBenefit)
            .multiply(dividendRealizationRate.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP))
    );

    // 3.5 累计保费和收益率
    BigDecimal totalPremium = annualPremium.multiply(
        new BigDecimal(Math.min(policyYear, paymentYear))
    );
    BigDecimal returnRate = BigDecimal.ZERO;
    if (totalPremium.compareTo(BigDecimal.ZERO) > 0) {
        returnRate = projectedCashValue.subtract(totalPremium)
            .divide(totalPremium, 4, RoundingMode.HALF_UP);
    }

    // 3.6 组装年度数据（分红型需额外标注保证部分和含分红部分）
    YearlyProjectionVO vo = new YearlyProjectionVO();
    vo.setPolicyYear(policyYear);
    vo.setAge(currentAge);
    vo.setCashValue(projectedCashValue);        // 含分红演示的现金价值
    vo.setCashValueGuaranteed(guaranteedCashValue); // 保证部分
    vo.setDeathBenefit(projectedDeathBenefit);
    vo.setTotalPremium(totalPremium);
    vo.setReturnRate(returnRate);
    projections.add(vo);
}
```

**模式二：公式估算（仅保证现金价值表 + 分红利率配置）**

当产品仅提供保证现金价值表，未提供含分红现金价值表时，采用公式估算：

```java
// 步骤1：查询分红利率配置（低档/中档/高档）
ProductDividendConfig config = productDividendConfigMapper.selectByProductId(productId);
BigDecimal dividendRateMid = config.getDividendRateMid(); // 中档分红利率，如 0.035
BigDecimal accumulationRate = config.getAccumulationRate(); // 红利累积利率，如 0.025

// 步骤2：计算保额（用于红利计算基数）
BigDecimal ratePerThousand = premiumRateMapper.selectRate(productId, gender, age, paymentYear);
BigDecimal coverage = annualPremium.divide(ratePerThousand, 4, RoundingMode.HALF_UP).multiply(new BigDecimal("1000"));

// 步骤3：逐年计算累积红利
BigDecimal cumulativeDividend = BigDecimal.ZERO;
for (int policyYear = 1; policyYear <= maxPolicyYear; policyYear++) {
    // 年度红利 = 保额 × 分红利率
    BigDecimal annualDividend = coverage.multiply(dividendRateMid);
    // 累积红利 = 上年累积红利 × (1 + 累积利率) + 本年度红利
    cumulativeDividend = cumulativeDividend.multiply(
        BigDecimal.ONE.add(accumulationRate)
    ).add(annualDividend);

    // 含分红现金价值 = 保证现金价值 + 累积红利
    BigDecimal guaranteedCV = ...; // 同固收型计算
    BigDecimal projectedCV = guaranteedCV.add(cumulativeDividend);
}
```

**关键公式总结：**
| 指标 | 固收型公式 | 分红型公式（模式一：查表） | 分红型公式（模式二：估算） |
|------|-----------|------------------------|------------------------|
| 年缴保费 | 用户输入 或 保额 × 费率 ÷ 1000 | 同固收型 | 同固收型 |
| 实际现金价值 | 表中值 × (年缴保费 ÷ 1000) | 保证部分 + (中档分红部分 - 保证部分) × (分红实现率 ÷ 100) | 保证现金价值 + 累积红利 |
| 实际身故保险金 | max(累计保费×比例, 现金价值, 表值) | 同固收型（基于含分红现金价值） | 同固收型 + 累积红利 |
| 累计保费 | 年缴保费 × min(保单年度, 缴费年限) | 同上 | 同上 |
| 收益率 | (现金价值 - 累计保费) ÷ 累计保费 | (含分红现金价值 - 累计保费) ÷ 累计保费 | 同上 |

**⚠️ 数据现状与导入建议：**
- **增额寿现金价值表**：部分产品（如中意一生中意系列）覆盖保单年度1-105，数据完整；部分产品仅3个保单年度
- **费率表**：数据完整，投保年龄0-70岁，缴费期间趸交/3/5/10/15/20年，男女分栏
- **分红演示数据**：`whole_life_dividend_rate` 表尚未导入，需从产品说明书提取保证/中档分红现金价值
- **分红利率配置**：当前 `product_dividend_config` 表中分红利率为NaN，需管理员在后台配置低档/中档/高档分红利率及红利累积利率
- **导入流程建议**：Excel原始表（现价.xlsx/费率.xlsx）→ 数据清洗（统一单位、处理空值）→ 按产品ID分表导入 `whole_life_rate` / `whole_life_dividend_rate`

---

#### 10.8.3 年金险利益演算【已实现 · v1.8.20公式补全】

**数据表结构说明（基于中意人寿、中英人寿实际产品数据）：**

| 数据表 | 维度结构 | 值单位 | 典型产品 |
|--------|---------|--------|---------|
| `annuity_rate`（快返年金） | 缴费期间 × 性别 × 投保年龄 → 保单年度1-105 | 元/每千元保费 | 中英悦活人生 |
| `annuity_rate`（养老年金） | 领取年龄 × 缴费期间 × 性别 × 投保年龄 → 保单年度1-105 | 元/每千元保费 | 中意真爱久久 |
| `annuity_rate`（分红年金） | 产品计划 × 缴费期间 × 性别 × 投保年龄 → 保单年度1-105 | 元/每千元保额 | 中意一生中意 |
| `premium_rate`（费率表） | [领取年龄/产品计划] × 投保年龄 × 缴费期间（男女分栏） | 元/每千元保额 | 通用 |

> **与增额寿的关键区别**：
> 1. **维度更多**：年金险现金价值表可能包含**领取年龄**（55/60/65周岁）或**产品计划**（计划一/二）维度
> 2. **单位不一**：部分产品按"每千元保费"（如中英悦活人生），部分按"每千元保额"（如中意一生中意）
> 3. **曲线形态**：年金险现金价值通常**先增后降**（快返年金缓慢递减，养老年金到领取年龄后归0）
> 4. **领取逻辑**：年领取金额可能不在现金价值表中，需从单独的年金给付表或按保额×给付比例计算

**固收型年金险收益演示公式：**

```
POST /api/v1/calculate/annuity-projection
请求体：AnnuityProjectionDTO
{
  "productId": 3001,
  "gender": 1,            // 0-女/1-男
  "age": 30,              // 投保年龄
  "paymentYear": 10,      // 缴费年限
  "annualPremium": 100000 // 年缴保费（元）【或传入保额】
  "startAge": 60,         // 领取开始年龄（可选，如未传从product配置获取）
  "planId": "PLAN_1"      // 产品计划（可选，仅多计划产品需要）
}
```

**返回：AnnuityProjectionVO**

**输入参数与单位换算逻辑：**

```java
// 步骤0：查询产品信息，获取关键配置
ProductBase product = productService.getById(productId);
String unitType = product.getRateUnitType(); // "PER_PREMIUM"=每千元保费 或 "PER_COVERAGE"=每千元保额
Integer startAge = dto.getStartAge() != null ? dto.getStartAge() : product.getStartAge();
String planId = dto.getPlanId(); // 产品计划，如"计划一"

// 步骤1：确定年缴保费和保额
BigDecimal annualPremium, coverage;
if ("PER_COVERAGE".equals(unitType)) {
    // 按保额单位的产品：用户输入保额 → 查费率表算保费
    coverage = dto.getCoverage();
    BigDecimal ratePerThousand = premiumRateMapper.selectRate(
        productId, gender, age, paymentYear, startAge, planId
    );
    annualPremium = coverage.multiply(ratePerThousand).divide(new BigDecimal("1000"), 2, RoundingMode.HALF_UP);
} else {
    // 按保费单位的产品：用户输入保费 → 如需保额则反推
    annualPremium = dto.getAnnualPremium();
    if (dto.getCoverage() != null) {
        coverage = dto.getCoverage();
    } else {
        // 反推保额（可选）
        BigDecimal ratePerThousand = premiumRateMapper.selectRate(
            productId, gender, age, paymentYear, startAge, planId
        );
        coverage = annualPremium.divide(ratePerThousand, 4, RoundingMode.HALF_UP)
            .multiply(new BigDecimal("1000"));
    }
}
```

**年度收益列表生成逻辑（伪代码）：**
```java
// 步骤2：遍历每个保单年度
List<AnnuityYearlyVO> projections = new ArrayList<>();
BigDecimal cumulativeReceived = BigDecimal.ZERO;
BigDecimal monthlyPayout = BigDecimal.ZERO;

for (int policyYear = 1; policyYear <= maxPolicyYear; policyYear++) {
    int currentAge = age + policyYear - 1;

    // 2.1 查询年金险数据（根据产品维度传入不同参数）
    AnnuityRate rate = annuityRateMapper.selectOne(
        productId, gender, age, paymentYear, policyYear, startAge, planId
    );

    // 2.2 计算实际现金价值（根据单位类型选择换算基数）
    BigDecimal actualCashValue;
    if ("PER_COVERAGE".equals(unitType)) {
        // 按保额单位：现金价值 = 表中值 × (保额 ÷ 1000)
        actualCashValue = rate.getCashValue()
            .multiply(coverage.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
    } else {
        // 按保费单位：现金价值 = 表中值 × (年缴保费 ÷ 1000)
        actualCashValue = rate.getCashValue()
            .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
    }

    // 2.3 计算实际年领取金额
    // 方式A：表中直接存储年金系数（适用于快返年金/部分养老年金）
    BigDecimal actualAnnualPayout = BigDecimal.ZERO;
    if (rate.getAnnualPayout() != null && rate.getAnnualPayout().compareTo(BigDecimal.ZERO) > 0) {
        if ("PER_COVERAGE".equals(unitType)) {
            actualAnnualPayout = rate.getAnnualPayout()
                .multiply(coverage.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
        } else {
            actualAnnualPayout = rate.getAnnualPayout()
                .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
        }
    }
    // 方式B：按保额×年金给付比例计算（适用于未存储年金系数的养老年金）
    else if (startAge != null && currentAge >= startAge) {
        BigDecimal payoutRatio = product.getAnnuityPayoutRatio(); // 如 0.05 = 每年领取保额的5%
        if (payoutRatio != null) {
            actualAnnualPayout = coverage.multiply(payoutRatio);
        }
    }

    // 2.4 未达到领取年龄前年领取为0（养老年金）
    if (startAge != null && currentAge < startAge) {
        actualAnnualPayout = BigDecimal.ZERO;
    }

    // 2.5 计算实际身故保险金
    BigDecimal actualDeathBenefit = BigDecimal.ZERO;
    if (rate.getDeathBenefit() != null) {
        if ("PER_COVERAGE".equals(unitType)) {
            actualDeathBenefit = rate.getDeathBenefit()
                .multiply(coverage.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
        } else {
            actualDeathBenefit = rate.getDeathBenefit()
                .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
        }
    }

    // 2.6 累计领取
    if (actualAnnualPayout.compareTo(BigDecimal.ZERO) > 0) {
        cumulativeReceived = cumulativeReceived.add(actualAnnualPayout);
    }

    // 2.7 月领取金额 = 年领取金额 × 月领系数（通常0.085，即年领÷12×1.02）
    monthlyPayout = actualAnnualPayout.multiply(new BigDecimal("0.085"))
        .setScale(2, RoundingMode.HALF_UP);

    // 2.8 组装年度数据
    AnnuityYearlyVO vo = new AnnuityYearlyVO();
    vo.setPolicyYear(policyYear);
    vo.setAge(currentAge);
    vo.setAnnualPayout(actualAnnualPayout);
    vo.setCashValue(actualCashValue);
    vo.setDeathBenefit(actualDeathBenefit);
    vo.setTotalReceived(cumulativeReceived);
    projections.add(vo);
}

// 返回汇总信息
AnnuityProjectionVO result = new AnnuityProjectionVO();
result.setProductId(productId);
result.setProductName(product.getProductName());
result.setGender(gender);
result.setAge(age);
result.setPaymentYear(paymentYear);
result.setAnnualPremium(annualPremium);
result.setCoverage(coverage);
result.setTotalPremium(annualPremium.multiply(new BigDecimal(paymentYear)));
result.setStartAge(startAge);
result.setPlanId(planId);
if (startAge != null && startAge >= age) {
    result.setAnnualPayout(projections.get(startAge - age).getAnnualPayout());
}
result.setMonthlyPayout(monthlyPayout);
result.setYearlyProjections(projections);
```

**年金险现金价值曲线形态说明：**

| 产品类型 | 曲线特征 | 典型产品 | 说明 |
|---------|---------|---------|------|
| 快返年金 | 缴费期满后快速达到峰值，然后缓慢递减 | 中英悦活人生 | 第5年达峰约1054，之后逐年缓慢下降 |
| 养老年金 | 领取年龄前持续增长，领取后归0或递减 | 中意真爱久久 | 60岁领取后现金价值快速归0 |
| 分红年金 | 形态与固收类似，但含分红演示更高 | 中意一生中意 | 分红型保证部分曲线同固收 |

---

**分红型年金险收益演示公式：**

与增额寿一致，分红型年金险也有**直接查表**和**公式估算**两种模式。

**模式一：直接查表（产品说明书含分红演示表）**

```java
// 步骤1：获取用户选择的分红实现率
BigDecimal dividendRealizationRate = userSelectedRate != null
    ? userSelectedRate : new BigDecimal("100");

// 步骤2：遍历每个保单年度
for (int policyYear = 1; policyYear <= maxPolicyYear; policyYear++) {
    int currentAge = age + policyYear - 1;

    // 2.1 查询分红演示数据
    AnnuityDividendRate divRate = annuityDividendRateMapper.selectOne(
        productId, gender, age, paymentYear, policyYear, startAge, planId
    );

    // 2.2 保证部分（按单位类型换算）
    BigDecimal guaranteedCashValue, guaranteedAnnualPayout;
    if ("PER_COVERAGE".equals(unitType)) {
        guaranteedCashValue = divRate.getCashValueGuaranteed()
            .multiply(coverage.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
        guaranteedAnnualPayout = divRate.getAnnualPayoutGuaranteed()
            .multiply(coverage.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
    } else {
        guaranteedCashValue = divRate.getCashValueGuaranteed()
            .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
        guaranteedAnnualPayout = divRate.getAnnualPayoutGuaranteed()
            .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
    }

    // 2.3 分红演示部分
    BigDecimal midDividendCashValue, midDividendAnnualPayout;
    if ("PER_COVERAGE".equals(unitType)) {
        midDividendCashValue = divRate.getCashValueMidDividend()
            .multiply(coverage.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
        midDividendAnnualPayout = divRate.getAnnualPayoutMidDividend()
            .multiply(coverage.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
    } else {
        midDividendCashValue = divRate.getCashValueMidDividend()
            .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
        midDividendAnnualPayout = divRate.getAnnualPayoutMidDividend()
            .multiply(annualPremium.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP));
    }

    // 公式：含分红值 = 保证部分 + (中档分红部分 - 保证部分) × (分红实现率 ÷ 100)
    BigDecimal projectedCashValue = guaranteedCashValue.add(
        midDividendCashValue.subtract(guaranteedCashValue)
            .multiply(dividendRealizationRate.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP))
    );
    BigDecimal projectedAnnualPayout = guaranteedAnnualPayout.add(
        midDividendAnnualPayout.subtract(guaranteedAnnualPayout)
            .multiply(dividendRealizationRate.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP))
    );

    // 2.4 累计领取（达到领取年龄后累加）
    if (startAge != null && currentAge >= startAge) {
        cumulativeReceived = cumulativeReceived.add(projectedAnnualPayout);
    }

    // 2.5 组装数据
    AnnuityYearlyVO vo = new AnnuityYearlyVO();
    vo.setPolicyYear(policyYear);
    vo.setAge(currentAge);
    vo.setAnnualPayout(startAge != null && currentAge >= startAge ? projectedAnnualPayout : BigDecimal.ZERO);
    vo.setCashValueGuaranteed(guaranteedCashValue); // 保证部分
    vo.setCashValue(projectedCashValue); // 含分红演示
    vo.setTotalReceived(cumulativeReceived);
    projections.add(vo);
}
```

**模式二：公式估算（仅保证现金价值表 + 分红利率配置）**

当产品仅提供保证年金数据时，分红部分通过红利累积估算：

```java
// 步骤1：查询分红利率配置
ProductDividendConfig config = productDividendConfigMapper.selectByProductId(productId);
BigDecimal dividendRateMid = config.getDividendRateMid(); // 中档分红利率
BigDecimal accumulationRate = config.getAccumulationRate(); // 红利累积利率

// 步骤2：确定保额（红利计算基数）
// 如为PER_PREMIUM单位产品，需通过费率表反推保额
BigDecimal baseCoverage = coverage != null ? coverage :
    annualPremium.divide(ratePerThousand, 4, RoundingMode.HALF_UP).multiply(new BigDecimal("1000"));

// 步骤3：逐年计算累积红利和分红后领取金额
BigDecimal cumulativeDividend = BigDecimal.ZERO;
for (int policyYear = 1; policyYear <= maxPolicyYear; policyYear++) {
    // 年度红利 = 保额 × 分红利率
    BigDecimal annualDividend = baseCoverage.multiply(dividendRateMid);
    // 累积红利复利计算
    cumulativeDividend = cumulativeDividend.multiply(BigDecimal.ONE.add(accumulationRate))
        .add(annualDividend);

    // 保证部分（同固收型查询）
    BigDecimal guaranteedPayout = ...;
    BigDecimal guaranteedCV = ...;

    // 含分红年领取金额 = 保证领取 + 累积红利分摊（按产品规则）
    BigDecimal projectedPayout = guaranteedPayout.add(
        cumulativeDividend.multiply(config.getDividendPayoutRatio())
    );
    BigDecimal projectedCV = guaranteedCV.add(cumulativeDividend);
}
```

**关键公式总结：**
| 指标 | 固收型公式（每千元保费单位） | 固收型公式（每千元保额单位） | 分红型公式（模式一：查表） |
|------|------------------------|------------------------|------------------------|
| 年缴保费 | 用户输入 | 保额 × 费率 ÷ 1000 | 同固收型 |
| 保额 | 保费 ÷ 费率 × 1000（反推） | 用户输入 | 同固收型 |
| 现金价值 | 表中值 × (年缴保费 ÷ 1000) | 表中值 × (保额 ÷ 1000) | 保证 + (中档 - 保证) × 实现率 |
| 年领取金额 | 表中值 × (年缴保费 ÷ 1000) 或 保额 × 给付比例 | 表中值 × (保额 ÷ 1000) 或 保额 × 给付比例 | 同上 |
| 身故保险金 | 表中值 × (年缴保费 ÷ 1000) | 表中值 × (保额 ÷ 1000) | 同上 |
| 月领取金额 | 年领取 × 0.085 | 年领取 × 0.085 | 同上 |

**⚠️ 数据现状与导入建议：**
- **快返年金现金价值表**：中英悦活人生等产品数据完整，覆盖保单年度1-105，按"每千元保费"单位
- **养老年金现金价值表**：中意真爱久久等数据完整，有"领取年龄"维度（55/60/65），按"每千元保费"单位
- **分红年金现金价值表**：中意一生中意等按"每千元保额"单位，有"产品计划"维度
- **年金领取数据**：部分产品现金价值表含年金系数（`annual_payout`字段），部分需通过`product.annuity_payout_ratio`配置计算
- **费率表**：养老年金费率表有"领取年龄"维度，分红年金费率表有"产品计划"维度，需支持动态列扩展
- **数据导入优先级**：① 统一`annuity_rate`表结构（增加`start_age`、`plan_id`字段）② 按产品单位类型分类导入 ③ 配置年金给付比例（如未存储在表中）

#### 10.8.4 获取费率表【待实现】
```
GET /api/v1/calculate/rate-table?productId=1001&gender=1&paymentYear=20
返回：List<PremiumRateVO>
说明：前端已定义但后端尚未实现
```

#### 10.8.5 获取缴费期选项【待实现】
```
GET /api/v1/calculate/payment-periods/{productId}
返回：List<Integer>（支持的缴费年限列表）
说明：前端已定义但后端尚未实现
```

### 10.6 对比相关接口

#### 10.6.1 重疾险对比【已实现】
```
POST /api/v1/compare/critical-illness
请求体：CriticalIllnessCompareDTO
{
  "productIds": [1001, 1002, 1003]  // @NotEmpty，至少2个产品ID
}
返回：CompareResultVO（对比结果，包含产品基本信息Map和对比维度列表）
```

#### 10.6.2 增额终身寿险对比【已实现】
```
POST /api/v1/compare/whole-life
请求体：WholeLifeCompareDTO
{
  "productIds": [2001, 2002, 2003]  // @NotEmpty
}
返回：CompareResultVO
```

#### 10.6.3 年金险对比【已实现】
```
POST /api/v1/compare/annuity
请求体：AnnuityCompareDTO
{
  "productIds": [3001, 3002, 3003]  // @NotEmpty
}
返回：CompareResultVO
```

#### 10.6.4 获取对比历史【待实现】
```
GET /api/v1/compare/history?pageNum=1&pageSize=10
返回：PageResult<CompareHistoryVO>
说明：前端已定义但后端尚未实现
```

#### 10.6.5 保存对比记录【待实现】
```
POST /api/v1/compare/save
请求体：{ "productIds": [...], "compareType": "critical-illness" }
返回：Long（对比记录ID）
说明：前端已定义但后端尚未实现
```

---

## 11. VIP 会员体系

### 11.1 新三档会员架构
|会员档位|定价|有效期|
|-|-|-|
|免费用户|0元|永久有效|
|VIP会员|19.9元|30天（月卡）|
|SVIP会员|29.9元|30天（月卡）|

### 11.2 完整权限对照表
|功能权限|免费用户|VIP（19.9元/30天）|SVIP（29.9元/30天）|
|-|-|-|-|
|**每日生成卡片上限**|无限制|无限制|无限制|
|**同时对比产品数**|最多3款|最多5款|最多8款|
|**展业卡片基础生成**|✅ 支持|✅ 支持|✅ 支持|
|**全部背景模板库（v1.8.13升级）**|❌ 仅默认模板|✅ 全部500个背景解锁|✅ 全部500个背景解锁|
|**自定义上传背景图**|❌ 不支持|❌ 不支持|✅ 支持|
|**自定义水印（v1.8.14升级）**|❌ 无水印功能|✅（固定用户名，全屏蜂窝平铺）|✅（自定义文字+6项参数，全屏蜂窝平铺）|
|**个人专属二维码**|❌ 不支持|❌ 不支持|✅ 支持|
|**分红实现率5档调节**|❌ 仅100%|✅ 全部5档|✅ 全部5档|
|**4曲线分红对比图表**|❌ 不显示|✅ 显示|✅ 显示|
|**利益演示自定义列**|❌ 固定列|✅ 自由勾选|✅ 自由勾选|
|**批量生成卡片**|❌ 不支持|❌ 不支持|✅ 支持|

---

## 12. 非功能需求

### 12.1 性能指标
- 首屏加载 < 1.5s
- 5款产品对比渲染 < 2s
- 所有接口P95 < 300ms
- 卡片单张生成 < 2s
- 分类筛选响应 < 100ms
- 背景图库查询 < 100ms（v1.8.13新增）
- 背景预览切换 < 50ms（v1.8.13新增）
- 增额寿/年金险利益演算 < 500ms
- 智能隐藏计算 < 100ms
- 保司排行榜查询 < 200ms
- 保司数据看板加载 < 500ms
- **水印渲染 < 100ms（v1.8.14新增）**

### 12.2 数据质量指标
- 与明亚后台对齐率 100%
- 责任配置准确率 100%
- 费率计算准确率 100%
- 分红计算准确率 100%
- 自定义列准确率 100%
- 背景分类准确率 100%（v1.8.13新增）
- **水印渲染准确率 100%（v1.8.14新增）**
- 祝寿金计算准确率 100%
- 产品状态过滤准确率 100%
- 保司评级数据准确率 100%

---

## 13. 自动化测试方案

### 13.1 自动化测试用例生成
- 功能测试用例自动生成
- 边界条件测试用例
- 异常场景测试用例
- 性能测试用例
- 兼容性测试用例

### 13.2 自动化功能测试执行
- 前端页面功能自动化测试
- API接口自动化测试
- 数据一致性校验
- 业务流程端到端测试

### 13.3 自动化性能测试
- 并发压力测试
- 响应时间测试
- 资源占用监控
- 瓶颈定位与优化建议

### 13.4 自动化回归测试
- 版本迭代自动回归
- 变更影响范围分析
- 兼容性检测
- 测试报告自动生成

### 13.5 v1.8.14 新增测试用例
- 水印全屏覆盖渲染测试
- 蜂窝状平铺算法测试
- 水印6项配置参数测试（透明度/密度/角度/字体/颜色/文字）
- 会员水印权限分级测试（免费/VIP/SVIP）
- SVG水印生成与html2canvas渲染测试
- 水印层级z-index测试
- 10大分类背景筛选测试
- 名称/标签模糊搜索测试
- 背景预览实时更新测试
- 热度统计更新测试

---

## 14. 附录 A - 法定疾病清单

### 14.1 28种法定重大疾病（银保监会2021年重疾新规）
1. 恶性肿瘤——重度
2. 较重急性心肌梗死
3. 严重脑中风后遗症
4. 重大器官移植术或造血干细胞移植术
5. 冠状动脉搭桥术（或称冠状动脉旁路移植术）
6. 严重慢性肾衰竭
7. 多个肢体缺失
8. 急性重症肝炎或亚急性重症肝炎
9. 严重良性颅内肿瘤
10. 慢性肝功能衰竭失代偿期
11. 严重脑炎后遗症或严重脑膜炎后遗症
12. 深度昏迷
13. 双耳失聪
14. 双目失明
15. 瘫痪
16. 心脏瓣膜手术
17. 严重阿尔茨海默病
18. 严重脑损伤
19. 严重原发性帕金森病
20. 严重Ⅲ度烧伤
21. 严重特发性肺动脉高压
22. 严重运动神经元病
23. 语言能力丧失
24. 重型再生障碍性贫血
25. 主动脉手术
26. 严重慢性呼吸衰竭
27. 严重克罗恩病
28. 严重溃疡性结肠炎

### 14.2 3种法定轻症（银保监会2021年重疾新规）
1. 恶性肿瘤——轻度
2. 较轻急性心肌梗死
3. 轻度脑中风后遗症

### 14.3 行业通用中症参考清单（约25种）
- 中度脑中风后遗症、中度心肌梗死、中度帕金森病、中度阿尔茨海默病
- 中度运动神经元病、中度多发性硬化、中度重症肌无力、中度类风湿性关节炎
- 中度克罗恩病、中度溃疡性结肠炎、中度慢性呼吸衰竭、中度慢性肾衰竭
- 单眼失明、单耳失聪、人工耳蜗植入术、视力严重受损、听力严重受损
- 中度瘫痪、中度Ⅲ度烧伤、较小面积Ⅲ度烧伤、单侧肺脏切除
- 单侧肾脏切除、单侧肝脏切除、早期肝硬化、系统性红斑狼疮

### 14.4 高发轻症/中症参考清单（15种）
1. 极早期恶性肿瘤或恶性病变
2. 不典型的急性心肌梗死
3. 轻微脑中风
4. 冠状动脉介入手术
5. 微创冠状动脉搭桥术
6. 脑垂体瘤、脑囊肿、脑动脉瘤及脑血管瘤
7. 主动脉内手术
8. 心脏瓣膜介入手术
9. 特定周围动脉疾病的血管介入治疗
10. 慢性肾功能衰竭
11. 单侧肾脏切除
12. 单侧肺脏切除
13. 肝脏手术
14. 单眼视力严重受损
15. 听力严重受损

---

## 15. 附录 B - 卡片背景图库（v1.8.13新增）

### 分类数量规划
|分类|背景数量|
|-|-|
|少儿教育金|50个|
|养老规划|50个|
|财富传承|50个|
|重疾保障|50个|
|少儿专属|50个|
|家庭守护|50个|
|企业主专属|40个|
|节日营销|60个（含各节日）|
|开门红专属|40个|
|极简通用|50个|
|**总计**|**500个背景图库**|

### 15.1 分类：少儿教育金（50个示例）
#### 1. 温馨亲子存钱罐
- **标签**：亲子、存钱罐、温馨、教育金、金色
- **提示词**：warm parent-child background, cute piggy bank, golden light, soft colors, education fund theme, high quality, 1080x350px

#### 2. 书本成长阶梯
- **标签**：书本、阶梯、成长、蓝色、教育
- **提示词**：books forming growth ladder, blue sky, children education, clean design, 1080x350px

#### 3. 金色未来梦想
- **标签**：金色、梦想、未来、翅膀、希望
- **提示词**：golden dream wings, bright future, children hope, warm light, 1080x350px

#### 4. 童趣星球探险
- **标签**：星球、太空、童趣、探险、蓝色
- **提示词**：cute space planet, children adventure, cartoon style, blue background, 1080x350px

#### 5. 压岁钱红包
- **标签**：红包、压岁钱、春节、红色、理财
- **提示词**：red envelope, lucky money, chinese new year, children savings, 1080x350px
*(剩余45个背景按相同格式补充)*

### 15.2 分类：养老规划（50个示例）
#### 1. 夕阳红漫步
- **标签**：夕阳、老人、散步、温馨、养老
- **提示词**：sunset background, elderly couple walking, warm orange, retirement life, 1080x350px

#### 2. 品质退休生活
- **标签**：咖啡、书籍、悠闲、品质、金色
- **提示词**：coffee and books, comfortable retirement, warm indoor, quality life, 1080x350px

#### 3. 金色晚年
- **标签**：金色、晚年、温暖、安心、保障
- **提示词**：golden years, warm light, peaceful retirement, secure feeling, 1080x350px
*(剩余47个背景按相同格式补充)*

### 15.3 分类：财富传承（50个示例）
#### 1. 蓝金财富传承
- **标签**：蓝色、金色、财富、传承、专业
- **提示词**：blue and gold professional background, wealth inheritance, modern design, 1080x350px

#### 2. 家族守护盾牌
- **标签**：盾牌、守护、家族、安全、深蓝
- **提示词**：shield protection, family wealth security, deep blue background, 1080x350px

#### 3. 金字塔资产配置
- **标签**：金字塔、资产、配置、金色、专业
- **提示词**：golden pyramid, asset allocation, wealth management, professional style, 1080x350px
*(剩余47个背景按相同格式补充)*

### 15.4 分类：重疾保障（50个示例）
### 15.5 分类：少儿专属（50个示例）
### 15.6 分类：家庭守护（50个示例）
### 15.7 分类：企业主专属（40个示例）
### 15.8 分类：节日营销（60个示例）
### 15.9 分类：开门红专属（40个示例）
### 15.10 分类：极简通用（50个示例）
*(以上分类均按相同格式补充完整500个背景)*

---

## 16. 版本历史

### v1.8.20（2026-06-28）【年金险公式完善 + 多维度数据结构对齐 + 单位类型区分】

✅ **年金险收益演示公式完善（G.5）**：
- 基于中英悦活人生（快返年金）、中意真爱久久（养老年金）、中意一生中意（分红年金）实际产品数据，完善年金险公式
- 区分三种年金险产品类型的现金价值曲线形态：快返年金（先增后缓慢递减）、养老年金（领取后归0）、分红年金（同固收+分红演示）
- 识别年金险现金价值表的**两种单位基准**：每千元保费（中英悦活人生、中意真爱久久）vs 每千元保额（中意一生中意）
- 识别年金险比增额寿多的两个维度：**领取年龄**（55/60/65，养老年金特有）和**产品计划**（计划一/二，分红年金特有）
- 补充年金领取金额的两种计算方式：表中直接存储年金系数（方式A）或 保额 × 年金给付比例（方式B）
- 更新伪代码支持 `unitType` 动态换算（`PER_PREMIUM`/`PER_COVERAGE`）、`startAge` 领取年龄、`planId` 产品计划参数
- 更新分红型年金险公式，支持按单位类型换算保证部分和分红演示部分
- 影响范围：第10章API接口（10.8.3）、第8章数据模型（annuity_rate表需增加start_age/plan_id字段）

✅ **增额终身寿险导入功能升级（代码已实现）**：
- 支持 PDF + Excel（.xlsx/.xls）双格式上传导入
- 自动检测宽表/长表格式：宽表（维度列+多个保单年度列）自动转换为长表导入
- PDF解析通过Python脚本（pdfplumber）提取表格数据
- Excel解析支持按列名动态映射（兼容多种列头写法）
- 新增管理端导入页面，支持增额寿产品列表页一键跳转导入

✅ **年金险导入功能开发（代码已实现）**：
- 新增 `POST /api/v1/admin/product/{productId}/import-annuity-rates` 接口
- 支持 PDF + Excel 双格式，自动宽表转长表
- 解析字段：gender/age/paymentYear/startAge/planId/policyYear/annualPayout/cashValue/deathBenefit
- 新增管理端年金险导入页面（AnnuityRateImport.vue）
- 校验：仅允许productType=3的产品导入

✅ **年金险收益演示计算完善（代码已实现）**：
- 双模式计算：模式一（查表）/ 模式二（公式估算）
- 查表模式：从 annuity_rate 表查询，按保费系数（年缴保费÷1000）换算实际金额
- 公式估算模式：无费率表数据时，按缴费年限确定基础年金比例（6%~9%），延迟领取每年额外+2%
- 现金价值按交费期内/交费期后分段计算不同增长率
- 身故保险金取 max(已缴保费×110%, 现金价值)
- 支持 startAge 维度筛选（养老年金）

✅ **数据模型扩展（代码已实现）**：
- `annuity_rate` 表增加 `start_age`（INT NULL）、`plan_id`（VARCHAR(50) NULL）字段
- 唯一索引更新为 `(product_id, gender, age, payment_year, start_age, plan_id, policy_year)`
- `AnnuityRate` 实体类同步增加 startAge、planId 字段

---

### v1.8.19（2026-06-28）【收益演示公式推导 + 数据模型优化 + 产品结构对齐】

✅ **增额终身寿险收益演示公式推导（G.1）**：
- 基于中意人寿实际产品数据结构（现金价值表、费率表）推导固收型与分红型增额寿收益演示公式
- 明确现金价值表单位：每千元保费对应现金价值；费率表单位：每千元保额对应年缴保费
- 固收型公式：现金价值 = 年缴保费 × 现金价值系数 ÷ 1000；累计保费 = 年缴保费 × min(保单年度, 缴费年限)
- 分红型公式：保证部分与固收型一致；分红演示部分 = 保证部分 + (中档分红部分 - 保证部分) × (分红实现率 ÷ 100)
- 身故保险金计算：增额寿取 max(累计保费×给付比例, 现金价值, 有效保额)
- 补充分红演示数据表结构：product_dividend_config、whole_life_dividend_rate、annuity_dividend_rate
- 影响范围：第8章数据模型（8.11.4-8.11.6）、第10章API接口（10.8.2-10.8.3）

✅ **年金险收益演示公式推导（G.2）**：
- 基于现金价值公示表数据结构推导年金险收益演示公式
- 固收型年金险：年领取金额 = 年缴保费 × 年金系数 ÷ 1000；现金价值同理按比例换算
- 分红型年金险：保证领取与分红演示领取分别计算，分红实现率影响分红部分
- 累计领取从约定领取年龄开始逐年累加，月领取 = 年领取 × 月领系数（通常0.085）
- 影响范围：第10章API接口（10.8.3）

✅ **数据缺失与导入规范（G.3）**：
- 现金价值表数据覆盖率：增额寿部分产品覆盖保单年度1-105，年金险仅3个保单年度
- 分红利率数据当前全为NaN，需管理员在后台配置分红演示利率（低档/中档/高档）
- 费率表数据完整（投保年龄0-70岁，缴费期间趸交/3/5/10/15/20年）
- 建议导入流程：Excel原始表 → 数据清洗 → 按产品ID分表导入whole_life_rate/annuity_rate

✅ **产品结构对齐（G.4）**：
- 增额寿现金价值表结构：缴费期间 × 性别 × 投保年龄 → 保单年度1-105现金价值
- 增额寿费率表结构：投保年龄 × 缴费期间 → 每千元保额保费（男女分栏）
- 年金险现金价值公示表结构：保险公司 × 产品名称 × 保单年度 × 现金价值 × 性别 × 年龄 × 缴费期间 × 年金

---

### v1.8.18（2026-06-22）【代码实现同步 + 接口规范完善 + 安全问题修正】

✅ **代码实现与PRD同步（E.1）**：
- 实际代码已实现大量PRD未记录的接口和功能，本次更新将代码实现同步回PRD
- 新增/完善的接口模块：用户认证、微信登录、VIP体系、产品搜索、卡片模板、管理后台、数据看板
- 新增实体：UserInfo、UserVipRecord、AdminUser、AdminRole、AdminPermission、AdminRolePermission、DashboardStats
- 影响范围：第9章技术架构、第10章API接口规范、第8章数据模型

✅ **接口规范完善（E.2）**：
- 补充16个前端已定义但后端未实现的接口（标注为【待实现】）
- 统一接口路径风格：全部使用 `/api/v1/` 前缀
- 统一分页参数：`pageNum` + `pageSize`
- 补充完整的请求/响应DTO定义

✅ **安全问题修正（E.3）**：
- SecurityConfig白名单过大问题：当前几乎所有业务接口都在permitAll中，实际不强制JWT认证
- JWT密钥硬编码问题：密钥直接写在代码中，需改为配置文件或环境变量注入
- admin模块逻辑删除字段不一致：admin用`deleted`，api用`isDeleted`，已统一为`isDeleted`
- 补充接口限流设计：登录接口5次/分钟/IP，费率计算30次/分钟/用户，卡片生成10次/分钟/用户

✅ **枚举定义修正（E.4）**：
- MemberLevelEnum：原定义5等级(NORMAL/SILVER/GOLD/PLATINUM/DIAMOND)，实际使用0/1/2(普通/VIP/SVIP)，已同步为实际使用的3档
- ProductTypeEnum：原定义7种类型，实际使用1/2/3(重疾/终身寿/年金)，已同步为实际使用的3种

✅ **Docker部署方案补充（E.5）**：
- docker-compose.yml配置：MySQL 8.0 + Redis 7 + API(8080) + Admin(8081) + Nginx(80)
- 环境变量配置规范：微信appId/appSecret通过环境变量注入
- 数据库初始化脚本：01_create_database → 02_create_tables → 03_init_data → 04_import_companies → 05_import_products → 06_wechat_fields → 07_card_background_import

✅ **数据完整性问题确认（E.6）**：
- 费率表数据0覆盖、现金价值表数据0覆盖、分红相关字段缺失、IRR计算逻辑未实现
- 新增数据导入专项章节建议（见第17章）

✅ **前端路由与页面同步（E.7）**：
- 同步实际前端路由配置：/product/list, /product/:id, /compare, /card/generate, /user, /vip, /login, /register
- 同步业务组件清单：BackgroundSelector, BenefitTable, BirthdayBonus, CardGenerator, CompareTable, DiseaseList, DividendSelector, PayoutPlan, PremiumCalculator, ProductCard, ResponsibilityConfig, WithdrawalPlan
- 同步Pinia状态管理：userStore, productStore, compareStore

✅ **管理端页面字段对齐（F.1）**：
- 管理端三个产品列表页（重疾险/增额终身寿险/年金险）的模板使用了后端AdminProductVO中不存在的字段名（id/name/premium/coverage/term/status/displayStatus），导致页面渲染时报TypeError崩溃
- 修复方案：模板列统一使用AdminProductVO返回的字段（productId/productName/companyName/productTypeDesc/minAge/maxAge/paymentYears/saleStatus/systemStatus），添加parsePaymentYears辅助函数处理JSON格式缴费年限
- 影响文件：CriticalIllnessList.vue, WholeLifeList.vue, AnnuityList.vue

✅ **公司列表字段对齐（F.2）**：
- 后端AdminCompanyVO返回字段（companyId/companyName/companyShortName/logoUrl/officialWebsite/servicePhone/cooperationStatus/establishedYear/registeredCapital/createdAt/updatedAt），但前端Company接口使用旧字段（id/name/shortName/logo/website/phone/status/establishDate/createTime/updateTime）导致表格渲染"系统繁忙"错误
- 修复方案：更新company.ts的Company和CompanyDetail接口、重写CompanyList.vue模板所有列字段、对话框表单字段、事件处理参数
- 影响文件：company.ts, CompanyList.vue, RatingHistory.vue

✅ **VIP管理API路径修复 + 后端补充接口（F.3）**：
- 前端调用 /v1/admin/vip/user/list，后端实际路径为 /v1/admin/vip/users，导致"系统繁忙"错误
- 修复方案：前端API路径改为 /v1/admin/vip/users；后端新增两个缺失端点：PUT /v1/admin/vip/user/{id}/status（更新VIP状态）和 PUT /v1/admin/vip/user/{id}/extend（延长VIP期限）
- 影响文件：vip.ts, AdminVipController.java, AdminVipService.java, AdminVipServiceImpl.java, AdminVipStatusUpdateDTO.java, AdminVipExtendDTO.java

✅ **管理端认证端点补充（F.4）**：
- DashboardPage.vue登录后调用 /info 和 /logout 端点，但后端 AdminAuthController 未实现对应接口，SecurityConfig 也未放行这些路径，导致登录后自动跳回登录页
- 修复方案：AdminAuthController新增 GET /info（返回AdminInfoVO）、POST /logout、POST /refresh 三个端点；SecurityConfig 放行 /api/v1/admin/auth/info、/logout、/refresh 路径

✅ **卡片背景图批量导入（F.5）**：
- 通过Python脚本（import_card_templates.py）将638张自动生成的卡片背景图通过API导入系统数据库
- 分类覆盖：少儿教育金（50张）、养老规划（50张）、财富传承（53张）、重疾保障（52张）、少儿专属（56张）、家庭守护（55张）、企业主专属（43张）、节日营销（65张）、开门红专属（65张）、极简通用（149张）
- 导入脚本位置：临时工作目录的 import_card_templates.py

✅ **注册功能简化（F.6）**：
- 移除微信登录注册和手机验证码要求，改为仅用户名+强密码验证
- 注册时调用 /v1/auth/check-username 接口检查用户名唯一性
- 后端新增 RegisterDTO 简化版（仅username/password）、密码强度校验（8位以上字母+数字组合）、MyMetaObjectHandler添加isDeleted字段自动填充
- 前端RegisterView.vue移除验证码输入，LoginView.vue移除微信扫码登录Tab

✅ **赛博朋克样式统一（F.7）**：
- 重疾险/增额终身寿险/年金险详情页（CriticalIllnessDetail.vue, WholeLifeDetail.vue, AnnuityDetail.vue）使用硬编码浅色背景(#f5f7fa等)，与赛博朋克深色主题不符
- 修复方案：所有硬编码颜色替换为CSS变量（--bg-secondary, --border-color, --text-secondary, --accent-orange）

✅ **产品卡片显示优化（F.8）**：
- 前端ProductCard.vue将缴费期限字段改为显示可投保年龄范围和缴费方式
- 新增 displayAgeRange 和 displayPaymentMethod 两个computed属性
- 缴费方式解析逻辑：JSON格式paymentYears字段解析，1年→"趸交"，其它年限→"X年"

✅ **数据看板页面修复（F.9）**：
- DashboardPage.vue的DashboardStats接口字段与后端返回不匹配（totalProducts→totalProductCount等），导致统计卡片显示undefined
- ChartCard组件height属性类型不匹配（String→Number）
- 修复方案：更新所有字段映射为后端实际返回字段名，ChartCard的:height使用Number类型

✅ **卡片模板管理页面修复（F.10）**：
- 前端CardTemplate接口字段与后端AdminCardTemplateVO完全不匹配（id/name/type/description/previewUrl/status/createTime等 vs templateId/templateName/categoryCode/tags/aiPrompt/searchKeywords/backgroundUrl/defaultTitle/defaultSubtitle/isSystem/isRecommended/useCount7d/useCount30d/useCountTotal/lastUsedTime/sortOrder/isActive/createdAt/updatedAt），导致表格列全部显示undefined和"系统繁忙"
- 后端AdminCardTemplateController缺少删除、状态更新、图片上传接口，AdminCardTemplateQueryDTO缺少keyword字段导致前端搜索不可用
- 修复方案：
  - 前端：重写cardTemplate.ts接口定义（CardTemplate/CardTemplateForm/TemplateQuery/PageResult），重写TemplateList.vue模板（所有列使用正确字段名，添加parseTags辅助函数，分类显示使用CATEGORY_LABEL_MAP映射）
  - 后端：AdminCardTemplateQueryDTO新增keyword字段（支持templateName和searchKeywords模糊搜索）；AdminCardTemplateController新增DELETE /{templateId}、PUT /{templateId}/status、POST /upload三个端点；AdminCardTemplateService/Impl新增deleteCardTemplate、updateCardTemplateStatus方法
  - 新增VO：ProductDistributionVO、UserTrendVO、CardGenerationVO
  - DashboardServiceImpl实现getProductDistribution（按productType分组统计）、getUserTrend（按日期统计新增/活跃/VIP用户）、getCardGenerationStats（简化实现）
  - DashboardController补充三个GET端点：/product-distribution、/user-trend、/card-generation
- 影响文件：cardTemplate.ts, TemplateList.vue, AdminCardTemplateQueryDTO.java, AdminCardTemplateController.java, AdminCardTemplateService.java, AdminCardTemplateServiceImpl.java, AdminCardTemplateStatusDTO.java（新增）, DashboardService.java, DashboardServiceImpl.java, DashboardController.java, ProductDistributionVO.java（新增）, UserTrendVO.java（新增）, CardGenerationVO.java（新增）

✅ **产品管理编辑功能修复（F.11）**：
- 增额终身寿险和年金险列表页编辑按钮无跳转（handleEdit只显示ElMessage.info提示，handleAdd也只显示提示），用户无法进入编辑页面
- 三个产品编辑表单页（CriticalIllnessForm.vue/WholeLifeForm.vue/AnnuityForm.vue）的loadDetail方法使用旧字段名（res.name/res.companyId/res.category等），但后端ProductVO返回productName/companyId/productType等，导致编辑页所有字段为空
- 后端AdminProductController缺少GET /{productId}详情接口，返回404/500错误
- 路由配置缺少增额终身寿险和年金险的表单路由（/product/whole-life/form和/product/annuity/form）
- 修复方案：
  - WholeLifeList.vue/AnnuityList.vue：引入useRouter，handleAdd和handleEdit改为router.push跳转到对应表单页
  - router/index.ts：新增WholeLifeForm和AnnuityForm路由配置
  - CriticalIllnessForm.vue/WholeLifeForm.vue/AnnuityForm.vue：loadDetail方法字段映射修正为后端实际字段名（productName/companyId/productType/paymentYears/saleStatus等），subProductData字段使用res.subProductData解析
  - AdminProductController.java：新增GET /{productId}详情端点
  - AdminProductService.java/AdminProductServiceImpl.java：新增getProductDetail方法，查询ProductBase并关联InsuranceCompany返回AdminProductVO
- 影响文件：WholeLifeList.vue, AnnuityList.vue, router/index.ts, CriticalIllnessForm.vue, WholeLifeForm.vue, AnnuityForm.vue, AdminProductController.java, AdminProductService.java, AdminProductServiceImpl.java

---
✅ **前后端字段名统一（D.1）**：
- 前端Product接口使用`id`/`name`字段，后端ProductVO返回`productId`/`productName`，导致产品列表页"系统繁忙"、对比功能异常（点击一个产品所有都加入对比）、分页不显示总数
- 统一前端Product接口字段名为`productId`/`productName`，ProductListResult使用`pageNum`替代`page`
- 影响文件：api/product.ts, ProductList.vue, ProductCard.vue, HomePage.vue, ComparePage.vue, CardGenerate.vue, productStore.ts, compareStore.ts, AnnuityDetail.vue, WholeLifeDetail.vue, CriticalIllnessDetail.vue, ProductDetailWrapper.vue
✅ **产品详情页字段对齐（D.2）**：
- ProductDetail接口定义了后端不存在的字段（description, status, clauses, benefits, scenarios, faqs），导致详情页渲染崩溃
- ProductDetail接口改为匹配后端ProductVO实际字段（productCode, productTypeDesc, subType, minAge, maxAge, paymentYears, occupationClass等）
- 影响文件：api/product.ts, WholeLifeDetail.vue, CriticalIllnessDetail.vue, AnnuityDetail.vue
✅ **产品类型判断修复（D.3）**：
- ProductDetailWrapper.vue用字符串比较productType（'critical_illness'/'whole_life'/'annuity'），但后端返回数字（1/2/3）
- switch case同时支持数字和字符串两种格式
✅ **登录/注册API修复（D.4）**：
- 数据库user_info表缺少wechat_nickname、wechat_avatar、wechat_bound字段，与UserInfo实体类不匹配，导致登录/注册返回500错误
- ALTER TABLE添加缺失字段；用Python bcrypt重新生成正确的BCrypt密码哈希
✅ **API路径统一（D.5）**：
- Vite proxy rewrite规则会剥离/api前缀，导致前端请求路径与后端不匹配，返回403
- 移除vite.config.ts中的rewrite规则，客户端端口固定8001，管理端端口固定7988
✅ **SecurityConfig放行路径更新（D.6）**：
- 新增放行路径：/api/v1/product/**, /api/v1/company/**, /api/v1/auth/login, /api/v1/auth/register等
✅ **明亚数据对比验证（D.7）**：
- 本地系统215款产品 vs 明亚后台14款公开产品
- 基础字段覆盖较好（85分），product_base表字段基本覆盖明亚后台产品基础信息
- 缺失项：费率表数据0覆盖、现金价值表数据0覆盖、分红相关字段缺失、IRR计算逻辑未实现
- 详细报告：`数据验证/mingya_field_comparison_report.md`
✅ **产品数据来源确认（D.8）**：
- 产品数据为真实数据库数据（MySQL product_base表），非页面测试数据
- 数据来源：明亚保险经纪后台同步导入
- 保险公司包括：中华联合人寿、中意人寿、中汇人寿、中英人寿、信泰人寿、众安在线等

---

### v1.8.16（2026-06-18）【赛博朋克视觉设计 + 微信登录 + 卡片背景图导入 + 开发目录调整】
✅ **赛博朋克视觉设计规范（附录C.1）**：
- 完整配色体系（12色定义：主背景/次背景/三级背景/主文字/次文字/弱文字/霓虹紫/霓虹青/琥珀橙/霓虹红/霓虹绿/边框色）
- 字体规范（Orbitron标题 + Rajdhani正文 + 中文回退）
- 核心视觉元素（霓虹发光/毛玻璃/科技网格/渐变文字/深色半透明导航）
✅ **微信登录功能规范（附录C.2）**：
- 登录方式矩阵（PC账号密码/PC微信扫码/小程序微信一键登录）
- PC微信扫码登录完整流程（6步）
- 微信小程序登录流程（4步）
- 账号绑定微信机制
- 数据库字段扩展（5个新字段）
- 后端API接口（6个新接口）
✅ **卡片背景图导入状态（附录C.3）**：
- 现有20张素材盘点（3个系列）
- 数据库导入脚本说明
- 差距分析与AI生图补充建议
✅ **开发目录调整（附录C.4）**：
- 迁移至 `f:\天保星君\program\`
- 5个子项目目录说明

---

### v1.8.15（2026-06-17）【技术架构完整章节新增】
✅ **新增完整技术架构章节**：
- 系统整体架构设计（分层架构图、技术栈完整清单、项目目录结构）
- 数据库设计规范（命名规范、索引设计规范、字段设计规范、完整SQL建表规范）
- API接口设计规范（统一返回格式、RESTful API规范、分页查询规范、接口权限控制）
- 安全设计规范（认证与授权、参数校验、文件上传安全、XSS/SQL注入防护）
- 性能优化设计（缓存策略、数据库优化、前端性能优化）
- 部署与运维（Docker Compose配置、日志规范、监控告警）
- 前端与小程序兼容说明

---

### v1.8.14（2026-06-17）【自定义水印功能完整修正】
✅ **水印覆盖范围强制全屏**：
- 永久取消分区域控制设计
- 整个卡片1080px×任意高度全部覆盖水印
- 覆盖5大区域：顶部背景/方案详情/利益表格/扩展填充/底部信息
✅ **蜂窝状平铺算法完整规格**：
- 从(-50%, -50%)开始渲染，超出边界也覆盖
- 横向间隔÷密度系数（稀疏6/适中4/密集3）
- 纵向间隔=横向×0.866（正三角形比例）
- 奇数行偏移半个间隔，蜂窝状排列
- 整体旋转-45度
✅ **6项配置参数完整定义**：
- 水印文字（最多20字）、透明度（10%-50%）
- 密度（稀疏/适中/密集）、角度（30°/45°/60°）
- 字体大小（12px-36px）、颜色（黑/深灰/白）
✅ **会员权限分级控制**：
- 免费用户：❌ 无水印
- VIP会员：✅ 固定用户名水印，参数默认
- SVIP会员：✅ 自定义文字+全部6项参数自由调整
✅ **前端技术实现规格**：
- 渲染层级：水印层最顶层（z-index: 9999）
- SVG动态生成水印图案
- CSS规范完整定义
- html2canvas完美渲染

---

### v1.8.13（2026-06-17）【卡片背景图库系统完整设计】
✅ **微信小程序端卡片背景选择界面**：
- 顶部预览区 + 10大分类Tab + 搜索框 + 网格列表
- 热度标签：🔥热门 ⭐推荐 🆕新品
✅ **10大分类体系定义**：
- 少儿教育金、养老规划、财富传承、重疾保障、少儿专属
- 家庭守护、企业主专属、节日营销、开门红专属、极简通用
✅ **自定义水印功能升级**：
- 全卡片5大区域覆盖
- 6项配置项：文字、透明度、密度、角度、字体大小、颜色
✅ **卡片背景图库附录**：
- 500个背景完整规划（名称+标签+AI生图提示词）
- 10大分类数量分配
✅ **数据模型更新**：
- card_template表新增4个字段：category_code、tags、ai_prompt、search_keywords
✅ **管理端背景图库管理功能**：
- 分类筛选、标签搜索、热度排序
- 使用数据统计看板

---

### v1.8.12（2026-06-17）【后台菜单重构 + 产品双状态 + 保司数据看板】
✅ **后台管理菜单结构完整重构**
✅ **产品双状态体系（核心架构优化）**
✅ **保险公司管理全面升级（数据看板+评级历史）**

### v1.8.11（2026-06-16）【Java 21技术栈升级 + 保险公司完整模块】
✅ **技术栈全面升级（Java 21 LTS + Spring Boot 3.3.x）**
✅ **保险公司完整模块（100%对标明亚系统字段）**

### v1.8.10（2026-06-16）【缴费周期灵活配置 + 对比页智能隐藏】
✅ **缴费周期灵活配置机制**
✅ **对比页智能隐藏规则**

### v1.8.9（2026-06-16）【三大险种僵化设计全面修正】
✅ **所有固定选项改为产品级灵活配置，100%对齐明亚系统**

### v1.8.8（2026-06-16）【年金险祝寿金灵活配置机制】
✅ **移除固定节点设计，新增灵活配置表**

### v1.8.7（2026-06-16）【增额寿/年金险真实产品资料优化】
✅ **基于真实产品资料全面优化费率计算与领取计划**

### v1.8.6（2026-06-16）【重疾险责任编码体系v2.0升级】
✅ **32位编码结构 + 动态位分配机制**

### v1.8.5（2026-06-16）【费率导入功能升级】
✅ **Excel+PDF双格式导入**

### v1.8.4（2026-06-16）【重疾险费率计算系统重构】
✅ **责任组合唯一编码 + 4张核心数据表**

### v1.8.3（2026-06-16）【重疾险责任二级目录结构优化】
✅ **7大一级分类 + N个二级责任项**

### v1.8.2（2026-06-16）【VIP会员体系重大调整】
✅ **新三档会员架构（免费/VIP/SVIP）**

### v1.7.2（2026-06-16）【系统性整理完善正式版】
✅ **PRD文档系统性整理完善**

---

## 附录C：v1.8.16 更新日志

### C.1 赛博朋克视觉设计规范

系统采用赛博朋克（Cyberpunk）视觉风格，基于品牌IP形象（赛博柴犬）延伸设计。

**C.1.1 配色体系**

| 色彩角色 | 色值 | 用途 |
|---------|------|------|
| 主背景 | #0a0a0f | 页面底色 |
| 次背景 | #12121a | 卡片/面板背景 |
| 三级背景 | #1a1a2e | 输入框/下拉框 |
| 主文字 | #e0e0ff | 标题/正文 |
| 次文字 | #8888aa | 描述/辅助文字 |
| 弱文字 | #555577 | 占位符/禁用文字 |
| 霓虹紫 | #b347d9 | 主强调色、品牌色 |
| 霓虹青 | #00e5ff | 辅助强调色、链接 |
| 琥珀橙 | #ff8c00 | 警告、价格、重要数据 |
| 霓虹红 | #ff3366 | 错误、热门标签 |
| 霓虹绿 | #00ff88 | 成功、在线状态 |
| 边框色 | #2a2a4a | 分割线、边框 |

**C.1.2 字体规范**
- 标题字体：Orbitron（科技感展示字体）
- 正文字体：Rajdhani（清晰易读的无衬线字体）
- 中文回退：系统默认中文字体

**C.1.3 核心视觉元素**
- 霓虹发光效果（box-shadow + text-shadow）
- 毛玻璃效果（backdrop-filter: blur）
- 科技网格线背景
- 渐变文字（background-clip: text）
- 深色半透明导航栏

### C.2 微信登录功能规范

**C.2.1 登录方式矩阵**

| 端 | 登录方式 | 说明 |
|---|---------|------|
| PC网页 | 账号密码 | 用户名/手机号 + 密码 |
| PC网页 | 微信扫码 | 微信开放平台网站应用扫码 |
| 微信小程序 | 微信一键登录 | wx.login() 静默授权 |

**C.2.2 PC微信扫码登录流程**
1. 前端调用 `GET /api/wechat/qrcode` 获取微信二维码URL和sessionId
2. 前端展示二维码（iframe嵌入或二维码图片）
3. 前端每3秒轮询 `GET /api/wechat/qrcode/check?sessionId=xxx`
4. 用户使用微信扫码后，微信回调 `GET /api/wechat/callback?code=xxx&state=xxx`
5. 后端用code换取openid，查找/自动注册用户，生成JWT Token
6. 前端轮询到CONFIRMED状态，获取Token完成登录

**C.2.3 微信小程序登录流程**
1. 小程序端调用 `wx.login()` 获取临时code
2. 调用 `POST /api/wechat/mp/login` 传入code
3. 后端用code换取openid，查找/自动注册用户，返回LoginVO
4. 小程序端存储Token，后续请求携带Token

**C.2.4 账号绑定微信**
- 注册时可选绑定微信（跳转微信扫码）
- 已注册用户可在个人中心绑定/解绑微信
- 未绑定微信的用户仅可浏览产品，不可生成/保存/分享卡片

**C.2.5 数据库字段扩展**
```sql
ALTER TABLE user_info ADD COLUMN wechat_openid VARCHAR(64);
ALTER TABLE user_info ADD COLUMN wechat_unionid VARCHAR(64);
ALTER TABLE user_info ADD COLUMN wechat_nickname VARCHAR(128);
ALTER TABLE user_info ADD COLUMN wechat_avatar VARCHAR(512);
ALTER TABLE user_info ADD COLUMN wechat_bound TINYINT(1) DEFAULT 0;
```

**C.2.6 后端API接口**

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| /api/wechat/qrcode | GET | 获取PC扫码二维码 | 否 |
| /api/wechat/qrcode/check | GET | 轮询扫码状态 | 否 |
| /api/wechat/callback | GET | 微信开放平台回调 | 否 |
| /api/wechat/mp/login | POST | 小程序登录 | 否 |
| /api/wechat/bind | POST | 绑定微信 | 是 |
| /api/wechat/unbind | POST | 解绑微信 | 是 |

### C.3 卡片背景图导入状态

**C.3.1 现有素材**
- `卡片背景资料/` 目录下共20张背景图素材
- 分为3个系列：极简纯色(1张)、都市摩登女郎(6张)、中年家庭理财(13张)
- 均为APP界面截图，需裁剪后使用

**C.3.2 数据库导入**
- 已创建导入脚本 `07_card_background_import.sql`
- 20张素材按PRD 10大分类合理分配
- 分类编码已统一为PRD标准（EDUCATION/RETIREMENT/LEGACY/CRITICAL_ILLNESS等）

**C.3.3 差距说明**
- PRD要求500张预设背景图，当前仅有20张素材
- 建议后续通过AI生图补充剩余480张
- 每张背景图尺寸要求：1080x350px（顶部区域）

### C.4 开发目录调整

- 开发目录已迁移至 `f:\天保星君\program\`
- 包含：insurance-web、insurance-backend、insurance-admin-web、insurance-mp、insurance-deploy
- Logo文件：`program/logo.jpg`（赛博柴犬IP形象）

---

## 附录 D - v1.8.17 变更记录 (2026-06-18)

### D.1 API路径统一修复（修复403错误）

**问题**: 前端API请求路径与后端Controller路径不匹配，导致所有API请求返回403 Forbidden。

**根因分析**:
- 前端 baseURL 为 `/api`，请求路径如 `/products`，实际发送 `/api/products`
- 后端 Controller 路径为 `/api/v1/product/list`（带v1前缀，单数名词）
- SecurityConfig 仅放行 `/api/v1/**` 路径，前端请求命中 `.anyRequest().authenticated()` 返回403

**修复方案**: 统一前端API路径，添加 `/v1/` 前缀并匹配后端Controller路径。

**修改文件清单**:

| 文件 | 修改内容 |
|------|---------|
| `insurance-web/src/api/auth.ts` | 5处路径更新：login/register/user-info/send-code/refresh 添加 `/v1/` 前缀 |
| `insurance-web/src/api/product.ts` | 5处路径更新：products → v1/product/list等 |
| `insurance-web/src/api/company.ts` | 3处路径更新：companies → v1/company/list等 |
| `insurance-web/src/api/calculate.ts` | 5处路径更新：calculate → v1/calculate/* |
| `insurance-web/src/api/compare.ts` | 4处路径更新：compare → v1/compare/* |
| `insurance-web/src/api/card.ts` | 4处路径更新：cards → v1/card-template/* |
| `insurance-web/src/api/vip.ts` | 5处路径更新：vip → v1/vip/* |
| `insurance-web/src/api/request.ts` | token刷新硬编码路径 `/api/auth/refresh` → `/api/v1/auth/refresh` |
| `SecurityConfig.java` | 新增放行路径：`/api/v1/auth/send-code`、`/api/v1/user/info`、`/api/v1/vip/**`、`/api/wechat/**` |

### D.2 系统样式修复

**问题**: BaseSearch组件和LoginView组件使用硬编码白色背景 `#fff`，与赛博仙侠深色主题不符。

**修复内容**:
- `BaseSearch.vue`: `.base-search-wrapper` 背景色改为 `var(--bg-card)`，添加边框和圆角CSS变量
- `LoginView.vue`: `.qr-wrapper` 背景色改为 `var(--bg-card)`

### D.3 双主题系统设计

**新增文件**: `insurance-web/src/assets/styles/normal-theme.css`

**设计理念**: 系统支持两套主题风格，通过切换CSS文件实现：

| 主题 | 风格 | 文件 | 适用场景 |
|------|------|------|---------|
| 仙家版 | 赛博仙侠深色主题 | `cyberpunk-theme.css` | 品牌展示、年轻用户、科技感 |
| 普通版 | 专业保险浅色主题 | `normal-theme.css` | 正式场合、传统客户、商务场景 |

**普通版配色方案**:
- 主色: #2563EB (专业蓝)
- 辅助色: #0891B2 (青蓝)
- 强调色: #F59E0B (琥珀金)
- 背景主色: #F8FAFC (极浅灰蓝)
- 卡片背景: #FFFFFF (白色)
- 文字主色: #1E293B (深灰蓝)

**普通版专属工具类** (5个，与仙家版一一对应):
| 仙家版类名 | 普通版类名 | 效果 |
|-----------|-----------|------|
| `.tb-star-glow` | `.tb-gradient-header` | 渐变标题装饰 |
| `.tb-immortal-card` | `.tb-clean-card` | 简洁白色卡片 |
| `.tb-nebula-bg` | `.tb-subtle-bg` | 柔和浅色背景 |
| `.tb-star-trail` | `.tb-divider-line` | 优雅分割线 |
| `.tb-qi-glow` | `.tb-highlight-box` | 高亮提示框 |

**切换方式**: 在 `main.ts` 中通过条件导入不同主题CSS文件实现主题切换。

### D.4 Vite代理配置修复（二次修复403）

**问题**: 首次修复API路径后，前端仍报403错误。

**根因**: Vite `proxy` 配置中存在 `rewrite` 规则，会将 `/api` 前缀剥离：
```js
// 修复前 - 错误配置
proxy: {
  '/api': {
    target: 'http://localhost:8080',
    changeOrigin: true,
    rewrite: (path) => path.replace(/^\/api/, '')  // ← 剥离了/api前缀
  }
}
```
前端请求 `/api/v1/product/list` → 代理rewrite后发送 `/v1/product/list` 到后端 → 后端实际路径是 `/api/v1/product/list` → 403。

**修复方案**: 去掉 `rewrite` 规则，保留 `/api` 前缀完整转发到后端。

**修改文件**:

| 文件 | 修改内容 |
|------|---------|
| `insurance-web/vite.config.ts` | 去掉rewrite规则，端口改为8001 |
| `insurance-admin-web/vite.config.ts` | 去掉rewrite规则，端口改为7988 |

**端口固定**:
- 客户端Web: `http://localhost:8001`
- 管理端Web: `http://localhost:7988`
- API后端: `http://localhost:8080`
- Admin后端: `http://localhost:8081`

### D.5 管理端API路径修复及登录问题修复

**问题1**: 管理端前端API路径与后端不匹配，导致登录403。
**修复**: 管理端前端7个API文件共50处路径添加 `/v1/` 前缀，匹配后端 `/api/v1/admin/` 路径。

**问题2**: 数据库中无 `admin` 用户，默认账号无法登录。
**修复**: 在 `admin_user` 表中插入 `admin` 用户（密码: admin123）。

**问题3**: 后端登录响应字段与前端不匹配。
- 后端返回: `accessToken`, `adminInfo`（含 `adminId`, `realName`, `avatarUrl`）
- 前端期望: `token`, `refreshToken`, `admin`（含 `id`, `nickname`, `avatar`）
**修复**: 更新 `auth.ts` 的 `LoginResult` 和 `AdminInfo` 接口，更新 `userStore.ts` 的 `login` 方法和 computed 属性。

**问题4**: Vite代理 `rewrite` 规则剥离 `/api` 前缀。
**修复**: 去掉客户端和管理端 `vite.config.ts` 中的 `rewrite` 规则。

**端口固定**:
| 服务 | 端口 |
|------|------|
| 客户端Web | 8001 |
| 管理端Web | 7988 |
| API后端 | 8080 |
| Admin后端 | 8081 |

### D.6 后端缺失API接口补充

**问题**: 前端调用 `/api/v1/product/hot`、`/api/v1/product/types`、`/api/v1/product/search` 返回500，后端无对应接口。

**修复**: 在 `ProductController`、`ProductService`、`ProductServiceImpl` 中添加3个接口：
- `GET /api/v1/product/hot?limit=8` — 热门产品
- `GET /api/v1/product/types` — 产品类型列表
- `GET /api/v1/product/search?keyword=xxx` — 产品搜索

### D.7 前端组件修复

**Shield图标不存在**: `@element-plus/icons-vue` 无 `Shield` 导出，替换为 `Lock`。

**productType类型兼容**: 后端返回数字类型(1,2,3)，前端映射表使用字符串键。修复 `useProduct.ts` 的 `productTypeMap` 同时支持数字和字符串键，`getTypeLabel/getTypeColor` 函数使用 `String(type)` 转换。

### D.8 SecurityConfig放行路径更新

新增放行路径:
- `/api/v1/admin/auth/login` — 管理端登录
- `/admin/health` — 管理端健康检查
- `/api/v1/auth/send-code` — 发送验证码
- `/api/v1/user/info` — 获取用户信息
- `/api/v1/vip/**` — VIP相关（替代逐个放行）
- `/api/wechat/**` — 微信相关（替代逐个放行）

---

## 附录 E - v1.8.18 变更记录 (2026-06-23)

### E.1 JWT认证过滤器重构（修复用户信息接口401）

**问题**: 用户登录成功获取token后，调用 `/api/v1/user/info` 返回401 "请先登录"。

**根因分析**:
- `JwtAuthenticationFilter` 从token中提取userId（雪花算法数字ID，如 `2069090470768881665`）
- 然后调用 `userDetailsService.loadUserByUsername(String.valueOf(userId))` 查询用户
- 但 `UserDetailsServiceImpl` 是占位实现（TODO注释），硬编码返回固定用户，不查询数据库
- 即使查数据库，`UserInfo` 表的主键是userId，`loadUserByUsername` 期望的是username字段
- 导致认证对象无法创建，`SecurityContextHolder` 中无认证信息
- Controller中 `SecurityUtils.getCurrentUserId()` 返回null，手动返回401

**修复方案**: 重构JWT认证流程，不再依赖 `UserDetailsService` 查数据库，直接从JWT claims中提取用户信息构建认证对象。

**修改文件清单**:

| 文件 | 修改内容 |
|------|---------|
| `JwtAuthenticationFilter.java` | 完全重写：从JWT claims提取username、memberLevel、type等，直接构建UserDetails和权限列表，设置request attribute（userId、userType） |
| `SecurityUtils.java` | 完全重写：`getCurrentUserId()` 优先从request attribute获取userId（兼容Number/String/Long类型），新增 `getCurrentUserType()` 方法 |
| `JwtUtil.java` | 新增 `getClaim(token, key)` 方法，支持从JWT claims中提取自定义字段 |

**权限设计**:
- 普通用户: `ROLE_USER` + 可选 `ROLE_VIP`/`ROLE_SVIP`（根据memberLevel）
- 管理员: `ROLE_ADMIN` + `ROLE_ADMIN_{roleId}`

### E.2 客户端-管理端交互全面检查

**检查范围**: 全部4个服务（API:8080, Admin:8081, Web:8002, AdminWeb:7989）

#### 客户端交互流程验证结果

| 流程 | 状态 | 说明 |
|------|------|------|
| 注册 | ✅ 正常 | 注册成功返回token和用户信息，所有字段正确回写 |
| 登录 | ✅ 正常 | 登录成功跳转首页，导航栏显示用户名，显示"登录成功"提示 |
| 首页 | ✅ 正常 | 品牌展示、搜索框、三大险种入口、热门产品推荐（8个产品卡片）、平台优势 |
| 产品列表 | ✅ 正常 | 筛选条件（类型/公司/年限/关键词）、12个产品卡片、分页、查看详情/对比按钮 |
| 产品详情 | ✅ 正常 | 产品名称/公司、减保参数配置、年龄/性别/缴费期限/年缴保费、计算演示按钮 |
| 产品对比 | ✅ 正常 | 重疾险/终身寿险/年金险分别有独立对比接口，返回对比维度和值 |
| 卡片模板 | ✅ 正常 | 648个模板，字段完整（templateId/templateName/categoryCode/tags/isActive） |
| VIP | ⚠️ 部分可用 | VIP plans接口返回500，需后续完善 |

#### 管理端交互流程验证结果

| 流程 | 状态 | 说明 |
|------|------|------|
| 管理员登录 | ✅ 正常 | 登录成功，显示"系统管理员"，Dashboard数据正确 |
| 数据看板 | ✅ 正常 | 4个统计卡片（215产品/202公司/7用户/1VIP），数据与数据库一致 |
| 产品管理 | ✅ 正常 | 列表/详情/编辑页路由正常，字段映射正确 |
| 保险公司管理 | ✅ 正常 | 202家公司，字段完整 |
| 卡片模板管理 | ✅ 正常 | 648个模板，CRUD操作正常 |
| VIP会员管理 | ✅ 正常 | 用户列表和VIP记录列表均正常，字段完整（含orderNo/payTypeDesc/statusDesc） |

### E.3 数据库字段回写检查

#### ProductBase → ProductVO / AdminProductVO

| 字段 | 实体 | 客户端VO | 管理端VO | 回写状态 |
|------|------|---------|---------|---------|
| productId | ✅ | ✅ | ✅ | ✅ 正常 |
| productName | ✅ | ✅ | ✅ | ✅ 正常 |
| productCode | ✅ | ✅ | ✅ | ✅ 正常 |
| productType | ✅ | ✅ | ✅ | ✅ 正常 |
| subType | ✅ | ✅ | ✅ | ✅ 正常（部分产品为空，数据本身如此） |
| companyId | ✅ | ✅ | ✅ | ✅ 正常 |
| companyName | ❌（关联查询） | ✅（手动设置） | ✅（手动设置） | ✅ 正常 |
| productTypeDesc | ❌（计算字段） | ✅（手动设置） | ✅（手动设置） | ✅ 正常 |
| minAge/maxAge | ✅ | ✅ | ✅ | ✅ 正常 |
| paymentYears | ✅ | ✅ | ✅ | ✅ 正常（JSON数组） |
| paymentPeriods | ✅ | ✅ | ✅ | ✅ 正常（JSON数组） |
| occupationClass | ✅ | ✅ | ✅ | ✅ 正常 |
| monthlyRatio等费率 | ✅ | ✅ | ✅ | ⚠️ 部分产品为空（数据导入时未填充） |
| saleStatus/systemStatus | ✅ | ✅ | ✅ | ✅ 正常 |
| createdAt/updatedAt | ✅ | ✅ | ✅ | ✅ 正常 |
| createdBy/updatedBy/isDeleted | ✅ | ❌ 未暴露 | ❌ 未暴露 | ℹ️ 合理排除（内部字段） |
| subProductData | ❌（关联查询） | ✅（手动设置） | ❌ 不需要 | ✅ 正常 |

#### UserInfo → UserInfoVO

| 字段 | 回写状态 | 说明 |
|------|---------|------|
| userId/username/nickname/avatarUrl/phone/email/gender/birthday | ✅ 正常 | 全部正确映射 |
| memberLevel/memberExpireTime/status | ✅ 正常 | 正确映射 |
| wechatOpenid/wechatUnionid/wechatNickname/wechatAvatar/wechatBound | ✅ 正常 | 正确映射 |
| password | ℹ️ 合理排除 | 安全考虑不暴露给前端 |
| createdAt/updatedAt | ℹ️ 未暴露 | 可考虑在用户中心展示注册时间 |

#### InsuranceCompany → CompanyVO / AdminCompanyVO

| 字段 | 回写状态 | 说明 |
|------|---------|------|
| companyId/companyName/shortName/logoUrl/cooperationStatus | ✅ 正常 | 全部正确映射 |
| companyTypeDesc | ✅ 正常 | 手动计算字段 |
| remark | ℹ️ 未暴露 | 管理端可考虑展示 |

#### CardTemplate → AdminCardTemplateVO

| 字段 | 回写状态 | 说明 |
|------|---------|------|
| 全部字段（templateId/templateName/categoryCode/tags/backgroundUrl/isActive/isRecommended/useCount*/sortOrder等） | ✅ 正常 | 完整映射，无遗漏 |

### E.4 已知待优化项

| 编号 | 问题 | 优先级 | 说明 |
|------|------|--------|------|
| P1 | VIP plans接口返回500 | 中 | `/api/v1/vip/plans` 接口未实现，影响VIP购买流程 |
| P2 | 产品对比前端仅调用critical-illness路径 | 低 | `compare.ts` 中 `compareProducts` 固定调用 `/v1/compare/critical-illness`，未根据产品类型动态选择路径 |
| P3 | 部分产品费率字段为空 | 低 | monthlyRatio/quarterlyRatio等字段在数据库中未填充，非代码问题 |
| P4 | 部分产品companyName为空 | 低 | 少量产品的companyId无对应公司记录，非代码问题 |
| ~~P5~~ | ~~accessToken和refreshToken完全相同~~ | ~~低~~ | ~~已修复：refreshToken使用7天过期时间~~ |

### E.3 待优化项修复记录 (2026-06-23)

#### E.3.1 VIP Plans接口实现

**问题**: `/api/v1/vip/plans` 接口不存在，返回404/500。

**修复内容**:
- 新增 `VipPlanVO` 和 `VipPlanListVO` 类
- `VipController` 新增 `GET /api/v1/vip/plans` 端点
- `VipService` / `VipServiceImpl` 新增 `getVipPlans()` 方法
- 返回3个套餐：VIP月度(¥29.9)、VIP年度(¥199, 推荐)、SVIP年度(¥399)
- 同时返回当前用户VIP状态

**验证结果**: ✅ 正常返回3个套餐和当前用户状态

#### E.3.2 产品对比路径动态选择

**问题**: 前端 `compare.ts` 固定调用 `/v1/compare/critical-illness`，未根据产品类型选择对应路径。

**修复内容**:
- `compare.ts`: `compareProducts()` 新增 `productType` 参数，内部根据类型映射到正确路径
- `compareStore.ts`: `doCompare()` 新增 `productType` 参数，保存 `currentProductType` 状态

**路径映射**:
| 产品类型 | API路径 |
|---------|---------|
| critical_illness | `/v1/compare/critical-illness` |
| whole_life | `/v1/compare/whole-life` |
| annuity | `/v1/compare/annuity` |

**验证结果**: ✅ whole-life和annuity路径均正常返回对比数据

#### E.3.3 AccessToken/RefreshToken区分

**问题**: 登录时 accessToken 和 refreshToken 使用完全相同的参数生成，仅靠字段名区分。

**修复内容**:
- `JwtUtil.java`: 新增 `REFRESH_EXPIRATION = 7天`，新增 `generateRefreshToken()` 方法
- `UserServiceImpl.java`: `generateLoginVO()` 中 refreshToken 调用 `generateRefreshToken()`

**验证结果**: ✅ accessToken过期1天，refreshToken过期7天，差值6天

#### E.3.4 管理端产品列表改为抽屉弹窗

**需求**: 产品列表点击行即可查看详情和编辑，编辑和详情页面为抽屉弹窗。

**修改文件**:
- `CriticalIllnessList.vue` — 完全重写，添加抽屉组件
- `WholeLifeList.vue` — 完全重写，添加抽屉组件
- `AnnuityList.vue` — 完全重写，添加抽屉组件

**抽屉功能**:
- **查看模式**: `el-descriptions` 展示产品全部字段（ID、编码、名称、公司、类型、年龄、缴费年限/期间、职业类别、销售状态、系统状态、创建/更新时间）
- **编辑模式**: `el-form` 表单编辑产品名称、编码、公司、投保年龄、缴费年限、销售/系统状态
- **操作按钮**: 详情页有"编辑"和"关闭"按钮；编辑页有"保存"和"取消"按钮
- **产品名称列**: 改为 `el-link`，点击直接打开详情抽屉
- **行操作列**: 保留"编辑"和"删除"按钮，编辑按钮直接打开编辑抽屉
- **新增按钮**: 仍跳转独立表单页面（复杂表单不适合抽屉）

**交互流程**:
```
产品列表 → 点击行/产品名称 → 抽屉详情 → 点击"编辑" → 抽屉切换为编辑模式
产品列表 → 点击"编辑"按钮 → 直接打开编辑抽屉
产品列表 → 点击"新增"按钮 → 跳转独立表单页面
```
