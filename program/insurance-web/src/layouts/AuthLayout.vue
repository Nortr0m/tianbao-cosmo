<template>
  <div class="auth-layout">
    <div class="auth-container">
      <div class="auth-left">
        <div class="auth-brand">
          <img src="/logo.jpg" alt="天保星君" class="brand-logo" />
          <h1 class="brand-title">天保星君</h1>
          <p class="brand-slogan">智能保险产品对比 · 利益演示 · 卡片生成</p>
        </div>
        <div class="auth-features">
          <div class="feature-item">
            <el-icon size="24" color="#00ff88"><CircleCheck /></el-icon>
            <span>海量保险产品一键对比</span>
          </div>
          <div class="feature-item">
            <el-icon size="24" color="#00ff88"><CircleCheck /></el-icon>
            <span>精准利益演示与IRR计算</span>
          </div>
          <div class="feature-item">
            <el-icon size="24" color="#00ff88"><CircleCheck /></el-icon>
            <span>专业营销卡片快速生成</span>
          </div>
        </div>
      </div>
      <div class="auth-right">
        <div class="auth-box">
          <router-view />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { CircleCheck } from '@element-plus/icons-vue'
</script>

<style scoped>
.auth-layout {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-primary);
  background-image:
    linear-gradient(rgba(179, 71, 217, 0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(179, 71, 217, 0.03) 1px, transparent 1px);
  background-size: 40px 40px;
  padding: 24px;
  position: relative;
  overflow: hidden;
}

/* 装饰性霓虹光效 */
.auth-layout::before {
  content: '';
  position: absolute;
  top: -200px;
  left: -200px;
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(179, 71, 217, 0.15) 0%, transparent 70%);
  pointer-events: none;
}

.auth-layout::after {
  content: '';
  position: absolute;
  bottom: -200px;
  right: -200px;
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(0, 229, 255, 0.1) 0%, transparent 70%);
  pointer-events: none;
}

.auth-container {
  display: flex;
  width: 100%;
  max-width: 1000px;
  min-height: 600px;
  background: var(--bg-card);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: var(--shadow-card-hover), var(--shadow-neon-purple);
  border: 1px solid var(--border-color);
  position: relative;
  z-index: 1;
}

.auth-left {
  flex: 1;
  background: linear-gradient(135deg, rgba(179, 71, 217, 0.2) 0%, rgba(0, 229, 255, 0.1) 100%);
  color: var(--text-primary);
  padding: 60px 48px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

/* 科技线条装饰 */
.auth-left::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
    linear-gradient(rgba(0, 229, 255, 0.05) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0, 229, 255, 0.05) 1px, transparent 1px);
  background-size: 30px 30px;
  pointer-events: none;
}

.auth-brand {
  margin-bottom: 48px;
  position: relative;
}

.brand-logo {
  width: 72px;
  height: 72px;
  border-radius: 16px;
  object-fit: contain;
  box-shadow: var(--shadow-neon-purple);
  margin-bottom: 16px;
}

.brand-title {
  font-size: 32px;
  font-weight: 700;
  margin: 0 0 8px;
  background: var(--gradient-main);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-family: var(--font-family-display);
  letter-spacing: 3px;
}

.brand-slogan {
  font-size: 16px;
  color: var(--text-secondary);
}

.auth-features {
  display: flex;
  flex-direction: column;
  gap: 20px;
  position: relative;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 15px;
  color: var(--text-primary);
}

.auth-right {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48px;
}

.auth-box {
  width: 100%;
  max-width: 360px;
}

@media (max-width: 768px) {
  .auth-container {
    flex-direction: column;
  }

  .auth-left {
    padding: 32px 24px;
    min-height: 200px;
  }

  .auth-right {
    padding: 32px 24px;
  }
}
</style>
