import { CardTemplate, CardCategory } from '../../../api/card';
import { getCardCategories, getCardTemplates, generateCard } from '../../../api/card';
import { hasWatermarkPermission, showPermissionTip } from '../../../utils/permission';

Page({
  data: {
    // 分类
    categories: [] as CardCategory[],
    activeCategory: '',
    // 搜索
    keyword: '',
    // 模板列表
    templates: [] as CardTemplate[],
    page: 1,
    pageSize: 12,
    hasMore: true,
    loading: false,
    // 预览
    previewTemplate: null as CardTemplate | null,
    // 水印配置
    watermarkEnabled: true,
    watermarkText: '天保星君',
    canRemoveWatermark: false,
    // 联系信息
    contactName: '',
    contactPhone: '',
    contactWechat: '',
    // 生成中
    generating: false,
  },

  onLoad(options: Record<string, string>) {
    const { productId } = options;
    if (productId) {
      // 如果有产品ID，可以预填充一些信息
    }

    // 检查水印权限
    const canRemoveWatermark = hasWatermarkPermission();
    this.setData({ canRemoveWatermark });

    // 加载分类和模板
    this.loadCategories();
    this.loadTemplates(true);
  },

  // 加载分类
  async loadCategories() {
    try {
      const categories = await getCardCategories().catch(() => this.getMockCategories());
      this.setData({ categories });
    } catch (error) {
      console.error('加载分类失败:', error);
    }
  },

  // 加载模板
  async loadTemplates(reset: boolean = false) {
    if (this.data.loading) return;

    const page = reset ? 1 : this.data.page;
    const { pageSize, activeCategory, keyword } = this.data;

    this.setData({ loading: true });

    try {
      const result = await getCardTemplates({
        categoryId: activeCategory || undefined,
        keyword: keyword || undefined,
        page,
        pageSize,
      }).catch(() => this.getMockTemplates(page, pageSize, activeCategory, keyword));

      const newTemplates = reset ? result.list : [...this.data.templates, ...result.list];

      this.setData({
        templates: newTemplates,
        page: page + 1,
        hasMore: result.hasMore,
        loading: false,
      });
    } catch (error) {
      console.error('加载模板失败:', error);
      this.setData({ loading: false });
    }
  },

  // 模拟分类数据
  getMockCategories(): CardCategory[] {
    return [
      { id: '', name: '全部', icon: 'apps-o', sort: 0 },
      { id: '1', name: '重疾险', icon: 'shield-o', sort: 1 },
      { id: '2', name: '增额寿', icon: 'gem-o', sort: 2 },
      { id: '3', name: '年金险', icon: 'gold-coin-o', sort: 3 },
      { id: '4', name: '医疗险', icon: 'medical-o', sort: 4 },
      { id: '5', name: '意外险', icon: 'warning-o', sort: 5 },
      { id: '6', name: '寿险', icon: 'user-o', sort: 6 },
      { id: '7', name: '养老', icon: 'home-o', sort: 7 },
      { id: '8', name: '少儿', icon: 'smile-o', sort: 8 },
      { id: '9', name: '财富', icon: 'chart-trending-o', sort: 9 },
      { id: '10', name: '节日', icon: 'gift-o', sort: 10 },
    ];
  },

  // 模拟模板数据
  getMockTemplates(
    page: number,
    pageSize: number,
    categoryId?: string,
    keyword?: string
  ): { list: CardTemplate[]; total: number; page: number; pageSize: number; hasMore: boolean } {
    const allTemplates: CardTemplate[] = [
      {
        id: '1',
        name: '经典商务蓝',
        categoryId: '1',
        categoryName: '重疾险',
        thumbnail: 'https://images.unsplash.com/photo-1557683316-973673baf926?w=400',
        backgroundUrl: 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800',
        type: 'basic',
        hotScore: 95,
        isHot: true,
        isNew: false,
        tags: ['商务', '经典'],
      },
      {
        id: '2',
        name: '温暖家庭风',
        categoryId: '1',
        categoryName: '重疾险',
        thumbnail: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=400',
        backgroundUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=800',
        type: 'basic',
        hotScore: 88,
        isHot: true,
        isNew: false,
        tags: ['温馨', '家庭'],
      },
      {
        id: '3',
        name: '高端金色',
        categoryId: '2',
        categoryName: '增额寿',
        thumbnail: 'https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?w=400',
        backgroundUrl: 'https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?w=800',
        type: 'premium',
        hotScore: 92,
        isHot: true,
        isNew: true,
        tags: ['高端', '金色'],
      },
      {
        id: '4',
        name: '清新自然绿',
        categoryId: '3',
        categoryName: '年金险',
        thumbnail: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=400',
        backgroundUrl: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=800',
        type: 'basic',
        hotScore: 85,
        isHot: false,
        isNew: true,
        tags: ['清新', '自然'],
      },
      {
        id: '5',
        name: '春节喜庆红',
        categoryId: '10',
        categoryName: '节日',
        thumbnail: 'https://images.unsplash.com/photo-1543255006-d6395b6f1171?w=400',
        backgroundUrl: 'https://images.unsplash.com/photo-1543255006-d6395b6f1171?w=800',
        type: 'holiday',
        hotScore: 90,
        isHot: true,
        isNew: true,
        tags: ['春节', '喜庆'],
      },
      {
        id: '6',
        name: '专业深蓝',
        categoryId: '1',
        categoryName: '重疾险',
        thumbnail: 'https://images.unsplash.com/photo-1557683311-eac922347aa1?w=400',
        backgroundUrl: 'https://images.unsplash.com/photo-1557683311-eac922347aa1?w=800',
        type: 'basic',
        hotScore: 87,
        isHot: false,
        isNew: false,
        tags: ['专业', '深蓝'],
      },
      {
        id: '7',
        name: '浪漫紫罗兰',
        categoryId: '5',
        categoryName: '意外险',
        thumbnail: 'https://images.unsplash.com/photo-1557682224-5b8590cd9ec5?w=400',
        backgroundUrl: 'https://images.unsplash.com/photo-1557682224-5b8590cd9ec5?w=800',
        type: 'premium',
        hotScore: 83,
        isHot: false,
        isNew: true,
        tags: ['浪漫', '紫色'],
      },
      {
        id: '8',
        name: '稳重灰色',
        categoryId: '2',
        categoryName: '增额寿',
        thumbnail: 'https://images.unsplash.com/photo-1557682260-96773eb01377?w=400',
        backgroundUrl: 'https://images.unsplash.com/photo-1557682260-96773eb01377?w=800',
        type: 'basic',
        hotScore: 80,
        isHot: false,
        isNew: false,
        tags: ['稳重', '灰色'],
      },
      {
        id: '9',
        name: '活力橙色',
        categoryId: '8',
        categoryName: '少儿',
        thumbnail: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=400',
        backgroundUrl: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=800',
        type: 'basic',
        hotScore: 78,
        isHot: false,
        isNew: true,
        tags: ['活力', '橙色'],
      },
    ];

    let filtered = allTemplates;

    if (categoryId) {
      filtered = filtered.filter((t) => t.categoryId === categoryId);
    }

    if (keyword) {
      filtered = filtered.filter((t) => t.name.includes(keyword) || t.tags.some((tag) => tag.includes(keyword)));
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

  // 分类切换
  onCategoryChange(e: WechatMiniprogram.TouchEvent) {
    const { id } = e.currentTarget.dataset;
    this.setData({ activeCategory: id });
    this.loadTemplates(true);
  },

  // 搜索
  onSearch(e: WechatMiniprogram.TouchEvent) {
    const { value } = e.detail;
    this.setData({ keyword: value });
    this.loadTemplates(true);
  },

  // 搜索取消
  onSearchCancel() {
    this.setData({ keyword: '' });
    this.loadTemplates(true);
  },

  // 选择模板
  onSelectTemplate(e: WechatMiniprogram.TouchEvent) {
    const { template } = e.currentTarget.dataset;
    this.setData({ previewTemplate: template });
  },

  // 切换水印
  onWatermarkChange(e: WechatMiniprogram.TouchEvent) {
    const { value } = e.detail;
    if (!value && !this.data.canRemoveWatermark) {
      showPermissionTip('去除水印');
      return;
    }
    this.setData({ watermarkEnabled: value });
  },

  // 水印文字变化
  onWatermarkTextChange(e: WechatMiniprogram.TouchEvent) {
    this.setData({ watermarkText: e.detail.value });
  },

  // 联系信息变化
  onContactNameChange(e: WechatMiniprogram.TouchEvent) {
    this.setData({ contactName: e.detail.value });
  },

  onContactPhoneChange(e: WechatMiniprogram.TouchEvent) {
    this.setData({ contactPhone: e.detail.value });
  },

  onContactWechatChange(e: WechatMiniprogram.TouchEvent) {
    this.setData({ contactWechat: e.detail.value });
  },

  // 生成卡片
  async onGenerate() {
    const { previewTemplate, watermarkEnabled, watermarkText, contactName, contactPhone, contactWechat } = this.data;

    if (!previewTemplate) {
      wx.showToast({
        title: '请先选择模板',
        icon: 'none',
      });
      return;
    }

    this.setData({ generating: true });

    try {
      const result = await generateCard({
        templateId: previewTemplate.id,
        watermark: watermarkEnabled,
        watermarkText: watermarkEnabled ? watermarkText : undefined,
        contactInfo: contactName || contactPhone || contactWechat
          ? {
              name: contactName,
              phone: contactPhone,
              wechat: contactWechat,
            }
          : undefined,
      }).catch(() => ({
        cardId: 'mock-' + Date.now(),
        imageUrl: previewTemplate.backgroundUrl,
        shareUrl: '',
        createTime: new Date().toISOString(),
      }));

      this.setData({ generating: false });

      // 预览并保存
      wx.previewImage({
        urls: [result.imageUrl],
        current: result.imageUrl,
        success: () => {
          wx.showModal({
            title: '生成成功',
            content: '是否保存到相册？',
            confirmText: '保存',
            success: (res) => {
              if (res.confirm) {
                this.saveImage(result.imageUrl);
              }
            },
          });
        },
      });
    } catch (error) {
      console.error('生成卡片失败:', error);
      this.setData({ generating: false });
      wx.showToast({
        title: '生成失败',
        icon: 'none',
      });
    }
  },

  // 保存图片到相册
  saveImage(url: string) {
    wx.downloadFile({
      url,
      success: (res) => {
        wx.saveImageToPhotosAlbum({
          filePath: res.tempFilePath,
          success: () => {
            wx.showToast({
              title: '保存成功',
              icon: 'success',
            });
          },
          fail: () => {
            wx.showToast({
              title: '保存失败',
              icon: 'none',
            });
          },
        });
      },
      fail: () => {
        wx.showToast({
          title: '下载失败',
          icon: 'none',
        });
      },
    });
  },

  // 加载更多
  onReachBottom() {
    if (this.data.hasMore && !this.data.loading) {
      this.loadTemplates(false);
    }
  },
});
