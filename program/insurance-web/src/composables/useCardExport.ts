/**
 * 卡片导出组合式函数
 * 负责卡片DOM组装、html2canvas渲染和下载
 */

import { ref } from 'vue'
import html2canvas from 'html2canvas'
import { generateWatermarkSvg, type WatermarkOptions } from '@/utils/watermark'

export interface CardContent {
  /** 主标题 */
  title: string
  /** 副标题 */
  subtitle: string
  /** 背景图URL */
  backgroundImage: string
  /** 水印配置（null表示无水印） */
  watermark?: WatermarkOptions | null
  /** 产品信息数据 */
  productData?: Record<string, string | number>
  /** 是否显示Logo */
  showLogo?: boolean
  /** 是否显示二维码 */
  showQrCode?: boolean
  /** 二维码链接 */
  qrCodeUrl?: string
  /** 额外自定义字段 */
  customFields?: Record<string, string>
}

export interface ExportOptions {
  /** 输出宽度，默认1080 */
  width?: number
  /** 输出高度，默认1920（9:16竖版） */
  height?: number
  /** 渲染倍数，默认2（2倍高清） */
  scale?: number
  /** 输出文件名 */
  filename?: string
}

export function useCardExport() {
  const isExporting = ref(false)
  const exportProgress = ref(0)

  /**
   * 组装卡片DOM元素
   * 返回一个离屏的DOM节点，可直接用于html2canvas
   */
  function assembleCardDom(content: CardContent): HTMLDivElement {
    const {
      title,
      subtitle,
      backgroundImage,
      watermark = null,
      productData = {},
      showLogo = true,
      showQrCode = false,
      qrCodeUrl = '',
      customFields = {}
    } = content

    const container = document.createElement('div')
    container.style.width = '1080px'
    container.style.height = '1920px'
    container.style.position = 'relative'
    container.style.overflow = 'hidden'
    container.style.fontFamily = '"PingFang SC", "Microsoft YaHei", sans-serif'
    container.style.color = '#ffffff'
    container.style.background = '#1a1a2e'

    // 背景层
    const bgLayer = document.createElement('div')
    bgLayer.style.position = 'absolute'
    bgLayer.style.inset = '0'
    bgLayer.style.backgroundImage = `url("${backgroundImage}")`
    bgLayer.style.backgroundSize = 'cover'
    bgLayer.style.backgroundPosition = 'center'
    container.appendChild(bgLayer)

    // 遮罩层（增强文字可读性）
    const overlay = document.createElement('div')
    overlay.style.position = 'absolute'
    overlay.style.inset = '0'
    overlay.style.background = 'linear-gradient(180deg, rgba(0,0,0,0.2) 0%, rgba(0,0,0,0.6) 100%)'
    container.appendChild(overlay)

    // 水印层
    if (watermark) {
      const watermarkLayer = document.createElement('div')
      watermarkLayer.style.position = 'absolute'
      watermarkLayer.style.inset = '0'
      watermarkLayer.style.pointerEvents = 'none'
      watermarkLayer.style.zIndex = '10'
      watermarkLayer.style.backgroundImage = `url("${generateWatermarkSvg(watermark)}")`
      watermarkLayer.style.backgroundRepeat = 'repeat'
      watermarkLayer.style.backgroundSize = 'cover'
      container.appendChild(watermarkLayer)
    }

    // 内容层
    const contentLayer = document.createElement('div')
    contentLayer.style.position = 'relative'
    contentLayer.style.zIndex = '5'
    contentLayer.style.display = 'flex'
    contentLayer.style.flexDirection = 'column'
    contentLayer.style.justifyContent = 'space-between'
    contentLayer.style.height = '100%'
    contentLayer.style.padding = '80px 60px'
    contentLayer.style.boxSizing = 'border-box'

    // 顶部：Logo区域
    if (showLogo) {
      const header = document.createElement('div')
      header.style.display = 'flex'
      header.style.alignItems = 'center'
      header.style.gap = '16px'

      const logoText = document.createElement('div')
      logoText.style.fontSize = '36px'
      logoText.style.fontWeight = '700'
      logoText.style.letterSpacing = '4px'
      logoText.textContent = '保险优选'

      const tagline = document.createElement('div')
      tagline.style.fontSize = '20px'
      tagline.style.opacity = '0.8'
      tagline.style.borderLeft = '2px solid rgba(255,255,255,0.5)'
      tagline.style.paddingLeft = '16px'
      tagline.textContent = '专业保险对比平台'

      header.appendChild(logoText)
      header.appendChild(tagline)
      contentLayer.appendChild(header)
    }

    // 中部：标题和产品信息
    const mainContent = document.createElement('div')
    mainContent.style.flex = '1'
    mainContent.style.display = 'flex'
    mainContent.style.flexDirection = 'column'
    mainContent.style.justifyContent = 'center'
    mainContent.style.gap = '40px'

    // 标题区域
    const titleArea = document.createElement('div')
    titleArea.style.textAlign = 'center'

    const mainTitle = document.createElement('h1')
    mainTitle.style.fontSize = '72px'
    mainTitle.style.fontWeight = '800'
    mainTitle.style.margin = '0 0 24px 0'
    mainTitle.style.lineHeight = '1.2'
    mainTitle.style.textShadow = '0 4px 20px rgba(0,0,0,0.3)'
    mainTitle.textContent = title

    const subTitle = document.createElement('p')
    subTitle.style.fontSize = '36px'
    subTitle.style.margin = '0'
    subTitle.style.opacity = '0.9'
    subTitle.style.textShadow = '0 2px 10px rgba(0,0,0,0.3)'
    subTitle.textContent = subtitle

    titleArea.appendChild(mainTitle)
    titleArea.appendChild(subTitle)
    mainContent.appendChild(titleArea)

    // 产品数据区域
    if (Object.keys(productData).length > 0) {
      const dataGrid = document.createElement('div')
      dataGrid.style.display = 'grid'
      dataGrid.style.gridTemplateColumns = 'repeat(2, 1fr)'
      dataGrid.style.gap = '24px'
      dataGrid.style.background = 'rgba(255,255,255,0.1)'
      dataGrid.style.backdropFilter = 'blur(10px)'
      dataGrid.style.borderRadius = '24px'
      dataGrid.style.padding = '40px'
      dataGrid.style.border = '1px solid rgba(255,255,255,0.15)'

      Object.entries(productData).forEach(([key, value]) => {
        const item = document.createElement('div')
        item.style.display = 'flex'
        item.style.flexDirection = 'column'
        item.style.gap = '8px'

        const label = document.createElement('span')
        label.style.fontSize = '24px'
        label.style.opacity = '0.7'
        label.textContent = key

        const val = document.createElement('span')
        val.style.fontSize = '36px'
        val.style.fontWeight = '700'
        val.textContent = String(value)

        item.appendChild(label)
        item.appendChild(val)
        dataGrid.appendChild(item)
      })

      mainContent.appendChild(dataGrid)
    }

    // 自定义字段区域
    if (Object.keys(customFields).length > 0) {
      const customArea = document.createElement('div')
      customArea.style.display = 'flex'
      customArea.style.flexDirection = 'column'
      customArea.style.gap = '16px'

      Object.entries(customFields).forEach(([key, value]) => {
        const row = document.createElement('div')
        row.style.display = 'flex'
        row.style.alignItems = 'center'
        row.style.gap = '16px'
        row.style.fontSize = '28px'

        const label = document.createElement('span')
        label.style.opacity = '0.7'
        label.style.minWidth = '120px'
        label.textContent = key + '：'

        const val = document.createElement('span')
        val.style.fontWeight = '600'
        val.textContent = value

        row.appendChild(label)
        row.appendChild(val)
        customArea.appendChild(row)
      })

      mainContent.appendChild(customArea)
    }

    contentLayer.appendChild(mainContent)

    // 底部：二维码区域
    const footer = document.createElement('div')
    footer.style.display = 'flex'
    footer.style.alignItems = 'center'
    footer.style.justifyContent = 'space-between'

    if (showQrCode && qrCodeUrl) {
      const qrArea = document.createElement('div')
      qrArea.style.display = 'flex'
      qrArea.style.alignItems = 'center'
      qrArea.style.gap = '20px'

      const qrImg = document.createElement('img')
      qrImg.src = qrCodeUrl
      qrImg.style.width = '140px'
      qrImg.style.height = '140px'
      qrImg.style.borderRadius = '12px'
      qrImg.style.background = '#ffffff'
      qrImg.style.padding = '8px'

      const qrText = document.createElement('div')
      qrText.style.display = 'flex'
      qrText.style.flexDirection = 'column'
      qrText.style.gap = '8px'

      const scanTip = document.createElement('span')
      scanTip.style.fontSize = '24px'
      scanTip.style.opacity = '0.8'
      scanTip.textContent = '扫码了解更多'

      const contact = document.createElement('span')
      contact.style.fontSize = '20px'
      contact.style.opacity = '0.6'
      contact.textContent = '专业顾问一对一服务'

      qrText.appendChild(scanTip)
      qrText.appendChild(contact)
      qrArea.appendChild(qrImg)
      qrArea.appendChild(qrText)
      footer.appendChild(qrArea)
    }

    const slogan = document.createElement('div')
    slogan.style.fontSize = '24px'
    slogan.style.opacity = '0.6'
    slogan.style.textAlign = 'right'
    slogan.textContent = '数据仅供参考，以保险公司条款为准'
    footer.appendChild(slogan)

    contentLayer.appendChild(footer)
    container.appendChild(contentLayer)

    return container
  }

  /**
   * 使用html2canvas生成图片
   */
  async function renderToImage(
    dom: HTMLElement,
    options: ExportOptions = {}
  ): Promise<HTMLCanvasElement> {
    const { scale = 2 } = options

    const canvas = await html2canvas(dom, {
      scale,
      useCORS: true,
      allowTaint: true,
      backgroundColor: null,
      logging: false,
      width: 1080,
      height: 1920,
      onclone: (clonedDoc) => {
        // 确保克隆文档中字体已加载
        const clonedContainer = clonedDoc.body.firstChild as HTMLElement
        if (clonedContainer) {
          clonedContainer.style.position = 'fixed'
          clonedContainer.style.left = '-9999px'
          clonedContainer.style.top = '-9999px'
        }
      }
    })

    return canvas
  }

  /**
   * 下载Canvas为PNG图片
   */
  function downloadCanvas(
    canvas: HTMLCanvasElement,
    filename = `保险卡片_${Date.now()}.png`
  ): void {
    const link = document.createElement('a')
    link.download = filename
    link.href = canvas.toDataURL('image/png', 1.0)
    link.click()
  }

  /**
   * 获取Canvas的DataURL
   */
  function getCanvasDataUrl(canvas: HTMLCanvasElement): string {
    return canvas.toDataURL('image/png', 1.0)
  }

  /**
   * 完整导出流程：组装DOM -> 渲染 -> 下载
   */
  async function exportCard(
    content: CardContent,
    options: ExportOptions = {}
  ): Promise<string> {
    isExporting.value = true
    exportProgress.value = 0

    try {
      // 1. 组装DOM
      exportProgress.value = 20
      const cardDom = assembleCardDom(content)

      // 临时挂载到body（html2canvas需要元素在DOM中）
      cardDom.style.position = 'fixed'
      cardDom.style.left = '-9999px'
      cardDom.style.top = '-9999px'
      document.body.appendChild(cardDom)

      // 等待图片加载
      exportProgress.value = 40
      await waitForImages(cardDom)

      // 2. 渲染
      exportProgress.value = 60
      const canvas = await renderToImage(cardDom, options)

      // 3. 下载或返回
      exportProgress.value = 80
      const filename = options.filename || `保险卡片_${Date.now()}.png`
      downloadCanvas(canvas, filename)

      exportProgress.value = 100
      return getCanvasDataUrl(canvas)
    } finally {
      // 清理临时DOM
      const tempElements = document.querySelectorAll('[data-card-export-temp]')
      tempElements.forEach((el) => el.remove())
      isExporting.value = false
    }
  }

  /**
   * 仅预览：组装DOM -> 渲染 -> 返回DataURL
   */
  async function previewCard(
    content: CardContent,
    options: ExportOptions = {}
  ): Promise<string> {
    const cardDom = assembleCardDom(content)
    cardDom.style.position = 'fixed'
    cardDom.style.left = '-9999px'
    cardDom.style.top = '-9999px'
    document.body.appendChild(cardDom)

    try {
      await waitForImages(cardDom)
      const canvas = await renderToImage(cardDom, { ...options, scale: 1 })
      return getCanvasDataUrl(canvas)
    } finally {
      cardDom.remove()
    }
  }

  /**
   * 等待DOM中所有图片加载完成
   */
  function waitForImages(container: HTMLElement): Promise<void> {
    const images = container.querySelectorAll('img')
    const promises = Array.from(images).map((img) => {
      return new Promise<void>((resolve) => {
        if (img.complete && img.naturalWidth > 0) {
          resolve()
          return
        }
        img.onload = () => resolve()
        img.onerror = () => resolve()
        // 超时处理
        setTimeout(() => resolve(), 3000)
      })
    })
    return Promise.all(promises).then(() => undefined)
  }

  return {
    isExporting,
    exportProgress,
    assembleCardDom,
    renderToImage,
    downloadCanvas,
    getCanvasDataUrl,
    exportCard,
    previewCard,
    waitForImages
  }
}
