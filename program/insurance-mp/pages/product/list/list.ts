import { Product, ProductType } from '../../../api/product';
import { getProductList } from '../../../api/product';
import { getCompareLimit, checkCompareLimit, showPermissionTip } from '../../../utils/permission';
import { getStorage, setStorage } from '../../../utils/storage';

// 分类Tab数据
const TABS = [
  { title: '全部', value: '' as ProductType | '' },
  { title: '重疾险', value: 'critical_illness' as ProductType },
  { title: '增额寿', value: 'whole_life' as ProductType },
  { title: '年金险', value: 'annuity' as ProductType },
];

Page({
  data: {
    tabs: TABS,
    activeTab: 0,
    products: [] as Product[],
    page: 1,
    pageSize: 10,
    hasMore: true,
    loading: false,
    refreshing: false,
    keyword: '',
    compareMode: false,
    compareList: [] as Array<{ id: string; name: string; companyName: string; logo?: string }>,
    showCompareBar: false,
    maxCompareCount: 3,
  },

  onLoad(options: Record<string, string>) {
    // 从URL参数获取类型
    if (options.type) {
      const tabIndex = TABS.findIndex((tab) => tab.value === options.type);
      if (tabIndex > -1) {
        this.setData({ activeTab: tabIndex });
      }
    }

    // 对比模式
    if (options.compareMode === 'true') {
      this.setData({ compareMode: true });
    }

    // 获取会员等级对应的对比限制
    const maxCount = getCompareLimit();
    this.setData({ maxCompareCount: maxCount });

    // 加载已保存的对比列表
    this.loadCompareList();

    // 加载产品列表
    this.loadProducts(true);
  },

  onShow() {
    // 刷新对比限制
    const maxCount = getCompareLimit();
    if (maxCount !== this.data.maxCompareCount) {
      this.setData({ maxCompareCount: maxCount });
    }
  },

  onPullDownRefresh() {
    this.setData({ refreshing: true });
    this.loadProducts(true).finally(() => {
      wx.stopPullDownRefresh();
      this.setData({ refreshing: false });
    });
  },

  onReachBottom() {
    if (this.data.hasMore && !this.data.loading) {
      this.loadProducts(false);
    }
  },

  // 加载产品列表
  async loadProducts(reset: boolean = false) {
    if (this.data.loading) return;

    const page = reset ? 1 : this.data.page;
    const { pageSize, activeTab, keyword } = this.data;
    const type = TABS[activeTab].value;

    this.setData({ loading: true });

    try {
      const result = await getProductList({
        type: type || undefined,
        keyword: keyword || undefined,
        page,
        pageSize,
      }).catch(() => this.getMockProducts(page, pageSize, type, keyword));

      const newProducts = reset ? result.list : [...this.data.products, ...result.list];

      this.setData({
        products: newProducts,
        page: page + 1,
        hasMore: result.hasMore,
        loading: false,
      });
    } catch (error) {
      console.error('加载产品列表失败:', error);
      this.setData({ loading: false });
    }
  },

  // 模拟产品数据
  getMockProducts(page: number, pageSize: number, type?: string, keyword?: string): {
    list: Product[];
    total: number;
    page: number;
    pageSize: number;
    hasMore: boolean;
  } {
    const allProducts: Product[] = [
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
      },
      {
        id: '3',
        name: '增额终身寿A款',
        companyId: '3',
        companyName: '太平洋保险',
        companyLogo: '',
        type: 'whole_life',
        typeName: '增额寿',
        tags: ['3.5%复利', '灵活取现'],
        price: 1000000,
        priceUnit: '年',
        coverage: 100000000,
        coverageUnit: '元',
        summary: '3.5%复利递增，灵活减保取现',
        hotScore: 92,
        isHot: true,
        isNew: true,
        createTime: '2024-03-01',
      },
      {
        id: '4',
        name: '年金险尊享版',
        companyId: '4',
        companyName: '泰康人寿',
        companyLogo: '',
        type: 'annuity',
        typeName: '年金险',
        tags: ['养老规划', '保证领取'],
        price: 500000,
        priceUnit: '年',
        coverage: 20000000,
        coverageUnit: '元',
        summary: '保证领取20年，养老无忧',
        hotScore: 85,
        isHot: false,
        isNew: true,
        createTime: '2024-02-01',
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
      },
      {
        id: '6',
        name: '金玉满堂2.0',
        companyId: '6',
        companyName: '弘康人寿',
        companyLogo: '',
        type: 'whole_life',
        typeName: '增额寿',
        tags: ['高现价', '快速回本'],
        price: 1000000,
        priceUnit: '年',
        coverage: 80000000,
        coverageUnit: '元',
        summary: '现金价值高，第5年回本',
        hotScore: 93,
        isHot: true,
        isNew: false,
        createTime: '2024-01-15',
      },
      {
        id: '7',
        name: '养多多3号',
        companyId: '7',
        companyName: '大家养老',
        companyLogo: '',
        type: 'annuity',
        typeName: '年金险',
        tags: ['高领取', '对接养老社区'],
        price: 300000,
        priceUnit: '年',
        coverage: 15000000,
        coverageUnit: '元',
        summary: '领取金额高，可对接养老社区',
        hotScore: 87,
        isHot: false,
        isNew: true,
        createTime: '2024-02-20',
      },
      {
        id: '8',
        name: '超级玛丽9号',
        companyId: '8',
        companyName: '君龙人寿',
        companyLogo: '',
        type: 'critical_illness',
        typeName: '重疾险',
        tags: ['网红产品', '责任全面'],
        price: 580000,
        priceUnit: '年',
        coverage: 50000000,
        coverageUnit: '元',
        summary: '网红重疾险，保障责任全面',
        hotScore: 91,
        isHot: true,
        isNew: true,
        createTime: '2024-03-10',
      },
      {
        id: '9',
        name: '康宁终身2024',
        companyId: '2',
        companyName: '中国人寿',
        companyLogo: '',
        type: 'critical_illness',
        typeName: '重疾险',
        tags: ['经典产品', '保障全面'],
        price: 850000,
        priceUnit: '年',
        coverage: 40000000,
        coverageUnit: '元',
        summary: '经典重疾险，保障全面',
        hotScore: 82,
        isHot: false,
        isNew: false,
        createTime: '2024-01-01',
      },
      {
        id: '10',
        name: '鑫享未来',
        companyId: '3',
        companyName: '太平洋保险',
        companyLogo: '',
        type: 'whole_life',
        typeName: '增额寿',
        tags: ['双被保人', '传承规划'],
        price: 2000000,
        priceUnit: '年',
        coverage: 120000000,
        coverageUnit: '元',
        summary: '双被保人设计，财富传承首选',
        hotScore: 89,
        isHot: false,
        isNew: true,
        createTime: '2024-03-20',
      },
    ];

    let filtered = allProducts;

    // 按类型筛选
    if (type) {
      filtered = filtered.filter((p) => p.type === type);
    }

    // 按关键词筛选
    if (keyword) {
      filtered = filtered.filter(
        (p) => p.name.includes(keyword) || p.companyName.includes(keyword)
      );
    }

    const start = (page - 1) * pageSize;
    const end = start + pageSize;
    const list = filtered.slice(start, end);

    return {
      list,
      total: filtered.length,
      page,
      pageSize,
      hasMore: end < filtered.length,
    };
  },

  // Tab切换
  onTabChange(e: WechatMiniprogram.TouchEvent) {
    const { index } = e.detail;
    this.setData({ activeTab: index });
    this.loadProducts(true);
  },

  // 搜索
  onSearch(e: WechatMiniprogram.TouchEvent) {
    const { value } = e.detail;
    this.setData({ keyword: value });
    this.loadProducts(true);
  },

  // 搜索取消
  onSearchCancel() {
    this.setData({ keyword: '' });
    this.loadProducts(true);
  },

  // 切换对比模式
  onToggleCompareMode() {
    const { compareMode } = this.data;
    this.setData({ compareMode: !compareMode });
  },

  // 对比选择变化
  onCompareChange(e: WechatMiniprogram.TouchEvent) {
    const { product, checked } = e.detail;
    const { compareList, maxCompareCount } = this.data;

    if (checked) {
      // 检查是否超过限制
      if (compareList.length >= maxCompareCount) {
        wx.showToast({
          title: `最多选择${maxCompareCount}款产品`,
          icon: 'none',
        });
        return;
      }

      // 检查是否已存在
      if (compareList.some((item) => item.id === product.id)) {
        return;
      }

      const newList = [
        ...compareList,
        {
          id: product.id,
          name: product.name,
          companyName: product.companyName,
          logo: product.companyLogo,
        },
      ];

      this.setData({
        compareList: newList,
        showCompareBar: true,
      });
      this.saveCompareList(newList);
    } else {
      const newList = compareList.filter((item) => item.id !== product.id);
      this.setData({
        compareList: newList,
        showCompareBar: newList.length > 0,
      });
      this.saveCompareList(newList);
    }
  },

  // 检查产品是否在对比列表中
  isInCompareList(productId: string): boolean {
    return this.data.compareList.some((item) => item.id === productId);
  },

  // 保存对比列表
  saveCompareList(list: Array<{ id: string; name: string; companyName: string; logo?: string }>) {
    setStorage('compareList', list);
  },

  // 加载对比列表
  loadCompareList() {
    const list = getStorage<Array<{ id: string; name: string; companyName: string; logo?: string }>>('compareList') || [];
    this.setData({
      compareList: list,
      showCompareBar: list.length > 0,
    });
  },

  // 移除对比项
  onRemoveCompare(e: WechatMiniprogram.TouchEvent) {
    const { index } = e.detail;
    const newList = [...this.data.compareList];
    newList.splice(index, 1);
    this.setData({
      compareList: newList,
      showCompareBar: newList.length > 0,
    });
    this.saveCompareList(newList);
  },

  // 清空对比
  onClearCompare() {
    this.setData({
      compareList: [],
      showCompareBar: false,
    });
    this.saveCompareList([]);
  },

  // 关闭对比栏
  onCloseCompareBar() {
    this.setData({ showCompareBar: false });
  },
});
