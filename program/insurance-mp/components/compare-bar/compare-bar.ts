// 底部对比悬浮栏组件
Component({
  properties: {
    // 已选中的产品列表
    compareList: {
      type: Array as () => Array<{
        id: string;
        name: string;
        companyName: string;
        logo?: string;
      }>,
      value: [],
    },
    // 最大对比数量
    maxCount: {
      type: Number,
      value: 3,
    },
    // 是否显示
    visible: {
      type: Boolean,
      value: false,
    },
  },

  data: {
    count: 0,
    canCompare: false,
  },

  lifetimes: {
    attached() {
      this.updateStatus();
    },
  },

  observers: {
    'compareList': function() {
      this.updateStatus();
    },
  },

  methods: {
    // 更新状态
    updateStatus() {
      const { compareList } = this.properties;
      const count = compareList.length;
      this.setData({
        count,
        canCompare: count >= 2,
      });
    },

    // 删除对比项
    onRemoveItem(e: WechatMiniprogram.TouchEvent) {
      const { index } = e.currentTarget.dataset;
      this.triggerEvent('remove', { index });
    },

    // 清空对比
    onClear() {
      wx.showModal({
        title: '提示',
        content: '确定清空所有对比项吗？',
        success: (res) => {
          if (res.confirm) {
            this.triggerEvent('clear');
          }
        },
      });
    },

    // 开始对比
    onCompare() {
      const { canCompare, count } = this.data;
      if (!canCompare) {
        wx.showToast({
          title: `请至少选择2款产品`,
          icon: 'none',
        });
        return;
      }

      const { compareList } = this.properties;
      const ids = compareList.map((item) => item.id).join(',');
      wx.navigateTo({
        url: `/pages/compare/compare?ids=${ids}`,
      });
    },

    // 关闭对比栏
    onClose() {
      this.triggerEvent('close');
    },
  },
});
