package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.AnnuityRate;
import org.apache.ibatis.annotations.Mapper;

/**
 * 年金险费率 Mapper接口
 */
@Mapper
public interface AnnuityRateMapper extends BaseMapper<AnnuityRate> {
}
