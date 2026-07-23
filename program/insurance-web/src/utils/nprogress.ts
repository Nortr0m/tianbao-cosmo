/**
 * 轻量级路由进度条工具
 * 不依赖第三方库，使用自定义实现
 */

interface NProgressState {
  status: number | null
  timer: number | null
  trickleSpeed: number
}

const state: NProgressState = {
  status: null,
  timer: null,
  trickleSpeed: 200
}

function clamp(n: number, min: number, max: number): number {
  if (n < min) return min
  if (n > max) return max
  return n
}

function getBar(): HTMLElement | null {
  return document.querySelector('[role="nprogress-bar"]')
}

function setBarPosition(percent: number): void {
  const bar = getBar()
  if (!bar) return
  const offset = (percent * 100 - 100).toFixed(2)
  bar.style.transform = `translate3d(${offset}%, 0, 0)`
}

function createBar(): void {
  removeBar()
  const barEl = document.createElement('div')
  barEl.setAttribute('role', 'nprogress-bar')
  barEl.style.cssText = `
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 3px;
    z-index: 9999;
    background: linear-gradient(90deg, #409eff, #67c23a, #e6a23c, #f56c6c);
    transform: translate3d(-100%, 0, 0);
    transition: transform 0.2s ease-out;
    pointer-events: none;
    box-shadow: 0 0 10px rgba(64, 158, 255, 0.6);
  `
  document.body.appendChild(barEl)
}

function removeBar(): void {
  const bars = document.querySelectorAll('[role="nprogress-bar"]')
  bars.forEach(bar => {
    if (bar.parentNode) {
      bar.parentNode.removeChild(bar)
    }
  })
  if (state.timer) {
    clearTimeout(state.timer)
    state.timer = null
  }
}

function trickle(): void {
  if (state.status === null) return
  let amount: number
  const n = state.status
  if (n >= 0 && n < 0.2) amount = 0.1
  else if (n >= 0.2 && n < 0.5) amount = 0.04
  else if (n >= 0.5 && n < 0.8) amount = 0.02
  else if (n >= 0.8 && n < 0.99) amount = 0.005
  else amount = 0
  set(n + amount)
  scheduleTrickle()
}

function scheduleTrickle(): void {
  if (state.timer) clearTimeout(state.timer)
  state.timer = window.setTimeout(trickle, state.trickleSpeed)
}

function set(n: number): void {
  state.status = clamp(n, 0, 0.994)
  setBarPosition(state.status)
}

const NProgress = {
  /** 开始进度条 */
  start() {
    if (state.status !== null) return this
    state.status = 0
    createBar()
    scheduleTrickle()
    return this
  },

  /** 完成进度条 */
  done(force?: boolean) {
    if (state.status === null && !force) return this
    // 快速增长到接近100%
    if (state.status !== null) {
      set(0.8)
    }
    setTimeout(() => {
      if (state.status === null) return
      set(1)
      setBarPosition(1)
      setTimeout(() => {
        removeBar()
        state.status = null
      }, 300)
    }, 100)
    return this
  },

  /** 手动设置进度 (0-1) */
  set(n: number) {
    if (state.status === null) {
      createBar()
    }
    set(n)
    return this
  },

  /** 增加一点进度 */
  inc(amount?: number) {
    if (state.status === null) {
      this.start()
    } else if (typeof amount === 'number') {
      set(state.status + amount)
    } else {
      trickle()
    }
    return this
  }
}

export default NProgress
