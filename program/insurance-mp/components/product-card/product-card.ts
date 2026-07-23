import { Product } from '../../api/product';
import { formatAmountWithComma } from '../../utils/format';

// 产品卡片组件
Component({
  properties: {
    // 产品数据
    product: {
      type: Object as () => Product,
      value: {} as Product,
    },
    // 是否显示对比选择框
    showCompare: {
      type: Boolean,
      value: false,
    },
    // 是否已选中对比
    isCompared: {
      type: Boolean,
      value: false,
    },
    // 是否显示公司Logo
    showLogo: {
      type: Boolean,
      value: true,
    },
    // 卡片样式类型
    cardType: {
      type: String,
      value: 'default', // default / compact
    },
  },

  data: {
    formattedPrice: '',
    formattedCoverage: '',
  },

  lifetimes: {
    attached() {
      this.formatData();
    },
  },

  observers: {
    'product': function(product: Product) {
      if (product && product.id) {
        this.formatData();
      }
    },
  },

  methods: {
    // 格式化数据
    formatData() {
      const { product } = this.properties;
      if (!product || !product.id) return;

      this.setData({
        formattedPrice: formatAmountWithComma(product.price),
        formattedCoverage: formatAmountWithComma(product.coverage, 0),
      });
    },

    // 点击卡片
    onTapCard() {
      const { product } = this.properties;
      if (!product || !product.id) return;

      wx.navigateTo({
        url: `/pages/product/detail/detail?id=${product.id}`,
      });
    },

    // 点击对比选择框
    onTapCompare(e: WechatMiniprogram.TouchEvent) {
      e.stopPropagation();
      const { product, isCompared } = this.properties;
      this.triggerEvent('compareChange', {
        product,
        checked: !isCompared,
      });
    },

    // 点击标签
    onTapTag(e: WechatMiniprogram.TouchEvent) {
      e.stopPropagation();
      const { tag } = e.currentTarget.dataset;
      this.triggerEvent('tagTap', { tag });
    },
  },
});
