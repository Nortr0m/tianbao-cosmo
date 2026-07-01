<template>
  <component :is="detailComponent" />
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useProduct } from '@/composables/useProduct'
import CriticalIllnessDetail from './CriticalIllnessDetail.vue'
import WholeLifeDetail from './WholeLifeDetail.vue'
import AnnuityDetail from './AnnuityDetail.vue'

const route = useRoute()
const { detail, fetchDetail } = useProduct()

const productId = Number(route.params.id)

onMounted(() => {
  fetchDetail(productId)
})

const detailComponent = computed(() => {
  const type = detail.value?.productType
  switch (type) {
    case 1:
      return CriticalIllnessDetail
    case 2:
      return WholeLifeDetail
    case 3:
      return AnnuityDetail
    default:
      return CriticalIllnessDetail
  }
})
</script>
