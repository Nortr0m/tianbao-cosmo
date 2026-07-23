/**
 * 水印工具函数
 * 生成蜂窝状平铺水印的SVG pattern
 */

export type WatermarkDensity = 'sparse' | 'medium' | 'dense'
export type WatermarkAngle = 30 | 45 | 60
export type WatermarkColor = 'black' | 'darkgray' | 'white'

export interface WatermarkOptions {
  /** 水印文字 */
  text: string
  /** 透明度 0.1-0.5 */
  opacity?: number
  /** 密度 */
  density?: WatermarkDensity
  /** 角度 */
  angle?: WatermarkAngle
  /** 字体大小 12-36px */
  fontSize?: number
  /** 颜色 */
  color?: WatermarkColor
}

const DENSITY_MAP: Record<WatermarkDensity, number> = {
  sparse: 6,
  medium: 4,
  dense: 3
}

const COLOR_MAP: Record<WatermarkColor, string> = {
  black: '#000000',
  darkgray: '#666666',
  white: '#ffffff'
}

/**
 * 生成蜂窝状平铺水印的SVG data URL
 *
 * 蜂窝状平铺算法：
 * - 横向间隔 = 1080 / 密度系数(稀疏=6, 适中=4, 密集=3)
 * - 纵向间隔 = 横向间隔 × 0.866
 * - 奇数行偏移半个间隔
 * - 整体旋转 -45 度
 */
export function generateWatermarkSvg(options: WatermarkOptions): string {
  const {
    text,
    opacity = 0.15,
    density = 'medium',
    angle = 45,
    fontSize = 16,
    color = 'darkgray'
  } = options

  const containerWidth = 1080
  const containerHeight = 1080
  const densityFactor = DENSITY_MAP[density]
  const horizontalGap = containerWidth / densityFactor
  const verticalGap = horizontalGap * 0.866

  const textElements: string[] = []
  const rows = Math.ceil(containerHeight / verticalGap) + 2
  const cols = Math.ceil(containerWidth / horizontalGap) + 2

  for (let row = 0; row < rows; row++) {
    const y = row * verticalGap + verticalGap / 2
    const offsetX = (row % 2 === 1) ? horizontalGap / 2 : 0

    for (let col = 0; col < cols; col++) {
      const x = col * horizontalGap + offsetX + horizontalGap / 2
      textElements.push(
        `<text x="${x}" y="${y}" text-anchor="middle" dominant-baseline="middle" ` +
        `font-size="${fontSize}px" fill="${COLOR_MAP[color]}" opacity="${opacity}">` +
        `${escapeXml(text)}</text>`
      )
    }
  }

  const svgContent =
    `<svg xmlns="http://www.w3.org/2000/svg" width="${containerWidth}" height="${containerHeight}">` +
    `<g transform="rotate(${-angle} ${containerWidth / 2} ${containerHeight / 2})">` +
    textElements.join('') +
    `</g></svg>`

  const base64 = btoa(unescape(encodeURIComponent(svgContent)))
  return `data:image/svg+xml;base64,${base64}`
}

/**
 * 生成CSS样式的水印背景
 * 返回可直接用于 background-image 的 CSS 属性值
 */
export function generateWatermarkStyle(options: WatermarkOptions): string {
  const dataUrl = generateWatermarkSvg(options)
  return `url("${dataUrl}")`
}

/**
 * 创建水印DOM元素并添加到指定容器
 */
export function applyWatermarkToElement(
  container: HTMLElement,
  options: WatermarkOptions
): HTMLDivElement {
  const watermarkDiv = document.createElement('div')
  watermarkDiv.style.position = 'absolute'
  watermarkDiv.style.top = '0'
  watermarkDiv.style.left = '0'
  watermarkDiv.style.width = '100%'
  watermarkDiv.style.height = '100%'
  watermarkDiv.style.pointerEvents = 'none'
  watermarkDiv.style.zIndex = '1000'
  watermarkDiv.style.backgroundImage = generateWatermarkStyle(options)
  watermarkDiv.style.backgroundRepeat = 'repeat'
  watermarkDiv.style.backgroundSize = 'cover'

  // 确保容器有相对定位
  const computedStyle = window.getComputedStyle(container)
  if (computedStyle.position === 'static') {
    container.style.position = 'relative'
  }

  container.appendChild(watermarkDiv)
  return watermarkDiv
}

/**
 * 移除水印元素
 */
export function removeWatermark(watermarkDiv: HTMLDivElement | null): void {
  if (watermarkDiv && watermarkDiv.parentNode) {
    watermarkDiv.parentNode.removeChild(watermarkDiv)
  }
}

function escapeXml(str: string): string {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;')
}
