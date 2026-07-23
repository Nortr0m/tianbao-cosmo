import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'
import { mockApiPlugin } from './mock'

// ============================================================
// Vite 配置
// ============================================================
export default defineConfig(({ mode }) => {
  const isDev = mode === 'development'
  const isProd = mode === 'production'
  // 是否启用 Mock 数据（设为 false 则对接真实后端 API）
  const enableMock = true

  return {
    // 插件配置
    plugins: [
      vue(),
      AutoImport({
        resolvers: [ElementPlusResolver()],
        imports: ['vue', 'vue-router', 'pinia'],
        dts: 'src/auto-imports.d.ts'
      }),
      Components({
        resolvers: [ElementPlusResolver()],
        dts: 'src/components.d.ts'
      }),
      // Mock 中间件 - 仅在开发环境且 enableMock 为 true 时生效
      isDev && enableMock && mockApiPlugin()
    ].filter(Boolean),

    // 路径别名
    resolve: {
      alias: {
        '@': resolve(__dirname, 'src')
      }
    },

    // 开发服务器配置
    server: {
      port: 8001,
      // 启用预热，优化首屏加载速度
      warmup: {
        clientFiles: [
          './src/main.ts',
          './src/App.vue',
          './src/router/index.ts'
        ]
      },
      proxy: {
        '/api': {
          target: 'http://localhost:8080',
          changeOrigin: true
        }
      }
    },

    // 依赖预构建优化
    optimizeDeps: {
      // 预构建的依赖，避免首次加载时的瀑布请求
      include: [
        'vue',
        'vue-router',
        'pinia',
        'axios',
        'element-plus',
        'dayjs',
        'echarts',
        'three',
        'html2canvas'
      ],
      // 排除不需要预构建的依赖
      exclude: []
    },

    // 构建配置
    build: {
      target: 'es2015',
      outDir: 'dist',
      assetsDir: 'assets',
      // 生产环境关闭 sourcemap，减小包体积
      sourcemap: !isProd,
      // 启用 CSS 代码分割
      cssCodeSplit: true,
      // 启用 terser 压缩（需安装 terser），这里使用 esbuild 更快
      minify: 'esbuild',
      // 块大小警告限制（单位 KB）
      chunkSizeWarningLimit: 1000,
      // 构建时清空输出目录
      emptyOutDir: true,
      // Rollup 配置
      rollupOptions: {
        output: {
          // 入口文件命名
          entryFileNames: 'js/[name]-[hash].js',
          // 代码块命名
          chunkFileNames: 'js/[name]-[hash].js',
          // 静态资源命名
          assetFileNames: (chunkInfo) => {
            const info = chunkInfo.name?.split('.') || []
            const ext = info[info.length - 1]
            if (/\.(png|jpe?g|gif|svg|webp|ico)$/.test(chunkInfo.name || '')) {
              return 'img/[name]-[hash][extname]'
            }
            if (/\.(woff2?|eot|ttf|otf)$/.test(chunkInfo.name || '')) {
              return 'fonts/[name]-[hash][extname]'
            }
            return 'css/[name]-[hash][extname]'
          },
          // 手动代码分割 - 将大型依赖拆分为独立 chunk
          manualChunks: {
            // Vue 核心生态
            'vue-vendor': ['vue', 'vue-router', 'pinia'],
            // UI 组件库
            'element-plus': ['element-plus'],
            // 图表库（体积较大，单独拆分）
            'echarts': ['echarts'],
            // 3D 渲染库（体积很大，单独拆分）
            'three': ['three'],
            // 工具库
            'utils': ['axios', 'dayjs', 'html2canvas']
          }
        },
        // 外部化（不打包的依赖）
        external: []
      }
    },

    // 预渲染配置（可选，用于 SEO）
    // ssr: false,

    // 环境变量配置
    envDir: '.',
    envPrefix: 'VITE_'
  }
})
