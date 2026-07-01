package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.PremiumRate;
import org.apache.ibatis.annotations.Mapper;

/**
 * 重疾险费率 Mapper接口
 */
@Mapper
public interface PremiumRateMapper extends BaseMapper<PremiumRate> {
}
