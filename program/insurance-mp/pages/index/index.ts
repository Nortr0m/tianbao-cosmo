import { Product } from '../../api/product';
import { getHotProducts, getNewProducts } from '../../api/product';

// 首页数据接口
interface IndexData {
  banners: Banner[];
  categories: Category[];
  hotProducts: Product[];
  newProducts: Product[];
  loading: boolean;
}

// Banner接口
interface Banner {
  id: string;
  image: string;
  title: string;
  url: string;
}

// 分类接口
interface Category {
  id: string;
  name: string;
  icon: string;
  color: string;
  path: string;
}

Page({
  data: {
    banners: [] as Banner[],
    categories: [] as Category[],
    hotProducts: [] as Product[],
    newProducts: [] as Product[],
    loading: true,
  } as IndexData,

  onLoad() {
    this.loadData();
  },

  onPullDownRefresh() {
    this.loadData().finally(() => {
      wx.stopPullDownRefresh();
    });
  },

  onShareAppMessage() {
    return {
      title: '天保星君 - 专业保险对比平台',
      path: '/pages/index/index',
    };
  },

  // 加载数据
  async loadData() {
    this.setData({ loading: true });

    try {
      // 模拟Banner数据
      const banners: Banner[] = [
        {
          id: '1',
          image: 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=800',
          title: '专业保险对比平台',
          url: '',
        },
        {
          id: '2',
          image: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800',
          title: '精选优质保险产品',
          url: '',
        },
        {
          id: '3',
          image: 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=800',
          title: '一键生成保险卡片',
          url: '',
        },
      ];

      // 险种分类
      const categories: Category[] = [
        {
          id: 'critical_illness',
          name: '重疾险',
          icon: 'shield-o',
          color: '#E53E3E',
          path: '/pages/product/list/list?type=critical_illness',
        },
        {
          id: 'whole_life',
          name: '增额寿',
          icon: 'gem-o',
          color: '#2B6CB0',
          path: '/pages/product/list/list?type=whole_life',
        },
        {
          id: 'annuity',
          name: '年金险',
          icon: 'gold-coin-o',
          color: '#38A169',
          path: '/pages/product/list/list?type=annuity',
        },
        {
          id: 'compare',
          name: '产品对比',
          icon: 'exchange',
          color: '#D69E2E',
          path: '/pages/product/list/list?compareMode=true',
        },
        {
          id: 'card',
          name: '生成卡片',
          icon: 'photo-o',
          color: '#805AD5',
          path: '/pages/card/generate/generate',
        },
        {
          id: 'vip',
          name: 'VIP特权',
          icon: 'vip-card-o',
          color: '#DD6B20',
          path: '/pages/user/user',
        },
      ];

      // 获取热门产品
      const hotProducts = await getHotProducts(4).catch(() => this.getMockProducts().slice(0, 4));

      // 获取新品推荐
      const newProducts = await getNewProducts(4).catch(() => this.getMockProducts().slice(4, 8));

      this.setData({
        banners,
        categories,
        hotProducts,
        newProducts,
        loading: false,
      });
    } catch (error) {
      console.error('加载首页数据失败:', error);
      this.setData({ loading: false });
    }
  },

  // 模拟产品数据
  getMockProducts(): Product[] {
    return [
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
    ];
  },

  // Banner点击
  onBannerTap(e: WechatMiniprogram.TouchEvent) {
    const { item } = e.currentTarget.dataset;
    if (item.url) {
      wx.navigateTo({
        url: item.url,
      });
    }
  },

  // 分类点击
  onCategoryTap(e: WechatMiniprogram.TouchEvent) {
    const { item } = e.currentTarget.dataset;
    if (item.path) {
      if (item.path.startsWith('/pages/user')) {
        wx.switchTab({ url: item.path });
      } else {
        wx.navigateTo({ url: item.path });
      }
    }
  },

  // 查看更多热门产品
  onViewMoreHot() {
    wx.switchTab({
      url: '/pages/product/list/list',
    });
  },

  // 查看更多新品
  onViewMoreNew() {
    wx.switchTab({
      url: '/pages/product/list/list',
    });
  },
});
