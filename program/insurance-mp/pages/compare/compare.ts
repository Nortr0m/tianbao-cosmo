import { ProductDetail, ComparisonItem } from '../../api/product';
import { compareProducts } from '../../api/product';
import { formatAmountWithComma } from '../../utils/format';
import { getStorage, setStorage } from '../../utils/storage';

Page({
  data: {
    productIds: [] as string[],
    products: [] as ProductDetail[],
    comparison: [] as ComparisonItem[],
    loading: true,
    empty: false,
  },

  onLoad(options: Record<string, string>) {
    const { ids } = options;
    if (!ids) {
      // 尝试从storage获取
      const compareList = getStorage<Array<{ id: string }>>('compareList') || [];
      if (compareList.length < 2) {
        this.setData({
          loading: false,
          empty: true,
        });
        return;
      }
      const productIds = compareList.map((item) => item.id);
      this.setData({ productIds });
      this.loadCompareData(productIds);
    } else {
      const productIds = ids.split(',');
      this.setData({ productIds });
      this.loadCompareData(productIds);
    }
  },

  onShareAppMessage() {
    const { productIds } = this.data;
    return {
      title: '保险产品对比 - 天保星君',
      path: `/pages/compare/compare?ids=${productIds.join(',')}`,
    };
  },

  // 加载对比数据
  async loadCompareData(productIds: string[]) {
    this.setData({ loading: true });

    try {
      const result = await compareProducts({ productIds }).catch(() =>
        this.getMockCompareData(productIds)
      );

      this.setData({
        products: result.products,
        comparison: result.comparison,
        loading: false,
        empty: false,
      });
    } catch (error) {
      console.error('加载对比数据失败:', error);
      this.setData({ loading: false });
    }
  },

  // 模拟对比数据
  getMockCompareData(productIds: string[]): {
    products: ProductDetail[];
    comparison: ComparisonItem[];
  } {
    const products: ProductDetail[] = [
      {
        id: '1',
        name: '平安福2024',
        companyId: '1',
        companyName: '中国平安',
        companyLogo: '',
        type: 'critical_illness',
        typeName: '重疾险',
        tags: ['多次赔付', '终身保障'],
        price: 1250000,
        priceUnit: '年',
        coverage: 50000000,
        coverageUnit: '元',
        summary: '涵盖180种疾病，多次赔付，终身保障',
        hotScore: 95,
        isHot: true,
        isNew: false,
        createTime: '2024-01-01',
        description: '',
        features: [],
        responsibilities: [],
        benefitDemo: [],
        companyInfo: {
          id: '1',
          name: '中国平安',
          logo: '',
          establishDate: '2002年',
          registeredCapital: '338亿元',
          riskRating: 'A',
          satisfaction: '95%',
          complaintRate: '0.02%',
          introduction: '',
        },
        conditions: [],
        exclusions: [],
      },
      {
        id: '2',
        name: '国寿福盛典版',
        companyId: '2',
        companyName: '中国人寿',
        companyLogo: '',
        type: 'critical_illness',
        typeName: '重疾险',
        tags: ['品牌保障', '返还型'],
        price: 980000,
        priceUnit: '年',
        coverage: 30000000,
        coverageUnit: '元',
        summary: '大品牌保障，满期返还保费',
        hotScore: 88,
        isHot: true,
        isNew: false,
        createTime: '2024-01-01',
        description: '',
        features: [],
        responsibilities: [],
        benefitDemo: [],
        companyInfo: {
          id: '2',
          name: '中国人寿',
          logo: '',
          establishDate: '1949年',
          registeredCapital: '282亿元',
          riskRating: 'A',
          satisfaction: '93%',
          complaintRate: '0.03%',
          introduction: '',
        },
        conditions: [],
        exclusions: [],
      },
      {
        id: '5',
        name: '达尔文8号',
        companyId: '5',
        companyName: '信泰人寿',
        companyLogo: '',
        type: 'critical_illness',
        typeName: '重疾险',
        tags: ['性价比高', '可选责任多'],
        price: 650000,
        priceUnit: '年',
        coverage: 50000000,
        coverageUnit: '元',
        summary: '高性价比，可选责任丰富',
        hotScore: 90,
        isHot: true,
        isNew: true,
        createTime: '2024-03-15',
        description: '',
        features: [],
        responsibilities: [],
        benefitDemo: [],
        companyInfo: {
          id: '5',
          name: '信泰人寿',
          logo: '',
          establishDate: '2007年',
          registeredCapital: '50亿元',
          riskRating: 'B',
          satisfaction: '91%',
          complaintRate: '0.05%',
          introduction: '',
        },
        conditions: [],
        exclusions: [],
      },
    ];

    const comparison: ComparisonItem[] = [
      {
        key: 'company',
        label: '保险公司',
        values: ['中国平安', '中国人寿', '信泰人寿'],
      },
      {
        key: 'type',
        label: '产品类型',
        values: ['重疾险', '重疾险', '重疾险'],
      },
      {
        key: 'price',
        label: '年缴保费',
        values: ['12,500元', '9,800元', '6,500元'],
        highlight: 2,
      },
      {
        key: 'coverage',
        label: '基本保额',
        values: ['50万元', '30万元', '50万元'],
      },
      {
        key: 'diseaseCount',
        label: '保障疾病数',
        values: ['180种', '160种', '190种'],
        highlight: 2,
      },
      {
        key: 'criticalIllness',
        label: '重疾赔付次数',
        values: ['6次', '1次', '3次'],
        highlight: 0,
      },
      {
        key: 'lightIllness',
        label: '轻症赔付比例',
        values: ['30%', '20%', '30%'],
      },
      {
        key: 'mediumIllness',
        label: '中症赔付比例',
        values: ['60%', '50%', '60%'],
      },
      {
        key: 'waitingPeriod',
        label: '等待期',
        values: ['90天', '180天', '90天'],
        highlight: 0,
      },
      {
        key: 'riskRating',
        label: '公司风险评级',
        values: ['A', 'A', 'B'],
      },
    ];

    return {
      products: products.filter((p) => productIds.includes(p.id)),
      comparison,
    };
  },

  // 格式化金额
  formatMoney(amount: number): string {
    return formatAmountWithComma(amount, 0);
  },

  // 移除对比产品
  onRemoveProduct(e: WechatMiniprogram.TouchEvent) {
    const { index } = e.currentTarget.dataset;
    const { products, productIds, comparison } = this.data;

    if (products.length <= 2) {
      wx.showToast({
        title: '至少保留2款产品',
        icon: 'none',
      });
      return;
    }

    const newProducts = [...products];
    const removedProduct = newProducts.splice(index, 1)[0];

    // 更新对比项
    const newComparison = comparison.map((item) => {
      const newValues = [...item.values];
      newValues.splice(index, 1);
      return {
        ...item,
        values: newValues,
        highlight: item.highlight === index ? undefined : item.highlight !== undefined && item.highlight > index ? item.highlight - 1 : item.highlight,
      };
    });

    const newProductIds = productIds.filter((id) => id !== removedProduct.id);

    // 更新storage
    const compareList = getStorage<Array<{ id: string; name: string; companyName: string }>>('compareList') || [];
    const newCompareList = compareList.filter((item) => item.id !== removedProduct.id);
    setStorage('compareList', newCompareList);

    this.setData({
      products: newProducts,
      productIds: newProductIds,
      comparison: newComparison,
    });
  },

  // 去产品列表添加更多
  onAddMore() {
    wx.switchTab({
      url: '/pages/product/list/list?compareMode=true',
    });
  },

  // 查看产品详情
  onViewDetail(e: WechatMiniprogram.TouchEvent) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/product/detail/detail?id=${id}`,
    });
  },
});
