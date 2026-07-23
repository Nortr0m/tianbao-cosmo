<template>
  <div class="system-settings-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>系统设置</span>
        </div>
      </template>

      <el-tabs v-model="activeTab">
        <el-tab-pane label="基础配置" name="basic">
          <el-form
            ref="basicFormRef"
            :model="basicForm"
            :rules="basicRules"
            label-width="140px"
            class="settings-form"
          >
            <el-row :gutter="24">
              <el-col :span="12">
                <el-form-item label="网站名称" prop="siteName">
                  <el-input v-model="basicForm.siteName" placeholder="请输入网站名称" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="网站标题" prop="siteTitle">
                  <el-input v-model="basicForm.siteTitle" placeholder="请输入网站标题" />
                </el-form-item>
              </el-col>
            </el-row>

            <el-row :gutter="24">
              <el-col :span="12">
                <el-form-item label="客服电话" prop="servicePhone">
                  <el-input v-model="basicForm.servicePhone" placeholder="请输入客服电话" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="客服邮箱" prop="serviceEmail">
                  <el-input v-model="basicForm.serviceEmail" placeholder="请输入客服邮箱" />
                </el-form-item>
              </el-col>
            </el-row>

            <el-row :gutter="24">
              <el-col :span="12">
                <el-form-item label="公司地址" prop="companyAddress">
                  <el-input v-model="basicForm.companyAddress" placeholder="请输入公司地址" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="ICP备案号" prop="icp">
                  <el-input v-model="basicForm.icp" placeholder="请输入ICP备案号" />
                </el-form-item>
              </el-col>
            </el-row>

            <el-form-item label="网站Logo" prop="logo">
              <el-upload
                class="logo-uploader"
                action="/api/admin/upload"
                :show-file-list="false"
                :on-success="handleLogoSuccess"
                :before-upload="beforeLogoUpload"
              >
                <img v-if="basicForm.logo" :src="basicForm.logo" class="logo-preview" />
                <el-icon v-else class="logo-uploader-icon"><Plus /></el-icon>
              </el-upload>
              <div class="upload-tip">建议尺寸 200x60px，支持 jpg/png 格式</div>
            </el-form-item>

            <el-form-item label="网站描述" prop="siteDescription">
              <el-input
                v-model="basicForm.siteDescription"
                type="textarea"
                :rows="3"
                placeholder="请输入网站描述，用于SEO"
              />
            </el-form-item>

            <el-form-item label="版权信息" prop="copyright">
              <el-input
                v-model="basicForm.copyright"
                type="textarea"
                :rows="2"
                placeholder="请输入版权信息"
              />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" :loading="saving" @click="handleSaveBasic">保存配置</el-button>
              <el-button @click="handleResetBasic">重置</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <el-tab-pane label="功能配置" name="feature">
          <el-form
            ref="featureFormRef"
            :model="featureForm"
            :rules="featureRules"
            label-width="180px"
            class="settings-form"
          >
            <el-form-item label="用户注册开关" prop="enableRegister">
              <el-switch v-model="featureForm.enableRegister" :active-value="1" :inactive-value="0" />
            </el-form-item>

            <el-form-item label="VIP功能开关" prop="enableVip">
              <el-switch v-model="featureForm.enableVip" :active-value="1" :inactive-value="0" />
            </el-form-item>

            <el-form-item label="兑换码功能开关" prop="enableRedeemCode">
              <el-switch v-model="featureForm.enableRedeemCode" :active-value="1" :inactive-value="0" />
            </el-form-item>

            <el-form-item label="每日免费生成次数" prop="dailyFreeQuota">
              <el-input-number v-model="featureForm.dailyFreeQuota" :min="0" :max="100" style="width: 200px" />
            </el-form-item>

            <el-form-item label="单次生成最大卡片数" prop="maxCardsPerGenerate">
              <el-input-number v-model="featureForm.maxCardsPerGenerate" :min="1" :max="50" style="width: 200px" />
            </el-form-item>

            <el-form-item label="客服工作时间" prop="serviceWorkTime">
              <el-input v-model="featureForm.serviceWorkTime" placeholder="如：周一至周五 9:00-18:00" style="width: 300px" />
            </el-form-item>

            <el-form-item label="自动清理日志天数" prop="logRetainDays">
              <el-input-number v-model="featureForm.logRetainDays" :min="7" :max="365" style="width: 200px" />
              <span class="form-tip">天</span>
            </el-form-item>

            <el-form-item>
              <el-button type="primary" :loading="saving" @click="handleSaveFeature">保存配置</el-button>
              <el-button @click="handleResetFeature">重置</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <el-tab-pane label="安全设置" name="security">
          <el-form
            ref="securityFormRef"
            :model="securityForm"
            :rules="securityRules"
            label-width="180px"
            class="settings-form"
          >
            <el-form-item label="登录失败锁定次数" prop="loginMaxFailures">
              <el-input-number v-model="securityForm.loginMaxFailures" :min="3" :max="10" style="width: 200px" />
              <span class="form-tip">次后锁定账号</span>
            </el-form-item>

            <el-form-item label="登录锁定时间" prop="loginLockDuration">
              <el-input-number v-model="securityForm.loginLockDuration" :min="5" :max="1440" style="width: 200px" />
              <span class="form-tip">分钟</span>
            </el-form-item>

            <el-form-item label="密码最小长度" prop="passwordMinLength">
              <el-input-number v-model="securityForm.passwordMinLength" :min="6" :max="20" style="width: 200px" />
            </el-form-item>

            <el-form-item label="密码复杂度要求" prop="passwordRequireComplex">
              <el-switch v-model="securityForm.passwordRequireComplex" :active-value="1" :inactive-value="0" />
              <span class="form-tip">要求包含字母、数字和特殊字符</span>
            </el-form-item>

            <el-form-item label="Token有效期" prop="tokenExpireHours">
              <el-input-number v-model="securityForm.tokenExpireHours" :min="1" :max="168" style="width: 200px" />
              <span class="form-tip">小时</span>
            </el-form-item>

            <el-form-item label="后台登录验证码" prop="enableCaptcha">
              <el-switch v-model="securityForm.enableCaptcha" :active-value="1" :inactive-value="0" />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" :loading="saving" @click="handleSaveSecurity">保存配置</el-button>
              <el-button @click="handleResetSecurity">重置</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import type { FormInstance, FormRules } from 'element-plus'
