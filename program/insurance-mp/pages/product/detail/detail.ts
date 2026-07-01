import { ProductDetail, Responsibility, BenefitDemo, CompanyInfo } from '../../../api/product';
import { getProductDetail } from '../../../api/product';
import { getStorage, setStorage } from '../../../utils/storage';
import { formatAmountWithComma } from '../../../utils/format';

// Tab类型
type DetailTab = 'responsibility' | 'benefit' | 'company';

Page({
  data: {
    productId: '',
    product: null as ProductDetail | null,
    activeTab: 'responsibility' as DetailTab,
    loading: true,
    isInCompare: false,
    formattedPrice: '',
    formattedCoverage: '',
    // 利益演示表格数据
    benefitYears: [1, 5, 10, 20, 30, 40] as number[],
    benefitData: [] as BenefitDemo[],
  },

  onLoad(options: Record<string, string>) {
    const { id } = options;
    if (!id) {
      wx.showToast({
        title: '产品ID不能为空',
        icon: 'none',
      });
      wx.navigateBack();
      return;
    }

    this.setData({ productId: id });
    this.loadProductDetail(id);
    this.checkCompareStatus(id);
  },

  onShareAppMessage() {
    const { product } = this.data;
    return {
      title: product ? `${product.name} - 天保星君` : '天保星君 - 专业保险对比平台',
      path: `/pages/product/detail/detail?id=${this.data.productId}`,
    };
  },

  // 加载产品详情
  async loadProductDetail(id: string) {
    this.setData({ loading: true });

    try {
      const product = await getProductDetail(id).catch(() => this.getMockProductDetail(id));

      this.setData({
        product,
        loading: false,
        formattedPrice: formatAmountWithComma(product.price),
        formattedCoverage: formatAmountWithComma(product.coverage, 0),
        benefitData: product.benefitDemo || this.getMockBenefitData(),
      });

      // 设置导航栏标题
      wx.setNavigationBarTitle({
        title: product.name,
      });
    } catch (error) {
      console.error('加载产品详情失败:', error);
      this.setData({ loading: false });
    }
  },

  // 检查对比状态
  checkCompareStatus(productId: string) {
    const compareList = getStorage<Array<{ id: string }>>('compareList') || [];
    this.setData({
      isInCompare: compareList.some((item) => item.id === productId),
    });
  },

  // Tab切换
  onTabChange(e: WechatMiniprogram.TouchEvent) {
    const { name } = e.detail;
    this.setData({ activeTab: name as DetailTab });
  },

  // 切换对比状态
  onToggleCompare() {
    const { productId, isInCompare, product } = this.data;
    if (!product) return;

    const compareList = getStorage<Array<{ id: string; name: string; companyName: string; logo?: string }>>('compareList') || [];

    if (isInCompare) {
      // 移除对比
      const newList = compareList.filter((item) => item.id !== productId);
      setStorage('compareList', newList);
      this.setData({ isInCompare: false });
      wx.showToast({
        title: '已移除对比',
        icon: 'success',
      });
    } else {
      // 添加对比
      if (compareList.length >= 3) {
        wx.showToast({
          title: '最多对比3款产品',
          icon: 'none',
        });
        return;
      }

      const newList = [
        ...compareList,
        {
          id: productId,
          name: product.name,
          companyName: product.companyName,
          logo: product.companyLogo,
        },
      ];
      setStorage('compareList', newList);
      this.setData({ isInCompare: true });
      wx.showToast({
        title: '已加入对比',
        icon: 'success',
      });
    }
  },

  // 生成卡片
  onGenerateCard() {
    const { productId } = this.data;
    wx.navigateTo({
      url: `/pages/card/generate/generate?productId=${productId}`,
    });
  },

  // 模拟产品详情数据
  getMockProductDetail(id: string): ProductDetail {
    const responsibilities: Responsibility[] = [
      {
        name: '重大疾病保险金',
        description: '确诊合同约定的重大疾病，给付基本保额',
        amount: '50万',
        isMain: true,
      },
      {
        name: '轻症疾病保险金',
        description: '确诊合同约定的轻症疾病，给付基本保额的30%',
        amount: '15万',
        isMain: false,
      },
      {
        name: '中症疾病保险金',
        description: '确诊合同约定的中症疾病，给付基本保额的60%',
        amount: '30万',
        isMain: false,
      },
      {
        name: '身故保险金',
        description: '被保险人身故，给付基本保额与现金价值较大者',
        amount: '50万',
        isMain: false,
      },
      {
        name: '豁免保险费',
        description: '确诊轻症/中症/重疾后，豁免后续保费',
        amount: '豁免',
        isMain: false,
      },
    ];

    const companyInfo: CompanyInfo = {
      id: '1',
      name: '中国平安人寿保险股份有限公司',
      logo: '',
      establishDate: '2002年',
      registeredCapital: '338亿元',
      riskRating: 'A',
      satisfaction: '95%',
      complaintRate: '0.02%',
      introduction: '中国平安人寿保险股份有限公司成立于2002年，是中国平安保险（集团）股份有限公司旗下的重要成员。公司服务网络遍布全国，向客户提供全周期人身保险产品和服务。',
    };

    return {
      id,
      name: '平安福2024',
      companyId: '1',
      companyName: '中国平安',
      companyLogo: '',
      type: 'critical_illness',
      typeName: '重疾险',
      tags: ['多次赔付', '终身保障', '品牌优选'],
      price: 1250000,
      priceUnit: '年',
      coverage: 50000000,
      coverageUnit: '元',
      summary: '涵盖180种疾病，多次赔付，终身保障',
      hotScore: 95,
      isHot: true,
      isNew: false,
      createTime: '2024-01-01',
      description: '平安福2024是一款终身重大疾病保险产品，涵盖180种疾病保障，包括120种重疾、40种轻症、20种中症。支持多次赔付，最高可赔付6次。附加身故保障，保障全面。',
      features: [
        '保障180种疾病，覆盖全面',
        '重疾多次赔付，最高6次',
        '轻症/中症额外赔付',
        '确诊豁免后续保费',
        '终身保障，安心无忧',
      ],
      responsibilities,
      benefitDemo: this.getMockBenefitData(),
      companyInfo,
      conditions: [
        '投保年龄：出生满28天至55周岁',
        '保险期间：终身',
        '缴费期间：10年/15年/20年/30年',
        '等待期：90天',
      ],
      exclusions: [
        '投保人对被保险人的故意杀害、故意伤害',
        '被保险人故意犯罪或抗拒依法采取的刑事强制措施',
        '被保险人自本合同成立或复效之日起2年内自杀',
        '被保险人酒后驾驶、无合法有效驾驶证驾驶',
        '战争、军事冲突、暴乱或武装叛乱',
      ],
    };
  },

  // 模拟利益演示数据
  getMockBenefitData(): BenefitDemo[] {
    return [
      { year: 1, age: 31, premium: 12500, cashValue: 3200, deathBenefit: 500000, surrenderValue: 3200 },
      { year: 5, age: 35, premium: 62500, cashValue: 28500, deathBenefit: 500000, surrenderValue: 28500 },
      { year: 10, age: 40, premium: 125000, cashValue: 78000, deathBenefit: 500000, surrenderValue: 78000 },
      { year: 20, age: 50, premium: 250000, cashValue: 195000, deathBenefit: 500000, surrenderValue: 195000 },
      { year: 30, age: 60, premium: 375000, cashValue: 368000, deathBenefit: 500000, surrenderValue: 368000 },
      { year: 40, age: 70, premium: 500000, cashValue: 520000, deathBenefit: 500000, surrenderValue: 520000 },
    ];
  },

  // 格式化金额
  formatMoney(amount: number): string {
    return formatAmountWithComma(amount, 0);
  },
});