import { getSettings, saveBasicSettings, saveFeatureSettings, saveSecuritySettings } from '@/api/settings'
import type { BasicSettings, FeatureSettings, SecuritySettings } from '@/api/settings'

// 复用 api/settings.ts 中的类型定义

const activeTab = ref('basic')
const saving = ref(false)

const basicFormRef = ref<FormInstance>()
const featureFormRef = ref<FormInstance>()
const securityFormRef = ref<FormInstance>()

const basicForm = reactive<BasicSettings>({
  siteName: '',
  siteTitle: '',
  servicePhone: '',
  serviceEmail: '',
  companyAddress: '',
  icp: '',
  logo: '',
  siteDescription: '',
  copyright: ''
})

const basicRules: FormRules = {
  siteName: [{ required: true, message: '请输入网站名称', trigger: 'blur' }],
  siteTitle: [{ required: true, message: '请输入网站标题', trigger: 'blur' }],
  servicePhone: [
    { required: true, message: '请输入客服电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$|^0\d{2,3}-?\d{7,8}$/, message: '请输入正确的电话号码', trigger: 'blur' }
  ],
  serviceEmail: [
    { required: true, message: '请输入客服邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ]
}

const featureForm = reactive<FeatureSettings>({
  enableRegister: 1,
  enableVip: 1,
  enableRedeemCode: 1,
  dailyFreeQuota: 3,
  maxCardsPerGenerate: 10,
  serviceWorkTime: '周一至周五 9:00-18:00',
  logRetainDays: 30
})

const featureRules: FormRules = {
  dailyFreeQuota: [{ required: true, message: '请输入每日免费生成次数', trigger: 'blur' }],
  maxCardsPerGenerate: [{ required: true, message: '请输入单次生成最大卡片数', trigger: 'blur' }],
  logRetainDays: [{ required: true, message: '请输入日志保留天数', trigger: 'blur' }]
}

const securityForm = reactive<SecuritySettings>({
  loginMaxFailures: 5,
  loginLockDuration: 30,
  passwordMinLength: 8,
  passwordRequireComplex: 1,
  tokenExpireHours: 24,
  enableCaptcha: 1
})

const securityRules: FormRules = {
  loginMaxFailures: [{ required: true, message: '请输入登录失败锁定次数', trigger: 'blur' }],
  loginLockDuration: [{ required: true, message: '请输入登录锁定时间', trigger: 'blur' }],
  passwordMinLength: [{ required: true, message: '请输入密码最小长度', trigger: 'blur' }],
  tokenExpireHours: [{ required: true, message: '请输入Token有效期', trigger: 'blur' }]
}

function handleLogoSuccess(res: any) {
  if (res.url) {
    basicForm.logo = res.url
    ElMessage.success('Logo上传成功')
  }
}

function beforeLogoUpload(file: File) {
  const isJpgOrPng = file.type === 'image/jpeg' || file.type === 'image/png'
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isJpgOrPng) {
    ElMessage.error('只支持 JPG/PNG 格式!')
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
  }
  return isJpgOrPng && isLt2M
}

async function handleSaveBasic() {
  if (!basicFormRef.value) return
  await basicFormRef.value.validate(async (valid) => {
    if (!valid) return
    saving.value = true
    try {
      await saveBasicSettings(basicForm)
      ElMessage.success('基础配置保存成功')
    } catch (e: any) {
      if (e?.message) ElMessage.error(e.message)
    } finally {
      saving.value = false
    }
  })
}

async function handleSaveFeature() {
  if (!featureFormRef.value) return
  await featureFormRef.value.validate(async (valid) => {
    if (!valid) return
    saving.value = true
    try {
      await saveFeatureSettings(featureForm)
      ElMessage.success('功能配置保存成功')
    } catch (e: any) {
      if (e?.message) ElMessage.error(e.message)
    } finally {
      saving.value = false
    }
  })
}

async function handleSaveSecurity() {
  if (!securityFormRef.value) return
  await securityFormRef.value.validate(async (valid) => {
    if (!valid) return
    saving.value = true
    try {
      await saveSecuritySettings(securityForm)
      ElMessage.success('安全设置保存成功')
    } catch (e: any) {
      if (e?.message) ElMessage.error(e.message)
    } finally {
      saving.value = false
    }
  })
}

function handleResetBasic() {
  basicFormRef.value?.resetFields()
}

function handleResetFeature() {
  featureFormRef.value?.resetFields()
}

function handleResetSecurity() {
  securityFormRef.value?.resetFields()
}

async function loadSettings() {
  try {
    const res = await getSettings()
    if (res.basic) Object.assign(basicForm, res.basic)
    if (res.feature) Object.assign(featureForm, res.feature)
    if (res.security) Object.assign(securityForm, res.security)
  } catch (e: any) {
    if (e?.message) ElMessage.error(e.message)
  }
}

onMounted(() => {
  loadSettings()
})
</script>

<style scoped>
.card-header {
  font-weight: 500;
}

.settings-form {
  max-width: 800px;
  padding-top: 16px;
}

.logo-uploader {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
  width: 200px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.logo-uploader:hover {
  border-color: var(--el-color-primary);
}

.logo-uploader-icon {
  font-size: 28px;
  color: #8c939d;
}

.logo-preview {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.upload-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
}

.form-tip {
  margin-left: 8px;
  color: #909399;
  font-size: 13px;
}
</style>
